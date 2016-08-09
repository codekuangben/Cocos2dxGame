package modulecommon.scene.arena 
{
	/**
	 * 竞技场箱子奖励Tips数据
	 * @author ...
	 */
	public class TipData
	{
		public var type:int;		//tips类型 0:今日积分排名奖励  1:周排名奖励
		public var id:int;		//编号
		public var rank:int;	//周排名区间
		public var scoreVec:Vector.<int>;	//积分区间
		public var title:String;	//称号
		public var yinbi:uint;		//获得银币范围
		public var jianghun:uint;	//获得将魂范围
		public var desc:String;		//奖励描述
		
		public function TipData() 
		{
			desc = "";
			title = "";
		}
		
		public function tipsDataParseXml(xml:XML, rewardtype:uint):void
		{
			var str:String 
			var ar:Array;
			scoreVec = new Vector.<int>(2);
			
			type = rewardtype;
			id = parseInt(xml.@id);
			str = xml.@score;
			if (str != null)
			{
				ar = str.split("-");
				if (2 == ar.length)
				{
					scoreVec[0] = ar[0];
					scoreVec[1] = ar[1];
				}
			}
			
			if (ArenaMgr.REWARDWEEK == rewardtype)
			{
				title = xml.@title;
			}
			
			yinbi = parseInt(xml.@yinbi);
			jianghun = parseInt(xml.@jianghun);
			desc = xml.@desc;
		}
		
	}

}