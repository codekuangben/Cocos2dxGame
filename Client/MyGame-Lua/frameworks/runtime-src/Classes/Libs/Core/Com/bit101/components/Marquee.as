package com.bit101.components 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.pblabs.engine.core.ITickedObject;
	import common.Context;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.pblabs.engine.entity.EntityCValue;

	public class Marquee extends Component implements ITickedObject
	{
		protected var m_con:Context;
		protected var m_content:DisplayObject;
		protected var m_speed:Number = 30;
		protected var m_inPMgr:Boolean = false;
		protected var m_bLoop:Boolean = true;
		public function Marquee(cont:Context, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			m_con = cont;
			super(parent, xpos, ypos);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		public function onTick(deltaTime:Number):void
		{
			m_content.x -= deltaTime * m_speed;
			if (m_content.x < -m_content.width)
			{
				if (m_bLoop == false)
				{
					this.dispatchEvent(new Event(Event.COMPLETE));
					end();
					return;
				}
				m_content.x = this.width;
			}			
		}
		
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
			var rect:Rectangle = new Rectangle(0, 0, w, h);
			this.scrollRect = rect;
		}
		public function set content(sp:DisplayObject):void
		{
			m_content = sp;
			addChild(sp);
		}
		override public function dispose():void 
		{
			super.dispose();
			end();
		}
		
		public function set speed(s:Number):void
		{
			m_speed = s;
		}
		
		public function set loop(s:Number):void
		{
			m_bLoop = s;
		}
		public function begin():void
		{
			m_content.x = this.width;
			
			if (m_inPMgr == false)
			{
				m_con.m_processManager.addTickedObject(this, EntityCValue.PriorityUI);
				m_inPMgr = true;
			}			
		}
		public function end():void
		{
			if (m_inPMgr)
			{
				m_con.m_processManager.removeTickedObject(this);
				m_inPMgr = false;
			}
		}
		public function reset():void
		{
			m_content.x = this.width;	
			end();
		}
		
	}

}