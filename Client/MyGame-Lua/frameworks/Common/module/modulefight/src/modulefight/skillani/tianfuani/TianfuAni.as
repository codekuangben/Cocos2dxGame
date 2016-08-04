package modulefight.skillani.tianfuani 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.ani.AniPropertys;
	/**
	 * ...
	 * @author ...
	 */
	public class TianfuAni extends Component
	{
		protected var m_context:Context;
		protected var m_ani:Ani;		
		protected var m_wordPanel:Panel;
		protected var m_timer:Timer;
		protected var m_aniPropertys:AniPropertys;
		//protected var m_side:int;
		
		public function TianfuAni(con:Context, side:int, nameWord:String) 
		{
			m_context = con;
			m_ani = new Ani(m_context);
			m_ani.centerPlay = true;
			m_ani.stop();
			this.addChild(m_ani);			
			m_ani.onCompleteFun = onAniComplete;
			//if (side == EntityCValue.RKLeft)
			//{
				m_ani.setImageAni("ejfazhaotianfu.swf");
			//}
			/*else
			{
				m_ani.setImageAniMirror("ejfazhaotianfu.swf", Image.MirrorMode_HOR);
			}		*/
			
			m_ani.duration = 0.3;
			m_ani.repeatCount = 1;			
			
			m_wordPanel = new Panel(this, -25,-44);
			m_wordPanel.setPanelImageSkin("tianfu/" + nameWord);
			
			m_timer = new Timer(800);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);	
			m_timer.repeatCount = 1;
			
			m_aniPropertys = new AniPropertys();
			m_aniPropertys.sprite = this;
			m_aniPropertys.onEnd = fadeOut;			
		}
		public function begin():void
		{
			m_ani.begin();
			this.alpha = 1;			
		}
		public function get isStop():Boolean
		{
			return m_ani.isStop;
		}
		override public function dispose():void
		{
			if (m_ani)
			{
				m_ani.dispose();			
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
			m_aniPropertys.duration = 0.6;
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