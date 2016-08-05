package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class notifyTouXiangData extends stCopyUserCmd
	{
		public var tempid:uint;
		public var yinbi:uint;
		public var baowuNum:uint;

		public function notifyTouXiangData() 
		{
			super();
			byParam = stCopyUserCmd.NOTIFY_TOUXIANG_DATA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			tempid = byte.readUnsignedInt();
			yinbi = byte.readUnsignedInt();
			baowuNum = byte.readUnsignedByte();
		}
	}
}

//通知显示藏宝库投降信息 s->c
//const BYTE  NOTIFY_TOUXIANG_DATA = 68;
//struct notifyTouXiangData: public stCopyUserCmd
//{
	//notifyTouXiangData()
	//{
		//byParam = NOTIFY_TOUXIANG_DATA;
		//tempid = yinbi = 0;
		//baowuNum = 0;
	//}
	//DWORD tempid; //守卫临时id
	//DWORD yinbi;
	//BYTE baowuNum;
//};