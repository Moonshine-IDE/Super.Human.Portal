package view.controls
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.jewel.beads.views.SliderView;

	public class SliderPasswordStrengthView extends SliderView 
	{
		public function SliderPasswordStrengthView()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			sliderTrackContainer.classList.add("sliderPasswordStrengthContainer");
			sliderTrackFill.classList.add("sliderPasswordStrengthTrackFill");
			sliderTrack.classList.add("sliderPasswordStrengthTrack");
		}
	}
}