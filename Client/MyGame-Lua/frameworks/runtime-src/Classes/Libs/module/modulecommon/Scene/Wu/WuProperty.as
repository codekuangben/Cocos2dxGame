package modulecommon.scene.wu
{
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.stObjLocation;
	//import modulecommon.scene.prop.job.Soldier;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TWJZhanliItem;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuProperty
	{
		private static var m_dicPropertyNameToName:Dictionary;
		public static const MAINHERO_ID:uint = uint.MAX_VALUE; //主角的heroid, 用以区分其它武将的heroid
		
		public static const PROPTYPE_FORCE:uint = 0; //武力
		public static const PROPTYPE_IQ:uint = 1; //智力
		public static const PROPTYPE_CHIEF:uint = 2; //统帅
		public static const PROPTYPE_HPLIMIT:uint = 3; //带兵上限(生命上限)
		public static const PROPTYPE_LEVEL:uint = 4; //等级
		public static const PROPTYPE_EXP:uint = 5; //经验
		public static const PROPTYPE_NEXTEXP:uint = 6; //下一级经验上限
		public static const PROPTYPE_PHYDAM:uint = 7; //物理攻击
		public static const PROPTYPE_PHYDEF:uint = 8; //物理防御
		public static const PROPTYPE_STRATEGYDAM:uint = 9; //策略攻击
		public static const PROPTYPE_STRATEGYDEF:uint = 10; //策略防御
		public static const PROPTYPE_ZFDAM:uint = 11; //技能攻击
		public static const PROPTYPE_ZFDEF:uint = 12; //技能防御
		public static const PROPTYPE_BAOJI:uint = 13; //暴击
		public static const PROPTYPE_BJDEF:uint = 14; //防暴击
		public static const PROPTYPE_LUCK:uint = 15; //格挡
		public static const PROPTYPE_POJI:uint = 16; //破击
		public static const PROPTYPE_FANJI:uint = 17; //反击
		public static const PROPTYPE_ATTACKSPEED:uint = 18; //攻击速度
		public static const PROPTYPE_SHIQI:uint = 20; //士气		
		public static const PROPTYPE_ZHANLI:uint = 21; //战力
		public static const PROPTYPE_ZONGZHANLI:uint = 22; //总战力
		
		public static const PROPTYPE_MAX:uint = 23;
		
		//属性名定义
		//-------------------------------------------------
		public static const PROPTYPE_NAME_FORCE:String = "m_uForce"; //武力
		public static const PROPTYPE_NAME_IQ:String = "m_uIQ"; //智力
		public static const PROPTYPE_NAME_CHIEF:String = "m_uChief"; //统帅
		public static const PROPTYPE_NAME_HPLIMIT:String = "m_uHPLimit"; //带兵上限(生命上限)
		public static const PROPTYPE_NAME_LEVEL:String = "m_uLevel"; //等级
		public static const PROPTYPE_NAME_EXP:String = "m_uExp"; //经验
		public static const PROPTYPE_NAME_NEXTEXP:String = "m_uExpTotal"; //下一级经验上限
		public static const PROPTYPE_NAME_PHYDAM:String = "m_uPhyDam"; //物理攻击
		public static const PROPTYPE_NAME_PHYDEF:String = "m_uPhyDef"; //物理防御
		public static const PROPTYPE_NAME_STRATEGYDAM:String = "m_uStrategyDam"; //策略攻击
		public static const PROPTYPE_NAME_STRATEGYDEF:String = "m_uStrategyDef"; //策略防御
		public static const PROPTYPE_NAME_ZFDAM:String = "m_uZfDam"; //技能攻击
		public static const PROPTYPE_NAME_ZFDEF:String = "m_uZfDef"; //技能防御
		public static const PROPTYPE_NAME_BAOJI:String = "m_uBaoji"; //暴击
		public static const PROPTYPE_NAME_BJDEF:String = "m_uBjDef"; //防暴击
		public static const PROPTYPE_NAME_LUCK:String = "m_uLuck"; //格挡
		public static const PROPTYPE_NAME_POJI:String = "m_uPoji"; //破击
		public static const PROPTYPE_NAME_FANJI:String = "m_uFanji"; //反击
		public static const PROPTYPE_NAME_ATTACKSPEED:String = "m_uAttackSpeed"; //攻击速度
		public static const PROPTYPE_NAME_SHIQI:String = "m_uShiqi"; //士气
		public static const PROPTYPE_NAME_ZHANLI:String = "m_uZhanli"; //战力
		public static const PROPTYPE_NAME_ZONGZHANLI:String = "m_uZongZhanli"; //总战力
		//-------------------------------------------------
		public static const SQUAREHEAD_WIDHT:int = 58;
		public static const SQUAREHEAD_HEIGHT:int = 72;
		
		//武将颜色定义
		public static const COLOR_WHITE:int = 0;
		public static const COLOR_GREEN:int = 1;
		public static const COLOR_BLUE:int = 2;
		public static const COLOR_PURPLE:int = 3;
		public static const COLOR_GOLD:int = 4;
		
		//战力级别
		public static const ZHANLI_Putong:int = 0; //普通
		public static const ZHANLI_Jingying:int = 1; //精英
		public static const ZHANLI_Zhuoyue:int = 2; //卓越
		public static const ZHANLI_Shenji:int = 3; //神级
		public static const ZHANLI_Nitian:int = 4; //逆天
		
		public static const HERO_STATE_NOT:int = -1;		//未获得(酒馆中不能招募)
		public static const HERO_STATE_NONE:int = 0;    	//未出战
		public static const HERO_STATE_FIGHT:int = 1;       //出战状态  
		public static const HERO_STATE_GUARD:int = 2;       //守护星座状态
		public static const HERO_STATE_XIAYE:int = 3;       //下野状态
		public static const HERO_STATE_NORECRUIT:int = 4;	//未招募(酒馆中有可以招募;出战列表、未出战列表、下野列表中没有)

		//---------------------
		public var m_gkContext:GkContext;
		public var m_name:String;
		public var m_uHeroID:uint;
		public var m_uJob:int;
		public var m_uSoldierType:int;
		public var m_uFight:uint; //true - 出战	
		public var m_uForce:uint; //武力
		public var m_uIQ:uint; //智力
		public var m_uChief:uint; //统帅
		public var m_uHPLimit:uint; //带兵上限(生命上限，带兵总值)
		public var m_uLevel:uint; //等级
		public var m_uExp:uint; //经验
		public var m_uExpTotal:uint; //升到下级，所需要的总经验
		public var m_uPhyDam:uint; //物理攻击
		public var m_uPhyDef:uint; //物理防御
		public var m_uStrategyDam:uint; //策略攻击
		public var m_uStrategyDef:uint; //策略防御
		public var m_uZfDam:uint; //技能攻击
		public var m_uZfDef:uint; //技能防御
		public var m_uBaoji:uint; //暴击
		public var m_uBjDef:uint; //防暴击
		public var m_uLuck:uint; //格挡
		public var m_uPoji:uint; //破击
		public var m_uFanji:uint; //反击
		public var m_uAttackSpeed:uint; //攻击速度
		public var m_uShiqi:uint; //士气
		public var m_uZhanli:uint; //战力
		public var m_trainLevel:uint;	//当前培养等级
		public var m_trainPower:uint;	//当前培养能量
		public var m_minor:uint;		//0:成年人 1：未成年人
		
		public function WuProperty(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		public function get isMain():Boolean
		{
			return m_uHeroID == WuProperty.MAINHERO_ID;
		}
		
		public function get soldierName():String
		{
			return this.m_gkContext.m_Solder.toSoldierName(m_uSoldierType);
		}
		
		public function get zhanshuID():uint
		{
			return 0;
		}
		
		public function get zhanshuName():String
		{
			return null;
		}
		
		public function get halfingPathName():String
		{
			return null;
		}
		
		public function get xiaye():Boolean
		{
			return m_uFight == HERO_STATE_XIAYE;
		}
		public function setXiaye():void
		{
			m_uFight = HERO_STATE_XIAYE;
		}
		//判断是否出战
		public function get chuzhan():Boolean
		{
			return m_uFight == HERO_STATE_FIGHT;
		}
		
		public function setChuzhan():void
		{
			m_uFight = HERO_STATE_FIGHT;
		}
		
		public function get antiChuzhan():Boolean
		{
			return m_uFight == HERO_STATE_NONE;
		}
		public function setAntiChuzhan():void
		{
			m_uFight = HERO_STATE_NONE;
		}
		public function get fullName():String
		{
			return m_name;
		}
		
		public function get zhanliLimit():int
		{
			var item:TWJZhanliItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_WJZHANLILIMIT, this.m_uLevel) as TWJZhanliItem;
			if (item)
			{
				return item.m_zhanliLimit;
			}
			else
			{
				DebugBox.sendToDataBase("WuProperty::zhanliLimit m_uLevel==" + m_uLevel + " m_uHeroID="+this.m_uHeroID+ " m_name="+m_name);
				return 1;
			}
		}
		
		public function get zhanliHonour():int
		{
			var ret:int;
			var v:Number = m_uZhanli / zhanliLimit;
			if (v < 0.3)
			{
				ret = ZHANLI_Putong;
			}
			else if (v < 0.5)
			{
				ret = ZHANLI_Jingying;
			}
			else if (v < 0.7)
			{
				ret = ZHANLI_Zhuoyue;
			}
			else if (v < 0.9)
			{
				ret = ZHANLI_Shenji;
			}
			else
			{
				ret = ZHANLI_Nitian;
			}
			return ret;
		
		}
		
		public function get trainLevel():uint
		{
			return (m_trainLevel > 0? m_trainLevel: 1);
		}
		
		public function get colorValue():uint
		{
			return 0xdddddd;
		}
		
		//return:此武将对应装备包裹的location值
		public function get packageLocation():int
		{
			return isMain? stObjLocation.OBJECTCELLTYPE_UEQUIP:stObjLocation.OBJECTCELLTYPE_HEQUIP;
		}
		public static function s_PropertyNameToName(propertyName:String):String
		{
			if (m_dicPropertyNameToName == null)
			{
				m_dicPropertyNameToName = new Dictionary();
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_FORCE] = "武力";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_IQ] = "智力";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_CHIEF] = "统率";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_HPLIMIT] = "兵力";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_LEVEL] = "等级";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_EXP] = "经验";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_NEXTEXP] = "下一级经验上限";
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_PHYDAM] = "物理攻击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_PHYDEF] = "物理防御"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_STRATEGYDAM] = "策略攻击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_STRATEGYDEF] = "策略防御"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_ZFDAM] = "技能攻击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_ZFDEF] = "技能防御"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_BAOJI] = "暴击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_BJDEF] = "防暴击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_LUCK] = "运气"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_POJI] = "破击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_FANJI] = "反击"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_ATTACKSPEED] = "出手速度"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_SHIQI] = "士气"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_ZHANLI] = "战力"
				m_dicPropertyNameToName[WuProperty.PROPTYPE_NAME_ZONGZHANLI] = "总战力"
			}
			return m_dicPropertyNameToName[propertyName];
		}
	}

}