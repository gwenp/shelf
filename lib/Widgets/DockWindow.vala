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

using Shelf.Factories;
using Shelf.System;

namespace Shelf.Widgets
{
	/**
	 * The main window for all docks.
	 */
	public class DockWindow : CompositedWindow
	{
		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
		
		
		uint reposition_timer = 0;
		uint hover_reposition_timer = 0;
		
		bool dock_is_starting = true;
		
		Cairo.RectangleInt input_rect;
		
		/**
		 * Creates a new dock window.
		 */
		public DockWindow (DockController controller)
		{
			GLib.Object (controller: controller, type: Gtk.WindowType.TOPLEVEL, type_hint: WindowTypeHint.DOCK);
		}
		
		construct
		{
			accept_focus = false;
			can_focus = false;
			// skip_pager_hint = true;
			// skip_taskbar_hint = true;
			
			stick ();
			
			add_events (EventMask.BUTTON_PRESS_MASK |
						EventMask.BUTTON_RELEASE_MASK |
						EventMask.ENTER_NOTIFY_MASK |
						EventMask.LEAVE_NOTIFY_MASK |
						EventMask.POINTER_MOTION_MASK |
						EventMask.SCROLL_MASK);
		}
		
		~DockWindow ()
		{
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool draw (Context cr)
		{
			if (dock_is_starting) {
				debug ("dock window loaded");
				dock_is_starting = false;
			}
			
			// set_input_mask ();
			// controller.renderer.draw_dock (cr);
			
			return true;
		}
	}
}
