package game.ui.aniRewarded 
{
	import com.bit101.components.Component;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIAniRewarded;
	/**
	 * ...
	 * @author ...
	 * 获得奖励提示:燃烧的火向两边展开
	 */
	public class UIAniRewarded extends Form implements IUIAniRewarded
	{
		private var m_aniCtrl:AniCtrl;
		private var m_timer:Timer;
		private var m_param:Object;
		
		public function UIAniRewarded() 
		{
			super();
			
			this.setSize(672, 424);
			this.alignVertial = Component.TOP;
			this.marginTop = -40;
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		override public function onReady():void 
		{
			super.onReady();
			
			m_aniCtrl = new AniCtrl(m_gkcontext, this, this);
		}
		
		override public function adjustPosWithAlign():void
		{
			if (undefined != m_param["uigamble"])
			{
				var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGamble);
				if (form.isVisible())
				{
					this.setPos(form.x + 210, form.y - 20);
				}
			}
			else
			{
				super.adjustPosWithAlign();
			}
		}
		
		//com显示位置，取中心点对齐
		public function setDetail(param:Object):void
		{
			m_param = param;
			m_aniCtrl.beginPlay(param);
			
			this.show();
		}
		
		public function onAniRewardedEnd():void
		{
			if (null == m_timer)
			{
				m_timer = new Timer(1000); //1秒
				m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer.repeatCount = 1;
			}
			m_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			this.exit();
		}
		
		override public function onDestroy():void 
		{
			if(m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer = null;
			}
			
			super.onDestroy();
		}
	}

}