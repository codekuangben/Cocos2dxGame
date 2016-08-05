package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stRemoveObjectPropertyUserCmd extends stPropertyUserCmd 
	{
		public var thisID:uint;
		public function stRemoveObjectPropertyUserCmd() 
		{
			byParam = REMOVEUSEROBJ_PROPERTY_USRECMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			thisID = byte.readUnsignedInt();
		}
	}

}

/*
 * //删除道具
	const BYTE REMOVEUSEROBJ_PROPERTY_USRECMD = 2;
	struct stRemoveObjectPropertyUserCmd : public stPropertyUserCmd
	{
		stRemoveObjectPropertyUserCmd()
		{
			byParam = REMOVEUSEROBJ_PROPERTY_USRECMD;
		}
		DWORD thisid;	//物品唯一id
	};
*/