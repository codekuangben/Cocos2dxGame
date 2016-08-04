package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author helloworld
	 */
	public class stReqRebirthCmd extends stSceneHeroCmd
	{
		public var m_heroid:uint;
		public function stReqRebirthCmd() 
		{
			byParam = PARA_REQ_REBIRTH_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_heroid);
		}
	}

}

/*
	///请求武将转生
	const BYTE PARA_REQ_REBIRTH_USERCMD = 20;
	struct stReqRebirthCmd : public stSceneHeroCmd
	{
		stReqRebirthCmd()
		{
			byParam = PARA_REQ_REBIRTH_USERCMD;
			heroid = 0;
		}
		DWORD heroid;
	};

*/