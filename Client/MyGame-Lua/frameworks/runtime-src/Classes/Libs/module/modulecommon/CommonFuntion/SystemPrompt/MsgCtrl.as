package modulecommon.commonfuntion.systemprompt 
{
	import com.ani.AniPropertys;
	import com.ani.AniPause;
	import com.bit101.components.Component;	
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;

	import modulecommon.GkContext;
	import com.gskinner.motion.easing.Quadratic;
	/**
	 * ...
	 * @author 
	 */
	public class MsgCtrl extends Component 
	{
		//动画播放的阶段定义
		public static const STATE_none:int = 0;
		public static const STATE_fadeIn:int = 1;
		public static const STATE_pause:int = 2;
		public static const STATE_fadeOut:int = 3;
		
		public var m_gkContext:GkContext;
		private var m_sysPrompt:SystemPromptMulti;
		private var m_format:MsgCtrl_format;
		
		private var m_state:int;
		private var m_tf:Label;
		private var m_ani:AniPropertys;
		private var m_aniPause:AniPause;
		public function MsgCtrl(gk:GkContext, sys:SystemPromptMulti, format:MsgCtrl_format) 
		{
			m_gkContext = gk;
			m_sysPrompt = sys;
			m_format = format;
			
			m_tf = new Label(this);		
			m_tf.width = 1000;
			m_tf.setFontColor(m_format.m_color);
			m_tf.setFontSize(26);
			m_tf.setBold(true);		
			m_tf.textField.filters = m_gkContext.m_context.m_globalObj.glowFilter;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			
			m_aniPause = new AniPause();
			m_aniPause.sprite = this;
			m_aniPause.onEnd = onPauseEnd;
		}
		public function begin():void
		{
			m_state = STATE_fadeIn;
			m_tf.htmlText = m_format.m_msg;
			m_tf.flush();
			this.x = (m_gkContext.m_context.m_config.m_curWidth - (m_tf.width + 4)) / 2;			
			
			this.alpha = 0;
			m_ani.resetValues( { alpha:1, y:m_sysPrompt.standardY } );
			m_ani.ease = Quadratic.easeIn;
			m_ani.duration = 0.2;
			m_ani.onEnd = onYPos;
			m_ani.begin();
			m_gkContext.m_UIMgr.addToTopMoseLayer(this);
			
		}
		public function onYPos():void
		{			
			m_state = STATE_pause;
			m_sysPrompt.onFadeInEnd(this);
			m_aniPause.delay = 1;
			m_aniPause.begin();
		}
		
		public function onPauseEnd():void
		{
			m_state = STATE_fadeOut;
			m_ani.resetValues( { alpha:0 } );
			m_ani.duration = 0.6;
			m_ani.onEnd = onFadeOut;
			m_ani.begin();
		}
		public function onFadeOut():void
		{
			m_state = STATE_none;
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			m_sysPrompt.onFadeOutEnd(this);
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			m_aniPause.dispose();
			super.dispose();
		}
		
		public function get isState_fadeIn():Boolean
		{
			return m_state == STATE_fadeIn;
		}
		
	}

}