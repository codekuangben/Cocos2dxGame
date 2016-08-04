package game.ui.uiZhenfa 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.uiObject.UIMBeing;
	
	/**
	 * ...
	 * @author 
	 */
	public class WuAniPanel extends Panel 
	{
		protected var m_bgAniPanel:Panel;
		protected var m_beingPanel:Panel;
		protected var m_topAniPanel:Panel;
		
		protected var m_gkContext:GkContext;
		protected var m_bgAni:Ani;
		protected var m_topAni:Ani;
		protected var m_wu:WuProperty;
		public function WuAniPanel(gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
			m_gkContext = gk;
			m_bgAniPanel = new Panel(this);
			m_beingPanel = new Panel(this);
			m_topAniPanel = new Panel(this);
		}
		
		public function setWu(wu:WuProperty, being:UIMBeing):void
		{
			m_wu = wu;
			being.changeContainerParent(m_beingPanel);
			addAni();
		}
		public function clearWu():void
		{
			m_wu = null;
			clearAni();
		}
		
		protected function addAni():void
		{
			if (m_bgAni == null)
			{
				m_bgAni = new Ani(m_gkContext.m_context, m_bgAniPanel, 31, -16);
				m_bgAni.setParam(0, true, false, 2, true);				
				m_bgAni.setAutoStopWhenHide(true);
				
				m_topAni = new Ani(m_gkContext.m_context, m_topAniPanel, 31, -16);
				m_topAni.setParam(0, true, false, 2, true);
				m_topAni.setAutoStopWhenHide(true);
			}
			
			m_bgAni.setImageAni("ejzhengfaguixia.swf");
			m_topAni.setImageAni("ejzhengfaguishang.swf");
			m_bgAni.begin();
			m_topAni.begin();
		}
		protected function clearAni():void
		{
			if (m_bgAni)
			{
				m_bgAni.dispose();				
				m_topAni.dispose();
				m_bgAni = null;
				m_topAni = null;
			}
		}
		
		
	}

}