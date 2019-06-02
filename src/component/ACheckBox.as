package component
	//component.ACheckBox
{
	import animation.Anim_Frame_Controller;
	
	import appManager.displayContentElemets.TitleText;
	
	import dataManager.GlobalStorage;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import spark.components.Label;
	import flash.filesystem.File;
	import contents.alert.Alert;

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
		
		private var wikiMC:MovieClip,infoMC:MovieClip,infoContainerMC:MovieClip,
					infoContainerAnim:Anim_Frame_Controller,
					settingMC:MovieClip;
					
		/**Make it be able to add to the list of ANEs*/
		public var addItToList:Boolean;
		private var myLabel:String;
		
		public function ACheckBox()
		{
			super();
			
			distriqtMC = Obj.get("distriqt_mc",this);
			if(distriqtMC)
				distriqtMC.visible = false ;
			infoContainerMC = Obj.get("info_mc",this);
			if(infoContainerMC)
			{
				infoContainerAnim = new Anim_Frame_Controller(infoContainerMC,0,false);
				infoMC = Obj.get("info_mc",infoContainerMC);
				infoMC.buttonMode = true ;
				infoMC.visible = false ;
				infoMC.addEventListener(MouseEvent.CLICK,openInfo);
				
				infoContainerMC.stop();
				infoContainerMC.addEventListener(MouseEvent.MOUSE_OVER,openInfoEffect);
				infoContainerMC.addEventListener(MouseEvent.MOUSE_OUT,closeInfoEffect);
				
				wikiMC = Obj.get("help_mc",infoContainerMC);
				if(wikiMC)
				{
					wikiMC.buttonMode = true ;
					wikiMC.visible = false ;
					wikiMC.addEventListener(MouseEvent.CLICK,openHelp);
				}
			}
			
			settingMC = Obj.get("setting_mc",this);
			if(settingMC)
			{
				settingMC.visible = false ;
				settingMC.addEventListener(MouseEvent.CLICK,triggerCustomANE,false,2);
				settingMC.buttonMode = true ;
			}
			
			titleTF = Obj.findThisClass(TitleText,this);
			if(titleTF)
				titleTFX0 = titleTF.x ;
			this.addEventListener(MouseEvent.CLICK,changeStatus);
			this.stop();
		}
		
			protected function closeInfoEffect(event:MouseEvent):void
			{
				infoContainerAnim.gotoFrame(1);
			}
			
			protected function openInfoEffect(event:MouseEvent):void
			{
				infoContainerAnim.gotoFrame(infoContainerAnim.totalFrames);
			}
		
		/**Open the info page*/
		protected function openInfo(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(info));
			event.stopImmediatePropagation();
		}
		
		/**Returns item priority based on user click*/
		public function getPriority():uint
		{
			return uint(GlobalStorage.load(myLabel));
		}
		
		/**Increase priority*/
		private function increasePriority():void
		{
			GlobalStorage.save(myLabel,getPriority()+1)
		}
		
		
		public function getLabel():String
		{
			return myLabel ;
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

		public function addSetting(onANEFileLocated:Function):void
		{
			settingMC.visible = true ;
		}
		
		public function changeStatus(event:MouseEvent=null):void
		{
			this.gotoAndStop(((this.currentFrame-1)+1)%this.totalFrames+1);
			this.dispatchEvent(new Event(Event.CHANGE));
			if(getStatus())
			{
				increasePriority();
			}
		}
		
		public function set status(val:Boolean):void
		{
			var lastStatus:Boolean = getStatus();
			if(val)
			{
				increasePriority();
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
			this.myLabel = label ;
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
		
		/**Returns true if the text can be found in its description*/
		public function match(text:String):Boolean
		{
			text = text.replace(/\s{2,}/g,' ').toLowerCase();
			var label:String = getLabel().toLowerCase() ;
			var list:Array = text.split(' ');
			var isFounded:* = null ;
			for(var i:int = 0 ; i<list.length ; i++)
			{
				if(label.indexOf(list[i])!=-1)
				{
					isFounded = isFounded==null?true:isFounded&&true ;
				}
				else
				{
					isFounded = false ;
				}
			}
			return isFounded;
		}



//////////////////////////////////////////////////

		private var myCustomANE:File ;

		private var customButtonTriggered:Function ;

		public function addCustomANE(filesDirectory:File,customAneFileName:String,triggerCustomBuild:Function):ACheckBox
		{
			myCustomANE = filesDirectory.resolvePath(folderName).resolvePath(customAneFileName);
			settingMC.visible = myCustomANE.exists ;
			customButtonTriggered = triggerCustomBuild ;
			return this ;
		}

		private function triggerCustomANE(e:MouseEvent):void
		{
			if(getStatus())
			{
				e.stopImmediatePropagation();
			}
			customButtonTriggered(myCustomANE);
		}
	}
}