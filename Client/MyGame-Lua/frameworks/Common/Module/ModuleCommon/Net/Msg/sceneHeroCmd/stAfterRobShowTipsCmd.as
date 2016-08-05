package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stAfterRobShowTipsCmd extends stSceneHeroCmd
	{
		public var sucess:uint;
		public var baowuID:uint;
		
		public function stAfterRobShowTipsCmd() 
		{
			byParam = PARA_AFTER_ROB_SHOW_TIPS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			sucess = byte.readUnsignedByte();
			baowuID = byte.readUnsignedInt();
		}
	}

}

/*
//抢夺宝物后给以提示
    const BYTE PARA_AFTER_ROB_SHOW_TIPS_USERCMD = 30; 
    struct stAfterRobShowTipsCmd : public stSceneHeroCmd
    {   
        stAfterRobShowTipsCmd()
        {   
            byParam = PARA_AFTER_ROB_SHOW_TIPS_USERCMD;
        }   
        BYTE sucess;    //是否成功 0-失败 1-成功
        DWORD baowu;
    };
*/