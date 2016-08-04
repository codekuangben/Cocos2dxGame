package game.ui.announcement 
{
	import com.bit101.components.AniScroll_CenterToTwoSide;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;	
	import flash.events.Event;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AnnCtrl extends Component 
	{
		//动画步骤
		public static const SETP_Idle:int = 0;	//空闲
		public static const SETP_BGUnfold:int = 1;	//背景展开
		public static const SETP_Marquee:int = 2;	//文字从右向左移动
		public static const SETP_BGFold:int = 3;	//背景合上（折叠）
		
		private var m_step:int;
		private var m_bgAni:AniScroll_CenterToTwoSide;
		private var m_ann:MarqueeAnn;
		private var m_gkContext:GkContext;
		private var m_ui:UIAnnouncement;
		public function AnnCtrl(ui:UIAnnouncement, gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);	
			m_gkContext = gk;
			m_ui = ui;
			var panel:Panel = new Panel();
			panel.setPanelImageSkin("commoncontrol/panel/announcementbg.png");
			m_bgAni = new AniScroll_CenterToTwoSide(this);
			m_bgAni.setParam(487, 95, 20, panel);
			//m_bgAni.imagePanel.setPanelImageSkin("commoncontrol/panel/announcementbg.png");
			m_bgAni.wScroll = 0;
			
			m_bgAni.addEventListener(Event.COMPLETE, onBgAniComplete);
			m_ann = new MarqueeAnn(m_gkContext.m_context, this);
			m_ann.x = -m_ann.width / 2;			
			m_ann.addEventListener(Event.COMPLETE, onAnnComplete);
		}
		
		public function begin(text:String):void
		{
			m_step = SETP_BGUnfold;
			m_ann.setText(text);
			m_ann.reset();
			m_bgAni.beginUnfold();
		}
		
		private function onBgAniComplete(e:Event):void
		{
			if (m_step == SETP_BGUnfold)
			{
				m_step = SETP_Marquee;
				m_ann.begin();
			}
			else if (m_step == SETP_BGFold)
			{
				m_step = SETP_Idle;
				m_ui.onAnnEnd();
			}
		}
		
		private function onAnnComplete(e:Event):void
		{
			m_step = SETP_BGFold;
			m_bgAni.beginFold();
		}
		
		public function get step():int
		{
			return m_step;
		}
	}

}