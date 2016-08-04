package game.ui.uiTeamFBSys.iteamzx.event
{
	import modulecommon.scene.prop.table.TNpcBattleItem;

	/**
	 * @brief 拖放数据
	 * */
	public class TeamDragData
	{
		public var m_isMain:Boolean;			// 是否是主角
		public var m_npcBase:TNpcBattleItem;	// 如果不是主角，存放武将在 npc 表中的信息
		
		public function isMain():Boolean
		{
			return m_isMain;
		}
	}
}