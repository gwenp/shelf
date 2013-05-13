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
using Gdk;
using Cairo;

namespace Shelf.Items
{
	/**
	 * The main manager for dock tabs.
	 */
	public class TabManager : GLib.Object
	{
		private ArrayList<Tab> tabs;
		private Gee.Map<Tab, int> saved_tabs_positions;


		public int tab_icon_size = 48;
		public int tab_margin = 8;
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
			saved_tabs_positions = new HashMap<Tab, int> ();
			populate ();
		}
		
		~TabManager ()
		{
		}

		/**
		 * Populate the tab list with some dummy tabs.
		 */
		public void populate()
		{
			add_tab (new Tab(this, "data/icons/facebook.png"));
			add_tab (new Tab(this, "data/icons/mail.png"));
			add_tab (new Tab(this, "data/icons/twitter.png"));
			add_tab (new Tab(this, "data/icons/transmission.png"));
			add_tab (new Tab(this, "data/icons/rss.png"));
			add_tab (new Tab(this, "data/icons/googleplus.png"));
		}

		public void add_tab(Tab t)
		{
			tabs.add (t);
			saved_tabs_positions[t] = tabs.size - 1;
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

		public int get_tab_position (Tab t)
		{
			return saved_tabs_positions[t];
		}

		public void check_tab_mouse_collision(EventMotion event)
		{
			foreach (Tab t in tabs) {
				t.hovered = t.is_mouse_inside_tab (event);
			}
		}
	}
}
