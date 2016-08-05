package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	
	public class stRequestQuestUserCmd extends stQuestUserCmd 
	{
		public var target:String;
		public var offset:uint;
		public function stRequestQuestUserCmd() 
		{
			byParam = QuestUserParam.REQUEST_QUEST_PARA;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, target, 16);
			byte.writeByte(offset);
		}	
		
	}

	/*
	 * const BYTE REQUEST_QUEST_PARA = 3;
	struct stRequestQuestUserCmd : public stQuestUserCmd
	{
		stRequestQuestUserCmd()
		{
			byParam = REQUEST_QUEST_PARA;
		}
		char target[16];
		BYTE offset; //任务分支
	};
	*/
}