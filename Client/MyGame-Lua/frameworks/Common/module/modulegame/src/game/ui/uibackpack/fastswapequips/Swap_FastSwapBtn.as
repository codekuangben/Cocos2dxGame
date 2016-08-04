package game.ui.uibackpack.fastswapequips 
{
	import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class Swap_FastSwapBtn extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIFastSwapEquips;
		private var m_panelCom:PanelContainer;
		private var m_swapBtn:PushButton;
		private var m_rotationAni:AniPropertys;
		
		public function Swap_FastSwapBtn(gk:GkContext, ui:UIFastSwapEquips, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			var panel:Panel;
			panel = new Panel(this, 0, 0);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/swapequips/swapback.png");
			
			m_panelCom = new PanelContainer(this, 48, 48);
			panel = new Panel(m_panelCom, -46, -46);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/swapequips/swap.png");
			
			m_rotationAni = new AniPropertys();
			m_rotationAni.sprite = m_panelCom;
			m_rotationAni.resetValues( { rotation:360 } );
			m_rotationAni.duration = 1;
			m_rotationAni.repeatCount = 1;
			
			m_swapBtn = new PushButton(this, 18, 18, onSwapBtnClick);
			m_swapBtn.setSize(96, 96);
			m_swapBtn.setSkinButton1Image("commoncontrol/panel/backpack/swapequips/swapbtn.png");
		}
		
		private function onSwapBtnClick(event:MouseEvent):void
		{
			if (event.currentTarget is PushButton)
			{
				m_rotationAni.begin();
				
				m_ui.startSwapEquips();
			}
		}
		
		override public function dispose():void
		{
			if (m_rotationAni)
			{
				m_rotationAni.dispose();
			}
			
			super.dispose();
		}
	}

}