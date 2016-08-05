package com.bit101.components.progressBar 
{
	import com.ani.AniPropertys;
	import com.bit101.components.PanelCut;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 */
	public class BarInProgress2 extends PanelCut
	{
		private var m_ani:AniPropertys;
		protected var m_funCallOnAniEnd:Function;
		private var m_totalWidth:Number;
		protected var _value:Number = 0;
		protected var _max:Number = 1;
		
		
		public function BarInProgress2(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
		}
		public function set maximum(m:Number):void
		{
			_max = m;
		}
		
		public function set initValue(v:Number):void
		{
			_value = v;
			this.setCutRect(this.width * _value / _max, this.height);
		}		
		
		public function set value(v:Number):void
		{
			_value = v;
			
			if (m_ani == null)
			{
				m_ani = new AniPropertys();
				m_ani.sprite = this;
				m_ani.duration = 0.3;	
				m_ani.onEnd = aniEndCallBack;
			}
			
			m_ani.resetValues( { cutRectW:this.width * _value / _max } );
			m_ani.begin();			
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function setAniEndCallBack(fun:Function):void
		{
			m_funCallOnAniEnd = fun;
		}
		
		private function aniEndCallBack():void
		{
			if (m_funCallOnAniEnd!=null)
			{
				m_funCallOnAniEnd();
			}
		}
		
		override public function dispose():void 
		{
			if (m_ani)
			{
				m_ani.dispose();
			}
			super.dispose();
		}
	}

}