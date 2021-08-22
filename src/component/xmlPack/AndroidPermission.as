package component.xmlPack
{
	import contents.alert.Alert;
	

	public class AndroidPermission
	{
		private var main:XML ;
		private const androidNameSpace:String = "android";
		private const xmlPerfix:String = ' xmlns:android="'+androidNameSpace+'"';
		
		private var appId:String ;
		private var URIScheme:String ;
		
		
		public var addAirPreset:Boolean = true ;
		
		private static const package_name_list:Array = ['YOUR_APPLICATION_IDENTIFIER','YOUR_PACKAGE_NAME','YOUR_APPLICATION_PACKAGE','YOUR_APP_ID','APPLICATION_PACKAGE','APPLICATION_ID'] ;
		
		public function AndroidPermission()
		{
			reset();
		}
		
		public function reset():void
		{
			main = new XML();
		}
		
		public function setAppId(appId:String):void
		{
			//reset();
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
				Alert.show("The Android manifest had problem. solve the xml problem first : \n\n"+e.message);
				//throw e ;
			}
		}
		
		public function toString():String
		{
			var stringFormat:String = main.toXMLString() ;
			stringFormat = stringFormat.replace(xmlPerfix,'');
			return stringFormat;
		}
		
		/**This will replace appId thru the descriptor file*/
		private function injectAppId(source:String):String
		{
			for(var i:int = 0 ; i<package_name_list.length ; i++)
			{
				source = source.replace(new RegExp(package_name_list[i],'gi'),createAppId());
			}
			source = source.replace(/APPLICATION_LAUNCHER_ID/g,URIScheme);
			source = source.replace(/air\.air\./g,'air.');
			return source ;
		}
		
		/**It will replace APPLICATION_PACKAGE with the ap id*/
		public function add(AndroidPermissionXMLString:String):void
		{
			AndroidPermissionXMLString = injectAppId(AndroidPermissionXMLString);// AndroidPermissionXMLString.replace(/air\.air\./g,'air.');
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
			if(String(main)=='')
			{
				main = AndroidPermissionXML.copy();
			}
			else
			{
				main = mergeToXML(main,AndroidPermissionXML,true);
				main = mergeToXML(main,AndroidPermissionXML);
			}
		}
		
		/**Create application id*/
		private function createAppId():String
		{
			return (addAirPreset?'air.':'')+appId ;
		}
		
		/**Returns true if the permission was already in your XML file founded*/
		public function dohave(AndroidPermissionXMLString:String):Boolean
		{
			if(AndroidPermissionXMLString==null || AndroidPermissionXMLString=='')
			{
				return true ;
			}
			AndroidPermissionXMLString = injectAppId(AndroidPermissionXMLString);//AndroidPermissionXMLString.replace(/APPLICATION_LAUNCHER_ID/g,URIScheme);
			var AndroidPermissionXML:XML ;
			try
			{
				AndroidPermissionXML = new XML(AndroidPermissionXMLString.replace('<manifest','<manifest'+xmlPerfix));
			}
			catch(e:Error)
			{
				Alert.show(e.message);
				return true;
			}
			
			return mergeToXML(main,AndroidPermissionXML,false,true)!=null;
		}
		/**It will replace APPLICATION_PACKAGE with the ap id*/
		public function remove(AndroidPermissionXMLString:String):void
		{
			if(AndroidPermissionXMLString=='')
				return ;
			AndroidPermissionXMLString = injectAppId(AndroidPermissionXMLString);//AndroidPermissionXMLString.replace(/APPLICATION_LAUNCHER_ID/g,URIScheme);
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
			
			main = mergeToXML(main,AndroidPermissionXML,true);
		}
		
		private function mergeToXML(firstXML:XML,secXML:XML,removeParams:Boolean=false,returnNullIfDefrend:Boolean=false):XML
		{
			trace("secXML: "+secXML+'\n\n'+'*****************************'+'\n\n\n)');
			var firstList:XMLList = firstXML.children() ;
			var secondList:XMLList = secXML.children() ;
			
			for(var i:int = 0 ; i<secondList.length() ; i++)
			{
				trace("secondList["+i+"].name() : "+secondList[i].name());
				var nodeUpdated:Boolean = false ;
				var onNodeFounded:Boolean = false ;
				for(var j:int = 0 ; j<firstList.length() ;j++)
				{
					var areNodeSame:Boolean = false ;
					if(secondList[i].name()==firstList[j].name())
					{
						areNodeSame = true ;
						var s1:XML = secondList[i] ;
						var s2:XML = firstList[j] ;
						switch(String(secondList[i].name()))
						{
							case "application":
							case "uses-sdk":
								nodeUpdated = true ;
								if(!removeParams)
								{
									if(returnNullIfDefrend)
									{
										if(mergAributes(s2,s1,true))
										{
											areNodeSame = false ;
											break;
											//return null ;
										}
									}
									else
									{
										mergAributes(s2,s1);
									}
								}
								else
									trace("Dont need to remove any thing");
								
								if(s1.hasComplexContent())
								{
									var mergResult:XML = mergeToXML(s2,s1,removeParams,returnNullIfDefrend);
									if(returnNullIfDefrend && mergResult==null)
									{
										areNodeSame = false ;
										break;
										//return null ;
									}
								}
							break;
							default:
								if(	haveSaveAtributes(s1,s2))
								{
									trace("Duplicated atributes");
									nodeUpdated = true ;
									
									if(removeParams)
									{
										delete firstList[j] ;
									}
									else
									{
										if(s1.hasComplexContent())
										{
											var mergResult2:XML = mergeToXML(s2,s1,false,returnNullIfDefrend);
											if(returnNullIfDefrend && mergResult2==null)
											{
												areNodeSame = false ;
												break;
												//return null ;
											}
										}
									}
									j = firstList.length() ;
								}
							break;
						}
					}
					onNodeFounded = onNodeFounded || areNodeSame ;
				}
				if(returnNullIfDefrend && !onNodeFounded)
				{
					return null ;
				}
				if(!nodeUpdated)
				{
					trace("This node is new : "+secondList[i].toXMLString());
					if(returnNullIfDefrend)
					{
						return null ;
					}
					if(!removeParams)
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
			if(fatrib.length()!=satrib.length() && (fatrib.length()==0 || satrib.length()==0))
			{
				return false ;
			}
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
		
		private function mergAributes(firstNode:XML,secondNode:XML,returnTrueIfNeedChangeOnly:Boolean=false):Boolean
		{
			var fatrib:XMLList = firstNode.attributes() ;
			var satrib:XMLList = secondNode.attributes() ;
			/*if((fatrib.length()!=satrib.length()) && (fatrib.length()==0 || satrib.length()==0))
			{
				return false ;
			}*/
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
							if(!returnTrueIfNeedChangeOnly)
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
							trace("*** We have confict on node "+firstNode.name()+" and attribute "+a1.name()+" : "+a1+" vs "+a2);
							atribFounded = true ;
							return false ;
							/*if(!returnTrueIfNeedChangeOnly)
								firstNode.@[a2.name()] = a2 ;*/
						}
					}
				}
				if(!atribFounded)
				{
					trace("Add this attribute : "+a2.name()+' = '+a2);
					if(returnTrueIfNeedChangeOnly)
					{
						return true ;
					}
					
					firstNode.@[a2.name()] = a2 ;
				}
			}
			return false ;
		}
		
		
		
		public function setAppScheme(URIScheme:String):void
		{
			//reset();
			this.URIScheme = URIScheme ;
		}
	}
}