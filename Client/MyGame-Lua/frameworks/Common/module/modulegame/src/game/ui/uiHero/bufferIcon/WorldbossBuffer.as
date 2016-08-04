package game.ui.uiHero.bufferIcon 
{
	import com.ani.AniMiaobian;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.hero.EffectBuffer;
	import modulecommon.scene.hero.ItemBuffer;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 世界BOSS中buffer:鼓舞、激励
	 */
	public class WorldbossBuffer extends BufferBase
	{
		private var m_itemBuffer:ItemBuffer;
		private var m_levelDC:DigitComponent;	//等级显示
		private var m_leftTimeLabel:Label;
		private var m_ani:AniMiaobian;			//(激励)当有剩余次数时显示特效
		
		public function WorldbossBuffer(gk:GkContext, parent:DisplayObjectContainer) 
		{
			super(gk, parent);
			
			m_levelDC = new DigitComponent(m_gkContext.m_context, this, 40, 5);
			m_levelDC.align = Component.CENTER;
			m_levelDC.setParam("commoncontrol/digit/digit02", 16, 25);
			
			m_leftTimeLabel = new Label(this, 38, 78, "", UtilColor.GOLD);
			m_leftTimeLabel.align = Component.CENTER;
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function setData(buffer:ItemBuffer):void
		{
			m_itemBuffer = buffer;
			
			this.initData(m_itemBuffer.bufferID, m_itemBuffer.iconName, AttrBufferMgr.TYPE_WORLDBOSS);
			m_levelDC.digit = m_itemBuffer.m_level;
			
			if (AttrBufferMgr.Buffer_Jili == bufferID && null == m_ani)
			{
				m_ani = new AniMiaobian();
				m_ani.sprite = m_iconPanel;
				m_ani.setParam(6, UtilColor.GOLD);
			}
		}
		
		public function updateData(buffer:ItemBuffer):void
		{
			m_itemBuffer = buffer;
			m_levelDC.digit = m_itemBuffer.m_level;
		}
		
		public function updateLeftTimes(value:uint):void
		{
			m_leftTimeLabel.text = "剩余次数 " + value.toString() + " 次";
			
			if (m_ani)
			{
				if (value)
				{
					m_ani.begin();
				}
				else
				{
					m_ani.stop();
				}
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if (event.currentTarget as BufferBase)
			{
				m_gkContext.m_worldBossMgr.reqEncourageAddInspire(bufferID);
			}
		}
		
		override protected function onRollOver(event:MouseEvent):void
		{
			var buffer:BufferBase = event.currentTarget as BufferBase;
			if (null == buffer)
			{
				return;
			}
			
			m_iconPanel.scaleX = 1.1;
			m_iconPanel.scaleY = 1.1;
			m_iconPanel.setPos(0 - (m_iconPanel.width * 0.1) / 2, 0 - (m_iconPanel.height * 0.1) / 2);
			
			m_levelDC.scaleX = 1.1;
			m_levelDC.scaleY = 1.1;
			m_levelDC.setPos(40, 5 - (m_iconPanel.height * 0.1) / 2);
			
			this.buttonMode = true;
			
			UtilHtml.beginCompose();
			UtilHtml.add(m_itemBuffer.name + " " + m_itemBuffer.m_level.toString() + "级", UtilColor.BLUE, 14);
			
			var i:int;
			var str:String;
			var pt:Point;
			var effList:Vector.<EffectBuffer> = m_itemBuffer.m_vecEffect;
			
			for (i = 0; i < effList.length; i++)
			{
				UtilHtml.breakline();
				UtilHtml.add(m_gkContext.m_attrBufferMgr.getAttrDesc(effList[i].m_type, effList[i].m_value), 0xdFa600, 12);
			}
			
			UtilHtml.breakline();
			if (AttrBufferMgr.Buffer_Guwu == bufferID)
			{
				str = "使用元宝购买，最多可购买20次，每次20元宝(重新登陆等级不会改变)";
			}
			else if (AttrBufferMgr.Buffer_Jili == bufferID)
			{
				str = "每击杀一只boss，等级可提升一级";
			}
			UtilHtml.add(str, UtilColor.WHITE_B, 12);
			
			pt = this.localToScreen(new Point(70, 10));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 230);
		}
		
		override protected function onRollOut(event:MouseEvent):void
		{
			super.onRollOut(event);
			
			m_iconPanel.scaleX = 1;
			m_iconPanel.scaleY = 1;
			m_iconPanel.setPos(0, 0);
			
			m_levelDC.scaleX = 1;
			m_levelDC.scaleY = 1;
			m_levelDC.setPos(40, 5);
			
			this.buttonMode = false;
		}
		
		override public function dispose():void
		{
			if (m_ani)
			{
				m_ani.dispose();
				m_ani = null;
			}
			
			super.dispose();
		}
	}

}