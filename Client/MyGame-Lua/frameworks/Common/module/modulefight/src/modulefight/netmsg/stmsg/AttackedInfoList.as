package modulefight.netmsg.stmsg 
{	
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class AttackedInfoList 
	{
		private var m_attackedList:Vector.<AttackedInfoGrid>;
		private var m_dic:Dictionary;		
		public function AttackedInfoList() 
		{
			m_attackedList = new Vector.<AttackedInfoGrid>();
			m_dic = new Dictionary();
		}
		private function createAttackedInfoGrid(gridNO:int):AttackedInfoGrid
		{
			var infoGrid:AttackedInfoGrid = new AttackedInfoGrid();
			infoGrid.gridNO = gridNO;
			m_dic[gridNO] = infoGrid;
			m_attackedList.push(infoGrid);
			return infoGrid;
		}
		public function addDef(def:DefList):void
		{
			var gridNO:int = BattleArray.s_gridNO(def.pos);
			var infoGrid:AttackedInfoGrid = m_dic[gridNO];
			if (infoGrid == null)
			{
				infoGrid = createAttackedInfoGrid(gridNO);
			}
			infoGrid.addDef(def);
		}
		public function getAttackActTargetPos(aPos:int):uint
		{
			var min:uint = uint.MAX_VALUE;
			var info:AttackedInfoGrid;
			for each(info in m_attackedList)
			{
				if ((aPos - info.gridNO) % 3 == 0) // 如果在同一行上，找到立即返回就行了
				{
					return info.gridNO;
				}
				else if (min > info.gridNO) // 如果在最上面，就是一列的最小值
				{
					min = info.gridNO; // 记录最小值
				}
			}
			return min;
		}		
		public function init(gk:GkContext):void
		{
			var info:AttackedInfoGrid;
			for each(info in m_attackedList)
			{
				if (info.buffer)
				{
					info.buffer.m_gkContext = gk;
				}
			}
		}
		// 是否产生暴击
		public function get isBaoji():Boolean
		{
			var infoGrid:AttackedInfoGrid;
			for each(infoGrid in m_attackedList)
			{
				if (infoGrid.isBaoji)
				{
					return true;
				}
			}
			return false;
		}
		public function getAttackedInfoGridByPos(pos:int):AttackedInfoGrid
		{
			return m_dic[pos];
		}
		public function isAttacked(pos:int):Boolean
		{
			return m_dic[pos]!=undefined;
		}
		public function get isEmpty():Boolean
		{
			return m_attackedList.length == 0;
		}
		public function get list():Vector.<AttackedInfoGrid>
		{
			return m_attackedList;
		}
	}

}