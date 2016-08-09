package modulecommon.net.msg.dailyactivitesCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stPerDayValueUserCmd extends stSceneUserCmd
	{
		public var activeValue:uint;
		public var fenVec:Vector.<uint>;
		
		public function stPerDayValueUserCmd() 
		{
			byParam = SceneUserParam.PARA_PER_DAY_VALUE_USERCMD;
			fenVec = new Vector.<uint>(4);
			for (var i:int = 0; i < 4; i++)
			{
				fenVec[i] = 0;
			}
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			activeValue = byte.readUnsignedShort();
			for (var i:int = 0; i < 4; i++)
			{
				fenVec[i] = byte.readUnsignedShort();
			}
		}
	}

}

/*
//通知每日活跃值
	const BYTE PARA_PER_DAY_VALUE_USERCMD = 45;
	struct stPerDayValueUserCmd : public stSceneUserCmd
	{
		stPerDayValueUserCmd()
		{
			byParam = PARA_PER_DAY_VALUE_USERCMD;
			activeValue = 0;
			bzero(fen, sizeof(WORD)*4);
		}
		WORD activeValue; //当日活跃值
		WORD fen[4]; //这个分值对应宝箱未领
	};
*/