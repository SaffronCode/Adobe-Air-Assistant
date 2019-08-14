package component
//component.DefaultImageGenerator
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import flash.filesystem.File;
    import flash.utils.ByteArray;
    import contents.alert.Alert;
    import flash.desktop.NativeDragManager;
    import flash.events.NativeDragEvent;
    import flash.desktop.ClipboardFormats;
    import appManager.displayContentElemets.LightImage;

    public class DefaultImageGenerator extends MovieClip
    {
        private var sampleAreaMC:MovieClip ;
        private var loadImageMC:MovieClip ;
        private var generateDefaultsMC:MovieClip ;

        /**2D array contains name, width and height of each default image */
        private var defaultsLandscape:Array = [['name',10,20]];
        private var defaultsPortrate:Array = [['name',10,20]];


        private var isPortrate:Boolean = false,
                    isLandscape:Boolean = false;

        private var currentFile:File ;

        private var loadedImage:BitmapData ;

        private var sampleImage:LightImage ;

        public function DefaultImageGenerator()
        {
            super();


            loadedImage = new BitmapData(4000,4000,false,0);

            sampleAreaMC = Obj.get("sample_image_area_mc",this);
            sampleImage = new LightImage();
            sampleImage.x = sampleAreaMC.x ;
            sampleImage.y = sampleAreaMC.y ;
            this.addChild(sampleImage);

            loadImageMC = Obj.get("load_default_images_mc",this);
            generateDefaultsMC = Obj.get("generate_default_images_mc",this);

            loadImageMC.addEventListener(MouseEvent.CLICK,function(e){
                FileManager.browse(loadThisImage,['jpg','png','jpeg'],"Select a default image for iOS projects");
            })


            defaultsPortrate = [];
            defaultsPortrate.push(["Default@2x~iphone.png",640,960]);
            defaultsPortrate.push(["Default~iphone.png",640,960]);
            defaultsPortrate.push(["Default-375w-667h@2x~iphone.png",750,1334]);
            defaultsPortrate.push(["Default-414w-736h@3x~iphone.png",1242,2208]);
            defaultsPortrate.push(["Default-568h@2x~iphone.png",640,1136]);
            defaultsPortrate.push(["Default-812h@3x~iphone.png",1125,2436]);
            defaultsPortrate.push(["Default-Portrait@2x.png",2048,2732]);
            defaultsPortrate.push(["Default-Portrait@2x~ipad.png",1536,2048]);
            defaultsPortrate.push(["Default-Portrait~ipad.png",768,1024]);
            defaultsPortrate.push(["Default-Portrait-1112h@2x.png",1668,2224]);
            
            defaultsLandscape = [];
            defaultsLandscape.push(["Default-Landscape@2x.png",2732,2048]);
            defaultsLandscape.push(["Default-Landscape@2x~ipad.png",2048,1536]);
            defaultsLandscape.push(["Default-Landscape~ipad.png",1024,768]);
            defaultsLandscape.push(["Default-Landscape-414w-736h@3x~iphone.png",2208,1242]);
            defaultsLandscape.push(["Default-Landscape-812h@3x~iphone.png",2436,1125]);
            defaultsLandscape.push(["Default-Landscape-1112h@2x.png",2224,1668]);

            generateDefaultsMC.addEventListener(MouseEvent.CLICK,exportDefaults);

            NativeDragManager.acceptDragDrop(this);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragged);
        }

            protected function onDragged(event:NativeDragEvent):void
            {
                var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
                currentFile = files[0];
                var arrPath:Array = currentFile.name.split('.');
                var type:String = String(arrPath[arrPath.length-1]).toLowerCase();
                if (!currentFile.isDirectory && (type == 'jpg' || type == 'png' || type == 'jpeg')) {
                    NativeDragManager.acceptDragDrop(this);
                    this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
                }
            }
            
            private function onDropped(event:NativeDragEvent):void
            {
                this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropped);
                loadThisImage(currentFile);
            }

            private function loadThisImage(imageFile:File):void
            {
                sampleImage.setUp(imageFile.url,false,sampleAreaMC.width,sampleAreaMC.height);
                DeviceImage.loadFile(function(){
                    loadedImage = DeviceImage.imageBitmapData.clone();
                },imageFile,4000,4000);
            }

        public function setToLandscape(status:Boolean=true):void
        {
            isLandscape = status ;
        }

        public function setToPortrate(status:Boolean=true):void
        {
            isPortrate = status ;
        }

        private function exportDefaults(e:MouseEvent):void
        {
            FileManager.browseForDirectory(saveInThisDirectory,"Select your project default directory");
            function saveInThisDirectory(directory:File):void
            {
                if(isPortrate)
                {
                   createAllFilesForTheList(defaultsPortrate,loadedImage,directory);
                }
                if(isLandscape)
                {
                   createAllFilesForTheList(defaultsLandscape,loadedImage,directory);
                }
                Alert.show("Default Images saved on your project directory.")
            }
            
        }

        private function createAllFilesForTheList(list:Array,originalImage:BitmapData,projectDirectory:File):void
        {
            var i:int ;
            var targetFile:File ;
            var fileBytes:ByteArray ;
            for(i = 0 ; i<list.length ; i++ )
            {
                targetFile = projectDirectory.resolvePath(list[i][0]);
                fileBytes = BitmapEffects.createPNG(BitmapEffects.changeSize(originalImage,list[i][1],list[i][2],true,false,true)); 
                FileManager.saveFile(targetFile,fileBytes);
            }
            ScrollMT
        }
    }
}