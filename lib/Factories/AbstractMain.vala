//
//  Copyright (C) 2011-2012 Robert Dyer, Rico Tzschichholz
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

using Gtk;
using Posix;

using Shelf.System;

namespace Shelf.Factories
{
	/**
	 * The main class for all dock applications.  All docks should extend this class.
	 * In the constructor, the string fields should be initialized to customize the dock.
	 */
	public abstract class AbstractMain : GLib.Object
	{

		/**
		 * The Application for preserving uniqueness
		 */
		protected Gtk.Application application;

		/**
		 * Signal fired when the program is fully initialized, before creating and showing the dock.
		 */
		protected signal void initialized ();

		/**
		 * The displayed name of the program.
		 */
		protected string program_name = "";
		/**
		 * The executable name of the program.
		 */
		protected string exec_name = "";

		public virtual int run (ref unowned string[] args)
		{
			initialize_program ();
			
			if (!parse_commandline (ref args))
				return Posix.EXIT_FAILURE;
			
			if (!initialize_libraries (ref args))
				return Posix.EXIT_FAILURE;

			set_options ();

			initialized ();
			
			create_controller ();
			Gdk.threads_enter ();
			Gtk.main ();
			Gdk.threads_leave ();

			return Posix.EXIT_SUCCESS;
		}
			
		[CCode (cheader_filename = "sys/prctl.h", cname = "prctl")]
		extern static int prctl (int option, string arg2, ulong arg3, ulong arg4, ulong arg5);
		
		[CCode (cheader_filename = "glib/glib.h", cname = "glib_major_version")]
		extern const uint glib_major_version;
		[CCode (cheader_filename = "glib/glib.h", cname = "glib_minor_version")]
		extern const uint glib_minor_version;
		[CCode (cheader_filename = "glib/glib.h", cname = "glib_micro_version")]
		extern const uint glib_micro_version;

		protected virtual void initialize_program ()
		{
			// set program name
			prctl (15, exec_name, 0, 0, 0);
			Environment.set_prgname (exec_name);
						
			Posix.signal(Posix.SIGINT, sig_handler);
			Posix.signal(Posix.SIGTERM, sig_handler);
			
			Logger.initialize ("shelf");
			// Logger.DisplayLevel = LogLevel.INFO;
			// message ("%s version: %s", program_name, build_version);
			// message ("Kernel version: %s", Posix.utsname ().release);
			// message ("GLib version: %u.%u.%u", glib_major_version, glib_minor_version, glib_micro_version);
			// message ("GTK+ version: %u.%u.%u", Gtk.get_major_version (), Gtk.get_minor_version () , Gtk.get_micro_version ());
			// message ("Wnck version: %d.%d.%d", Wnck.Version.MAJOR_VERSION, Wnck.Version.MINOR_VERSION, Wnck.Version.MICRO_VERSION);
			// message ("Cairo version: %s", Cairo.version_string ());
			// message ("Pango version: %s", Pango.version_string ());
			// Logger.DisplayLevel = LogLevel.WARN;
		}
	
		protected virtual bool initialize_libraries (ref unowned string[] args)
		{
			// Intl.bindtextdomain (exec_name, build_data_dir + "/locale");
			
			if (!Thread.supported ()) {
				critical ("Problem initializing thread support.");
				return false;
			}
			
			Gdk.threads_init ();
			Gtk.init (ref args);
			
			application = new Gtk.Application ("testing.shelf", ApplicationFlags.FLAGS_NONE);
			try {
				if (application.register () && !application.get_is_remote ())
					return true;
			} catch (Error e) {
				critical ("Registering application as '%s' failed. (%s)", "shelf", e.message);
				return false;
			}
			
			// warning ("Exiting because another instance of this application is already running with the name '%s'.", dock_path);
			return false;
		}
	
		static void sig_handler (int sig)
		{
			warning ("Caught signal (%d), exiting", sig);
			Gtk.main_quit ();
		}

		/**
		 * If debug mode is enabled.
		 */
		protected static bool DEBUG = false;
		
		/**
		 * If verbose mode is enabled.
		 */
		protected static bool VERBOSE = false;
		/**
		 * The default command-line options for the dock.
		 */
		protected const OptionEntry[] options = {
			{ "debug", 'd', 0, OptionArg.NONE, out DEBUG, "Enable debug logging", null },
			{ "verbose", 'v', 0, OptionArg.NONE, out VERBOSE, "Enable verbose logging", null },
			{ null }
		};


		/**
		 * Parses the command-line for options, but does not set them.
		 *
		 * @param args the command-line arguments
		 * @return whether the arguments were parsed successfully
		 */
		protected virtual bool parse_commandline (ref unowned string[] args)
		{
			// parse commandline options
			var context = new OptionContext ("");
			
			context.add_main_entries (options, null);
			context.add_group (Gtk.get_option_group (false));
			
			try {
				context.parse (ref args);
			} catch {
				return false;
			}
			
			return true;
		}

		/**
		 * Sets options based on the parsed command-line.
		 */
		protected virtual void set_options ()
		{
			if (DEBUG)
				Logger.DisplayLevel = LogLevel.DEBUG;
			if (VERBOSE)
				Logger.DisplayLevel = LogLevel.VERBOSE;
		}
				
		/**
		 * Creates the dock controller.
		 */
		protected virtual void create_controller ()
		{
			new DockController ();
		}

	}
}
