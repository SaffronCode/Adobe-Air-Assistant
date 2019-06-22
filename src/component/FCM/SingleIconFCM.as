package component.FCM
//component.FCM.SingleIconFCM
{
    import flash.display.MovieClip;
    import contents.alert.Alert;
    import flash.display.BitmapData;
    import appManager.displayContentElemets.LightImage;
    import appManager.displayContentElemets.TextParag;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.events.Event;
    import flash.utils.setTimeout;

    public class SingleIconFCM extends MovieClip
    {
        private var icon:LightImage ;

        private var paragMC:TextParag ;

        public var fileName:String ;


        private var imageW:Number,imageH:Number,imageX:Number,imageY:Number;

        public function SingleIconFCM(iconFolder:String)
        {
            super();

            fileName = iconFolder ;

            icon = Obj.findThisClass(LightImage,this);
            imageW = icon.width ;
            imageH = icon.height ;
            imageX = icon.x ;
            imageY = icon.y ;
            paragMC = Obj.findThisClass(TextParag,this);
            trace("imageW : "+imageW);
            trace("ImageH : "+imageH);

            var splitedName:Array = iconFolder.split('drawable-');
            var myName:String = splitedName[splitedName.length-1];
            //Alert.show("myName : "+myName);
            myName = myName.substring(0,myName.lastIndexOf('/')-1);
            //Alert.show("myName2 : "+myName);
            paragMC.setUp(myName,false,false);

            this.buttonMode = true ;
            this.addEventListener(MouseEvent.CLICK,replaceMyImage);
            icon.addEventListener(Event.COMPLETE,resizeImage);
        }

        private function resizeImage(e:Event):void
        {
            setTimeout(function(){
                icon.width = imageW ;
                icon.height = imageH ;
                icon.scaleX = icon.scaleY = Math.min(icon.scaleX,icon.scaleY);
                icon.x = imageX + (imageW-icon.width)/2;
                icon.y = imageY + (imageH-icon.height)/2;
            },0);
        }

        private function replaceMyImage(e:MouseEvent):void
        {
            FileManager.browse(newImageSelected,["*.png;*.jpg;*.jpeg;*.PNG;*.JPG;*.JPEG"],"Replace new image with existing one.");
        }

            private function newImageSelected(newImage:File):void
            {
                trace("Update icon position");
                setIcon(newImage);
            }


        public function setIcon(iconBitmap:*):void
        {
            icon.scaleX = icon.scaleY = 1 ;
            trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Load image : "+iconBitmap);
            //Alert.show("iconBitmap : "+iconBitmap);
            if(iconBitmap is BitmapData)
                icon.setUpBitmapData(iconBitmap,true,-1,-1,0,0,true);
            else if(iconBitmap is File)
                icon.setUp(iconBitmap.url,true,-1,-1,0,0,true);
        }


        public function getBitmapData():BitmapData
        {
            return icon.getBitmapData();
        }
    }
}