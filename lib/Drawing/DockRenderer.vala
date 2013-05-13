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

namespace Shelf.Drawing
{

	/**
	 * The main renderer for the dock.
	 */
	public class DockRenderer : GLib.Object
	{
		DockSurface? main_buffer;
		DockSurface? background_buffer;


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
			// controller.renderer.draw_dock (cr);
			cr.set_source_rgb (0, 0, 0);

			cr.set_line_width (10 / 4);
			cr.set_tolerance (0.1);

			cr.set_line_join (LineJoin.ROUND);

			controller.tab_manager.draw(cr);
			return true;
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
