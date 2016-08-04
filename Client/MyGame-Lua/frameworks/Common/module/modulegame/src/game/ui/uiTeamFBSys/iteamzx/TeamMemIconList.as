package game.ui.uiTeamFBSys.iteamzx
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import common.event.DragAndDropEvent;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.msg.retChangeUserPosUserCmd;
	import game.ui.uiTeamFBSys.msg.retOpenAssginHeroUiCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	
	/**
	 * ...
	 */
	public class TeamMemIconList extends Component
	{
		private static const HEIGHT:int = 360;
		
		protected var m_TFBSysData:UITFBSysData;
		private var m_teamMemLst:Vector.<TeamMemIconItem>;
		
		public function TeamMemIconList(data:UITFBSysData, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			m_TFBSysData = data;
			super(parent, xpos, ypos);
			
			m_teamMemLst = new Vector.<TeamMemIconItem>(3, true);
			var idx:int = 0;
			while (idx < 3)
			{
				m_teamMemLst[idx] = new TeamMemIconItem(m_TFBSysData, this, 0, 100 * idx);
				m_teamMemLst[idx].m_iTag = idx;
				m_teamMemLst[idx].addEventListener(TeamDragEvent.DRAG_TEAMMEM, dragTeamMem);
				m_teamMemLst[idx].addEventListener(DragAndDropEvent.DRAG_READYDROP, readyTeamMem);
				++idx;
			}
		}
		
		override public function dispose():void
		{
			var idx:int = 0;
			while (idx < 3)
			{
				m_teamMemLst[idx].removeEventListener(TeamDragEvent.DRAG_TEAMMEM, dragTeamMem);
				m_teamMemLst[idx].removeEventListener(DragAndDropEvent.DRAG_READYDROP, readyTeamMem);
				++idx;
			}
			
			super.dispose();
		}
		
		// 显示展位空间
		protected function dragTeamMem(event:TeamDragEvent):void
		{
			var idx:int = 0;
			while (idx < 3)
			{
				m_teamMemLst[idx].toggleDnd(true);
				++idx;
			}
		}
		
		// 拖动结束
		protected function readyTeamMem(event:DragAndDropEvent):void
		{
			var idx:int = 0;
			while (idx < 3)
			{
				m_teamMemLst[idx].toggleDnd(false);
				++idx;
			}
		}
		
		public function psretChangeUserPosUserCmd(msg:retChangeUserPosUserCmd):void
		{				
			// 更新 数据
			m_teamMemLst[msg.src].updateUI();
			m_teamMemLst[msg.pos].updateUI();
		}
		
		public function psretOpenAssginHeroUiCopyUserCmd(msg:retOpenAssginHeroUiCopyUserCmd):void
		{
			var item:UserDispatch;
			var idx:int = 0;
			while(idx < 3)
			{
				m_teamMemLst[idx].updateUI();
				++idx;
			}
		}
	}
}