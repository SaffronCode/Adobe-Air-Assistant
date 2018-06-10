package component.xmlPack
{
	

	public class AndroidPermission
	{
		private var main:XML ;
		
		private const xmlPerfix:String = ' xmlns:android="android"'
		
		public function AndroidPermission()
		{
			
			//Alert.show("main.uses-permission : "+main.@*);
			//Alert.show("main.uses-permission : "+main['uses-permission'][0].@*);
				//Done
			//Alert.show("main.meta-data : "+XML(main['meta-data'][0]).attribute(new QName('android','name')));
			
			
		}
		
		public function importPermission(permissionXML:String):void
		{
			permissionXML = permissionXML.replace('<manifest','<manifest'+xmlPerfix) ;
			main = XML(permissionXML) ;
		}
		
		public function toString():String
		{
			var stringFormat:String = main.toXMLString() ;
			stringFormat = stringFormat.replace(xmlPerfix,'');
			return stringFormat;
		}
	}
}