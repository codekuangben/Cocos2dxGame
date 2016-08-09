package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class notifyBestCopyPkReviewCopyUserCmd extends stCopyUserCmd
	{
		public var bprid:uint;
		public var zhanli:uint;
		public var name:String;
		
		public function notifyBestCopyPkReviewCopyUserCmd() 
		{
			byParam = NOTIFY_BEST_COPY_PK_REVIEW_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			bprid = byte.readUnsignedInt();
			zhanli = byte.readUnsignedInt();
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
		}
	}

}

/*
//发送副本最佳通关记录
    const BYTE  NOTIFY_BEST_COPY_PK_REVIEW_USERCMD = 55; 
    struct  notifyBestCopyPkReviewCopyUserCmd: public stCopyUserCmd
    {   
        notifyBestCopyPkReviewCopyUserCmd()
        {   
            byParam = NOTIFY_BEST_COPY_PK_REVIEW_USERCMD;
            zhanli = 0;
            bzero(name, MAX_NAMESIZE);
        }   
		DWORD bprid;    //最佳通关纪录id
        DWORD zhanli;
        char name[MAX_NAMESIZE];
    };  
*/