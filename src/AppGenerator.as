package
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import appManager.displayObjects.SwitchButtonAnimated ;

	import component.ACheckBox;
	import component.AppIconGenerator;
	import component.WarningShow;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	import contents.alert.Alert;
	
	import dynamicFrame.FrameGenerator;
	
	import popForm.PopField;
	import popForm.PopFieldBoolean;
	import deng.fzip.FZip;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import component.googleServices.GoogleServiceJSON;
	import com.mteamapp.JSONParser;
	import appManager.displayContentElemets.TitleText;
	import deng.fzip.FZipFile;
	import appManager.displayContentElemets.LightImage;
	import dataManager.GlobalStorage;
	import googleAPI.type.address_componentsClass;
	import flash.display.BitmapData;
	import component.FCM.AllFCMIcons;
	import com.mteamapp.VersionController;
	import flash.net.URLRequestMethod;
	import restDoaService.RestDoaServiceCaller;
	import flash.net.URLVariables;

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
		
		private var clearMC:MovieClip ;
		
		private var currentFile:File;

		private var manifestLoaderMC:MovieClip;
		
		private var searchMC:PopField ;

		private var nativeCheckContainerMC:MovieClip;
		
		private var warningMC:WarningShow ;
		
		private var warnButtonMC:MovieClip,
		
					lastWarningText:String ,
					lastWarningFunction:Function ;

		private var aneSettingMC:MovieClip,
					aneDirectory:File,
					createAneDirectoryMC:MovieClip;
		private const id_ane_directory:String = "id_ane_directory" ;
		
		public function AppGenerator()
		{
			super();

			///ANE directory
			aneSettingMC = Obj.get("ane_setting_mc",this);
			aneSettingMC.buttonMode = true ;
			aneSettingMC.addEventListener(MouseEvent.CLICK,function(e){
				FileManager.browseForDirectory(aneDirectorySelected,"Select your local native files directory");
				function aneDirectorySelected(AneDirectory:File)
				{
					aneDirectory = AneDirectory;
					GlobalStorage.save(id_ane_directory,aneDirectory.nativePath);
					createAneDirectoryMC.visible = true ;
				}
			});
			if(GlobalStorage.load(id_ane_directory)!=null)
			{
				aneDirectory = new File(GlobalStorage.load(id_ane_directory));
			}
			createAneDirectoryMC = Obj.get("save_anes_mc",this);
			createAneDirectoryMC.buttonMode = true ;
			createAneDirectoryMC.visible = aneDirectory!=null?true:false;
			createAneDirectoryMC.addEventListener(MouseEvent.CLICK,saveAllanesToProjectPath);
			//////↑

			TextPutter.defaultResolution = 1 ;
			RestDoaServiceCaller

			var versionContrllURL:String = 'http://www.saffroncodesdk.com/api/Projects/versioncontrol' ;
			//Alert.show("Version controll : "+versionContrllURL);
			var versionRequest:URLRequest = new URLRequest(versionContrllURL);
			versionRequest.contentType = 'application/json';
			versionRequest.method = URLRequestMethod.POST ;
			versionRequest.data = JSON.stringify({AppId:"com.saffroncodesdk."+DevicePrefrence.appID}) ;
			VersionController.controllVersion(function(){
				//Alert.show("Version is OK");
			},function(){
				//Alert.show("Version is not OK!")
			},versionRequest,DevicePrefrence.appVersion,false);

			setUpFCMForDistriqt();
			
			warningMC = Obj.findThisClass(WarningShow,this);
			warnButtonMC = Obj.get("warn_mc",this);
			warnButtonMC.visible = false ;
			warnButtonMC.buttonMode = true ;
			warnButtonMC.addEventListener(MouseEvent.CLICK,openLastWarning);
			
			clearMC = Obj.get("clear_mc",this);
			
			searchMC = Obj.get("search_text",this);
			
			nativeCheckContainerMC = Obj.get("natives_mc",Obj.get("natives_mc",this));
			var nativeContainerBackMC:MovieClip = Obj.get("back_mc",nativeCheckContainerMC);
			//nativeCheckContainerMC.graphics.beginFill(0,0);
			//nativeCheckContainerMC.graphics.drawRect(0,0,nativeContainerBackMC.width,nativeContainerBackMC.height+300);
			new ScrollMT(nativeCheckContainerMC,new Rectangle(nativeCheckContainerMC.x,nativeCheckContainerMC.y,nativeContainerBackMC.width,nativeContainerBackMC.height),null,true,false,true,false,false,0,null,true);
			nativeContainerBackMC.visible = false ;
			
			newVersionMC = Obj.get("new_version_mc",this);
			var hintTF:TextField = Obj.get("hint_mc",newVersionMC);
			newVersionMC.addEventListener(MouseEvent.CLICK,openUpdator);
			
			var fileURL:String = "https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/build/AppGenerator.air" ;
			
			function openUpdator(e:MouseEvent):void
			{
				newVersionMC.removeEventListener(MouseEvent.CLICK,openUpdator);
				var loader:URLLoader = new URLLoader(new URLRequest(fileURL));
				loader.dataFormat = URLLoaderDataFormat.BINARY ;
				
				loader.addEventListener(Event.COMPLETE,loaded);
				loader.addEventListener(ProgressEvent.PROGRESS,progress)
				
				hintTF.text = "Please wait ..." ;
				
				function progress(e:ProgressEvent):void
				{
					hintTF.text = "Please wait ...(%"+Math.round((e.bytesLoaded/e.bytesTotal)*100)+")" ;
				}
				
				function loaded(e:Event):void
				{
					var fileTarget:File = File.createTempDirectory().resolvePath('SaffronAppGenerator.air') ;
					FileManager.seveFile(fileTarget,loader.data);
					
					fileTarget.openWithDefaultApplication();
					
					hintTF.text = "The installer should be open now...";
					
					setTimeout(function(e){
						NativeApplication.nativeApplication.exit();
					},2000);
					
					newVersionMC.addEventListener(MouseEvent.CLICK,function(e)
					{
						//navigateToURL(new URLRequest(fileTarget.url));
						navigateToURL(new URLRequest(fileURL));
					});
				}
				
			}
			
			newVersionMC.visible = false ;
			var urlLoader:URLLoader = new URLLoader(new URLRequest("https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/src/AppGenerator-app.xml?"+new Date().time));
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			urlLoader.addEventListener(Event.COMPLETE,function(e){
				var versionPart:Array = String(urlLoader.data).match(/<versionNumber>.*<\/versionNumber>/gi);
				if(versionPart.length>0)
				{
					versionPart[0] = String(versionPart[0]).split('<versionNumber>').join('').split('</versionNumber>').join('');
					trace("version loaded : "+versionPart[0]+' > '+(DevicePrefrence.appVersion==versionPart[0]));
					trace("DevicePrefrence.appVersion : "+DevicePrefrence.appVersion);
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
			
			manifestLoaderMC = Obj.get("load_manifest_mc",this) ;
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
			field_uriLauncherMC.addEventListener(MouseEvent.CLICK,function(e){
				if(uriLauncher.status==false)
				{
					uriLauncher.changeStatus();
				}
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
				manifestGenerate.setTeamId(field_teamIdMC.text) ;
			});
			
			field_airVersionMC = Obj.get("air_version_text",this);
			field_airVersionMC.setUp('Air Version:','',null,false,true,false,1,1,2,0,null,false,false,null,null,true);
			field_airVersionMC.addEventListener(Event.CHANGE,function(e){
				manifestGenerate.airVersion = field_airVersionMC.text ;
			});
			
			/////////////// ANE list
			var checkBoxSample:ACheckBox = Obj.findThisClass(ACheckBox,nativeCheckContainerMC);
			var checkBoxY:Number = checkBoxSample.y ;
			var checkBoxClass:Class = Obj.getObjectClass(checkBoxSample);
			Obj.remove(checkBoxSample);
				
			function addCheckBox(checkBoxName:String,manifestDirectoryName:String,onTrigered:Function=null,
			addItToList:Boolean=true,defaultStatus:Boolean=false):ACheckBox
			{
				var checkBox:ACheckBox = new checkBoxClass();
				
				checkBox.setUp(defaultStatus,checkBoxName,manifestDirectoryName);
				checkList.push(checkBox);
				checkBox.addItToList = addItToList ;
				
				if(onTrigered!=null)
				{
					checkBox.addEventListener(Event.CHANGE,function(e){
						onTrigered(checkBox);
					});
				}
				
				return checkBox ;
			}	
			
			
			///uri launcher
			uriLauncher = addCheckBox('URL Scheme Launcher','URILauncher',function(check:ACheckBox){
				if(check.status)
					field_uriLauncherMC.text = manifestGenerate.uriLauncher = schemFromId() ;
				else
					field_uriLauncherMC.text = manifestGenerate.uriLauncher = "" ;
				field_uriLauncherMC.enabled = check.status ;
				field_uriLauncherMC.alpha = (check.status)?1:0.5;
			});
			
			
			//ANEs
			
			
			
			addCheckBox('Distriqt CameraUI','distriqtCameraUI')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.CameraUI")
				.setWiki("https://distriqt.github.io/ANE-CameraUI/");
			var milkman_push:ACheckBox = 
				addCheckBox('Milkman Easy Push','MilkmanNotification',function(check:ACheckBox){
				if(check.status)
				{
					distriqt_onesignal.status = false ;
					distriqt_firebase.status = false ;
				}
			});
			var distriqt_onesignal:ACheckBox = 
				addCheckBox('Distriqt Push Notifications OneSignal','distriqtNotification',function(check:ACheckBox){
				if(check.status)
				{
					milkman_push.status = false ; 
					distriqt_firebase.status = false ;
				}
			})
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.PushNotifications")
				.setWiki("https://distriqt.github.io/ANE-PushNotifications/s.OneSignal");
			
			var distriqt_firebase:ACheckBox = 
				addCheckBox('Distriqt Push Notifications Firebase','distriqtNotificationFirebase',function(check:ACheckBox){
				if(check.status)
				{
					milkman_push.status = false ;
					distriqt_onesignal.status = false ;
				}
			})
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.PushNotifications")
				.setWiki("https://distriqt.github.io/ANE-PushNotifications/s.Firebase%20Cloud%20Messaging")
				.addCustomANE(xmlFolder,"com.distriqt.CustomResources.ane",generateFCMforDistriqt);
			addCheckBox('Distriqt Share','distriqtShare',function(check:ACheckBox){
				addPDFReader.useSecondAndroid = check.status ;
				//Alert.show("addPDFReader.useSecondAndroid : "+addPDFReader.useSecondAndroid);
			})
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.Share")
					.setWiki("https://distriqt.github.io/ANE-Share/");
			var addPDFReader:ACheckBox = addCheckBox('Distriqt PDF Reader','distriqtPdf')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.PDFReader")
				.setWiki("https://distriqt.github.io/ANE-PDFReader/");
			addCheckBox('Distriqt Media Player','distriqtMediaPlayer')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.MediaPlayer")
				.setWiki("https://distriqt.github.io/ANE-MediaPlayer/");
			addCheckBox('Flashvisions Video Gallery','flashvisionsVideoGallery');
			addCheckBox('Distriqt Scanner','distriqtScanner')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.Scanner")
				.setWiki("https://distriqt.github.io/ANE-Scanner/");
			addCheckBox('Default Manifests','baseXMLs',null,false,true);
			addCheckBox('Distriqt Location','distriqtLocation')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.Location")
				.setWiki("https://airnativeextensions.com/extension/com.distriqt.Location");
			addCheckBox('Distriqt Audio Recorder','distriqtAudioRecorder')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.AudioRecorder")
				.setWiki("https://distriqt.github.io/ANE-AudioRecorder/");
			addCheckBox('Distriqt Native WebView','distriqtNativeWebView')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.NativeWebView")
				.setWiki("https://distriqt.github.io/ANE-NativeWebView/");
			addCheckBox('Distriqt Native Maps','distriqtNativeMap')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.NativeMaps")
				.setWiki("https://distriqt.github.io/ANE-NativeMaps/");
			addCheckBox('JK Local Notifications','JKLocalNotifications');
			addCheckBox('SystemProperties (mateusz)','SystemProperties');
			
			addCheckBox('Distriqt Adverts','distriqtAdverts')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Adverts")
				.setWiki("https://distriqt.github.io/ANE-Adverts/");

			addCheckBox('Distriqt Application','distriqtApplication')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Application")
				.setWiki("https://distriqt.github.io/ANE-Application/");

			addCheckBox('Distriqt Application Rater','distriqtApplicationRater')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.ApplicationRater")
				.setWiki("https://distriqt.github.io/ANE-ApplicationRater/");

			addCheckBox('Distriqt Battery','distriqtBattery')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Battery")
				.setWiki("https://distriqt.github.io/ANE-Battery/");

			addCheckBox('Distriqt Beacon','distriqtBeacon')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Beacon")
				.setWiki("https://distriqt.github.io/ANE-Beacon/");
				
			addCheckBox('Distriqt Bluetooth','distriqtBluetooth')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Bluetooth")
				.setWiki("https://distriqt.github.io/ANE-Bluetooth/");
				
			addCheckBox('Distriqt Bluetooth LE','distriqtBluetoothLE')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.BluetoothLE")
				.setWiki("https://distriqt.github.io/ANE-BluetoothLE/");
				
			addCheckBox('Distriqt Branch','distriqtBranch',function(check:ACheckBox):void
				{
					if(check.enabled)
					{
						uriLauncher.status = true ;
					}
				}
			).setInfo("https://airnativeextensions.com/extension/io.branch.nativeExtensions.Branch")
				.setWiki("https://github.com/distriqt/ANE-BranchIO/wiki")
				
			addCheckBox('Distriqt Calendar','distriqtCalendar')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Calendar")
				.setWiki("https://distriqt.github.io/ANE-Calendar/");
				
			addCheckBox('Distriqt Camera','distriqtCamera')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Camera")
				.setWiki("https://distriqt.github.io/ANE-Camera/");
				
			addCheckBox('Distriqt Camera Roll Extended','distriqtCameraRollExtended')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.CameraRollExtended")
				.setWiki("https://distriqt.github.io/ANE-CameraRollExtended/");
				
			addCheckBox('Distriqt CloudStorage','distriqtCloudStorage')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.CloudStorage")
				.setWiki("https://distriqt.github.io/ANE-CloudStorage/");
				
			addCheckBox('Distriqt Compass','distriqtCompass')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Compass")
				.setWiki("https://distriqt.github.io/ANE-Compass/");
				
			addCheckBox('Distriqt Contacts','distriqtContacts')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Contacts")
				.setWiki("https://distriqt.github.io/ANE-Contacts/");
				
			addCheckBox('Distriqt Device Motion','distriqtDeviceMotion')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.DeviceMotion")
				.setWiki("https://distriqt.github.io/ANE-DeviceMotion/");
			
			addCheckBox('Distriqt Dialog','distriqtDialog')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Dialog")
				.setWiki("https://distriqt.github.io/ANE-Dialog/");
			
			addCheckBox('Distriqt Exceptions','distriqtExceptions')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Exceptions");
			
			addCheckBox('Distriqt Expansion Files','distriqtExpansionFiles')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.ExpansionFiles")
				.setWiki("https://distriqt.github.io/ANE-ExpansionFiles/");
			
			addCheckBox('Distriqt Facebook API','distriqtFacebookAPI')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.FacebookAPI")
				.setWiki("https://distriqt.github.io/ANE-FacebookAPI/");
			
			addCheckBox('Distriqt Firebase','distriqtFirebase')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Firebase")
				.setWiki("https://distriqt.github.io/ANE-Firebase/");
			
			
			
			//More setting needed to receive [APPGROUP] from user
			addCheckBox('Distriqt AppGroup Defaults','distriqtAppGroupDefaults')
				.setInfo("https://airnativeextensions.com/extension/com.distriqt.AppGroupDefaults")
				.setWiki("https://distriqt.github.io/ANE-AppGroupDefaults/");
			
			addCheckBox('Distriqt Flurry','distriqtFlurry')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Flurry")
				.setWiki("https://distriqt.github.io/ANE-Flurry/");
				
			
			addCheckBox('Distriqt Force Touch','distriqtForceTouch')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Flurry")
				.setWiki("https://distriqt.github.io/ANE-Flurry/");
			
			addCheckBox('Distriqt Game Services','distriqtGameServices')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Flurry")
				.setWiki("https://distriqt.github.io/ANE-Flurry/");
			
			addCheckBox('Distriqt Google Analytics','distriqtGoogleAnalytics')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.GoogleAnalytics")
				.setWiki("https://distriqt.github.io/ANE-GoogleAnalytics/");
			
			addCheckBox('Distriqt Google Identity','distriqtGoogleIdentity')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.GoogleIdentity")
				.setWiki("https://distriqt.github.io/ANE-GoogleIdentity/");
			
			addCheckBox('Distriqt Google Plus','distriqtGooglePlus')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.GooglePlus")
				.setWiki("https://distriqt.github.io/ANE-GooglePlus/");
			
			addCheckBox('Distriqt Google Tag Manager','distriqtGoogleTagManager')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.GoogleTagManager")
				.setWiki("https://distriqt.github.io/ANE-GoogleTagManager/");
				
			
			addCheckBox('Distriqt Gyroscope','distriqtGyroscope')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Gyroscope")
				.setWiki("https://distriqt.github.io/ANE-Gyroscope/");
			
			addCheckBox('Distriqt IDFA','distriqtIDFA')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.IDFA")
				.setWiki("https://distriqt.github.io/ANE-IDFA/");
			
			addCheckBox('Distriqt Image','distriqtImage')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Image")
				.setWiki("https://distriqt.github.io/ANE-Image/");
			
			addCheckBox('Distriqt InApp Billing','distriqtInAppBilling')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.InAppBilling")
				.setWiki("https://distriqt.github.io/ANE-InAppBilling/");
			
			addCheckBox('Distriqt JobScheduler','distriqtJobScheduler')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.JobScheduler")
				.setWiki("https://github.com/distriqt/ANE-JobScheduler/wiki");
			
			addCheckBox('Distriqt Local Auth','distriqtLocalAuth')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.LocalAuth")
				.setWiki("https://distriqt.github.io/ANE-LocalAuth/");
			
			addCheckBox('Distriqt Memory','distriqtMemory')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Memory")
				.setWiki("https://github.com/distriqt/ANE-Memory");
			
			addCheckBox('Distriqt Message','distriqtMessage')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Message")
				.setWiki("https://distriqt.github.io/ANE-Message/");
			
			addCheckBox('Distriqt Network Info','distriqtNetworkInfo')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.NetworkInfo")
				.setWiki("https://distriqt.github.io/ANE-NetworkInfo/");
			
			addCheckBox('Distriqt NFC','distriqtNFC')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.NFC")
				.setWiki("https://distriqt.github.io/ANE-NFC/");
			
			addCheckBox('Distriqt OCR','distriqtOCR')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.OCR")
				.setWiki("https://distriqt.github.io/ANE-OCR/");
				
			
			addCheckBox('Distriqt Parse','distriqtParse')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Parse")
				.setWiki("https://distriqt.github.io/ANE-Parse/");
			
			addCheckBox('Distriqt PayPal SDK','distriqtPayPalSDK')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.PayPalSDK")
				.setWiki("https://distriqt.github.io/ANE-PayPalSDK/");
			
			addCheckBox('Distriqt Permissions','distriqtPermissions')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Permissions")
				.setWiki("https://distriqt.github.io/ANE-Permissions/");
			
			addCheckBox('Distriqt System Gestures','distriqtSystemGestures')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.SystemGestures")
				.setWiki("https://distriqt.github.io/ANE-SystemGestures/");
			
			addCheckBox('Distriqt System Vibration','distriqtVibration')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Vibration")
				.setWiki("https://distriqt.github.io/ANE-Vibration/");
			
			addCheckBox('Distriqt Volume','distriqtVolume')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Volume")
				.setWiki("https://distriqt.github.io/ANE-Volume/");

			addCheckBox('Distriqt WebP','distriqtWebP')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.WebP")
				.setWiki("https://distriqt.github.io/ANE-WebP/");

			addCheckBox('Distriqt Zip Utils','distriqtZipUtils')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.ZipUtils")
				.setWiki("https://distriqt.github.io/ANE-ZipUtils/");

			addCheckBox('Distriqt Local Notifications','distriqtLocalNotification')
			.setInfo("https://airnativeextensions.com/extension/com.distriqt.Notifications")
				.setWiki("https://distriqt.github.io/ANE-Notifications/");

			addCheckBox('Background Location(iOS)','backgroundLocation');
			addCheckBox('Background Audio(iOS)','backgroundAudio');
				
			
			////Permissions
			
			
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
			
			var permSaveMC:ACheckBox = Obj.get("write_file_mc",this);
			permSaveMC.setUp(false,'Save File Access','saveFile');
			checkList.push(permSaveMC);
			
			clearMC.addEventListener(MouseEvent.CLICK,resetEarlierPermissions);
			
			updateInformations();
			
			
			NativeDragManager.acceptDragDrop(manifestLoaderMC);
			NativeDragManager.acceptDragDrop(loadMobileProvisionMC);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragged);
			
			searchMC.setUp('Search:','',null,false,true,false,1,1,1,0,null,false,false,null,null,true,true,false);
			searchMC.addEventListener(Event.RENDER,updateANEList);
			
			//Order items by their priorities
			checkList.sort(function(a:ACheckBox,b:ACheckBox){
				if(a.getPriority()<b.getPriority())
				{
					return 1
				}
				else if(a.getPriority()>b.getPriority())
				{
					return -1 ;
				}
				return 0 ;
			})
			
			updateANEList();
		}
		
		protected function updateANEList(event:Event=null):void
		{
			trace(searchMC.text);
			var checkBoxY:Number = 20 ;
			
			
			for(var i:int = 0 ; i<checkList.length ; i++)
			{
				var checkBox:ACheckBox = checkList[i] ;
				if(checkBox.addItToList)
				{
					if( searchMC.text=='' || checkBox.match(searchMC.text))
					{
						checkBox.x = (nativeCheckContainerMC.width-checkBox.width)/2;
						checkBox.y = checkBoxY ;
						checkBoxY += checkBox.height ;
						nativeCheckContainerMC.addChild(checkBox);
						checkBox.visible = true ;
					}
					else
					{
						checkBox.y = 0 ; 
						checkBox.visible = false ;
						//checkBox.alpha = 0.5 ;
					}
				}
			}
				
		}
		
		protected function onDragged(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			currentFile = files[0];
			var arrPath:Array = currentFile.name.split('.');
			var type:String = arrPath[arrPath.length-1];
			if (!currentFile.isDirectory && (type == 'xml')) {
				NativeDragManager.acceptDragDrop(this);
				this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			}
			else if (!currentFile.isDirectory && (type == 'mobileprovision')) {
				NativeDragManager.acceptDragDrop(this);
				this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppedMobileProvision);
			}
		}
		
		private function onDropped(event:NativeDragEvent):void
		{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			loadThisManifestXML(currentFile);
		}
		
		private function onDroppedMobileProvision(event:NativeDragEvent):void
		{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppedMobileProvision);
			mobileProvissionSelected(currentFile);
		}
		
		
		private function resetEarlierPermissions(e:MouseEvent):void
		{
			manifestGenerate.resetPermissions();
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
			field_teamIdMC.text = manifestGenerate.getTeamId() ;
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
		}
		
			private function mobileProvissionSelected(fil:File):void
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
		
		private function addDefaultManifestFrom(folder:File,useSecondModelForAndroid:Boolean = false):void
		{
			if(useSecondModelForAndroid)
			{
				//Alert.show("The second manifest for android");
				manifestGenerate.addAndroidPermission(TextFile.load(folder.resolvePath("android_manifest2.xml")));
			}
			else
				manifestGenerate.addAndroidPermission(TextFile.load(folder.resolvePath("android_manifest.xml")));
			
			manifestGenerate.addIosEntitlements(TextFile.load(folder.resolvePath("ios_Entitlements.xml")));
			manifestGenerate.addInfoAdditions(TextFile.load(folder.resolvePath("ios_infoAdditions.xml")));
			manifestGenerate.addExtension(TextFile.load(folder.resolvePath("extension.xml")));
		}
		
		private function checkIfExistsBefor(folder:File):Boolean
		{
			var con1:Boolean = manifestGenerate.doAndroidPermissionHave(TextFile.load(folder.resolvePath("android_manifest.xml")));
			if(con1 == false && folder.resolvePath("android_manifest2.xml").exists)
			{
				con1 = manifestGenerate.doAndroidPermissionHave(TextFile.load(folder.resolvePath("android_manifest2.xml")));
			}
			var con2:Boolean = manifestGenerate.doIosEntitlementsHave(TextFile.load(folder.resolvePath("ios_Entitlements.xml")));
			var con3:Boolean = manifestGenerate.doInfoAdditionsHave(TextFile.load(folder.resolvePath("ios_infoAdditions.xml")));
			if(con1 && con2 && con3)
			{
				return manifestGenerate.haveExtension(TextFile.load(folder.resolvePath("extension.xml")));
			}
			return false ;
		}
		
		private function removeDefaultManifestFrom(folder:File):void
		{
			manifestGenerate.removeAndroidPermission(TextFile.load(folder.resolvePath("android_manifest.xml")));
			manifestGenerate.removeAndroidPermission(TextFile.load(folder.resolvePath("android_manifest2.xml")));
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
			//trace("mainXMLFile : "+mainXMLFile.nativePath);
			
			for(var i:int = 0 ; i<checkList.length ; i++)
			{
				nativeFolder = xmlFolder.resolvePath(checkList[i].folderName);
				if(!checkList[i].status)
				{
					removeDefaultManifestFrom(nativeFolder);
				}
			}
			
			var warningList:String = '' ;
			
			for(i = 0 ; i<checkList.length ; i++)
			{
				nativeFolder = xmlFolder.resolvePath(checkList[i].folderName);
				if(checkList[i].status)
				{
					addDefaultManifestFrom(nativeFolder,checkList[i].useSecondAndroid);
					var warningFile:File = nativeFolder.resolvePath('warning.txt');
					if(warningFile.exists)
					{
						warningList += TextFile.load(warningFile)+'\n\n' ;
					}
				}
			}
			FileManager.browseToSave(saveFileThere,"Select a destination for your new Manifest file",'xml');
			
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
				
				
				var fileTarget2:File ;
				
				if(newDistManifest!=null)
				{
					var distName:String = fileTarget.name.split('.'+fileTarget.extension).join('');
					fileTarget2 = fileTarget.parent.resolvePath(distName+'-dist.xml');
					TextFile.save(fileTarget2,newDistManifest);
				}
				if(warningList!='')
				{
					warnButtonMC.visible = true ;
					ShowWarning(warningList,
						function(e=null){
							fileTarget.openWithDefaultApplication();
							if(fileTarget2)
								fileTarget2.openWithDefaultApplication();
						}
					);
				}
				else
				{
					warnButtonMC.visible = false ;
				}
			}
		}
		
		/**Show the warning message on the screen*/
		private function ShowWarning(warningText:String,onClosed:Function=null):void
		{
			lastWarningText = warningText ;
			lastWarningFunction = onClosed ;
			openLastWarning(null);
		}
		
			/**Open the warning window from the last warning text*/
			private function openLastWarning(e:MouseEvent):void
			{
				warningMC.show(lastWarningText,lastWarningFunction);
			}
		
		private function loadExistingManifest(e:MouseEvent):void
		{
			FileManager.browse(loadThisManifestXML,['*.xml']);
			
		}
		
		
		private function loadThisManifestXML(fileTarget:File):void
		{
			mainXMLFile = fileTarget ;
			trace("Loaded file is : "+fileTarget.nativePath);
			trace("mainXML file is : "+mainXMLFile.nativePath);
			//convertSampleXML();
			manifestExporterMC.visible = true ;
			manifestGenerate.convert(TextFile.load(mainXMLFile));
			manifestGenerate.uriLauncher = schemFromId() ;
			
			
			updateInformations();
		}





	////////////////////////////////////////////////ANE Settings part

		private var generateFCMforDistriqt:Function ;

		private var allFCMIcons:AllFCMIcons,
					basicFCMIcons:Sprite ;

		private var fcmAdvancedButton:SwitchButtonAnimated ;

		private function setUpFCMForDistriqt():void
		{
			const 	id_latest_image:String = "id_latest_image4",
					id_last_selected_image:String = "id_last_selected_image",
					id_fcm_advanced_mode:String = "id_fcm_advanced_mode",
					id_last_google_service:String = "id_last_google_service" ;

			var selectedImageIndex:int = GlobalStorage.load(id_last_selected_image) as int ;

			var lastSelectedImageIndex:int = -1 ;

			var imageUpdated:Boolean = false ;
			
			var fcmGeneratorMC:MovieClip,
				imageAreaMC:MovieClip,
				loadImageMC:MovieClip,
				googleServiceTitle:TitleText,
				setGoogleServiceMC:MovieClip,
				cancelMC:MovieClip,
				saveMC:MovieClip;

			var imageW:Number,
				imageH:Number,
				margin:Number = 20 ;

			const iconFixPart1:String = "META-INF/ANE/Android-ARM/distriqt-extension-customresources-res/";
			const iconFixPart2:String = "META-INF/ANE/Android-x86/distriqt-extension-customresources-res/";

			var client_id:String = null ;
			var jsonObject:GoogleServiceJSON = new GoogleServiceJSON();

			/**ANE file */
			var fcmImage1:LightImage;
			/**User's file */
			var fcmImage2:LightImage;
			/**App icon file */
			var fcmImage3:LightImage;

			/**FCM images frame */
			var selectedImageFrame:Sprite ;

			/**ANE file sample */
			var aneFile:File ;
			var googleFile:File ;

			fcmGeneratorMC = Obj.get("distiqt_fcm_mc",this);
			allFCMIcons = Obj.get("all_icons_mc",fcmGeneratorMC);
			fcmAdvancedButton = Obj.get("advanced_switch_mc",fcmGeneratorMC);
			fcmAdvancedButton.status = Boolean(GlobalStorage.load(id_fcm_advanced_mode));
			basicFCMIcons = new Sprite();
			fcmGeneratorMC.addChild(basicFCMIcons);
			imageAreaMC = Obj.get("image_area_mc",fcmGeneratorMC);
			loadImageMC = Obj.get("change_icon_mc",fcmGeneratorMC);
			loadImageMC.buttonMode = true ;
			googleServiceTitle = Obj.get("google_service_txt",fcmGeneratorMC);
			setGoogleServiceMC = Obj.get("set_google_services_mc",fcmGeneratorMC);
			cancelMC = Obj.get("cancel_mc",fcmGeneratorMC);
			saveMC = Obj.get("save_mc",fcmGeneratorMC);
			saveMC.buttonMode = true ;
			imageAreaMC.visible = false ;

			saveMC.mouseEnabled = false;
			saveMC.mouseChildren = false ;
			saveMC.alpha = 0.5;
			saveMC.addEventListener(MouseEvent.CLICK,saveANEFile);

			
			var iconList:Array = [] ;
			var iconSize:Array = [] ;

			
			iconList.push("drawable-mdpi/ic_stat_distriqt.png");
			iconSize.push(25);
			iconList.push("drawable-mdpi-v11/ic_stat_distriqt.png");//W
			iconSize.push(24);
			iconList.push("drawable-hdpi/ic_stat_distriqt.png");
			iconSize.push(38);
			iconList.push("drawable-hdpi-v11/ic_stat_distriqt.png");//W
			iconSize.push(36);
			iconList.push("drawable-xhdpi/ic_stat_distriqt.png");
			iconSize.push(50);
			iconList.push("drawable-xhdpi-v11/ic_stat_distriqt.png");//W
			iconSize.push(48);
			iconList.push("drawable-xxhdpi/ic_stat_distriqt.png");
			iconSize.push(75);
			iconList.push("drawable-xxhdpi-v11/ic_stat_distriqt.png");//W
			iconSize.push(72);
			iconList.push("drawable-xxxhdpi/ic_stat_distriqt.png");
			iconSize.push(100);
			iconList.push("drawable-xxxhdpi-v11/ic_stat_distriqt.png");//W
			iconSize.push(96);

			//??DO not save duplicate item for each size. set icon sizes then duplicate them

			allFCMIcons.setUp(iconList);

			fcmAdvancedButton.addEventListener(Event.CHANGE,showAdvancedOptionOrBasic);
			function showAdvancedOptionOrBasic(e:Event=null){
				GlobalStorage.save(id_fcm_advanced_mode,fcmAdvancedButton.status);
				allFCMIcons.visible = fcmAdvancedButton.status ;
				loadImageMC.visible = basicFCMIcons.visible = !fcmAdvancedButton.status ;
				//Whant to reset allFCMLIcon? 
			}
			showAdvancedOptionOrBasic();

			function saveANEFile(e:Event):void
			{
				onGoolgeJSONSelected(googleFile);

				var i:int;
				var data:XML = <resources>
									<string name="default_web_client_id" translatable="false">{client_id}</string>
									<string name="firebase_database_url" translatable="false">{jsonObject.project_info.firebase_url}</string>
									<string name="gcm_defaultSenderId" translatable="false">{jsonObject.project_info.project_number}</string>
									<string name="google_api_key" translatable="false">{jsonObject.client[0].api_key[0].current_key}</string>
									<string name="google_app_id" translatable="false">{jsonObject.client[0].client_info.mobilesdk_app_id}</string>
									<string name="google_crash_reporting_api_key" translatable="false">{jsonObject.client[0].api_key[0].current_key}</string>
									<string name="google_storage_bucket" translatable="false">{jsonObject.project_info.storage_bucket}</string>
								</resources>;
				//var whereToSave:File = File.desktopDirectory.resolvePath('ane2.ane') ;


				var bitmapToReplace:BitmapData ;
				switch(selectedImageIndex)
				{
					case 2:
						bitmapToReplace = fcmImage2.getBitmapData();
						break;
					case 3:
						bitmapToReplace = fcmImage3.getBitmapData();
						break;
				}

				//Alert.show("selectedImageIndex : "+selectedImageIndex+" > "+bitmapToReplace+" vs "+fcmImage2.getBitmapData());

				var zip:FZip = new FZip();
				//zip.addEventListener(Event.OPEN, onOpen);
				zip.addEventListener(Event.COMPLETE, onComplete);
				zip.load(new URLRequest(aneFile.url));

				function onComplete(e:*=null):void
				{
					for( i=0 ; i<zip.getFileCount() ; i++)
					{
						var fileName:String = zip.getFileAt(i).filename ;
						if(fileName == "META-INF/ANE/Android-ARM/distriqt-extension-customresources-res/values/values.xml")
						{
							trace("File remvoed! : "+fileName);
							zip.removeFileAt(i);
							zip.addFileFromStringAt(i,"META-INF/ANE/Android-ARM/distriqt-extension-customresources-res/values/values.xml",'<?xml version="1.0" encoding="utf-8"?>'+data.toXMLString());
						}
						if(fileName == "META-INF/ANE/Android-x86/distriqt-extension-customresources-res/values/values.xml")
						{
							trace("File remvoed! : "+fileName);
							zip.removeFileAt(i);
							zip.addFileFromStringAt(i,"META-INF/ANE/Android-x86/distriqt-extension-customresources-res/values/values.xml",'<?xml version="1.0" encoding="utf-8"?>'+data.toXMLString());
						}
						
						for(var j:int = 0 ; j<iconList.length ; j++)
						{
							trace("iconFixPart1+iconList[i] : "+iconFixPart1+iconList[j]+" vs "+fileName)
							if(iconFixPart1+iconList[j] == fileName || iconFixPart2+iconList[j] == fileName)
							{
								//Alert.show("File must replace : "+fileName);
								zip.removeFileAt(i);
								zip.addFileAt(i,fileName,BitmapEffects.createPNG(BitmapEffects.changeSize(allFCMIcons.getImage(iconList[j]),iconSize[j],iconSize[j],true,true)));
							}
						}
					}


					FileManager.browseForDirectory(aneDirectorySelected,'Select a directory for your custom ane file');

					function aneDirectorySelected(aneDirectory:File):void
					{
						const nativeFolderName:String = 'native';
						if(aneDirectory.name!=nativeFolderName)
						{
							aneDirectory = aneDirectory.resolvePath(nativeFolderName);
							aneDirectory.createDirectory();
						}
						aneDirectory = aneDirectory.resolvePath(aneFile.name);
						var targetStream:FileStream = new FileStream();
						targetStream.open(aneDirectory,FileMode.WRITE);
						zip.serialize(targetStream);
						targetStream.close();

						fcmGeneratorMC.visible = false ;
					}
				}
			}
			
			setGoogleServiceMC.buttonMode = true ;
			setGoogleServiceMC.addEventListener(MouseEvent.CLICK,loadGoogleServiceJSON);
			var lastGoogleServiceFileURL:String = GlobalStorage.load(id_last_google_service);
			if(lastGoogleServiceFileURL!=null && new File(lastGoogleServiceFileURL).exists)
			{
				onGoolgeJSONSelected(new File(lastGoogleServiceFileURL));
			}

			function loadGoogleServiceJSON(e:MouseEvent):void
			{
				FileManager.browse(onGoolgeJSONSelected,['*.json'],"Select google-services.json");
			}


			imageW = (imageAreaMC.width-margin*2)/3;
			imageH = imageAreaMC.height ;

			fcmImage1 = new LightImage();
			basicFCMIcons.addChild(fcmImage1);
			fcmImage1.buttonMode = true ;
			fcmImage1.addEventListener(MouseEvent.CLICK,function(e){
				selectedImageIndex = 1 ;
				GlobalStorage.save(id_last_selected_image,selectedImageIndex);
			});

			selectedImageFrame = new Sprite();
			selectedImageFrame.graphics.lineStyle(5,0xffffff);
			selectedImageFrame.graphics.drawRoundRect(0,0,imageW,imageH,10,10);
			basicFCMIcons.addChild(selectedImageFrame);
			selectedImageFrame.y = fcmImage1.y = imageAreaMC.y ;



			fcmImage2 = new LightImage();
			basicFCMIcons.addChild(fcmImage2);
			fcmImage2.y = imageAreaMC.y ;
			fcmImage2.setUp('');
			fcmImage2.buttonMode = true ;
			fcmImage2.addEventListener(Event.COMPLETE,updateImagePosition);
			fcmImage2.addEventListener(MouseEvent.CLICK,function(e){
				selectedImageIndex = 2 ;
				GlobalStorage.save(id_last_selected_image,selectedImageIndex);
			});

			fcmImage3 = new LightImage();
			basicFCMIcons.addChild(fcmImage3);
			fcmImage3.y = imageAreaMC.y ;
			fcmImage3.setUp('');
			fcmImage3.buttonMode = true ;
			fcmImage3.addEventListener(MouseEvent.CLICK,function(e){
				selectedImageIndex = 3 ;
				GlobalStorage.save(id_last_selected_image,selectedImageIndex);
			});

			this.addEventListener(Event.ENTER_FRAME,updateSelectedImageInterface);
			

			function updateSelectedImageInterface(e:Event):void
			{
				var selectedItemAlpha:Number = 1.0;
				var unselectedItemAlpha:Number = 0.3 ;
				
				var image1Alpha:Number = unselectedItemAlpha,
					image2Alpha:Number = unselectedItemAlpha,
					image3Alpha:Number = unselectedItemAlpha;


				var selectedImage:LightImage ;

				switch(selectedImageIndex)
				{
					case 0:
					case 1:
						image1Alpha = selectedItemAlpha ;
						selectedImage = fcmImage1;
						break;
					case 2:
						image2Alpha = selectedItemAlpha ;
						selectedImage = fcmImage2;
						break;
					case 3:
						image3Alpha = selectedItemAlpha ;
						selectedImage = fcmImage3;
						break;
				}

				if((lastSelectedImageIndex!=selectedImageIndex && selectedImage.getBitmapData()!=null) || imageUpdated)
				{
					lastSelectedImageIndex = selectedImageIndex ;
					//Alert.show("Selected image on "+selectedImageIndex+" is : "+selectedImage);
					allFCMIcons.setDefaultImage(selectedImage.getBitmapData());

					imageUpdated = false ;
				}

				fcmImage1.alpha += (image1Alpha-fcmImage1.alpha)/4;
				fcmImage2.alpha += (image2Alpha-fcmImage2.alpha)/4;
				fcmImage3.alpha += (image3Alpha-fcmImage3.alpha)/4;

				selectedImageFrame.x += (selectedImage.x-selectedImageFrame.x)/4;
			}

			updateImagePosition();

			function updateImagePosition(e:*=null):void
			{
				if(fcmImage2.getBitmapData()!=null && fcmImage3.getBitmapData()!=null)
				{
					fcmImage2.x = imageAreaMC.x + imageW+margin;
					fcmImage1.x = imageAreaMC.x ;
					fcmImage3.x = imageAreaMC.x+(imageW)*2+margin*2 ;
				}
				else if(fcmImage2.getBitmapData()!=null && fcmImage3.getBitmapData()==null)
				{
					fcmImage2.x = imageAreaMC.x + imageW+margin+(imageW+margin)/2;
					fcmImage1.x = imageAreaMC.x +(imageW+margin)/2;
				}
				else if(fcmImage3.getBitmapData()!=null && fcmImage2.getBitmapData()==null)
				{
					fcmImage3.x = imageAreaMC.x + imageW+margin+(imageW+margin)/2;
					fcmImage1.x = imageAreaMC.x +(imageW+margin)/2;
				}
				else if(fcmImage2.getBitmapData()==null && fcmImage3.getBitmapData()==null)
				{
					fcmImage1.x = imageAreaMC.x + imageW+margin;
					selectedImageIndex = 1 ;
				}
			}

			fcmGeneratorMC.visible = false ;
			

			cancelMC.buttonMode = true ;
			cancelMC.addEventListener(MouseEvent.CLICK,function(e){
				fcmGeneratorMC.visible = false ;
			});

			loadImageMC.addEventListener(MouseEvent.CLICK,loadNewImageForFCM);


			///Cash latest file
			var cashedImageURL:String = GlobalStorage.load(id_latest_image);
			if(cashedImageURL!=null && new File(cashedImageURL).exists)
			{
				onNewIconFoundedForFCM(new File(cashedImageURL),false);
			}
			

			function loadNewImageForFCM(e:MouseEvent):void
			{
				FileManager.browse(onNewIconFoundedForFCM,['*.jpg;*.jpeg;*.JPG;*.JPEG;*.png;*.PNG'],"Select a notification icon (Black and white and transparent image preferred)");
			}

			function onNewIconFoundedForFCM(SelectedImageFile:File,updateImage:Boolean=true):void
			{
				selectedImageIndex = 2 ;
				GlobalStorage.save(id_latest_image,SelectedImageFile.url)
				fcmImage2.setUp(SelectedImageFile.url,true,imageW,imageH);
				updateImagePosition();
				imageUpdated = updateImage ;
			}
			function onGoolgeJSONSelected(googleFiles:File):void
			{
				googleFile = googleFiles; 
				var jsonString:String = TextFile.load(googleFile);
				if(jsonString==null)
					return;
				jsonObject = new GoogleServiceJSON();
				try
				{
					JSONParser.parsParams(JSON.parse(jsonString),jsonObject);
				}
				catch(e){}

				if(jsonObject.client.length==0)
				{
					Alert.show("Google-services file has problem!");
					GlobalStorage.save(id_last_google_service,null);
							
					saveMC.mouseEnabled = false;
					saveMC.alpha = 0.5;
					googleServiceTitle.setUp('',false);
					return;
				}
				else
				{
					GlobalStorage.save(id_last_google_service,googleFile.url);
				}
				
				
				client_id = null ;
				for(var iii:int = 0 ; iii<jsonObject.client[0].oauth_client.length ; iii++)
				{
					if(jsonObject.client[0].oauth_client[iii].client_type==3)
					{
						client_id = jsonObject.client[0].oauth_client[iii].client_id ;
						break ;
					}
				}

				saveMC.mouseEnabled = true;
				saveMC.alpha = 1;
				googleServiceTitle.setUp(jsonObject.project_info.storage_bucket,false);

			}

			generateFCMforDistriqt = function generateFCMforDistriqt(aneFiles:File):void
			{
				aneFile = aneFiles ;
				fcmGeneratorMC.visible = true;
				if(iconGenerator.cashedBitmap!=null)
				{
					fcmImage3.setUpBitmapData(iconGenerator.cashedBitmap.clone(),true,imageW,imageH,0,0,true);
				}
				else
				{
					fcmImage3.setUp('');
					if(selectedImageIndex==3)
					{
						if(fcmImage2.getBitmapData()!=null)
							selectedImageIndex = 2 ;
						else
							selectedImageIndex = 1 ;
					}
				}
				updateImagePosition();

				var zip:FZip = new FZip();
					//zip.addEventListener(Event.OPEN, onOpen);
				zip.addEventListener(Event.COMPLETE, onComplete);
				zip.load(new URLRequest(aneFile.url));

				function onComplete(e:*=null):void
				{
					var sampleImage:FZipFile = zip.getFileByName(iconFixPart2+"drawable-xxxhdpi-v11/ic_stat_distriqt.png");
					fcmImage1.setUpBytes(sampleImage.content,true,imageW,imageH,0,0,true);
				}
			}
		}

		private function saveAllanesToProjectPath(e:MouseEvent):void
		{
			var neededExtensionList:Array = [] ;
			var anyANESelected:Boolean = false ;
			for(var i:int = 0 ; i<checkList.length ; i++)
			{
				if(checkList[i].status)
				{
					var extensionListFile:File = xmlFolder.resolvePath(checkList[i].folderName).resolvePath("extension.xml");
					if(extensionListFile.exists)
					{
						try
						{
							var loadedExtensionsXMLList:XMLList = new XMLList(TextFile.load(extensionListFile));
							if(anyANESelected==false)
								anyANESelected = loadedExtensionsXMLList.length()>0 ;
							for(var j:int = 0 ; j<loadedExtensionsXMLList.length() ; j++)
							{
								if(neededExtensionList.indexOf(loadedExtensionsXMLList[j].toString())==-1)
								neededExtensionList.push(loadedExtensionsXMLList[j].toString());
							}
						}
						catch(e){}
					}
				}
			}
			if(anyANESelected==false)
			{
				Alert.show("You don't need to have any native file.");
				return;
			}
			var aneFiles:Vector.<File> = new Vector.<File>();
			for(i = 0 ; i<neededExtensionList.length ; i++)
			{
				var aneFile:File = aneDirectory.resolvePath(neededExtensionList[i]+".ane");
				if(aneFile.exists)
				{
					neededExtensionList.removeAt(i);
					i--;
					aneFiles.push(aneFile);
				}
			}

			if(aneFiles.length==0)
			{
				Alert.show("You don't have any of these ane files on your local directory. Get them online.");
			}
			else
			{
				FileManager.browseForDirectory(function(nativeDirectory:File){
					if(nativeDirectory.name != 'native')
					{
						nativeDirectory = nativeDirectory.resolvePath('native');
						if(!nativeDirectory.exists)
						{
							nativeDirectory.createDirectory();
						}
						var allExistingANEFiles:Array = nativeDirectory.getDirectoryListing();
						for(i = 0 ; i<allExistingANEFiles.length ; i++)
						{
							var aneF:File = allExistingANEFiles[i] as File ;
							if(aneF.name.toLowerCase().indexOf('custom')==-1)
							{
								try
								{
									if(aneF.isDirectory)
									{
										FileManager.deleteAllFiles(aneF);
									}
									else
									{
										aneF.deleteFile();
									}
								}
								catch(e:Error){
									//Alert.show("Proplem on file Delet"+e.message)
								};
							}
						}
						for(i = 0 ; i<aneFiles.length ; i++)
						{
							aneFiles[i].copyTo(nativeDirectory.resolvePath(aneFiles[i].name),true);
						}
					}

				},"Select you project directory to store all required native files there.")
			}
			if(neededExtensionList.length>0)
			{
				var warning:String = 'You should add these ANE files to your native folder manualy.\n\n' ;
				for(i = 0 ; i<neededExtensionList.length ; i++)
				{
					warning += neededExtensionList[i]+'\n';
				}
				warningMC.show(warning);
			}
		}
	}
}