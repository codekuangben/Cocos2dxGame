package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.controlList.ControlListH;
	import flash.events.Event;
	import game.ui.uibenefithall.DataBenefitHall;
	/**
	 * ...
	 * @author 
	 */
	public class QiriTopPart extends Component 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_QiriBottomPart:QiriBottomPart;
		private var m_list:ControlListH;
		public function QiriTopPart(data:DataBenefitHall, qiriBottomPart:QiriBottomPart, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_QiriBottomPart = qiriBottomPart;
			m_dataBenefitHall = data;
			
			
			m_list = new ControlListH(this, 38, 48);
			var param:ControlHAlignmentParam = new ControlHAlignmentParam();
			param.m_class = Qiri_DayItem;
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_dataBenefitHall.m_gkContext;			
			
			param.m_dataParam = dataParam;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 0;
			param.m_intervalH = 21;
			param.m_height = 120;
			param.m_widthList = 107 * 6 + param.m_marginLeft + param.m_marginRight + param.m_intervalH * 5-2;
			
			m_list.setParam(param);
			m_list.addEventListener(Event.SELECT, onItemSelected);
			
			var datas:Array = new Array();
			var i:int;
			var idSelected:int=0;
			for (i = 1; i <= 7; i++)
			{
				datas.push(i);
				
				if (idSelected == 0)
				{
					if (m_dataBenefitHall.m_gkContext.m_qiridengluMgr.isLingqu(i) == false)
					{
						idSelected = i;
					}
				}
			}
			if (idSelected == 0)
			{
				idSelected = 7;
			}
			m_list.setDatas(datas);		
			m_list.setSeleced(idSelected - 1);
		}
		
		public function updateDay(day:int):void
		{
			var item:Qiri_DayItem = m_list.getCtrl(day) as Qiri_DayItem;
			if (item)
			{
				item.update();
			}
		}
		public function onItemSelected(event:Event):void
		{
			var item:Qiri_DayItem = m_list.getControlSelected() as Qiri_DayItem;
			if (item)
			{
				m_QiriBottomPart.showPage(item.id);
			}
		}
	}

}