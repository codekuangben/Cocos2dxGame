package modulecommon.net.msg.copyUserCmd
{
	
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	
	
	/**
	 * ...
	 * @author panqiangqiang 20130730
	 */
	
	public class retQuickFinishSaoDangYuanBaoUserCmd extends stCopyUserCmd
	{
		public var num:uint;
		public function retQuickFinishSaoDangYuanBaoUserCmd()
		{
			byParam = RET_QUICK_FINISH_SAO_DANG_YUAN_BAO_USERCMD;
			num = 0;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			num = byte.readUnsignedInt();
		}	
	}
	
	/*
	
	//快速完成所需元宝   
	416     const BYTE  RET_QUICK_FINISH_SAO_DANG_YUAN_BAO_USERCMD = 31;
	417     struct  retQuickFinishSaoDangYuanBaoUserCmd: public stCopyUserCmd
	418     {     
	419         retQuickFinishSaoDangYuanBaoUserCmd()
	420         { 
	421             byParam = RET_QUICK_FINISH_SAO_DANG_YUAN_BAO_USERCMD;
	422             num = 0;
	423         } 
	424         DWORD num;
	425     };
	*/
		
		
		
}