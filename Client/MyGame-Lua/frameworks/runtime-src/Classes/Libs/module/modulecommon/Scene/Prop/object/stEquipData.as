package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stEquipData 
	{
		public var isNoServerData:Boolean;	//true -表示没有服务器生成的数据，比如宝石，小属性
		
		public var color:uint;
		public var basePropType:uint;
		public var basePropValue:uint;
		public var enhancelevel:uint;
		public var basePropEnhance:uint;
		public var gemslots:Vector.<uint>;
		public var smallAttrs:Vector.<SmallAttrData>
		public var equipmark:uint;
		
		public function serialize(byte:ByteArray):void
		{
			byte.writeByte(color);
			byte.writeByte(basePropType);
			byte.writeUnsignedInt(basePropValue);
			byte.writeByte(enhancelevel);
			byte.writeUnsignedInt(basePropEnhance);
			
			var i:int=0;
			if (gemslots)
			{
				for (i = 0; i < gemslots.length; i++)
				{
					byte.writeUnsignedInt(gemslots[i]);
				}
			}
			for (; i < ZObjectDef.GemSlotMAXNUM; i++)
			{
				byte.writeUnsignedInt(0);
			}
			var sad:SmallAttrData;
			for (i = 0; i < 5; i++)
			{
				if (smallAttrs && i < smallAttrs.length )
				{
					sad = smallAttrs[i];
				}
				else
				{
					sad = new SmallAttrData();
				}
				sad.serialize(byte);
			}
			byte.writeUnsignedInt(equipmark);
		}
		public function deserialize(byte:ByteArray):void
		{
			color = byte.readUnsignedByte();
			basePropType = byte.readUnsignedByte();
			basePropValue = byte.readUnsignedInt();
			enhancelevel = byte.readUnsignedByte();
			basePropEnhance = byte.readUnsignedInt();
			gemslots = new Vector.<uint>(4);
			
			var i:int=0;
			while (i < ZObjectDef.GemSlotMAXNUM)
			{			
				gemslots[i] = byte.readUnsignedInt();		
				i++;
			}
			
			i = 0;
			var sad:SmallAttrData;					
			while (i < 5)
			{
				sad = new SmallAttrData();
				sad.deserialize(byte);
				if (sad.m_type||sad.m_value)
				{
					if (smallAttrs == null)
					{
						smallAttrs = new Vector.<SmallAttrData>();
					}
					smallAttrs.push(sad);
				}
				else
				{
					byte.position += (5 - (i+1)) * SmallAttrData.SIZE;
					break;
				}
				i++;
			}
			
			equipmark = byte.readUnsignedInt(); 
		}
		
		public function clone():stEquipData
		{
			var ret:stEquipData = new stEquipData();
			ret.color = this.color;
			ret.basePropType = this.basePropType;
			ret.basePropValue = this.basePropValue;
			ret.enhancelevel = this.enhancelevel;
			ret.basePropEnhance = this.basePropEnhance;
			ret.equipmark = this.equipmark;
			var i:int;
			if (this.gemslots)
			{
				ret.gemslots = new Vector.<uint>();
				for (i = 0; i < this.gemslots.length; i++)
				{
					ret.gemslots.push(this.gemslots[i]);
				}
			}
			if (this.smallAttrs)
			{
				ret.smallAttrs = new Vector.<SmallAttrData>();
				for (i = 0; i < this.smallAttrs.length; i++)
				{
					ret.smallAttrs.push(this.smallAttrs[i].clone());
				}
			}
			return ret;
		}
		
		public function get numOfSmallAttrsOwn():int
		{
			if (smallAttrs == null)
			{
				return 0;
			}
			return smallAttrs.length;
		}
		
		//取得第index宝石ID
		public function getGemID(index:int):uint
		{
			if (gemslots == null || index>=gemslots.length )
			{
				return 0;
			}
			return gemslots[index];
		}
	}

}

/*
 * ///装备数据
	struct stEquipData
	{
		BYTE  color;  //品质
		BYTE  basePropType;		//基础类型
		DWORD basePropValue;	//基础数值
		BYTE  enhancelevel;     //强化等级
		DWORD basePropEnhance;	//增加数值(装备改造等用)
		DWORD gemslot[4];   //镶嵌槽
		DWORD equipmark;    //装备评分
		stEquipData()
		{
			basePropType = 0;
			basePropValue = 0;
			basePropEnhance = 0;
			equipmark = 0;
		}
	};
*/