package modulecommon.ui
{
	import com.ani.DigitAniBase;
	import com.ani.AniPropertys;
	import com.bit101.components.Window;
	
	/**
	 * ...
	 * @author
	 * Form对象淡入，淡出动画
	 */
	public class AniFormFade extends DigitAniBase
	{
		public static const STATE_Static:int = 0;
		public static const STATE_FadeIn:int = 1;
		public static const STATE_FadeOut:int = 2;
		
		private var m_state:int;
		private var m_form:Form;
		protected var m_aniAlpha:AniPropertys;
		
		public function AniFormFade(form:Form)
		{
			super();
			m_form = form;
			m_aniAlpha = new AniPropertys();
			m_aniAlpha.sprite = m_form;
			m_aniAlpha.useFrames = true;
		}
		
		override public function dispose():void
		{
			m_aniAlpha.dispose();
			m_form = null;
		}
		
		public function fadeIn():void
		{
			m_state=STATE_FadeIn;
			m_form.alpha = 0;
			m_aniAlpha.resetValues({alpha: 1});
			m_aniAlpha.duration = 4;
			m_aniAlpha.onEnd = onFadeInEnd;
			m_aniAlpha.begin();
		}
		
		public function fadeOut():void
		{
			m_state=STATE_FadeIn;
			m_form.alpha = 1;
			m_aniAlpha.resetValues({alpha: 0});
			m_aniAlpha.duration = 4;
			m_aniAlpha.onEnd = onExitFadeOut;
			m_aniAlpha.begin();
		}
		protected function onFadeInEnd():void
		{
			m_state = STATE_Static;
		}
		override public function stop():void
		{
			super.stop();
			m_aniAlpha.stop();
		}
		protected function onExitFadeOut():void
		{
			if (m_form.exitMode == Window.EXITMODE_DESTORY)
			{
				m_form.gkcontext.m_UIMgr.destroyForm(m_form.id);
			}
			else
			{
				m_form.gkcontext.m_UIMgr.hideForm(m_form.id);
			}
		}
	}

}