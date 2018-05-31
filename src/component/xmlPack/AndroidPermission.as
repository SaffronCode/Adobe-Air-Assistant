package component.xmlPack
{
	public class AndroidPermission
	{
		private var main:XML ;
		
		public function AndroidPermission()
		{
			main = new XML(<manifest/>);
			main.addNamespace(new Namespace("android","auto"));
			var test_skd:XML = new XML(<uses-sdk/>);
			main.appendChild(new XML(<uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />));
		}
		
		public function toString():String
		{
			return main.toXMLString();
		}
	}
}