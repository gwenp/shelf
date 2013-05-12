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

using Cairo;
using Gdk;

namespace Shelf.Drawing
{
	/**
	 * Utility service for loading icons and working with pixbufs.
	 */
	public class DrawingService : GLib.Object
	{
		const double SATURATION_WEIGHT = 1.5;
		const double WEIGHT_THRESHOLD = 1.0;
		const uint8 ALPHA_THRESHOLD = 24;
		
		/**
		 * Computes and returns the average color of a {@link Gdk.Pixbuf}.
		 * The resulting color is the average of all pixels which aren't
		 * nearly transparent while saturated pixels are weighted more than
		 * "grey" ones.
		 *
		 * @param source the pixbuf to use
		 * @return the average color of the pixbuf
		 */
		public static Drawing.Color average_color (Pixbuf source)
		{
			uint8 r, g, b, a, min, max;
			double delta;

			var rTotal = 0.0;
			var gTotal = 0.0;
			var bTotal = 0.0;
			
			var bTotal2 = 0.0;
			var gTotal2 = 0.0;
			var rTotal2 = 0.0;
			var aTotal2 = 0.0;
			
			uint8* dataPtr = source.get_pixels ();
			int n_channels = source.n_channels;
			int width = source.width;
			int height = source.height;
			int rowstride = source.rowstride;
			int length = width * height;
			int pixels = height * rowstride / n_channels;
			double scoreTotal = 0.0;
			
			for (var i = 0; i < pixels; i++) {
				r = dataPtr [0];
				g = dataPtr [1];
				b = dataPtr [2];
				a = dataPtr [3];
				
				// skip (nearly) invisible pixels
				if (a <= ALPHA_THRESHOLD) {
					length--;
					dataPtr += n_channels;
					continue;
				}
				
				min = uint8.min (r, uint8.min (g, b));
				max = uint8.max (r, uint8.max (g, b));
				delta = max - min;
				
				// prefer colored pixels over shades of grey
				var score = SATURATION_WEIGHT * (delta == 0 ? 0.0 : delta / max);
				
				// weighted sums, revert pre-multiplied alpha value
				bTotal += score * b / a;
				gTotal += score * g / a;
				rTotal += score * r / a;
				scoreTotal += score;
				
				// not weighted sums
				bTotal2 += b;
				gTotal2 += g;
				rTotal2 += r;
				aTotal2 += a;
				
				dataPtr += n_channels;
			}
			
			// looks like a fully transparent image
			if (length <= 0)
				return { 0.0, 0.0, 0.0, 0.0 };
			
			scoreTotal /= length;
			bTotal /= length;
			gTotal /= length;
			rTotal /= length;
			
			if (scoreTotal > 0.0) {
				bTotal /= scoreTotal;
				gTotal /= scoreTotal;
				rTotal /= scoreTotal;
			}
			
			bTotal2 /= length * uint8.MAX;
			gTotal2 /= length * uint8.MAX;
			rTotal2 /= length * uint8.MAX;
			aTotal2 /= length * uint8.MAX;
			
			// combine weighted and not weighted sum depending on the average "saturation"
			// if saturation isn't reasonable enough
			// s = 0.0 -> f = 0.0 ; s = WEIGHT_THRESHOLD -> f = 1.0
			if (scoreTotal <= WEIGHT_THRESHOLD) {
				var f = 1.0 / WEIGHT_THRESHOLD * scoreTotal;
				var rf = 1.0 - f;
				bTotal = bTotal * f + bTotal2 * rf;
				gTotal = gTotal * f + gTotal2 * rf;
				rTotal = rTotal * f + rTotal2 * rf;
			}
			
			// there shouldn't be values larger then 1.0
			var max_val = double.max (rTotal, double.max (gTotal, bTotal));
			if (max_val > 1.0) {
				bTotal /= max_val;
				gTotal /= max_val;
				rTotal /= max_val;
			}
			
			return { rTotal, gTotal, bTotal, aTotal2 };
		}
	}
}
