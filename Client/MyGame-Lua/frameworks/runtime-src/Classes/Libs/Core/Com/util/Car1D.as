package com.util 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Car1D 
	{
		private var m_sorPos:Number;
		private var m_curPos:Number;
		private var m_destPos:Number;
		private var m_bRunning:Boolean;
		private var m_mvSpeed:Number;		//移动速度
		
		public function Car1D() 
		{
			
		}
		
		public function set sorPos(pos:Number):void
		{
			m_sorPos = pos;
		}
		public function set destPos(pos:Number):void
		{
			m_destPos = pos;
		}
		
		public function set mvSpeed(speed:Number):void
		{
			m_mvSpeed = speed;
		}
		
		public function set totalTime(time:Number):void
		{
			m_mvSpeed = Math.abs(m_sorPos - m_destPos) / time;
		}
		
		public function get isStop():Boolean
		{
			return m_bRunning == false;
		}
		
		public function get curPos():Number
		{
			return m_curPos;
		}
		
		public function begin():void
		{
			m_bRunning = true;
			m_curPos = m_sorPos;
			if (m_destPos < m_sorPos)
			{
				m_mvSpeed = -m_mvSpeed;
			}
		}
		
		public function stop():void
		{
			m_bRunning = false;
		}
		
		public function onTick(deltaTime:Number):void
		{
			if (isStop)
			{
				return;
			}
			m_curPos += m_mvSpeed * deltaTime;
			if (Math.abs(m_curPos - m_sorPos) >= Math.abs(m_destPos - m_sorPos))
			{
				m_curPos = m_destPos;
				m_bRunning = false;
			}
		}		
	}

}