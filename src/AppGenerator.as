package
{
	import dynamicFrame.FrameGenerator;
	
	import flash.display.Sprite;
	
	public class AppGenerator extends Sprite
	{
		public function AppGenerator()
		{
			super();
			
			FrameGenerator.createFrame(stage);
		}
	}
}