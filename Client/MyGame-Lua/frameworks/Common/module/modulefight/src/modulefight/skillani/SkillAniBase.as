package modulefight.skillani 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.ani.AniPropertys;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SkillAniBase extends Sprite 
	{
			
		protected var m_con:Context;
		protected var m_aniLeft:Ani;
		protected var m_aniRight:Ani;
		protected var m_wordPanel:Panel;
		protected var m_timer:Timer;
		protected var m_aniPropertys:AniPropertys;
		
		public function SkillAniBase(con:Context)
		{
			m_con = con;
			
			m_aniRight = new Ani(m_con);
			m_aniRight.centerPlay = true;
			m_aniRight.stop();
			this.addChild(m_aniRight);			
			m_aniRight.onCompleteFun = onAniComplete;
			
			m_aniLeft = new Ani(m_con);
			m_aniLeft.centerPlay = true;
			m_aniLeft.stop();
			this.addChild(m_aniLeft);			
			m_aniLeft.onCompleteFun = onAniComplete;
			
			m_wordPanel = new Panel(this);
			
			m_timer = new Timer(400);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);	
			m_timer.repeatCount = 1;
			
			m_aniPropertys = new AniPropertys();
			m_aniPropertys.sprite = this;
			m_aniPropertys.onEnd = fadeOut;
		}
		
		public function dispose():void
		{
			if (m_aniLeft)
			{
				m_aniLeft.dispose();
				m_aniRight.dispose();
				m_wordPanel.dispose();
			}
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer = null;
		}				
		
		protected function onAniComplete(ani:Ani):void
		{
			m_timer.reset();
			m_timer.start();
		}
		
		protected function onTimer(e:TimerEvent):void
		{
			m_aniPropertys.resetValues( {alpha:0} );
			m_aniPropertys.duration = 0.3;
			m_aniPropertys.begin();
		}
		
		protected function fadeOut():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}

}