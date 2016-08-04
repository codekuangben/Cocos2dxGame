package game.ui.uiHero 
{
	import com.bit101.components.Ani;
	
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author 
	 * 这个类用于在屏幕的某个位置播放特效
	 */
	public class AniInScreen 
	{
		private var m_ui:UIHero;
		private var m_gkContext:GkContext;		
		private var m_offsetX:Number;
		private var m_offsetY:Number;
		
		private var m_aniTaskSubmit:Ani;
		private var m_aniAutoWalk:Ani;		// 自动寻路
		
		public function AniInScreen(gk:GkContext, ui:UIHero) 
		{
			m_gkContext = gk;
			m_ui = ui;
			m_offsetX = -3;
			m_offsetY = -5;
		}
		
		// 分辨率改变
		public function onStageReSize():void
		{
			if (m_aniAutoWalk && m_aniAutoWalk.parent)
			{
				m_aniAutoWalk.x = m_gkContext.m_context.m_config.m_curWidth / 2;
				m_aniAutoWalk.y = m_gkContext.m_context.m_config.m_curHeight / 2 - 200;
			}
		}
		
		public function showTaskSubmitAni():void
		{
			if (m_aniTaskSubmit==null)
			{
				m_aniTaskSubmit = new Ani(m_gkContext.m_context);
				m_aniTaskSubmit.setImageAni("ejrenwuwancheng.swf");
				m_aniTaskSubmit.centerPlay = true;				
				m_aniTaskSubmit.duration = 1.5;
				m_aniTaskSubmit.onCompleteFun = onEndAniTaskSubmit;
			}
			if (m_aniTaskSubmit.parent == null)
			{ 
				m_ui.addChild(m_aniTaskSubmit);				
			}
			m_aniTaskSubmit.begin();
			m_aniTaskSubmit.x = m_offsetX+m_gkContext.m_context.m_config.m_curWidth / 2;
			m_aniTaskSubmit.y = m_offsetY+m_gkContext.m_context.m_config.m_curHeight*0.4;
		}

		private function onEndAniTaskSubmit(ani:Ani):void
		{
			if (m_aniTaskSubmit.parent)
			{
				m_aniTaskSubmit.parent.removeChild(m_aniTaskSubmit);
			}
		}
		
		public function toggleAutoWay(bshow:Boolean):void
		{
			if(bshow)
			{
				if (!m_aniAutoWalk)
				{
					m_aniAutoWalk = new Ani(m_gkContext.m_context);
					m_aniAutoWalk.setImageAni("ejzidongxunlu.swf");
					m_aniAutoWalk.centerPlay = true;
					m_aniAutoWalk.duration = 1.5;
					m_aniAutoWalk.repeatCount = int.MAX_VALUE;	// 无限循环播放
					m_aniAutoWalk.onCompleteFun = onEndAniTaskSubmit;
				}
				if (!m_aniAutoWalk.parent)
				{ 
					m_ui.addChild(m_aniAutoWalk);				
				}
				m_aniAutoWalk.begin();
				m_aniAutoWalk.x = m_gkContext.m_context.m_config.m_curWidth / 2;
				m_aniAutoWalk.y = m_gkContext.m_context.m_config.m_curHeight / 2 - 200;
			}
			else
			{
				if(m_aniAutoWalk)
				{
					m_aniAutoWalk.stop();
					if(m_ui.contains(m_aniAutoWalk))
					{
						m_ui.removeChild(m_aniAutoWalk);
					}
				}
			}
		}
	}
}