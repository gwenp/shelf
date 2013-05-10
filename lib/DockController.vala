//
//  Copyright (C) 2011 Robert Dyer
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

using Shelf.Factories;
using Shelf.Widgets;

namespace Shelf
{
	/**
	 * A controller class for managing a single dock.
	 */
	public class DockController : GLib.Object
	{
		// public PositionManager position_manager;
		// public DockRenderer renderer;
		public DockWindow window;
		
		public DockController ()
		{
			// prefs = new DockPreferences.with_filename (Factories.AbstractMain.dock_path + "/settings");
			// items = new ApplicationDockItemProvider (this);
			// position_manager = new PositionManager (this);
			// renderer = new DockRenderer (this);
			// drag_manager = new DragManager (this);
			// hide_manager = new HideManager (this);
			// hover = new HoverWindow (this);
			window = new DockWindow (this);
			
			// position_manager.initialize ();
			// renderer.initialize ();
			// drag_manager.initialize ();
			// hide_manager.initialize ();
			
			// window.show_all ();
		}
	}
}
