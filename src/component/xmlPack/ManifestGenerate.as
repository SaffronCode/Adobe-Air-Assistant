package component.xmlPack
{
	import com.mteamapp.StringFunctions;
	import com.mteamapp.XMLFunctions;
	
	import contents.alert.Alert;
	
	import dataManager.GlobalStorage;
	
	import flash.utils.ByteArray;

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
		
		private const id_storage:String = "id_storage" ;
		
		public var teamId:String = '' ;
		
		///Name spaces
		private const airNSURI:String = "http://ns.adobe.com/air/application/" ;
		private var airNameSpace:String ;
		
		//Extentions
		private var extensionsList:Vector.<String> = new Vector.<String>();
		//Parameters
		public var 	airVersion:String = '29.0',
					id:String='com.mteamapps.saffron',
					versionNumber:String = '0.0.0',
					description:String = '';
		
		private var _uriLauncher:String = "" ;
		
		/**Dont use complex charachters for this field*/
		public var filename:String="Saffron";
		/**This is the application name.*/
		public var name:String ="Saffron";
		public var copyright:String ="MTeam Co.";
		
		//initialWindow
		public var content:String = "Saffrony.swf" ;
		public var systemChrome:String = "standard" ;
		public var transparent:Boolean = false ;
		public var visible:Boolean = true ;
		public var fullScreen:Boolean = false ;
		
		/**gpu or cpu*/
		public var renderMode:String = "gpu"
		
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
			var lastSavedStatus:Object = GlobalStorage.load(id_storage);
			for(var i in lastSavedStatus)
			{
				if(this.hasOwnProperty(i))
				{
					try
					{
						this[i] = lastSavedStatus[i] ;
					}
					catch(e){}
				}
			}
			
			airNameSpace = airNSURI+airVersion ;
			if(airVersion.indexOf('.')==-1)
			{
				airVersion = airVersion+'.0';
			}
			this.iconsList = iconsList ;
			this.airVersion = airVersion ;
			updateXML();
			
			androidPermission = new AndroidPermission();
			iOSPermission = new IOSPermission();
			
			setAppId(id);
		}
		
		
		private function saveCurrentStatusToCash(e:*=null):void
		{
			var obj:Object = JSON.parse(JSON.stringify(this));
			GlobalStorage.save(id_storage,obj);
		}
		
		public function get uriLauncher():String
		{
			return _uriLauncher;
		}

		public function set uriLauncher(value:String):void
		{
			_uriLauncher = value.toLowerCase();
			androidPermission.setAppScheme(_uriLauncher);
			iOSPermission.setAppScheme(_uriLauncher);
		}

		/**It will creats a final xml based on parameters*/
		private function updateXML():void
		{
			///Main
			mXML = new XML(<application/>);
			mXML.@xmlns = airNSURI+airVersion ;
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
			initialWindow.appendChild(XMLFromId('renderMode'));
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
			
			//Find target air version
			var airVersionURIIndex:int = -1 ;
			if((airVersionURIIndex = oldAppXML.indexOf(airNSURI)) !=-1)
			{
				airVersion = oldAppXML.substring(airVersionURIIndex+airNSURI.length,oldAppXML.indexOf('"',airVersionURIIndex));
			}
			
			airNameSpace = airNSURI+airVersion ;
			
			var convertedXML:XML ;
			oldAppXML = oldAppXML.replace(/[\n\r][\t\s]+[\n\r]/gi,'\n');
			oldAppXML = oldAppXML.replace(/[\n\r]{2,}/gi,'\n');
			try{
				convertedXML = XML(oldAppXML);
			}
			catch(e:Error)
			{
				Alert(e);
				return ;
			}
			loadParametersFromXML(convertedXML);
			
			//Load extensions
			var extListContainer:XML = convertedXML.child(new QName(airNameSpace,'extensions'))[0] ;
			var extList:XMLList = new XMLList();
			if(extListContainer!=null)
				extList = extListContainer.child(new QName(airNameSpace,'extensionID'));
			extensionsList = new Vector.<String>();
			for(var i:int = 0 ; i<extList.length() ; i++)
			{
				extensionsList.push(extList[i]);
			}
			
			androidPermission.setAppId(id);
			androidPermission.importPermission(convertedXML.child(new QName(airNameSpace,'android')).child(new QName(airNameSpace,'manifestAdditions')));
			
			iOSPermission.setAppId(id);
			iOSPermission.importInfoAdditions(convertedXML.child(new QName(airNameSpace,'iPhone')).child(new QName(airNameSpace,'InfoAdditions')));
			iOSPermission.importEntitlements(convertedXML.child(new QName(airNameSpace,'iPhone')).child(new QName(airNameSpace,'Entitlements')));
			
			updateXML();
		}
		
		public function setAppId(id:String):void
		{
			this.id = id ;
			iOSPermission.setAppId(id);
			androidPermission.setAppId(id);
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
				if(this[requiredNodeName] is Boolean)
				{
					this[requiredNodeName] = (cNode[0]=='true')?true:false ;
				}
				else if(this[requiredNodeName] is Number)
				{
					this[requiredNodeName] = Number(cNode[0]) ;
				}
				else
				{
					this[requiredNodeName] = cNode[0] ;
				}
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
			XMLFunctions.deleteChildren(manifestAdditions);
			XMLFunctions.deleteChildren(InfoAdditions);
			XMLFunctions.deleteChildren(Entitlements);
			
			manifestAdditions.appendChild(new XML("<![CDATA[\n"+androidPermission.toString()+"\n]]>"));
			InfoAdditions.appendChild(new XML("<![CDATA[\n"+iOSPermission.InfoAdditionsToString()+"\n]]>"));
			Entitlements.appendChild(new XML("<![CDATA[\n"+iOSPermission.EntitlementsToString()+"\n]]>"));

			saveCurrentStatusToCash();
			
			return '<?xml version="1.0" encoding="utf-8" standalone="no" ?>\n'+mXML.toXMLString();
			
		}
		
		/**Dont forget to add  xmlns:android="android"   to the root node of the permission xml to make it work*/
		public function addAndroidPermission(AndroidPermission:String):void
		{
			androidPermission.add(AndroidPermission);
		}

		/**Returns true if the permission was existed*/
		public function doAndroidPermissionHave(AndroidPermission:String):Boolean
		{
			return androidPermission.dohave(AndroidPermission);
		}

		public function removeAndroidPermission(AndroidPermission:String):void
		{
			androidPermission.remove(AndroidPermission);
		}
		
		/**Add the iOS entitlement to the project*/
		public function addIosEntitlements(ios_Entitlements:String=''):void
		{
			if(ios_Entitlements=='')
			{
				return ;
			}
			iOSPermission.addEntitlements(ios_Entitlements)
		}
		
		/**Add the iOS entitlement to the project*/
		public function doIosEntitlementsHave(ios_Entitlements:String=''):Boolean
		{
			return iOSPermission.doEntitlementsHave(ios_Entitlements)
		}
		
		/**Remove xml from iOS*/
		public function removeIosEntitlements(ios_Entitlements:String=''):void
		{
			if(ios_Entitlements=='')
			{
				return ;
			}
			iOSPermission.removeEntitlements(ios_Entitlements)
		}
		
		/**Returns true if all new InfoAdditinons was existed on current application*/
		public function doInfoAdditionsHave(ios_InfoAdditions:String):Boolean
		{
			return iOSPermission.doInfoAdditionsHave(ios_InfoAdditions);
		}
		
		/**Add the iOS InfoAdditions to the project*/
		public function addInfoAdditions(ios_InfoAdditions:String):void
		{
			iOSPermission.addInfoAdditions(ios_InfoAdditions);
		}
		public function removeInfoAdditions(ios_InfoAdditions:String):void
		{
			iOSPermission.removeInfoAdditions(ios_InfoAdditions);
		}
		
		/**Extension xml list file<br/><br/>
		 * <extensionID>com.distriqt.Core</extensionID><br/>
    <extensionID>com.distriqt.androidsupport.V4</extensionID><br/>
    <extensionID>com.distriqt.androidsupport.CustomTabs</extensionID><br/>
    <extensionID>com.distriqt.Firebase</extensionID><br/>
    <extensionID>com.distriqt.playservices.Base</extensionID><br/>
    <extensionID>com.distriqt.PushNotifications</extensionID>*/
		public function addExtension(extensionListXMLList:String):void
		{
			try
			{
				var extensionList:XMLList = new XMLList(extensionListXMLList);
				for(var i:int = 0 ; i<extensionList.length() ; i++)
				{
					if(extensionsList.indexOf(extensionList[i].toString())==-1)
					{
						trace("new extenstion is : "+extensionList[i].toString());
						extensionsList.push(extensionList[i].toString());
					}
				}
				extensionsList.sort(StringFunctions.compairFarsiString) ;
				updateXML();
			}
			catch(e:Error)
			{
				Alert.show(e.toString());
			}
		}
		
		/**Remove extensino from the list*/
		public function removeExtension(extensionListXMLList:String):void
		{
			/*try
			{*/
				var extensionListXML:XMLList = new XMLList(extensionListXMLList);
				for(var i:int = 0 ; i<extensionListXML.length() ; i++)
				{
					var foundedIndex:int = extensionsList.indexOf(extensionListXML[i].toString()) ; 
					if(foundedIndex!=-1)
					{
						extensionsList.removeAt(foundedIndex);
					}
				}
				updateXML();
			/*}
			catch(e:Error)
			{
				//Alert.show(e.toString());
				throw e ;
			}*/
		}
		
		/**It will load the project id and team id from the provision and returns true if no problem occured.*/
		public function addMobileProvission(mobileProvissionString:ByteArray):Boolean
		{
			var xmlStarted:Boolean = false ;
			var pureManifest:String = '' ;
			var tempTexts:String = '' ;
			while(mobileProvissionString.bytesAvailable)
			{
				var char:String = mobileProvissionString.readUTFBytes(1);
				if(char=='<')
				{
					xmlStarted = true ;
					pureManifest += tempTexts;
					tempTexts = char ;
				}
				else if(char=='>')
				{
					tempTexts += char ;
					pureManifest += tempTexts;
					tempTexts = '' ;
					if(pureManifest.lastIndexOf('</plist>')==pureManifest.length-String('</plist>').length)
					{
						break;
					}
				}
				else if(xmlStarted>0)
				{
					tempTexts+=char ;
				}
			}
			var mobileProvission:XML ;
			try
			{
				mobileProvission = new XML(pureManifest);
				teamId = XMLFunctions.getValueOfKey('TeamIdentifier',mobileProvission.dict[0].children()).string[0] ;
				iOSPermission.setTeamId(teamId);
				id = XMLFunctions.getValueOfKey('application-identifier',mobileProvission.dict[0].dict[0].children()) ;
				id = id.split(teamId+'.').join('');
				iOSPermission.setAppId(id);
				return true ;
			}
			catch(e:Error)
			{
				Alert.show("The selected mobile provission got problem");
				return false ;
			}
			return true ;
		}
	}
}