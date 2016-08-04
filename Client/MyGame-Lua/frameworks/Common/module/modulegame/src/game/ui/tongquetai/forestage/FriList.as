package game.ui.tongquetai.forestage 
{
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelPage;
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import game.ui.tongquetai.msg.FriendWuNvState;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import game.ui.tongquetai.msg.retOpenWuNvUIUserCmd;
	import modulecommon.scene.prop.relation.RelFriend;
	import flash.events.MouseEvent;
	import com.bit101.components.PushButton;
	import com.bit101.components.Label;
	import com.bit101.components.Component;
	import com.dgrigg.image.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FriList extends PanelPage 
	{
		public var m_gkContext:GkContext;
		public var m_list:ControlList;
		private var m_pageturn:PageTurn;
		public var m_curhaoyou:int;
		private var m_selectbg:PanelDisposeEx;	
		private var m_overbg:PanelDisposeEx;	
		public function FriList(gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;	
			this.setPanelImageSkin("commoncontrol/panel/tongquetai/frilistbg.png");
			m_selectbg = new PanelDisposeEx();
			m_selectbg.setPanelImageSkin("commoncontrol/panel/tongquetai/frilistselectbg.png");
			m_selectbg.x = -1;
			m_overbg = new PanelDisposeEx();
			m_overbg.setPanelImageSkin("commoncontrol/panel/tongquetai/frilistselectbg.png");
			m_overbg.x = -1;
			m_overbg.alpha = 0.5;
			m_list = new ControlList(this, 12, 42);
			m_list.bInitSubCtrlOnShow = true;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["parent"] = this;
			dataParam["selectbg"] = m_selectbg;
			dataParam["overbg"] = m_overbg;
			
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = FriItem;
			param.m_height = 31;
			param.m_width = 204;
			param.m_numColumn = 1;
			param.m_numRow = 7;
			param.m_intervalV = 2;
			param.m_intervalH = 18;
			/*param.m_marginLeft = 10;
			param.m_marginRight = 10;*/
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			
			
			m_pageturn = new PageTurn(this, 48, 282);
			m_pageturn.setBtnPos(0, 0, 77, 0, 0, 18);
			m_pageturn.setParam(onPageTurn);
			m_pageturn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_pageturn.pageCount = 0;
			m_pageturn.curPage = 0;
			
		}
		
		public function process_retOpenWuNvUIUserCmd(msg:ByteArray):void
		{
			var rev:retOpenWuNvUIUserCmd = new retOpenWuNvUIUserCmd();
			rev.deserialize(msg);
			m_list.setDatas(rev.m_fdata);
			m_pageturn.pageCount = m_list.pageCount;
		}
	
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_list.toPreLine();
			}
			else
			{
				m_list.toNextLine();
			}
		}
		public function updataState(ID:int,data:FriendWuNvState):void
		{
			var item:FriItem = m_list.findCtrl(FriItem.s_compare,ID) as FriItem;
			if (item)
			{
				item.updataState(data);
			}
		}
		override public function dispose():void 
		{
			m_selectbg.disposeEx();
			m_overbg.disposeEx();
			super.dispose();
		}
	}

}