//
//  Copyright (C) 2011-2012 Robert Dyer, Rico Tzschichholz
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

using Gdk;
using Wnck;

using Shelf.Services.Windows;
using Shelf.Widgets;

namespace Shelf.System
{
	/**
	 * If/How the dock should hide itself.
	 */
	public enum HideType
	{
		/**
		 * The dock does not hide.  It should set struts to reserve space for it.
		 */
		NONE,
		/**
		 * The dock hides if a window in the active window group overlaps it.
		 */
		INTELLIGENT,
		/**
		 * The dock hides if the mouse is not over it.
		 */
		AUTO
	}
	
	/**
	 * Class to handle checking if a dock should hide or not.
	 */
	public class HideManager : GLib.Object
	{
		// a delay between window changes and updating our data
		// this allows window animations to occur, which might change
		// the results of our update
		const uint UPDATE_TIMEOUT = 200;
		
		public DockController controller { private get; construct; }
		
		/**
		 * If hiding the dock is currently disabled
		 */
		public bool Disabled { get; set; default = false; }
		
		/**
		 * If the dock is currently hovered by the mouse cursor.
		 */
		public bool DockHovered { get; set; default = false; }
		
		uint timer_unhide = 0;
		bool pointer_update = true;
		
		/**
		 * Creates a new instance of a HideManager, which handles
		 * checking if a dock should hide or not.
		 *
		 * @param controller the {@link DockController} to manage hiding for
		 */
		public HideManager (DockController controller)
		{
			GLib.Object (controller : controller);
		}
		
		construct
		{
			windows_intersect = false;
			hide ();
			
			notify["Disabled"].connect (update_hidden);
			notify["DockHovered"].connect (update_hidden);
			// controller.prefs.changed.connect (prefs_changed);
		}
		
		/**
		 * Initializes the hide manager.  Call after the DockWindow is constructed.
		 */
		public void initialize ()
			requires (controller.window != null)
		{
			controller.window.enter_notify_event.connect (enter_notify_event);
			controller.window.leave_notify_event.connect (leave_notify_event);
			controller.window.motion_notify_event.connect (motion_notify_event);
						
			Matcher.get_default ().window_opened.connect (schedule_update);
			Matcher.get_default ().window_closed.connect (schedule_update);
			
			Wnck.Screen.get_default ().active_window_changed.connect (handle_window_changed);
			Wnck.Screen.get_default ().active_workspace_changed.connect (handle_workspace_changed);
			
			setup_active_window ();
		}
		
		~HideManager ()
		{
			notify["Disabled"].disconnect (update_hidden);
			notify["DockHovered"].disconnect (update_hidden);
			// controller.prefs.changed.disconnect (prefs_changed);
			
			controller.window.enter_notify_event.disconnect (enter_notify_event);
			controller.window.leave_notify_event.disconnect (leave_notify_event);
			controller.window.motion_notify_event.disconnect (motion_notify_event);
						
			Matcher.get_default ().window_opened.disconnect (schedule_update);
			Matcher.get_default ().window_closed.disconnect (schedule_update);
			
			Wnck.Screen.get_default ().active_window_changed.disconnect (handle_window_changed);
			Wnck.Screen.get_default ().active_workspace_changed.disconnect (handle_workspace_changed);
			
			stop_timers ();
		}
		
		/**
		 * Checks to see if the dock is being hovered by the mouse cursor.
		 */
		public void update_dock_hovered ()
		{
			unowned DockPositionManager position_manager = controller.position_manager;
			unowned DockWindow window = controller.window;
			// unowned DragManager drag_manager = controller.drag_manager;
			
			// get current mouse pointer location
			int x, y;
			
			window.get_display ().
				get_device_manager ().get_client_pointer ().get_position (null, out x, out y);
			
			// get window location
			var win_x = position_manager.win_x;
			var win_y = position_manager.win_y;
			
			// compute rect of the window
			var dock_rect = position_manager.get_cursor_region ();
			dock_rect.x += win_x;
			dock_rect.y += win_y;
			
			// use the dock rect and cursor location to determine if dock is hovered
			var hovered = (x >= dock_rect.x && x <= dock_rect.x + dock_rect.width
				&& y >= dock_rect.y && y <= dock_rect.y + dock_rect.height);
			if (DockHovered != hovered)
				DockHovered = hovered;
			
			// disable hiding if drags are active
			// var disabled = (drag_manager.InternalDragActive || drag_manager.ExternalDragActive);
			// if (Disabled != disabled)
			// 	Disabled = disabled;
		}
		
		uint timer_prefs_changed = 0;
		
		void update_hidden ()
		{
			if (Disabled) {
				controller.renderer.show ();
				return;
			}
			
			switch (controller.prefs.HideMode) {
			default:
			case HideType.NONE:
				show ();
				break;
			
			case HideType.INTELLIGENT:
				if (DockHovered || !windows_intersect)
					show ();
				else
					hide ();
				break;
			
			case HideType.AUTO:
				if (DockHovered)
					show ();
				else
					hide ();
				break;
			}
			pointer_update = true;
		}
		
