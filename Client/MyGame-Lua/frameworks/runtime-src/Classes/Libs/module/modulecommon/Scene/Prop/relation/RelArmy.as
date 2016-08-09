package modulecommon.scene.prop.relation
{
	import com.util.DebugBox;
	import com.util.UtilXML;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.net.msg.corpscmd.notifyCorpsFirePosUserCmd;
	import modulecommon.net.msg.corpscmd.notifyCorpsKejiPropValueUserCmd;
	import modulecommon.net.msg.corpscmd.notifyMaxQuestTimesUserCmd;
	import modulecommon.net.msg.corpscmd.reqCorpsAllQuestInfoUserCmd;
	import modulecommon.net.msg.corpscmd.retAssignBoxUiCorpsMemberListUserCmd;
	import modulecommon.net.msg.corpscmd.stNotifyCorpsLotteryTimesCmd;
	import modulecommon.net.msg.corpscmd.stRetLotteryResultUserCmd;
	import modulecommon.net.msg.corpscmd.updateCorpsLevelUserCmd;
	import modulecommon.net.msg.corpscmd.ViewUserCorpsKejiPropValueUserCmd;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.MapInfo;
	import modulecommon.uiinterface.IUITaskTrace;
	//import modulecommon.net.msg.corpscmd.updateCoolDownTimeCorpsUserCmd;
	import modulecommon.net.msg.corpscmd.updateCorpsBoxNumberUserCmd;	
	import modulecommon.scene.prop.relation.corps.corpsCoolDownMgr;
	import modulecommon.scene.prop.relation.corps.CorpsQuestItem;
	//import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUICorpsMgr;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.corpscmd.notifyCorpsNameUserCmd;
	import modulecommon.net.msg.corpscmd.reqCorpsInfoUserCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICorpsInfo;
	/**
	 * @brief 军团数据
	 */
	public class RelArmy
	{
		//军团的几个界面常量
		public static const eTWBuild:uint = 0;		// 建筑
		public static const eTWMember:uint = 1;		// 成员
		public static const eTWDynamic:uint = 2;		// 动态
		public static const eTWDuobao:uint = 3;		// 夺宝
		//public static const eTWDepot:uint = 3;		// 仓库
		//public static const eTWCBattle:uint = 3;		// 军团城战
		public static const eTWNUM:uint = 4;		// 军团城战
		
		
		public static const TQ_TUANZHANG:uint = 1;		// 团长
		public static const TQ_FUTUANZHANG:uint = 2;		// 副团长
		public static const TQ_JINGYING:uint = 3;		// 精英
		public static const TQ_TUANYUAN:uint = 4;		// 团员
		
		public static const KejiMaxLevel:uint = 20;		//
		
		public static const TSX_QIAN_FANG:uint = 0;		//前军双防
		public static const TSX_QIAN_BINGLI:uint = 1;	//前军兵力
		public static const TSX_QIAN_YUNQI:uint = 2;	//前军运气
		public static const TSX_ZHONG_GONG:uint = 3;	//中军攻击
		public static const TSX_ZHONG_POJI:uint = 4;	//中军破击
		public static const TSX_ZHONG_SUDU:uint = 5;	//中军速度
		public static const TSX_HOU_GONG:uint = 6;		//后军攻击
		public static const TSX_HOU_BAOJI:uint = 7;		//后军暴击
		public static const TSX_HOU_SUDU:uint = 8;		//后军速度
		public static const TSX_XIULIANSUDU:uint = 9;	//修炼速度
		public static const TSX_MAX:uint = 10;
		
		public var m_gkContext:GkContext;
		public var m_openPageID:uint = uint.MAX_VALUE;
		public var m_openFormID:uint = uint.MAX_VALUE;
		public var m_uiMgr:IUICorpsMgr;
		public var m_ui:IUICorpsInfo;
		public var m_corpsInfo:CorpsInfo;
		protected var m_KejiInfolist:Vector.<KejiItemInfo>;
		protected var m_dicLotteryInfo:Dictionary;	//军团抽奖奖励信息
		public var m_taskInfoList:Array;	//元素类型CorpsQuestItem
		
		public var m_corpsID:uint;
		public var m_corpsName:String;
		public var m_uprivilege:uint = 4;
		public var m_kejiLearnd:Array;	//KejiLearnedItem
		public var m_numCorpsBox:uint;	//军团宝箱
		public var m_memberList:Array;	//军团成员信息列表(名字、职称、战力)
		public var m_taskMaxCounts:uint;	//每日可接取军团任务最大次数(当前军团等级)
		public var m_taskCounts:uint;		//今日军团任务次数
		public var m_coolDownMgr:corpsCoolDownMgr;
		public var m_lotteryMaxCounts:uint;	//当前军团等级最大可抽奖次数
		public var m_lotteryCounts:uint;	//今日军团抽奖次数
		public var m_reg:uint;				//自己所在的军团是否报名
		public var m_firePos:Point;			//军团聚餐地点
		public var m_otherKejiLearnd:Array;	//观察其他玩家军团科技信息
		
		public function RelArmy(gk:GkContext)
		{
			m_gkContext = gk;
			m_corpsName = "";
			m_corpsInfo = new CorpsInfo();
		}
		
		//返回值表示自己是否已有军团
		public function get hasCorps():Boolean
		{
			return m_corpsName.length > 0;
		}
		
		public function processNotifyCorpsNameUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:notifyCorpsNameUserCmd = new notifyCorpsNameUserCmd();
			rev.deserialize(msg);
			m_corpsID = rev.corpsid;
			m_corpsName = rev.name;
			m_uprivilege = rev.priv;
			m_taskCounts = rev.cishu;
			m_reg = rev.reg;
			m_corpsInfo.gongxian = rev.contr;
			m_corpsInfo.level = rev.corpslevel;
			
			if (m_gkContext.playerMain)
			{
				m_gkContext.playerMain.updateNameDesc();
			}
			if (m_corpsName.length == 0)
			{
				//表示退团了
				if (m_ui && m_ui.isVisible())
				{
					m_ui.exit();
				}
			}
			
			if (m_gkContext.m_uiChat)
			{
				m_gkContext.m_uiChat.updateOnCorps();
			}
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.processCmd(msg, param);
				m_gkContext.m_corpsMgr.m_ui.updateDataByPage(eTWBuild);
			}
			
		}
		
		public function processCorpsKejiPropValueUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:notifyCorpsKejiPropValueUserCmd = new notifyCorpsKejiPropValueUserCmd();
			rev.deserialize(msg);
			m_kejiLearnd = rev.m_list;
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiLearn);
			if (ui)
			{
				var obj:Object = new Object();
				obj["msg"] = msg;
				obj["param"] = param;
				ui.updateData(obj);
			}
		}
		
		public function process_updateCorpsLevelUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateCorpsLevelUserCmd = new updateCorpsLevelUserCmd();
			rev.deserialize(msg);
			m_corpsInfo.level = rev.corpslevel;
		}
		
		//上线通知抽奖次数
		public function processNotifyCorpsLotteryTimesUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:stNotifyCorpsLotteryTimesCmd = new stNotifyCorpsLotteryTimesCmd();
			rev.deserialize(msg);
			
			m_lotteryCounts = rev.lotterytimes;
		}
		
		public function requestCorpsInfo():void
		{
			var send: reqCorpsInfoUserCmd = new reqCorpsInfoUserCmd();
			send.corpsid = m_corpsID;
			
			m_gkContext.sendMsg(send);
		}
		
		public function resetOpenPageID():void
		{
			m_openPageID = uint.MAX_VALUE;
		}
		
		//打开兵团界面中的某个页面
		public function openPage(pageID:uint = eTWBuild):void		
		{
			if (m_ui)
			{				
				m_ui.show();
				m_ui.openPage(pageID);
				
			}
			else
			{
				m_openPageID = pageID;
				if (m_uiMgr)
				{
					m_uiMgr.showForm(UIFormID.UICorpsInfo);
				}
				else
				{
					m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsMgr);
				}
			}
		}
		public function openForm(id:uint):void		
		{
			m_openFormID = id;
			if (m_uiMgr)
			{
				m_uiMgr.showForm(m_openFormID);
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsMgr);
			}
		}
		
		public function dispose():void
		{
			
		}
		public function get isTuanzhang():Boolean
		{
			return m_uprivilege == TQ_TUANZHANG;
		}
		
		//是团长或副团长
		public function get isTuanzhangOrFuTuanzhang():Boolean
		{
			return m_uprivilege == TQ_TUANZHANG || m_uprivilege == TQ_FUTUANZHANG;
		}

		public function loadKejiConfig():void
		{
			if (m_KejiInfolist)
				return;
			m_KejiInfolist = new Vector.<KejiItemInfo>();
			
			var itemXML:XML;
			var xml:XML = m_gkContext.m_commonXML.getItem(3);
			var xmlList:XMLList = xml.child("tuanKeji");
			var dataItem:KejiItemInfo;
			for each(itemXML in xmlList)
			{
				dataItem = new KejiItemInfo();
				dataItem.m_type = UtilXML.attributeIntValue(itemXML, "type");
				dataItem.m_name = itemXML.attribute("name");
				dataItem.m_desc = itemXML.attribute("desc");
				m_KejiInfolist.push(dataItem);
			}
			m_gkContext.m_commonXML.deleteItem(3);
		}
		public function getKejiInfoByType(type:int):KejiItemInfo
		{
			if (m_KejiInfolist == null)
			{
				loadKejiConfig();
			}
			return m_KejiInfolist[type];
		}
		
		public function requestTaskInfoList():void
		{
			if (m_taskInfoList == null)
			{
				var send: reqCorpsAllQuestInfoUserCmd = new reqCorpsAllQuestInfoUserCmd();
				m_gkContext.sendMsg(send);
			}
		}
		
		public function getCorpsQuestItem(id:uint):CorpsQuestItem
		{
			var item:CorpsQuestItem;
			for each(item in m_taskInfoList)
			{
				if (item.m_taskID == id)
				{
					return item;
				}
			}
			var str:String="[团任务]缺少"+id.toString()+"的配置（配置文件是server/config/juntuan.xml）";
			DebugBox.info(str);
			return null;
		}
		public static function s_privilegeName(pri:uint):String
		{
			var ret:String;
			switch(pri)
			{
				case TQ_TUANZHANG:ret = "团长"; break;
				case TQ_FUTUANZHANG:ret = "副团长"; break;
				case TQ_JINGYING:ret = "精英"; break;
				case TQ_TUANYUAN:ret = "团员"; break;
			}
			return ret;
		}
		
		//更新争霸宝箱个数
		public function processUpdateCorpsBoxNumberUsercmd(msg:ByteArray, param:uint):void
		{
			var ret:updateCorpsBoxNumberUserCmd = new updateCorpsBoxNumberUserCmd();
			ret.deserialize(msg);
			
			m_numCorpsBox = ret.num;
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateCorpsBoxNums();
			}
		}
		
		//返回分配宝箱军团成员列表
		public function processAssignBoxUICorpsMemberListUserCmd(msg:ByteArray, param:uint):void
		{
			var ret:retAssignBoxUiCorpsMemberListUserCmd = new retAssignBoxUiCorpsMemberListUserCmd();
			ret.deserialize(msg);
			m_memberList = ret.dataList;
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsBoxAssign);
			if (ui)
			{
				var obj:Object = new Object();
				ui.updateData(m_memberList);
			}
			else
			{
				m_uiMgr.showForm(UIFormID.UICorpsBoxAssign);
			}
		}
		
		//更新每日可接任务最大次数
		public function processNotifyMaxQuestTimesUserCmd(msg:ByteArray, param:uint):void
		{
			var ret:notifyMaxQuestTimesUserCmd = new notifyMaxQuestTimesUserCmd();
			ret.deserialize(msg);
			
			m_taskMaxCounts = ret.num;
			m_lotteryMaxCounts = ret.lotterynum;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updatePrompt();
			}
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateDataByPage(eTWBuild);
			}
		}
		
		//更新军团冷却
		public function process_updateCoolDownTimeCorpsUserCmd(msg:ByteArray, param:uint):void
		{			
			if (this.isTuanzhangOrFuTuanzhang == false)
			{
				return;
			}
			if (m_coolDownMgr==null)
			{
				m_coolDownMgr = new corpsCoolDownMgr(m_gkContext);
			}
			m_coolDownMgr.process_updateCoolDownTimeCorpsUserCmd(msg, param);
		}
		
		//观察玩家军团科技信息
		public function processViewUserCorpsKejiPropValueUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:ViewUserCorpsKejiPropValueUserCmd = new ViewUserCorpsKejiPropValueUserCmd();
			rev.deserialize(msg);
			
			m_otherKejiLearnd = rev.m_list;
		}
		
		/**begin************************************军团抽奖***/
		public function loadLotteryConfig():void
		{
			if (m_dicLotteryInfo)
			{
				return;
			}
			m_dicLotteryInfo = new Dictionary();
			
			var itemXML:XML;
			var xml:XML = m_gkContext.m_commonXML.getItem(7);
			var xmlList:XMLList = xml.child("item");
			var dataItem:LotteryItemInfo;
			for each(itemXML in xmlList)
			{
				dataItem = new LotteryItemInfo();
				dataItem.m_index = UtilXML.attributeIntValue(itemXML, "index");
				dataItem.m_id = UtilXML.attributeIntValue(itemXML, "id");
				dataItem.m_name = itemXML.attribute("name");
				dataItem.m_icon = itemXML.attribute("icon");
				m_dicLotteryInfo[dataItem.m_index] = dataItem;
			}
			
			m_gkContext.m_commonXML.deleteItem(7);
		}
		
		public function getLotterInfoByIndex(index:uint):LotteryItemInfo
		{
			if (m_dicLotteryInfo == null)
			{
				loadLotteryConfig();
			}
			
			return m_dicLotteryInfo[index];
		}
		
		//返回军团抽奖结果
		public function processRetLotteryResultUserCmd(msg:ByteArray, param:uint):void
		{
			var ret:stRetLotteryResultUserCmd = new stRetLotteryResultUserCmd();
			ret.deserialize(msg);
			m_lotteryCounts = ret.m_cishu;
			
			var info:Object = new Object();
			info["rewardtype"] = ret.m_rewardtype;
			info["extra"] = ret.m_extra;
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsLottery);
			if (ui)
			{
				ui.updateData(info);
			}
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateDataByPage(eTWBuild);
			}
		}
		
		//剩余军团抽奖次数
		public function get leftLotteryCounts():uint
		{
			return (m_lotteryCounts < m_lotteryMaxCounts)? (m_lotteryMaxCounts - m_lotteryCounts): 0;
		}
		/**End************************************军团抽奖***/
		
		public function get taskCounts():uint
		{
			return m_taskCounts;
		}
		
		public function set taskCounts(value:uint):void
		{
			m_taskCounts = value;
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateDataByPage(eTWBuild);
			}
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			m_taskCounts = 0;
			m_lotteryCounts = 0;
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateDataByPage(eTWBuild);
			}
		}
		
		//获得军团科技加成属性对应阵位
		public static function getZhenweiTSX(type:int):int
		{
			var ret:int;
			
			switch(type)
			{
				case TSX_QIAN_BINGLI:
				case TSX_QIAN_FANG:
				case TSX_QIAN_YUNQI:
					ret = ZhenfaMgr.ZHENWEI_FRONT;
					break;
				case TSX_ZHONG_GONG:
				case TSX_ZHONG_POJI:
				case TSX_ZHONG_SUDU:
					ret = ZhenfaMgr.ZHENWEI_MIDDLE;
					break;
				case TSX_HOU_BAOJI:
				case TSX_HOU_GONG:
				case TSX_HOU_SUDU:
					ret = ZhenfaMgr.ZHENWEI_BACK;
					break;
				default:
					ret = 0;
			}
			
			return ret;
		}
		
		//通知军团聚餐坐标
		public function processNotifyCorpsFirePosUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:notifyCorpsFirePosUserCmd = new notifyCorpsFirePosUserCmd();
			rev.deserialize(msg);
			
			m_firePos = new Point(rev.m_firePosX, rev.m_firePosY);
			//showCorpsFirePrompt();
			
			var hintParam:Object = new Object();
			hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_ActFeature;
			hintParam["featuretype"] = HintMgr.ACTFUNC_CORPSFIRE;
			m_gkContext.m_hintMgr.hint(hintParam);
		}
		
		//军团聚餐提示
		public function showCorpsFirePrompt():void
		{
			var desc:String = "军团已在【长安城】发起军团聚餐，参加将获得大量经验，请问现在要过去么？";
			m_gkContext.m_confirmDlgMgr.showMode1(0, desc, onConfirmFun, null, "立刻去", "取消");
		}
		
		public function onConfirmFun():Boolean
		{
			if (m_gkContext.m_mapInfo.m_bInArean)
			{
				m_gkContext.m_systemPrompt.prompt("请先退出竞技场再去长安城聚餐");
			}
			else if (MapInfo.MTMain == m_gkContext.m_mapInfo.mapType())
			{
				var ui:IUITaskTrace = m_gkContext.m_UIs.taskTrace;
				if(ui)
				{
					ui.gotoFunc(m_firePos.x, m_firePos.y, MapInfo.MAPID_CHANGAN, 0);//npcid=0表示跑到指定地点
				}
			}
			else
			{
				m_gkContext.m_systemPrompt.prompt("请出副本后再去长安城聚餐");
			}
			
			return true;
		}
	}
}