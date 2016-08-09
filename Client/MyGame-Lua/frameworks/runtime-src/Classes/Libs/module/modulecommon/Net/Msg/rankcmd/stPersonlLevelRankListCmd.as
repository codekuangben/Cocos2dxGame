package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stPersonlLevelRankListCmd extends stRankCmd
	{
		public var num:uint;
		public var lrlist:Array;
		
		public var mselfRank:stPersonalRankItem;		// 自己的排名信息
		public var mfCB:Function;						// 回调函数

		public function stPersonlLevelRankListCmd()
		{
			super();
			byParam = stRankCmd.PARA_PERSONAL_LEVEL_RANK_LIST_USERCMD;			
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);

			lrlist = [];
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
						lrlist[lrlist.length] = item;
					}
				}
				else
				{
					lrlist[lrlist.length] = item;
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
	}
}

//个人等级榜信息
//const BYTE PARA_PERSONAL_LEVEL_RANK_LIST_USERCMD = 3;
//struct stPersonlLevelRankListCmd : public stRankCmd
//{   
	//stPersonlLevelRankListCmd()
	//{   
		//byParam = PARA_PERSONAL_LEVEL_RANK_LIST_USERCMD;
		//num = 0;
	//}   
	//WORD num;
	//stPersonalRankItem lrlist[0];
	//WORD getSize()
	//{
		//return (sizeof(*this) + num*sizeof(stPersonalRankItem));
	//}
//};