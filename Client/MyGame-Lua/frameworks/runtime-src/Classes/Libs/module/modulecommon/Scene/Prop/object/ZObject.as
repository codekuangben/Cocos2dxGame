package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TEnchUpperItem;
	import modulecommon.scene.prop.table.TEquipColorAdvanceItem;
	import modulecommon.scene.prop.table.TEquipEnchance;
	import modulecommon.scene.prop.table.TEquipLevelAdvanceItem;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import org.ffilmation.engine.datatypes.IntPoint;
	public class ZObject 
	{
		public static var m_gkContext:GkContext
		public static var dataTable:DataTable;
		public static const IconSize:int = 40;
		public static const IconBgSize:int = 46;
		public static const IconBg:String = "commoncontrol/panel/objectBG.png";
		public var m_ObjectBase:TObjectBaseItem;
		public var m_object:T_Object;
		public function ZObject()
		{
			
		}
		
		public function get thisID():uint
		{
			return m_object.thisID;
		}
		
		public function get iconName():String
		{
			return m_ObjectBase.m_iIconName;
		}
		
		public function get pathIconName():String
		{
			return m_ObjectBase.pathIconName();
		}
		
		public function get name():String
		{	
			var ret:String = m_ObjectBase.m_name;
			if (isEquip)
			{
				if (m_object.m_equipData.enhancelevel > 0)
				{
					ret += "+"+m_object.m_equipData.enhancelevel;
				}
			}
			
			return ret;
		}
		
		public function get type():int
		{
			return m_ObjectBase.m_iType;
		}
		
		public function get maxNum():uint
		{
			return m_ObjectBase.m_uMaxNum;
		}
		public function get equipPos():int
		{
			return ZObjectDef.typeToEquipPos(m_ObjectBase.m_iType);
		}
		public function get needLevel():int
		{
			return m_ObjectBase.m_iNeedLevel;
		}
		public function get level():int
		{
			return m_ObjectBase.m_iLevel;
		}
		public function get enchUpperID():uint
		{
			return m_ObjectBase.m_iNeedLevel * 10 + iconColor;
		}
		
		public function get isWeapon():Boolean
		{
			return ZObjectDef.isWeapon(m_ObjectBase.m_iType);
		}
		public function get isEquip():Boolean
		{
			return ZObjectDef.isEquip(m_ObjectBase.m_iType);
		}
		
		public function get numSlot():int
		{
			return ZObjectDef.numSlot(iconColor);
		}
		public function get numSmallAttr():int
		{
			return ZObjectDef.numSmallAttr(iconColor,level);
		}
		public function get equipBaseAttrType():int
		{
			return ZObjectDef.equipBaseAttrType(type);
		}
		
		public function get equipBaseAttrValue():int
		{
			var s:Number = 1;
			var c:int = iconColor;
			
			if (c == ZObjectDef.COLOR_BLUE)
			{
				s = 1.3;
			}
			else if (c == ZObjectDef.COLOR_PURPLE)
			{
				s = 1.6;
			}
			else if (c == ZObjectDef.COLOR_GOLD)
			{
				s = 2;
			}
			
			s = s * m_ObjectBase.m_iShareData1;
			return (int)(s);		
			
		}
		//返回值：true-此道具在包裹中
		public function get isInCommonPackage():Boolean
		{
			var loc:int = m_object.m_loation.location;
			if (loc >= stObjLocation.OBJECTCELLTYPE_COMMON1 && loc <= stObjLocation.OBJECTCELLTYPE_COMMON2)
			{
				return true;
			}
			return false;
		}
		//返回值：true-此装备已经装备到武将身上了
		public function get isEquiped():Boolean
		{
			var loc:int = m_object.m_loation.location;
			if (loc == stObjLocation.OBJECTCELLTYPE_HEQUIP || loc == stObjLocation.OBJECTCELLTYPE_UEQUIP)
			{
				return true;
			}
			return false;
		}
		
		//返回道具的颜色类型。Icon颜色与装备颜色是相同的
		public function get iconColor():int
		{
			var colorType:int;
			if (this.isEquip)
			{
				colorType = m_object.m_equipData.color;
			}
			else
			{
				colorType = m_ObjectBase.m_iIconColor;
			}			
			return colorType;
		}
		
		//返回颜色值
		public function get colorValue():uint
		{
			return ZObjectDef.colorValue(iconColor);
		}
		public function get ObjID():uint
		{
			return m_ObjectBase.m_uID;
		}
		
		public function toPackageKey():uint
		{
			if (m_object != null)
			{
				return m_object.toPackageKey();
			}
			return 0;			
		}
		public function setObject(t_object:T_Object):Boolean
		{
			m_ObjectBase = dataTable.getItem(DataTable.TABLE_OBJECT, t_object.objID) as TObjectBaseItem;
			if (m_ObjectBase == null)
			{
				return false;
			}
			m_object = t_object;
			/*if (m_object.name == null)
			{
				m_object.name = m_ObjectBase.m_name;
			}*/
			return true;
		}
		public function clone():ZObject
		{
			var ret:ZObject = new ZObject();
			ret.m_ObjectBase = m_ObjectBase;
			ret.m_object = m_object.clone();
			return ret;
		}
		/*
		 * 在客户端创建一个道具
		 */ 
		public static function createClientObject(id:uint, num:uint = 1, color:int=0):ZObject
		{
			var base:TObjectBaseItem;
			base = dataTable.getItem(DataTable.TABLE_OBJECT, id) as TObjectBaseItem;
			if (base == null)
			{
				return null;
			}
			var obj:ZObject = new ZObject();
			var tObject:T_Object = new T_Object();
			//tObject.name = base.m_name;
			tObject.objID = base.m_uID;
			tObject.num = num;	
			
			obj.m_ObjectBase = base;
			obj.m_object = tObject;
			
			if (obj.isEquip)
			{
				obj.m_object.m_equipData = new stEquipData();
				obj.m_object.m_equipData.isNoServerData = true;
				obj.m_object.m_equipData.color = color;
			}
			return obj;
		}
		
		
		//判断装备上是否有镶嵌宝石
		public function bHaveGems():Boolean
		{
			if (m_object.m_equipData)
			{
				var i:int = 0;
				while (i < numSlot)
				{
					if (m_object.m_equipData.gemslots[i])
					{
						return true;
					}
					i++;
				}
			}
			return false;
		}
		public function get hasSmallAttrData():Boolean
		{
			return m_object.m_equipData.smallAttrs != null;
		}		
		
		//取得第index宝石ID
		public function getGemID(index:int):uint
		{
			return m_object.m_equipData.getGemID(index);
		}
		
		//获得道具的游戏币价格(银币价格)
		public function get price_GameMoney():uint
		{
			var ret:uint;
			if (isEquip)
			{
				//装备贩卖价格=300+装备颜色系数*30+5*装备等级*（1+当前装备强化数）*当强装备强化数
				ret = 300 + (m_object.m_equipData.color + 1) * 30 + 5 * m_ObjectBase.m_iNeedLevel * (1 + m_object.m_equipData.enhancelevel) * m_object.m_equipData.enhancelevel;
			}
			else
			{
				ret = m_ObjectBase.m_gamePrice;
			}
			return ret;
		}
		// 返回装备评分值
		//public function equipScore():uint
		//{
			//return m_object.m_equipData.basePropEnhance;
		//}
		
		//装备当前强化等级
		public function get curEnhanceLevel():int
		{
			if (isEquip)
			{
				return m_object.m_equipData.enhancelevel;
			}
			
			return 0;
		}
		
		//装备最大强化等级
		public function get maxEnhanceLevel():int
		{
			if (isEquip)
			{
				var enchUpperItem:TEnchUpperItem = dataTable.getItem(DataTable.TABLE_EQUIPQHUPPER, enchUpperID) as TEnchUpperItem;
				if (enchUpperItem)
				{
					return enchUpperItem.m_upperLimit;
				}
			}
			
			return 0;
		}
		//返回值：true - 此装备已是最高强化等级
		public function get isMaxEnhanceLevel():Boolean
		{
			return m_object.m_equipData.enhancelevel == maxEnhanceLevel;
		}
		
		//返回值：装备等级提升时，下一个等级
		public function get nextEquipLevel():int
		{
			if (m_ObjectBase.m_iNeedLevel == 1)
			{
				return m_ObjectBase.m_iNeedLevel + 9;
			}
			else
			{
				return m_ObjectBase.m_iNeedLevel + 10;
			}
		}
		//返回值：装备等级提升时，下一个等级的道具ID
		public function get nextEquipID():uint
		{
			if (m_ObjectBase.m_iNeedLevel == 1)
			{
				return m_ObjectBase.m_uID + 9;
			}
			else
			{
				return m_ObjectBase.m_uID + 10;
			}
		}
		
		/*返回提升equip的等级所需要的材料
		 * IntPoint.x 材料ID
		 * IntPoint.y 材料数量
		 */
		public function getMateialForLevelAdvance():Vector.<IntPoint>
		{
			var id:uint = iconColor + nextEquipLevel * 10 + type * 10000;
			var base:TEquipLevelAdvanceItem = dataTable.getItem(DataTable.TABLE_EQUIP_LEVEL_ADVANCE, id) as TEquipLevelAdvanceItem;
			if (base==null)
			{
				return null;
			}
			
			var item:IntPoint;
			var retList:Vector.<IntPoint> = new Vector.<IntPoint>();
									
			item = new IntPoint(base.m_materialID1, base.m_num1);
			retList.push(item);
			if (base.m_materialID2)
			{
				item = new IntPoint(base.m_materialID2, base.m_num2);
				retList.push(item);
			}
			if (base.m_materialID3)
			{
				item = new IntPoint(base.m_materialID3, base.m_num3);
				retList.push(item);
			}
			
			return retList;
		}
		
		public function isMaterialEnoughForLevelAdvance():Boolean
		{
			var matList:Vector.<IntPoint> = getMateialForLevelAdvance();
			if (matList == null)
			{
				return false;
			}
			var numOwn:uint;
			var matItem:IntPoint;
			for each(matItem in matList)
			{
				numOwn = m_gkContext.m_objMgr.computeObjNumInCommonPackage(matItem.x);
				if (numOwn < matItem.y)
				{
					return false;
				}
			}
			return true;
		}
		
		//返回值: true-表示此装备可以颜色提升
		public function get canColorAdvance():Boolean
		{
			if (this.iconColor >= ZObjectDef.COLOR_GOLD)
			{
				return false;
			}
			var id:uint = (this.iconColor+1) + m_ObjectBase.m_iNeedLevel * 10 + type * 10000;
			return null != dataTable.getItemEx(DataTable.TABLE_EQUIPADVANCE, id);
		}
		
		/*返回提升equip的颜色所需要的材料
		 * IntPoint.x 材料ID
		 * IntPoint.y 材料数量
		 */
		public function getMateialForColorAdvance():Vector.<IntPoint>
		{			
			var id:uint = (this.iconColor+1) + m_ObjectBase.m_iNeedLevel * 10 + type * 10000;
			
			var base:TEquipColorAdvanceItem = dataTable.getItem(DataTable.TABLE_EQUIPADVANCE, id) as TEquipColorAdvanceItem;
			if (base==null)
			{
				return null;
			}
			var item:IntPoint;
			var retList:Vector.<IntPoint> = new Vector.<IntPoint>();
			
			item = new IntPoint(base.m_materialID1, base.m_num1);
			retList.push(item);
			if (base.m_materialID2)
			{
				item = new IntPoint(base.m_materialID2, base.m_num2);
				retList.push(item);
			}
			if (base.m_materialID3)
			{
				item = new IntPoint(base.m_materialID3, base.m_num3);
				retList.push(item);
			}			
			return retList;
		}	
		public function isMaterialEnoughForColorAdvance():Boolean
		{
			var matList:Vector.<IntPoint> = getMateialForColorAdvance();
			if (matList == null)
			{
				return false;
			}
			var numOwn:uint;
			var matItem:IntPoint;
			for each(matItem in matList)
			{
				numOwn = m_gkContext.m_objMgr.computeObjNumInCommonPackage(matItem.x);
				if (numOwn < matItem.y)
				{
					return false;
				}
			}
			return true;
		}
		public function computeBasePropEnhance():uint
		{
			var ret:int;
			var lowID:uint = needLevel * 1000 + 1;
			var highID:uint = needLevel * 1000 + curEnhanceLevel;
			
			var id:uint;
			var base:TEquipEnchance;
			var t:int = this.type;
			for (id = lowID; id <= highID; id++)
			{
				base = dataTable.getItem(DataTable.TABLE_EQUIPQH, id) as TEquipEnchance;
				if (base)
				{
					ret += base.getEnhanceValueByType(t);
				}
			}
			return ret;
			
		}
		
	}

}