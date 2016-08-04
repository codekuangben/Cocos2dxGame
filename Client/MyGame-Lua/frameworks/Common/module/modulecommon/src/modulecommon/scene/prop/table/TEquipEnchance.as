package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.ZObjectDef;
	/**
	 * ...
	 * @author 
	 * 编号定义:"1001~1999为1级装备
5001~5999为5级装备
10001~10999为10级装备

千位万位十万位为装备等级
个,十,百位为强化等级"


	 */
	public class TEquipEnchance extends TDataItem 
	{
		//public var m_iLvl:uint;	// 等级
		//public var m_strName:String;	// 名称
		public var m_sucRate:uint;	// 成功率
		public var m_cost:uint;	// 费用
		//public var m_color:uint;	// 颜色品质
		//public var m_mjequip:uint;	// 猛将武器
		//public var m_jsequip:uint;	// 军师武器
		//public var m_gjequip:uint;	// 弓将武器
		public var m_equip:uint;	// 猛将武器
		public var m_hat:uint;	// 帽子
		public var m_clothes:uint;	// 衣服
		public var m_shoes:uint;	// 鞋子
		public var m_ring:uint;	// 戒指
		public var m_cloak:uint;	// 披风
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			//m_iLvl = bytes.readUnsignedInt();
			//m_strName = TDataItem.readString(bytes);
			m_sucRate = bytes.readUnsignedByte();
			m_cost = bytes.readUnsignedInt();
			//m_color = bytes.readUnsignedByte();
			
			//m_mjequip = bytes.readUnsignedShort();
			//m_jsequip = bytes.readUnsignedShort();
			//m_gjequip = bytes.readUnsignedShort();
			m_equip = bytes.readUnsignedShort();
			
			m_hat = bytes.readUnsignedShort();
			m_clothes = bytes.readUnsignedShort();
			m_shoes = bytes.readUnsignedShort();
			m_ring = bytes.readUnsignedShort();
			m_cloak = bytes.readUnsignedShort();
		}
		
		public function getEnhanceValueByType(type:int):uint
		{
			var name:String = "";
			switch(type)
			{
				case ZObjectDef.ItemType_Hat: name = "m_hat"; break;
				case ZObjectDef.ItemType_Cloth: name = "m_clothes"; break;
				case ZObjectDef.ItemType_Shoes: name = "m_shoes"; break;
				case ZObjectDef.ItemType_Necklace: name = "m_ring"; break;
				case ZObjectDef.ItemType_Cloak: name = "m_cloak"; break;
				case ZObjectDef.ItemType_BothAxe: name = "m_equip"; break;
			}
			return this[name];
		}
		
	}
}