using Shelf.System;

namespace Shelf.System
{
	/**
	 * Class to manage dock's themes.
	 */
	public class DockTheme : Theme
	{		
		[Description(nick = "fade-opacity", blurb = "The opacity value (0 to 1) to fade the dock to when hiding it.")]
		public double FadeOpacity { get; set; }
		
		[Description(nick = "fade-time", blurb = "The time (in ms) to fade the dock in/out on a hide (if FadeOpacity is < 1).")]
		public int FadeTime { get; set; }
		
		[Description(nick = "hide-time", blurb = "The time (in ms) to slide the dock in/out on a hide (if FadeOpacity is 1).")]
		public int HideTime { get; set; }
		
		[Description(nick = "urgent-bounce-time", blurb = "The amount of time (in ms) to bounce an urgent icon.")]
		public int UrgentBounceTime { get; set; }

		[Description(nick = "glow-time", blurb = "The total time (in ms) to show the hidden-dock urgent glow.")]
		public int GlowTime { get; set; }
				
		[Description(nick = "active-time", blurb = "The amount of time (in ms) for active window indicator animations.")]
		public int ActiveTime { get; set; }
				
		[Description(nick = "click-time", blurb = "The amount of time (in ms) for click animations.")]
		public int ClickTime { get; set; }

		/**
		 * Creates a new dock theme manager.
		 */
		public DockTheme (DockController controller)
		{
			base (controller);
		}

		/**
		 * {@inheritDoc}
		 */
		protected override void reset_properties ()
		{
			base.reset_properties ();
			FadeOpacity = 1.0;
			ClickTime = 300;
			UrgentBounceTime = 600;
			ActiveTime = 300;
			FadeTime = 250;
			HideTime = 150;
			GlowTime = 10000;
		}


	}
}