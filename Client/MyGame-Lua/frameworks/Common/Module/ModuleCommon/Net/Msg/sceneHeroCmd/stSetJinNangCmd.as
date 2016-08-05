package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stSetJinNangCmd extends stSceneHeroCmd 
	{		
		public var jinnangID:uint;
		public var dstID:uint;
		public function stSetJinNangCmd() 
		{
			byParam = PARA_SET_JINNANG_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			jinnangID = byte.readUnsignedInt();
			dstID = byte.readUnsignedByte();
		}
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(jinnangID);
			byte.writeByte(dstID);			
		}
	}

}

/*
 * //设置锦囊
	const BYTE PARA_SET_JINNANG_USERCMD = 9;
	struct stSetJinNangCmd : public stSceneHeroCmd
	{
		stSetJinNangCmd()
		{ 
			byParam = PARA_SET_JINNANG_USERCMD;
			srcid = 0;
			dstid = 0;
		}
		DWORD srcid;
		BYTE dstid;	//锦囊格子编号(1-4)
	};
*/