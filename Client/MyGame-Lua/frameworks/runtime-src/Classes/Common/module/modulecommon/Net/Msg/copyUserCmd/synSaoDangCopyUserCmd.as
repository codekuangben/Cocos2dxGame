package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	
	
	/**
	 * ...
	 * @author panqiangqiang 20130725
	 */
	public class synSaoDangCopyUserCmd extends stCopyUserCmd
	{
		public var name:String; //副本名字
		public var cishu:uint; //层、次数
		public var type:uint; //类型
		public var time:uint; //剩余时间
		public function synSaoDangCopyUserCmd()
		{
			byParam = SYN_SAO_DANG_COPY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			cishu = byte.readUnsignedByte();
			type = byte.readUnsignedByte();
			time = byte.readUnsignedInt();	
			
		}
		/*
		const BYTE  SYN_SAO_DANG_COPY_USERCMD = 26;
		334     struct  synSaoDangCopyUserCmd: public stCopyUserCmd
		335     {
		336         synSaoDangCopyUserCmd()
		337         {
		338             byParam = SYN_SAO_DANG_COPY_USERCMD;
		339             bzero(copyname, MAX_NAMESIZE);
		340             type = 0;
		341             time = 0;
		342         }
		343         char copyname[MAX_NAMESIZE];
		344         union
		345         {
		346             BYTE cishu; //副本扫荡次数
		347             BYTE cengshu; //过关斩将第几层
		348         };
		349         BYTE type; //0:普通副本 1:过关斩将
		350         DWORD time; //剩余时间
		351     };
		*/
	}
}