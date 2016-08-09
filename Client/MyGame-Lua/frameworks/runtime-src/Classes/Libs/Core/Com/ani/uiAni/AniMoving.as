package com.ani.uiAni 
{
	import com.ani.AniComposeSequence;
	import com.ani.AniPosition;
	import com.ani.DigitAniBase;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	/**
	 * ...
	 * @author ...
	 * 显示对象，在某一方向的特定范围内，来回移动
	 */
	public class AniMoving extends DigitAniBase
	{
		public static const DIRECTION_Left:int = 1;		//向左
		public static const DIRECTION_Right:int = 2;	//向右
		public static const DIRECTION_Top:int = 3;		//向上
		public static const DIRECTION_Down:int = 4;		//向下
		
		private var m_aniSeq:AniComposeSequence;		// 序列执行动画
		private var m_arrowAni:AniPosition;
		private var m_arrowAni2:AniPosition;
		
		public function AniMoving() 
		{
			super();
			
			m_aniSeq = new AniComposeSequence();
			
			m_arrowAni = new AniPosition();
			m_arrowAni.repeatCount = 1;
			m_arrowAni.duration = 1.0;
			m_arrowAni.ease = Quadratic.easeInOut;
			
			m_arrowAni2 = new AniPosition();
			m_arrowAni2.repeatCount = 1;
			m_arrowAni2.duration = 1.0;
			m_arrowAni2.ease = Quadratic.easeInOut;
			
			m_aniSeq.setAniList([m_arrowAni, m_arrowAni2]);
			m_aniSeq.onEnd = onAniComposeSequenceEnd;
		}
		
		override public function set sprite(value:Object):void 
		{
			super.sprite = value;
			
			m_arrowAni.sprite = value;
			m_arrowAni2.sprite = value;
			m_aniSeq.sprite = value;
		}
		
		//设置移动轨迹方式
		public function setEase(easeFn:Function = null, ease2Fn:Function = null):void
		{
			m_arrowAni.ease = easeFn;
			m_arrowAni2.ease = ease2Fn;
		}
		
		//posX,posY:对象相对移动的中心点	interval:移动间距	duration:动画速度	direction:移动方向
		public function setParam(posX:Number, posY:Number, interval:Number = 15, duration:Number = 1.3, direction:int = DIRECTION_Top):void
		{
			m_arrowAni.duration = duration;
			m_arrowAni2.duration = duration;
			
			var beginX:Number;
			var beginY:Number;
			var endX:Number;
			var endY:Number;
			
			switch(direction)
			{
				case DIRECTION_Left:
					beginX = posX + interval;
					beginY = posY;
					endX = posX - interval;
					endY = posY;
					break;
				case DIRECTION_Right:
					beginX = posX - interval;
					beginY = posY;
					endX = posX + interval;
					endY = posY;
					break;
				case DIRECTION_Top:
					beginX = posX;
					beginY = posY + interval;
					endX = posX;
					endY = posY - interval;
					break;
				case DIRECTION_Down:
					beginX = posX;
					beginY = posY - interval;
					endX = posX;
					endY = posY + interval;
					break;
			}
			m_arrowAni.setBeginPos(beginX, beginY);
			m_arrowAni.setEndPos(endX, endY);
			m_arrowAni2.setBeginPos(endX, endY);
			m_arrowAni2.setEndPos(beginX, beginY);
		}
		
		private function onAniComposeSequenceEnd():void
		{
			m_aniSeq.begin();
		}
		
		override public function begin():void
		{
			super.begin();
			m_aniSeq.begin();
		}
		
		override public function stop():void
		{
			m_aniSeq.stop();
			super.stop();			
		}
		
		override public function dispose():void 
		{
			m_aniSeq.dispose();
			m_aniSeq = null;
			
			//m_arrowAni.dispose(); //m_aniSeq.dispose()中调用
			//m_arrowAni2.dispose();//m_aniSeq.dispose()中调用
			
			super.dispose();
		}
		
	}

}