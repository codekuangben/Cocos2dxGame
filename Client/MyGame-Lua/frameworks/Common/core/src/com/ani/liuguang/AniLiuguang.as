package com.ani.liuguang 
{
	import com.bit101.components.Component;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import common.Context;
	import flash.display.Shader;
	//import flash.display.Shape;
	//import flash.display.Sprite;
	import flash.filters.ShaderFilter;
	/**
	 * ...
	 * @author 
	 * posOflight: 光线的位置
	 * slope:斜率
	 * strength:光的强度
	 * width:光的宽度
	 * slope:斜率
	 */
	public class AniLiuguang 
	{
		private var m_con:Context;
		private var m_host:Component;
		private var m_gtWeen:GTween;
		private var m_shaderFilter:ShaderFilter;
		private var m_shader:Shader;
		private var m_x:Number;
		private var m_slop:Number;
		private var m_rangeBegin:Number;
		private var m_rangeEnd:Number;
		
		public function AniLiuguang(m_con:Context) 
		{
			m_shader = m_con.m_shaderMgr.getLiuguangShader();
			m_shaderFilter = new ShaderFilter();
			m_gtWeen = new GTween();
			m_gtWeen.target = this;
			m_gtWeen.duration = 1;
			m_gtWeen.ease = Cubic.easeOut;
		}
		public function set duration(v:Number):void
		{
			m_gtWeen.duration = v;
		}
		public function set lightWidth(v:Number):void
		{
			m_shader.data.width.value = [v];	
		}
			
		public function set slope(v:Number):void
		{
			m_shader.data.slope.value = [v];
			m_slop = v;
		}
		public function set strength(v:Number):void
		{
			m_shader.data.strength.value = [v];	
		}
		
		public function setParam(lightWidth:Number, slope:Number, strength:Number, duration:Number, rangeBegin:Number, rangeEnd:Number):void		
		{
			m_gtWeen.duration = duration;
			m_shader.data.width.value = [lightWidth];
			m_shader.data.slope.value = [slope];
			m_slop = slope;
			m_shader.data.strength.value = [strength];	
			m_rangeBegin = rangeBegin;
			m_rangeEnd = rangeEnd;
		}
		public function set x(v:Number):void
		{
			m_x = v;
			m_shader.data.posOflight.value = [m_x];	
			m_shaderFilter.shader = m_shader;
			m_host.filters = [m_shaderFilter];
		}
		public function get x():Number
		{
			return m_x;
		}
		public function set host(host:Component):void
		{
			m_host = host;
		}
		public function begin():void
		{
			//x = m_host.height;
			//m_gtWeen.setValue("x", m_host.width*(-m_slop));
			
			x = m_rangeBegin;
			m_gtWeen.setValue("x", m_rangeEnd);
			m_gtWeen.repeatCount = 0;
			
			m_gtWeen.paused = false;			
		}
		public function stop():void
		{
			m_gtWeen.paused = true;
			m_host.filters = null;
		}
		public function dispose():void
		{
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_host.filters = null;
			m_host = null;
		}
	}

}