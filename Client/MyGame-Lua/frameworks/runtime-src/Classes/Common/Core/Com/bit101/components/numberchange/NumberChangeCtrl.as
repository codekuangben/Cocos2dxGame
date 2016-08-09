package com.bit101.components.numberchange 
{
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NumberChangeCtrl extends Component 
	{				
		protected var m_addBtn:PushButton;
		protected var m_subtractBtn:PushButton;
		protected var m_input:InputText;		
		private var m_funOnNumberChange:Function;
		public function NumberChangeCtrl(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_addBtn = new PushButton(this, 0, 0, onBtnClick);
			m_addBtn.tag = 0;
			m_subtractBtn = new PushButton(this, 0, 0, onBtnClick);
			m_subtractBtn.tag = 1;
			
			m_input = new InputText(this, 0, 0, "", onChange );
			m_input.align = Component.CENTER;
			m_input.number = true;
		}
		
		public function setParam(min:int, max:int, defaultValue:int):void
		{
			m_input.minNumber = min;
			m_input.maxNumber = max;
			m_input.intText = defaultValue;
			updateBtnEnable();			
		}
		private function onBtnClick(e:MouseEvent):void
		{
			var v:int;
			var tag:int = (e.currentTarget as Component).tag;
			v = m_input.intText;
			if (tag == 0)
			{				
				if (v < m_input.maxNumber)
				{
					m_input.intText = v + 1;
				}
				
			}
			else
			{
				if (v > m_input.minNumber)
				{
					m_input.intText = v - 1;
				}
			}
			
			updateBtnEnable();
			
		}
		private function updateBtnEnable():void
		{
			var v:int = m_input.intText;
			if (v < m_input.maxNumber)
			{
				m_addBtn.enabled = true;
			}
			else
			{
				m_addBtn.enabled = false;
			}
			
			if (v > m_input.minNumber)
			{
				m_subtractBtn.enabled = true;
			}
			else
			{
				m_subtractBtn.enabled = false;
			}
			
			if (m_funOnNumberChange != null)
			{
				m_funOnNumberChange(m_input.intText);
			}
		}
		protected function onChange(event:Event):void	
		{	
			updateBtnEnable();			
		}
		public function setSurface(xPosAdd:Number, xPosSubtract:Number, xPosInput:Number, wInput:Number):void
		{
			m_addBtn.setSkinButton1Image("commoncontrol/button/addbtn.png");
			m_subtractBtn.setSkinButton1Image("commoncontrol/button/subtractbtn.png");
			
			m_addBtn.x = xPosAdd;
			m_subtractBtn.x = xPosSubtract;
			m_input.x = xPosInput;
			m_input.setSize(wInput, 24);
			m_input.setHorizontalImageSkin("commoncontrol/horstretch/inputBg_mirror.png");
			m_input.setTextFormat(0xffffff, 16);
			m_input.y = -3;
		}
		
		public function get number():int
		{
			return m_input.intText;
		}
		public function set funOnNumberChange(fun:Function):void
		{
			m_funOnNumberChange = fun;
		}
	}

}