package modulecommon.net.msg.treesurehuntCmd 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import flash.utils.ByteArray
	import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class stTreasureHuntingUIInfoCmd extends stSceneUserCmd 
	{
		public var m_bigprize:Array;
		public var m_superprize:Array;
		public var m_userprize:Array;
		public function stTreasureHuntingUIInfoCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_TREASURE_HUNTING_UIINFO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var bigprize:String = UtilTools.readStrEx(byte);
			m_bigprize = bigprize.split("|");
			if (m_bigprize.length > 0)
			{
				m_bigprize.pop();
			}
			var superprize:String = UtilTools.readStrEx(byte);
			m_superprize = superprize.split("|");
			if (m_superprize.length > 0)
			{
				m_superprize.pop();
			}
			var userprize:String = UtilTools.readStrEx(byte);
			m_userprize = userprize.split("|");
			if (m_userprize.length > 0)
			{
				m_userprize.pop();
			}
		}
		
	}

}
/*const BYTE PARA_TREASURE_HUNTING_UIINFO_USERCMD = 61;
    struct stTreasureHuntingUIInfoCmd : public stSceneUserCmd
    {    
        stTreasureHuntingUIInfoCmd()
        {    
            byParam = PARA_TREASURE_HUNTING_UIINFO_USERCMD;
        }    
        //每条纪录用|隔开
        WORD bigprizesize;      //大奖纪录
        char bigprize[0];
		WORD superprizesize;	//大奖特殊奖记录
        char superprize[0];
        WORD userprizesize;     //个人中奖纪录
        char userprize[0];
    };   */