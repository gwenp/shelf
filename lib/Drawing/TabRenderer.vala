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

namespace Shelf.Drawing
{
	/**
	 * The main manager for dock items.
	 */
	public class TabRenderer : GLib.Object
	{
		/**
		 * Creates a new tab renderer.
		 */
		public TabRenderer ()
		{
			GLib.Object ();
		}

		construct
		{
		}
		
		~TabRenderer ()
		{
		}

		/**
		 * Draws a tab.
		 */
		public void draw (Context cr, int position)
		{
			int icon_size = 48;
			int vertical_offset = icon_size * position;
			cr.save ();

			cr.move_to (0, vertical_offset);
			cr.rel_line_to (icon_size, 0);
			cr.rel_line_to (0, icon_size);
			cr.rel_line_to (-icon_size, 0);
			cr.close_path ();

			cr.stroke();
			cr.fill();

			cr.restore();
		}
	}
}
