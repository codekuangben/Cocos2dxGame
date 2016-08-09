package modulecommon.ui 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.Event;
	//import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 * form_W = 90 * 2 + 1 * n
	 * form_H = 37 * 2 + 9 * n
	 */
	public class FormStyleNine extends FormStyleEight
	{
		
		public function FormStyleNine() 
		{
			super();
			
			this.addEventListener(Event.RESIZE, onResize);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
		}
		
		protected function beginPanelDrawBg(w:Number, h:Number):void
		{
			beginPanelDraw(w, h, "form8.swf");
			
			var panel:Panel;
			panel = new Panel(null, 75, 6);
			panel.autoSizeByImage = false;
			panel.setSize(w - 150, 25);
			panel.setPanelImageSkinMirror("commoncontrol/panel/bluefight.png", Image.MirrorMode_LR);
			m_bgPart.addDrawCom(panel);
			
			if (w / 2 - 145 > 150)
			{
				panel = new Panel(null, 120, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
				
				panel = new Panel(null, w - 130, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
			}
			
			if (w / 2 - 145 > 210)
			{
				panel = new Panel(null, 180, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
				
				panel = new Panel(null, w - 190, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
			}
			
			if (w / 2 - 145 > 270)
			{
				panel = new Panel(null, 240, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
				
				panel = new Panel(null, w - 250, 11);
				panel.setPanelImageSkin("commoncontrol/panel/nail.png");
				m_bgPart.addDrawCom(panel);
			}
		}
		
		protected function setTitleDraw(titleW:Number = 282, image:String = "", swf:SWFResource = null, imageW:Number = 0):void
		{
			var panel:Panel;
			var panelContainer:PanelContainer;
			
			beginTitleDraw(titleW, 47, -17);
			panelContainer = new PanelContainer();
			panelContainer.width = titleW;
			panelContainer.setHorizontalImageSkin("commoncontrol/form/titlebg3_mirror.png");
			
			panel = new Panel(panelContainer, (titleW - imageW) / 2, 21);
			if (swf)
			{
				panel.setPanelImageSkinBySWF(swf, image);
			}
			else
			{
				panel.setPanelImageSkin(image);
			}
			m_titlePart.addDrawCom(panelContainer);
			endTitleDraw();
		}
		
		protected function onResize(event:Event):void
		{
			if (m_exitBtn)
			{
				m_exitBtn.setPos(this.width - 29, 6);
			}
			if (m_titlePart)
			{
				m_titlePart.x = (this.width - m_titlePart.width) / 2;
			}
		}
	}

}