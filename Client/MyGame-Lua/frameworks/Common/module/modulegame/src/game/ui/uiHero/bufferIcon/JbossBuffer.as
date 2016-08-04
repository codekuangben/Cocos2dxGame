package game.ui.uiHero.bufferIcon 
{
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
	 * 精英boss-buf类
	 * @author 
	 */
	public class JbossBuffer extends BufferBase 
	{
		/**
		 * buf数据
		 */
		private var m_itemBuffer:ItemBuffer;
		/**
		 * vip等级美术字
		 */
		private var m_levelDC:DigitComponent;
		public function JbossBuffer(gk:GkContext, parent:DisplayObjectContainer=null) 
		{
			super(gk, parent);
			m_levelDC = new DigitComponent(m_gkContext.m_context, this, 40, 26);
			m_levelDC.align = CENTER;
			m_levelDC.setParam("commoncontrol/digit/digit02", 16, 25);
		}
		
		/**
		 * 初始化buf
		 * @param	buffer
		 */
		public function setData(buffer:ItemBuffer):void
		{
			m_itemBuffer = buffer;
			
			this.initData(m_itemBuffer.bufferID, m_itemBuffer.iconName, AttrBufferMgr.TYPE_WORLDBOSS);
			m_levelDC.digit = m_gkContext.m_beingProp.vipLevel;
		}
		/**
		 * 更新buf
		 * @param	buffer
		 */
		public function updateData(buffer:ItemBuffer):void
		{
			m_itemBuffer = buffer;
		}
		/**
		 * vip等级提升更新
		 */
		public function updataVipLevel():void
		{
			m_levelDC.digit = m_gkContext.m_beingProp.vipLevel;
		}
		override public function initData(id:uint, icon:String = null, type:int = 0):void 
		{
			m_bufferID = id;
			m_type = type;
			m_iconPanel.setPanelImageSkin("bufficon/vip.png");
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
			m_levelDC.setPos(40, 26 - (m_iconPanel.height * 0.1) / 2);
			
			var pt:Point= this.localToScreen(new Point(70, 10));
			if (m_gkContext.m_beingProp.vipLevel == 0)
			{
				UtilHtml.beginCompose();
				UtilHtml.add("VIP0 无加成效果", UtilColor.BLUE, 14);
				UtilHtml.breakline();
				UtilHtml.add("提升vip等级", 0xdFa600, 12);
				UtilHtml.breakline();
				UtilHtml.add("加成效果将会使劲提升", 0xdFa600, 12);
				m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 230);
			}
			else
			{
				UtilHtml.beginCompose();
				UtilHtml.add("  "+m_itemBuffer.name, UtilColor.BLUE, 14);
				var i:int;
				var effList:Vector.<EffectBuffer> = m_itemBuffer.m_vecEffect;
				for (i = 0; i < effList.length; i++)
				{
					UtilHtml.breakline();
					UtilHtml.add(m_gkContext.m_attrBufferMgr.getAttrDesc(effList[i].m_type, effList[i].m_value), 0xdFa600, 12);
				}
				m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 230);
			}
		}
		
		override protected function onRollOut(event:MouseEvent):void
		{
			super.onRollOut(event);
			
			m_iconPanel.scaleX = 1;
			m_iconPanel.scaleY = 1;
			m_iconPanel.setPos(0, 0);
			
			m_levelDC.scaleX = 1;
			m_levelDC.scaleY = 1;
			m_levelDC.setPos(40, 26);
		}
	}

}