package game.ui.uihuntexchange.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	
	/**
	 * ...
	 * @author 
	 */
	public class stTHScoreExchangeObjCmd extends stSceneUserCmd 
	{
		public var m_id:uint;
		public function stTHScoreExchangeObjCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_THSCORE_EXCHANGE_OBJ_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_id);
		}
	}

}
/*//寻宝积分兑换物品
    const BYTE PARA_THSCORE_EXCHANGE_OBJ_USERCMD = 76;
    struct stTHScoreExchangeObjCmd : public stSceneUserCmd
    {    
        stTHScoreExchangeObjCmd()
        {    
            byParam = PARA_THSCORE_EXCHANGE_OBJ_USERCMD;
            objid = 0; 
        }    
        DWORD objid;
    };   
*/