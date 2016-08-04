package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stPersonalZhanLiRankListCmd extends stRankCmd
	{
		public var num:uint;
		public var zllist:Array;
		
		public var mselfRank:stPersonalRankItem;		// 自己的排名信息
		public var mfCB:Function;						// 回调函数
		
		public function stPersonalZhanLiRankListCmd()
		{
			super();
			byParam = stRankCmd.PARA_PERSONAL_ZHANLI_RANK_LIST_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);

			zllist = [];
			num = byte.readUnsignedShort();
			var idx:uint = 0;
			var item:stPersonalRankItem;

			while (idx < num)
			{
				item = new stPersonalRankItem();
				item.deserialize(byte);
				
				if (mfCB(item))
				{
					mselfRank = item;
					// 如果在 50 名内
					if (idx < 50)
					{
						zllist[zllist .length] = item;
					}
				}
				else
				{
					zllist[zllist.length] = item;
				}
				
				++idx;
			}
			
			mfCB = null;
		}
		
		public function getSelfRankStr():String
		{
			if (mselfRank && mselfRank.rank)
			{
				return mselfRank.rank + "";
			}
			else
			{
				return "未上榜";
			}
		}
		
		public function getSelfRank():uint
		{
			if (mselfRank)
			{
				return mselfRank.rank;
			}
			else
			{
				return 0;
			}
		}
		
		public function getSelfLevel():uint
		{
			if (mselfRank)
			{
				return mselfRank.level;
			}
			else
			{
				return 0;
			}
		}
		
		public function getSelfZhanLi():uint
		{
			if (mselfRank)
			{
				return mselfRank.zhanli;
			}
			else
			{
				return 0;
			}
		}
	}
}

//个人战力榜
//const BYTE PARA_PERSONAL_ZHANLI_RANK_LIST_USERCMD = 4;
//struct stPersonalZhanLiRankListCmd : public stRankCmd
//{
	//stPersonalZhanLiRankListCmd()
	//{
		//byParam = PARA_PERSONAL_ZHANLI_RANK_LIST_USERCMD;
		//num = 0;
	//}
	//WORD num;
	//stPersonalRankItem zllist[0];
	//WORD getSize()
	//{
		//return (sizeof(*this) + num*sizeof(stPersonalRankItem));
	//}
//};