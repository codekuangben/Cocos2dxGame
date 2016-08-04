package game.ui.tongquetai.backstage
{
	/**
	 * ...
	 * @author
	 */
	import com.bit101.components.Panel;
	import com.bit101.components.Label;
	import modulecommon.net.msg.wunvCmd.SpecialWuNv;
	
	public class DancerIconMystery extends DancerIconBase
	{		
		private var m_specialDancer:SpecialWuNv;
		private var m_girlsNumPanel:Panel;
		private var m_girlsNumLabel:Label;
		
		public function DancerIconMystery(param:Object = null)
		{
			super(param);
			m_girlsNumPanel = new Panel(this, -3, 7);
			m_girlsNumPanel.setPanelImageSkin("commoncontrol/panel/numBg2.png");
			m_girlsNumLabel = new Label(m_girlsNumPanel, 12, 6);
			m_girlsNumLabel.align = CENTER;
			buttonMode = true;
		}
		
		override public function setData(data:Object):void 
		{
			m_specialDancer = data as SpecialWuNv;
			super.setData(m_specialDancer.m_dancer);
			m_icon.setPanelImageSkin("girlicon/" + m_specialDancer.m_dancer.m_icon + ".png");
			m_iconName.text = m_specialDancer.m_dancer.m_name;
			update();
		}
		
		override public function update():void
		{
			super.update();
		
			//更新数量			
			m_girlsNumLabel.intText = m_specialDancer.num;
		}
	
	}

}