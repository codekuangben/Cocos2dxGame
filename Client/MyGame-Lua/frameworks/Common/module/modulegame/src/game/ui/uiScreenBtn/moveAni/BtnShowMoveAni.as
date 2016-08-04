package game.ui.uiScreenBtn.moveAni 
{
	import com.ani.AniComposeParallel;
	import com.ani.AniComposeSequence;
	import com.ani.AniPropertys;
	import com.ani.AniToDestPostion_BezierCurve2;
	import com.ani.DigitAniBase;
	/**
	 * ...
	 * @author ...
	 * 活动按钮展开显示动画
	 */
	public class BtnShowMoveAni extends DigitAniBase
	{
		private var m_ani:AniComposeSequence;
		private var m_firstAni:AniToDestPostion_BezierCurve2;
		private var m_funEndCalback:Function;
		
		public function BtnShowMoveAni() 
		{
			super();
			
			m_ani = new AniComposeSequence();
			
			var firstStepAni:AniComposeParallel = new AniComposeParallel();
			var alphaAniForFirst:AniPropertys = new AniPropertys();
			alphaAniForFirst.resetValues( { alpha:0.8 } );
			alphaAniForFirst.useFrames = true;
			alphaAniForFirst.duration = 20;
			
			m_firstAni = new AniToDestPostion_BezierCurve2();
			m_firstAni.useFrames = true;
			m_firstAni.duration = 20;
			
			firstStepAni.setAniList([alphaAniForFirst, m_firstAni]);
			
			var secAni:AniPropertys = new AniPropertys();
			secAni.resetValues( { alpha:1 } );
			secAni.useFrames = true;
			secAni.duration = 5;
			
			m_ani.onEnd = onAniEnd;
			m_ani.setAniList([firstStepAni, secAni]);
		}
		
		override public function set sprite(value:Object):void 
		{
			super.sprite = value;
			m_ani.sprite = value;
		}
		
		public function setDestPos(destX:Number, destY:Number):void
		{
			m_firstAni.setDestPos(destX, destY);
		}
		
		override public function begin():void
		{
			m_sp.visible = true;
			m_ani.begin();
		}
		
		private function onAniEnd():void
		{
			if (m_funEndCalback != null)
			{
				m_funEndCalback();
			}
		}
		
		override public function dispose():void 
		{
			m_ani.dispose();
			m_ani = null;
			super.dispose();		
		}
		
		public function set funEndCalback(fun:Function):void
		{
			m_funEndCalback = fun;
		}
	}

}