package game.ui.uiQAsys.msg 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRetQuestionInfoCmd extends stSceneUserCmd 
	{
		public var m_num:uint;
		public var m_question:String;
		public var m_answersList:Array;
		public function stRetQuestionInfoCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_RET_QUESTION_INFO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_answersList = new Array();
			m_num = byte.readUnsignedShort();
			m_num++;
			var result:uint = byte.readUnsignedByte();
			result--;
			m_question = byte.readMultiByte(EnNet.MAX_VSIZE, EnNet.UTF8);
			for (var i:uint = 0; i < 4; i++ )
			{
				var str:String = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
				m_answersList.push(str);
			}
			m_answersList.push(result);
		}
	}

}
/*//答题信息
    const BYTE PARA_RET_QUESTION_INFO_USERCMD = 71;  
    struct stRetQuestionInfoCmd : public stSceneUserCmd
    {    
        stRetQuestionInfoCmd()
        {
            byParam = PARA_RET_QUESTION_INFO_USERCMD;
            num = 0;
            result = 0;
            bzero(ask,sizeof(ask));
        }
        WORD num;   //已答过题的数量
        BYTE result;    //真确答案编号
        char ask[128];  //问题
        char answers[0];    //所有答案 4*48
    };*/