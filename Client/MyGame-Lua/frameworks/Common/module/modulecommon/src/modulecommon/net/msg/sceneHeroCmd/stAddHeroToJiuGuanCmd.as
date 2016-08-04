package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stAddHeroToJiuGuanCmd extends stSceneHeroCmd
	{
		public var heroid:uint;
		public function stAddHeroToJiuGuanCmd() 
		{
			byParam = PARA_ADDHERO_TO_JIUGUAN_USERCMD
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
		}
	}

}

/*
	///向酒馆中添加一个武将
	const BYTE PARA_ADDHERO_TO_JIUGUAN_USERCMD = 19;
	struct stAddHeroToJiuGuanCmd : public stSceneHeroCmd
	{
		stAddHeroToJiuGuanCmd()
		{
			byParam = PARA_ADDHERO_TO_JIUGUAN_USERCMD;
			heroid = 0;
		}
		DWORD heroid;
	};

*/