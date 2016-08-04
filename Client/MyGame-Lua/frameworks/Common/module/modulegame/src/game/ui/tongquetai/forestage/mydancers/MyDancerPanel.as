package game.ui.tongquetai.forestage.mydancers 
{
	import com.bit101.components.PanelShowAndHide;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.tongquetai.forestage.DancerModelBase;
	import game.ui.tongquetai.forestage.UITongQueWuHui;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import flash.utils.Dictionary;
	import game.ui.tongquetai.forestage.DancerPanelBase;
	import modulecommon.GkContext;
	import modulecommon.scene.tongquetai.DancingWuNv;

	/**
	 * ...
	 * @author 
	 */
	public class MyDancerPanel extends DancerPanelBase 
	{
		private var toTongQueTai:PushButton;
		public function MyDancerPanel(gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, MyDancerModel, parent, xpos, ypos);
		}
		
		public function init():void
		{
			toTongQueTai = new PushButton(this,720,228,goTongQueTai);
			toTongQueTai.setSkinButton1Image("commoncontrol/panel/tongquetai/enter.png");
			var dancerModel:MyDancerModel;
			for each(dancerModel in m_dancers)
			{
				dancerModel.init();
			}	
			exchangeName();
		}
		public function addDancing(dancer:DancingWuNv):void
		{
			m_dancers[dancer.m_dancingMsg.pos].addDancing(dancer);
		}
		public function removeDancing(dancer:DancingWuNv):void
		{
			m_dancers[dancer.m_dancingMsg.pos].removeDancing();
		}
		
		public function becomeOver(dancer:DancingWuNv):void
		{
			(m_dancers[dancer.m_dancingMsg.pos] as MyDancerModel).becomeOver();
		}		
		override protected function exchangeName(name:String = null):void 
		{
			m_nameLabel.text = "我" + "　　　　　";
			m_namePanel.x=  m_nameLabel.text.length*15 / 2-86;
			super.exchangeName();
		}
		public function updataTime(pos:int):void
		{
			if (m_dancers[pos])
			{
				(m_dancers[pos] as MyDancerModel).updataTimeLabel();
			}
		}
		public function showChat(pos:int, str:String):void
		{
			if (m_dancers[pos])
			{
				(m_dancers[pos] as MyDancerModel).showChat(str);
			}
		}
		override public function show():void 
		{
			super.show();
			var dancerModel:MyDancerModel;
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
			var dancerModel:MyDancerModel;
			for each(dancerModel in m_dancers)
			{
				if (dancerModel.m_timeLabel.parent)
				{
					m_parent.parent.removeChild(dancerModel.m_timeLabel);				
				}
			}
			
			super.hide();
		}
		override public function onShow():void 
		{
			super.onShow();
			var dancerModel:MyDancerModel;
			for each(dancerModel in m_dancers)
			{
				dancerModel.atachTickMgr();
			}
		}
		override public function onHide():void 
		{
			super.onHide();
			var dancerModel:MyDancerModel;
			for each(dancerModel in m_dancers)
			{
				dancerModel.unAttachTickMgr();
			}
			
		}
		private function goTongQueTai(e:MouseEvent):void
		{
			var formTongQueTai:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITongQueTai);
			formTongQueTai.show();	
		}
	}

}