package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshHeroNumCmd extends stSceneHeroCmd
	{
		public var heroid:uint;
		public var num:uint;
		public function stRefreshHeroNumCmd() 
		{
			byParam = PARA_REFRESH_HERONUM_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
			num = byte.readUnsignedShort();
		}
	}

}

/*
	///刷新武将数量
	const BYTE PARA_REFRESH_HERONUM_USERCMD = 21;
	struct stRefreshHeroNumCmd : public stSceneHeroCmd
	{
		stRefreshHeroNumCmd()
		{
			byParam = PARA_REFRESH_HERONUM_USERCMD;
			heroid = 0;
			num = 0;
		}
		DWORD heroid;
		WORD num;
	};

*/