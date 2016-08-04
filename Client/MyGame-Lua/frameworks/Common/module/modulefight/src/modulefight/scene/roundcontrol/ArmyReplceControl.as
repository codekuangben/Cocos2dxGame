package modulefight.scene.roundcontrol
{
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.netmsg.stmsg.stArmy;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ArmyReplceControl
	{
		public static const ARMYREPLACE_None:int = 0;
		public static const ARMYREPLACE_WaitAni:int = 1; //等待正在播放的所有战斗结束，结束之后，要替换的部队才能跑步进入。
		public static const ARMYREPLACE_SetArmyAndBeginWalk:int = 2; //设置格子上的新部队，准备跑入
		public static const ARMYREPLACE_WaitForAllGridWalk:int = 3; //等待所有部队进入
		
		protected var m_fightDB:FightDB;
		protected var m_roundControl:RoundControl;
		protected var m_listEnterGrids:Vector.<FightGrid>; //要跑步进场的格子放入此列表中，该格子到达目的位置后，从列表中删除该格子
		
		private var m_leftArmyIndex:int = 0;
		private var m_rightArmyIndex:int = 0;
		
		private var m_armyReplaceState:int = 0;
		
		public function ArmyReplceControl(fightDB:FightDB, roundControl:RoundControl)
		{
			m_fightDB = fightDB;
			m_roundControl = roundControl;
			m_listEnterGrids = new Vector.<FightGrid>();
		}
		
		public function processArmyReplace(leftArmyIndex:int, rightArmyIndex:int):void
		{
			m_leftArmyIndex = leftArmyIndex;
			m_rightArmyIndex = rightArmyIndex;
			if (m_roundControl.battleCtrlListLen == 0)
			{
				processArmyReplaceEx();
			}
			else
			{
				m_armyReplaceState = ARMYREPLACE_WaitAni;
			}
		}
		
		public function processArmyReplaceEx():void
		{
			m_armyReplaceState = ARMYREPLACE_SetArmyAndBeginWalk;
			// bug: 可能有多次换部队，换部队后就有可能再次释放锦囊，但是一次战斗不换部队，只能释放一个锦囊
			// 释放锦囊持续特效,这个特效是一致持续的，因此需要释放掉
			m_fightDB.m_effectMgr.disposeAllSceneJinNangEff();
						
			var army:stArmy;
			if (m_leftArmyIndex != 0)
			{
				army = m_fightDB.m_fightProcess.aArmylist[m_leftArmyIndex];
				this.enterIn(EntityCValue.RKLeft, army);
				m_fightDB.m_aArmyIndex = m_leftArmyIndex;			
				m_fightDB.m_UIBattleHead.setCurArmy(EntityCValue.RKLeft, army);
				// 更新兵团后续部队的数量
				m_fightDB.m_UIBattleHead.setLeftArmyCnt(EntityCValue.RKLeft, m_fightDB.m_fightProcess.aArmylist.length - 1 - m_leftArmyIndex);
			}
			
			if (m_rightArmyIndex != 0)
			{
				army = m_fightDB.m_fightProcess.bArmylist[m_rightArmyIndex]
				this.enterIn(EntityCValue.RKRight, army);
				m_fightDB.m_bArmyIndex = m_rightArmyIndex;
				m_fightDB.m_UIBattleHead.setCurArmy(EntityCValue.RKRight, army);
				// 更新兵团后续部队的数量
				m_fightDB.m_UIBattleHead.setLeftArmyCnt(EntityCValue.RKRight, m_fightDB.m_fightProcess.bArmylist.length - 1 - m_rightArmyIndex);
			}
			m_armyReplaceState = ARMYREPLACE_WaitForAllGridWalk;
			checkAllEntered();
		}
		
		//增援部队上来时，跑步入场
		protected function enterIn(side:int, army:stArmy):void
		{
			var i:int;
			var count:int;
			var gridsWithBudui:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[side];
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[side];
			count = army.matrixList.length;
			var matrix:stMatrixInfo;
			var grid:FightGrid;
			for each (grid in grids)
			{
				grid.clearBudui();
			}
			
			for (i = 0; i < count; i++)
			{
				matrix = army.matrixList[i];
				grid = grids[matrix.gridNo];
				grids[matrix.gridNo].setMatrixInfo(matrix);
				gridsWithBudui.push(grid);
				m_listEnterGrids.push(grid);
				if (i == 0)
				{
					grids[matrix.gridNo].enter(onEntered);
				}
				else
				{
					grids[matrix.gridNo].enter(onEntered);
				}
			}
			m_fightDB.m_UIBattleHead.beginAniArmyEnter();
		}
		
		protected function onEntered(grid:FightGrid):void
		{
			var i:int = m_listEnterGrids.indexOf(grid);
			if (i != -1)
			{
				m_listEnterGrids.splice(i, 1);
			}
			checkAllEntered();
		}
		
		//检测所有部队是否已经跑到指定位置了。如果已经到达目的位置，则进入下一阶段
		protected function checkAllEntered():void
		{
			if (m_armyReplaceState == ARMYREPLACE_WaitForAllGridWalk)
			{
				if (m_listEnterGrids.length == 0)
				{
					m_roundControl.onArmyReplaced();
					m_armyReplaceState = ARMYREPLACE_None;
				}
			}
		}
		
		public function get armyReplaceState():int
		{
			return m_armyReplaceState;
		}
		
		public function clear():void
		{
			m_listEnterGrids.length = 0;
			m_armyReplaceState = ARMYREPLACE_None;
		}
	}

}