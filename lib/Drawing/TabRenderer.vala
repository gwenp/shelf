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

using Shelf.Items;
using Shelf.System;

namespace Shelf.Drawing
{
	/**
	 * The main manager for dock items.
	 */
	public class TabRenderer : GLib.Object
	{
		ImageSurface surface_icon;

		public Tab tab { private get; construct; }

		/**
		 * Creates a new tab renderer.
		 */
		public TabRenderer (Tab the_tab)
		{
			GLib.Object (tab: the_tab);
		}

		construct
		{
			surface_icon = new ImageSurface.from_png(tab.icon_path);
		}
		
		~TabRenderer ()
		{
		}

		/**
		 * Draws a tab.
		 */
		public void draw (Context cr, int position)
		{
			unowned Theme theme = tab.tab_manager.controller.theme_manager;
			unowned DockPreferences prefs = tab.tab_manager.controller.prefs;
			int icon_size = prefs.IconSize;
			int padding = theme.tab_padding;
			
			Pixbuf pixbuf = pixbuf_get_from_surface (surface_icon, 0, 0, icon_size, icon_size);
			Drawing.Color c = DrawingService.average_color(pixbuf);

			int vertical_offset = ( icon_size + padding * 3 ) * position;

			cr.set_operator (Operator.OVER);

			if(tab.hovered)
				cr.set_source_rgb (c.R + 0.1, c.G + 0.1, c.B + 0.1);
			else
				cr.set_source_rgb (c.R, c.G, c.B);

			cr.move_to (0, vertical_offset);
			cr.rel_line_to (icon_size, 0);
			cr.rel_curve_to (padding, 0, padding, padding, padding, padding);
			
			cr.rel_line_to (0, icon_size);

			cr.rel_line_to (- icon_size - padding, padding * 8);
			
			cr.fill();
			cr.stroke();

			vertical_offset = ( icon_size + padding * 3 ) * position;

			cr.set_source_surface(surface_icon, padding / 4, vertical_offset + padding / 2);

			cr.move_to (padding / 4, vertical_offset + padding / 2);
			cr.rel_line_to (icon_size, 0);
			cr.rel_line_to (0, icon_size);
			cr.rel_line_to (-icon_size, 0);
			cr.close_path ();

			cr.fill();
		}
	}
}
