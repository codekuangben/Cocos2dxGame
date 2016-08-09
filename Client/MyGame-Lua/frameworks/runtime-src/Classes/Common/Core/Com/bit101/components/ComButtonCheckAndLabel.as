package com.bit101.components 
{
	import flash.events.MouseEvent;	
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class ComButtonCheckAndLabel extends Component 
	{
		protected var m_CheckBtn:ButtonCheck;
		protected var m_textLabel:Label;
		protected var m_funCallBack:Function;	// function OnSelecteChange(com:ComRadioButtonAndLabel):void
		public function ComButtonCheckAndLabel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);		
			m_CheckBtn = new ButtonCheck(this);
			m_CheckBtn.setPanelImageSkin("commoncontrol/button/bb_buttoncheck.swf");
			m_textLabel = new Label(this, 25, 4);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		public function onClick(e:MouseEvent):void
		{
			if (e.target != m_CheckBtn)
			{
				m_CheckBtn.selected = !m_CheckBtn.selected;
			}
			if (m_funCallBack != null)
			{
				m_funCallBack(this);
			}
		}
		public function set text(text:String):void
		{
			m_textLabel.text = text;
		}
		public function get selected():Boolean
		{
			return m_CheckBtn.selected;
		}
		
		public function set selected(b:Boolean):void
		{
			m_CheckBtn.selected = b;
		}
		public function set funCallBack(fun:Function):void
		{
			m_funCallBack = fun;
		}
		override public function dispose():void 
		{
			m_funCallBack = null;
			super.dispose();
		}
		
	}

}