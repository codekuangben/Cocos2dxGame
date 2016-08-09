package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.wu.WuProperty;
	public class stObjLocation 
	{
		public static const OBJECTCELLTYPE_COMMON1:int = 1;
		public static const OBJECTCELLTYPE_COMMON2:int = 2;
		public static const OBJECTCELLTYPE_COMMON3:int = 3;
		public static const OBJECTCELLTYPE_BAOWU:int = 6;
		public static const OBJECTCELLTYPE_UEQUIP:int = 4;	//玩家装备
		public static const OBJECTCELLTYPE_HEQUIP:int = 5;	//武将装备
		
		public var location:uint;
		public var heroid:uint;
		public var x:int;
		public var y:int;		
		public function deserialize(byte:ByteArray):void
		{
			location = byte.readUnsignedInt();
			heroid = byte.readUnsignedInt();
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
		}
		public function serialize(byte:ByteArray):void
		{
			byte.writeInt(location);
			byte.writeInt(heroid);
			byte.writeShort(x);
			byte.writeShort(y);
		}
		public function toPackageKey():uint
		{
			return ObjectMgr.toPackageKey(heroid, location);
		}
				
		public function clone():stObjLocation
		{
			var ret:stObjLocation = new stObjLocation();
			ret.location = this.location;
			ret.heroid = this.heroid;
			ret.x = this.x;
			ret.y = this.y;
			return ret;
		}
		public static function determineEquationLocation(heroid:uint):uint
		{
			if (heroid == WuProperty.MAINHERO_ID)
			{
				return OBJECTCELLTYPE_UEQUIP;
			}
			return OBJECTCELLTYPE_HEQUIP;
		}
		
		
		//不判断等级，职业，性别属性，只根据位置
		public function matchPos(objType:int):Boolean
		{
			if (location == OBJECTCELLTYPE_UEQUIP || location == OBJECTCELLTYPE_HEQUIP)
			{
				//表示当前位置是放装备的
				if (ZObjectDef.typeToEquipPos(objType) == y)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			return true;
		}
		
		/*
		 * 调用此函数前提是次道具是装备。
		 * 功能：返回值true: 此装备是装备在主角或武将身上了
		 */ 
		public function get isEquipedObject():Boolean
		{
			return location == OBJECTCELLTYPE_UEQUIP || location == OBJECTCELLTYPE_HEQUIP;
		}
		
	}
}

/*
 * struct stObjLocation
	{
		DWORD location;
		DWORD heroid;
		WORD x;
		WORD y;
	}
*/