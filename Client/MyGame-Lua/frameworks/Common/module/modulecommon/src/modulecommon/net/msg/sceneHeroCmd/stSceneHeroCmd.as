package modulecommon.net.msg.sceneHeroCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	import flash.utils.Dictionary;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stSceneHeroCmd extends stNullUserCmd 
	{		
		public static const PARA_HERO_MAINDATA_USERCMD:uint = 1;
		public static const PARA_GAIN_HERO_USERCMD:uint = 2;
		public static const PARA_HERO_DATA_USERCMD:uint = 3;
		public static const PARA_REQ_HERO_LIST_USERCMD:uint = 4;
		public static const PARA_RET_HERO_LIST_USERCMD:uint = 5;
		public static const PARA_SET_HERO_POSITION_USERCMD:uint = 6;
		public static const PARA_REQ_MATRIX_INFO_USERCMD:uint = 7;
		public static const PARA_RET_MATRIX_INFO_USERCMD:uint = 8;
		public static const PARA_SET_JINNANG_USERCMD:uint = 9;
		public static const PARA_SMART_SET_JINNANG_USERCMD:uint = 10;
		public static const PARA_RET_KITLIST_USERCMD:uint = 11;
		public static const PRAR_TAKEDOWN_FROM_MATRIX_USERCMD:uint = 12;
		public static const PARA_TAKEDOWN_KIT_USERCMD:uint = 13;
		public static const PARA_REQ_HERO_ENLIST_COST_USERCMD:uint = 15;
		public static const PARA_RET_HERO_ENLIST_COST_USERCMD:uint = 16;
		public static const PARA_HEROCOLOR_CHANGE_USERCMD:uint = 17;
		public static const PARA_JIUGUAN_HEROLIST_USERCMD:uint = 18;	//���߷��;ƹ��佫�б�
		public static const PARA_ADDHERO_TO_JIUGUAN_USERCMD:uint = 19;	//��ƹ������һ���佫
		public static const PARA_REQ_REBIRTH_USERCMD:uint = 20;		//�����佫ת��
		public static const PARA_REFRESH_HERONUM_USERCMD:uint = 21;	//ˢ���佫����
		public static const PARA_REMOVE_HERO_USERCMD:uint = 22;		//ɾ���佫
		public static const PARA_NOTIFY_OPEN_ZHENWEI_USERCMD:uint = 23;		//֪ͨ������λ
		public static const PARA_RET_REBIRTH_SUCCESS_USERCMD:uint = 24;		//ת��ɹ�
		public static const PARA_REQ_RICHER_AND_ENEMY_LIST_USERCMD:uint = 25;
		public static const PARA_RET_RICHER_AND_ENEMY_LIST_USERCMD:uint = 26;
		public static const PARA_REQ_QIANGDUO_USERCMD:uint = 27;
		public static const PARA_BUY_ROBTIMES_COST_USERCMD:uint = 28;
		public static const PARA_REQ_BUY_ROBTIMES_USERCMD:uint = 29;
		public static const PARA_AFTER_ROB_SHOW_TIPS_USERCMD:uint = 30;
		public static const PARA_VIEWED_HERO_LIST_USERCMD:uint = 31;
		public static const PARA_LEFT_ROBTIMES_ONLINE_USERCMD:uint = 32;
		public static const PARA_SET_HERO_XIAYE_USERCMD:uint = 33;
		public static const PARA_HERO_TRAINING_USERCMD:uint = 34;//�佫����
		public static const PARA_RET_HEROTRAINING_INFO_USERCMD:uint = 35;//����������Ϣ
		public static const PARA_ADD_HERO_PURPLE_HEROLIST_USERCMD:uint = 36;	//��һ���Ͻ����뵽�Ͻ��б���
		public static const PARA_PURPLE_HEROLIST_USERCMD:uint = 37;				//����ļ�Ͻ��б�
		public static const NOTIFY_ROB_NUMBER_USERCMD:uint = 38;
		public static const REQ_DETAIL_ROB_INFO_USERCMD:uint = 39;
		public static const RET_DETAIL_ROB_INFO_USERCMD:uint = 40;
		public static const REQ_ROB_PK_REVIEW_USERCMD:uint = 41;
		public static const PARA_HERO_REBIRHT_CACHE_HERO_EQUIP_CMD:uint = 42;
		public static const PARA_PUT_CACHE_EQUIP_TO_REBIRTH_HERO_CMD:uint = 43;
		public static const PARA_REFRESH_ROB_TARGET_HERO_CMD:uint = 44;
		public static const PARA_ROB_ENEMY_TIMES_HERO_CMD:uint = 45;
		public static const PARA_REQ_ROB_ENEMY_HERO_CMD:uint = 46;
		public static const GM_PARA_VIEWED_HERO_LIST_USERCMD:uint = 47;
		
		public function stSceneHeroCmd()
		{
			byCmd = HERO_USERCMD;
		}
		
		public static function initMsg():void
		{
			pushDic(PARA_SET_HERO_XIAYE_USERCMD, "stSetHeroXiaYeCmd--stSceneHeroCmd");
		}
		
		public static function pushDic(param:uint, name:String):void
		{
			s_dicMsg[s_toKey(HERO_USERCMD, param)] = name;
		}
	}

}