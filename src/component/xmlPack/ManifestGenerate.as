package component.xmlPack
{
	import contents.alert.Alert;

	public class ManifestGenerate
	{
		/**Manifest XML file*/
		private var mXML:XML ;
		private var initialWindow:XML ;
		private var icon:XML ;
		private var android:XML ;
		private var manifestAdditions:XML ;
		private var iPhone:XML ;
		private var InfoAdditions:XML ;
		private var Entitlements:XML ;
		private var extensions:XML ;
		
		//Parameters
		public var 	airVersion:String = '29.0',
					id:String='com.mteamapps.lego',
					versionNumber:String = '0.0.0',
					description:String = '';
		/**Dont use complex charachters for this field*/
		private var filename:String="Saffrony";
		/**This is the application name.*/
		public var name:String ="Saffron y";
		public var copyright:String ="MTeam Co.";
		
		//initialWindow
		public var content:String = "Saffrony.swf" ;
		private var systemChrome:String = "standard" ;
		private var transparent:Boolean = false ;
		private var visible:Boolean = true ;
		public var fullScreen:Boolean = false ;
		
		/**set the aspectRatio parameter*/
		public const 	aspectRatio_portrait = "portrait",
						aspectRatio_landscape = "landscape";
						//aspectRatio_auto = "auto" ;
		/**aspectRatio_portrait,aspectRatio_landscape*/
		public var aspectRatio:String = aspectRatio_portrait ;
		
		
		public var autoOrients:Boolean = false ;
		public var maximizable:Boolean = true ;
		public var minimizable:Boolean = true ;
		public var resizable:Boolean = true ;
		
		
		//android
		private var containsVideo:Boolean = true ;
		
		//iOS
		private var requestedDisplayResolution:String = "high" ;
		
		////
		private var customUpdateUI:Boolean = false ;
		private var allowBrowserInvocation:Boolean = false ;
		
		
		
		/**16,32,...*/
		private var iconsList:Array ;
		private var androidPermission:AndroidPermission;
		
		public function ManifestGenerate(iconsList:Array,airVersion:String)
		{
			if(airVersion.indexOf('.')==-1)
			{
				airVersion = airVersion+'.0';
			}
			this.iconsList = iconsList ;
			this.airVersion = airVersion ;
			updateXML();
		}
		
		/**It will creats a final xml based on parameters*/
		private function updateXML():void
		{
			///Main
			mXML = new XML(<application/>);
			mXML.@xmlns = 'http://ns.adobe.com/air/application/'+airVersion ;
			mXML.appendChild(XMLFromId('id'));
			mXML.appendChild(XMLFromId('versionNumber'));
			mXML.appendChild(XMLFromId('filename'));
			mXML.appendChild(XMLFromId('description'));
			mXML.appendChild(XMLFromId('name'));
			mXML.appendChild(XMLFromId('copyright'));
			
			///initialWindow
			initialWindow = new XML(<initialWindow/>);
			mXML.appendChild(initialWindow);
			initialWindow.appendChild(XMLFromId('content'));
			initialWindow.appendChild(XMLFromId('systemChrome'));
			initialWindow.appendChild(XMLFromId('transparent'));
			initialWindow.appendChild(XMLFromId('visible'));
			initialWindow.appendChild(XMLFromId('fullScreen'));
			initialWindow.appendChild(XMLFromId('aspectRatio'));
			initialWindow.appendChild(XMLFromId('autoOrients'));
			initialWindow.appendChild(XMLFromId('maximizable'));
			initialWindow.appendChild(XMLFromId('minimizable'));
			initialWindow.appendChild(XMLFromId('resizable'));
			
			///icon
			icon = new XML(<icon/>);
			mXML.appendChild(icon);
			for(var i:int = 0 ; i<iconsList.length ; i++)
			{
				icon.appendChild(makeIconXML(iconsList[i]));
			}
			
			//Android part
			android = new XML(<android/>);
			mXML.appendChild(android);
			manifestAdditions = new XML(<manifestAdditions/>);
			android.appendChild(manifestAdditions);
			
			android.appendChild(XMLFromId('containsVideo'));
			
			androidPermission = new AndroidPermission();
			
			
			//iOS
			iPhone = new XML(<iPhone/>);
			mXML.appendChild(iPhone);
			InfoAdditions = new XML(<InfoAdditions/>);
			iPhone.appendChild(InfoAdditions);
			Entitlements = new XML(<Entitlements/>);
			iPhone.appendChild(Entitlements);
			iPhone.appendChild(XMLFromId('requestedDisplayResolution'));
			
			//Continue
			mXML.appendChild(XMLFromId('customUpdateUI'));
			mXML.appendChild(XMLFromId('allowBrowserInvocation'));
			
			//Native extensions
			extensions = new XML(<extensions/>);
			mXML.appendChild(extensions);
			extensions.appendChild(extensionXML('com.distriqt.Core'));
		}
		
		/**It will catch your old xml file and fit it in the new XML*/
		public function convert(oldAppXML:String):void
		{
			var convertedXML:XML ;
			try{
				convertedXML = XML(oldAppXML);
			}
			catch(e:Error)
			{
				Alert(e.message);
				return ;
			}
			trace(convertedXML.toXMLString());
			updateXML();
		}
		
		/**Creates an extension id*/
		private function extensionXML(extensionId:String):XML
		{
			return <extensionID>{extensionId}</extensionID>;
		}
		
		/**Creats xml line <Id>Id</Id> it will load data varaible from this[Id]*/
		private function XMLFromId(Id:String):XML
		{
			return new XML(<{Id}>{this[Id]}</{Id}>);
		}
		
		/**Icon generator*/
		private function makeIconXML(size:uint):XML
		{
			return new XML('<image'+size+'x'+size+'>AppIconsForPublish/'+size+'.png</image'+size+'x'+size+'>');
		}
		
		public function toString():String
		{
			manifestAdditions.parent().manifestAdditions = new XML("<![CDATA[\n"+androidPermission.toString()+"\n]]>");
			return '<?xml version="1.0" encoding="utf-8" standalone="no" ?>\n'+mXML.toXMLString();
		}
	}
}