package game.ui.uipaoshangsys.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class retStartBusinessUserCmd extends stBusinessCmd
	{
		public var ret:uint;
		
		public function retStartBusinessUserCmd()
		{
			super();
			byParam = stBusinessCmd.RET_START_BUSINESS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			ret = byte.readUnsignedByte();
		}
	}
}

//const BYTE RET_START_BUSINESS_USERCMD = 9;
//struct retStartBusinessUserCmd : public stBusinessCmd
//{
	//retStartBusinessUserCmd()
	//{
		//byParam = RET_START_BUSINESS_USERCMD;
		//ret = 0;
	//}
	//BYTE ret; //0:成功， 1：失败
//};