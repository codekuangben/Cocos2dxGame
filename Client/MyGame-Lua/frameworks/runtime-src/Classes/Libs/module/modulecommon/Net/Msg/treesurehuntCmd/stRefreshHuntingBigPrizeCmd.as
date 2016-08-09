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
	public class stRefreshHuntingBigPrizeCmd extends stSceneUserCmd 
	{
		public var m_bigprizestr:Array;
		public var m_superprizestr:Array;
		public function stRefreshHuntingBigPrizeCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_REFRESH_HUNTING_BIGPRIZE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var bigprizestr:String = UtilTools.readStrEx(byte);
			m_bigprizestr = bigprizestr.split("|");
			if (m_bigprizestr.length > 0)
			{
				m_bigprizestr.pop();
			}
			var superprizestr:String = UtilTools.readStrEx(byte);
			m_superprizestr = superprizestr.split("|");
			if (m_superprizestr.length > 0)
			{
				m_superprizestr.pop();
			}
		}
		
	}

}
/*	//刷新大奖纪录
    const BYTE PARA_REFRESH_HUNTING_BIGPRIZE_USERCMD = 62;
    struct stRefreshHuntingBigPrizeCmd : public stSceneUserCmd
    {    
        stRefreshHuntingBigPrizeCmd()
        {    
            byParam = PARA_REFRESH_HUNTING_BIGPRIZE_USERCMD;
            bigprizesize = superprizesize = 0;
        }
        WORD bigprizesize;
        char bigprizestr[0];
		WORD superprizesize;
        char superprizestr[0];
    };*/