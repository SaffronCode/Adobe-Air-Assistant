package component.xmlPack
{
	import contents.alert.Alert;

	public class IOSPermission
	{
		private var InfoAdditions:XMLList ;
		private var Entitlements:XMLList ;
		
		private var appId:String ;
		
		public function IOSPermission()
		{
			InfoAdditions = new XMLList();
			Entitlements = new XMLList();
		}
		
		public function importInfoAdditions(InfoAdditionsXMLString:String):void
		{
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
		
		public function setAppId(id:String):void
		{
			this.appId = id ;			
		}
		
		
	///////////////////////////////////////////////////
		
		/**Add and update entitlements*/
		public function addEntitlements(entitlements:String):void
		{
			Alert.show('add entitlements : '+entitlements);
		}
		
		public function addInfoAdditions(infoAdditions:String):void
		{
			Alert.show('add InfoAdditions : '+infoAdditions);
		}
	}
}