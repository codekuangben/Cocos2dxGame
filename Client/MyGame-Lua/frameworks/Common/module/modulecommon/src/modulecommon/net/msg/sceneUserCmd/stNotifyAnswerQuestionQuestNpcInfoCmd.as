package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stNotifyAnswerQuestionQuestNpcInfoCmd extends stSceneUserCmd 
	{
		public var m_mapid:uint;
		public var m_npcid:uint;
		public var m_posx:uint;
		public var m_posy:uint;
		public function stNotifyAnswerQuestionQuestNpcInfoCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_NOTIFY_ANSWER_QUESTION_QUESTNPC_INFO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_mapid = byte.readUnsignedInt();
			m_npcid = byte.readUnsignedInt();
			m_posx = byte.readUnsignedShort();
			m_posy = byte.readUnsignedShort();
		}
	}

}
/*//答题任务发布npc信息
    const BYTE PARA_NOTIFY_ANSWER_QUESTION_QUESTNPC_INFO_USERCMD = 70;
	struct stNotifyAnswerQuestionQuestNpcInfoCmd : public stSceneUserCmd
    {    
        stNotifyAnswerQuestionQuestNpcInfoCmd()
        {    
            byParam = PARA_NOTIFY_ANSWER_QUESTION_QUESTNPC_INFO_USERCMD;
            mapid = npcid = 0; 
            x = y = 0; 
        }    
        DWORD mapid;
        DWORD npcid;
        WORD x;
        WORD y;
    };   */