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
		
		public function IOSPermission()
		{
			resetInfoAdditionsXML();
			Entitlements = new XML();
		}
		
		private function resetInfoAdditionsXML():void
		{
			InfoAdditions = new XML(<a/>);
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
			xmlString = xmlString.replace(/BUNDLE_SEED_ID/g,teamId);
			xmlString = xmlString.replace(/BUNDLE_IDENTIFIER/g,appId);
			return xmlString ;
		}
		
		public function EntitlementsToString():String
		{
			return insertAppIdAndTeamIds(Entitlements.children().toXMLString());
		}
		
		public function setAppId(id:String):void
		{
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
							XMLFunctions.removeKeyValue(Entitlements,newList[i]);
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
							XMLFunctions.removeKeyValue(InfoAdditions,newList[i]);
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
			this.teamId = teamId ;
		}
	}
}