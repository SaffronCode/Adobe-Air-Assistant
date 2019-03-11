package component
	//component.AppIconGenerator
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.system.System;
	
	import appManager.displayContentElemets.LightImage;
	
	import contents.alert.Alert;
	
	public class AppIconGenerator extends MovieClip
	{
		private var sampleImag:LightImage ;
		private var currentFile:File;
		
		private var iconSizes:Array = [];
		
		public var iconDirectoryName:String = "AppIconsForPublish";
		
		public function AppIconGenerator()
		{
			super();
			sampleImag = Obj.findThisClass(LightImage,this);
			
			NativeDragManager.acceptDragDrop(this);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragged);
		}
		
		protected function onDragged(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			currentFile = files[0];
			var arrPath:Array = currentFile.name.split('.');
			var type:String = arrPath[arrPath.length-1];
			if (!currentFile.isDirectory && (type == 'png' || type == 'jpg')) {
				NativeDragManager.acceptDragDrop(this);
				this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			}
		}
		
		private function onDropped(event:NativeDragEvent):void
		{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
			sampleImag.setUp(currentFile.nativePath,true);
			
			var targetFolder:File = new File();
			targetFolder.addEventListener(Event.SELECT,folderSelected);
			targetFolder.browseForDirectory("Where to save your icon package?");
			
			function folderSelected(e):void
			{
				trace("Target Selected : "+targetFolder.nativePath);
				if(targetFolder.name!=iconDirectoryName)
				{
					targetFolder = targetFolder.resolvePath(iconDirectoryName);
					targetFolder.createDirectory();
				}
				DeviceImage.loadFile(imageLoaded,currentFile,1024,1024);
				
				function imageLoaded():void
				{
					for(var i:int = 0 ; i<iconSizes.length ; i++)
					{
						saveIconTo(DeviceImage.imageBitmapData,iconSizes[i],targetFolder);
					}
				}
				
				System.setClipboard("<image16x16>"+iconDirectoryName+"/16.png</image16x16>\n" +
					"<image29x29>"+iconDirectoryName+"/29.png</image29x29>\n" +
					"<image32x32>"+iconDirectoryName+"/32.png</image32x32>\n" +
					"<image36x36>"+iconDirectoryName+"/36.png</image36x36>\n" +
					"<image40x40>"+iconDirectoryName+"/40.png</image40x40>\n" +
					"<image48x48>"+iconDirectoryName+"/48.png</image48x48>\n" +
					"<image50x50>"+iconDirectoryName+"/50.png</image50x50>\n" +
					"<image57x57>"+iconDirectoryName+"/57.png</image57x57>\n" +
					"<image58x58>"+iconDirectoryName+"/58.png</image58x58>\n" +
					"<image60x60>"+iconDirectoryName+"/60.png</image60x60>\n" +
					"<image72x72>"+iconDirectoryName+"/72.png</image72x72>\n" +
					"<image75x75>"+iconDirectoryName+"/75.png</image75x75>\n" +
					"<image76x76>"+iconDirectoryName+"/76.png</image76x76>\n" +
					"<image80x80>"+iconDirectoryName+"/80.png</image80x80>\n" +
					"<image87x87>"+iconDirectoryName+"/87.png</image87x87>\n" +
					"<image100x100>"+iconDirectoryName+"/100.png</image100x100>\n" +
					"<image128x128>"+iconDirectoryName+"/128.png</image128x128>\n" +
					"<image114x114>"+iconDirectoryName+"/114.png</image114x114>\n" +
					"<image120x120>"+iconDirectoryName+"/120.png</image120x120>\n" +
					"<image144x144>"+iconDirectoryName+"/144.png</image144x144>\n" +
					"<image152x152>"+iconDirectoryName+"/152.png</image152x152>\n" +
					"<image167x167>"+iconDirectoryName+"/167.png</image167x167>\n" +
					"<image180x180>"+iconDirectoryName+"/180.png</image180x180>\n" +
					"<image512x512>"+iconDirectoryName+"/512.png</image512x512>\n" +
					"<image1024x1024>"+iconDirectoryName+"/1024.png</image1024x1024>");
				
				//Alert.show("Application Icons xml list saved on your ClipBoard. (ctrl+v)");
			}
			
		}
		
		private function saveIconTo(imageBitmap:BitmapData,imageSize:uint,targetFolder:File):void
		{
			var resizedBitmapData:BitmapData = BitmapEffects.changeSize(imageBitmap,imageSize,imageSize,true,true,true);
			FileManager.seveFile(targetFolder.resolvePath(imageSize+'.png'),BitmapEffects.createPNG(resizedBitmapData));
		}
		
		public function setIconList(iconSizes:Array):void
		{
			this.iconSizes = iconSizes ;
		}
	}
}