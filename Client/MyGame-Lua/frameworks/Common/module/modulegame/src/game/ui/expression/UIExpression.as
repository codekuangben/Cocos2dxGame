package game.ui.expression 
{
	import com.bit101.components.Label;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIChat;


	import flash.events.MouseEvent;
	import modulecommon.appcontrol.PanelDisposeEx;
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlList;
	import modulecommon.ui.UIFormID;
	import modulecommon.commonfuntion.MsgRoute;	

	/**
	 * ...
	 * @author 
	 */
	public class UIExpression extends Form 
	{
		private var m_list:ControlList;
		private var m_overPanel:PanelDisposeEx;	
		private var m_expressionName:Label;
		public function UIExpression() 
		{
			super();
			alignHorizontal = LEFT;
			alignVertial = BOTTOM;
			exitMode = EXITMODE_HIDE;
			this.marginLeft = 315;
			this.marginBottom = 212;	//代表y距离屏幕底端的最小距离
			this.height = 200;
			this.setSize(245,164);
		}
		override public function onReady():void 
		{
			super.onReady();
			this.setPanelImageSkin("commoncontrol/panel/expressbg.png");
			
			m_expressionName = new Label(this, 9, 142);
			m_overPanel = new PanelDisposeEx();
			m_overPanel.x = 1;
			m_overPanel.setPanelImageSkin("commoncontrol/panel/expressover.png");
			
			m_list = new ControlList(this,5,5);
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			dataParam["overPanel"] = m_overPanel;
			dataParam.ui = this;
		
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = ExpressCtrl;
			param.m_height = 26;
			param.m_width = 26;
			param.m_numColumn = 9;
			param.m_numRow = 5;
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			
			var ar:Array = new Array(45);
			var i:int;
			for (i = 0; i < 45; i++)
			{
				ar[i] = i + 1;
			}
			m_list.setDatas(ar);
			
			
		}
		override public function onShow():void 
		{
			super.onShow();
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, closeListener);
		}
		
		private function closeListener(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			if (target == null)
			{
				hide();
			}
			
			var ui:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIChat);
			if (ui && ui.contains(target))
			{
				return;				
			}
			if (this.contains(target))
			{
				return;				
			}
			hide();
		}
		override public function adjustPosWithAlign():void 
		{
			this.x = _marginLeft;
			var h:Number = this.height + 3;
			var hS:uint = m_gkcontext.m_context.m_config.m_curHeight;
			if (h < _marginBottom)
			{
				this.y = hS - _marginBottom;
			}
			else
			{
				this.y = hS - h;
			}
			
		}
		override public function dispose():void 
		{
			m_overPanel.disposeEx();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,closeListener);
			super.dispose();
		}
		override public function onHide():void 
		{
			super.onHide();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, closeListener);
			
			// 请求移除事件监听
			m_gkcontext.m_msgRoute.m_expseDisp.dispatchEvent(new Event(MsgRoute.EtExpseRemEvt));
		}
		
		public function setExpressionName(str:String):void
		{
			m_expressionName.text = str;
		}
		
	}

}