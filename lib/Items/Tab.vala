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
using Cairo;

using Shelf.Drawing;
using Shelf.System;

namespace Shelf.Items
{
	/**
	 * The main manager for dock items.
	 */
	public class Tab : GLib.Object
	{
		public TabRenderer tab_renderer;
		public bool hovered;
		
		/**
		 * The tab manager.
		 */
		public TabManager tab_manager { public get; construct; }
		public string icon_path { public get; construct; }
		
		/**
		 * Creates a new item manager.
		 */
		public Tab (TabManager manager, string tab_icon_path)
		{
			GLib.Object (tab_manager: manager, icon_path: tab_icon_path);
		}

		construct
		{
			tab_renderer = new TabRenderer(this);
			hovered = false;
		}
		
		~Tab ()
		{
		}

		/**
		 * Draws a tab.
		 */
		public void draw (Context cr, int position)
		{
			tab_renderer.draw(cr, position);
		}

		public bool is_mouse_inside_tab(EventMotion event)
		{
			unowned Theme theme = tab_manager.controller.theme_manager;
			unowned DockPreferences prefs = tab_manager.controller.prefs;
			int icon_size = prefs.IconSize;
			int padding = theme.tab_padding;

			int tab_x = 0;
			int tab_y = (icon_size + padding * 3) * tab_manager.get_tab_position(this);
			int next_tab_y = (icon_size + padding * 3) * (tab_manager.get_tab_position(this) + 1);

			if(event.x < 48 + 12)
			{
				if(event.y < next_tab_y && event.y > tab_y)
				{
					return true;					
				}
			}

			return false;
		}
	}
}
