package component
	//component.WarningShow
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import appManager.displayContentElemets.TextParag;
	
	public class WarningShow extends MovieClip
	{
		private var paragTF:TextParag ;
		
		private var hideButton:MovieClip,okButton:MovieClip,hideButton2:MovieClip ;
		
		private var onDone:Function ;
		
		public function WarningShow()
		{
			super();
			
			paragTF = Obj.findThisClass(TextParag,this);
			hideButton = Obj.get("cancel_mc",this);
			hideButton2 = Obj.get("cancel2_mc",this);
			okButton = Obj.get("open_mc",this);
			hideButton.buttonMode = true ;
			hideButton2.buttonMode = true ;
			okButton.buttonMode = true ;
			
			hide();
			this.alpha = 0 ;
			
			hideButton.addEventListener(MouseEvent.CLICK,hide);
			hideButton2.addEventListener(MouseEvent.CLICK,hide);
			okButton.addEventListener(MouseEvent.CLICK,openForm);
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
			hideButton2.visible = onDone==null ;
			hideButton.visible = okButton.visible = onDone!=null ;
		}
		
		/**Hide warning*/
		public function hide(e:*=null):void
		{
			paragTF.visible = false ;
			this.mouseEnabled = false ;
			this.mouseChildren = false ;
			AnimData.fadeOut(this);
		}
		
		/**Hide warning*/
		public function openForm(e:*=null):void
		{
			if(onDone!=null)
			{
				onDone();
				//onDone = null ;
			}
		}
	}
}