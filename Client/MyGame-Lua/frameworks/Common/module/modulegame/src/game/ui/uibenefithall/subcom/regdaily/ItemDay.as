package game.ui.uibenefithall.subcom.regdaily 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	import com.util.UtilFont;
	/**
	 * ...
	 * @author ...
	 */
	public class ItemDay extends Component
	{
		private var m_regDailyPage:RegDailyPage;
		private var m_numLabel:Label;
		private var m_backPanel:Panel;
		private var m_selectPanel:Panel;
		
		public function ItemDay(regdailypage:RegDailyPage, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			this.setSize(61, 31);
			m_regDailyPage = regdailypage;
			
			m_numLabel = new Label(this, 0, 7);
			m_numLabel.autoSize = false;
			m_numLabel.setSize(this.width, 20);
			m_numLabel.setBold(true);
			m_numLabel.miaobian = false;
			m_numLabel.setFontName(UtilFont.NAME_HuawenXinwei);
			m_numLabel.setFontSize(14);
			m_numLabel.align = Component.CENTER;
			
		}
		
		//day:这一天几号   bcurmonth:是否属于本月 bworkday:是否是工作日
		public function setNum(day:uint, bcurmonth:Boolean, bworkday:Boolean = true):void
		{
			var color:uint;
			if (bcurmonth)
			{
				if (null == m_backPanel)
				{
					m_backPanel = new Panel();
					this.addChildAt(m_backPanel, 0);
					
					if (m_regDailyPage.resource)
					{
						m_backPanel.setPanelImageSkinBySWF(m_regDailyPage.resource, "regdaily.datebg");
					}
				}
				
				m_backPanel.visible = true;
				
				if (bworkday)
				{
					color = UtilColor.WHITE_Yellow;
				}
				else
				{
					color = UtilColor.GREEN;
				}
			}
			else
			{
				color = UtilColor.WHITE_B
				if (m_backPanel)
				{
					m_backPanel.visible = false;
				}
			}
			
			m_numLabel.setFontColor(color);
			m_numLabel.text = day.toString();
		}
		
		public function setSelect():void
		{
			if (null == m_selectPanel)
			{
				m_selectPanel = new Panel(this, 0, 0);
				m_selectPanel.setPanelImageSkin("commoncontrol/panel/select.png");
			}
		}
		
		public function clearSelect():void
		{
			if (m_selectPanel)
			{
				if (m_selectPanel.parent)
				{
					m_selectPanel.parent.removeChild(m_selectPanel);
				}
				m_selectPanel.dispose();
				m_selectPanel = null;
			}
		}
	}

}