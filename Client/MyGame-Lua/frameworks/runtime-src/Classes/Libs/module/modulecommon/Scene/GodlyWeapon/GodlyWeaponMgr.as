package modulecommon.scene.godlyweapon 
{
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.godlyweaponCmd.stAddGodlyWeaponCmd;
	import modulecommon.net.msg.godlyweaponCmd.stGodlyWeaponSkillTrainCmd;
	import modulecommon.net.msg.godlyweaponCmd.stGodlyWeaponSkillTrainResultCmd;
	import modulecommon.net.msg.godlyweaponCmd.stGodlyWeaponSysInfoCmd;
	import modulecommon.net.msg.godlyweaponCmd.stWearGodlyWeaponCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.scene.vip.VipPrivilegeMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIGodlyWeapon;
	import modulecommon.uiinterface.IUIGWSkill;
	/**
	 * ...
	 * @author ...
	 * 神兵
	 * 属性类型在 MountsAttr.as 中定义(见“图鉴属性”)
	 */
	public class GodlyWeaponMgr 
	{
		public static const GODLYWEAPON_ID1:uint = 1;
		public static const GODLYWEAPON_ID2:uint = 2;
		public static const GODLYWEAPON_ID3:uint = 3;
		public static const GODLYWEAPON_ID4:uint = 4;
		public static const GODLYWEAPON_ID5:uint = 5;
		public static const GODLYWEAPON_ID6:uint = 6;
		public static const GODLYWEAPON_ID7:uint = 7;
		
		public static const TYPE_Wear:uint = 1;		//佩戴
		public static const TYPE_Add:uint = 2;		//获得神兵
		
		//神兵培养
		public static const TRAIN_Greenhun:int = 1;	//绿魂培养
		public static const TRAIN_Bluehun:int = 2;	//蓝魂培养
		public static const TRAIN_Yuanbao:int = 3;	//元宝培养
		
		private var m_gkContext:GkContext;
		private var m_vecWeapon:Vector.<WeaponItem>;
		private var m_gwSkill:GWSkill;		//号令天下(神兵技能)
		
		public var m_loginDays:uint;		//登陆天数
		public var m_onlineTime:uint;		//今日累计在线时间(s)
		public var m_curWearGWId:uint;		//当前佩戴神兵
		public var m_actGWList:Array;		//已获得神兵列表
		
		public var m_maxTrainTimes:uint;	//最大培养次数
		public var m_leftTrainTimes:uint;	//剩余培养次数
		public var m_ybTrainTimes:uint;		//元宝已培养次数
		public var m_addExp:uint;		//培养增加的经验
		public var m_gwsCurLevel:uint;		//神兵等级(号令天下)
		public var m_gwsCurExp:uint;		//神兵当前经验
		public var m_bCrit:Boolean;		//是否暴击
		public var m_bNoQuery:Boolean;	//培养消费元宝是否提示 true-无提示 false-有提示
		
		public var m_bShowUIGWSkill:Boolean;//是否显示号令天下界面
		
		public function GodlyWeaponMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			
			m_actGWList = new Array();
			m_bCrit = false;
			m_bNoQuery = false;
			
			m_bShowUIGWSkill = false;
		}
		
		private function get isLoaded():Boolean
		{
			return (null != m_vecWeapon);
		}
		
		public function parseXml():void
		{
			if (isLoaded)
			{
				return;
			}
			
			m_vecWeapon = new Vector.<WeaponItem>();
			m_gwSkill = new GWSkill();
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_GodlyWeapon);
			var xmlList:XMLList;
			var itemXml:XML;
			var weapon:WeaponItem;
			
			xmlList = xml.child("weapon");
			for each(itemXml in xmlList)
			{
				weapon = new WeaponItem();
				weapon.parseXml(itemXml);
				m_vecWeapon.push(weapon);
			}
			
			var gwskill:GWSkill;
			xmlList = xml.child("gwskill");
			for each(itemXml in xmlList)
			{
				m_gwSkill.parseXml(itemXml);
			}
		}
		
		//上线神兵数据
		public function processGodlyWeaponSysInfoUseCmd(msg:ByteArray):void
		{
			var rev:stGodlyWeaponSysInfoCmd = new stGodlyWeaponSysInfoCmd();
			rev.deserialize(msg);
			
			m_loginDays = rev.loginDay;
			m_onlineTime = rev.onlineTime;
			m_curWearGWId = rev.weargwid;
			m_maxTrainTimes = rev.gwsmaxtraintimes;
			m_leftTrainTimes = rev.leftgwstraintimes;
			m_ybTrainTimes = rev.ybtraintimes;
			m_gwsCurLevel = rev.gwslevel;
			m_gwsCurExp = rev.gwsexp;
			
			var i:int;
			var gwid:uint;
			
			for (i = 0; i < rev.gwList.length; i++)
			{
				gwid = rev.gwList[i];
				m_actGWList.push(gwid);
			}
		}
		
		//获得神兵
		public function processAddGodlyWeaponUseCmd(msg:ByteArray):void
		{
			var rev:stAddGodlyWeaponCmd = new stAddGodlyWeaponCmd();
			rev.deserialize(msg);
			
			if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_GODLYWEAPON))
			{
				m_gkContext.addLog("收到 stAddGodlyWeaponCmd(gwid=" + rev.m_gwId.toString() + ")，但是，神兵（七武器）功能尚未开启！");
				return;
			}
			
			if (!bActGwId(rev.m_gwId))
			{
				m_actGWList.push(rev.m_gwId);
			}
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateGodlyWeapon(rev.m_gwId, TYPE_Add);
			}
			
			if (iUIGodlyWeapon)
			{
				iUIGodlyWeapon.addGodlyWeapon(rev.m_gwId);
			}
			
			//获得第一把神兵后，自动佩戴，并打开神兵界面
			if (GODLYWEAPON_ID1 == rev.m_gwId)
			{
				var cmd:stWearGodlyWeaponCmd = new stWearGodlyWeaponCmd();
				cmd.gwid = GODLYWEAPON_ID1;
				m_gkContext.sendMsg(cmd);
				
				if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGodlyWeapon))
				{
					m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGodlyWeapon);
				}
			}
		}
		
		//佩戴神兵
		public function processWearGodlyWeaponUseCmd(msg:ByteArray):void
		{
			var rev:stWearGodlyWeaponCmd = new stWearGodlyWeaponCmd();
			rev.deserialize(msg);
			
			m_curWearGWId = rev.gwid;
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateGodlyWeapon(rev.gwid, TYPE_Wear);
			}
			
			if (iUIGodlyWeapon && iUIGodlyWeapon.isVisible())
			{
				iUIGodlyWeapon.wearGodlyWeaponSuccess(rev.gwid);
			}
		}
		
		//神兵技能培养返回
		public function processGodlyWeaponSkillTrainResultUserCmd(msg:ByteArray):void
		{
			var rev:stGodlyWeaponSkillTrainResultCmd = new stGodlyWeaponSkillTrainResultCmd();
			rev.deserialize(msg);
			
			m_leftTrainTimes = rev.lefttraintimes;
			m_ybTrainTimes = rev.ybtraintimes;
			m_addExp = rev.addexp;
			m_gwsCurLevel = rev.gwslevel;
			m_gwsCurExp = rev.gwsexp;
			if (1 == rev.baoji)
			{
				m_bCrit = true;
			}
			else
			{
				m_bCrit = false;
			}
			
			var iuigwskill:IUIGWSkill = m_gkContext.m_UIMgr.getForm(UIFormID.UIGWSkill) as IUIGWSkill;
			if (iuigwskill)
			{
				iuigwskill.trainResult();
			}
			
			if (iUIGodlyWeapon)
			{
				iUIGodlyWeapon.updateTrainData();
			}
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateGodlyIconFlashing(m_leftTrainTimes > 0);
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_GodlyWeaponTrain, -1, m_leftTrainTimes);
			}
		}
		
		//请求神兵技能培养 type:培养类型 1-绿魂培养 2-蓝魂培养 3-元宝培养
		public function reqGodlyWeaponSkillTrain(type:int):void
		{
			var cmd:stGodlyWeaponSkillTrainCmd = new stGodlyWeaponSkillTrainCmd();
			cmd.traintype = type;
			m_gkContext.sendMsg(cmd);
		}
		
		public function get iUIGodlyWeapon():IUIGodlyWeapon
		{
			return m_gkContext.m_UIMgr.getForm(UIFormID.UIGodlyWeapon) as IUIGodlyWeapon;
		}
		
		//是否获得该神兵
		public function bActGwId(id:uint):Boolean
		{
			for (var i:int = 0; i < m_actGWList.length; i++)
			{
				if (id == m_actGWList[i])
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function get vecWeapon():Vector.<WeaponItem>
		{
			return m_vecWeapon;
		}
		
		//获得某一神兵信息
		public function getWeaponDataByID(id:uint):WeaponItem
		{
			if (isLoaded==false)
			{
				parseXml();
			}
			for (var i:int = 0; i < m_vecWeapon.length; i++)
			{
				if (m_vecWeapon[i].m_id == id)
				{
					return m_vecWeapon[i];
				}
			}
			
			return null;
		}
		
		//获得当前佩戴的神兵(未佩戴，返回第一个神兵)
		public function get curWearingWeapon():WeaponItem
		{
			var ret:WeaponItem;
			
			if (GODLYWEAPON_ID1 <= m_curWearGWId && m_curWearGWId <= GODLYWEAPON_ID7)
			{
				ret = getWeaponDataByID(m_curWearGWId);
			}
			else
			{
				ret = getWeaponDataByID(GODLYWEAPON_ID1);
			}
			
			return ret;
		}
		
		//获得某一等级神兵技能属性信息
		public function getGWSkillItem(level:uint):SkillItem
		{
			var ret:SkillItem = null;
			
			if (m_gwSkill)
			{
				ret = m_gwSkill.getSkillItemByLevel(level);
			}
			
			return ret;
		}
		
		public function getCurGWSkillItem():SkillItem
		{
			return getGWSkillItem(m_gwsCurLevel);
		}
		
		public function getNextGWSkillItem():SkillItem
		{
			return getGWSkillItem(m_gwsCurLevel + 1);
		}
		
		//获得培养暴率
		public function getBjper(type:int):uint
		{
			var ret:uint;
			
			switch(type)
			{
				case TRAIN_Greenhun:
					ret = m_gwSkill.m_greenbjper;
					break;
				case TRAIN_Bluehun:
					ret = m_gwSkill.m_bluebjper;
					break;
				case TRAIN_Yuanbao:
					ret = m_gwSkill.m_ybbjper;
					break;
				default:
					ret = 0;
			}
			
			return ret;
		}
		
		//神兵培养（天下号令）是否开启		//开启条件：玩家获得第1个神兵后（第1天2小时冷却获得后开启）
		public function get bOpenGWSkilltrain():Boolean
		{
			return bActGwId(GODLYWEAPON_ID1);
		}
		
		//元宝培养 消耗=50(固定值)
		public function get payMoney():uint
		{
			return 50;
		}
		
		//号令天下，今日元宝培养剩余次数
		public function get leftYBTrainTimes():uint
		{
			var ret:uint = m_gkContext.m_vipPrivilegeMgr.getPrivilegeValue(VipPrivilegeMgr.Vip_GWSTYuanbao);
			
			if (ret > m_ybTrainTimes)
			{
				ret -= m_ybTrainTimes;
			}
			else
			{
				ret = 0;
			}
			
			return ret;
		}
		
		//早上7点，培养次数重置
		public function process7ClockUserCmd():void
		{
			m_leftTrainTimes = m_maxTrainTimes;
			m_ybTrainTimes = 0;
			
			if (iUIGodlyWeapon)
			{
				iUIGodlyWeapon.updateTrainData();
			}
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateGodlyIconFlashing(m_leftTrainTimes > 0);
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_GodlyWeaponTrain, -1, m_leftTrainTimes);
			}
		}
	}

}