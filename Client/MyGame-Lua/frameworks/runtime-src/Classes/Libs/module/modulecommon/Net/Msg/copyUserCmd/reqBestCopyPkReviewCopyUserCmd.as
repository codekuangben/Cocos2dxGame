package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class reqBestCopyPkReviewCopyUserCmd extends stCopyUserCmd
	{
		public var copyid:uint;
		
		public function reqBestCopyPkReviewCopyUserCmd() 
		{
			byParam = REQ_BEST_COPY_PK_REVIEW_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeInt(copyid);
		}
	}

}

/*
	//请求回放最佳通关战斗
    const BYTE  REQ_BEST_COPY_PK_REVIEW_USERCMD = 56; 
    struct  reqBestCopyPkReviewCopyUserCmd: public stCopyUserCmd
    {   
        reqBestCopyPkReviewCopyUserCmd()
        {   
            byParam = REQ_BEST_COPY_PK_REVIEW_USERCMD;
        }   
		DWORD copyid;	//副本ID
    };  
*/