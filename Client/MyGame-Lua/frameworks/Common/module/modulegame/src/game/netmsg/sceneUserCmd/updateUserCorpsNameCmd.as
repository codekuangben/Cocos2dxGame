package game.netmsg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import com.util.UtilTools;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class updateUserCorpsNameCmd extends stSceneUserCmd 
	{
		public var tempID:uint;
		public var corpsname:String;
		public function updateUserCorpsNameCmd() 
		{
			byParam = SceneUserParam.UPDATE_USER_CORPSNAME_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			tempID = byte.readUnsignedInt();
			corpsname = UtilTools.readStr(byte,EnNet.MAX_NAMESIZE);
		}
	}

}

/*const BYTE UPDATE_USER_CORPSNAME_USERCMD = 51;
    struct updateUserCorpsNameCmd : public stSceneUserCmd
    {    
        updateUserCorpsNameCmd()
        {    
            byParam = UPDATE_USER_CORPSNAME_USERCMD;
            dwTempID = 0; 
            bzero(corpsname, MAX_NAMESIZE);
        }    
        DWORD dwTempID;
        char corpsname[MAX_NAMESIZE];
    };  */