package component.xmlPack
{
	import contents.alert.Alert;

	public class IOSPermission
	{
		private var InfoAdditions:XMLList ;
		private var Entitlements:XMLList ;
		
		public function IOSPermission()
		{
			InfoAdditions = new XMLList();
			Entitlements = new XMLList();
		}
		
		public function importInfoAdditions(InfoAdditionsXMLString:String):void
		{
			trace("InfoAdditionsXMLString : "+InfoAdditionsXMLString);
			try
			{
				InfoAdditions = new XMLList(InfoAdditionsXMLString);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		public function importEntitlements(EntitlementsXMLString:String):void
		{
			try
			{
				Entitlements = new XMLList(EntitlementsXMLString);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		public function InfoAdditionsToString():String
		{
			return InfoAdditions.toXMLString();
		}
		
		public function EntitlementsToString():String
		{
			return Entitlements.toXMLString();
		}
	}
}