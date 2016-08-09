package modulecommon.net.msg.chatUserCmd 
{
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 */
	public class stNpcAiChatUserCmd extends stChatUserCmd 
	{
		public var tempid:uint;
		public var text:String;
		public function stNpcAiChatUserCmd() 
		{
			byParam = NPC_AI_CHAT_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			tempid = byte.readUnsignedInt();
			var size:uint = byte.readUnsignedShort();
			text = UtilTools.readStr(byte, size);	
		}
		
	}

}

/*
const BYTE NPC_AI_CHAT_USERCMD = 3;
    struct stNpcAiChatUserCmd : public stChatUserCmd
    {      
        stNpcAiChatUserCmd()
        {  
            byParam = NPC_AI_CHAT_USERCMD;
            tempid = 0;
            size = 0;
        }   
        DWORD tempid;
        WORD size;
        char text[0];
        WORD getSize() const {return sizeof(*this) + size;}
    }; */