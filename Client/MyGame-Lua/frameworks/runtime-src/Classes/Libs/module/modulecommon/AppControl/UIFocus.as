package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.pblabs.engine.core.IResizeObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.commonfuntion.LocalDataMgr;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import com.pblabs.engine.entity.EntityCValue;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIFocus extends Form implements IResizeObject
	{
		private var m_focusCom:Component;
		private var m_focusComParent:DisplayObjectContainer;
		private var m_focusComX:Number;
		private var m_focusComY:Number;
		public function UIFocus() 
		{
			this.id = UIFormID.UIFocus;
		}
		public function focusOn(com:Component):void
		{
			m_focusCom = com;
			var focusForm:Form = UtilTools.getDisplayObjectByChild(Form, m_focusCom) as Form;		
			
			
			m_focusComParent = m_focusCom.parent;
			m_focusComX = m_focusCom.x;
			m_focusComY = m_focusCom.y;
			
			var newPos:Point = m_focusCom.posInRelativeParent(focusForm);
			focusForm.addChild(this);
			m_focusCom.x = newPos.x;
			m_focusCom.y = newPos.y;
			if (m_focusCom.parent == focusForm)
			{
				focusForm.removeChild(m_focusCom);
			}
			focusForm.addChild(m_focusCom);
			
			if (focusForm.parent==null)
			{
				m_gkcontext.addLog("UIFocus::focusOn_focusForm.parent==null；form is"+m_gkcontext.m_UIMgr.getFormName(focusForm.id));
			}
			
			focusForm.parent.setChildIndex(focusForm, focusForm.parent.numChildren-1);
			
			drawBack();
			m_gkcontext.m_localMgr.setShieldKeyEvent(LocalDataMgr.ShieldKeyEvent_UIFocus);
			m_gkcontext.m_context.m_processManager.addResizeObject(this, EntityCValue.ResizeUIAfter);
		}
		public function focusOut():void
		{
			if (m_focusCom == null)
			{
				return;
			}
			m_focusCom.x = m_focusComX;
			m_focusCom.y = m_focusComY;
			if (!m_focusComParent.contains(m_focusCom))
			{
				m_focusComParent.addChild(m_focusCom);
			}
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			m_focusCom = null;
			m_focusComParent = null;
			m_focusComX = 0;
			m_focusComY = 0;
			m_gkcontext.m_localMgr.clearShieldKeyEvent(LocalDataMgr.ShieldKeyEvent_UIFocus);
			m_gkcontext.m_context.m_processManager.removeResizeObject(this);
		}

		private function drawBack():void
		{
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			var pos:Point = this.posInRelativeParent(m_gkcontext.m_UIMgr);
			if (pos == null)
			{
				return;
			}
			this.graphics.clear();
			this.graphics.beginFill(0, 0.5);			
			
			this.graphics.drawRect( -pos.x, -pos.y, widthStage, heightStage);
			this.graphics.endFill();
		}
		
		public function onResize(viewWidth:int, viewHeight:int):void
		{
			if (this.parent == null)
			{
				return;
			}
			drawBack();
		}	
		
		override protected function onFormMouseGoDown(event:MouseEvent):void
		{
			
		}
		
		public function get focusCom():Component
		{
			return m_focusCom;
		}
	}

}