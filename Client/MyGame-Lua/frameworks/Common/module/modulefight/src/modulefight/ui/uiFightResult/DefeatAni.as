package modulefight.ui.uiFightResult 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.ani.AniPropertys;
	
	/**
	 * ...
	 * @author 
	 */
	public class DefeatAni extends Component 
	{
		private var m_panel:Panel;
		private var m_ani:AniPropertys;
		private var m_ui:UIFightResult;
		public function DefeatAni(ui:UIFightResult) 
		{
			m_ui = ui;
			m_panel = new Panel(this, -370 / 2, -314 / 2); 
			m_panel.setPanelImageSkin("commoncontrol/panel/battledefeat.png");
			m_ani = new AniPropertys();
			m_ani.duration = 0.3;
			m_ani.sprite = m_panel;	
			m_ani.onEnd = onEnd;
			
			//setPos(-185,-157);
		}
		public function begin():void
		{
			m_panel.alpha = 0;
			m_ani.resetValues( { alpha:1 } );
			m_ani.begin();
		}
		
		public function onEnd():void
		{
			m_ui.onAniEnd();
		}		
		
		override public function dispose():void
		{
			m_ani.dispose();
			m_ani = null;
		}
	}

}