		void hide ()
		{
			if (timer_unhide > 0) {
				GLib.Source.remove (timer_unhide);
				timer_unhide = 0;
			}
			controller.renderer.hide ();
		}

		void show ()
		{
			if (!pointer_update || controller.prefs.UnhideDelay == 0) {
				controller.renderer.show ();
				return;
			}
			
			if (timer_unhide > 0)
				return;
			timer_unhide = GLib.Timeout.add (controller.prefs.UnhideDelay, () => {
				controller.renderer.show ();
				timer_unhide = 0;
				return false;
			});
		}
		
		bool enter_notify_event (EventCrossing event)
		{
			if ((bool) event.send_event)
				DockHovered = true;
			else
				update_dock_hovered ();
			
			return controller.renderer.Hidden;
		}
		
		bool leave_notify_event (EventCrossing event)
		{
			// ignore this event if it was sent explicitly
			if ((bool) event.send_event)
				return false;
			
			if (DockHovered /*&& !controller.window.menu_is_visible ()*/)
				DockHovered = false;
			
			return false;
		}
		
		bool motion_notify_event (EventMotion event)
		{
			update_dock_hovered ();
			
			return controller.renderer.Hidden;
		}
		
		//
		// intelligent hiding code
		//
		
		bool windows_intersect;
		Gdk.Rectangle last_window_rect;
		
		uint timer_geo;
		uint timer_window_changed;
		
		void update_window_intersect ()
		{
			var dock_rect = controller.position_manager.get_static_dock_region ();
			
			//TODO static fix :/
			dock_rect.x = 0;
			dock_rect.y = 0;
			dock_rect.width = 200;
			dock_rect.height = 1000;

			var intersect = false;
			var screen = Wnck.Screen.get_default ();
			var active_window = screen.get_active_window ();
			var active_workspace = screen.get_active_workspace ();
			
			if (active_window != null && active_workspace != null)
				foreach (var w in screen.get_windows ()) {
					if (w.is_minimized ())
						continue;
					var type = w.get_window_type ();
					if (type == Wnck.WindowType.DESKTOP || type == Wnck.WindowType.DOCK
						|| type == Wnck.WindowType.MENU || type == Wnck.WindowType.SPLASHSCREEN)
						continue;
					if (!w.is_visible_on_workspace (active_workspace))
						continue;
					if (w.get_pid () != active_window.get_pid ())
						continue;
					
					if (window_geometry (w).intersect (dock_rect, null)) {
						intersect = true;
						break;
					}
				}
			
			if (windows_intersect != intersect)
				windows_intersect = intersect;
			
			pointer_update = false;

			update_hidden ();
		}
		
		void schedule_update ()
		{
			if (timer_window_changed > 0)
				return;
			
			timer_window_changed = GLib.Timeout.add (UPDATE_TIMEOUT, () => {
				update_window_intersect ();
				timer_window_changed = 0;
				return false;
			});
		}
		
		void handle_workspace_changed (Wnck.Workspace? previous)
		{
			schedule_update ();
		}
		
		void handle_window_changed (Wnck.Window? previous)
		{
			if (previous != null) {
				previous.geometry_changed.disconnect (handle_geometry_changed);
				previous.state_changed.disconnect (handle_state_changed);
			}
			
			setup_active_window ();
		}
		
		void setup_active_window ()
		{
			var active_window = Wnck.Screen.get_default ().get_active_window ();
			
			if (active_window != null) {
				last_window_rect = window_geometry (active_window);
				active_window.geometry_changed.connect (handle_geometry_changed);
				active_window.state_changed.connect (handle_state_changed);
			}
			
			schedule_update ();
		}
		
		void handle_state_changed (Wnck.WindowState changed_mask, Wnck.WindowState new_state)
		{
			if ((changed_mask & Wnck.WindowState.MINIMIZED) == 0)
				return;
			
			schedule_update ();
		}
		
		void handle_geometry_changed (Wnck.Window? w)
		{
			return_if_fail (w != null);
			
			var geo = window_geometry (w);
			if (geo == last_window_rect)
				return;
			
			last_window_rect = geo;
			
			if (timer_geo > 0)
				return;
			
			timer_geo = GLib.Timeout.add (UPDATE_TIMEOUT, () => {
				update_window_intersect ();
				timer_geo = 0;
				return false;
			});
		}
		
		Gdk.Rectangle window_geometry (Wnck.Window w)
		{
			var win_rect = Gdk.Rectangle ();
			w.get_geometry (out win_rect.x, out win_rect.y, out win_rect.width, out win_rect.height);
			return win_rect;
		}
		
		void stop_timers ()
		{
			if (timer_geo > 0) {
				GLib.Source.remove (timer_geo);
				timer_geo = 0;
			}
			
			if (timer_window_changed > 0) {
				GLib.Source.remove (timer_window_changed);
				timer_window_changed = 0;
			}
			
			if (timer_prefs_changed > 0) {
				GLib.Source.remove (timer_prefs_changed);
				timer_prefs_changed = 0;
			}
			
			if (timer_unhide > 0) {
				GLib.Source.remove (timer_unhide);
				timer_unhide = 0;
			}
		}
	}
}
