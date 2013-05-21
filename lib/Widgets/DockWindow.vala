//
//  Copyright (C) 2011-2012 Robert Dyer, Michal Hruby, Rico Tzschichholz
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

using Cairo;
using Gdk;
using Gee;
using Gtk;

using Shelf.Factories;
using Shelf.Drawing;
using Shelf.System;
using Shelf.Items;

namespace Shelf.Widgets
{
	public enum Struts
	{
		LEFT,
		RIGHT,
		TOP,
		BOTTOM,
		LEFT_START,
		LEFT_END,
		RIGHT_START,
		RIGHT_END,
		TOP_START,
		TOP_END,
		BOTTOM_START,
		BOTTOM_END,
		N_VALUES
	}
	
	/**
	 * The main window for all docks.
	 */
	public class DockWindow : CompositedWindow
	{

		uint reposition_timer = 0;

		bool dock_is_starting = true;

		Cairo.RectangleInt input_rect;

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		/**
		 * The currently hovered item (if any).
		 */
		public Tab? HoveredTab { get; protected set; }

		/**
		 * Creates a new dock window.
		 */
		public DockWindow (DockController controller)
		{
			GLib.Object (controller: controller, type: Gtk.WindowType.TOPLEVEL, type_hint: WindowTypeHint.DOCK);
		}
		
		construct
		{
			accept_focus = false;
			can_focus = false;
			skip_pager_hint = true;
			skip_taskbar_hint = true;
			
			stick ();
			
			add_events (EventMask.BUTTON_PRESS_MASK |
						EventMask.BUTTON_RELEASE_MASK |
						EventMask.ENTER_NOTIFY_MASK |
						EventMask.LEAVE_NOTIFY_MASK |
						EventMask.POINTER_MOTION_MASK |
						EventMask.SCROLL_MASK);
		}
		
		~DockWindow ()
		{
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool button_press_event (EventButton event)
		{
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool button_release_event (EventButton event)
		{

			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool enter_notify_event (EventCrossing event)
		{
			
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool leave_notify_event (EventCrossing event)
		{
			
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool motion_notify_event (EventMotion event)
		{
			controller.tab_manager.check_tab_mouse_collision(event);
			queue_draw();
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool scroll_event (EventScroll event)
		{
			
			return true;
		}

		/**
		 * {@inheritDoc}
		 */
		public override bool draw (Context cr)
		{
			if (dock_is_starting) {
				debug ("dock window loaded");
				dock_is_starting = false;
				
				// slide the dock in, if it shouldnt start hidden
				GLib.Timeout.add (400, () => {
					controller.hide_manager.update_dock_hovered ();
					return false;
				});
			}

			set_input_mask ();
			controller.renderer.draw (cr);
			return true;
		}
	
		/**
		 * Sets the currently hovered item for this dock.
		 *
		 * @param item the hovered item (if any) for this dock
		 */
		protected void set_hovered (Tab? tab)
		{
			if (HoveredTab == tab)
				return;
			
			HoveredTab = tab;
			
			// if (HoveredTab == null || controller.drag_manager.InternalDragActive) {
				// controller.hover.hide ();
				return;
			// }
			
			// if (hover_reposition_timer > 0)
				// return;
			
			// hover_reposition_timer = GLib.Timeout.add (1000 / 60, () => {
				// hover_reposition_timer = 0;
				
				// unowned HoverWindow hover = controller.hover;
				// if (hover.get_visible ())
					// hover.hide ();
				
				// if (HoveredTab == null)
					// return false;
				
				// hover.Text = HoveredTab.Text;
				// position_hover ();
				
				// if (!menu_is_visible () && !hover.get_visible ())
					// hover.show ();
				
				// return false;
			// });
		}
		
		public void update_size_and_position()
		{
			unowned DockPositionManager position_manager = controller.position_manager;
			position_manager.update_dock_position ();
			
			var x = position_manager.win_x;
			var y = position_manager.win_y;
			
			var width = position_manager.win_width;
			var height = position_manager.win_height;
			
			int width_current, height_current;
			get_size_request (out width_current, out height_current);
			var needs_resize = (width != width_current || height != height_current);
			
			var needs_reposition = true;
			if (get_realized ()) {
				int x_current, y_current;
				get_position (out x_current, out y_current);
				needs_reposition = (x != x_current || y != y_current);
			}
			
			if (needs_resize) {
				Logger.verbose ("DockWindow.set_size_request (width = %i, height = %i)", width, height);
				set_size_request (width, height);
				// controller.renderer.reset_buffers ();
				
				if (!needs_reposition) {
					// update_icon_regions ();
					set_struts ();
					set_hovered (null);
				}
			}
			
			if (needs_reposition) {
				if (dock_is_starting) {
					position (x, y);
				} else {
					schedule_position ();
				}
			}
		}

		void schedule_position ()
		{
			if (reposition_timer != 0) {
				GLib.Source.remove (reposition_timer);
				reposition_timer = 0;
			}
			
			reposition_timer = GLib.Timeout.add (50, () => {
				reposition_timer = 0;
				
				unowned DockPositionManager position_manager = controller.position_manager;
				position_manager.update_dock_position ();
				
				var x = position_manager.win_x;
				var y = position_manager.win_y;
				
				position (x, y);
				
				return false;
			});
		}
		
		void position (int x, int y)
		{
			Logger.verbose ("DockWindow.move (x = %i, y = %i)", x, y);
			move (x, y);
			
			// update_icon_regions ();
			set_struts ();
			set_hovered (null);
		}
		

		/**
		 * {@inheritDoc}
		 */
		public override bool map_event (EventAny event)
		{
			set_struts ();
			
			return base.map_event (event);
		}
		
		void set_input_mask ()
		{
			if (!get_realized ())
				return;
			
			var cursor = controller.position_manager.get_cursor_region ();
			// FIXME bug 768722 - this fixes the crash, but not WHY this happens
			return_if_fail (cursor.width > 0);
			return_if_fail (cursor.height > 0);
			
			RectangleInt rect = {cursor.x, cursor.y, cursor.width, cursor.height};
			if (rect != input_rect) {
				input_rect = rect;
				get_window ().input_shape_combine_region (new Region.rectangle (rect), 0, 0);
			}
		}


		void set_struts ()
		{
			if (!get_realized ())
				return;
			
			var struts = new ulong [Struts.N_VALUES];
			
			// if (controller.prefs.HideMode == HideType.NONE)
			// controller.position_manager.get_struts (ref struts);
			
			var first_struts = new ulong [Struts.BOTTOM + 1];
			for (var i = 0; i < first_struts.length; i++)
				first_struts [i] = struts [i];
			
			unowned X.Display display = X11Display.get_xdisplay (get_display ());
			var xid = X11Window.get_xid (get_window ());
			
			Gdk.error_trap_push ();
			display.change_property (xid, display.intern_atom ("_NET_WM_STRUT_PARTIAL", false), X.XA_CARDINAL,
			                      32, X.PropMode.Replace, (uchar[]) struts, struts.length);
			display.change_property (xid, display.intern_atom ("_NET_WM_STRUT", false), X.XA_CARDINAL,
			                      32, X.PropMode.Replace, (uchar[]) first_struts, first_struts.length);
			Gdk.error_trap_pop ();
		}
	}
}
