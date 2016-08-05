package modulecommon.net.msg.questUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class notifyCycleQuestNumCmd extends stQuestUserCmd 
	{
		public var num:uint;
		public var max:uint;
		public function notifyCycleQuestNumCmd() 
		{
			super();
			byParam = QuestUserParam.NOTIFY_CYCLE_QUEST_NUM_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			max = byte.readUnsignedShort();
		}
	}

}

//循环任务次数
   /* const BYTE NOTIFY_CYCLE_QUEST_NUM_PARA = 17; 
    struct notifyCycleQuestNumCmd : public stQuestUserCmd
    {   
        notifyCycleQuestNumCmd()
        {   
            byParam = NOTIFY_CYCLE_QUEST_NUM_PARA;
            num = max = 0;
        }
        WORD num; zero based
        WORD max;
    }; */
	