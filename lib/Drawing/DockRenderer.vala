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

using Shelf.Drawing;
using Shelf.Items;
using Shelf.System;

namespace Shelf.Drawing
{

	/**
	 * The main renderer for the dock.
	 */
	public class DockRenderer : AnimatedRenderer
	{
		Gdk.Rectangle background_rect;

		DockSurface? main_buffer;
		DockSurface? background_buffer;
		DockSurface? shadow_buffer;

		bool screen_is_composited;

		DateTime last_hide = new DateTime.from_unix_utc (0);

		DateTime frame_time = new DateTime.from_unix_utc (0);

		public bool Hidden { get; private set; default = true; }

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		/**
		 * Creates a new dock window.
		 */
		public DockRenderer (DockController controller)
		{
			GLib.Object (controller: controller);
		}

		construct
		{
			notify["Hidden"].connect (hidden_changed);
		}
		
		~DockRenderer ()
		{
			// controller.prefs.notify.disconnect (prefs_changed);
			// theme.changed.disconnect (theme_changed);
			
			// controller.items.item_state_changed.disconnect (item_state_changed);
			// controller.items.item_position_changed.disconnect (item_position_changed);
			// controller.items.items_changed.disconnect (items_changed);
			
			// controller.window.get_screen ().composited_changed.disconnect (composited_changed);

			notify["Hidden"].disconnect (hidden_changed);
			
			// controller.prefs.notify["Position"].disconnect (dock_position_changed);
			// controller.prefs.notify["Theme"].disconnect (load_theme);
			controller.window.notify["HoveredItem"].disconnect (animated_draw);
		}
		
		public void initialize ()
			requires (controller.window != null)
		{
			set_widget (controller.window);
			
			unowned Screen screen = controller.window.get_screen ();
			screen_is_composited = screen.is_composited ();
			// screen.composited_changed.connect (composited_changed);
			
			if(screen_is_composited)
				stdout.printf("screen_is_composited ok\n");
			controller.position_manager.initialize();
			
			// controller.position_manager.reset_caches (theme);
			controller.position_manager.update_regions ();
			
			//TODO replace the hover management with something like that
			controller.window.notify["HoveredItem"].connect (animated_draw);
		}
		
		/**
		 * The dock should be shown.
		 */
		public void show ()
		{
			if (!Hidden)
				return;
			Hidden = false;
		}
		
		/**
		 * The dock should be hidden.
		 */
		public void hide ()
		{
			if (Hidden)
				return;
			Hidden = true;
		}

		/**
		 * {@inheritDoc}
		 */
		public bool draw (Context cr)
		{
			frame_time = new DateTime.now_utc ();

			// calculate drawing offset
			var x_offset = 0, y_offset = 0;
			
			unowned DockPositionManager position_manager = controller.position_manager;
			position_manager.get_dock_draw_position (out x_offset, out y_offset);

			draw_background(cr, x_offset, y_offset);
			controller.tab_manager.draw(cr, x_offset, y_offset);

			return true;
		}

		private void draw_background(Context cr, int x_offset, int y_offset)
		{
			unowned DockPositionManager position_manager = controller.position_manager;
			
			var width = position_manager.win_width;
			var height = position_manager.win_height;
			
			if (main_buffer == null) {
				main_buffer = new DockSurface.with_surface (width, height, cr.get_target ());
			}
			
			if (shadow_buffer == null) {
				shadow_buffer = new DockSurface.with_surface (width, height, cr.get_target ());
			}
			
			background_rect = controller.position_manager.get_background_region ();

			if (background_buffer == null || background_buffer.Width != width
				|| background_buffer.Height != height)
				background_buffer = create_background (width, height,
					0, main_buffer);
			
			cr.set_source_surface (background_buffer.Internal, x_offset, y_offset);

			// draw the dock on the window
			cr.set_operator (Operator.SOURCE);
			cr.set_source_surface (shadow_buffer.Internal, x_offset, y_offset);
			cr.paint ();
		}

		private DockSurface create_background (int width, int height, Gtk.PositionType position, DockSurface model)
		{
			var surface = new DockSurface.with_dock_surface (width, height, model);
			surface.clear ();
			
			DockSurface temp;
			temp = new DockSurface.with_dock_surface (height, width, surface);
			
			unowned Context cr = surface.Context;
			
			var x_offset = 0.0, y_offset = 0.0;
			
			cr.save ();
			cr.set_source_surface (temp.Internal, x_offset, y_offset);
			cr.paint ();
			cr.restore ();
			
			return surface;
		}

		private delegate void DrawMethod ();

		public double get_hide_offset ()
		{
			if (!screen_is_composited)
				return 0;
			
			var time = controller.theme.FadeOpacity == 1.0 ? controller.theme.HideTime : controller.theme.FadeTime;
			var diff = double.min (1, frame_time.difference (last_hide) / (double) (time * 1000));

			return Hidden ? diff : 1 - diff;
		}

		void hidden_changed ()
		{
			var now = new DateTime.now_utc ();
			var diff = now.difference (last_hide);
			
			if (diff < controller.theme.HideTime * 1000)
				last_hide = now.add_seconds ((diff - controller.theme.HideTime * 1000) / 1000000.0);
			else
				last_hide = now;
			
			if (!screen_is_composited) {
				controller.window.update_size_and_position ();
				return;
			}
			
			// controller.window.update_icon_regions ();
			
			animated_draw ();
		}

		/**
		 * {@inheritDoc}
		 */
		protected override bool animation_needed (DateTime render_time)
		{
			if (controller.theme.FadeOpacity == 1.0) {
				if (render_time.difference (last_hide) <= controller.theme.HideTime * 1000)
					return true;
			} else {
				if (render_time.difference (last_hide) <= controller.theme.FadeTime * 1000)
					return true;
			}
			
			foreach (var tab in controller.tab_manager.tabs) {
				if (render_time.difference (tab.LastClicked) <= controller.theme.ClickTime * 1000)
					return true;
				if (render_time.difference (tab.LastActive) <= controller.theme.ActiveTime * 1000)
					return true;
				if (render_time.difference (tab.LastUrgent) <= (get_hide_offset () == 1.0 ? controller.theme.GlowTime : controller.theme.UrgentBounceTime) * 1000)
					return true;
			}
				
			return false;
		}
	}
}
