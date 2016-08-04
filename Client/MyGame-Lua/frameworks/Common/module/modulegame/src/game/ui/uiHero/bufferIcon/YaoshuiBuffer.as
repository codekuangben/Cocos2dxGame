package game.ui.uiHero.bufferIcon 
{
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.hero.EffectBuffer;
	import modulecommon.scene.hero.ItemBuffer;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 * 属性加成buffer:武力、智力、统率、兵力、
	 */
	public class YaoshuiBuffer extends BufferTime
	{
		private var m_itemBuffer:ItemBuffer;
		private var m_bgPanel:Panel;
		
		public function YaoshuiBuffer(gk:GkContext, parent:DisplayObjectContainer) 
		{
			super(gk, parent);
			
			m_bgPanel = new Panel(null, 0, 0);
			this.addChildAt(m_bgPanel, 0);
			m_bgPanel.setPanelImageSkin("commoncontrol/panel/objectbg_yaoshui.png");
		}
		
		public function setData(buffer:ItemBuffer):void
		{
			m_itemBuffer = buffer;
			m_leftTime = m_itemBuffer.leftTime;
			
			this.initData(m_itemBuffer.bufferID, m_itemBuffer.iconName, AttrBufferMgr.TYPE_YAOSHUI);
			beginDaojishi(m_leftTime);
		}
		
		override protected function onRollOver(event:MouseEvent):void
		{
			var str:String;
			var color:uint;
			var pt:Point;
			
			UtilHtml.beginCompose();
			str = UtilHtml.formatBold(m_itemBuffer.m_name);
			UtilHtml.add(str, UtilColor.BLUE, 14);
			UtilHtml.breakline();
			
			var effList:Vector.<EffectBuffer> = m_itemBuffer.m_vecEffect;
			var i:int;
			for (i = 0; i < effList.length; i++)
			{
				UtilHtml.add(m_gkContext.m_attrBufferMgr.getAttrDesc(effList[i].m_type, effList[i].m_value), 0xdFa600, 12);
				UtilHtml.breakline();
			}
			
			if (m_leftTime < 60)
			{
				color = UtilColor.RED;
			}
			else
			{
				color = UtilColor.GREEN;
			}
			
			str = UtilTools.formatTimeToString(m_leftTime);
			UtilHtml.add("剩余时间：" + str, color, 12);
			
			pt = this.localToScreen(new Point(25, -2));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 230);
		}
	}

}