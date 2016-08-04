package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stSetHeroPositionCmd extends stSceneHeroCmd 
	{
		public var heroid:uint;
		public var pos:uint;
		public function stSetHeroPositionCmd() 
		{
			byParam = PARA_SET_HERO_POSITION_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
			pos = byte.readUnsignedByte();
		}
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(heroid);
			byte.writeByte(pos);			
		}
	}

}

/*
 * //设置武将在阵法中的位置
	const BYTE PARA_SET_HERO_POSITION_USERCMD = 6;
	struct stSetHeroPositionCmd : public stSceneHeroCmd
	{
		stSetHeroPositionCmd()
		{
			byParam = PARA_SET_HERO_POSITION_USERCMD;
			heroid = 0;
			pos = 0;
		}
		DWORD heroid;
		BYTE pos;
	};
*/