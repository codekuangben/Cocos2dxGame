package modulecommon.ui 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.PushButton;
	import com.util.UtilFont;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class FormStyleFour extends Form 
	{
		protected var m_titlePart:PanelDraw;
		protected var m_bgPart:PanelDraw;
		protected var m_exitBtn:PushButton;
		public function FormStyleFour(showExitBtn:Boolean = true) 
		{
			m_bgPart = new PanelDraw();
			this.addBackgroundChild(m_bgPart);
			
			if (showExitBtn)
			{
				m_exitBtn = new PushButton(this,0,4);
				m_exitBtn.m_musicType = PushButton.BNMClose;
				m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
				m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			}
			this.addEventListener(Event.RESIZE, onResize);
			m_ocMusic = true;
		}
		
		override public function dispose():void
		{
			if (m_exitBtn)
			{
				m_exitBtn.removeEventListener(MouseEvent.CLICK, onExitBtnClick);
			}
			super.dispose();
		}
		
		public function setTitle(title:String, titleBGWidth:int, titleBG:String="titlebg_mirror.png", titleLabelY:Number=20,letterspace:Number=6):void
		{
			if (m_titlePart == null)
			{
				m_titlePart = new PanelDraw();
				this.addBackgroundChild(m_titlePart);
			}
			
			m_titlePart.y = -31;
			m_titlePart.setSize(titleBGWidth, 50);
			var panel:Panel = new Panel();
			panel.setSize(titleBGWidth, 36);
			m_titlePart.addDrawCom(panel, true);
			panel.setHorizontalImageSkin("commoncontrol/form/" + titleBG);
			
			var _titleLabel:Label = new Label();	

			//_titleLabel.setBold(true);
			_titleLabel.setFontSize(18);
			_titleLabel.setFontColor(0xe7e565);
			_titleLabel.setFontName(UtilFont.NAME_HuawenXinwei);
			_titleLabel.setLetterSpacing(letterspace);
			_titleLabel.autoSize = false;
			_titleLabel.setSize(120, 25);
			_titleLabel.align = Component.CENTER;			
			_titleLabel.text = title;
			_titleLabel.flush();
			_titleLabel.x = (titleBGWidth - _titleLabel.width) / 2;
			_titleLabel.y = titleLabelY;
			m_titlePart.addDrawCom(_titleLabel);
			m_titlePart.drawPanel();
			m_titlePart.x = (this.width - m_titlePart.width) / 2;
			
		}
		
		protected function onResize(e:Event):void
		{
			if (m_exitBtn)
			{
				m_exitBtn.x = this.width - 55;
			}
			if (m_titlePart)
			{
				m_titlePart.x = (this.width - m_titlePart.width) / 2;
			}
		}
				
		public function newHandMoveToExitBtn():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.prompt(false, 40, 40, "点击关闭。", m_exitBtn);
			}
		}
	}

}