package game.ui.tongquetai.forestage 
{
	import com.ani.AniPropertys;
	import com.ani.DigitAniBase;
	import com.bit101.components.Panel;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AniPanel extends DigitAniBase 
	{
		private var m_panel:Panel;
		protected var m_aniAlpha:AniPropertys;
		protected var m_aniSpeed:Number;	//关闭(或打开)界面动画的速度。单位:像素/帧
		private var m_desx:Number;
		private var m_desy:Number;
		public function AniPanel(panel:Panel) 
		{
			super();
			m_panel = panel;
			m_aniAlpha = new AniPropertys();
			m_aniAlpha.sprite = m_panel;
			m_aniAlpha.useFrames = true;
			m_aniSpeed = 1;
		}
		public function playAniForShow(sorx:Number,sory:Number,desx:Number,desy:Number):void
		{
			m_desx = desx;
			m_desy = desy;
			m_panel.alpha = 0;
			m_panel.scaleX = 0;
			m_panel.scaleY = 0;
			m_panel.x = sorx;
			m_panel.y = sory;
			//var distance:Number = mathUtils.distance(m_panel.x, m_panel.y, desx, desy);
			m_aniAlpha.onEnd = playAniForHide;
			m_aniAlpha.resetValues({alpha: 1, scaleX: 1, scaleY: 1, x: desx, y: desy});
			m_aniAlpha.duration = 32;
			m_aniAlpha.begin();
		}
		
		public function playAniForHide():void
		{	
			//var distance:Number = mathUtils.distance(m_panel.x, m_panel.y, m_desx,m_desy);
			m_aniAlpha.delay = 5;
			m_aniAlpha.resetValues({alpha: 0, scaleX:0, scaleY:0, x: m_panel.x, y: m_panel.y});
			m_aniAlpha.duration = 32;
			m_aniAlpha.begin();
		}
		override public function dispose():void
		{
			m_aniAlpha.dispose();
			m_panel = null;
		}
		public function set aniSpeed(s:Number):void
		{
			m_aniSpeed = s;
		}
	}

}