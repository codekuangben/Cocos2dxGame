package game.ui.treasurehunt 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight_queue;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.treasurehunt.TreasureHuntMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class leftList extends Component 
	{
		private var m_list:ControlListVHeight_queue;
		private var m_listv:ControlListVHeight_queue;
		public function leftList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_list = new ControlListVHeight_queue(this);
			m_listv = new ControlListVHeight_queue(this);
			m_list.queueSize = TreasureHuntMgr.LEFTLIST_MAXLINE;
			m_listv.queueSize = 3;
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = prizeItem;
			param.m_width = 200;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_heightList = 240;
			m_list.setParam(param);
			m_listv.setParam(param);
		}
		public function setdata(strlsit:Array,strlistv:Array):void
		{
			if (strlsit)
			{
				m_list.setDatas(strlsit);
			}
			if (strlistv)
			{
				m_listv.setDatas(strlistv);
			}
			var num:int = TreasureHuntMgr.LEFTLIST_MAXLINE-m_listv.controlList.length;
			m_list.y = m_listv.controlList.length * 23;
			m_list.queueSize = num;
		}
		public function updata(strlist:Array,strlistv:Array):void
		{
			for (var i:int = 0; i < strlist.length;i++ )
			{
				m_list.push(strlist[i]);
			}
			for (i = 0; i < strlistv.length;i++ )
			{
				m_listv.push(strlistv[i]);
			}
			var num:int = TreasureHuntMgr.LEFTLIST_MAXLINE-m_listv.controlList.length;
			while (m_list.controlList.length > num)
			{
				m_list.deleteDataWithoutAni(0);
			}
			m_list.y = m_listv.controlList.length * 23;
			m_list.queueSize = num;
		}
		
	}

}