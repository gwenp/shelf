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

using Gdk;
using Gtk;

namespace Shelf.System
{
	/**
	 * The main position manager for the dock.
	 */
	public class DockPositionManager : GLib.Object
	{
		Gdk.Rectangle monitor_geo;
		Gdk.Rectangle static_dock_region;
		Gdk.Rectangle cursor_region;
		
		bool screen_is_composited;

		int extra_hide_offset;

		/**
		 * Cached x position of the dock window.
		 */
		public int win_x { get; protected set; }
		
		/**
		 * Cached y position of the dock window.
		 */
		public int win_y { get; protected set; }

		/**
		 * Cached width position of the dock window.
		 */
		public int win_width { get; protected set; }
		
		/**
		 * Cached height of the dock window.
		 */
		public int win_height { get; protected set; }

		/**
		 * The currently visible width of the dock.
		 */
		public int VisibleDockWidth { get; private set; }

		/**
		 * The currently visible height of the dock.
		 */
		public int VisibleDockHeight { get; private set; }

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		/**
		 * The height of the dock's background image.
		 */
		public int DockBackgroundHeight { get; private set; }

		/**
		 * The width of the dock's background image.
		 */
		public int DockBackgroundWidth { get; private set; }

		/**
		 * Creates a new position manager.
		 */
		public DockPositionManager (DockController controller)
		{
			GLib.Object (controller: controller);
		}

		construct
		{
			cursor_region = Gdk.Rectangle ();
			static_dock_region = Gdk.Rectangle ();
		}
		
		~DockPositionManager ()
		{
		}

		public void initialize()
			requires (controller.window != null)
		{
			// controller.window.move(0,300);
			unowned Screen screen = controller.window.get_screen ();
			
			screen.monitors_changed.connect (update_monitor_geo);
			screen.size_changed.connect (update_monitor_geo);
			
			// NOTE don't call update_monitor_geo to avoid a double-call of dockwindow.set_size on startup
			screen.get_monitor_geometry (Screen.get_default ().get_primary_monitor (), out monitor_geo); //TODO change Screen.get_default ().get_primary_monitor () and store it to the prefs
			
			screen_is_composited = screen.is_composited ();

			// NOTE I actually call it to make it work :/
			update_monitor_geo();
		}

		void update_dimensions ()
		{
			win_width = controller.prefs.IconSize + controller.theme.tab_padding;
			win_height = monitor_geo.height;
			VisibleDockWidth = win_width;
			VisibleDockHeight = win_height;

		}

		void update_monitor_geo ()
		{
			controller.window.get_screen ().get_monitor_geometry (Screen.get_default ().get_primary_monitor (), out monitor_geo);
			update_dimensions ();
			update_dock_position ();
			update_regions ();
			
			controller.window.update_size_and_position ();			
		}

		public Gdk.Rectangle get_cursor_region ()
		{
			cursor_region.width = int.max (1, (int) ((1 - controller.renderer.get_hide_offset ()) * VisibleDockWidth));
			cursor_region.x = 0;
			
			return cursor_region;
		}

		/**
		 * Returns the static dock region for the dock.
		 * This is the region that the dock occupies when not hidden.
		 *
		 * @return the static dock region for the dock
		 */
		public Gdk.Rectangle get_static_dock_region ()
		{
			var dock_region = static_dock_region;
			dock_region.x += win_width;
			dock_region.y += win_height;
			
			// Revert adjustments made by update_dock_position () for non-compositing mode
			if (!screen_is_composited && controller.renderer.Hidden) {
				dock_region.x += win_width - 1;
			}
			
			return dock_region;
		}

		/**
		 * Caches the x and y position of the dock window.
		 */
		public void update_dock_position ()
		{
			unowned DockPreferences prefs = controller.prefs;
			
			var xoffset = 0;
			var yoffset = 0;
			
			// if (!screen_is_composited) {
				var offset = prefs.Offset;
				xoffset = (int) ((1 + offset / 100.0) * (monitor_geo.width - win_width) / 2);
				// yoffset = (int) ((1 + offset / 100.0) * (monitor_geo.height - win_height) / 2);
				yoffset = (int) ((offset / 100.0) * (monitor_geo.height) / 2);
				
				// switch (prefs.Alignment) {
				// default:
				// case Align.CENTER:
				// case Align.FILL:
				// 	break;
				// case Align.START:
				// 	xoffset = 0;
				// 	yoffset = (monitor_geo.height - static_dock_region.height);
				// 	break;
				// case Align.END:
				// 	xoffset = (monitor_geo.width - static_dock_region.width);
				// 	yoffset = 0;
				// 	break;
				// }
			// }
			
			//TODO put this in a switch, dependant on dock position (a preference)
			win_y = monitor_geo.y + yoffset;
			win_x = monitor_geo.x;
			
			stdout.printf("win_y = %i %i %i\n", win_y, monitor_geo.height, yoffset);
			// Actually change the window position while hidden for non-compositing mode
			if (!screen_is_composited && controller.renderer.Hidden) {
				//TODO put this in a switch, dependant on dock position (a preference)
				win_x -= win_width - 1;	
			}
		}

