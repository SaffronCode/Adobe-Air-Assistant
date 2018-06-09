package component.xmlPack
{
	public class AndroidPermission
	{
		private var main:XML ;
		
		public function AndroidPermission()
		{
			/*main = <manifest xmlns:android="http://schemas.android.com/apk/res/android" android:installLocation="auto">
					    <uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />
					</manifest>*///works
			const androidSchema:String = "http://schemas.android.com/apk/res/android" ;
			main = <manifest xmlns:android={androidSchema} android:installLocation="auto" />;
			main.appendChild(<uses-sdk xmlns:android={androidSchema} android:minSdkVersion="9" android:targetSdkVersion="22" />);//Not works
			//var U:XML = <uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />;
			//main = <manifest xmlns:android="http://schemas.android.com/apk/res/android" android:installLocation="auto" />;
			
			//main.appendChild(U);
			//main = new XML('<manifest xmlns:android="http://schemas.android.com/apk/res/android" android:installLocation="auto"/>');
			//main.appendChild(new XML('<uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />'))
			//main.appendChild(<uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />)
			
			/*
					<uses-sdk android:minSdkVersion="9" android:targetSdkVersion="22" />
					<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
					<uses-permission android:name="android.permission.INTERNET"/>
					<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
					<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
					<!--uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
					<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/-->
					<uses-permission android:name="android.permission.GET_ACCOUNTS"/>
					<uses-permission android:name="android.permission.DISABLE_KEYGUARD"/>
					<uses-permission android:name="android.permission.WAKE_LOCK"/>
					<uses-permission android:name="android.permission.VIBRATE"/>
					<uses-permission android:name="android.permission.GET_TASKS"/>
					
					<permission android:name="air.com.mteamapps.Aban.permission.C2D_MESSAGE" android:protectionLevel="signature" />
					<uses-permission android:name="air.com.mteamapps.Aban.permission.C2D_MESSAGE" />
					<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
				
					<application android:enabled="true" android:hardwareAccelerated="true">
					
					
						<activity>
							<intent-filter>
								<action android:name="android.intent.action.MAIN"/>
								<category android:name="android.intent.category.LAUNCHER"/>
							</intent-filter>
							<intent-filter>
								<action android:name="android.intent.action.VIEW"/>
								<category android:name="android.intent.category.BROWSABLE"/>
								<category android:name="android.intent.category.DEFAULT"/>
								<data android:scheme="aban"/>
							</intent-filter>
						</activity>
						<!-- manual or onesignal mode -->
						<receiver android:name="com.milkmangames.extensions.android.push.GCMBroadcastReceiver" android:permission="com.google.android.c2dm.permission.SEND" >
						  <intent-filter>
							<action android:name="com.google.android.c2dm.intent.RECEIVE" />
							<action android:name="com.google.android.c2dm.intent.REGISTRATION" />
							<category android:name="air.com.mteamapps.Aban" />
						  </intent-filter>
						</receiver>
						
						<service android:name="com.milkmangames.extensions.android.push.GCMIntentService" />
						
					</application>
					*/
		}
		
		public function toString():String
		{
			return main.toXMLString();
		}
	}
}