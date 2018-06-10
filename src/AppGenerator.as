package
{
	import appManager.mains.App;
	
	import com.mteamapp.StringFunctions;
	
	import component.AppIconGenerator;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	
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
			
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			
			var manifestGenerate:ManifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			manifestGenerate.convert(TextFile.load(File.applicationDirectory.resolvePath('SampleXML/KargozarMellat-app-android.xml')));
			
			trace(manifestGenerate.toString());
			
			FrameGenerator.createFrame(stage);
		}
	}
}