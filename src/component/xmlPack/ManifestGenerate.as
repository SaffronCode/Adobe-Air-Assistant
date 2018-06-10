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
		
		///Name spaces
		private var airNameSpace:String = "http://ns.adobe.com/air/application/26.0" ;
		
		//Extentions
		private var extensionsList:Vector.<String> = new Vector.<String>();
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
		private var iOSPermission:IOSPermission ;
		
		public function ManifestGenerate(iconsList:Array,airVersion:String)
		{
			if(airVersion.indexOf('.')==-1)
			{
				airVersion = airVersion+'.0';
			}
			this.iconsList = iconsList ;
			this.airVersion = airVersion ;
			updateXML();
			
			androidPermission = new AndroidPermission();
			iOSPermission = new IOSPermission();
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
			for(var j:int = 0 ; j<extensionsList.length ; j++)
			{
				extensions.appendChild(extensionXML(extensionsList[j]));
			}
		}
		
		/**It will catch your old xml file and fit it in the new XML*/
		public function convert(oldAppXML:String):void
		{
			var convertedXML:XML ;
			oldAppXML = oldAppXML.replace(/[\n\r][\t\s]+[\n\r]/gi,'\n');
			oldAppXML = oldAppXML.replace(/[\n\r]{2,}/gi,'\n');
			try{
				convertedXML = XML(oldAppXML);
			}
			catch(e:Error)
			{
				Alert(e.message);
				return ;
			}
			loadParametersFromXML(convertedXML);
			
			//Load extensions
			var extListContainer:XML = convertedXML.child(new QName(airNameSpace,'extensions'))[0] ;
			var extList:XMLList = extListContainer.child(new QName(airNameSpace,'extensionID'));
			for(var i:int = 0 ; i<extList.length() ; i++)
			{
				extensionsList.push(extList[i]);
			}
			androidPermission.importPermission(convertedXML.child(new QName(airNameSpace,'android')).child(new QName(airNameSpace,'manifestAdditions')));
			iOSPermission.importInfoAdditions(convertedXML.child(new QName(airNameSpace,'iPhone')).child(new QName(airNameSpace,'InfoAdditions')));
			iOSPermission.importEntitlements(convertedXML.child(new QName(airNameSpace,'iPhone')).child(new QName(airNameSpace,'Entitlements')));
			updateXML();
		}
		
		/**Search for nodes on xmls*/
		private function loadParametersFromXML(convertedXML:XML):void
		{
			var ObjectFromThis:Object = JSON.parse(JSON.stringify(this));
			for(var i in ObjectFromThis)
			{
				lookExactlyFor(convertedXML,i);
			}
		}
		
		/**Look for this node name on the list. returns true if node founded*/
		private function lookExactlyFor(convertedXML:XML,requiredNodeName:String=null):Boolean
		{
			//trace("Search for "+requiredNodeName+" in the list "+convertedXML);
			var cNode:XMLList = convertedXML.child(new QName(airNameSpace,requiredNodeName)) ; 
			if(cNode.length()==1)
			{
				this[requiredNodeName] = cNode[0] ;
				trace(">> "+requiredNodeName+" sat to "+this[requiredNodeName]);
				return true ;
			}
			else
			{
				var list:XMLList = convertedXML.children() ;
				var l:uint = list.length() ;
				//trace("list:"+list);
				//trace("length : "+lenght);
				for(var j:int = 0 ; l>1 && j<l ; j++)
				{
					//trace(" \n\n\n\n\nItem is : "+list[j]+" is it xml? "+XML(list[j]));
					var isFounded:Boolean;
					isFounded = lookExactlyFor(XML(list[j]),requiredNodeName);
					if(isFounded)
					{
						return true ;
					}
				}
				//trace("Cannot find "+requiredNodeName);
				return false ;
			}
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
			manifestAdditions.appendChild(new XML("<![CDATA[\n"+androidPermission.toString()+"\n]]>"));
			InfoAdditions.appendChild(new XML("<![CDATA[\n"+iOSPermission.InfoAdditionsToString()+"\n]]>"));
			Entitlements.appendChild(new XML("<![CDATA[\n"+iOSPermission.EntitlementsToString()+"\n]]>"));
			return '<?xml version="1.0" encoding="utf-8" standalone="no" ?>\n'+mXML.toXMLString();
		}
	}
}