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

using Shelf.Items;
using Shelf.System;

namespace Shelf.Drawing
{

	/**
	 * The main renderer for the dock.
	 */
	public class DockRenderer : GLib.Object
	{
		DockSurface? main_buffer;
		DockSurface? background_buffer;
		DockSurface? shadow_buffer;


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
		}
		
		~DockRenderer ()
		{
		}
		
		/**
		 * {@inheritDoc}
		 */
		public bool draw (Context cr)
		{
			draw_background(cr);
			controller.tab_manager.draw(cr);
			
			return true;
		}

		private void draw_background(Context cr)
		{
			unowned DockPositionManager position_manager = controller.position_manager;
			
			var x = position_manager.win_x;
			var y = position_manager.win_y;
			var width = position_manager.win_width;
			var height = position_manager.win_height;
			
			if (main_buffer == null) {
				main_buffer = new DockSurface.with_surface (width, height, cr.get_target ());
			}
			
			if (shadow_buffer == null) {
				shadow_buffer = new DockSurface.with_surface (width, height, cr.get_target ());
			}
			
			if (background_buffer == null || background_buffer.Width != width
				|| background_buffer.Height != height)
				background_buffer = create_background (width, height,
					0, main_buffer);
			
			cr.set_source_surface (background_buffer.Internal, x, y);
			// calculate drawing offset
			var x_offset = 0, y_offset = 0;
			
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

		private void stroke_shapes (Context ctx, int x, int y) {
			this.draw_shapes (ctx, x, y, ctx.stroke);
		}

		private void fill_shapes (Context ctx, int x, int y) {
			this.draw_shapes (ctx, x, y, ctx.fill);
		}

		private delegate void DrawMethod ();

		private void draw_shapes (Context ctx, int x, int y, DrawMethod draw_method) {

			ctx.save ();

			ctx.new_path ();
			ctx.translate (x + 10, y + 10);
			bowtie (ctx);
			draw_method ();

			ctx.new_path ();
			ctx.translate (3 * 10, 0);
			square (ctx);
			draw_method ();

			ctx.new_path ();
			ctx.translate (3 * 10, 0);
			triangle (ctx);
			draw_method ();

			ctx.new_path ();
			ctx.translate (3 * 10, 0);
			inf (ctx);
			draw_method ();

			ctx.restore();
		}

		private void triangle (Context ctx) {
			ctx.move_to (10, 0);
			ctx.rel_line_to (10, 2 * 10);
			ctx.rel_line_to (-2 * 10, 0);
			ctx.close_path ();
		}

		private void square (Context ctx) {
			ctx.move_to (0, 0);
			ctx.rel_line_to (2 * 10, 0);
			ctx.rel_line_to (0, 2 * 10);
			ctx.rel_line_to (-2 * 10, 0);
			ctx.close_path ();
		}

		private void bowtie (Context ctx) {
			ctx.move_to (0, 0);
			ctx.rel_line_to (2 * 10, 2 * 10);
			ctx.rel_line_to (-2 * 10, 0);
			ctx.rel_line_to (2 * 10, -2 * 10);
			ctx.close_path ();
		}

		private void inf (Context ctx) {
			ctx.move_to (0, 10);
			ctx.rel_curve_to (0, 10, 10, 10, 2 * 10, 0);
			ctx.rel_curve_to (10, -10, 2 * 10, -10, 2 * 10, 0);
			ctx.rel_curve_to (0, 10, -10, 10, -2 * 10, 0);
			ctx.rel_curve_to (-10, -10, -2 * 10, -10, -2 * 10, 0);
			ctx.close_path ();
		}
	}
}
