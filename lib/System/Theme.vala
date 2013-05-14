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

namespace Shelf.System
{
	/**
	 * The main position manager for the dock.
	 */
	public class Theme : GLib.Object
	{
		/**
		 * Width and height of tab icons
		 */
		public int tab_icon_size { get; protected set; }
		
		/**
		 * padding between the icons and the tab border.
		 */
		public int tab_padding { get; protected set; }

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		/**
		 * Creates a new theme class, to store properties of the current theme.
		 */
		public Theme (DockController controller)
		{
			GLib.Object (controller: controller, tab_icon_size : 48, tab_padding: 8);
		}

		construct
		{
		}
		
		~Theme ()
		{
		}
	}
}
