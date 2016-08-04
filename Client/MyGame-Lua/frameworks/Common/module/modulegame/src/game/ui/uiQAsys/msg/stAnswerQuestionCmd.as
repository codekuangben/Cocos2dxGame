package game.ui.uiQAsys.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAnswerQuestionCmd extends stSceneUserCmd 
	{
		public var m_result:uint;
		public function stAnswerQuestionCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_ANSWER_QUESTION_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_result);
		}
	}

}
/*//答题
    const BYTE PARA_ANSWER_QUESTION_USERCMD = 72;
    struct stAnswerQuestionCmd : public stSceneUserCmd
    {
        stAnswerQuestionCmd()
        {
            byParam = PARA_ANSWER_QUESTION_USERCMD;
            result = 0;
        }
        BYTE result;    //0:错误 1:正确 
    };*/