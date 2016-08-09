package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRemoveHeroCmd extends stSceneHeroCmd
	{
		public var heroid:uint;
		public function stRemoveHeroCmd() 
		{
			byParam = PARA_REMOVE_HERO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
		}
	}

}

/*
	///删除武将
	const BYTE PARA_REMOVE_HERO_USERCMD = 22;
	struct stRemoveHeroCmd : public stSceneHeroCmd
	{
		stRemoveHeroCmd()
		{
			byParam = PARA_REMOVE_HERO_USERCMD;
			heroid = 0;
		}
		DWORD heroid;
	}
*/