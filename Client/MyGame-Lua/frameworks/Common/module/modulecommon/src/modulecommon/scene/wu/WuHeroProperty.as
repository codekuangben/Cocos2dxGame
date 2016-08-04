package modulecommon.scene.wu
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.net.msg.sceneHeroCmd.t_HeroData;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	
	public dynamic class WuHeroProperty extends WuProperty
	{
		public static const MaxZhuanshengLevel:int = 3;
		
		public static const Add_Zero:int = 0;
		public static const Add_Gui:int = 1;	//鬼
		public static const Add_Xian:int = 2;	//仙
		public static const Add_Shen:int = 3;	//神
		
		public static const WUID_MaTeng:uint = 119;	//马腾
		
		//为关系武将定义状态
		public static const ActiveWuState_zaiye:uint = 0;	//在野
		public static const ActiveWuState_xiaye:uint = 1;	//下野
		public static const ActiveWuState_needZhuansheng:uint = 2;	//需转生
		public static const ActiveWuState_needZhaomu:uint = 3;	//需招募
		
		
		public var m_num:uint;	//武将数量
		public var m_uColor:uint; //武将颜色
		public var m_bActive:Boolean;	//true - 此武将已被其关系武将激活
		public var m_vecActiveHeros:Vector.<ActiveHero>; //激活武将	
		public var m_npcBase:TNpcBattleItem;
		public var m_wuPropertyBase:TWuPropertyItem;
		
		
		public function WuHeroProperty(gk:GkContext):void
		{
			super(gk);
		}
		
		public function setByHeroData(data:t_HeroData):void
		{			
			m_uHeroID = data.id;
			m_uJob = data.job;
			m_num = data.num;
			m_uFight = data.fight;			
			m_uSoldierType = data.soldiertype;
			m_uHPLimit = data.hp;
			m_trainLevel = data.trainlevel;
			m_trainPower = data.trainpower;
		}
		
		public function set npcBase(base:TNpcBattleItem):void
		{
			m_npcBase = base;
			m_name = base.m_name;			
			m_wuPropertyBase = this.m_gkContext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, m_npcBase.m_uID * 10 + base.m_uColor) as TWuPropertyItem;
			color = base.m_uColor;
		}
		
		public function get zhenweiName():String
		{
			return toZhenweiName(m_npcBase.m_iZhenwei);			
		}
		
		override public function get zhanshuID():uint
		{
			return m_wuPropertyBase.m_uZhanshu;
		}
		
		//返回天赋列表
		public function getTianfu():Vector.<uint>
		{
			return m_wuPropertyBase.tianfu;
		}
		
		override public function get zhanshuName():String
		{
			return m_gkContext.m_skillMgr.getName(zhanshuID);
		}
		
		public function set color(value:uint):void
		{
			m_uColor = value;
			onChangeColor();
		}
		public function get color():uint
		{
			return m_uColor;
		}
		
		public function get jinnang1Name():String
		{
			if (m_wuPropertyBase.m_uJinnang1 == 0)			
			{
				return null;
			}
			return m_gkContext.m_skillMgr.getName(m_wuPropertyBase.m_uJinnang1);
		}
		
		override public function get colorValue():uint
		{
			return NpcBattleBaseMgr.colorValue(m_uColor);
		}
		
		public static function s_colorValue(color:uint):uint
		{
			return NpcBattleBaseMgr.colorValue(color);
		}
		
		public function onChangeColor():void
		{
			var list:Vector.<uint> = m_wuPropertyBase.getVecAtiveWu();			
			if (m_vecActiveHeros == null)
			{
				m_vecActiveHeros = new Vector.<ActiveHero>();    
			}
			var i:int;
			var ah:ActiveHero;
			var count:int = list.length;
			var id:uint;
			for (i = 0; i < count; i++)
			{
				id = composeWuID(list[i], this.add);
				if (i < m_vecActiveHeros.length )
				{
					m_vecActiveHeros[i].id = id;
				}
				else
				{
					ah = new ActiveHero();
					ah.id = id;
					m_vecActiveHeros.push(ah);
				}
			}
		}
		//几激活
		public function get numWuActivated():uint
		{
			if (this.m_vecActiveHeros == null)
			{
				return 0;
			}
			var i:uint;
			var num:uint = 0;
			for (i = 0; i < m_vecActiveHeros.length; i++)
			{
				if (m_vecActiveHeros[i].bOwned)
				{
					num++;
				}
			}
			return num;
		}
		//几激活
		public function get numWuRecruited():uint
		{
			if (this.m_vecActiveHeros == null)
			{
				return 0;
			}
			var i:uint;
			var num:uint = 0;
			
			for (i = 0; i < m_vecActiveHeros.length; i++)
			{
				if (this.m_gkContext.m_wuMgr.getWuByHeroID(m_vecActiveHeros[i].id))
				{
					num++;
				}
			}
			return num;
		}
		public function canZhuansheng():Boolean
		{
			if (isMaxZhuanshengLevel)
			{
				return false;
			}
			var i:uint;			
			for (i = 0; i < m_vecActiveHeros.length; i++)
			{
				if (null == m_gkContext.m_wuMgr.getWuByHeroID(m_vecActiveHeros[i].id))
				{
					break;
				}				
			}
			if (i == m_vecActiveHeros.length)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//判断此武将是否已被激活：true - 已被激活
		public function get isActive():Boolean
		{
			return m_bActive;
		}
		
		//将tableID与add(加数)合成武将ID
		public static function composeWuID(tableID:uint, add:int):uint
		{
			return tableID * 10 + add;
		}
		
		//由合成ID得到tableID
		public static function tableIDOfWuID(wuID:uint):uint
		{
			return wuID/10;
		}
		
		//由合成ID得到加数
		public static function addOfWuID(wuID:uint):uint
		{
			return wuID%10;
		}
		
		public static function toZhenweiName(iZhenwei:int):String
		{
			var ret:String;
			switch (iZhenwei)
			{
				case 1: 
					ret = "前军";
					break;
				case 2: 
					ret = "中军";
					break;
				case 3: 
					ret = "后军";
					break;
			}
			return ret;
		}
	
	
		public function get tableID():uint
		{
			return m_npcBase.m_uID;
		}
		public function get add():int
		{
			return m_uHeroID % 10;
		}
		
		public static function s_wuPrefix(add:int):String
		{
			var prefixName:String;
			switch(add)
			{
				case 0:prefixName = ""; break;
				case 1:prefixName = "鬼"; break;
				case 2:prefixName = "仙"; break;
				case 3:prefixName = "神"; break;
			}
			return prefixName;
		}
				
		//return true - 已达到最高转生等级
		public function get isMaxZhuanshengLevel():Boolean
		{
			return this.add >= MaxZhuanshengLevel;
		}
		public static function s_fullName(add:int, name:String):String
		{
			if (add == 0)
			{
				return name;
			}
			else
			{
				return s_wuPrefix(add) + " • " + name;
			}
		}
		override public function get fullName():String
		{
			return s_fullName(this.add, m_name);						
		}
		
		override public function get halfingPathName():String
		{
			return NpcBattleBaseMgr.composehalfingPathName(m_npcBase.m_halfing);
		}
		
		//获得武将方头像路径名称
		public function get squareHeadPathName():String
		{
			return NpcBattleBaseMgr.composeSquareHeadResName(m_npcBase.m_squareHeadName);
		}
		
		public function computeActiveWuState(activeWuTableID:uint):uint
		{
			var ret:uint;
			var wuID:uint = composeWuID(activeWuTableID, add);
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(wuID) as WuHeroProperty;
			if (wu)
			{
				if (wu.xiaye)
				{
					ret = ActiveWuState_xiaye;
				}
				else
				{
					ret = ActiveWuState_zaiye
				}
			}
			else
			{
				wu = m_gkContext.m_wuMgr.getLowestWuByTableID(activeWuTableID) as WuHeroProperty;
				if (wu)
				{
					if (wu.add < add)
					{
						ret = ActiveWuState_needZhuansheng;
					}
					else
					{
						ret = ActiveWuState_needZhaomu;
					}
				}
				else
				{
					ret = ActiveWuState_needZhaomu;
				}
			}
			return ret;
			
		}
	}

}