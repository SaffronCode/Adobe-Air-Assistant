package component
	//component.ACheckBox
{
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ACheckBox extends MovieClip
	{
		private var titleTF:TitleText ;
		
		public var folderName:String ;
		
		private var _status:Boolean ;
		
		public var useSecondAndroid:Boolean = false ;
		
		public var info:String ;
		
		public var wiki:String ;
		
		private var distriqtMC:MovieClip ;
		
		private var titleTFX0:Number ;
		
		private var wikiMC:MovieClip,infoMC:MovieClip ;
		
		public function ACheckBox()
		{
			super();
			
			distriqtMC = Obj.get("distriqt_mc",this);
			if(distriqtMC)
				distriqtMC.visible = false ;
			
			wikiMC = Obj.get("help_mc",this);
			if(wikiMC)
			{
				wikiMC.buttonMode = true ;
				wikiMC.visible = false ;
				wikiMC.addEventListener(MouseEvent.CLICK,openHelp);
			}
			infoMC = Obj.get("info_mc",this);
			if(infoMC)
			{
				infoMC.buttonMode = true ;
				infoMC.visible = false ;
				infoMC.addEventListener(MouseEvent.CLICK,openInfo);
			}
			
			
			titleTF = Obj.findThisClass(TitleText,this);
			if(titleTF)
				titleTFX0 = titleTF.x ;
			this.addEventListener(MouseEvent.CLICK,changeStatus);
			this.stop();
		}
		
		/**Open the info page*/
		protected function openInfo(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(info));
			event.stopImmediatePropagation();
		}
		
		/**Open the help page*/
		protected function openHelp(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(wiki));
			event.stopImmediatePropagation();
		}
		
		public function setInfo(infoURL:String):ACheckBox
		{
			info = infoURL ;
			
			if(info!=null && infoMC!=null)
				infoMC.visible = true ;
			return this ;
		}
		
		public function setWiki(wikiURL:String):ACheckBox
		{
			wiki = wikiURL ;
			
			if(wiki!=null && wikiMC!=null)
				wikiMC.visible = true ;
			return this;
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
			const distriqtName:String = "distriqt" ;
			if(distriqtMC!=null && label.toLowerCase().indexOf(distriqtName)!=-1)
			{
				label = label.substring(distriqtName.length);
				distriqtMC.visible = true ;
				if(titleTF)
					titleTF.x = distriqtMC.x+distriqtMC.width ;
			}
			else if(distriqtMC!=null)
			{
				distriqtMC.visible = false ;
				if(titleTF)
					titleTF.x = titleTFX0 ;
			}
			
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