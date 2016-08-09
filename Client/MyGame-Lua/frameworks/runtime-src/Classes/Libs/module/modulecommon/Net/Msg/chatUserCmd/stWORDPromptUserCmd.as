package modulecommon.net.msg.chatUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	
	public class stWORDPromptUserCmd extends stChatUserCmd 
	{
		public var m_type:uint;
		public var m_lastTime:Number;
		public var m_content:String;
		public function stWORDPromptUserCmd() 
		{
			byParam = WORDPROMPT_USERCMD_PARAMETER;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_type = byte.readUnsignedByte();
			m_lastTime = byte.readUnsignedInt();
			var size:uint = byte.readUnsignedShort();
			m_content = UtilTools.readStr(byte, size);			
		}
	}

}

/*
*///文字提示，由脚本触发
/*const BYTE  WORDPROMPT_USERCMD_PARAMETER= 2;
struct stWORDPromptUserCmd: public stChatUserCmd
{
	BYTE type;	//类型0 - 屏幕底部位置; 1- 屏幕左侧位置
	DWORD lastTime;	//持续时间, 单位:毫秒
	WORD size;
	char content[0];
}*/