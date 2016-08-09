package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author panqiangqiang
	 */
	public class stRetMaxClearanceIdUserCmd extends stCopyUserCmd
	{
		public var id:uint;
		public function stRetMaxClearanceIdUserCmd()
		{
			byParam = RET_MAX_CLEARANCE_ID_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			id = byte.readUnsignedByte();
		}
	}
}

/*
//返回最大通关id
const BYTE  RET_MAX_CLEARANCE_ID_USERCMD = 10; 
struct  stRetMaxClearanceIdUserCmd: public stCopyUserCmd
{   
stRetMaxClearanceIdUserCmd()
{   
byParam = RET_MAX_CLEARANCE_ID_USERCMD;
id = 0;
}   
BYTE id; 
};  */