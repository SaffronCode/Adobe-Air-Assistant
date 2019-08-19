package component.xmlPack
{
	import com.mteamapp.XMLFunctions;
	
	import contents.alert.Alert;

	public class IOSPermission
	{
		private var InfoAdditions:XML ;
		private var Entitlements:XML ;
		
		private var appId:String ;
		private var teamId:String ;
		private var URIScheme:String ;
		
		public function IOSPermission()
		{
			resetInfoAdditionsXML();
		}
		
		private function resetInfoAdditionsXML():void
		{
			reset();
		}
		
		public function reset():void
		{
			InfoAdditions = new XML(<a/>);
			Entitlements = new XML(<a/>);
			addDefaultInfoAditions();			
		}
		
		private function addDefaultInfoAditions():void
		{
			addInfoAdditions('<key>UIDeviceFamily</key>'+
								'<array>'+
									'<string>1</string>'+
									'<string>2</string>'+
								'</array>');
		}
		
		public function importInfoAdditions(InfoAdditionsXMLString:String):void
		{
			try
			{
				resetInfoAdditionsXML();
				var xmlList:XMLList = new XMLList(InfoAdditionsXMLString);
				InfoAdditions.appendChild(xmlList);
			}
			catch(e:Error)
			{
				//Alert.show(e.message);
				throw e ;
			}
		}
		
		public function importEntitlements(EntitlementsXMLString:String):void
		{
			try
			{
				Entitlements = new XML(<a/>);
				var xmlList:XMLList = new XMLList(EntitlementsXMLString);
				Entitlements.appendChild(xmlList);
				for(var i:int = 0 ; i<xmlList.length() ; i++)
				{
					if((xmlList[i] as XML).name() == "key" && String(xmlList[i]) == "application-identifier" && i<xmlList.length()-1)
					{
						var teamPart:String = String(xmlList[i+1]) ;
						var teamPartSplited:Array = teamPart.split('.');
						if(teamPart.length>0 && teamPartSplited.length>1)
						{
							teamId = teamPartSplited[0] ;
						}
						break;
					}
				}
			}
			catch(e:Error)
			{
				Alert.show("Your iOS Entitlements had problem. solve the problem first : \n\n"+e.message);
			}
		}
		
		public function InfoAdditionsToString():String
		{
			return insertAppIdAndTeamIds(InfoAdditions.children().toXMLString());
		}
		
		private function insertAppIdAndTeamIds(xmlString:String):String
		{
			if(xmlString==null)
				return null ;
			xmlString = xmlString.replace(/BUNDLE_SEED_ID/g,teamId);
			xmlString = xmlString.replace(/null/g,teamId);
			xmlString = xmlString.replace(/BUNDLE_IDENTIFIER/g,appId);
			xmlString = xmlString.replace(/YOUR_APPLICATION_IDENTIFIER/g,appId);
			xmlString = xmlString.replace(/APPLICATION_LAUNCHER_ID/g,URIScheme);
			xmlString = xmlString.replace(/URL_SCHEME/g,URIScheme);
			xmlString = xmlString.replace(/URL_NAME/g,URIScheme);
			return xmlString ;
		}
		
		public function EntitlementsToString():String
		{
			return insertAppIdAndTeamIds(Entitlements.children().toXMLString());
		}
		
		public function setAppId(id:String):void
		{
			//reset();
			this.appId = id ;			
		}
		
		
	///////////////////////////////////////////////////
		
		/**Add and update entitlements*/
		public function addEntitlements(entitlements:String):void
		{
			try{
				var newList:XMLList = new XMLList(entitlements);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],Entitlements.children());
						if(foundedElement!=null)
						{
							XMLFunctions.removeKeyValue(Entitlements,newList[i]);
						}
					}
				}
				Entitlements.appendChild(newList);
			}
			catch(e:Error)
			{
				Alert.show("The entered xml Entitlements had problem. \n\n"+entitlements+'\n\n'+e.message);
			}
		}
		
		/**Add and update entitlements*/
		public function doEntitlementsHave(entitlements:String):Boolean
		{
			entitlements = insertAppIdAndTeamIds(entitlements);
			try{
				var newList:XMLList = new XMLList(entitlements);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],Entitlements.children());
						if(foundedElement==null)
						{
							return false ;
						}
					}
				}
				Entitlements.appendChild(newList);
			}
			catch(e:Error)
			{
				Alert.show("The entered xml Entitlements had problem. \n\n"+entitlements+'\n\n'+e.message);
			}
			return true ;
		}
		
		
		public function removeEntitlements(entitlements:String):void
		{
			try{
				var newList:XMLList = new XMLList(entitlements);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],Entitlements.children());
						if(foundedElement!=null)
						{
							if(foundedElement.name()=='array' && newList.length()>i+1 && newList[i+1].name()=='array')
							{
								addStringValueInArray(foundedElement,newList[i+1].children());
								return ;
							}
							else
							{
								XMLFunctions.removeKeyValue(Entitlements,newList[i]);
							}
						}
					}
				}
			}
			catch(e:Error)
			{
				Alert.show("The entered xml Entitlements had problem. \n\n"+entitlements+'\n\n'+e.message);
			}
		}
		
		public function addInfoAdditions(infoAdditions:String):void
		{
			try{
				var newList:XMLList = new XMLList(infoAdditions);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],InfoAdditions.children());
						if(foundedElement!=null)
						{
							if(foundedElement.name()=='array' && newList.length()>i+1 && newList[i+1].name()=='array')
							{
								addStringValueInArray(foundedElement,newList[i+1].children());
								return ;
							}
							else
							{
								XMLFunctions.removeKeyValue(InfoAdditions,newList[i]);
							}
						}
					}
				}
				InfoAdditions.appendChild(newList);
			}
			catch(e:Error)
			{
				Alert.show("The entered xml InfoAdditions had problem. \n\n"+infoAdditions+'\n\n'+e.message);
			}
		}
		
		/**Add string item to a XML list*/
		private function addStringValueInArray(destinationXML:XML,itemNames:XMLList,arreyItemName:String='string'):XML
		{
			var list:XMLList = destinationXML.children();
			for(var j:int = 0 ; j<itemNames.length() ; j++)
			{
				var founded:Boolean = false ;
				var newItemToAdd:String = itemNames[j].toString();
				for(var i:int = 0 ; i<list.length() ; i++)
				{
					if(list[i].toString() == newItemToAdd)
					{
						founded = true ;
						break ;
					}
				}
				if(!founded)
					destinationXML.appendChild(<{arreyItemName}>{newItemToAdd}</{arreyItemName}>);
			}
			return destinationXML ;
		}

		public function getValueOfInfoAddition(keyName:String):XML
		{
			return XMLFunctions.getValueOfKey(keyName,InfoAdditions.children());
		}
		
		/**Returns true if the permissions are already existed on the project*/
		public function doInfoAdditionsHave(infoAdditions:String):Boolean
		{
			infoAdditions = insertAppIdAndTeamIds(infoAdditions);
			try{
				var newList:XMLList = new XMLList(infoAdditions);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],InfoAdditions.children());
						if(foundedElement==null || i==newList.length() || !XMLFunctions.isContain(foundedElement,newList[i+1]))
						{
							return false ;
						}
					}
				}
			}
			catch(e:Error)
			{
				Alert.show("The entered xml InfoAdditions had problem. \n\n"+infoAdditions+'\n\n'+e.message);
			}
			return true ;
		}
		
		
		public function removeInfoAdditions(infoAdditions:String):void
		{
			try{
				var newList:XMLList = new XMLList(infoAdditions);
				for(var i:int = 0 ; i<newList.length() ; i++)
				{
					if(newList[i].name() == 'key')
					{
						var foundedElement:XML = XMLFunctions.getValueOfKey(newList[i],InfoAdditions.children());
						if(foundedElement!=null)
						{
							XMLFunctions.removeKeyValue(InfoAdditions,newList[i]);
						}
					}
				}
			}
			catch(e:Error)
			{
				Alert.show("The entered xml InfoAdditions had problem. \n\n"+infoAdditions+'\n\n'+e.message);
			}
			addDefaultInfoAditions();
		}
		
		public function setTeamId(teamId:String):void
		{
			//reset();
			this.teamId = teamId ;
		}
		
		public function getTeamId():String
		{
			return teamId ;
		}
		
		public function setAppScheme(URIScheme:String):void
		{
			//reset();
			this.URIScheme = URIScheme ;
		}
	}
}