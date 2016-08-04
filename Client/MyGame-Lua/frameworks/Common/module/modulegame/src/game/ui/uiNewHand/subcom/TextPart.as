package game.ui.uiNewHand.subcom
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	
	/**
	 * ...
	 * @author
	 * 文字内容加箭头
	 * 
	 */
	public class TextPart extends Component
	{
		private static const ARROW_W:int = 13;
		private static const ARROW_H:int = 15;
		
		private var m_bg:PanelContainer;
		private var m_arrow:Panel;
		private var m_tf:TextNoScroll;
		private var m_arrowCopy:Panel; //m_arrowCopy不会进入显示列表，它存在目的是是Image对象(tiparrow.png)的计数增加1.
		private var m_right:Boolean; //true-当前执行右方
		
		public function TextPart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		
			
			m_bg = new PanelContainer(this);
			m_bg.setSkinGrid9Image9(ResGrid9.StypeSeven);
			m_bg.width = 140;
			m_tf = new TextNoScroll();
			m_bg.addChild(m_tf);
			m_tf.x = 15;
			m_tf.y = 10;
			m_tf.width = 120;
			m_tf.setCSS("body", {leading: 3, color: "#fbdda2", fontSize:14}); //e0e0e0
			
			m_right = true;
			m_arrow = new Panel(this);
			m_arrow.setPanelImageSkin("commoncontrol/panel/tiparrow.png");
			
			m_arrowCopy = new Panel();
			m_arrowCopy.setPanelImageSkin("commoncontrol/panel/tiparrow.png");
			
			m_arrow.x = -ARROW_W;
			m_bg.x = m_arrow.x + 2 - m_bg.width;
		}
		
		override public function dispose():void
		{
			super.dispose();
			m_arrowCopy.dispose();
		}
		
		/*right: true-表示箭头指向右方
		 * (xPos,yPos) 箭头顶点的位置,也是TextPart对象的(x,y)
		 * text：文字内容
		 */
		public function showText(right:Boolean, xPos:int, yPos:int, text:String):void
		{
			this.setPos(xPos, yPos);
			m_tf.htmlText = "<body>" + text + "</body>";
			m_bg.height = m_tf.y + m_tf.height + 10;
			m_bg.y = - (m_bg.height-ARROW_H) / 2;
			
			if (m_right != right)
			{
				if (right)
				{
					m_arrow.setPanelImageSkin("commoncontrol/panel/tiparrow.png");
					m_arrow.x = -ARROW_W;
					m_bg.x = m_arrow.x + 2 - m_bg.width;
					
				}
				else
				{
					m_arrow.setPanelImageSkinMirror("commoncontrol/panel/tiparrow.png", Image.MirrorMode_HOR);
					m_arrow.x = 0;
					m_bg.x = m_arrow.x + ARROW_W - 2;
				}
				m_right = right;
			}
		
		}
	
	}

}