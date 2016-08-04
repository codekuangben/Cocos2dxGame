package game.ui.tongquetai.forestage.friendDancers 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import game.ui.tongquetai.forestage.DancerPanelBase;
	import game.ui.tongquetai.forestage.UITongQueWuHui;
	import game.ui.tongquetai.msg.FriendDancingWuNv;
	import game.ui.tongquetai.msg.FriendWuNvState;
	import game.ui.tongquetai.msg.stRetFriendWuNvDancingUserCmd;
	import modulecommon.GkContext;
	import modulecommon.scene.tongquetai.DancerBase;
	
	/**
	 * ...
	 * @author 
	 */
	public class FriendDancerPanel extends DancerPanelBase 
	{		
		private var m_ui:UITongQueWuHui;
		private var retoMyWuHui:PushButton;
		public var m_curHaoYouId:int;
		public function FriendDancerPanel(ui:UITongQueWuHui, gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, FriendDancerModel, parent, xpos, ypos);
			retoMyWuHui = new PushButton(this, 706,232,backToMyself);
			retoMyWuHui.setSkinButton1Image("commoncontrol/panel/tongquetai/backhome.png");
			m_ui = ui;
		}
		
		public function process_stRetFriendWuNvDancingUserCmd(byte:ByteArray):void
		{
			m_ui.switchToFriendPanel();
			var rev:stRetFriendWuNvDancingUserCmd = new stRetFriendWuNvDancingUserCmd();
			rev.deserialize(byte);
			m_curHaoYouId = rev.m_id;
			var str:String = m_gkContext.m_beingProp.m_rela.m_relFnd.getFriendNameByCharID(rev.m_id);
			exchangeName(str);
			var data:FriendDancingWuNv;
			var dancerModel:FriendDancerModel;
			for each(dancerModel in m_dancers)
			{
				data = rev.m_data[dancerModel.pos];
				if (data)
				{
					data.dancerBase = m_gkContext.m_tongquetaiMgr.m_dicIdToDancer[data.id] as DancerBase;
					dancerModel.addDancing(data);
				}
				else
				{
					dancerModel.removeDancing();
				}
				
			}
		}
		override protected function exchangeName(name:String = null):void 
		{
			m_nameLabel.text = name + "　　　　　";
			m_namePanel.x =  m_nameLabel.text.length*15 / 2-86;
			super.exchangeName();
		}
		private function backToMyself(e:MouseEvent):void
		{
			m_ui.swichToMyPanel();
		}	
		public function setFriState():void
		{
			var wunvState:uint = 0;
			var dancerModel:FriendDancerModel;
			var steal:Boolean = false;
			var event:Boolean = false;
			for each(dancerModel in m_dancers)
			{
				if (dancerModel)
				{
					steal ||= dancerModel.stealState();
					event ||= dancerModel.eventState();
				}
			}
			var friendWuNv:FriendWuNvState = new FriendWuNvState();
			friendWuNv.id = m_curHaoYouId;
			if (steal)
			{
				friendWuNv.state = 1;
			}
			else if (event)
			{
				friendWuNv.state = 2;
			}
			else
			{
				friendWuNv.state = 0;
			}
			m_ui.updataFriState(friendWuNv);
		}
		override public function show():void 
		{
			super.show();
			var dancerModel:FriendDancerModel;
			for each(dancerModel in m_dancers)
			{
				if (dancerModel.m_timeLabel.parent != m_parent.parent)
				{
					m_parent.parent.addChild(dancerModel.m_timeLabel);
				}
			}
		}
		override public function hide():void 
		{
			var dancerModel:FriendDancerModel;
			for each(dancerModel in m_dancers)
			{
				if (dancerModel.m_timeLabel.parent)
				{
					m_parent.parent.removeChild(dancerModel.m_timeLabel);				
				}
			}
			
			super.hide();
		}
		override public function onHide():void 
		{
			super.onHide();
			var dancerModel:FriendDancerModel;
			for each(dancerModel in m_dancers)
			{
				dancerModel.removeDancing();				
			}
		}
		
	}

}