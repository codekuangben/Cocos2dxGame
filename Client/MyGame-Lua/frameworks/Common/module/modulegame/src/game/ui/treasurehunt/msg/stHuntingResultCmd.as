package game.ui.treasurehunt.msg 
{
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stHuntingResultCmd extends stSceneUserCmd 
	{
		public var huntreward:Vector.<stHuntingRward>;
		public function stHuntingResultCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_HUNTING_RESULT_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			huntreward = new Vector.<stHuntingRward>();
			var num:int = byte.readUnsignedShort();
			var rward:stHuntingRward;
			for (var i:uint = 0; i < num; i++ )
			{
				rward = new stHuntingRward();
				rward.deserialize(byte);
				huntreward.push(rward);
			}
		}	
	}
}
/*//寻宝结果
    const BYTE PARA_HUNTING_RESULT_USERCMD = 65;
    struct stHuntingResultCmd : public stSceneUserCmd
    {
        stHuntingResultCmd()
        {
            byParam = PARA_HUNTING_RESULT_USERCMD;
            num = 0;
        }
        WORD num;
        stHuntingRward huntreward[0];
    };*/