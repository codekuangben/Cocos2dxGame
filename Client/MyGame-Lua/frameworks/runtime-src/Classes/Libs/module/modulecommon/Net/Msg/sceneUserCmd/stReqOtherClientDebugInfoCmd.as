package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	public class stReqOtherClientDebugInfoCmd extends stSceneUserCmd 
	{
		public static const TYPE_getLog:int = 0;
		public static const TYPE_execCode:int = 1;
		public static const TYPE_RecordCmd:int = 2;	//记录指定消息
		public static const TYPE_ReqCmd:int = 3;	//请求指定消息
		public static const TYPE_FightSnap:int = 4;	//战斗快照
		public static const TYPE_UIShowInfo:int = 5;//显示加载UI方面的信息
		
		public var dstusername:String;
		public var dstcharid:uint;
		public var srcusername:String;
		public var srccharid:uint;
		public var type:uint;		
		public var text:String;
		public function stReqOtherClientDebugInfoCmd() 
		{
			byParam = SceneUserParam.REQ_OTER_CLIENT_DEBUG_INFO_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			dstusername = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			dstcharid = byte.readUnsignedInt();
			
			srcusername = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			srccharid = byte.readUnsignedInt();
			
			type = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedShort();
			text = UtilTools.readStr(byte, num);
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			
			if (dstusername == null)
			{
				dstusername = "";
			}
			UtilTools.writeStr(byte, dstusername, EnNet.MAX_NAMESIZE);
			byte.writeUnsignedInt(dstcharid);
			
			if (srcusername == null)
			{
				srcusername = "";
			}
			UtilTools.writeStr(byte, srcusername, EnNet.MAX_NAMESIZE);
			byte.writeUnsignedInt(srccharid);
			byte.writeUnsignedInt(type);
			UtilTools.writeStrUnfixed(byte, text, 2);
		}
	}

}

/*这个消息只能GM身份才能像服务器发出，
 * 被调试的客户端会收到stReqOtherClientDebugInfoCmd
const BYTE REQ_OTER_CLIENT_DEBUG_INFO_PARA = 33; 
    struct stReqOtherClientDebugInfoCmd : public stSceneUserCmd
    {   
        stReqOtherClientDebugInfoCmd()
        {   
            byParam = REQ_OTER_CLIENT_DEBUG_INFO_PARA;
            bzero(dstusername,sizeof(dstusername));
            dstcharid = 0;
            bzero(srcusername,sizeof(srcusername));
            srccharid = 0;
            type = 0;
            type = 0;
        }   
        char dstusername[MAX_NAMESIZE];
        DWORD dstcharid;
        char srcusername[MAX_NAMESIZE];
        DWORD srccharid;
        DWORD type;
        WORD num;
        char text[0];
    };  
*/