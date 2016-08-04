package game.ui.uibackpack.backpack
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilGraphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.time.Daojishi;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	
	/**
	 * ...
	 * @author
	 * 时间到了之后，自动开格子
	 */
	public class OpenGridInTime extends Component
	{
		private var m_gkContext:GkContext;
		private var m_daojishi:Daojishi;
		private var m_tf:TextNoScroll;
		private var m_shape:Shape;
		
		public function OpenGridInTime(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			super(parent, xpos, ypos);
			this.setSize(38, 38);
			this.setPanelImageSkin("commoncontrol/panel/objectbg_light.png");
			
			m_daojishi = new Daojishi(m_gkContext.m_context);
			m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_daojishi.funCallBack = onDaojishiUpdate;
			
			m_tf = new TextNoScroll();
			this.addChild(m_tf);
			m_tf.x = 4;
			m_tf.y = 4;
			m_tf.width = 30;
			m_tf.height = 30;
			//m_tf.visible = false;
			UtilHtml.beginCompose();
			UtilHtml.add(UtilHtml.formatBold("正在"), 0xbbbbbb, 12);
			UtilHtml.breakline();
			UtilHtml.add(UtilHtml.formatBold("开启"), 0xbbbbbb, 12);
			
			m_tf.htmlText = UtilHtml.getComposedContent();
			addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			m_shape = new Shape();
			this.addChild(m_shape);
			m_shape.x = 19;
			m_shape.y = 19;
			
		}
		
		//当包裹界面显示时，调用此函数
		public function onShowEx():void
		{
			m_daojishi.initLastTime = m_gkContext.m_objMgr.leftTimeForOpenGrid;
			m_daojishi.begin(m_gkContext.m_objMgr.initTimeForOpenGrid);
			onDaojishiUpdate(m_daojishi);
		}
		
		//当包裹界面关闭时，调用此函数
		public function onHideEx():void
		{
			m_daojishi.end();
		}
		
		private function onDaojishiUpdate(djs:Daojishi):void
		{
			var totalTime:Number = m_gkContext.m_objMgr.totalTimeForOpenGrid;
			
			var angle:Number = (totalTime - m_daojishi.timeMillionSecond) / totalTime * Math.PI * 2;
			m_shape.graphics.clear();
			m_shape.graphics.beginFill(0x101010, 0.75);
			UtilGraphics.drawSquarePie(m_shape.graphics, angle, 20);
			m_shape.graphics.endFill();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			
			var pt:Point = this.localToScreen();
			pt.x += 42;
			pt.y -= 7;
			UtilHtml.beginCompose();
			UtilHtml.add("只要保持在线，包裹就会自动开启", UtilColor.BLUE);
			UtilHtml.breakline();
			UtilHtml.add("成为Vip可获得一定数量包裹", UtilColor.BLUE);
			UtilHtml.breakline();
			UtilHtml.breakline();
			
			var time:Number = m_daojishi.timeSecond;
			var str:String = "开启剩余时间: " + UtilTools.formatTimeToString(time);
			UtilHtml.add(str, UtilColor.WHITE_Yellow);
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent());
		
		}
	}

}