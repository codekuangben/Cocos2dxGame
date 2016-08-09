package modulecommon.scene.xingmai 
{
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.xingMaiCmd.stAttrInfo;
	import modulecommon.net.msg.xingMaiCmd.stChangeUserSkillXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMAttrXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMSkillXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stNotifyXMSkillActiveXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stSkillActive;
	import modulecommon.net.msg.xingMaiCmd.stXingLiChangeXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stXingMaiUIInfoXMCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIXingMai;
	/**
	 * ...
	 * @author 
	 * 星脉管理
	 */
	public class XingmaiMgr
	{
		//技能提升武将激活情况
		public static const XM_ACTSTATE_NONE:int = 0;		//无法激活
		public static const XM_ACTSTATE_RECRUIT:int = 1;	//需招募
		public static const XM_ACTSTATE_ACTION:int = 2;		//需激活
		public static const XM_ACTSTATE_REBIRTH:int = 3;	//需转生
		
		//属性类型
		public static const XM_FORCE_IQ:int = 1;	//武力(智力)
		public static const XM_CHIEF:int = 2;		//统率
		public static const XM_SOLDIERLIMIT:int = 3;//兵力
		public static const XM_ATTCK:int = 4;		//攻击力(双攻)
		public static const XM_DEF:int = 5;			//防御力(双防)
		public static const XM_SPEED:int = 6;		//速度
		
		
		private var m_gkContext:GkContext;
		private var m_dicAttrGrow:Dictionary;		//属性成长
		private var m_dicSkill:Dictionary;			//星脉技能
		private var m_openSkillList:Array;			//技能开放等级
		private var m_xingli:uint;					//星力值
		
		public var m_curUsingSkillBaseID:uint;	//当前使用中的技能 baseID
		public var m_vecAttr:Vector.<AttrData>;	//属性信息
		public var m_dicActSkills:Dictionary;	//已拥有技能
		public var m_bShowSkillList:Boolean;	//是否显示技能列表
		
		public function XingmaiMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicAttrGrow = new Dictionary();
			m_dicSkill = new Dictionary();
			m_openSkillList = new Array();
			m_vecAttr = new Vector.<AttrData>();
			m_dicActSkills = new Dictionary();
		}
		
		//读取配置文件数据
		private function loadConfig():void
		{
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Xingmaicfg);
			
			var xmlItem:XML;
			var xmlList:XMLList;
			var id:uint;
			var data:uint;
			
			xmlList = xml.child("attrgrow");
			for each(xmlItem in xmlList)
			{
				id = UtilXML.attributeIntValue(xmlItem, "id");
				data = UtilXML.attributeIntValue(xmlItem, "growvalue");
				m_dicAttrGrow[id] = data;
			}
			
			var openskill:OpenSkill;
			xmlList = xml.child("openskill");
			for each(xmlItem in xmlList)
			{
				openskill = new OpenSkill();
				openskill.parseXml(xmlItem);
				m_openSkillList.push(openskill);
			}
			m_openSkillList.sort(compare);
			
			var itemskill:ItemSkill;
			xmlList = xml.child("skill");
			for each(xmlItem in xmlList)
			{
				itemskill = new ItemSkill();
				itemskill.parseXml(xmlItem);
				m_dicSkill[itemskill.m_id] = itemskill;
			}
		}
		
		private function compare(a:OpenSkill, b:OpenSkill):int
		{
			if (a.m_attrlevel < b.m_attrlevel)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		//上线发送觉醒界面数据
		public function processXingmaiUIinfoXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stXingMaiUIInfoXMCmd = new stXingMaiUIInfoXMCmd();
			rev.deserialize(msg);
			
			loadConfig();
			
			m_xingli = rev.m_xingli;
			m_curUsingSkillBaseID = rev.m_curSkillID;
			
			var i:int;
			var attr:AttrData;
			for (i = 0; i < rev.m_attrList.length; i++)
			{
				attr = new AttrData();
				attr.m_id = rev.m_attrList[i].m_attrno;
				attr.m_level = rev.m_attrList[i].m_level;
				attr.m_growvalue = m_dicAttrGrow[attr.m_id];
				
				m_vecAttr.push(attr);
			}
			
			var skill:stSkillActive;
			for (i = 0; i < rev.m_skillsList.length; i++)
			{
				skill = rev.m_skillsList[i];
				m_dicActSkills[skill.m_skillBaseID] = skill;
			}
		}
		
		//属性等级升级
		public function processLevelUpXMAttrXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stLevelUpXMAttrXMCmd = new stLevelUpXMAttrXMCmd();
			rev.deserialize(msg);
			
			var attr:AttrData = getAttrDataByID(rev.m_attrno);
			if (attr)
			{
				attr.m_level += 1;
				
				if (uixingmai)
				{
					uixingmai.updateAttrLevel(rev.m_attrno);
					uixingmai.updateJiangHun();
				}
				
				if (m_gkContext.m_UIs.hero)
				{
					m_gkContext.m_UIs.hero.updateJianghun();
				}
			}
		}
		
		//星脉技能激活 s->c
		public function processNotifyXMSkillActiveXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stNotifyXMSkillActiveXMCmd = new stNotifyXMSkillActiveXMCmd();
			rev.deserialize(msg);
			
			var count:uint = 0;
			var skill:stSkillActive;
			
			skill = new stSkillActive();
			skill.m_skillBaseID = rev.m_skillid;
			
			if (m_dicActSkills[skill.m_skillBaseID] == undefined)
			{
				m_dicActSkills[skill.m_skillBaseID] = skill;
			}
			
			if (uixingmai)
			{
				uixingmai.openOneNewXMSkill();
			}
			
			for each(skill in m_dicActSkills)
			{
				count++;
			}
			
			if ((1 == count) && uixingmai)
			{
				uixingmai.reSetDefaultUsingSkill();
			}
		}
		
		//更换技能
		public function processChangeUserSkillXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stChangeUserSkillXMCmd = new stChangeUserSkillXMCmd();
			rev.deserialize(msg);
			
			m_curUsingSkillBaseID = rev.m_skillid;
			
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.updateZhanshu();
			}
			
			if (uixingmai)
			{
				uixingmai.updateUsingSkill();
			}
		}
		
		//星脉技能升级
		public function processLevelUpXMSkillXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stLevelUpXMSkillXMCmd = new stLevelUpXMSkillXMCmd();
			rev.deserialize(msg);
			
			var oldWuid:uint;
			var newWuid:uint = rev.m_heroid / 10;
			var item:stSkillActive = m_dicActSkills[rev.m_skillid];
			if (item)
			{
				for (var i:int = 0; i < item.m_herosVec.length; i++)
				{
					oldWuid = item.m_herosVec[i] / 10;
					if (oldWuid == newWuid)
					{
						break;
					}
					if (0 == item.m_herosVec[i])
					{
						break;
					}
				}
				item.m_herosVec[i] = rev.m_heroid;
			}
			
			if (uixingmai)
			{
				uixingmai.successSkillLevelUp(rev.m_skillid);
				uixingmai.updateActWuState(rev.m_heroid);
			}
			
			//更新人物界面主角技能
			if ((m_curUsingSkillBaseID == rev.m_skillid) && m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.updateZhanshu();
			}
		}
		
		//星力变化
		public function processXingmaiChangeXMCmd(msg:ByteArray, param:int):void
		{
			var rev:stXingLiChangeXMCmd = new stXingLiChangeXMCmd();
			rev.deserialize(msg);
			
			m_xingli = rev.m_xingli;
			
			if (uixingmai)
			{
				uixingmai.updateXingLi(xingli);
			}
		}
		
		public function get xingli():uint
		{
			return m_xingli;
		}
		
		public function getItemSkill(id:uint):ItemSkill
		{
			return m_dicSkill[id];
		}
		
		//获得星脉技能已激活信息
		public function get actSkillsList():Array
		{
			var list:Array = new Array();
			var item:stSkillActive;
			
			for each(item in m_dicActSkills)
			{
				list.push(item.m_skillBaseID);
			}
			list.sort(compareId);
			
			return list;
		}
		
		private function compareId(a:uint, b:uint):int
		{
			if (a < b)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function getXMSkillLevelID(baseid:uint):uint
		{
			var item:stSkillActive;
			for each(item in m_dicActSkills)
			{
				if (item.m_skillBaseID == baseid)
				{
					return item.skillLevelID;
				}
			}
			
			return baseid;
		}
		
		//获得属性中最低等级
		public function get lowestAttrLevel():uint
		{
			var ret:uint = uint.MAX_VALUE;
			
			for (var i:int = 0; i < m_vecAttr.length; i++)
			{
				if (ret >= m_vecAttr[i].m_level)
				{
					ret = m_vecAttr[i].m_level;
				}
			}
			
			return ret;
		}
		
		//获得即将开启的技能BaseID
		public function get willActXMSkillID():uint
		{
			var i:int;
			var lowLevel:uint = lowestAttrLevel;
			var skill:OpenSkill;
			var len:int = m_openSkillList.length;
			
			for (i = 0; i < len; i++)
			{
				skill = m_openSkillList[i] as OpenSkill;
				if (lowLevel < skill.m_attrlevel)
				{
					return (m_openSkillList[i] as OpenSkill).m_skillid;
				}
			}
			
			return skill.m_skillid;
		}
		
		//上一次已开启的技能BaseID(即最后一次)
		public function get lastActXMSkillID():uint
		{
			var i:int;
			var skill:OpenSkill;
			var lowLevel:uint = lowestAttrLevel;
			
			for (i = (m_openSkillList.length - 1); i >= 0; i--)
			{
				skill = m_openSkillList[i] as OpenSkill;
				if (lowLevel >= skill.m_attrlevel)
				{
					return skill.m_skillid;
				}
			}
			
			return 0;
		}
		
		//获得当前使用的技能levelID
		public function get curUsingXMSkillID():uint
		{
			return getXMSkillLevelID(m_curUsingSkillBaseID);
		}
		
		//获得激活武将id  wuid:武将id(3位数)  return:heroid  0(未激活)
		public function getHasActHeroId(wuid:uint, skillid:uint):uint
		{
			var item:stSkillActive = m_dicActSkills[skillid] as stSkillActive;
			var i:uint;
			var id:uint;
			
			if (item)
			{
				for (i = 0; i < item.m_herosVec.length; i++)
				{
					id = item.m_herosVec[i] / 10;
					if (wuid == id)
					{
						return item.m_herosVec[i];
					}
				}
			}
			
			return 0;
		}
		
		//获得属性信息
		public function get vecAttrDatas():Vector.<AttrData>
		{
			return m_vecAttr;
		}
		
		public function getAttrDataByID(id:uint):AttrData
		{
			for each(var attr:AttrData in m_vecAttr)
			{
				if (id == attr.m_id)
				{
					return attr;
				}
			}
			
			return null;
		}
		
		private function get uixingmai():IUIXingMai
		{
			return m_gkContext.m_UIMgr.getForm(UIFormID.UIXingMai) as IUIXingMai;
		}
		
		//获得某一等级的属性信息   id:编号 level = -1(表示当前等级的)
		public function getNextLevelAttr(id:uint, level:int = -1):AttrData
		{
			var ret:AttrData;
			var attr:AttrData = getAttrDataByID(id);
			
			if (null == attr)
			{
				return null;
			}
			
			ret = new AttrData();
			ret.m_id = attr.m_id;
			ret.m_growvalue = attr.m_growvalue;
			if ( -1 == level)
			{
				ret.m_level = attr.m_level + 1;
			}
			else
			{
				ret.m_level = level + 1;
			}
			
			return ret;
		}
		
		//所需将魂=目标等级*50 + int(目标等级/10)*500
		public static function getPayValue(level:uint):uint
		{
			return (level * 50 + Math.floor(level / 10) * 500);
		}
		
		//获得最低等级属性升级所需将魂值
		public function get jianghunForNextAttr():uint
		{
			return getPayValue(lowestAttrLevel + 1);
		}
		
		public function getOpenSkill(skillid:uint):OpenSkill
		{
			var ret:OpenSkill;
			var item:OpenSkill;
			
			for each(item in m_openSkillList)
			{
				if (item.m_skillid == skillid)
				{
					ret = item;
					break;
				}
			}
			
			return ret;
		}
	}

}