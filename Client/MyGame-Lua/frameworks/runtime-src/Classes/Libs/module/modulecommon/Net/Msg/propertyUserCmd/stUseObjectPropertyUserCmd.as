package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stUseObjectPropertyUserCmd extends stPropertyUserCmd 
	{
		public var thisID:uint;
		public var num:uint;
		public function stUseObjectPropertyUserCmd() 
		{
			byParam = USEUSEROBJ_PROPERTY_USRECMD;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);			
			byte.writeInt(thisID);
			byte.writeInt(num);
		}
		
	}

}

/*
 * //使用物品
	const BYTE USEUSEROBJ_PROPERTY_USRECMD = 4;
	struct stUseObjectPropertyUserCmd : public stPropertyUserCmd
	{
		stUseObjectPropertyUserCmd()
		{
			byParam = USEUSEROBJ_PROPERTY_USRECMD;
		}
		DWORD thisid;
		DWORD num;
	};
*/