package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stReqCreateCopyUserCmd extends stCopyUserCmd
	{
		public static const COPYID_SanguoZhanchang:uint = 9999;	//三国战场消息
		public static const COPYID_CorpsCitySys:uint = 8888;	//王成争霸消息
		
		//public var m_cbk:Boolean;
		public var copyid:uint;
		public var type:uint;
		public function stReqCreateCopyUserCmd() 
		{
			byParam = stCopyUserCmd.REQ_CREATE_COPY_USERCMD;
			type = 1;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			//if(m_cbk)
			//{
			//	byParam = stCopyUserCmd.REQ_CREATE_CANG_BAO_KU_COPY_USERCMD;
			//	super.serialize(byte);
			//}
			//else
			//{
				super.serialize(byte);
				byte.writeUnsignedInt(copyid);
				byte.writeByte(type);
			//}
		}
	}
}

//创建副本
//const BYTE  REQ_CREATE_COPY_USERCMD = 1;
//struct  stReqCreateCopyUserCmd: public stCopyUserCmd
//{   
//	DWORD copyid;
//	BYTE type; //0:使用收益  1:不使用收益
//	stReqCreateCopyUserCmd()
//	{   
//		byParam = REQ_CREATE_COPY_USERCMD;
//		copyid = 0;
//		type =0;	
//	}   
//};