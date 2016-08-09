package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stGainHeroCmd extends stSceneHeroCmd
	{
		public var heroid:uint;
		public var color:uint;
		public function stGainHeroCmd() 
		{
			byParam = PARA_GAIN_HERO_USERCMD;
		}
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(heroid);
			byte.writeByte(color);
		}
	}

}

/*
 * const BYTE PARA_GAIN_HERO_USERCMD = 2;
	struct stGainHeroCmd : public stSceneHeroCmd
	{
		stGainHeroCmd()
		{
			byParam = PARA_GAIN_HERO_USERCMD;
		}
		DWORD heroid;
		BYTE color;
	};
*/