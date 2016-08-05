package modulecommon.net.msg.propertyUserCmd 
{
	import modulecommon.scene.prop.object.stObjLocation;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stSwapObjectPropertyUserCmd extends stPropertyUserCmd 
	{
		public var thisID:uint;
		public var dst:stObjLocation;
		public function stSwapObjectPropertyUserCmd() 
		{
			byParam = SWAPUSEROBJ_PROPERTY_USRECMD;
			dst = new stObjLocation();
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			thisID = byte.readUnsignedInt();			
			dst.deserialize(byte);
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);			
			byte.writeUnsignedInt(thisID);
			dst.serialize(byte);	
		}
		
	}

}

/*
 * //交换(移动)物品
	const BYTE SWAPUSEROBJ_PROPERTY_USRECMD = 3;
	struct stSwapObjectPropertyUserCmd : public stPropertyUserCmd
	{
		stSwapObjectPropertyUserCmd()
		{
			byParam = SWAPUSEROBJ_PROPERTY_USRECMD;
		}
		DWORD thisid;
		stObjLocation dst;
	};
*/