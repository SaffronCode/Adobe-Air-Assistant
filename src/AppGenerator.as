package
{
	import appManager.mains.App;
	
	import component.AppIconGenerator;
	import component.xmlPack.ManifestGenerate;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.Sprite;
	
	public class AppGenerator extends Sprite
	{
		private static const iconSizes:Array = [16
												,29
												,32
												,36
												,57
												,114
												,512
												,48
												,72
												,50
												,58
												,100
												,144
												,1024
												,40
												,76
												,80
												,120
												,128
												,152
												,180
												,60
												,75
												,87
												,167] ;
		
		private var iconGenerator:AppIconGenerator ;
		
		public function AppGenerator()
		{
			super();
			
			iconSizes
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			var manifestGenerate:ManifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			trace(manifestGenerate.toString());
			
			FrameGenerator.createFrame(stage);
		}
	}
}