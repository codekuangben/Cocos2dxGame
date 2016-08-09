package modulecommon.scene.zhanliupgrade 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.scene.equipsys.EquipSysMgr;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.SmallAttrData;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TEnchUpperItem;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.wu.JinnangItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ZhanliUpgradeMgr 
	{
		public static const ZHANLIUP_HECHENG:int = 0;
		public static const ZHANLIUP_BAOSHI:int = 1;
		public static const ZHANLIUP_JINNANG:int = 2;
		public static const ZHANLIUP_XINGMAI:int = 3;
		public static const ZHANLIUP_QIANGHUA:int = 4;
		public static const ZHANLIUP_XILIAN:int = 5;
		public static const ZHANLIUP_WUJIANG:int = 6;
		public static const ZHANLIUP_JINNANGRESTRAIN:int = 7;
		public static const ZHANLIUP_MAX:int = 8;
		
		public static const BARCOLOR_WHITE:int = 0;
		public static const BARCOLOR_GREEN:int = 1;
		public static const BARCOLOR_BLUE:int = 2;
		public static const BARCOLOR_PURPLE:int = 3;
		public static const BARCOLOR_GOLD:int = 4;		
		
		private var m_gkContext:GkContext;
		private var m_dicitem:Dictionary;
		private var m_array:Array;
		private var m_hasRequest:Boolean;
		public function ZhanliUpgradeMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_dicitem = new Dictionary();
			m_array = ["hecheng", "baoshi", "jinnang", "xingmai"];
		}
		
		public function loadConfig():void
		{
			if (m_hasRequest == true)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Zhanlitishen);
			parseXml(xml);
			
			m_hasRequest = true;
		}
		
		public function parseXml(xml:XML):void
		{
			var i:int;
			var itemXMLList:XMLList;
			var upgradeitem:UpgradeItem;
			for (i = 0; i < m_array.length; i++)
			{
				itemXMLList = xml.child(m_array[i]);
				for each(var itemXML:XML in itemXMLList)
				{
					upgradeitem = new UpgradeItem();
					upgradeitem.parseXml(itemXML);
				}
				
				m_dicitem[i] = upgradeitem;
			}
			
		}
		
		public function hasRequest():Boolean
		{
			return m_hasRequest;
		}
		
		public function LimitAndCurValue(funcID:uint):upgradeData
		{
			var data:upgradeData = new upgradeData();
			
			var heroLevel:uint = m_gkContext.playerMain.level;
			var tempdata:upgradeData;
			switch(funcID)
			{
				case ZHANLIUP_HECHENG:
					data.limit = getValue(ZHANLIUP_HECHENG, heroLevel);
					data.curvalue = getEquipsHechengInfo(heroLevel);
					data.functype = ZHANLIUP_HECHENG;
					break;
				case ZHANLIUP_BAOSHI:
					tempdata = getEquipsBaoshiInfo(heroLevel);
					data.limit = tempdata.limit;
					data.curvalue = tempdata.curvalue;
					data.functype = ZHANLIUP_BAOSHI;
					break;
				case ZHANLIUP_JINNANG:
					data.limit = getValue(ZHANLIUP_JINNANG, heroLevel);
					data.curvalue = getAlljinnangLevelsSum();
					data.functype = ZHANLIUP_JINNANG;
					break;
				case ZHANLIUP_XINGMAI:
					data.limit = getValue(ZHANLIUP_XINGMAI, heroLevel);
					data.curvalue = 0;// m_gkContext.m_xingmaiMgr.numJiangXinIsActive;
					data.functype = ZHANLIUP_XINGMAI;
					break;
				case ZHANLIUP_QIANGHUA:
					tempdata = getEquipsQianghuaInfo();
					data.curvalue = tempdata.curvalue;
					data.limit = tempdata.limit;
					data.functype = ZHANLIUP_QIANGHUA;
					break;
				case ZHANLIUP_XILIAN:
					tempdata = getEquipsXilianInfo();
					data.curvalue = tempdata.curvalue;
					data.limit = tempdata.limit;
					data.functype = ZHANLIUP_XILIAN;
					break;
				case ZHANLIUP_WUJIANG:
					tempdata = getFightWuStateInfo();
					data.curvalue = tempdata.curvalue;
					data.limit = tempdata.limit;
					data.functype = ZHANLIUP_WUJIANG;
					break;
			}
			
			return data;
		}
		
		public function ZhanliCurValue(funcID:uint):uint
		{
			return 0;
		}
		
		public function getBarColorType(funcID:uint):uint
		{
			var ret:uint;
			var v:Number = 0;
			if (v < 0.3)
			{
				ret = BARCOLOR_WHITE;
			}
			else if (v < 0.6)
			{
				ret = BARCOLOR_GREEN;
			}
			else if (v < 0.8)
			{
				ret = BARCOLOR_BLUE;
			}
			else if (v < 0.99)
			{
				ret = BARCOLOR_PURPLE;
			}
			else
			{
				ret = BARCOLOR_GOLD;
			}
			
			return ret;
		}
		
		//获得该等级所在等级段的标准值(配置文件中所配)
		public function getValue(funcID:uint, level:uint):uint
		{
			var levellist:Vector.<UpgradeLevel> = (m_dicitem[funcID] as UpgradeItem).levelList;
			var ret:uint;
			var i:int;
			for (i = 0; i < levellist.length; i++)
			{
				if (level < levellist[i].m_levelMax)
				{
					ret = levellist[i].m_value;
					break;
				}
			}
			
			return ret;
		}
		
		//获得输入等级在等级段中的位置(依次序为0、1、2...) level为玩家等级或装备等级
		public function getIndexInLevelSegment(funcID:uint, level:uint):uint
		{
			var index:uint = 0;
			var levellist:Vector.<UpgradeLevel> = (m_dicitem[funcID] as UpgradeItem).levelList;
			for (var i:int = 0; i < levellist.length; i++)
			{
				if (level < levellist[i].m_levelMax)
				{
					index = i;
				}
			}
			
			return index;
		}
		
		//玩家当前已有锦囊等级数总和
		public function getAlljinnangLevelsSum():uint
		{
			var ret:uint = 0;
			var list:Array = m_gkContext.m_wuMgr.getJinnangList();
			for each(var jinnang:JinnangItem in list)
			{
				ret += (jinnang.idLevel % 100);
			}
			
			return ret;
		}
		
		public function getFightWuStateInfo():upgradeData
		{
			var activewunums:uint = 0;
			var allrelationwunums:uint = 0;
			var list:Array = m_gkContext.m_wuMgr.getFightWuList(true, false);
			var activelist:Vector.<ActiveHero>;
			for each(var wu:WuProperty in list)
			{
				activelist = (wu as WuHeroProperty).m_vecActiveHeros;
				allrelationwunums += activelist.length;
				
				for (var i:int = 0; i < activelist.length; i++)
				{
					if (activelist[i].bOwned)
					{
						activewunums += 1;
					}
				}
			}
			
			var data:upgradeData = new upgradeData();
			data.curvalue = activewunums;
			data.limit = allrelationwunums;
			return data;
		}
		
		//获得出战武将身上的装备
		public function getEquipsOfFightWu():Vector.<ZObject>
		{
			var j:int;
			var obj:ZObject;
			var wupackage:Package;
			var equipsList:Vector.<ZObject> = new Vector.<ZObject>();
			var list:Array = m_gkContext.m_wuMgr.getFightWuList(true, true);
			for each(var wu:WuProperty in list)
			{
				wupackage = m_gkContext.m_objMgr.getEquipPakage(wu.m_uHeroID);
				if (wupackage)
				{
					for (j = 0; j < ZObjectDef.EQUIP_MAX; j++)
					{
						obj = wupackage.getEquipInEquipPakageByPos(j);
						if (obj)
						{
							equipsList.push(obj);
						}
					}
				}
			}
			
			return equipsList;
		}
		
		//装备强化数据信息 return 当前值、标准值
		public function getEquipsQianghuaInfo():upgradeData
		{
			var vecEquips:Vector.<ZObject> = getEquipsOfFightWu();
			var qianghuaCurValue:uint = 0;
			var qianghuaLimit:uint = 0;
			var i:int;
			var enchUpperItem:TEnchUpperItem;
			for (i = 0; i < vecEquips.length; i++)
			{
				enchUpperItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_EQUIPQHUPPER, vecEquips[i].enchUpperID) as TEnchUpperItem;
				qianghuaLimit += enchUpperItem.m_upperLimit;
				qianghuaCurValue += vecEquips[i].m_object.m_equipData.enhancelevel;
			}
			
			var data:upgradeData = new upgradeData();
			data.curvalue = qianghuaCurValue;
			data.limit = qianghuaLimit;
			return data;
		}
		
		//装备合成数据信息 return:当前值
		public function getEquipsHechengInfo(level:uint):uint
		{
			var ret:int = 0;
			var vecEquips:Vector.<ZObject> = getEquipsOfFightWu();
			var list:Array = m_gkContext.m_wuMgr.getFightWuList(true, true);
			var i:int;
			var index:uint;
			var curIndex:uint = getValue(ZHANLIUP_HECHENG, level);
			for (i = 0; i < vecEquips.length; i++)
			{
				ret += vecEquips[i].iconColor;
				index = getValue(ZHANLIUP_HECHENG, vecEquips[i].needLevel);
				if (index < curIndex)
				{
					ret -= (curIndex - index);
				}
			}
			ret -= (list.length * ZObjectDef.EQUIP_MAX - vecEquips.length);
			
			return (ret > 0? ret: 0);
		}
		
		//装备镶嵌宝石数据信息 return:当前值、标准值
		public function getEquipsBaoshiInfo(level:uint):upgradeData
		{
			var countSlot:uint = 0;
			var curValue:uint = 0;
			var vecEquips:Vector.<ZObject> = getEquipsOfFightWu();
			var base:TObjectBaseItem;
			var gemList:Vector.<uint>;
			for (var i:int = 0; i < vecEquips.length; i++)
			{
				gemList = vecEquips[i].m_object.m_equipData.gemslots;
				for (var j:int = 0; j < gemList.length; j++)
				{
					if (gemList[j])
					{
						base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, gemList[j]) as TObjectBaseItem;
						if (base)
						{
							curValue += base.m_iNeedLevel;
						}
					}
				}
				
				countSlot += vecEquips[i].numSlot;
			}
			
			var data:upgradeData = new upgradeData();
			data.limit = countSlot * getValue(ZHANLIUP_BAOSHI, level);
			data.curvalue = curValue;
			return data;
		}
		
		//装备洗炼数据信息 return:当前值、标准值
		public function getEquipsXilianInfo():upgradeData
		{
			var countSmallAttr:uint = 0;
			var curValue:uint = 0;
			var vecEquips:Vector.<ZObject> = getEquipsOfFightWu();
			var i:int;
			var j:int;
			var smalAttrs:Vector.<SmallAttrData>
			for (i = 0; i < vecEquips.length; i++)
			{
				smalAttrs = vecEquips[i].m_object.m_equipData.smallAttrs;
				if (smalAttrs)
				{
					for (j = 0; j < smalAttrs.length; j++)
					{
						curValue += 0;//以后需再修改
					}
				}
				
				countSmallAttr += vecEquips[i].numSmallAttr;
			}
			
			var data:upgradeData = new upgradeData();
			data.limit = countSmallAttr * 10; //小属性最高等级为 10级
			data.curvalue = curValue;
			return data;
		}
		
		//获得 可提升战力的各项列表（已排序,当前值<标准值）
		public function upgradeItemList():Vector.<upgradeData>
		{
			var i:int;
			var item:upgradeData;
			var upgradeList:Vector.<upgradeData> = new Vector.<upgradeData>();
			
			for (i = 0; i < ZHANLIUP_MAX; i++)
			{
				item = LimitAndCurValue(i);
				if (IsOpenFeature(i))
				{
					upgradeList.push(item);
				}
			}
			
			var data:Object = m_gkContext.m_contentBuffer.getContent("jinnangRestraint_info", true);
			if (data)
			{
				if (data["reason"] == 2)
				{
					item = new upgradeData();
					item.functype = ZHANLIUP_JINNANGRESTRAIN;
					upgradeList.unshift(item);
				}
			}
			
			return upgradeList;
		}
		
		public function getUpgradeFuncName(type:int):String
		{
			var str:String;
			switch(type)
			{
				case ZHANLIUP_HECHENG: str = "hecheng"; break;
				case ZHANLIUP_BAOSHI: str = "baoshi"; break;
				case ZHANLIUP_JINNANG: str = "jinnang"; break;
				case ZHANLIUP_XINGMAI: str = "xingmai"; break;
				case ZHANLIUP_QIANGHUA: str = "qianghua"; break;
				case ZHANLIUP_XILIAN: str = "xilian"; break;
				case ZHANLIUP_WUJIANG: str = "wujiang"; break;
				case ZHANLIUP_JINNANGRESTRAIN: str = "jinnang"; break;
			}
			
			return str;
		}
		
		//获得出战武将的所有未激活关系武将(即未招募武将)
		public function getOutFightWuActiveList():Array
		{
			var list:Array = m_gkContext.m_wuMgr.getFightWuList(true, false);
			if (null == list)
			{
				return null;
			}
			
			var i:int;
			var j:int;
			var heroid:uint;
			var retList:Array = new Array();
			var activelist:Vector.<ActiveHero>;
			for each(var wu:WuProperty in list)
			{
				activelist = (wu as WuHeroProperty).m_vecActiveHeros;
				for (i = 0; i < activelist.length; i++)
				{
					if (false == activelist[i].bOwned)
					{
						//鬼武将需要鬼关系武将才能激活
						heroid = activelist[i].tableID * 10 + (wu as WuHeroProperty).add;
						retList.push(heroid);
					}
				}
			}
			
			return retList;
		}
		
		public function getRelationWuHaveSomejinnang():Array
		{
			var retlist:Array = new Array();
			var wulist:Array = new Array();
			var list:Vector.<uint> = m_gkContext.m_zhenfaMgr.getJinnangList();
			var i:int;
			var j:int;
			var uID:uint;
			var wu:WuHeroProperty;
			for (i = 0; i < 1; i++)
			{
				wulist = m_gkContext.m_wuMgr.getWuListOfHaveSameJinnang(list[i]);
				if (wulist)
				{
					for (j = 0; j < wulist.length; j++)
					{
						uID = wulist[j] / 10;//DataTable.TABLE_WUPROPERTY 该表中id值个位数表示武将颜色
						wu = m_gkContext.m_wuMgr.getLowestWuByTableID(uID);
						if (null == wu)
						{
							retlist.push(uID * 10);
						}
					}
				}
			}
			
			return retlist;
		}
		
		public static function getEquipSysPageID(type:int):uint
		{
			var ret:uint;
			switch(type)
			{
				case ZHANLIUP_HECHENG:
					ret = EquipSysMgr.eEquipHeCheng;
					break;
				case ZHANLIUP_BAOSHI:
					ret = EquipSysMgr.eEquipXiangQian;
					break;
				case ZHANLIUP_QIANGHUA:
					ret = EquipSysMgr.eEquipStren;
					break;
				case ZHANLIUP_XILIAN:
					ret = EquipSysMgr.eEquipXiLian;
					break;
			}
			
			return ret;
		}
		
		private function IsOpenFeature(type:int):Boolean
		{
			var func:int;
			switch(type)
			{
				case ZHANLIUP_XILIAN:
				case ZHANLIUP_BAOSHI:
				case ZHANLIUP_HECHENG:
				case ZHANLIUP_QIANGHUA:
					func = SysNewFeatures.NFT_DAZAO;
					break;
				case ZHANLIUP_JINNANG:
					func = SysNewFeatures.NFT_JINNANG;
					break;
				case ZHANLIUP_XINGMAI:
					func = SysNewFeatures.NFT_XINGMAI;
					break;
				case ZHANLIUP_WUJIANG:
					var wulist:Array = m_gkContext.m_wuMgr.getFightWuList(true, false);
					if (wulist.length)
					{
						return true;
					}
					else
					{
						return false;
					}
				case ZHANLIUP_JINNANGRESTRAIN:
					return false;
			}
			
			return m_gkContext.m_sysnewfeatures.isSet(func);
		}
		
	}

}