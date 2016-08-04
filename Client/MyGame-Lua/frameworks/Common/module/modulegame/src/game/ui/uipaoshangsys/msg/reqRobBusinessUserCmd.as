package game.ui.uipaoshangsys.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqRobBusinessUserCmd extends stBusinessCmd
	{
		public var id:uint;
		
		public function reqRobBusinessUserCmd() 
		{
			super();
			byParam = stBusinessCmd.REQ_ROB_BUSINESS_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(id);
		}
	}
}

//请求抢劫某人
//const BYTE REQ_ROB_BUSINESS_USERCMD = 10;
//struct reqRobBusinessUserCmd : public stBusinessCmd
//{
	//reqRobBusinessUserCmd()
	//{
		//byParam = REQ_ROB_BUSINESS_USERCMD;
	//}
	//DWORD id; //
//};