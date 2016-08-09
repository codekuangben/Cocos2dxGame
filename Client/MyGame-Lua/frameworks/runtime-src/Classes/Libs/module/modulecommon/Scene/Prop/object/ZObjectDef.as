package modulecommon.scene.prop.object
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.util.UtilColor;
	
	public class ZObjectDef
	{
		//道具颜色定义
		public static const COLOR_WHITE:int = 0;
		public static const COLOR_GREEN:int = 1;
		public static const COLOR_BLUE:int = 2;
		public static const COLOR_PURPLE:int = 3;
		public static const COLOR_GOLD:int = 4;
		
		//道具位置定义
		public static const HAT:int = 0; //帽子
		public static const CLOTH:int = 1; //衣服
		public static const SHOES:int = 2; //鞋子
		public static const NECKLACE:int = 3; //项链
		public static const WEAPON:int = 4; //武器
		public static const CLOAK:int = 5; //披风
		public static const EQUIP_MAX:int = 6;
		
		//道具类型定义
		public static const ItemType_Hat:int = 1; //帽子
		public static const ItemType_Cloth:int = 2; //衣服
		public static const ItemType_Shoes:int = 3; //鞋子
		public static const ItemType_Necklace:int = 4; //项链
		public static const ItemType_Cloak:int = 5; //披风
		public static const ItemType_BothAxe:int = 6; //双手斧
		public static const ItemType_Fan:int = 7; //羽扇
		public static const ItemType_Bow:int = 8; //弓
		
		public static const ItemType_Yinbi:int = 100; //银币
		public static const ItemType_Jinbi:int = 101; //金币
		public static const ItemType_Yuanbao:int = 102; //元宝
		public static const ItemType_Jianghun:int = 103; //将魂
		public static const ItemType_Binghun:int = 104; //兵魂
		public static const ItemType_Junling:int = 105; //军令
		public static const ItemType_ZhuFuShi:uint = 106; //祝福石(装备强化提升强化成功率)
		public static const ItemType_WuJiang:uint = 107; //武将道具
		public static const ItemType_EmbedGem:uint = 108; //宝石, 可镶嵌在装备上
		public static const ItemType_XiLianShi:uint = 109; //洗练石
		public static const ItemType_Baowu:uint = 110; //宝物
		public static const ItemType_EquipMaterial:uint = 111; //用于合成装备的材料
		public static const ItemType_LiBao:uint = 112; //礼包
		public static const ItemType_GreenShenHun:uint = 113; //绿色神魂
		public static const ItemType_BlueShenHun:uint = 114; //蓝色神魂
		public static const ItemType_YuanQiDan:uint = 115; //元气丹
		public static const ItemType_SuiJiLiBao:uint = 116; //随机礼包
		public static const ItemType_JunLiang:uint = 117; //军粮
		public static const ItemType_YaoShui:uint = 118; //属性加成药水
		public static const ItemType_WuNv:int = 119;	//舞女
		//装备基本属性定义
		public static const EQUIPPROP_PHYDAM:uint = 0; //物理攻击
		public static const EQUIPPROP_PHYDEF:uint = 1; //物理防御
		public static const EQUIPPROP_STRATEGYDAM:uint = 2; //策略攻击
		public static const EQUIPPROP_STRATEGYDEF:uint = 3; //策略防御
		public static const EQUIPPROP_ZFDAM:uint = 4; //技能攻击
		public static const EQUIPPROP_ZFDEF:uint = 5; //技能防御
		public static const EQUIPPROP_SOLDIERLIMIT:uint = 6; //带兵上限
		public static const EQUIPPROP_BAOJI:uint = 7; //暴击
		public static const EQUIPPROP_BJDEF:uint = 8; //防暴击    
		public static const EQUIPPROP_GEDANG:uint = 9; //格挡
		public static const EQUIPPROP_POJI:uint = 10; //破击
		public static const EQUIPPROP_FANJI:uint = 11; //反击
		public static const EQUIPPROP_FORCE:uint = 12; //武力
		public static const EQUIPPROP_IQ:uint = 13 //智力
		public static const EQUIPPROP_CHIEF:uint = 14; //统帅
		
		//宝石相关定义
		public static const GemSlotMAXNUM:int = 4; //装备的宝石槽的最大数量
		
		public static const GEMPROP_PHYDAM:int = 1; //增加物理攻击
		public static const GEMPROP_STRATEGYDAM:int = 2; //增加策略攻击
		public static const GEMPROP_ZFDAM:int = 3; //增加技能攻击
		public static const GEMPROP_PHYDEF:int = 4; //增加物理防御
		public static const GEMPROP_STRATEGYDEF:int = 5; //增加策略防御
		public static const GEMPROP_ZFDEF:int = 6; //增加技能防御
		public static const GEMPROP_HPLIMIT:int = 7; //增加生命上限
		public static const GEMPROP_BAOJI:int = 8; //暴击
		public static const GEMPROP_BJDEF:int = 9; //防暴击
		public static const GEMPROP_POJI:int = 10; //破击
		public static const GEMPROP_GEDANG:int = 11; //格挡
		public static const GEMPROP_ATTACKSPEED:int = 12; //攻击速度
		
		//小属性类型定义
		public static const XLPROP_PHYDAM:int = 1; //增加物理攻击
		public static const XLPROP_STRATEGYDAM:int = 2; //增加策略攻击
		public static const XLPROP_ZFDAM:int = 3; //增加技能攻击
		public static const XLPROP_PHYDEF:int = 4; //增加物理防御
		public static const XLPROP_STRATEGYDEF:int = 5; //增加策略防御
		public static const XLPROP_ZFDEF:int = 6; //增加技能防御
		public static const XLPROP_HPLIMIT:int = 7; //增加生命上限
		public static const XLPROP_BAOJI:int = 8; //暴击
		public static const XLPROP_BJDEF:int = 9; //防暴击
		public static const XLPROP_POJI:int = 10; //破击
		public static const XLPROP_GEDANG:int = 11; //格挡
		public static const XLPROP_ATTACKSPEED:int = 12; //攻击速度
		public static const XLPROP_FORCE:int = 13; //武力
		public static const XLPROP_IQ:int = 14; //智力
		public static const XLPROP_CHIEF:int = 15; //统帅
		
		public static const ObjAniType_None:int = 0;
		public static const ObjAniType_Huanrao:int = 1; //环绕
		public static const ObjAniType_Neiguang:int = 2; //内光
		public static const ObjAniType_Xiaoguang:int = 3; //小光
		
		public static const OBJANIPLAY_IMMEDIATELY:int = 0;//立即播放
		public static const OBJANITYPE_NEVER:int = 1; //不播放
		public static const OBJANITYPE_AFTERBATTLE:int = 2; //战斗结束播放
		
		//一些道具ID的定义
		public static const OBJID_rongyu:uint = 10412; //荣誉勋章
		public static const OBJID_shenge:uint = 19500; //神格
		
		public static function isWeapon(type:uint):Boolean
		{
			return (type == ItemType_BothAxe || type == ItemType_Fan || type == ItemType_Bow);
		}
		
		public static function isEquip(type:uint):Boolean
		{
			return ((0 < type) && (type < 100)); //1~99 为装备
		}
		
		//返回装备基本属性的类型。不能处理武器，因为武器有2个基本属性
		public static function equipBaseAttrType(equipType:int):int
		{
			var ret:int;
			switch (equipType)
			{
				case ItemType_Hat: 
					ret = EQUIPPROP_SOLDIERLIMIT;
					break; //帽子
				case ItemType_Cloth: 
					ret = EQUIPPROP_PHYDEF;
					break; //衣服
				case ItemType_Shoes: 
					ret = EQUIPPROP_STRATEGYDEF;
					break; //鞋子
				case ItemType_Necklace: 
					ret = EQUIPPROP_BAOJI;
					break; //项链
				case ItemType_Cloak: 
					ret = EQUIPPROP_BJDEF;
					break; //披风
			}
			return ret;
		}
		
		public static function numSlot(color:int):int
		{
			var ret:int;
			switch (color)
			{
				case COLOR_WHITE: 
					ret = 0;
					break;
				case COLOR_GREEN: 
					ret = 1;
					break;
				case COLOR_BLUE: 
					ret = 2;
					break;
				case COLOR_PURPLE: 
					ret = 3;
					break;
				case COLOR_GOLD: 
					ret = 4;
					break;
			}
			return ret;
		}
		
		public static function numSmallAttr(color:int,level:int):int
		{
			var ret:int;
			switch (color)
			{
				case COLOR_WHITE:
				case COLOR_GREEN:
					ret = 0;
					break;
				case COLOR_BLUE:
					ret = 1;
					break;
				case COLOR_PURPLE: 
					ret = 2;
					break;
				case COLOR_GOLD: 
				{
					if (level < 50)
					{
						ret = 3;
					}
					else if (level < 60)
					{
						ret = 4;
					}
					else
					{
						ret = 5;
					}
					break;
				}
			}
			return ret;
		}
		
		public static function typeToEquipPos(objType:int):int
		{
			var ret:int = EQUIP_MAX;
			switch (objType)
			{
				case ItemType_Hat: 
					ret = HAT;
					break;
				case ItemType_Cloth: 
					ret = CLOTH;
					break;
				case ItemType_Shoes: 
					ret = SHOES;
					break;
				case ItemType_Necklace: 
					ret = NECKLACE;
					break;
				case ItemType_Cloak: 
					ret = CLOAK;
					break;
				
				case ItemType_BothAxe: 
					ret = WEAPON;
					break;
				case ItemType_Fan: 
					ret = WEAPON;
					break;
				case ItemType_Bow: 
					ret = WEAPON;
					break;
			}
			return ret;
		}
		
		public static function colorValue(color:uint):uint
		{
			var ret:uint;
			switch (color)
			{
				case COLOR_WHITE: 
					ret = UtilColor.WHITE;
					break;
				case COLOR_GREEN: 
					ret = UtilColor.GREEN;
					break;
				case COLOR_BLUE: 
					ret = UtilColor.BLUE;
					break;
				case COLOR_PURPLE: 
					ret = UtilColor.PURPLE;
					break;
				case COLOR_GOLD: 
					ret = UtilColor.GOLD;
					break;
			}
			return ret;
		}
		
		
		public static function getObjAniResName(color:int = 0):String
		{
			var ret:String;
			
			switch(color)
			{
				case ZObjectDef.COLOR_WHITE: ret = "ejzhuangbeihuanraolv.swf"; break;
				case ZObjectDef.COLOR_GREEN: ret = "ejzhuangbeihuanraolv.swf"; break;
				case ZObjectDef.COLOR_BLUE: ret = "ejzhuangbeihuanraolan.swf"; break;
				case ZObjectDef.COLOR_PURPLE: ret = "ejzhuangbeihuanraozi.swf"; break;
				case ZObjectDef.COLOR_GOLD: ret = "ejzhuangbeihuanraojin.swf"; break;
			}
			
			return ret;
		}
		
		public static function colorValueDesc(color:uint):String
		{
			var ret:String;
			switch (color)
			{
				case COLOR_WHITE: 
					ret = "白";
					break;
				case COLOR_GREEN: 
					ret = "绿";
					break;
				case COLOR_BLUE: 
					ret = "蓝";
					break;
				case COLOR_PURPLE: 
					ret = "紫";
					break;
				case COLOR_GOLD: 
					ret = "金";
					break;
			}
			return ret;
		}
		
		public static function gemAttrName(type:int):String
		{
			var ret:String;
			switch (type)
			{
				case GEMPROP_PHYDAM: 
					ret = "物理攻击";
					break;
				case GEMPROP_STRATEGYDAM: 
					ret = "策略攻击";
					break;
				case GEMPROP_ZFDAM: 
					ret = "技能攻击";
					break;
				case GEMPROP_PHYDEF: 
					ret = "物理防御";
					break;
				case GEMPROP_STRATEGYDEF: 
					ret = "策略防御";
					break;
				case GEMPROP_ZFDEF: 
					ret = "技能防御";
					break;
				case GEMPROP_HPLIMIT: 
					ret = "兵力";
					break;
				case GEMPROP_BAOJI: 
					ret = "暴击";
					break;
				case GEMPROP_BJDEF: 
					ret = "防暴击";
					break;
				case GEMPROP_POJI: 
					ret = "破击";
					break;
				case GEMPROP_GEDANG: 
					ret = "运气";
					break; //格挡
				case GEMPROP_ATTACKSPEED: 
					ret = "出手速度";
					break;
			}
			return ret;
		}
		
		public static function baseAttrTypeToName(type:int):String
		{
			var str:String = "";
			switch (type)
			{
				case ZObjectDef.EQUIPPROP_PHYDEF: 
					str = "物理防御";
					break;
				case ZObjectDef.EQUIPPROP_STRATEGYDEF: 
					str = "策略防御";
					break;
				case ZObjectDef.EQUIPPROP_ZFDAM: 
					str = "技能攻击";
					break;
				case ZObjectDef.EQUIPPROP_ZFDEF: 
					str = "技能防御";
					break;
				case ZObjectDef.EQUIPPROP_SOLDIERLIMIT: 
					str = "兵力";
					break;
				case ZObjectDef.EQUIPPROP_BJDEF: 
					str = "防暴击";
					break;
				case ZObjectDef.EQUIPPROP_BAOJI: 
					str = "暴击";
					break;
			}
			return str;
		}
		
		public static function composeEquipID(pos:int, equipLevel:int):uint
		{
			equipLevel = Math.floor(equipLevel / 10) * 10;
			if (equipLevel == 0)
			{
				equipLevel = 1;
			}
			var equipid:uint = (pos + 1) * 100000 + equipLevel;
			if (pos == 4)
				equipid = 600000 + equipLevel;
			if (pos == 5)
				equipid = 500000 + equipLevel;
			return equipid;
		}
		
		// 装备存放的位置
		public static function inEquipPackage(obj:ZObject):Boolean
		{
			var loc:int = obj.m_object.m_loation.location;
			
			if (loc >= stObjLocation.OBJECTCELLTYPE_COMMON1 && loc <= stObjLocation.OBJECTCELLTYPE_COMMON2)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}

}