package modulecommon.scene.jiuguan
{
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.stRobEnemyTimesHeroCmd;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.Form;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.sceneHeroCmd.stAddHeroToJiuGuanCmd;
	import modulecommon.net.msg.sceneHeroCmd.stAddHeroToPurpleListCmd;
	import modulecommon.net.msg.sceneHeroCmd.stAfterRobShowTipsCmd;
	import modulecommon.net.msg.sceneHeroCmd.stJiuGuanHeroListCmd;
	import modulecommon.net.msg.sceneHeroCmd.stLeftRobtimesOnlineCmd;
	import modulecommon.net.msg.sceneHeroCmd.stPurpleHeroListCmd;
	import modulecommon.uiinterface.IUIMailContent;
	//import modulecommon.net.msg.sceneHeroCmd.stRetHeroEnlistCostCmd;
	//import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	import modulecommon.scene.prop.object.ZObject;
	//import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.scene.wu.WuProperty;
	//import modulecommon.scene.prop.table.DataTable;
	import com.util.UtilHtml;
	
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUIJiuGuan;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	
	/**
	 * ...
	 * @author panqiangqiang
	 */
	
	public class JiuguanMgr
	{
		public static const ROB_MAXCOUNTS:uint = 100;	//抢夺宝物次数显示最大值
		
		public static const WU_UNRECRUIT:int = 5;	//未招募
		public static const WU_RECRUIT:int = 4;		//已招募
		public static const WU_PURPLE:int = 3;		//紫将
		public static const WU_BLUE:int = 2;		//蓝将
		public static const WU_GREEN:int = 1;		//绿将
		
		//特殊紫武将
		public static const PURPLE_Dianwei:uint = 172;	//典韦
		public static const PURPLE_Xuchu:uint = 173;	//许褚
		public static const PURPLE_Liru:uint = 174;		//李儒
		public static const PURPLE_Caiwenji:uint = 175;	//蔡文姬
		
		public var m_gkContext:GkContext;
		protected var m_vecList:Vector.<uint>;		//绿将、蓝将
		public var m_HeropubGroup:Vector.<Heropub>;
		public var m_hasRequest:Boolean;
		public var m_openPageID:int;		//5 未招募 4 招募 3 紫将 2 蓝将 1 绿将
		public var m_robLeftTimes:uint;		//宝物抢夺剩余次数
		public var m_robenemytimes:uint;	//抢劫敌人(即复仇)次数
		public var m_dicPurpleHero:Dictionary;		//所有紫武将
		public var m_purpleWuList:Array;			//可招募紫武将(紫武将界面显示亮起来)
		public var m_isRecruitSelectPurWu:Boolean; 	//当前选择紫将是否可招募（酒馆中）
		public var m_curSelectWuID:uint;			//当前选择武将id(TabelID)
		public var m_curSnatchWuID:uint;			//当前所抢宝物对应武将id
		public var m_bnoQuery:Boolean = false;		//宝物抢夺“立即刷新”消费元宝是否提示 true-无提示 false-有提示
		
		private var m_vecSpecialPurpleWu:Vector.<uint>;	//特殊紫武将列表
		
		public function JiuguanMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_vecList = new Vector.<uint>();
			m_dicPurpleHero = new Dictionary();
			m_HeropubGroup = new Vector.<Heropub>();
			m_purpleWuList = new Array();
			m_curSelectWuID = 0;
			m_curSnatchWuID = 0;
			m_vecSpecialPurpleWu = new Vector.<uint>();
		}
		
		public function loadConfig():void
		{
			if (m_hasRequest == true)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Heropub);
			parseXml(xml);		
			
			m_vecSpecialPurpleWu.push(PURPLE_Dianwei);
			m_vecSpecialPurpleWu.push(PURPLE_Xuchu);
			m_vecSpecialPurpleWu.push(PURPLE_Liru);
			m_vecSpecialPurpleWu.push(PURPLE_Caiwenji);
			
			m_hasRequest = true;
		}
		
		public function parseXml(xml:XML):void
		{
			var constellationList:XMLList;
			
			constellationList = xml.child("openlevel");
			var heropub:Heropub;
			for each(var openlevel:XML in constellationList)
			{
				heropub = new Heropub();
				heropub.parseXml(openlevel);
				m_HeropubGroup.push(heropub);
			}
			
			constellationList = xml.child("purplehero");
			var purplewu:ItemPurpleWu;
			for each(var purplehero:XML in constellationList)
			{
				purplewu = new ItemPurpleWu();
				purplewu.parseXml(purplehero);
				m_dicPurpleHero[purplewu.m_id] = purplewu;
			}
		}
		
		//某一紫将，是在玩家多少级开放    wuid:紫将id    return:开放等级段
		public function getHeropubGroupID(wuid:uint):uint
		{
			if (m_HeropubGroup)
			{
				var i:int;
				var j:int;
				var heropub:Heropub;
				for (i = 0; i < m_HeropubGroup.length; i++)
				{
					heropub = m_HeropubGroup[i];
					for (j = 0; j < heropub.m_purpleheroList.length; j++)
					{
						if (wuid == heropub.m_purpleheroList[j])
						{
							return heropub.m_level;
						}
					}
				}
			}
			return 0;
		}
		
		//玩家下一等级段将要显示的紫将
		public function getNextLevelIntervalHero(level:uint):Array
		{
			var i:int;
			var j:int;
			var len:uint = m_HeropubGroup.length;
			var ret:Array = new Array();
			for (i = 0; i < len; i++)
			{
				if (level < m_HeropubGroup[i].m_level)
				{
					break;
				}
			}
			
			if (i < len)
			{
				var list:Vector.<uint> = m_HeropubGroup[i].m_purpleheroList;
				for (i = 0; i < list.length; i++)
				{
					for (j = 0; j < m_purpleWuList.length; j++)
					{
						if (list[i] == m_purpleWuList[j])
						{
							break;
						}
					}
					
					if (j == m_purpleWuList.length)
					{
						ret.push(list[i]);
					}
				}
			}
			
			return ret;
		}
		
		//未开放招募所有紫武将列表
		public function getNoOpenPurpleWuList():Array
		{
			var i:int;
			var j:int;
			var level:uint = m_gkContext.m_mainPro.level;
			var len:uint = m_HeropubGroup.length;
			var ret:Array = new Array();
			var list:Vector.<uint>;
			
			for (i = 0; i < len; i++)
			{
				if (level < m_HeropubGroup[i].m_level)
				{
					list = m_HeropubGroup[i].m_purpleheroList;
					for (j = 0; j < list.length; j++)
					{
						if (!hasWu(list[j]))
						{
							ret.push(list[j]);
						}
					}
				}
			}
			
			for (i = 0; i < m_vecSpecialPurpleWu.length; i++)
			{
				if (!hasWu(m_vecSpecialPurpleWu[i]))
				{
					ret.push(m_vecSpecialPurpleWu[i]);
				}
			}
			
			return ret;
		}
		
		//根据紫将ID，获得紫将招募所需宝物、武将
		public function getBaoWuPurpleWu(wuid:uint):ItemPurpleWu
		{
			return m_dicPurpleHero[wuid] as ItemPurpleWu;
		}
		
		/*
		public function processHeroEnlistCostCmd(msg:ByteArray):void
		{
			var rev:stRetHeroEnlistCostCmd = new stRetHeroEnlistCostCmd();
			rev.deserialize(msg);
			m_vecCost = rev.m_vecCost;
			if (m_gkContext.m_UIs.jiuguan != null)
			{
				m_gkContext.m_UIs.jiuguan.updateCost();
			}
		}*/
		
		public function processJiuGuanHeroListUserCmd(msg:ByteArray):void
		{
			var rev:stJiuGuanHeroListCmd = new stJiuGuanHeroListCmd();
			rev.deserialize(msg);
			m_vecList = rev.list;
			
			loadConfig();
		}
		
		public function processAddHeroToJiuGuanUserCmd(msg:ByteArray):void 
		{
			var rev:stAddHeroToJiuGuanCmd = new stAddHeroToJiuGuanCmd();
			rev.deserialize(msg);
			if ( -1 == m_vecList.indexOf(rev.heroid))
			{
				m_vecList.push(rev.heroid);
			}
		}
		public function processRicherAndEnemyListCmd(msg:ByteArray):void
		{
			m_gkContext.m_contentBuffer.addContent("uiSnatchTreasure_info", msg);
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UISnatchTreasure) as Form;
			if (form)
			{
				form.updateData();
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UISnatchTreasure);
			}
		}
		
		public function processBuyRobtimesCostUserCmd(msg:ByteArray):void
		{
			m_gkContext.m_contentBuffer.addContent("uiSnatchTreasure_cost", msg);
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UISnatchTreasure);
			if (form && form.isVisible())
			{
				form.updateData();
			}
		}
		
		public function processAfterRobShowTipsUserCmd(msg:ByteArray):void
		{
			m_gkContext.m_contentBuffer.addContent("afterRobShowTips_info", msg);
		}
		
		//宝物抢夺剩余次数(上线、变化时收到)
		public function processLeftRobtimesOnlineUserCmd(msg:ByteArray):void
		{
			var rev:stLeftRobtimesOnlineCmd = new stLeftRobtimesOnlineCmd();
			rev.deserialize(msg);
			
			m_robLeftTimes = rev.m_robtimes;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_SnatchTreasure, -1, m_robLeftTimes);
			}
		}
		
		//抢劫敌人(即复仇)次数变化(上线、变化时收到)
		public function processRobEnemyTimesHeroCmd(msg:ByteArray):void
		{
			var rev:stRobEnemyTimesHeroCmd = new stRobEnemyTimesHeroCmd();
			rev.deserialize(msg);
			
			m_robenemytimes = rev.robenemytimes;
			
			var iuiMailContent:IUIMailContent = m_gkContext.m_UIMgr.getForm(UIFormID.UIMailContent) as IUIMailContent;
			if (iuiMailContent)
			{
				iuiMailContent.updatebaowuRansomPanel();
			}
		}
		
		//将一个紫将加入到紫将列表中
		public function processAddHeroPurpleHerolistUserCmd(msg:ByteArray):void
		{
			var ret:stAddHeroToPurpleListCmd = new stAddHeroToPurpleListCmd();
			ret.deserialize(msg);
			
			m_purpleWuList.push(ret.m_wuid);
			m_purpleWuList.sort(compare);
		}
		
		//可招募紫将列表
		public function processPurpleHerolistUserCmd(msg:ByteArray):void
		{
			var ret:stPurpleHeroListCmd = new stPurpleHeroListCmd();
			ret.deserialize(msg);
			
			m_purpleWuList = ret.m_list;
			m_purpleWuList.sort(compare);
		}
		
		public function sortPurpleWuList():void
		{
			m_purpleWuList.sort(compare);
		}
		
		//未招募的排前面
		private function compare(a:uint, b:uint):int
		{
			var wu_a:WuProperty = m_gkContext.m_wuMgr.getLowestWuByTableID(a);
			var wu_b:WuProperty = m_gkContext.m_wuMgr.getLowestWuByTableID(b);
			if (null == wu_a)
			{
				wu_a = m_gkContext.m_wuMgr.getWuByHeroID(a * 10 + 3);
			}
			if (null == wu_b)
			{
				wu_b = m_gkContext.m_wuMgr.getWuByHeroID(b * 10 + 3);
			}
			
			if (null == wu_a && wu_b)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function showTipsOfAfterRob():void
		{
			var date:ByteArray = m_gkContext.m_contentBuffer.getContent("afterRobShowTips_info", true) as ByteArray;
			if (date)
			{
				var rev:stAfterRobShowTipsCmd = new stAfterRobShowTipsCmd();
				rev.deserialize(date);
				
				var desc:String;
				if (1 == rev.sucess)
				{
					var name:String = "";
					var color:uint = 0xffffff;
					var baowu:ZObject = ZObject.createClientObject(rev.baowuID);
					if (baowu)
					{
						name = baowu.name;
						color = baowu.colorValue;
					}
					
					UtilHtml.beginCompose();
					UtilHtml.addStringNoFormat("恭喜你抢夺成功！");
					UtilHtml.breakline();
					
					UtilHtml.addStringNoFormat("获得 【宝物】");
					UtilHtml.add(name, color, 14);
					desc = UtilHtml.getComposedContent();
					m_gkContext.m_confirmDlgMgr.showMode2(0, desc, funConfirm, "关闭");
				}
				else
				{
					m_gkContext.m_confirmDlgMgr.showMode2(0, getStrPrompt(), funConfirm, "关闭");
				}
			}
		}
		
		private function funConfirm():Boolean
		{
			return true;
		}
		
		private function getStrPrompt():String
		{
			var str:String;
			var index:Number = Math.random();
			
			if (index < 0.2)
			{
				str = "虽然你战胜了物主，但他把宝物藏起来了，因此你没抢到宝物，请再接再励！";
			}
			else if (index < 0.4)
			{
				str = "虽然你战胜了物主，但他跪地祈求，你一时心软没有拿他的宝物，请再接再励！";
			}
			else if (index < 0.6)
			{
				str = "虽然你战胜了物主，但他朋友及时赶到阻止了你施暴，你没得到宝物，请再接再励！";
			}
			else if (index < 0.8)
			{
				str = "虽然你战胜了物主，但碰到捕快寻街，你落荒而逃，没得到宝物，请再接再励！";
			}
			else if (index < 1)
			{
				str = "虽然你战胜了物主，但由于她长得像你的初恋，你没有取她宝物，请再接再励！";
			}
			else
			{
				str = "虽然你战胜了物主，但碰到城管寻街，你落荒而逃，没得到宝物，请再接再励！";
			}
			
			return str;
		}
		
		public function get requestAll():Boolean
		{
			return (m_vecList.length != 0 && m_gkContext.m_wuMgr.loaded);
		}
		
		public function hasWu(id:uint):Boolean
		{
			if (false == m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JIUGUAN))
			{
				return false;
			}
			
			for (var i:int = 0; i < m_purpleWuList.length; i++)
			{
				if (m_purpleWuList[i] == id)
				{
					return true;
				}
			}
			
			return m_vecList.indexOf(id) != -1;
		}
		
		public function get evcList():Vector.<uint>
		{
			return m_vecList;
		}
		
		public function setOpenPage(pageID:uint):void
		{
			m_openPageID = pageID;
		}
		
		//紫武将开放时间同宝物抢夺一起
		public function get isPurpleWuOpen():Boolean
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_BAOWUROB))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//7点数据刷新 //宝物抢夺剩余次数累加10次
		public function process7ClockUserCmd():void
		{
			if ((m_robLeftTimes + 10) > ROB_MAXCOUNTS)
			{
				m_robLeftTimes = ROB_MAXCOUNTS;
			}
			else
			{
				m_robLeftTimes += 10;
			}
		}
		
		//获得某一武将招募所需宝物 wuid:tableID  return:宝物ID
		public function getBaowuByWuid(wuid:uint):uint
		{
			var ret:uint = 0;
			var itempurplewu:ItemPurpleWu = getBaoWuPurpleWu(wuid);
			
			if (itempurplewu)
			{
				var index:int;
				var len:int = itempurplewu.m_baowuVec.length;
				
				if (len)
				{
					index = (Math.random() * 10 % len);
				}
				
				ret = itempurplewu.m_baowuVec[index].m_id;
			}
			
			return ret;
		}
		
		//打开酒馆，并打开对应武将招募界面  wuid:武将TableID
		public function openJiuGuanRecruitByWuID(wuid:uint):void
		{
			var npcBase:TNpcBattleItem;
			var pageid:uint;
			
			npcBase = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(wuid);
			if (null == npcBase)
			{
				return;
			}
			
			pageid = npcBase.m_uColor;
			if (WuProperty.COLOR_PURPLE == npcBase.m_uColor && false == isPurpleWuOpen)
			{
				pageid = WU_UNRECRUIT;
				m_gkContext.m_systemPrompt.prompt("紫色武将还未开放");
			}
			
			setOpenPage(npcBase.m_uColor);
			m_curSelectWuID = wuid;
			
			if (m_gkContext.m_sysnewfeatures.openOneFuncForm(SysNewFeatures.NFT_JIUGUAN))
			{
				//打开酒馆界面
			}
			
		}
		
		//武将开放条件
		public function getOpenConditions(wuid:uint):String
		{
			var ret:String = "人物等级达到";
			
			if (PURPLE_Dianwei == wuid)
			{
				ret += "55级，并且通关第65层过关斩将";
			}
			else if (PURPLE_Liru == wuid)
			{
				ret += "55级，并且通关第10层组队BOSS";
			}
			else if (PURPLE_Xuchu == wuid)
			{
				ret += "55级，并且通关第70层过关斩将";
			}
			else if (PURPLE_Caiwenji == wuid)
			{
				ret += "55级，并且通关第11层组队BOSS";
			}
			else
			{
				ret += getHeropubGroupID(wuid).toString() + "级";
			}
			
			return ret;
		}
	}
}