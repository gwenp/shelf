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

using Shelf.Drawing;

namespace Shelf.Items
{
	/**
	 * The main manager for dock items.
	 */
	public class Tab : GLib.Object
	{
		private TabRenderer tab_renderer;

		/**
		 * The tab manager.
		 */
		public TabManager tab_manager { private get; construct; }
		
		/**
		 * Creates a new item manager.
		 */
		public Tab (TabManager manager)
		{
			GLib.Object (tab_manager: manager);
		}

		construct
		{
			tab_renderer = new TabRenderer();
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
	}
}
