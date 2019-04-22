package
{
	import com.mteamapp.StringFunctions;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	import contents.TextFile;
	import contents.alert.Alert;
	
	import dynamicFrame.FrameGenerator;
	
	import otherPlatforms.dragAndDrow.DragAndDrop;
	import otherPlatforms.dynamicVersionControl.GitHubVersionCheck;
	import otherPlatforms.postMan.PostManToASFiles;
	
	public class WebServiceGenerator extends Sprite
	{
		private static var loggerTF:TextField,
							loggerBackMC:MovieClip;
							
		private var recreateButtonMC:MovieClip ;
		
		private var jsonCreatorButtonMC:MovieClip,
					pasteJSONMC:MovieClip,
					jsonObjectAreaMC:MovieClip;
		
		private var jsonText:TextField,
					asClassName:TextField;
					
					
		private var postmanDropAreaMC:MovieClip,
					button_importJSJON:MovieClip,
					button_import_postmanMC:MovieClip;
		
		public function WebServiceGenerator()
		{
			super();
			FrameGenerator.createFrame(stage);
			
			postmanDropAreaMC = Obj.get("postman_area_mc",this);
			
			button_import_postmanMC = Obj.get("import_mc",this);
			button_import_postmanMC.buttonMode = true ;
			button_import_postmanMC.addEventListener(MouseEvent.CLICK,openFileBrowserToOpenPostmanFile);
			
			recreateButtonMC = Obj.get("recreate_mc",this);
			recreateButtonMC.visible = false ;
			jsonCreatorButtonMC = Obj.get("json_mc",this);
			pasteJSONMC = Obj.get("paste_json_mc",this);
			jsonText = Obj.get("json_txt",this);
			asClassName = Obj.get("as_name_txt",this);
			
			button_importJSJON = Obj.get("import_json_object_mc",this);
			button_importJSJON.buttonMode = true ;
			button_importJSJON.addEventListener(MouseEvent.CLICK,importJSONObject);
			jsonObjectAreaMC = Obj.get("json_object_area_mc",this);
			DragAndDrop.activateDragAndDrop(jsonObjectAreaMC,addThisJSONObject,['json','txt']);
			
			pasteJSONMC.buttonMode = true ;
			pasteJSONMC.addEventListener(MouseEvent.CLICK,function(e){
				jsonText.text = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
			});
			
			loggerBackMC = new MovieClip();
			loggerBackMC.graphics.beginFill(0x000000,0.8);
			loggerBackMC.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.addChild(loggerBackMC);
			loggerTF = new TextField();
			loggerTF.wordWrap = true ;
			loggerTF.width = stage.stageWidth ;
			loggerTF.height = stage.stageHeight ;
			loggerTF.textColor = 0xffffff ;
			this.addChild(loggerTF);
			loggerBackMC.visible = false ;
			loggerTF.visible = false ;
			//loggerBackMC.mouseEnabled = loggerBackMC.mouseChildren = false ;
			loggerBackMC.addEventListener(MouseEvent.CLICK,hideLogger);
			loggerTF.mouseEnabled = false ;
			
			var newVersionMC:MovieClip = Obj.get("new_version_mc",this);
			newVersionMC.visible = false ;
			var hintTF:TextField = Obj.get("hint_mc",newVersionMC);
			newVersionMC.addEventListener(MouseEvent.CLICK,openUpdator);
			GitHubVersionCheck.compairVersionWithOnline("https://raw.githubusercontent.com/SaffronCode/Adobe-Air-Assistant/master/jsnon-postman/JSONtool-app.xml",needToUpdate);
			function needToUpdate():void
			{
				newVersionMC.visible = true ;
				newVersionMC.alpha = 0 ;
				AnimData.fadeIn(newVersionMC);
			}
			
			function openUpdator(e:MouseEvent=null):void
			{
				GitHubVersionCheck.dowloadInstallerAndLaunch("https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/build/JSONtool.air",showDownloadProgress,downloadCompleted);
				
				function showDownloadProgress(precent:Number):void
				{
					hintTF.text = "Please wait ...(%"+precent+")" ;
				}
				
				function downloadCompleted():void
				{
					hintTF.text = "The installer should be open now...";
				}
			}
			
			NativeDragManager.acceptDragDrop(postmanDropAreaMC);
			postmanDropAreaMC.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDraggedForPostman);
			
			recreateButtonMC.addEventListener(MouseEvent.CLICK,createPostManOutPut);
			
			
			if(jsonCreatorButtonMC)
			{
				jsonCreatorButtonMC.addEventListener(MouseEvent.CLICK,createASFilesFromJSON);
				jsonCreatorButtonMC.addEventListener(MouseEvent.MOUSE_OUT,createASFilesFromJSON)
			}
		}
		
		private function addThisJSONObject(jsonObjectFiles:Vector.<File>):void
		{
			jsonObjectFounded(jsonObjectFiles[0]);
		}
		
		/**Load JSON object to the text area*/
		private function importJSONObject(e:MouseEvent):void
		{
			FileManager.browse(jsonObjectFounded,['*.json','*.JSON','*.text',"*.TEXT"],"Select your JSON object file");
		}
		
			private function jsonObjectFounded(selectedFile:File):void
			{
				var loadedJSON:String = TextFile.load(selectedFile);
				try
				{
					JSON.parse(loadedJSON);
					jsonText.text = loadedJSON ;
				}
				catch(e)
				{
					Alert.show("JSON parse error");
				}
			}
		
		/**Hide the logger screen*/
		private function hideLogger(e:MouseEvent):void
		{
			loggerBackMC.visible = false ;
			loggerTF.visible = false ;
		}
		
		protected function createASFilesFromJSON(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_OUT && !event.buttonDown)
			{
				return ;
			}
			trace("Pure json : "+jsonText.text);
			var jsonString:String = jsonText.text;//StringFunctions.utfToUnicode(jsonText.text) ;
			//Remove enters 
			jsonString = jsonString.split('\n').join('').split('\r').join('') ;
			var jsonObject:Object ;
			
			trace("Entered JSON is :\n\n"+jsonString);
			
			try
			{
				jsonObject = JSON.parse(jsonString) ;
			}
			catch(e)
			{
				Alert.show("JSON parse error");
				return ;
			}
			
			if(event.type == MouseEvent.CLICK)
			{
				var asFileTarget:File = new File();
				asFileTarget.addEventListener(Event.SELECT,saveThisJSONTo);
				asFileTarget.browseForDirectory("Select a folder to save your as files");
				
				function saveThisJSONTo(e:Event):void
				{
					trace("Start saving : "+JSON.stringify(jsonObject,null,' '));
					PostManToASFiles.SaveJSONtoAs(jsonObject,asFileTarget,StringFunctions.clearSpacesAndTabs(asClassName.text));
				}
			}
			else if(event.type == MouseEvent.MOUSE_OUT)
			{
				var fileForUser:File = PostManToASFiles.SaveJSONtoAs(jsonObject,File.createTempDirectory(),StringFunctions.clearSpacesAndTabs(asClassName.text));
				DragAndDrop.startDrag(jsonCreatorButtonMC,[fileForUser]);
			}
		}
		
		
		/*private function saveJSONTo(file:File):void
		{
			PostManToASFiles.SaveJSONtoAs(jsonObject,asFileTarget,StringFunctions.clearSpacesAndTabs(asClassName.text));
		}*/
		
		public static function log(str:String):void
		{
			loggerBackMC.visible = true ;
			loggerTF.visible = true ;
			loggerTF.appendText(str+"\n");
			loggerTF.visible = true ;
		}
		
		public static function clearLog():void
		{
			loggerBackMC.visible = false ;
			loggerTF.visible = false ;
			loggerTF.text = '' ;
		}
		
		/*protected function reload(event:MouseEvent):void
		{
			if(currentFile!=null && currentFile.exists)
			{
				clearLog();
				var serviceFolder:File = currentFile.parent.resolvePath(serviceFolderName) ;
				var typeFolders:File = currentFile.parent.resolvePath(dataFolderName) ;
				PostManToASFiles.saveClasses(serviceFolder,TextFile.load(currentFile),typeFolders);
			}
		}*/
		
		private var currentPostManJSONFile:File;

		private var serviceFolderName:String = "service";;

		private var dataFolderName:String = "types";

		protected function onDraggedForPostman(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			currentPostManJSONFile = files[0];
			var arrPath:Array = currentPostManJSONFile.name.split('.');
			var type:String = arrPath[arrPath.length-1];
			if (!currentPostManJSONFile.isDirectory && (type == 'json')) {
				NativeDragManager.acceptDragDrop(this);
				this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppeddForPostman);
			}
		}
		
		private function openFileBrowserToOpenPostmanFile(e:MouseEvent):void
		{
			FileManager.browse(onFileSelected,['*.json','*.JSON'],'Select the Postman output (Collection V2)');
			function onFileSelected(selectedFile:File):void
			{
				currentPostManJSONFile = selectedFile ;
				recreateButtonMC.visible = true ;
			}
		}
		
		private function onDroppeddForPostman(event:NativeDragEvent):void
		{
			clearLog();
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppeddForPostman);
			recreateButtonMC.visible = true ;
			
			createPostManOutPut();
		}
		
			/**Re generate postman file again*/
			private function createPostManOutPut(e:*=null):void
			{
				FileManager.browseForDirecory(selectFolderToSave,"Select the output directory");
				function selectFolderToSave(selectedDirectory:File):void
				{
					var serviceFolder:File = selectedDirectory.resolvePath(serviceFolderName) ;
					serviceFolder.createDirectory();
					var typeFolders:File = selectedDirectory.resolvePath(dataFolderName) ;
					typeFolders.createDirectory();
					PostManToASFiles.saveClasses(serviceFolder,TextFile.load(currentPostManJSONFile),typeFolders);
				}
			}
	}
}