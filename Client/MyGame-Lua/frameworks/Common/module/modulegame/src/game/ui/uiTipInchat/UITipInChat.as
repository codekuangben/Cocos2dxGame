package game.ui.uiTipInchat 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	//import modulecommon.scene.prop.object.T_Object;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUITipInChat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UITipInChat extends Form implements IUITipInChat
	{
		public static const TOPH:int = 150;
		private var m_tipEquip:TipEquipInChat;
		private var m_tipNotEquip:TipNotEquipInChat;
		public function UITipInChat() 
		{
			super();
			alignHorizontal = Component.LEFT;
			alignVertial = Component.BOTTOM;
			exitMode = EXITMODE_HIDE;
			this.marginLeft = 315;
			this.marginBottom = 212;	//代表y距离屏幕底端的最小距离
			this.height = 200;
		}
		override public function onReady():void 
		{
			super.onReady();
			
			this.setSkinGrid9Image9("commoncontrol/grid9/grid9Tip.swf");
		}
		
		public function showObjectTip(obj:ZObject):void
		{			
			if (obj.isEquip)
			{
				showEquipTip(obj);
			}
			else
			{
				showNotEquipTip(obj);
			}
		}
		private function showEquipTip(obj:ZObject):void
		{
			if (m_tipEquip == null)
			{
				m_tipEquip = new TipEquipInChat(m_gkcontext, this);
			}
			
			m_tipEquip.showTip(obj);
			m_tipEquip.visible = true;
			adjustTipsPos(m_tipEquip);
			show();
		}
		
		private function adjustTipsPos(tip:Component):void
		{
			this.setSize(tip.width,tip.height);				
			this.adjustPosWithAlign();
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
		private function showNotEquipTip(obj:ZObject):void
		{
			if (m_tipNotEquip == null)
			{
				m_tipNotEquip = new TipNotEquipInChat(m_gkcontext, this);
			}
			
			m_tipNotEquip.showTip(obj);
			m_tipNotEquip.visible = true;
			adjustTipsPos(m_tipNotEquip);			
			show();
		}
		override public function onHide():void 
		{
			super.onHide();
			m_gkcontext.m_context.m_mainStage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			hideAll();
		}
		
		override public function onShow():void 
		{
			super.onShow();
			m_gkcontext.m_context.m_mainStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			var targetDisplay:DisplayObject = e.target as DisplayObject;
			if (targetDisplay)
			{
			if (this != targetDisplay && this.contains(targetDisplay)==false)
			{
				this.exit();
			}
			}
		}
		
		private function hideAll():void
		{
			if (m_tipEquip)
			{
				m_tipEquip.onHide();
				m_tipEquip.visible = false;
			}
			if (m_tipNotEquip)
			{				
				m_tipNotEquip.visible = false;
			}
		}
		
	}

}