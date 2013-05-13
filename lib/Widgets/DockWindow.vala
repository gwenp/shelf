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
using Shelf.Drawing;
using Shelf.System;

namespace Shelf.Widgets
{
	public enum Struts
	{
		LEFT,
		RIGHT,
		TOP,
		BOTTOM,
		LEFT_START,
		LEFT_END,
		RIGHT_START,
		RIGHT_END,
		TOP_START,
		TOP_END,
		BOTTOM_START,
		BOTTOM_END,
		N_VALUES
	}
	
	/**
	 * The main window for all docks.
	 */
	public class DockWindow : CompositedWindow
	{

		bool firstDraw = true;

		/**
		 * The controller for this dock.
		 */
		public DockController controller { private get; construct; }
		
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
			skip_pager_hint = true;
			skip_taskbar_hint = true;
			
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
		public override bool button_press_event (EventButton event)
		{
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool button_release_event (EventButton event)
		{

			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool enter_notify_event (EventCrossing event)
		{
			
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool leave_notify_event (EventCrossing event)
		{
			
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool motion_notify_event (EventMotion event)
		{
			controller.tab_manager.check_tab_mouse_collision(event);
			queue_draw();
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		public override bool scroll_event (EventScroll event)
		{
			
			return true;
		}

		/**
		 * {@inheritDoc}
		 */
		public override bool draw (Context cr)
		{
			if(firstDraw)
			{
				firstDraw = false;
				controller.position_manager.initialize();
			}

			controller.renderer.draw(cr);
			return true;
		}

		public void update_size_and_position()
		{
			stdout.printf("update_size_and_position");
			unowned DockPositionManager position_manager = controller.position_manager;

			set_size_request (position_manager.win_width, position_manager.win_height);
		}

		/**
		 * {@inheritDoc}
		 */
		public override bool map_event (EventAny event)
		{
			set_struts ();
			
			return base.map_event (event);
		}

		void set_struts ()
		{
			if (!get_realized ())
				return;
			
			var struts = new ulong [Struts.N_VALUES];
			
			// if (controller.prefs.HideMode == HideType.NONE)
			// controller.position_manager.get_struts (ref struts);
			
			var first_struts = new ulong [Struts.BOTTOM + 1];
			for (var i = 0; i < first_struts.length; i++)
				first_struts [i] = struts [i];
			
			unowned X.Display display = X11Display.get_xdisplay (get_display ());
			var xid = X11Window.get_xid (get_window ());
			
			Gdk.error_trap_push ();
			display.change_property (xid, display.intern_atom ("_NET_WM_STRUT_PARTIAL", false), X.XA_CARDINAL,
			                      32, X.PropMode.Replace, (uchar[]) struts, struts.length);
			display.change_property (xid, display.intern_atom ("_NET_WM_STRUT", false), X.XA_CARDINAL,
			                      32, X.PropMode.Replace, (uchar[]) first_struts, first_struts.length);
			Gdk.error_trap_pop ();
		}
	}
}
