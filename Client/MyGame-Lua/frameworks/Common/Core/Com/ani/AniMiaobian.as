package com.ani 
{
	import com.gskinner.motion.GTween;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.PBUtil;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 * 描边闪烁
	 */
	
	public class AniMiaobian extends DigitAniBase 
	{
		private var m_gtWeen:GTween;
		private var m_t:Number;
		private var m_blurY:uint;
		private var m_strength:uint;
		private var m_colorsb:uint;
		private var m_duration:Number;	
		private var m_curUintFrame:uint;
		
		public function AniMiaobian() 
		{
			m_gtWeen = new GTween();
			m_gtWeen.reflect = true;
			m_gtWeen.autoPlay = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.target = this;
			m_gtWeen.paused = true;
			m_gtWeen.repeatCount = 0;
		}
		
		public function setParam(duration:Number, color:uint, blurY:uint = 9, strength:uint = 5, useFrames:Boolean = true):void
		{
			m_duration = duration;
			m_colorsb = color;
			m_blurY = blurY;
			m_strength = strength;
			m_gtWeen.useFrames = useFrames;
		}
		
		public function set repeatCount(t:int):void
		{
			m_gtWeen.repeatCount = t;
		}
		
		override public function begin():void
		{
			super.begin();
			
			m_t = 1 - 0.49999;
			m_gtWeen.setValue("t", m_strength + 0.49999);
			m_gtWeen.duration = m_duration;
			m_gtWeen.paused = false;
		}
		
		override protected function onAniEnd():void
		{
			super.onAniEnd();
			stop();
		}
		
		override public function dispose():void 
		{
			m_gtWeen.paused = true;
			m_gtWeen.onComplete = null;
			m_gtWeen.target = null;
			m_gtWeen = null;
			super.dispose();
		}
		
		override public function stop():void
		{
			super.stop();
			if (m_sp)
			{
				m_sp.filters = null;
			}
			
			m_bRun = false;
			m_gtWeen.paused = true;
		}
		
		public function get paused():Boolean
		{
			return m_gtWeen.paused;
		}
		
		public function set t(v:Number):void
		{
			m_t = v;
			
			var a:uint = Math.ceil(m_t);
			var dic:Dictionary;
			if (a != m_curUintFrame)
			{
				m_curUintFrame = a;
				dic = new Dictionary();
				dic[EntityCValue.blurY] = m_blurY + a;
				dic[EntityCValue.strength] = a;
				dic[EntityCValue.colorsb] = m_colorsb;
				m_sp.filters = [PBUtil.buildGradientGlowFilter(dic)];
			}
		}
		
		public function get t():Number
		{
			return m_t;
		}
	}

}