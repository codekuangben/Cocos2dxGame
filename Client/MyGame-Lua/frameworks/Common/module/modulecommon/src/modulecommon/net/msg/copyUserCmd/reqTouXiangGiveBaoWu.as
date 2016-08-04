package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class reqTouXiangGiveBaoWu extends stCopyUserCmd
	{
		public var tempid:uint;

		public function reqTouXiangGiveBaoWu()
		{
			super();
			byParam = stCopyUserCmd.REQ_TOUXIANG_GIVE_BAOWU;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(tempid);
		}
	}
}

//给他宝物请求 c->s
//const BYTE  REQ_TOUXIANG_GIVE_BAOWU = 69;
//struct reqTouXiangGiveBaoWu: public stCopyUserCmd
//{
	//reqTouXiangGiveBaoWu()
	//{
		//byParam = REQ_TOUXIANG_GIVE_BAOWU;
	//}
	//DWORD tempid; //守卫临时id
//};