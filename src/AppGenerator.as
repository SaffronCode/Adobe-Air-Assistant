package
{
	import component.*;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.*;
	
	import popForm.*;
	import contents.alert.Alert;

;

	//import flash.system.System;
	
	
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
		private var manifestExporterMC:MovieClip ;
		private var loadMobileProvisionMC:MovieClip ;
		
					
		private var checkList:Vector.<ACheckBox> = new Vector.<ACheckBox>();
		
		private const xmlFolder:File = File.applicationDirectory.resolvePath('SampleXML');
		
		//Display fields
		private var field_nameMC:PopField,
					field_appIdMC:PopField,
					field_teamIdMC:PopField,
					field_uriLauncherMC:PopField,
					field_airVersionMC:PopField,
					fullscreen_textMC:PopFieldBoolean,
					render_mode_textMC:PopField,
					auto_orients_txtMC:PopFieldBoolean,
					swf_name_textMC:PopField,
					file_name_textMC:PopField,
					copyright_textMC:PopField,
					field_versionMC:PopField;

					private var uriLauncher:ACheckBox;
					
		private var newVersionMC:MovieClip ;
		
		public function AppGenerator()
		{
			super();
			
			newVersionMC = Obj.get("new_version_mc",this);
			newVersionMC.addEventListener(MouseEvent.CLICK,function(e){
				navigateToURL(new URLRequest("https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/build/AppGenerator.air"));
			});
			newVersionMC.visible = false ;
			var urlLoader:URLLoader = new URLLoader(new URLRequest("https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/src/AppGenerator-app.xml?"+new Date().time));
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			urlLoader.addEventListener(Event.COMPLETE,function(e){
				var versionPart:Array = String(urlLoader.data).match(/<versionNumber>.*<\/versionNumber>/gi);
				if(versionPart.length>0)
				{
					versionPart[0] = String(versionPart[0]).split('<versionNumber>').join('').split('</versionNumber>').join('');
					//Alert.show("version loaded : "+versionPart[0]+' > '+(DevicePrefrence.appVersion==versionPart[0]));
					if(!(DevicePrefrence.appVersion==versionPart[0]))
					{
						newVersionMC.visible = true ;
						newVersionMC.alpha = 0 ;
						AnimData.fadeIn(newVersionMC);
					}
				}
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e){});
			
			FrameGenerator.createFrame(stage);
			
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			
			manifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			//stage.addEventListener(MouseEvent.CLICK,convertSampleXML);
			
			manifestExporterMC = Obj.get("export_manifest_mc",this);
			manifestExporterMC.addEventListener(MouseEvent.CLICK,exportSavedManifest);
			//manifestExporterMC.visible = false ;
			
			var manifestLoaderMC:MovieClip = Obj.get("load_manifest_mc",this) ;
			manifestLoaderMC.buttonMode = true ;
			manifestLoaderMC.addEventListener(MouseEvent.CLICK,loadExistingManifest);
			
			loadMobileProvisionMC = Obj.get("load_privision_mc",this);
			loadMobileProvisionMC.gotoAndStop(2);
			loadMobileProvisionMC.addEventListener(MouseEvent.CLICK,loadMobileProvission);
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			
			//Display fields
			render_mode_textMC = Obj.get("render_mode_text",this);
			render_mode_textMC.setUp('Render Mode:','',null,false,true,false,1,1,2,0,['gpu','cpu','auto'],false,true,null,null,true);
			render_mode_textMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.renderMode = render_mode_textMC.text ;
			});

			fullscreen_textMC = Obj.get("fullscreen_text",this);
			fullscreen_textMC.setUp('Full Screen:',false,false);
			fullscreen_textMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.fullScreen = fullscreen_textMC.data ;
			});

			auto_orients_txtMC = Obj.get("auto_orients_txt",this);
			auto_orients_txtMC.setUp('Auto Orients:',false,false);
			auto_orients_txtMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.autoOrients = auto_orients_txtMC.data ;
			});
 
			field_nameMC = Obj.get("app_name_text",this);
			field_nameMC.setUp('App Name:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_nameMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.name = field_nameMC.text ;
			});
 
			copyright_textMC = Obj.get("copyright_text",this);
			copyright_textMC.setUp('Copyright:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			copyright_textMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.copyright = copyright_textMC.text ;
			});

			file_name_textMC = Obj.get("file_name_text",this);
			file_name_textMC.setUp('File Name:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			file_name_textMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.filename = file_name_textMC.text ;
			});
			
			field_versionMC = Obj.get("app_version_text",this);
			field_versionMC.setUp('Version:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_versionMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.versionNumber = field_versionMC.text ;
			});
			
			field_uriLauncherMC = Obj.get("uri_launcher_text",this);
			field_uriLauncherMC.setUp('URI Scheme:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_uriLauncherMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.uriLauncher = field_uriLauncherMC.text.toLowerCase() ;
			});
			
			swf_name_textMC = Obj.get("swf_name_text",this);
			swf_name_textMC.setUp('SWF Name:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			swf_name_textMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.content = swf_name_textMC.text ;
			});
			
			field_appIdMC = Obj.get("app_id_text",this);
			field_appIdMC.setUp('App Id:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_appIdMC.addEventListener(Event.CHANGE,function(e){
					manifestGenerate.setAppId(field_appIdMC.text);
					if(uriLauncher.status)
					{
						createURISchemeFromId();
					}
				}
			);
			
			field_teamIdMC = Obj.get("team_id_text",this);
			field_teamIdMC.setUp('iOS Team Id:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_teamIdMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.teamId = field_teamIdMC.text ;
			});
			
			field_airVersionMC = Obj.get("air_version_text",this);
			field_airVersionMC.setUp('Air Version:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_airVersionMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.airVersion = field_airVersionMC.text ;
			});
			
			///////////////
			var distriqt_camera:ACheckBox = Obj.get("distriqt_camera_ui_mc",this);
				distriqt_camera.setUp(false,'Distriqt Camera UI','distriqtCameraUI');
				checkList.push(distriqt_camera);
				
			var milkman_push:ACheckBox = Obj.get("milkman_push_mc",this);
				milkman_push.setUp(false,'Milkman Easy Push','MilkmanNotification');
				checkList.push(milkman_push);
			var distriqt_push:ACheckBox = Obj.get("distriqt_push_mc",this);
				distriqt_push.setUp(false,'Distriqt Push Notification','distriqtNotification');
				checkList.push(distriqt_push);
				
				milkman_push.addEventListener(Event.CHANGE,function(e){
					if(milkman_push.status)
						distriqt_push.status = false ; 
				});
				
				distriqt_push.addEventListener(Event.CHANGE,function(e){
					if(distriqt_push.status)
						milkman_push.status = false ; 
				});
				
			var distriqt_share:ACheckBox = Obj.get("distriqt_share_mc",this);
				distriqt_share.setUp(false,'Distriqt Share','distriqtShare');
				checkList.push(distriqt_share);
			var distriqt_PDF:ACheckBox = Obj.get("distriqt_pdf_mc",this);
				distriqt_PDF.setUp(false,'Distriqt PDF Reader','distriqtPdf');
				checkList.push(distriqt_PDF);
			var distriqt_mediaplayer:ACheckBox = Obj.get("distriqt_mediaplayer_mc",this);
				distriqt_mediaplayer.setUp(false,'Distriqt Media Player','distriqtMediaPlayer');
				checkList.push(distriqt_mediaplayer);
				
			var permCameraMC:ACheckBox = Obj.get("permission_camera_mc",this);
			permCameraMC.setUp(false,'Camera','camera');
			checkList.push(permCameraMC);
				
			var permInternetMC:ACheckBox = Obj.get("permission_internet_mc",this);
			permInternetMC.setUp(true,'Internet Access','internet');
			checkList.push(permInternetMC);
				
			var permLocationMC:ACheckBox = Obj.get("permission_location_mc",this);
			permLocationMC.setUp(false,'Location','location');
			checkList.push(permLocationMC);
				
			var permMicrophoneMC:ACheckBox = Obj.get("permission_microphone_mc",this);
			permMicrophoneMC.setUp(false,'Microphone','microphone');
			checkList.push(permMicrophoneMC);
				
			var permWakeMC:ACheckBox = Obj.get("permission_wakelock_mc",this);
			permWakeMC.setUp(false,'Prevent Sleep','wakelock');
			checkList.push(permWakeMC);
				
			var flashvisionsVideoGalleryMC:ACheckBox = Obj.get("video_gallery_mc",this);
			flashvisionsVideoGalleryMC.setUp(false,'Flashvisions Video Gallery','flashvisionsVideoGallery');
			checkList.push(flashvisionsVideoGalleryMC);
				
			var distriqtScannerMC:ACheckBox = Obj.get("distriqt_scanner_mc",this);
			distriqtScannerMC.setUp(false,'Distriqt Scanner','distriqtScanner');
			checkList.push(distriqtScannerMC);
				
			var distriqtLocationMC:ACheckBox = Obj.get("distriqt_location_mc",this);
			distriqtLocationMC.setUp(false,'Distriqt Location','distriqtLocation');
			checkList.push(distriqtLocationMC);
			
			uriLauncher = Obj.get("uri_caller_mc",this);
			uriLauncher.setUp(false,'URL Scheme Launcher','URILauncher');
			checkList.push(uriLauncher);
			uriLauncher.addEventListener(Event.CHANGE,function(e){
				if(uriLauncher.status)
				{
					if(field_uriLauncherMC.text=='')
						field_uriLauncherMC.text = manifestGenerate.uriLauncher = schemFromId() ;
				}
				else
				{
					field_uriLauncherMC.text = '' ;
				}
			});
			
			
			
			updateInformations();
		}
				
		private function createURISchemeFromId()
		{
			manifestGenerate.uriLauncher = schemFromId();
			updateInformations();
		}
		
		/**Creats scheme from id*/
		private function schemFromId():String
		{
			return manifestGenerate.id.slice(manifestGenerate.id.lastIndexOf('.')+1);
		}		
		
		private function updateInformations():void
		{
			field_nameMC.text = manifestGenerate.name ;
			field_versionMC.text = manifestGenerate.versionNumber ;
			field_appIdMC.text = manifestGenerate.id ;
			field_teamIdMC.text = manifestGenerate.teamId ;
			field_airVersionMC.text = manifestGenerate.airVersion ;
			field_uriLauncherMC.text = manifestGenerate.uriLauncher ;
			render_mode_textMC.text = manifestGenerate.renderMode ;
			fullscreen_textMC.data = manifestGenerate.fullScreen ;
			auto_orients_txtMC.data = manifestGenerate.autoOrients ;
			swf_name_textMC.text = manifestGenerate.content ;
			file_name_textMC.text = manifestGenerate.filename ;
			copyright_textMC.text = manifestGenerate.copyright ;
			
			field_uriLauncherMC.enabled = uriLauncher.status ;
			field_uriLauncherMC.alpha = (uriLauncher.status)?1:0.5;
			
			for(var i:int = 0 ; i<checkList.length ; i++)
			{
				checkList[i].status = checkIfExistsBefor(xmlFolder.resolvePath(checkList[i].folderName)) ; 
			}
		}
		
		private function loadMobileProvission(e:MouseEvent):void
		{
			FileManager.browse(mobileProvissionSelected,["*.mobileprovision"],"Select your mobile provission");
			function mobileProvissionSelected(fil:File):void
			{
				var status:Boolean = manifestGenerate.addMobileProvission(FileManager.loadFile(fil));
				if(status)
				{
					loadMobileProvisionMC.gotoAndStop(1);
					manifestExporterMC.visible = true ;
				}
				else
					loadMobileProvisionMC.gotoAndStop(2);
				
				updateInformations();
			}
		}
		
		private function addDefaultManifestFrom(folder:File):void
		{
			manifestGenerate.addAndroidPermission(TextFile.load(folder.resolvePath("android_manifest.xml")));
			manifestGenerate.addIosEntitlements(TextFile.load(folder.resolvePath("ios_Entitlements.xml")));
			manifestGenerate.addInfoAdditions(TextFile.load(folder.resolvePath("ios_infoAdditions.xml")));
			manifestGenerate.addExtension(TextFile.load(folder.resolvePath("extension.xml")));
		}
		
		private function checkIfExistsBefor(folder:File):Boolean
		{
			var con1:Boolean = manifestGenerate.doAndroidPermissionHave(TextFile.load(folder.resolvePath("android_manifest.xml")));
			var con2:Boolean = manifestGenerate.doIosEntitlementsHave(TextFile.load(folder.resolvePath("ios_Entitlements.xml")));
			var con3:Boolean = manifestGenerate.doInfoAdditionsHave(TextFile.load(folder.resolvePath("ios_infoAdditions.xml"))); 
			return con1 && con2 && con3 ;
		}
		
		private function removeDefaultManifestFrom(folder:File):void
		{
			manifestGenerate.removeAndroidPermission(TextFile.load(folder.resolvePath("android_manifest.xml")));
			manifestGenerate.removeIosEntitlements(TextFile.load(folder.resolvePath("ios_Entitlements.xml")));
			manifestGenerate.removeInfoAdditions(TextFile.load(folder.resolvePath("ios_infoAdditions.xml")));
			manifestGenerate.removeExtension(TextFile.load(folder.resolvePath("extension.xml")));
		}
		
		private function addDistManifestFrom(folder:File):String
		{
			var loadedDistEntitlements:String = TextFile.load(folder.resolvePath("ios_Entitlements-dist.xml")) ;
			if(loadedDistEntitlements!='')
			{
				manifestGenerate.addIosEntitlements(loadedDistEntitlements);
				return manifestGenerate.toString();
			}
			return null ;
		}
		
		private function exportSavedManifest(e:MouseEvent):void
		{		
			var nativeFolder:File ;
			FileManager.browseToSave(saveFileThere,"Select a destination for your new Manifest file",'xml');
			//trace("mainXMLFile : "+mainXMLFile.nativePath);
			
			for(var i:int = 0 ; i<checkList.length ; i++)
			{
				nativeFolder = xmlFolder.resolvePath(checkList[i].folderName);
				if(!checkList[i].status)
				{
					removeDefaultManifestFrom(nativeFolder);
				}
			}
			
			for(i = 0 ; i<checkList.length ; i++)
			{
				nativeFolder = xmlFolder.resolvePath(checkList[i].folderName);
				if(checkList[i].status)
				{
					addDefaultManifestFrom(nativeFolder);
				}
			}
			
			var newManifest:String = manifestGenerate.toString();
			//System.setClipboard(newManifest);
			var newDistManifest:String ;
			var newChanges:String ; 
			
			for(i = 0 ; i<checkList.length ; i++)
			{
				if(checkList[i].status)
				{
					nativeFolder = xmlFolder.resolvePath(checkList[i].folderName);
					newChanges = addDistManifestFrom(nativeFolder);
					newDistManifest = (newChanges!=null)?newChanges:newDistManifest ;
				}
			}
			//updateInformations();
			
			
			function saveFileThere(fileTarget:File):void
			{
				TextFile.save(fileTarget,newManifest);
				if(newDistManifest!=null)
				{
					var distName:String = fileTarget.name.split('.'+fileTarget.extension).join('');
					fileTarget = fileTarget.parent.resolvePath(distName+'-dist.xml');
					TextFile.save(fileTarget,newDistManifest);
				}
			}
		}
		
		private function loadExistingManifest(e:MouseEvent):void
		{
			FileManager.browse(loadThisManifestXML,['*.xml']);
			
			function loadThisManifestXML(fileTarget:File):void
			{
				mainXMLFile = fileTarget ;
				trace("Loaded file is : "+fileTarget.nativePath);
				trace("mainXML file is : "+mainXMLFile.nativePath);
				//convertSampleXML();
				manifestExporterMC.visible = true ;
				manifestGenerate.convert(TextFile.load(mainXMLFile));
				
				
				updateInformations();
			}
		}
	}
}