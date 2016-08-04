package game.ui.treasurehunt.resurticon 
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.Timer;
	import game.ui.treasurehunt.midPart;
	import modulecommon.GkContext;
	import com.ani.AniXml;
	import com.ani.AniToDestPostion_BezierCurve2;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResurtPrizeIcon_Base extends Component 
	{
		protected var m_midPart:midPart;
		protected var m_gkContext:GkContext;	
		private var m_aniPathToDest:AniXml;
		public function ResurtPrizeIcon_Base(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			
			var xml:XML=<ani>
	<AniComposeSequence>
		<AniToDestPostion_BezierCurve2  id="1" destX="200" destY="200" duration="15" useFrames="1" />
		<AniComposeParallel>
			<AniPropertys attributes="alpha=0 scaleX=0 scaleY=0" duration="5" useFrames="1"/>			
		</AniComposeParallel>
	</AniComposeSequence>
</ani>
			
			m_aniPathToDest = new AniXml();
			m_aniPathToDest.parseXML(xml);
			m_aniPathToDest.sprite = this;
			m_aniPathToDest.onEnd = onAniPathToDestEnd;
		}
		public function setMidPart(midPart:midPart):void
		{
			m_midPart = midPart;
		}
		public function begin():void
		{
			
		}
		
		public function flyToPackageBtn(dest:Point):void//飞到包裹中动画 渐透明
		{
			var bc2:AniToDestPostion_BezierCurve2 = m_aniPathToDest.getAniByID(1) as AniToDestPostion_BezierCurve2;
			bc2.setDestPos(dest.x, dest.y);
			m_aniPathToDest.begin();
		}
		private function onAniPathToDestEnd():void
		{
			m_midPart.onPrizeIconAniEnd(this);
		}
		override public function dispose():void 
		{			
			m_aniPathToDest.dispose();
			super.dispose();
		}
	}

}