package component
	//component.ACheckBox
{
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ACheckBox extends MovieClip
	{
		private var titleTF:TitleText ;
		
		public var folderName:String ;
		
		public function ACheckBox()
		{
			super();
			titleTF = Obj.findThisClass(TitleText,this);
			this.addEventListener(MouseEvent.CLICK,changeStatus);
			this.stop();
		}
		
		protected function changeStatus(event:MouseEvent):void
		{
			this.gotoAndStop(((this.currentFrame-1)+1)%this.totalFrames+1);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set status(val:Boolean):void
		{
			if(val)
			{
				this.gotoAndStop(2);
			}
			else
			{
				this.gotoAndStop(1);
			}
		}
		
		public function get status():Boolean
		{
			return this.currentFrame == 2 ;
		}
		
		public function setUp(status:Boolean=false,label:String='',folderName:String=''):void
		{
			this.folderName = folderName ;
			titleTF.setUp(label,false,false,0,false) ;
			if(status)
			{
				gotoAndStop(2);
			}
		}
	}
}