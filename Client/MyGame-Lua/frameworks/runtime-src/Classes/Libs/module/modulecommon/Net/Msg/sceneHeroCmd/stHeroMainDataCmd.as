package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	public class stHeroMainDataCmd extends stSceneHeroCmd 
	{
		public var data:t_HeroData;
		public var list:Dictionary;
		public function stHeroMainDataCmd() 
		{
			byParam = PARA_HERO_MAINDATA_USERCMD;
			data = new t_HeroData();			
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			data.deserialize(byte);
			
			list = t_ItemData.read(byte);
		}
		
	}

}

/*
 * const BYTE PARA_HERO_MAINDATA_USERCMD = 1;
	struct stHeroMainDataCmd : public stSceneHeroCmd
	{
		stHeroMainDataCmd()
		{
			byParam = PARA_HERO_MAINDATA_USERCMD;
		}
		t_HeroData data;
	};
*/