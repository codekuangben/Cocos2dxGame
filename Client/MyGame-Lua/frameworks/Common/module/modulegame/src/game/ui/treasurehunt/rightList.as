package game.ui.treasurehunt 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight_queue;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam_ForPageMode;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class rightList extends Component 
	{
		private var m_list:ControlListVHeight_queue;
		public function rightList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_list = new ControlListVHeight_queue(this);
			m_list.queueSize = 50;
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = prizeItem;
			param.m_width = 200;
			param.m_marginLeft = 10;
			param.m_marginRight =10;
			param.m_heightList = 240;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 0;
			param.m_bCreateScrollBar = true;
			m_list.setParam(param);
		}
		public function setdata(strlsit:Array):void
		{
			if (strlsit)
			{
				m_list.setDatas(strlsit);
			}
			m_list.scrollPos = m_list.maxScrollPos;
		}
		public function updata(strlist:Array):void
		{
			for (var i:int = 0; i < strlist.length;i++ )
			{
				m_list.push(strlist[i]);
			}
			m_list.scrollPos = m_list.maxScrollPos;
		}
		
	}

}