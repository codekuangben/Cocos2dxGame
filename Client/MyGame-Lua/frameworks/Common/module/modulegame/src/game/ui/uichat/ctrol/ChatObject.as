package game.ui.uichat.ctrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;	
	import com.riaidea.text.GraphicBase;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.T_Object;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITipInChat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatObject extends GraphicBase 
	{
		private var m_gkContext:GkContext;
		private var m_label:Label;
		private var m_zObject:ZObject;
		private var m_bForInput:Boolean;
		public function ChatObject(gk:GkContext, bForInput:Boolean) 
		{
			m_bForInput = bForInput;
			m_gkContext = gk;					
			m_label = new Label(this, 0,-2);
			
			
			if (m_bForInput)
			{
				this.mouseEnabled = false;
				m_label.setBold(true);
			}
			else
			{
				m_label.underline = true;
				m_label.miaobian = false;
				buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		public function setObject(obj:T_Object):void
		{
			m_zObject = new ZObject();
			m_zObject.setObject(obj);
			var str:String;
			if (m_bForInput)
			{
				str = "[" + m_zObject.name + "]";
			}
			else
			{
				str = m_zObject.name;
			}
			m_label.text = str;			
			m_label.setFontColor(m_zObject.colorValue);
			m_label.flush();
		}
		
		override public function get width():Number 
		{
			return m_label.width;
		}
		
		override public function get height():Number 
		{
			return 14;
		}		
		
		override public function get identification():String 
		{
			return ChatRichTextField.s_formatZObject(m_zObject);
		}
		
		private function onClick(e:MouseEvent):void
		{
			var ui:IUITipInChat = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITipInChat) as IUITipInChat;
			ui.showObjectTip(m_zObject);
		}
	}

}