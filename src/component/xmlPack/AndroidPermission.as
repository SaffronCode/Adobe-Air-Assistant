package component.xmlPack
{
	import contents.alert.Alert;
	

	public class AndroidPermission
	{
		private var main:XML ;
		private const androidNameSpace:String = "android";
		private const xmlPerfix:String = ' xmlns:android="'+androidNameSpace+'"';
		
		public function AndroidPermission()
		{
			main = new XML();
			//Alert.show("main.uses-permission : "+main.@*);
			//Alert.show("main.uses-permission : "+main['uses-permission'][0].@*);
				//Done
			//Alert.show("main.meta-data : "+XML(main['meta-data'][0]).attribute(new QName('android','name')));
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
		
		public function add(AndroidPermission:XML):void
		{
			//AndroidPermission vs main
			main = mergeToXML(AndroidPermission,main);
		}
		private function mergeToXML(mainXML:XML,newXML:XML):XML
		{
			var mergedXML:XML = mainXML.copy();
			var newList:XMLList = newXML.children() ;
			var l:int = newList.length() ;
			
			for(var i:int = 0 ; i<l ; i++)
			{
				insertNodeToXML(mergedXML,newList[i]);
			}
			
			return mainXML ;
		}
		
		private function insertNodeToXML(newList:XML, node:XML):void
		{
			//myXML.item.(@name==e.target.name).@full;
			//<uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS" />
			trace("Can you fine one for me?? "+newList.child(new QName(androidNameSpace,'uses-permission')).toXMLString());
			trace("newList : "+newList.toXMLString());
			trace("node : "+node.toXMLString());
		}
	}
}