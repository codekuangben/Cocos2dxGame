package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.ani.AniComposeSequence;
	import com.ani.AniPosition;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.easing.Circular;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.easing.Sine;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class AniMoving extends Component
	{
		public static const DIRECTION_Left:int = 1;		//向左
		public static const DIRECTION_Right:int = 2;	//向右
		public static const DIRECTION_Top:int = 3;		//向上
		public static const DIRECTION_Down:int = 4;		//向下
		
		private var m_aniSeq:AniComposeSequence;		// 序列执行动画
		private var m_arrowAni:AniPosition;
		private var m_arrowAni2:AniPosition;
		private var m_panel:Panel;
		
		public function AniMoving(paren:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(paren, xpos, ypos);
			
			m_aniSeq = new AniComposeSequence();
			m_panel = new Panel(this);
			
			m_arrowAni = new AniPosition();
			m_arrowAni.sprite = m_panel;
			m_arrowAni.repeatCount = 1;
			m_arrowAni.duration = 1.0;
			m_arrowAni.ease = Quadratic.easeInOut;
			
			m_arrowAni2 = new AniPosition();
			m_arrowAni2.sprite = m_panel;
			m_arrowAni2.repeatCount = 1;
			m_arrowAni2.duration = 1.0;
			m_arrowAni2.ease = Quadratic.easeInOut;
		}
		
		public function setParam(image:String, bMirror:Boolean, imageW:Number, imageH:Number, direction:int = DIRECTION_Right, duration:Number = 1.3):void
		{
			if (bMirror)
			{
				m_panel.setPanelImageSkinMirror(image, Image.MirrorMode_HOR);
			}
			else
			{
				m_panel.setPanelImageSkin(image);
			}
			
			m_panel.setSize(imageW, imageH);
			m_panel.setPos( -imageW / 2, -imageH / 2);
			
			m_arrowAni.duration = duration;
			m_arrowAni2.duration = duration;
			
			var beginX:Number;
			var beginY:Number;
			var endX:Number;
			var endY:Number;
			switch(direction)
			{
				case DIRECTION_Left:
					beginX = this.x + 15;
					beginY = this.y;
					endX = this.x - 15;
					endY = this.y;
					break;
				case DIRECTION_Right:
					beginX = this.x - 15;
					beginY = this.y;
					endX = this.x + 15;
					endY = this.y;
					break;
				case DIRECTION_Top:
					beginX = this.x;
					beginY = this.y + 15;
					endX = this.x;
					endY = this.y - 15;
					break;
				case DIRECTION_Down:
					beginX = this.x;
					beginY = this.y - 15;
					endX = this.x;
					endY = this.y + 15;
					break;
			}
			m_arrowAni.setBeginPos(beginX, beginY);
			m_arrowAni.setEndPos(endX, endY);
			m_arrowAni2.setBeginPos(endX, endY);
			m_arrowAni2.setEndPos(beginX, beginY);
			
			m_aniSeq.setAniList([m_arrowAni, m_arrowAni2]);
			m_aniSeq.sprite = this;
			m_aniSeq.onEnd = onAniComposeSequenceEnd;
		}
		
		private function onAniComposeSequenceEnd():void
		{
			m_aniSeq.begin();
		}
		
		public function begin():void
		{
			m_aniSeq.begin();
		}
		
		public function end():void
		{
			this.dispose();
		}
		
		override public function dispose():void
		{
			if (m_aniSeq)
			{
				m_aniSeq.dispose();
			}
			
			super.dispose();
		}
	}

}