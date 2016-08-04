package game.ui.expression 
{
	import com.bit101.components.Ani;
	import com.bit101.components.controlList.CtrolComponent;
	import flash.events.MouseEvent;
	import modulecommon.commonfuntion.customevt.EvtCstm;
	import modulecommon.GkContext;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TExpressionItem;
	import modulecommon.ui.UIFormID;
	import modulecommon.commonfuntion.MsgRoute;
	
	/**
	 * ...
	 * @author 
	 */
	public class ExpressCtrl extends CtrolComponent 
	{
		private var m_id:int;
		private var m_ani:Ani;
		public var m_gkContext:GkContext;
		private var m_overPanel:PanelDisposeEx;
		private var m_base:TExpressionItem;
		private var m_ui:UIExpression;
	
		public function ExpressCtrl(param:Object=null)
		{
			super(param);
			m_gkContext = param.gk as GkContext;
			m_overPanel = param.overPanel as PanelDisposeEx;		
			m_ui = param.ui as UIExpression;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		override public function setData(data:Object):void 
		{
			super.setData(data);
			m_id = data as int;
			
			m_base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_EXPRESSION, m_id) as TExpressionItem;
			
			m_ani = new Ani(m_gkContext.m_context, this, 13,13);
			m_ani.centerPlay = true;
			m_ani.duration = 2;
			m_ani.repeatCount = 0;
			m_ani.setImageAni("expression/" + m_base.m_expressID + ".swf");
			m_ani.setAutoStopWhenHide();
			m_ani.begin();
			m_ani.mouseEnabled = false;
			m_ani.mouseChildren = false;
		}
		override public function onOver():void
		{
			super.onOver();
			m_overPanel.show(this);
			m_ui.setExpressionName(m_base.m_name);
		}
		override public function onOut():void
		{
			super.onOut();
			m_overPanel.hide(this);
			m_ui.setExpressionName("");
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (!m_gkContext.m_msgRoute.m_expseDisp.hasEventListener(MsgRoute.EtExpseClk))
			{
				if (m_gkContext.m_uiChat)
				{
					m_gkContext.m_uiChat.addExpression(m_id);
				}
			}
			else	// 别的界面在监听这个事件，分发给别的界面
			{
				var evt:EvtCstm = new EvtCstm(MsgRoute.EtExpseClk);
				evt.m_data = m_id;
				m_gkContext.m_msgRoute.m_expseDisp.dispatchEvent(evt);
			}
			m_gkContext.m_UIMgr.exitForm(UIFormID.UIExpression);
		}
		
	}

}