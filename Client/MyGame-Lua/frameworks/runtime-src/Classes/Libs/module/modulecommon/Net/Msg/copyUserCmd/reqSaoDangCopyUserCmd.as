package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	
	
	/**
	 * ...
	 * @author panqiangqiang 20130725
	 */
	public class reqSaoDangCopyUserCmd extends stCopyUserCmd
	{
		public var copyid:uint;
		public var type:uint;
		public var num:uint;
		public function reqSaoDangCopyUserCmd()
		{
			byParam = REQ_SAO_DANG_COPY_USERCMD;
		}
		
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(copyid);
			byte.writeByte(type);
			byte.writeByte(num);
		}	
	}
	
	/*
	
	//客户端请求扫荡副本
	320     const BYTE  REQ_SAO_DANG_COPY_USERCMD = 25;
	321     struct  reqSaoDangCopyUserCmd: public stCopyUserCmd
	322     {
	323         reqSaoDangCopyUserCmd()
	324         {
	325             byParam = REQ_SAO_DANG_COPY_USERCMD;
	326             copyid = 0;
	327             type = num = 0;
	328         }
	329         DWORD copyid;
	330         BYTE type; //0:普通副本 1:过关斩将
	331         BYTE num; //次数、层数
	332     };
	
	
	*/
}