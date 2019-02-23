package component
	//component.WarningShow
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import appManager.displayContentElemets.TextParag;
	
	public class WarningShow extends MovieClip
	{
		private var paragTF:TextParag ;
		
		private var hideButton:MovieClip ;
		
		private var onDone:Function ;
		
		public function WarningShow()
		{
			super();
			
			paragTF = Obj.findThisClass(TextParag,this);
			hideButton = Obj.get("ok_mc",this);
			hideButton.buttonMode = true ;
			
			hide();
			this.alpha = 0 ;
			
			hideButton.addEventListener(MouseEvent.CLICK,hide);
		}
		
		/**Show the warning*/
		public function show(text:String,onClosed:Function=null):void
		{
			onDone = onClosed ;
			paragTF.setUp(text.replace(/[\n\r]{1,2}/g,'\n'),false,true,false,false,true,true,false,true,true,true,true,2);
			paragTF.visible = true ;
			this.mouseEnabled = true ;
			this.mouseChildren = true ;
			AnimData.fadeIn(this);
		}
		
		/**Hide warning*/
		public function hide(e:*=null):void
		{
			if(onDone!=null)
			{
				onDone();
				onDone = null ;
			}
			paragTF.visible = false ;
			this.mouseEnabled = false ;
			this.mouseChildren = false ;
			AnimData.fadeOut(this);
		}
	}
}