		/**
		 * Get's the x and y position to display the main dock buffer.
		 *
		 * @param x the resulting x position
		 * @param y the resulting y position
		 */
		public void get_dock_draw_position (out int x, out int y)
		{
			if (!screen_is_composited) {
				x = 0;
				y = 0;
				return;
			}
			
			// switch (controller.prefs.Position) {
			// default:
			// case PositionType.BOTTOM:
			// 	x = 0;
			// 	y = (int) ((VisibleDockHeight + extra_hide_offset) * controller.renderer.get_hide_offset ());
			// 	break;
			// case PositionType.TOP:
			// 	x = 0;
			// 	y = (int) (- (VisibleDockHeight + extra_hide_offset) * controller.renderer.get_hide_offset ());
			// 	break;
			// case PositionType.LEFT:
				x = (int) (- (VisibleDockWidth + extra_hide_offset) * controller.renderer.get_hide_offset ());
				y = 0;
			// 	break;
			// case PositionType.RIGHT:
			// 	x = (int) ((VisibleDockWidth + extra_hide_offset) * controller.renderer.get_hide_offset ());
			// 	y = 0;
			// 	break;
			// }
		}

		/**
		 * Get's the region for background of the dock.
		 *
		 * @return the region for the dock background
		 */
		public Gdk.Rectangle get_background_region ()
		{
			var x = 0, y = 0;
			var width = 0, height = 0;
			
			if (screen_is_composited) {
				x = static_dock_region.x;
				y = static_dock_region.y;
				width = VisibleDockWidth;
				height = VisibleDockHeight;
			} else {
				width = win_width;
				height = win_height;
			}
			
				x = 0;
				y += (height - DockBackgroundHeight) / 2;
			
			return { x, y, DockBackgroundWidth, DockBackgroundHeight };
		}


		/**
		 * Call when any cached region needs updating.
		 */
		public void update_regions ()
		{
			unowned DockPreferences prefs = controller.prefs;
			
			Logger.verbose ("PositionManager.update_regions ()");
			
			var old_region = static_dock_region;
			
			// width of the items-area of the dock
			// items_width = controller.items.Items.size * (ItemPadding + IconSize);
			
			static_dock_region.width = VisibleDockWidth;
			static_dock_region.height = VisibleDockHeight;
			
			var xoffset = (win_width - static_dock_region.width) / 2;
			var yoffset = (win_height - static_dock_region.height) / 2;
			
			if (screen_is_composited) {
				var offset = prefs.Offset;
				xoffset = (int) ((1 + offset / 100.0) * xoffset);
				yoffset = (int) ((1 + offset / 100.0) * yoffset);
				
				//TODO manage alignment
			}
			
			// switch (prefs.Position) {
			// default:
			// case PositionType.BOTTOM:
			// 	static_dock_region.x = xoffset;
			// 	static_dock_region.y = win_height - static_dock_region.height;
				
			// 	cursor_region.x = static_dock_region.x;
			// 	cursor_region.width = static_dock_region.width;
			// 	break;
			// case PositionType.TOP:
			// 	static_dock_region.x = xoffset;
			// 	static_dock_region.y = 0;
				
			// 	cursor_region.x = static_dock_region.x;
			// 	cursor_region.width = static_dock_region.width;
			// 	break;
			// case PositionType.LEFT:
			static_dock_region.y = yoffset;
			static_dock_region.x = 0;
				
				cursor_region.y = static_dock_region.y;
				cursor_region.height = static_dock_region.height;
			// 	break;
			// case PositionType.RIGHT:
			// 	static_dock_region.y = yoffset;
			// 	static_dock_region.x = win_width - static_dock_region.width;
				
			// 	cursor_region.y = static_dock_region.y;
			// 	cursor_region.height = static_dock_region.height;
			// 	break;
			// }
			
			if (old_region.x != static_dock_region.x
				|| old_region.y != static_dock_region.y
				|| old_region.width != static_dock_region.width
				|| old_region.height != static_dock_region.height) {
				controller.window.update_size_and_position ();
				
				// With active compositing support update_size_and_position () won't trigger a redraw
				// (a changed static_dock_region doesn't implicate the window-size changed)
				if (screen_is_composited)
					controller.renderer.animated_draw ();
			} else {
				controller.renderer.animated_draw ();
			}
		}
	}
}
