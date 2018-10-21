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
		
		private var _status:Boolean ;
		
		public var useSecondAndroid:Boolean = false ;
		
		public function ACheckBox()
		{
			super();
			titleTF = Obj.findThisClass(TitleText,this);
			this.addEventListener(MouseEvent.CLICK,changeStatus);
			this.stop();
		}
		
		public function changeStatus(event:MouseEvent=null):void
		{
			this.gotoAndStop(((this.currentFrame-1)+1)%this.totalFrames+1);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set status(val:Boolean):void
		{
			var lastStatus:Boolean = getStatus();
			if(val)
			{
				this.gotoAndStop(2);
			}
			else
			{
				this.gotoAndStop(1);
			}
			if(lastStatus!=getStatus())
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get status():Boolean
		{
			return getStatus();
		}
		
		private function getStatus():Boolean
		{
			if(this.currentFrame==0)
			{
				return _status ;
			}
			else
			{
				return this.currentFrame == 2 ;
			}
		}
		
		public function setUp(status:Boolean=false,label:String='',folderName:String=''):void
		{
			this.folderName = folderName ;
			if(titleTF)
				titleTF.setUp(label,false,false,0,false) ;
			_status = status ;
			if(status)
			{
				gotoAndStop(2);
			}
		}
	}
}