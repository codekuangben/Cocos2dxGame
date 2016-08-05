package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class QuestUserParam 
	{		
		public static const QUEST_INFO_PARA:uint = 1;
		public static const QUEST_VARS_PARA:uint = 2;
		public static const REQUEST_QUEST_PARA:uint = 3;
		public static const ABANDON_QUEST_PARA:uint = 4;
		public static const SYN_QUEST_DATA_FIN_PARA:uint = 5;
		
		public static const REQ_OPEN_XUAN_SHANG_QUEST_PARA:uint = 6;		//����������������
		public static const RET_OPEN_XUAN_SHANG_QUEST_PARA:uint = 7;		//������(�����ͽ����)
		public static const REQ_CLOSE_XUAN_SHANG_QUEST_PARA:uint = 8;		//����ر������������
		public static const REQ_REFRESH_XUAN_SHANG_QUEST_PARA:uint = 9;		//��������ˢ��
		public static const RET_REFRESH_XUAN_SHANG_QUEST_PARA:uint = 10;	//����ˢ�µ�QuestItem
		public static const REQ_GET_XUAN_SHANG_QUEST_PARA:uint = 11;		//������ȡһ������
		public static const RET_GET_XUAN_SHANG_QUEST_PARA:uint = 12;		//�����ѽ��������
		public static const REQ_ABANDON_XUAN_SHANG_QUEST_PARA:uint = 13;	//����ȡ����������
		public static const REFRESH_XUAN_SHANG_QUEST_STATE_PARA:uint = 14;	//����ˢ��ĳ���İ�ť״̬(������󣬻������������)
		public static const DIRECT_FINISH_QUEST_PARA:uint = 15;				//����ֱ�����
		public static const REQ_XUAN_SHANG_QUEST_REWARD_PARA:uint = 16;		//������ȡ����
		public static const NOTIFY_CYCLE_QUEST_NUM_PARA:uint = 17;		//ѭ���������
	}

}