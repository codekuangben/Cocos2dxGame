package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;

	/**
	 * @author ...
	 */
	public class stReqRankListUserCmd extends stRankCmd
	{	
		public var type:uint;
		
		public function stReqRankListUserCmd() 
		{
			super();
			byParam = stRankCmd.REQ_RANK_LIST_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(type);
		}
	}
}

//const BYTE CORPS_LEVEL_RANK = 0; //军团等级
//const BYTE CORPS_ZHANLI_RANK = 1; //军团战力

////请求打开排行榜 c->s
//const BYTE REQ_RANK_LIST_USERCMD = 1;
//struct stReqRankListUserCmd : public stRankCmd
//{
	//stReqRankListUserCmd()
	//{
		//byParam = REQ_RANK_LIST_USERCMD;
	//}
	//BYTE type;
//};