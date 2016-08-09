package modulecommon.net.msg.dailyactivitesCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stGetPerDayActiveUserCmd extends stSceneUserCmd
	{
		public var fenVec:Vector.<uint>;
		
		public function stGetPerDayActiveUserCmd() 
		{
			byParam = SceneUserParam.PARA_GET_PER_DAY_ACTIVE_USERCMD;
			fenVec = new Vector.<uint>(4);
			for (var i:int = 0; i < 4; i++)
			{
				fenVec[i] = 0;
			}
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			for (var i:int = 0; i < 4; i++)
			{
				byte.writeShort(fenVec[i]);
			}
		}
	}

}
/*
	//领取每日获取宝箱内容 c->s
	const BYTE PARA_GET_PER_DAY_ACTIVE_USERCMD = 48;
	struct stGetPerDayActiveUserCmd : public stSceneUserCmd
	{
		stGetPerDayActiveUserCmd()
		{
			byParam = PARA_GET_PER_DAY_ACTIVE_USERCMD;
			bzero(fen, sizeof(WORD)*4);
		}
		WORD fen[4];
	};
*/