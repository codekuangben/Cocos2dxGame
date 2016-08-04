package game.ui.uibenefithall.subcom.peoplerank.pagestyle1 
{
	import com.bit101.components.Component;	
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.controlList.ControlListH;
	import flash.events.Event;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	
	/**
	 * ...
	 * @author 
	 */
	public class FixAwardPart extends Component 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks:Ranks_Style1;
		private var m_list:ControlListH;
		public function FixAwardPart(ranks:Ranks_Style1, data:DataBenefitHall,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
			m_ranks = ranks;
			
			m_list = new ControlListH(this, 15, 0);
			var param:ControlHAlignmentParam = new ControlHAlignmentParam();
			param.m_class = FixAwardItem;
			
			var dataParam:Object = new Object();
			dataParam["data"] = m_dataBenefitHall;
			dataParam["ranks"] = m_ranks;
			
			param.m_dataParam = dataParam;
			param.m_marginBottom = 30;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 30;
			param.m_intervalH = 59;
			param.m_height = 120;
			param.m_widthList = 107 * 6 + param.m_marginLeft + param.m_marginRight + param.m_intervalH * 5-2;
			
			m_list.setParam(param);		
			m_list.setDatas(m_ranks.m_fixRwards);
			
			this.listenAddedToStageEvent();
		}
		
		public function onLingqu():void
		{
			m_list.update();
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			m_list.update();
		}
		public function onNextDay():void
		{
			m_list.update();
		}
	}

}