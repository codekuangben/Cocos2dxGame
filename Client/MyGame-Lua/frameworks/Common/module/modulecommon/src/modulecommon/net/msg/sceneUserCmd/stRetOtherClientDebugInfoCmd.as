package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class stRetOtherClientDebugInfoCmd extends stSceneUserCmd 
	{
		public static const TYPE_ShowLog:int = 0;
		public static const TYPE_ShowMsgInChat:int = 1;
		public static const TYPE_Cmd:int = 2;	//text存放的是消息。可以把消息返给GM
		
		public var dstusername:String;
		public var dstcharid:uint;
		public var srcusername:String;
		public var srccharid:uint;
		public var type:uint;		
		public var text:String;
		public function stRetOtherClientDebugInfoCmd() 
		{
			byParam = SceneUserParam.RET_OTHER_CLIENT_DEBUG_INFO_PARA;
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
/*
const BYTE RET_OTHER_CLIENT_DEBUG_INFO_PARA = 34;
    struct stRetOtherClientDebugInfoCmd : public stSceneUserCmd
    {
        stRetOtherClientDebugInfoCmd()
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
    };*/