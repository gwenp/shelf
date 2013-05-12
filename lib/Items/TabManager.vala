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

using Gee;
using Cairo;

namespace Shelf.Items
{
	/**
	 * The main manager for dock tabs.
	 */
	public class TabManager : GLib.Object
	{
		ArrayList<Tab> tabs;

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		/**
		 * Creates a new item manager.
		 */
		public TabManager (DockController controller)
		{
			GLib.Object (controller: controller);
		}

		construct
		{
			tabs = new ArrayList<Tab> ();
			populate ();
		}
		
		~TabManager ()
		{
		}

		public void populate()
		{
			tabs.add (new Tab(this));
			tabs.add (new Tab(this));
			tabs.add (new Tab(this));
		}

		/**
		 * Draws the list of tabs.
		 */
		public void draw (Context cr)
		{
			int i = 0;
			foreach (Tab t in tabs) {
				t.draw (cr, i);
				i++;
			}
		}
	}
}
