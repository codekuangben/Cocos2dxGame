package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRetRebirthSuccessCmd extends stSceneHeroCmd
	{
		public var heroid:uint;
		public function stRetRebirthSuccessCmd() 
		{
			byParam = PARA_RET_REBIRTH_SUCCESS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
		}
	}

}

/*
	///武将转生成功返回客户端消息
    const BYTE PARA_RET_REBIRTH_SUCCESS_USERCMD = 24;
    struct stRetRebirthSuccessCmd : public stSceneHeroCmd
    {
        stRetRebirthSuccessCmd()
        {
            byParam = PARA_RET_REBIRTH_SUCCESS_USERCMD;
            heroid = 0;
        }
        DWORD heroid;   //武将转生后合成id
    };
*/