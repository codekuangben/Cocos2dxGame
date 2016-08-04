package game.ui.uiblack
{
	import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.gskinner.motion.easing.Linear;
	import modulecommon.time.Daojishi;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * @brief 过地图一个界面
	 */
	public class UIBlack extends Form
	{
		protected var m_pnlBlack:Panel;		// 黑色地图
		protected var m_aniFadeInOut:AniPropertys;	// 淡入淡出
		private var m_daojishi:Daojishi;

		public function UIBlack()
		{
			this.id = UIFormID.UIBlack;
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.LEFT;
			this.exitMode = EXITMODE_HIDE;
			
			m_pnlBlack = new Panel(this);
			m_pnlBlack.autoSizeByImage = false;
			m_pnlBlack.setSize(m_gkcontext.m_context.m_config.m_curWidth, m_gkcontext.m_context.m_config.m_curHeight);
			m_pnlBlack.setPanelImageSkin("commoncontrol/panel/blackbg.jpg");
			
			m_daojishi = new Daojishi(m_gkcontext.m_context);
			m_daojishi.timeMode = Daojishi.TIMEMODE_1Second;
			m_daojishi.funCallBack = updateDaojishi;
		}
		
		override public function onShow():void
		{
			super.onShow();
			m_pnlBlack.alpha = 1;
			//startFadeIn();
			beginDaojishi(1000);
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
			// 调整底图位置
			m_pnlBlack.setSize(m_gkcontext.m_context.m_config.m_curWidth, m_gkcontext.m_context.m_config.m_curHeight);
		}
		
		// 开始渐变
		protected function startFadeIn():void
		{
			m_pnlBlack.alpha = 0;
			m_aniFadeInOut = new AniPropertys();
			m_aniFadeInOut.sprite = m_pnlBlack;
			m_aniFadeInOut.duration = 0.5;
			m_aniFadeInOut.ease = Linear.easeNone;
			m_aniFadeInOut.resetValues({alpha:1});
			m_aniFadeInOut.onEnd = fadeInAniEnd;
			m_aniFadeInOut.begin();
		}
		
		// 开始渐变
		protected function startFadeOut():void
		{
			m_aniFadeInOut = new AniPropertys();
			m_aniFadeInOut.sprite = m_pnlBlack;
			m_aniFadeInOut.duration = 0.5;
			m_aniFadeInOut.ease = Linear.easeNone;
			m_aniFadeInOut.resetValues({alpha:0});
			m_aniFadeInOut.onEnd = fadeOutAniEnd;
			m_aniFadeInOut.begin();
		}
		
		protected function fadeInAniEnd():void
		{
			beginDaojishi(1000);
		}
		
		protected function fadeOutAniEnd():void
		{
			hide();
		}
		
		//单位毫秒
		public function beginDaojishi(leftTime:int):void
		{
			m_daojishi.end();

			m_daojishi.initLastTime = leftTime;
			m_daojishi.begin();
			//updateDaojishi(m_daojishi);
		}
		
		public function updateDaojishi(d:Daojishi):void
		{	
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				startFadeOut();
			}
		}
	}
}