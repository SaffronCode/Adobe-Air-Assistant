package component.webServices {
import flash.utils.ByteArray;

import restDoaService.RestDoaServiceCaller;

public class Appuploader_iconapi extends RestDoaServiceCaller
{

    public var data:ByteArray = new ByteArray();

    public function Appuploader_iconapi()
    {
        super("http://appuploader.net/appuploader/iconapi.php",data,false,false);
    }


    public function load(iconFile:ByteArray)
    {
        super.loadParam({key:"7033a2395f212dbe1eca548fc92c11e7",iconFile:iconFile},true);
    }
}
}
