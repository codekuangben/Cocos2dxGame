package modulecommon.net.msg.treesurehuntCmd 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class stRefreshHuntingPersonalPrizeCmd extends stSceneUserCmd 
	{
		public var m_prizestr:Array;
		public function stRefreshHuntingPersonalPrizeCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_REFRESH_HUNTING_PERSONAL_PRIZE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var prizestr:String = UtilTools.readStrEx(byte);
			m_prizestr = prizestr.split("|");
			m_prizestr.pop();
		}
	}

}/*//刷新个人中奖纪录
    const BYTE PARA_REFRESH_HUNTING_PERSONAL_PRIZE_USERCMD = 63;
    struct stRefreshHuntingPersonalPrizeCmd : public stSceneUserCmd
    {
        stRefreshHuntingPersonalPrizeCmd()
        {
            byParam = PARA_REFRESH_HUNTING_PERSONAL_PRIZE_USERCMD;
            size = 0;
        }
        WORD size;
        char prizestr[0];
    };*/