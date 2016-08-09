package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stRetKitListCmd extends stSceneHeroCmd 
	{
		public var jinnang:Vector.<uint>;
		public function stRetKitListCmd() 
		{
			byParam = PARA_RET_KITLIST_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var i:int;		
			
			for (i = 0; i < 4; i++)
			{
				jinnang[i] = byte.readUnsignedInt();
			}
		}
	}

}
/*
 * //返回锦囊列表
	const BYTE PARA_RET_KITLIST_USERCMD = 11;
	struct stRetKitListCmd : public stSceneHeroCmd
	{
		stRetKitListCmd()
		{
			byParam = PARA_RET_KITLIST_USERCMD;
		}
		DWORD kits[4];
	};
*/