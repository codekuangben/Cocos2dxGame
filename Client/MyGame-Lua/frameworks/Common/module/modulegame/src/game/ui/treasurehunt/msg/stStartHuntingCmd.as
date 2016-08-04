package game.ui.treasurehunt.msg 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	/**
	 * ...
	 * @author ...
	 */
	public class stStartHuntingCmd extends stSceneUserCmd 
	{
		public var hunttype:uint;
		public function stStartHuntingCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_START_HUNTING_USERCMD;
			
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(hunttype);
		}
		
	}

}

	
	/*//请求寻宝
    const BYTE PARA_START_HUNTING_USERCMD = 64;
    struct stStartHuntingCmd : public stSceneUserCmd
    {
        stStartHuntingCmd()
        {
            byParam = PARA_START_HUNTING_USERCMD;
            hunttype = 0;
        }
        BYTE hunttype;  //寻宝类型  1:寻宝1次 2:寻宝10次 3:寻宝50次
    };*/