package modulecommon.scene.vip 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * vip特权
	 */
	public class VipPrivilegeMgr 
	{
		public static const Vip_IngotBefall:uint = 1;	//招财神
		public static const Vip_Barrier:uint = 2;		//精英boss
		public static const Vip_DazuoTime:uint = 3;		//修炼最高累积时间
		public static const Vip_DazuoBuyExp:uint = 4;	//购买他人修炼经验
		public static const Vip_BuyLingpai:uint = 5;	//购买令牌
		public static const Vip_OpenBackpack:uint = 6;	//包裹调整
		public static const Vip_Jiuguan:uint = 7;		//酒馆下注
		public static const Vip_CorpsTask:uint = 8;		//免费重点军团任务
		public static const Vip_Saodang:uint = 9;		//扫荡立即完成
		public static const Vip_EquipSys:uint = 10;		//装备强化免冷却
		public static const Vip_Cangbaoku:uint = 11;	//藏宝窟免冷却
		public static const Vip_Arena:uint = 12;		//竞技场免冷却
		public static const Vip_AutoReg:uint = 13;		//自动签到
		public static const Vip_DailyActivities:uint = 14;	//每日活跃增加
		public static const Vip_Lingpai:uint = 15;		//每日免费令牌
		public static const Vip_XuanshangRenwu:uint = 16;	//悬赏任务 星级
		public static const Vip_GWSTYuanbao:uint = 17;	//神兵元宝培养
		
		private var m_gkContext:GkContext;
		private var m_hasRequest:Boolean;
		private var m_dicVipItem:Dictionary;	//vip特权项
		private var m_vipLevelList:Array;		//vip不同等级段的特权项
		
		public var m_dicPrivilegeValue:Dictionary;	//不同vip等级特权数值
		
		public function VipPrivilegeMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_dicVipItem = new Dictionary();
			m_vipLevelList = new Array();
			m_dicPrivilegeValue = new Dictionary();
		}
		
		public function loadConfig():void
		{
			if (m_hasRequest == true)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Vip);
			parseXml(xml);
		}
		
		private function parseXml(xml:XML):void
		{
			var xmllist:XMLList;
			var itemXml:XML;
			
			xmllist = xml.child("tequan");
			var itemprivilege:ItemPrivilege;
			for each(itemXml in xmllist)
			{
				itemprivilege = new ItemPrivilege();
				itemprivilege.parseXml(itemXml);
				m_dicVipItem[itemprivilege.id] = itemprivilege;
			}
			
			xmllist = null;
			itemXml = null;
			xmllist = xml.child("vip");
			var itemviplevel:ItemVipLevel;
			for each(itemXml in xmllist)
			{
				itemviplevel = new ItemVipLevel();
				itemviplevel.parseXml(itemXml);
				m_vipLevelList.push(itemviplevel);
			}
			
			m_hasRequest = true;
		}
		
		//从common.xml配置文件中，读取相关数据:不同Vip等级段，各功能特权数据
		public function loadConfigCommonXmlData():void
		{
			var xml:XML = m_gkContext.m_commonXML.getItem(2);
			var xmllist:XMLList;
			var itemXml:XML;
			
			xmllist = xml.child("vip");
			var privilegevalue:PrivilegeValue;
			var viplevel:int;
			var valuelist:Array;
			var tequanlist:XMLList;
			
			for each(itemXml in xmllist)
			{
				viplevel = parseInt(itemXml.@level);
				tequanlist = itemXml.child("tequan");
				valuelist = new Array();
				for each(var item:XML in tequanlist)
				{
					privilegevalue = new PrivilegeValue();
					privilegevalue.parseXml(item);
					privilegevalue.viplevel = viplevel;
					
					valuelist.push(privilegevalue);
				}
				
				m_dicPrivilegeValue[viplevel] = valuelist;
			}
			
			m_gkContext.m_commonXML.deleteItem(2);
		}
		
		//获得Vip特权项 id:编号 (有image、desc信息)
		public function getItemPrivilege(id:uint):ItemPrivilege
		{
			return m_dicVipItem[id];
		}
		
		//获得所有不同vip等级段的特权项信息
		public function getVipDataList():Array
		{
			return m_vipLevelList;
		}
		
		//显示Vip特权界面
		public function showVipPrivilegeForm():void
		{
			loadConfig();
			
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UIVipPrivilege);
		}
		
		//获得当前Vip等级段积分值
		public function get scoreCurVipLevel():uint
		{
			var counts:uint = m_vipLevelList.length;
			var curlevel:uint = m_gkContext.m_beingProp.vipLevel;
			
			for each(var item:ItemVipLevel in m_vipLevelList)
			{
				if (item.viplevel == curlevel)
				{
					return item.vipscor;
				}
			}
			
			return 0;
		}
		
		//获得下一Vip等级段积分值
		public function get scoreNextVipLevel():uint
		{
			var counts:uint = m_vipLevelList.length;
			var nextlevel:uint = m_gkContext.m_beingProp.vipLevel + 1;
			if (nextlevel > counts)
			{
				return 0;
			}
			
			for each(var item:ItemVipLevel in m_vipLevelList)
			{
				if (item.viplevel == nextlevel)
				{
					return item.vipscor;
				}
			}
			
			return 0;
		}
		
		//获得当前Vip等级段对应特权(部分功能每日任务次数上限变化)
		public function getPrivilegeValue(id:uint):uint
		{
			return getPrivilegeValueInLevel(m_gkContext.m_beingProp.vipLevel, id);
		}
		
		//获得某一特权更高Vip等级的数据信息 id:特权ID
		public function getNextVipLevelPrivilegeValue(id:uint):PrivilegeValue
		{
			var ret:PrivilegeValue = null;
			var viplevel:uint = m_gkContext.m_beingProp.vipLevel;
			var i:int;
			var item:PrivilegeValue;
			
			for (i = (viplevel + 1); i <= BeingProp.VIP_Level_Max; i++)
			{
				item = getNextPValueInVL(i, id);
				if (item)
				{
					return item;
				}
			}
			
			return getNextPValueInVL(viplevel, id);
		}
		
		public function getNextPValueInVL(viplevel:int, id:uint):PrivilegeValue
		{
			var valuelist:Array;
			var i:int;
			
			for (i = viplevel; i <= BeingProp.VIP_Level_Max; i++)
			{
				valuelist = m_dicPrivilegeValue[i];
				for each(var item:PrivilegeValue in valuelist)
				{
					if (item.id == id)
					{
						return item;
					}
				}
			}
			
			return null;
		}
		
		public function getPrePValueInVL(viplevel:int, id:uint):PrivilegeValue
		{
			var valuelist:Array;
			var i:int;
			
			for (i = viplevel; i >= 0; i--)
			{
				valuelist = m_dicPrivilegeValue[i];
				for each(var item:PrivilegeValue in valuelist)
				{
					if (item.id == id)
					{
						return item;
					}
				}
			}
			
			return null;
		}
		
		//获得特权在某一vip等级的数值
		public function getPrivilegeValueInLevel(viplevel:int, id:uint):uint
		{
			var ret:uint = 0;
			var privilegevalue:PrivilegeValue = getPrePValueInVL(viplevel, id);
			
			if (privilegevalue)
			{
				ret = privilegevalue.value;
			}
			
			return ret;
		}
	}

}