package game.ui.uibackpack.sale 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import modulecommon.scene.prop.object.ZObject;
	import com.bit101.components.Panel;
	/**
	 * ...
	 * @author ...
	 */
	public class SaleItem extends CtrolVHeightComponent 
	{
		private var m_SalePart:SalePart;
		private var m_obj:ZObject;
		
		private var m_nameLabel:Label;
		private var m_input:InputText;
		private var m_concelBtn:PushButton;
		private var m_underLinePanel:Panel;
		public function SaleItem(param:Object)
		{
			super();
			m_SalePart  = param["SalePart"] as SalePart;
			this.height = 26;
			
			m_nameLabel = new Label(this, 0, 7);
			m_input = new InputText(this, 100, 3);
			m_input.width = 40;
			m_input.setHorizontalImageSkin("commoncontrol/horstretch/inputBg2_mirror.png");
			m_input.setTextFormat(0xffffff, 14);
			m_input.align = Component.CENTER;
			m_input.number = true;
			
			m_concelBtn = new PushButton(this, 150, 8,onCancelBtn);
			m_concelBtn.setSkinButton1Image("commoncontrol/button/exitbtn4.png");
			
			m_underLinePanel = new Panel(this, 0, this.height);
			m_underLinePanel.setSize(175, 2);
			m_underLinePanel.autoSizeByImage = false;
			m_underLinePanel.setPanelImageSkin("commoncontrol/panel/splitline.png");
			
			m_input.addEventListener(Event.CHANGE, onChange);
		}
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_obj = data as ZObject;
			
			m_nameLabel.text = m_obj.name;
			m_nameLabel.setFontColor(m_obj.colorValue);
			m_input.intText = m_obj.m_object.num;
			m_input.minNumber = 1;
			m_input.maxNumber = m_obj.m_object.num;
		}
		protected function onChange(event:Event):void
		{
			m_SalePart.updatemoney();
		}
		public function onCancelBtn(event:MouseEvent):void
		{
			m_SalePart.deleteItem(m_obj);
		}
		public function get obj():ZObject
		{
			return m_obj;
		}
		
		public function get num():int
		{
			return m_input.intText;
		}
	}

}