package modulefight.ui.battlehead 
{
	import com.bit101.components.AniScroll_CenterToTwoSide;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.label.LabelFormat;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import com.util.UtilColor;
	//import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class AniTips extends Component 
	{
		//private var m_gkContext:GkContext;
		private var m_bgCP:Component;
		private var m_scrollAni:AniScroll_CenterToTwoSide;
		private var m_tf:Label;
		
		public function AniTips(/*gk:GkContext,*/parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			//m_gkContext = gk;
			m_bgCP = new Component(this);
			m_bgCP.setSize(570, 40);
			m_bgCP.setHorizontalImageSkin("commoncontrol/horstretch/fighttips_mirror.png");
			
			m_scrollAni = new AniScroll_CenterToTwoSide(this, 300, 168);
			m_scrollAni.setParam(570, 40, 25, m_bgCP);
			m_scrollAni.wScroll = 0;
			
			m_tf = new Label(m_bgCP, 285, 8, "", UtilColor.WHITE, 12);
			m_tf.setLetterSpacing(1);
			m_tf.align = CENTER;
			this.setSize(570, 40);
		}
		public function beginPlay(str:String):void
		{
			if (!str)
			{
				return;
			}
			else
			{
				m_tf.text = str;
			}
			
			m_scrollAni.beginUnfold();
		}
		override public function dispose():void 
		{
			if (m_scrollAni)
			{
				if (m_scrollAni.parent)
				{
					m_scrollAni.parent.removeChild(m_scrollAni);
				}
				m_scrollAni.dispose();
				m_scrollAni = null;
			}
			super.dispose();
			
		}
	}

}