package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	
	public class stQuestInfoUserCmd extends stQuestUserCmd 
	{
		public var name:String;
		public var info:String;
		public function stQuestInfoUserCmd() 
		{
			byParam = QuestUserParam.QUEST_INFO_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);	
			name = byte.readMultiByte(EnNet.MAX_QUEST_NAME + 1, EnNet.UTF8);
			var size:uint = byte.readUnsignedShort();
			info = byte.readMultiByte(size, EnNet.UTF8);
		}
		
	}
	
	/*
	  const BYTE QUEST_INFO_PARA = 1;
	struct stQuestInfoUserCmd : public stQuestUserCmd
	{
		stQuestInfoUserCmd()
		{
			byParam = QUEST_INFO_PARA;
			bzero(name, MAX_QUEST_NAME + 1);
			size = 0;
		}

		BYTE name[MAX_QUEST_NAME + 1];
		WORD size;
		BYTE info[0];
		WORD getSize() { return size + sizeof(*this); }
	};
	 */

}