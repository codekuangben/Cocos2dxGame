package modulefight.tianfu
{
	//import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.netmsg.stmsg.stTianFuData;
	import modulefight.netmsg.stmsg.TianfuPart;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author ...
	 * 需要客户端处理数值的天赋列表
	 * 
	 * Tianfu_RenJun	加士气
	 * Tianfu_XiaoXiong	加兵力
	 * Tianfu_WuWei		加兵力
	 * Tianfu_DiMeng	加士气和兵力
	 * Tianfu_ShaShen	加士气
	 * Tianfu_LianYing	减士气
	 */
	public class TianfuMgr
	{
		public static const TIANFU_LongDan:uint = 7801; //龙胆
		public static const TIANFU_ShenYong:uint = 7811; //神勇
		public static const TIANFU_XiaoXiong:uint = 7821; //枭雄
		public static const TIANFU_FeiJiang:uint = 7831; //飞将
		public static const TIANFU_ShenYi:uint = 7841; //神医
		//public static const TIANFU_ShiPo:uint = 7049; //识破
		public static const TIANFU_WuWei:uint = 7851; //无为
		public static const TIANFU_RenJun:uint = 7861; //仁君
		public static const TIANFU_JiaSi:uint = 7052; //假死
		public static const TIANFU_LaoMou:uint = 7871; //老谋
		public static const TIANFU_WoLong:uint = 7881; //卧龙
		public static const TIANFU_XiaoQi:uint = 7891; //小气
		public static const TIANFU_DiMeng:uint = 7901; //缔盟
		public static const TIANFU_ShaShen:uint = 7911; //杀神
		public static const TIANFU_YueShen:uint = 7058; //月神
		public static const TIANFU_HanJiang:uint = 7921; //捍将
		public static const TIANFU_LianYing:uint = 7931; //连营
		//public static const TIANFU_MoJiang:uint = 7941; //魔将
		public static const TIANFU_MoHua:uint = 7951; //魔化
		public static const TIANFU_ShenShe:uint = 7961; //神射
		public static const TIANFU_Simazhaozhixin:uint = 7064; //司马昭之心
		public static const TIANFU_YiZhi:uint = 7971; //遗志
		public static const TIANFU_WuSheng:uint = 7981; //武圣
		public static const TIANFU_GuiCai:uint = 7991; //鬼才
		public static const TIANFU_Yuhui:uint = 8001; //迂回
		public static const TIANFU_Mengdu:uint = 8011; //猛毒
		public static const TIANFU_Kedi:uint = 8021; //克敌
		public static const TIANFU_Xisheng:uint = 8031; //牺牲
		public static const TIANFU_Shenyin:uint = 7941; //神隐
		
		protected var m_fightDB:FightDB;
		protected var m_gkContext:GkContext;
		protected var m_dicTianfuClass:Dictionary;
		
		public var m_dicList:Dictionary;
		private var m_bTianfuTrigger:Boolean;
		
		public function TianfuMgr(fightDB:FightDB)
		{
			m_fightDB = fightDB;
			m_gkContext = m_fightDB.m_gkcontext;
			m_dicList = new Dictionary();
			init();
		}
		
		private function init():void
		{
			m_dicTianfuClass = new Dictionary();
			m_dicTianfuClass[TIANFU_LongDan] = Tianfu_LongDan;
			m_dicTianfuClass[TIANFU_ShenYong] = Tianfu_ShenYong;
			m_dicTianfuClass[TIANFU_RenJun] = Tianfu_RenJun;
			m_dicTianfuClass[TIANFU_XiaoXiong] = Tianfu_XiaoXiong;
			m_dicTianfuClass[TIANFU_WuWei] = Tianfu_WuWei;
			m_dicTianfuClass[TIANFU_XiaoQi] = Tianfu_XiaoQi;
			m_dicTianfuClass[TIANFU_FeiJiang] = Tianfu_FeiJiang;
			m_dicTianfuClass[TIANFU_ShenYi] = Tianfu_Shenyi;
			m_dicTianfuClass[TIANFU_LaoMou] = Tianfu_LaoMou;
			m_dicTianfuClass[TIANFU_WoLong] = Tianfu_WoLong;
			m_dicTianfuClass[TIANFU_DiMeng] = Tianfu_DiMeng;
			m_dicTianfuClass[TIANFU_ShaShen] = Tianfu_ShaShen;
			m_dicTianfuClass[TIANFU_HanJiang] = Tianfu_HanJiang;
			m_dicTianfuClass[TIANFU_LianYing] = Tianfu_LianYing;
			//m_dicTianfuClass[TIANFU_MoJiang] = Tianfu_MoJiang;
			m_dicTianfuClass[TIANFU_MoHua] = Tianfu_MoHua;
			m_dicTianfuClass[TIANFU_ShenShe] = Tianfu_ShenShe;
			m_dicTianfuClass[TIANFU_YiZhi] = Tianfu_YiZhi;
			m_dicTianfuClass[TIANFU_WuSheng] = Tianfu_WuSheng;
			m_dicTianfuClass[TIANFU_GuiCai] = Tianfu_GuiCai;
			
			m_dicTianfuClass[TIANFU_Yuhui] = Tianfu_Yuhui;
			m_dicTianfuClass[TIANFU_Mengdu] = Tianfu_Mengdu;
			m_dicTianfuClass[TIANFU_Kedi] = Tianfu_Kedi;
			m_dicTianfuClass[TIANFU_Xisheng] = Tianfu_Xisheng;
			m_dicTianfuClass[TIANFU_Shenyin] = Tianfu_Shenyin;
		}
		
		public function createTianfu(fightGrid:FightGrid):TianfuBase
		{
			var baseTianfuID:uint;			
			var skillBaseItem:TSkillBaseItem = fightGrid.matrixInfo.activeTianfuSkillItem;
			if (skillBaseItem == null)
			{
				return null;
			}
			baseTianfuID = fightGrid.matrixInfo.getWuPropertyBase().m_tianfu[3];
			var tianfuClass:Class = m_dicTianfuClass[baseTianfuID];
			if (tianfuClass == null)
			{
				return null;
			}
			
			var ret:TianfuBase = new tianfuClass();
			ret.setInitData(this, m_fightDB, fightGrid, skillBaseItem, baseTianfuID,skillBaseItem.m_uID);
			ret.init();
			addToList(ret);
			return ret;
		}
		
		public function releaseTianfu(tianfu:TianfuBase):void
		{
			removeFromList(tianfu);
			tianfu.dispose();
		}
		
		public function addToList(tianfu:TianfuBase):void
		{
			if (tianfu.type == TianfuBase.TYPE_None)
			{
				return;
			}
			var list:Vector.<TianfuBase> = m_dicList[tianfu.type];
			if (list == null)
			{
				list = new Vector.<TianfuBase>();
				m_dicList[tianfu.type] = list;
			}
			list.push(tianfu);
		}
		
		public function removeFromList(tianfu:TianfuBase):void
		{
			if (tianfu.type == TianfuBase.TYPE_None)
			{
				return;
			}
			var list:Vector.<TianfuBase> = m_dicList[tianfu.type];
			if (list)
			{
				var i:int = list.indexOf(tianfu);
				if (i != -1)
				{
					list.splice(i, 1);
				}
				if (list.length == 0)
				{
					delete m_dicList[tianfu.type];
				}
			}
		}
		
		/*
		 * 部队死亡时,会触发天赋的情况下,相关函数-开始
		 */
		//当有部队死亡时，调用此函数
		public function onFightGridDie(fightGrid:FightGrid):void
		{
			var list:Vector.<TianfuBase> = m_dicList[TianfuBase.TYPE_BuDuDie];
			var tianfu:Tianfu_GridDieTrigerBase;
			for each (tianfu in list)
			{
				tianfu.onFightGridDie(fightGrid);
			}
		}
		
		public function isNotifyFightGridDie():Boolean
		{
			return m_dicList[TianfuBase.TYPE_BuDuDie] != undefined;
		}
		
		//有武将回血，释放通知
		public function isNotifyRestoreHP():Boolean
		{
			return m_dicList[TianfuBase.TYPE_RestoreHP] != undefined;
		}
		
		public function processTianfuData(tianfuDataPart:TianfuPart):void
		{
			m_bTianfuTrigger = false;
			var tianfu:stTianFuData;
			var grid:FightGrid;
			for each(tianfu in tianfuDataPart.m_list)
			{
				grid = m_fightDB.getFightGrid(tianfu.pos);
				var tianfuBase:TianfuBase = grid.tianfu;
				if (tianfuBase)
				{
					tianfuBase.exec(tianfu);
				}
			}
		}
		/*
		 * 部队死亡时,会触发天赋的情况下,相关函数-结束
		 */
		
		//回合开始的时候，调用此函数
		/*public function trigerByRoundBegin():void
		{
			m_bTianfuTrigger = false;
			var tianfu:TianfuBase;
			var list:Vector.<TianfuBase> = m_dicList[TianfuBase.TYPE_RoundBegin];
			var tianfuData:stTianFuData;
			for each (tianfu in list)
			{
				if (tianfu)
				{					
					if (tianfu.isTriger())
					{
						tianfu.exec();
					}
				}
			}
		}*/
		
		/*public function trigerByBuduiDie():void
		{
			m_bTianfuTrigger = false;
			var tianfu:Tianfu_GridDieTrigerBase;
			var list:Vector.<TianfuBase> = m_dicList[TianfuBase.TYPE_BuDuDie];
			for each (tianfu in list)
			{
				if (tianfu)
				{
					if (tianfu.isTriger())
					{
						tianfu.exec();
					}
				}
			}
		}*/
		
		/*public function trigerByAttackEnd(bat:BattleArray):void
		{
			m_bTianfuTrigger = false;
			var tianfu:TianfuBase;
			var list:Vector.<TianfuBase> = m_dicList[TianfuBase.TYPE_BuDuDie];
			for each (tianfu in list)
			{
				if (tianfu)
				{
					if (tianfu.isTriger(bat))
					{
						tianfu.exec(bat);
					}
				}
			}
			list = m_dicList[TianfuBase.TYPE_AttackEnd];
			if (list)
			{
				for each (tianfu in list)
				{
					if (tianfu)
					{
						if (tianfu.isTriger(bat))
						{
							tianfu.exec(bat);
						}
					}
				}
			}
		}*/
		
		//回血触发。这样的天赋不需要延时
		public function onFightGridRestoreHP(fightGrid:FightGrid):void
		{
			var tianfu:TianfuBase;
			var list:Vector.<TianfuBase> = m_dicList[TianfuBase.TYPE_RestoreHP];
			for each (tianfu in list)
			{
				if (tianfu)
				{
					if (tianfu.isTriger(fightGrid))
					{
						tianfu.exec();
					}
				}
			}
		}
		
		public function setTriggerTianfu():void
		{
			m_bTianfuTrigger = true;
		}
		
		public function get isTianfuTriggered():Boolean
		{
			return m_bTianfuTrigger;
		}
		
		public function get timeForPlayTianfAni():Number
		{
			return 1;
		}
	
	}

}