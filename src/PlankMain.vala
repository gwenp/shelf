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

using Shelf.Factories;

namespace PlankMain
{
	public class PlankMain : AbstractMain
	{
		public static int main (string[] args)
		{
			var main_class = new PlankMain ();
			Factory.init (main_class, new ItemFactory ());
			return main_class.run (ref args);
		}
		
		public PlankMain ()
		{
			build_pkg_data_dir = Build.PKGDATADIR;
			
			program_name = "Shelf";
			exec_name = "shelf";
		}
	}
}
