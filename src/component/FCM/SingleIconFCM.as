package component.FCM
//component.FCM.SingleIconFCM
{
    import flash.display.MovieClip;
    import contents.alert.Alert;
    import flash.display.BitmapData;
    import appManager.displayContentElemets.LightImage;
    import appManager.displayContentElemets.TextParag;

    public class SingleIconFCM extends MovieClip
    {
        private var icon:LightImage ;

        private var paragMC:TextParag ;

        public function SingleIconFCM(iconFolder:String)
        {
            super();

            icon = Obj.findThisClass(LightImage,this);
            paragMC = Obj.findThisClass(TextParag,this);

            var splitedName:Array = iconFolder.split('drawable-');
            var myName:String = splitedName[splitedName.length-1];
            //Alert.show("myName : "+myName);
            myName = myName.substring(0,myName.lastIndexOf('/')-1);
            //Alert.show("myName2 : "+myName);
            paragMC.setUp(myName,false,false);
        }


        public function setIcon(iconBitmap:BitmapData):void
        {
            //Alert.show("iconBitmap : "+iconBitmap);
            icon.setUpBitmapData(iconBitmap,true,0,0,0,0,true);
        }
    }
}