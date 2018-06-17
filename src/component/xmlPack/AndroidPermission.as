package component.xmlPack
{
	import contents.alert.Alert;
	

	public class AndroidPermission
	{
		private var main:XML ;
		private const androidNameSpace:String = "android";
		private const xmlPerfix:String = ' xmlns:android="'+androidNameSpace+'"';
		
		private var appId:String ;
		
		public function AndroidPermission()
		{
			main = new XML();
		}
		
		public function setAppId(appId:String):void
		{
			this.appId = appId ;
		}
		
		public function importPermission(permissionXML:String):void
		{
			permissionXML = permissionXML.replace('<manifest','<manifest'+xmlPerfix) ;
			try
			{
				main = XML(permissionXML) ;
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		public function toString():String
		{
			var stringFormat:String = main.toXMLString() ;
			stringFormat = stringFormat.replace(xmlPerfix,'');
			return stringFormat;
		}
		
		/**It will replace APPLICATION_PACKAGE with the ap id*/
		public function add(AndroidPermissionXMLString:String):void
		{
			AndroidPermissionXMLString = AndroidPermissionXMLString.replace(/APPLICATION_PACKAGE/gi,appId);
			var AndroidPermissionXML:XML ;
			try
			{
				AndroidPermissionXML = new XML(AndroidPermissionXMLString.replace('<manifest','<manifest'+xmlPerfix));
			}
			catch(e:Error)
			{
				Alert.show(e.message);
				return ;
			}
			main = mergeToXML(main,AndroidPermissionXML);
		}
		private function mergeToXML(firstXML:XML,secXML:XML):XML
		{
			trace("secXML: "+secXML+'\n\n'+'*****************************'+'\n\n\n)');
			var firstList:XMLList = firstXML.children() ;
			var secondList:XMLList = secXML.children() ;
			
			for(var i:int = 0 ; i<secondList.length() ; i++)
			{
				if(secondList[i].name() == 'com.onesignal.GcmBroadcastReceiver')
				{
					var what:String = 'hapend';
					trace('android:name="com.onesignal.GcmBroadcastReceiver"');
					
				}
				trace("secondList["+i+"].name() : "+secondList[i].name());
				var nodeUpdated:Boolean = false ;
				for(var j:int = 0 ; j<firstList.length() ;j++)
				{
					if(secondList[i].name()==firstList[j].name())
					{
						var s1:XML = secondList[i] ;
						var s2:XML = firstList[j] ;
						switch(String(secondList[i].name()))
						{
							case "application":
								nodeUpdated = true ;
								mergAributes(s2,s1);
								if(s1.hasComplexContent())
								{
									mergeToXML(s2,s1);
								}
							break;
							default:
								if(	haveSaveAtributes(s1,s2))
								{
									trace("Duplicated atributes");
									nodeUpdated = true ;
									
									if(s1.hasComplexContent())
									{
										mergeToXML(s2,s1);
									}
									j = firstList.length() ;
								}
							break;
						}
					}
				}
				if(!nodeUpdated)
				{
					trace("This node is new : "+secondList[i].toXMLString());
					firstXML.appendChild(secondList[i]);
				}
			}
			
			return firstXML ;
		}
		
		/**Check if two node had save atributes*/
		private function haveSaveAtributes(s1:XML, s2:XML):Boolean
		{
			var fatrib:XMLList = s1.attributes() ;
			var satrib:XMLList = s2.attributes() ;
			for(var i:int = 0 ; i<fatrib.length() ; i++)
			{
				var a1:XML = fatrib[i];
				for(var j:int = 0 ; j<satrib.length() ; j++)
				{
					var a2:XML = satrib[j];
					trace(a1.name()+' vs '+a2.name());
					if(a1.name() == a2.name())
					{
						trace(a1+' vs2 '+a2);
						if(a1 != a2)
						{
							return false ;
						}
					}
				}
			}
			return true ;
		}
		
		private function mergAributes(firstNode:XML,secondNode:XML):void
		{
			var fatrib:XMLList = firstNode.attributes() ;
			var satrib:XMLList = secondNode.attributes() ;
			for(var i:int = 0 ; i<satrib.length() ; i++)
			{
				var atribFounded:Boolean = false ;
				var a2:XML = satrib[i];
				for(var j:int = 0 ; j<fatrib.length() ; j++)
				{
					var a1:XML = fatrib[j];
					if(a1.name()==a2.name())
					{
						trace("a1 : "+a1);
						trace("a2 : "+a2);
						if(!isNaN(Number(a1)) && !isNaN(Number(a2)))
						{
							atribFounded = true ;
							firstNode.@[a2.name()] = Math.max(Number(a2),Number(a1)) ;
							break ;
						}
						else if(a1==a2)
						{
							atribFounded = true ;
							break ;
						}
						else
						{
							Alert.show("We have confict on node "+firstNode.name()+" and attribute "+a1.name());
							atribFounded = true ;
							firstNode.@[a2.name()] = a2 ;
						}
					}
				}
				if(!atribFounded)
				{
					trace("Add this attribute : "+a2.name()+' = '+a2);
					firstNode.@[a2.name()] = a2 ;
				}
			}
		}
		
		
		/**Returns true if both nodes have same name and same atribute names
		private function updateIfTheyAreSame(node1:XML,node2:XML)
		{
			//TODO not completed
			if(node1.name() == node2.name())
			{
				var atribs1:XMLList = node1.attributes();
				var atribs2:XMLList = node2.attributes();
				for(var i:int = 0 ; i<atribs1.length() ; i++)
				{
					var didIFoundThisAtrib:Boolean = false ;
					for(var j:int = 0 ; j<atribs2.length() ; j++)
					{
						if(atribs2[j].name() == atribs1[i].name())
						{
							if(atribs2[j] == atribs1[i])
							{
								//The atribute data are same to. skip this
								break;
							}
							else if(!isNaN(Number(atribs1[i])) && !isNaN(Number(atribs2[j])))
							{
								
							}
						}
					}
					if(!didIFoundThisAtrib)
					{
						return false ;
					}
				}
				return true ;
			}
		}*/
		
			/**Returns true if both nodes have same name and same atribute names
			private function updateIfTheyAreSame(node1:XML,node2:XML)
			{
				//TODO not completed
				if(node1.name() == node2.name())
				{
					var atribs1:XMLList = node1.attributes();
					var atribs2:XMLList = node2.attributes();
					for(var i:int = 0 ; i<atribs1.length() ; i++)
					{
						var didIFoundThisAtrib:Boolean = false ;
						for(var j:int = 0 ; j<atribs2.length() ; j++)
						{
							if(atribs2[j].name() == atribs1[i].name())
							{
								if(atribs2[j] == atribs1[i])
								{
									//The atribute data are same to. skip this
									break;
								}
								else if(!isNaN(Number(atribs1[i])) && !isNaN(Number(atribs2[j])))
								{
									
								}
							}
						}
						if(!didIFoundThisAtrib)
						{
							return false ;
						}
					}
					return true ;
				}
			}
			
			private function updateNode(mainNode:XML,secondNode:XML):void
			{
				//TODO
			}*/
		
		/*private function insertNodeToXML(newList:XML, node:XML):void
		{
			var androidNS:Namespace = new Namespace('android',androidNameSpace);
			//myXML.item.(@name==e.target.name).@full;
			//<uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS" />
			//trace("Can you fine one for me?? "+newList.child(new QName(androidNameSpace,'uses-permission')).toXMLString());
			var nodeName:String = node.name();
			trace("Node Name : "+node.name());
			var nodeAtributes:XMLList = node.attributes();
			for(var i:int = 0 ; i<nodeAtributes.length() ; i++)
			{
				var atribName:String = nodeAtributes[i].name() ;
				trace("note atribs : "+nodeAtributes[i].name()+' > '+nodeAtributes[i]);
				trace("Can you search for me??"+node.attribute(new QName(androidNameSpace,'name')));
			}
			trace("Can i get the atib directly?? "+node.@androidNS::name);
			//trace("Can you fine one for me?? "+newList.child(new QName(androidNameSpace,'uses-permission')).attribute(new QName(androidNameSpace,'name'))[0].name());
			//trace("newList : "+newList.toXMLString());
			//trace("node : "+node.toXMLString());
		}*/
	}
}