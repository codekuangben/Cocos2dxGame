package game.ui.uiTeamFBSys.xmldata
{
	/**
	 * @author ...
	 */
	public class XmlData 
	{	
		public var m_guanshujianglitip:String;
		public var m_mingcijianglitip:String;
		
		public var m_defGuanshujianglitip:String;
		public var m_defMingcijianglitip:String;		
		
		public var m_bossRewardVec:Vector.<XmlBossRewardItem>;
		public var m_rankVec:Vector.<XmlRankItem>;
		
		public function XmlData()
		{
			m_bossRewardVec = new Vector.<XmlBossRewardItem>();
			m_rankVec = new Vector.<XmlRankItem>();
		}
		
		// 根据 boss id 查找总和
		public function getTotalByBossID(bossid:uint):uint
		{
			var item:XmlBossRewardItem;
			var total:uint = 0;
			for each(item in m_bossRewardVec)
			{
				total += item.m_siliver;
				if (item.m_bossID == bossid)
				{
					break;
				}
			}
			
			return total;
		}
		
		// 根据索引查找总和，索引从 1 开始的，因此应该是 < 1
		public function getTotalByIdx(idx:uint):uint
		{
			var item:XmlBossRewardItem;
			var total:uint = 0;
			var curidx:int = 0;
			while(curidx < idx)
			{
				item = m_bossRewardVec[curidx];
				total += item.m_siliver;
				++curidx;
			}
			
			return total;
		}
		
		public function getTextByRank(rank:uint):String
		{
			var curidx:int = 0;
			while(curidx < m_rankVec.length)
			{
				if (m_rankVec[curidx].m_min <= rank && rank <= m_rankVec[curidx].m_max)
				{
					break;
				}
				++curidx;
			}
			
			if (curidx < m_rankVec.length)
			{
				return m_rankVec[curidx].m_text;
			}
			
			return "";
		}
	}
}