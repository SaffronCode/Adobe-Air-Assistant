package component
	//component.AppIconGenerator
{
	import appManager.displayContentElemets.LightImage;
	
	import contents.alert.Alert;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.system.System;
	
	public class AppIconGenerator extends MovieClip
	{
		private var sampleImag:LightImage ;
		private var currentFile:File;
		
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
				DeviceImage.loadFile(imageLoaded,currentFile,1024,1024);
				
				function imageLoaded():void
				{
					saveIconTo(DeviceImage.imageBitmapData,16,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,29,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,32,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,36,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,57,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,114,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,512,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,48,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,72,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,50,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,58,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,100,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,144,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,1024,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,40,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,76,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,80,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,120,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,128,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,152,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,180,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,60,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,75,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,87,targetFolder);
					saveIconTo(DeviceImage.imageBitmapData,167,targetFolder);
				}
				
				System.setClipboard("<image16x16>AppIconsForPublish/16.png</image16x16>\n" +
					"<image29x29>AppIconsForPublish/29.png</image29x29>\n" +
					"<image32x32>AppIconsForPublish/32.png</image32x32>\n" +
					"<image36x36>AppIconsForPublish/36.png</image36x36>\n" +
					"<image40x40>AppIconsForPublish/40.png</image40x40>\n" +
					"<image48x48>AppIconsForPublish/48.png</image48x48>\n" +
					"<image50x50>AppIconsForPublish/50.png</image50x50>\n" +
					"<image57x57>AppIconsForPublish/57.png</image57x57>\n" +
					"<image58x58>AppIconsForPublish/58.png</image58x58>\n" +
					"<image60x60>AppIconsForPublish/60.png</image60x60>\n" +
					"<image72x72>AppIconsForPublish/72.png</image72x72>\n" +
					"<image75x75>AppIconsForPublish/75.png</image75x75>\n" +
					"<image76x76>AppIconsForPublish/76.png</image76x76>\n" +
					"<image80x80>AppIconsForPublish/80.png</image80x80>\n" +
					"<image87x87>AppIconsForPublish/87.png</image87x87>\n" +
					"<image100x100>AppIconsForPublish/100.png</image100x100>\n" +
					"<image128x128>AppIconsForPublish/128.png</image128x128>\n" +
					"<image114x114>AppIconsForPublish/114.png</image114x114>\n" +
					"<image120x120>AppIconsForPublish/120.png</image120x120>\n" +
					"<image144x144>AppIconsForPublish/144.png</image144x144>\n" +
					"<image152x152>AppIconsForPublish/152.png</image152x152>\n" +
					"<image167x167>AppIconsForPublish/167.png</image167x167>\n" +
					"<image180x180>AppIconsForPublish/180.png</image180x180>\n" +
					"<image512x512>AppIconsForPublish/512.png</image512x512>\n" +
					"<image1024x1024>AppIconsForPublish/1024.png</image1024x1024>");
				
				Alert.show("Application Icons xml list saved on your ClipBoard. (ctrl+v)");
			}
			
		}
		
		private function saveIconTo(imageBitmap:BitmapData,imageSize:uint,targetFolder:File):void
		{
			var resizedBitmapData:BitmapData = BitmapEffects.changeSize(imageBitmap,imageSize,imageSize,true,false,true);
			FileManager.seveFile(targetFolder.resolvePath(imageSize+'.png'),BitmapEffects.createPNG(resizedBitmapData));
		}
	}
}