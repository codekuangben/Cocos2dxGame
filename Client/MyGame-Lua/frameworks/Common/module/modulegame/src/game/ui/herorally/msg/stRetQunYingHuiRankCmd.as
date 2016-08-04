package game.ui.herorally.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sgQunYingCmd.stSGQunYingCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRetQunYingHuiRankCmd extends stSGQunYingCmd 
	{
		public var m_rankNo:uint;
		public var m_rankList:Array;
		public function stRetQunYingHuiRankCmd() 
		{
			super();
			byParam = stSGQunYingCmd.PARA_RET_QUN_YING_HUI_RANK_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_rankNo = byte.readUnsignedByte();
			var num:uint = byte.readUnsignedShort();
			m_rankList = new Array();
			for (var i:uint = 0; i < num; i++ )
			{
				var rankitem:QYHRankItem = new QYHRankItem();
				rankitem.m_id = i + 1;
				rankitem.deserialize(byte);
				m_rankList.push(rankitem);
			}
		}
		
	}

}/*	//返回排行榜信息
	const BYTE PARA_RET_QUN_YING_HUI_RANK_CMD = 5;
	struct stRetQunYingHuiRankCmd : public stSGQunYingCmd
	{
		stRetQunYingHuiRankCmd()
		{
			byParam = PARA_RET_QUN_YING_HUI_RANK_CMD;
			rankno = 0;
			num = 0;
		}
		BYTE rankno;
		WORD num;
		QYHRankItem ranklist[0];
		WORD getSize()
		{
			return (sizeof(*this) + num*sizeof(QYHRankItem));
		}
	};*/