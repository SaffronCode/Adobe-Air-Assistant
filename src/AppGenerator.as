package
{
	import appManager.mains.App;
	
	import com.mteamapp.StringFunctions;
	
	import component.AppIconGenerator;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.System;
	import contents.alert.Alert;
	
	
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
		private var mainXMLFile:File;
		
		public function AppGenerator()
		{
			super();
			
			FrameGenerator.createFrame(stage);
			
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			
			manifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			//stage.addEventListener(MouseEvent.CLICK,convertSampleXML);
			
			var manifestLoaderMC:MovieClip = Obj.get("load_manifest_mc",this) ;
			manifestLoaderMC.buttonMode = true ;
			manifestLoaderMC.addEventListener(MouseEvent.CLICK,loadExistingManifest);
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
		}
		
		private function loadExistingManifest(e:MouseEvent):void
		{
			FileManager.browse(loadThisManifestXML,['*.xml']);
			
			function loadThisManifestXML(fileTarget:File):void
			{
				mainXMLFile = fileTarget ;
				trace("Loaded file is : "+fileTarget.nativePath);
				trace("mainXML file is : "+mainXMLFile.nativePath);
				convertSampleXML();
			}
		}
		
		protected function convertSampleXML():void
		{
			trace("mainXMLFile : "+mainXMLFile.nativePath);
			manifestGenerate.convert(TextFile.load(mainXMLFile));
			manifestGenerate.addAndroidPermission(TextFile.load(File.applicationDirectory.resolvePath("SampleXML")
					.resolvePath("distriqtNotification")
					.resolvePath("distriqtNotificationOneSignal.xml")));
			manifestGenerate.addExtension(TextFile.load(File.applicationDirectory.resolvePath("SampleXML/distriqtNotification/distriqtNotificationOneSignal-extension.xml")));
			
			var newManifest:String = manifestGenerate.toString();
			System.setClipboard(newManifest);
			trace(newManifest);
		}
	}
}