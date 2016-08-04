package modulecommon.net.msg.questUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRetGetXuanShangQuestUserCmd extends stQuestUserCmd
	{
		private var m_count:uint;
		public function stRetGetXuanShangQuestUserCmd() 
		{
			byParam = QuestUserParam.RET_GET_XUAN_SHANG_QUEST_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_count = byte.readUnsignedByte();
		}
		
		public function get count():uint
		{
			return m_count;
		}
	}

}

/*
	//已接取过的悬赏任务次数
	const BYTE RET_GET_XUAN_SHANG_QUEST_PARA = 12;
	struct stRetGetXuanShangQuestUserCmd : public stQuestUserCmd
	{
		stRetGetXuanShangQuestUserCmd()
		{
			byParam = RET_GET_XUAN_SHANG_QUEST_PARA;
		}
		BYTE count; //第几次接任务
	};
*/