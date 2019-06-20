package component.FCM
//component.FCM.AllFCMIcons
{
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.display.Sprite;

    public class AllFCMIcons extends MovieClip
    {
        private var W:Number,H:Number ;

        private var directories:Array = [] ;

        private var icons:Vector.<SingleIconFCM> ;

        private var iconsContainer:Sprite ;

        public function AllFCMIcons()
        {
            super();
            W = super.width;
            H = super.height ;
            this.removeChildren();

            iconsContainer = new Sprite();
            this.addChild(iconsContainer);
            new ScrollMT(iconsContainer,new Rectangle(0,0,W,H),null,false,true);
        }

        public function setUp(directoryNames:Array):void
        {
            iconsContainer.removeChildren();
            directories = directoryNames.concat() ;
            icons = new Vector.<SingleIconFCM>();
            for(var i:int = 0 ; i<directories.length ; i++)
            {
                var icon:SingleIconFCM = new SingleIconFCM();
                icons.push(icon);
                iconsContainer.addChild(icon);
            }
        }

        override public function get width():Number
        {
            return W ;
        }

        override public function get height():Number
        {
            return H ;
        }
    }
}