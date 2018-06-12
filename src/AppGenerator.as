package
{
	import appManager.mains.App;
	
	import com.mteamapp.StringFunctions;
	
	import component.AppIconGenerator;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.System;
	
	
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

		private var manifestGenerate:ManifestGenerate;
		
		public function AppGenerator()
		{
			super();
			
			FrameGenerator.createFrame(stage);
			
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			
			manifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			stage.addEventListener(MouseEvent.CLICK,convertSampleXML);
		}
		
		protected function convertSampleXML(event:MouseEvent):void
		{
			manifestGenerate.convert(TextFile.load(File.applicationDirectory.resolvePath('SampleXML/KargozarMellat-app-android.xml')));
			
			manifestGenerate.addAndroidPermission(TextFile.load(File.applicationDirectory.resolvePath("SampleXML/distriqtNotificationOneSignal.xml")));
			
			var newManifest:String = manifestGenerate.toString();
			System.setClipboard(newManifest);
			trace(newManifest);
		}
	}
}