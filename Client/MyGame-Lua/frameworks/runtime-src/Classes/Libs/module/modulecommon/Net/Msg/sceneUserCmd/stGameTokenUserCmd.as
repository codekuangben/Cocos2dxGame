package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class stGameTokenUserCmd extends stSceneUserCmd 
	{				
		public var m_list:Dictionary;
		public function stGameTokenUserCmd() 
		{
			byParam = SceneUserParam.GAME_TOKEN_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var num:uint = byte.readUnsignedShort();
			m_list = t_ItemData.readWidthNum(byte, num);
		}
		
	}

}

/*
 * enum eMoney
{
	SILVER_COIN = 1, //银币(游戏币)
	GOLD_COIN = 2,  //金币(绑定rmb)
	YUAN_BAO = 3,   //元宝(充值rmb)
	JIANG_HUN = 4,	//将魂
	BING_HUN = 5,  //兵魂
	GREEN_SHENHUN = 6,	//绿色神魂
	BLUE_SHENHUN = 7,	//蓝色神魂
	PURPLE_SHENHUN = 8,	//紫色神魂
	MONEY_MAX,
};
 * const BYTE GAME_TOKEN_USERCMD_PARA = 20;
	struct stGameTokenUserCmd : public stSceneUserCmd
	{
		stGameTokenUserCmd()
		{
			byParam = GAME_TOKEN_USERCMD_PARA;
			num = 0;
		}
		WORD num;
		t_MoneyData money[0];
		WORD getSize()
		{
			return sizeof(*this) + num*sizeof(t_MoneyData);
		}
	};
*/