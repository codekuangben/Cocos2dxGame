package modulecommon.net.msg.propertyUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stPickUpObjPropertyUserCmd extends stPropertyUserCmd
	{
		//public var x:uint;
		//public var y:uint;
		public var thisid:uint;
		
		public function stPickUpObjPropertyUserCmd() 
		{
			super();
			byParam = stPropertyUserCmd.PICKUPOBJ_PROPERTY_USRECMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			//byte.writeUnsignedInt(x);
			//byte.writeUnsignedInt(y);
			byte.writeUnsignedInt(thisid);
		}
	}
}

//捡物品
//const BYTE PICKUPOBJ_PROPERTY_USRECMD = 5;
//struct stPickUpObjPropertyUserCmd : public stPropertyUserCmd
//{
	//stPickUpObjPropertyUserCmd()
	//{
		//byParam = PICKUPOBJ_PROPERTY_USRECMD;
	//}
	//DWORD x;
	//DWORD y;
	//DWORD thisid;
//};