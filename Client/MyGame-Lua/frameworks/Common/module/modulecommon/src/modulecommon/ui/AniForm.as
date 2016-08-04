package modulecommon.ui 
{
	import com.ani.AniPropertys;
	import com.ani.DigitAniBase;
	import com.bit101.components.Window;
	import flash.geom.Point;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class AniForm extends DigitAniBase 
	{
		public static const STATE_Static:int = 0;
		public static const STATE_AniShow:int = 1;
		public static const STATE_AniHide:int = 2;
		
		private var m_state:int;
		private var m_form:Form;
		protected var m_aniAlpha:AniPropertys;
		protected var m_aniSpeed:Number;	//关闭(或打开)界面动画的速度。单位:像素/帧
		public function AniForm(form:Form) 
		{
			super();
			m_form = form;
			
			m_aniAlpha = new AniPropertys();
			m_aniAlpha.sprite = m_form;
			m_aniAlpha.useFrames = true;
			m_aniSpeed = 160;
		}
		
		public function playAniForShow():void
		{
			var destPos:Point = m_form.getDestPosForShow();
			var sorPos:Point = m_form.getDestPosForHide();
			if (sorPos == null)
			{
				m_form.resetShowParam();
				return;
			}			
			
			m_form.alpha = 0;
			m_form.scaleX = 0;
			m_form.scaleY = 0;
			m_form.x = sorPos.x;
			m_form.y = sorPos.y;
			m_form.mouseChildren = false;
			m_form.mouseEnabled = false;
			
			var distance:Number = mathUtils.distance(m_form.x, m_form.y, destPos.x+m_form.width/2, destPos.y+m_form.height/2);
			
			m_state = STATE_AniShow;
			m_aniAlpha.onEnd = onEndPlayAniForShow;
			m_aniAlpha.resetValues({alpha: 1, scaleX: 1, scaleY: 1, x: destPos.x, y: destPos.y});
			m_aniAlpha.duration = distance/m_aniSpeed;
			m_aniAlpha.begin();
		}
		
		protected function onEndPlayAniForShow():void
		{		
			m_form.mouseChildren = true;
			m_form.mouseEnabled = true;
			m_state = STATE_Static;
		}
		override public function stop():void
		{
			super.stop();
			m_aniAlpha.stop();
		}
		/*
		 * 以动画的方式隐藏：即：淡出、缩小、移动3种动画同时进行
		 */
		public function playAniForHide():void
		{
			m_form.mouseChildren = false;
			m_form.mouseEnabled = false;		
			var destPos:Point = m_form.getDestPosForHide();
			if (destPos == null)
			{
				onEndPlayAniForHide();				
				return;
			}
		
			m_state = STATE_AniHide;
			var distance:Number = mathUtils.distance(m_form.x+m_form.width/2, m_form.y+m_form.height/2, destPos.x, destPos.y);
			
			m_aniAlpha.onEnd = onFirstStepEndForHide;
			m_aniAlpha.resetValues({alpha: 0.3, scaleX: 25/m_form.width, scaleY: 35/m_form.height, x: destPos.x, y: destPos.y});
			m_aniAlpha.duration = distance/m_aniSpeed;
			m_aniAlpha.begin();
		}
		
		protected function onFirstStepEndForHide():void
		{
			m_aniAlpha.resetValues( { alpha: 0 } );
			m_aniAlpha.onEnd = onEndPlayAniForHide;
			m_aniAlpha.duration = 4;
			m_aniAlpha.begin();
		}
		
		protected function onEndPlayAniForHide():void
		{
			m_form.mouseChildren = true;
			m_form.mouseEnabled = true;
			m_state = STATE_Static;
			if (m_form.exitMode == Window.EXITMODE_DESTORY)
			{
				m_form.gkcontext.m_UIMgr.destroyForm(m_form.id);
			}
			else
			{
				m_form.gkcontext.m_UIMgr.hideForm(m_form.id);
			}
		} 
		
		
		override public function dispose():void
		{
			m_aniAlpha.dispose();
			m_form = null;
		}
		public function set aniSpeed(s:Number):void
		{
			m_aniSpeed = s;
		}
		
		public function get state():int
		{
			return m_state;
		}
		
	}

}