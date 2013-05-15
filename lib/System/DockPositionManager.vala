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
		 * The currently visible height of the dock.
		 */
		public int VisibleDockHeight { get; private set; }

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
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
		}
		
		~DockPositionManager ()
		{
		}

		public void initialize()
			requires (controller.window != null)
		{
			controller.window.move(0,30);
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
			win_width = 200;
			win_height = monitor_geo.height;
		}

		void update_monitor_geo ()
		{
			stdout.printf("update_monitor_geo");
			controller.window.get_screen ().get_monitor_geometry (Screen.get_default ().get_primary_monitor (), out monitor_geo);
			update_dimensions ();
			// update_dock_position ();
			// update_regions ();
			
			controller.window.update_size_and_position ();
		}

		public Gdk.Rectangle get_cursor_region ()
		{
			cursor_region.height = int.max (1, (int) ((1 - controller.renderer.get_hide_offset ()) * VisibleDockHeight));
			cursor_region.y = win_height - cursor_region.height;
			
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

	}
}
