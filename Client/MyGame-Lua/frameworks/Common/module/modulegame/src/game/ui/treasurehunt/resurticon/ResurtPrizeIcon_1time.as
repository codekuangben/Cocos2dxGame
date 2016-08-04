package game.ui.treasurehunt.resurticon 
{
	import com.ani.AniToDestPostion_BezierCurve2;
	import com.ani.AniXml;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 * 一次抽奖
	 */
	public class ResurtPrizeIcon_1time extends ResurtPrizeIcon_Base 
	{		
		private var m_sorPosX:Number;
		private var m_sorPosY:Number;
		public var m_desPosX:Number;
		public var m_desPosY:Number;
		public var m_midPosX:Number;
		public var m_midPosY:Number;
		private var m_pathAni:AniXml;
		private var m_bc2:AniToDestPostion_BezierCurve2;
		
		public function ResurtPrizeIcon_1time(gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, parent, xpos, ypos);
			
			var xml:XML=<ani>
	<AniComposeSequence>
		<AniComposeParallel>
			<AniPropertys attributes="alpha=1" duration="2" ease="EASE_Exponential_easeOut" useFrames="1"/>
			<AniToDestPostion_BezierCurve2  id="1" destX="220" destY="226" duration="10" useFrames="1" />
		</AniComposeParallel>
		<AniPause delay="10" useFrames="1"/>
	</AniComposeSequence>
</ani>
			
			m_pathAni = new AniXml();
			m_pathAni.parseXML(xml);
			m_pathAni.sprite = this;
			m_pathAni.onEnd = onAniEnd;
			m_bc2 = m_pathAni.getAniByID(1) as AniToDestPostion_BezierCurve2;
		}
		public function setSorPos(aniX:Number = 0, aniY:Number = 0):void
		{
			m_sorPosX = aniX;
			m_sorPosY = aniY;
			this.setPos(m_sorPosX, m_sorPosY);
			this.alpha = 0;
		}
		override public function begin():void//飞到中间位置
		{
			super.begin();
			m_pathAni.begin();
		}
		public function setMidPos(aniX:Number = 0, aniY:Number = 0):void
		{
			m_midPosX = aniX;
			m_midPosY = aniY;
			m_bc2.setDestPos(m_midPosX, m_midPosY);
		}
		private function onAniEnd():void
		{
			flyToPackageBtn(new Point(m_desPosX,m_desPosY));
		}
		public function setAutoPlayEndAni(isplay:Boolean = true):void
		{
			if (isplay)
			{
				m_pathAni.onEnd = onAniEnd;
			}
			else
			{
				m_pathAni.onEnd = null;
			}
		}
		
		override public function dispose():void 
		{
			m_pathAni.dispose();
			super.dispose();
		}
		public function setDesPos(aniX:Number = 0, aniY:Number = 0):void
		{
			m_desPosX = aniX;
			m_desPosY = aniY;
		}
		public function prompt():void//返回抽奖获得物品的string供文字显示
		{
		}
	}

}