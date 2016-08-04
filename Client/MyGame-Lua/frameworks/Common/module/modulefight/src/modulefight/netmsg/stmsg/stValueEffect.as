package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stValueEffect 
	{				
		
		public var pos:int;
		public var curhp:int;
		public var curshiqi:int;
		public var type:int;	//FightEn.DAMTYPE_VEADDHP等值
		public var value:int;
		public function stValueEffect() 
		{
			
		}
		
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			curshiqi = byte.readUnsignedByte();
			curhp = byte.readUnsignedInt();			
			type = byte.readUnsignedByte();
			value = byte.readInt();
		}
		
		public static function readList(size:int, byte:ByteArray):Vector.<stValueEffect>
		{
			var list:Vector.<stValueEffect> = new Vector.<stValueEffect>();
			var effItem:stValueEffect;
			var i:int;
			var k:int;
			for (i = 0; i < size; i++)
			{
				effItem = new stValueEffect();
				effItem.deserialize(byte);
				
				for (k = 0; k < list.length; k++)
				{
					var listItem:stValueEffect = list[k];
					if (listItem.pos == effItem.pos && listItem.type == effItem.type)
					{
						listItem.value += effItem.value;
						break;
					}
				}
				
				if (k >= list.length)
				{
					list.push(effItem);
				}
			}	
			
			return list;
		}
	}

}


//数值效果
/*struct stValueEffect
{
	BYTE pos;	//十位数表示部队，个位数表示格子编号
	BYTE curshiqi
	DWORD curhp;
	
	BYTE type;	//效果类型：0. 无效值，1.士气变化, 2兵力变化
	int value;	
}
*/