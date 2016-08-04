package game.ui.zhanliAdvance 
{
	import com.ani.AniComposeParallel;
	import com.ani.AniComposeSequence;
	import com.ani.AniXml;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.AniScroll_CenterToTwoSide;
	import modulecommon.appcontrol.DigitComponentWidthSign;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class ZhanliCtrl extends Component 
	{		
		//动画步骤
		public static const SETP_Idle:int = 0;	//空闲
		public static const SETP_BGUnfold:int = 1;	//背景展开
		public static const SETP_FadeOut:int = 2;	//淡出
		
		private var m_step:int;
		private var m_bgAni:AniScroll_CenterToTwoSide;
		private var m_panel:Panel;
		private var m_digit:DigitComponentWidthSign;
		private var m_ani:AniXml;
		private var m_ui:UIZhanliAdvance_ValueAni;
		public function ZhanliCtrl(con:Context, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_ui = parent as UIZhanliAdvance_ValueAni;
			
			m_panel = new Panel();
			m_panel.x = 18;
			var panel:Panel = new Panel(m_panel);
			panel.setPanelImageSkin("commoncontrol/panel/word_zhanlitisheng.png");
			m_digit = new DigitComponentWidthSign(con, m_panel,120, 6);
			m_digit.setParam("commoncontrol/digit/digit02", 16, 35, "commoncontrol/digit/digit02/add.png", 0, 23);
			
			m_bgAni = new AniScroll_CenterToTwoSide(this);
			m_bgAni.setParam(230, 37, 10, m_panel);
			m_bgAni.addEventListener(Event.COMPLETE, onBgAniComplete);
			
			var xml:XML=<ani>
	<AniComposeSequence>
		<AniPause delay="15" useFrames="1"/>
		<AniComposeParallel>
			<AniToDestPostion_BezierCurve1 relativePos="1" destX="" destY="-100" duration="30" useFrames="1" ease="EASE_Cubic_easeIn"/>
			<AniPropertys attributes="alpha=0" duration="30" useFrames="1" ease="EASE_Cubic_easeIn"/>
		</AniComposeParallel>
	</AniComposeSequence>
</ani>
			m_ani = new AniXml();
			m_ani.parseXML(xml);
			m_ani.sprite = this;
			m_ani.onEnd = onAniEnd;
		}
		
		public function begin(n:int):void
		{			
			m_step = SETP_BGUnfold;
			this.y = 0;
			this.alpha = 1;
			m_digit.digit = n;
			m_bgAni.beginUnfold();
			
		}
		
		private function onBgAniComplete(e:Event):void
		{			
			m_step = SETP_FadeOut;
			m_ani.begin();
		}
		
		private function onAniEnd():void
		{
			m_step = SETP_Idle;
			m_ui.exit();
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();
		}
		public function get step():int
		{
			return m_step;
		}
	}

}