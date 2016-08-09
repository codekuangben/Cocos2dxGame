package modulecommon.commonfuntion 
{
	import com.util.UtilCommon;
	/**
	 * ...
	 * @author 
	 * 记录与服务器无关的一些数据
	 */
	public class LocalDataMgr 
	{		
		public static const ShieldKeyEvent_UIOpenNewFeature:int = 0;
		public static const ShieldKeyEvent_UIFocus:int = 1;
		private var m_shieldKeyEvent:uint;
		
		public var m_equipHechengConfig:XML;
		
		
		public function setShieldKeyEvent(type:int):void
		{
			m_shieldKeyEvent = UtilCommon.setStateUint(m_shieldKeyEvent, type);
		}
		public function clearShieldKeyEvent(type:int):void
		{
			m_shieldKeyEvent = UtilCommon.clearStateUint(m_shieldKeyEvent, type);
		}
		public function get isShieldKeyEvent():Boolean
		{
			return m_shieldKeyEvent != 0;
		}
		
		// 记录局部选项
		public static const LDSSound:int = 0;
		public static const LOCAL_HIDE_UIScreenBtn:int = 1;
		public static const LOCAL_HIDE_UITaskTrace:int = 2;
		public static const LOCAL_HIDE_TurnCardState:int = 3;	//处于翻牌状态下
		public static const LOCAL_OpenUIWatch:int = 4;	//UIBackPack对象初始化时，判断是否打开观察界面
		public static const LOCAL_HIDE_UITaskPrompt:int = 5;
		public static const LOCAL_WillIntoBattle:int = 6;	//收到stPrePKUserCmd时，设置此状态，离开战斗是，清除此状态
		public static const LOCAL_UseYuaobaoForXilianshi:int = 7;	//true:表示可用元宝代替洗练石进行洗练		
		public static const LOCAL_ZhanxingNoPromptForHecheng:int = 9;		//占星，一键合成不再提示
		public static const LOCAL_MountsTrain:int = 10;		//坐骑培养购买的时候是否每次总是弹出来
		public static const LOCAL_QiangDuoBaowuBattle:int = 11;	//抢夺宝物战斗
		public static const LOCAL_InBatchMoveObj:int = 12;	//在批量处理道具移动消息过程中
		public static const LOCAL_InNotPlayAniForGetObject:int = 13;	//不播放得到道具动画
		public static const LOCAL_ShowOtherPlayer:int = 14;	//是否隐藏周围玩家，设置就隐藏
		
		////关于GM的一些开关从50开始定义
		public static const LOCAL_GM_ShowMapCoordinate:int = 50;	
		public static const LOCAL_GM_ShowLogInUIChat:int = 51;	//是否想聊天框中输入信息
		public static const LOCAL_GM_ShowMainPlayerMoveLog:int = 52;	//主角移动时，输出移动信息
		public static const LOCAL_GM_ShowNPCID:int = 53;	//显示NPC id
		public static const LOCAL_GM_showTaskInfo:int = 54;	//显示任务信息
		public static const COMMONSET_NUM:int = 55;			// 总的数

		private var m_sysOptions:Vector.<uint>;
		
		public function LocalDataMgr()
		{
			var size:int = int((COMMONSET_NUM + UtilCommon.UNITSIZE - 1) / UtilCommon.UNITSIZE);
			m_sysOptions = new Vector.<uint>(size);
			set(LDSSound);
		}
		
		public function isSet(id:int):Boolean
		{
			return UtilCommon.isSet(m_sysOptions, id);
		}
		
		public function set(id:int):void
		{
			UtilCommon.setState(m_sysOptions, id);
		}
		
		public function clear(id:int):void
		{
			UtilCommon.clearState(m_sysOptions, id);
		}
		
		public function setBool(id:int,b:Boolean):void
		{
			if (b)
			{
				set(id);
			}
			else
			{
				clear(id);
			}
		}
	}
}