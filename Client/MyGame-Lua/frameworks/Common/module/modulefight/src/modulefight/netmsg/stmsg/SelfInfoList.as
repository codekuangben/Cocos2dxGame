package modulefight.netmsg.stmsg 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class SelfInfoList 
	{
		private var m_list:Vector.<SelfInfoGrid>;
		private var m_dic:Dictionary;
		public function SelfInfoList() 
		{
			m_list = new Vector.<SelfInfoGrid>();
			m_dic = new Dictionary();
		}
		
		private function createSelfInfoGrid(gridNO:int):SelfInfoGrid
		{
			var infoGrid:SelfInfoGrid = new SelfInfoGrid();
			infoGrid.gridNO = gridNO;
			m_dic[gridNO] = infoGrid;
			m_list.push(infoGrid);
			return infoGrid;
		}	
		
		public function addDef(def:DefList):void
		{
			var gridNO:int = BattleArray.s_gridNO(def.pos);
			var infoGrid:SelfInfoGrid = m_dic[gridNO];
			if (infoGrid == null)
			{
				infoGrid = createSelfInfoGrid(gridNO);
			}
			infoGrid.addDef(def);
		}
		public function init(gk:GkContext):void
		{
			var info:SelfInfoGrid;
			for each(info in m_list)
			{
				if (info.buffer)
				{
					info.buffer.m_gkContext = gk;
				}
			}
		}
		public function getInfoGridByPos(pos:int):SelfInfoGrid
		{
			return m_dic[pos];
		}
		public function get isEmpty():Boolean
		{
			return m_list.length == 0;
		}
		public function get list():Vector.<SelfInfoGrid>
		{
			return m_list;
		}
	}

}