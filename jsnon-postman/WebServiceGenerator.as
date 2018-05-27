package
{
	import com.mteamapp.JSONParser;
	import com.mteamapp.StringFunctions;
	
	import contents.TextFile;
	import contents.alert.Alert;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import otherPlatforms.postMan.PostManToASFiles;
	
	import restDoaService.RestDoaService;
	
	public class WebServiceGenerator extends Sprite
	{
		private static var loggerTF:TextField,
							loggerBackMC:MovieClip;
							
		private var recreateButtonMC:MovieClip ;
		
		private var jsonCreatorButtonMC:MovieClip ;
		
		private var jsonText:TextField,
					asClassName:TextField;
		
		public function WebServiceGenerator()
		{
			super();
			FrameGenerator.createFrame(stage);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragged);
			
			recreateButtonMC = Obj.get("recreate_mc",this);
			jsonCreatorButtonMC = Obj.get("json_mc",this);
			jsonText = Obj.get("json_txt",this);
			asClassName = Obj.get("as_name_txt",this);
			
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
			loggerBackMC.mouseEnabled = loggerBackMC.mouseChildren = false ;
			loggerTF.mouseEnabled = false ;
			
			/*var areaMC:Sprite = new Sprite();
			areaMC.graphics.beginFill(0xff0000);
			areaMC.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.addChild(areaMC);
			areaMC.alpha = 0 ;*/
			
			NativeDragManager.acceptDragDrop(this);
			//NativeDragManager.doDrag(;
			
			//var service:String = TextFile.load(File.desktopDirectory.resolvePath("Panjereh-video share.postman_collection.json"));
			//trace(service);
				//PostManToASFiles.saveClasses(File.desktopDirectory.resolvePath('classes'),service);
				//PostManToASFiles.SaveJSONtoAs(JSON.parse(service),File.desktopDirectory.resolvePath('classes'),'PostManMain');
			/*RestDoaService.setUp("http://");
			var myservice:GetVideoGroupComments = new GetVideoGroupComments();
			myservice.load('1026');
			var saveComment:RegisterVideoGroupComment = new RegisterVideoGroupComment();
			saveComment.load('hi',"78f242e7-c6ea-4879-93c0-500032350d65",1026);*/
			
			if(recreateButtonMC)
			{
				recreateButtonMC.addEventListener(MouseEvent.CLICK,reload);
			}
			else
			{
				stage.addEventListener(MouseEvent.CLICK,reload);
			}
			
			
			if(jsonCreatorButtonMC)
			{
				jsonCreatorButtonMC.addEventListener(MouseEvent.CLICK,createASFilesFromJSON);
			}
		}
		
		protected function createASFilesFromJSON(event:MouseEvent):void
		{
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
			
			var asFileTarget:File = new File();
			asFileTarget.addEventListener(Event.SELECT,saveThisJSONTo);
			asFileTarget.browseForDirectory("Select a folder to save your as files");
			
			function saveThisJSONTo(e:Event):void
			{
				trace("Start saving : "+JSON.stringify(jsonObject,null,' '));
				PostManToASFiles.SaveJSONtoAs(jsonObject,asFileTarget,StringFunctions.clearSpacesAndTabs(asClassName.text));
			}
		}
		
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
		
		protected function reload(event:MouseEvent):void
		{
			if(currentFile!=null && currentFile.exists)
			{
				clearLog();
				var serviceFolder:File = currentFile.parent.resolvePath(serviceFolderName) ;
				var typeFolders:File = currentFile.parent.resolvePath(dataFolderName) ;
				PostManToASFiles.saveClasses(serviceFolder,TextFile.load(currentFile),typeFolders);
			}
		}
		
		private var currentFile:File;

		private var serviceFolderName:String = "service";;

		private var dataFolderName:String = "types";

		protected function onDragged(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			currentFile = files[0];
			var arrPath:Array = currentFile.name.split('.');
			var type:String = arrPath[arrPath.length-1];
			if (!currentFile.isDirectory && (type == 'json' || type == 'txt')) {
				NativeDragManager.acceptDragDrop(this);
				this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			}
		}
		
		private function onDropped(event:NativeDragEvent):void
		{
			clearLog();
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			var serviceFolder:File = currentFile.parent.resolvePath(serviceFolderName) ;
			serviceFolder.createDirectory()
			var typeFolders:File = currentFile.parent.resolvePath(dataFolderName) ;
			typeFolders.createDirectory()
			PostManToASFiles.saveClasses(serviceFolder,TextFile.load(currentFile),typeFolders);
		}
	}
}