package game.ui.herorally.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sgQunYingCmd.stSGQunYingCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stReqQunYingHuiRankCmd extends stSGQunYingCmd 
	{
		public var m_rankNo:uint;
		public function stReqQunYingHuiRankCmd() 
		{
			super();
			byParam = stSGQunYingCmd.PARA_REQ_QUN_YING_HUI_RANK_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_rankNo);
		}
	}

}/*	//请求排行榜信息
	const BYTE PARA_REQ_QUN_YING_HUI_RANK_CMD = 4;
	struct stReqQunYingHuiRankCmd : public stSGQunYingCmd
	{
		stReqQunYingHuiRankCmd()
		{
			byParam = PARA_REQ_QUN_YING_HUI_RANK_CMD;
			rankno = 0;
		}
		BYTE rankno;	//分组编号
	};*/