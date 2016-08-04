package game.ui.tongquetai.backstage 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign_Param;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import modulecommon.GkContext;
	
	import modulecommon.scene.tongquetai.DancerBase;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NormalPage extends Component 
	{
		public var m_gkContext:GkContext;
		public var m_list:ControlList_VerticalAlign;
		private var m_ui:UITongQueTai;
		public function NormalPage(ui:UITongQueTai, gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;	
			m_ui = ui;
			
			m_list = new ControlList_VerticalAlign(this);
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;			
			var param:ControlList_VerticalAlign_Param = new ControlList_VerticalAlign_Param();
			param.m_class = DancerIconNormal;
			param.m_height = 98;
			param.m_width = 91;
			
			param.m_numRow = 3;
			param.m_numColum = 2;
			param.m_intervalV = 42;
			param.m_intervalH = 20;		
			param.m_marginTop = 31;
			param.m_marginBottom = 10;
			param.m_marginLeft = 5;
			param.m_dataParam = dataParam;
			m_list.setParam(param);
			m_list.addEventListener(Event.SELECT, onSelect);
		}
		
		public function init():void
		{
			var list:Array = m_gkContext.m_tongquetaiMgr.getNormalList();			
			m_list.setDatas(list);
		}		
		
		public function upDataAll():void
		{
			m_list.update();
		}
		public function addNormalDancer(id:int):void
		{
			var icon:DancerIconNormal = m_list.findCtrl(DancerIconBase.s_compare,id) as DancerIconNormal;
			if (icon)
			{
				icon.addDancer();
			}
		}
		
		public function onSelect(e:Event):void
		{
			var dancer:DancerBase = m_list.getDataSelected() as DancerBase;
			if (dancer)
			{
				m_ui.updataSelectModel(dancer);
			}
		}
		public function selectNO():void
		{
			m_list.setSeleced( -1);
		}
		
		public function selectFirstDancer():void
		{
			m_list.setSeleced(0);
		}
		
	}

}