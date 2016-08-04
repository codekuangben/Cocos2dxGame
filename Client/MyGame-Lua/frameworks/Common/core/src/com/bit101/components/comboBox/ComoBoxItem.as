package com.bit101.components.comboBox 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.Label;
	import com.bit101.components.ListItem;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	
	public class ComoBoxItem extends ListItem
	{
		protected var m_funMakeLabel:Function;
		protected var m_label:Label;
		protected var m_overPanel:Panel;
		protected var m_selectPanel:Panel;
		public function ComoBoxItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null, param:Object = null) 
		{
			m_label = new Label(this);
			super(parent, xpos, ypos,null,param);
			this.data = data;
			m_overPanel = param["over"];
			m_selectPanel = param["select"];
		}
		
		override public function set data(value:Object):void 
		{
			if (value && value is String)
			{
				m_label.text = value as String;
			}
			
			super.data = value;
			
		}
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
			drawRectBG();
		}
		public function get funMakeLabel():Function
		{
			return m_funMakeLabel
		}
		override public function onOver():void 
		{
			if (m_overPanel.parent != this)
			{				
				this.addChildAt(m_overPanel, 0);
			}
		}
		override public function onOut():void 
		{
			if (m_overPanel.parent == this)
			{
				this.removeChild(m_overPanel);
			}
		}
		override public function onSelected():void 
		{
			if (m_selectPanel.parent != this)
			{
				this.addChildAt(m_selectPanel, 0);		
			}
		}
		override public function onNotSelected():void 
		{
			if (m_selectPanel.parent == this)
			{
				this.removeChild(m_selectPanel);
			}
		}
	}

}