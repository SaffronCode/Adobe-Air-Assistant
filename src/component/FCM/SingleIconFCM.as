package component.FCM
//component.FCM.SingleIconFCM
{
    import flash.display.MovieClip;
    import contents.alert.Alert;
    import flash.display.BitmapData;
    import appManager.displayContentElemets.LightImage;

    public class SingleIconFCM extends MovieClip
    {
        private var icon:LightImage ;

        public function SingleIconFCM(iconFolder:String)
        {
            super();

            icon = Obj.findThisClass(LightImage,this);
        }


        public function setIcon(iconBitmap:BitmapData):void
        {
            //Alert.show("iconBitmap : "+iconBitmap);
            icon.setUpBitmapData(iconBitmap,true,0,0,0,0,true);
        }
    }
}