package modulecommon.commonfuntion.systempromt_bottom 
{
	import com.ani.AniPropertys;
	import com.ani.AniPause;
	import com.bit101.components.Component;	
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.util.UtilFont;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import com.gskinner.motion.easing.Quadratic;
	
	/**
	 * ...
	 * @author 
	 */
	public class MsgCtrol_Bottom extends PanelContainer 
	{
		//动画播放的阶段定义
		public static const STATE_none:int = 0;
		public static const STATE_fadeIn:int = 1;
		public static const STATE_pause:int = 2;
		public static const STATE_fadeOut:int = 3;
		
		public var m_gkContext:GkContext;
		private var m_sysPrompt:SystemPrompt_Bottom;
		
		private var m_state:int;
		private var m_tf:Label;
		private var m_ani:AniPropertys;
		private var m_aniPause:AniPause;
		public function MsgCtrol_Bottom(gk:GkContext, sys:SystemPrompt_Bottom) 
		{
			setPanelImageSkin("commoncontrol/panel/announcementbg.png");
			m_gkContext = gk;
			m_sysPrompt = sys;
			
			var filter:GlowFilter = new GlowFilter(0xEB3ACF, 0.9, 6,6,2, BitmapFilterQuality.HIGH, false, false);
			
			var dropFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0xEB3ACF, 0.5, 16, 16, 5, BitmapFilterQuality.HIGH, false, false );
			var arFilter:Array = [filter, dropFilter];
			
			m_tf = new Label(this, 487 / 2, 37);
			m_tf.setBold(true);
			m_tf.setFontName(UtilFont.NAME_HuawenXinwei);
			m_tf.setFontSize(24);
			m_tf.align = CENTER;			
			m_tf.filters = arFilter;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			
			m_aniPause = new AniPause();
			m_aniPause.sprite = this;
			m_aniPause.onEnd = onPauseEnd;
			
		}
		public function begin(text:String):void
		{
			m_state = STATE_fadeIn;
			m_tf.text = text;
			this.x = (m_gkContext.m_context.m_config.m_curWidth - (487)) / 2;			
			
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
			m_aniPause.delay = 2;
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