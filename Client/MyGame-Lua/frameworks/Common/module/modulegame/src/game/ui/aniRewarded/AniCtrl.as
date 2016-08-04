package game.ui.aniRewarded 
{
	import com.bit101.components.Ani;
	import com.bit101.components.AniScroll_CenterToTwoSide;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 * 
	 */
	public class AniCtrl extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIAniRewarded;
		private var m_bgCP:Component;		//显示背景图、文字(或图片)
		private var m_fireAni:Ani;			//燃烧的火
		private var m_scrollAni:AniScroll_CenterToTwoSide;
		
		public function AniCtrl(gk:GkContext, ui:UIAniRewarded, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			m_fireAni = new Ani(m_gkContext.m_context);
			m_fireAni.repeatCount = 1;
			m_fireAni.centerPlay = true;
			m_fireAni.duration = 1;
			m_fireAni.x = 336;
			m_fireAni.y = 212;
			m_fireAni.setImageAni("ejduchangjiesuan.swf");
			this.addChild(m_fireAni);
			
			m_bgCP = new Component(this);
			m_bgCP.setSize(514, 109);
			m_bgCP.setPanelImageSkin("commoncontrol/panel/anirewardedbg.png");
			
			m_scrollAni = new AniScroll_CenterToTwoSide(this, 336, 168);
			m_scrollAni.setParam(514, 109, 25, m_bgCP);
			m_scrollAni.wScroll = 0;
			m_scrollAni.addEventListener(Event.COMPLETE, onBgAniComplete);
			
			this.setSize(672, 424);
		}
		
		public function beginPlay(param:Object):void
		{
			if (undefined != param["string"])
			{
				setDetailOfStr(param["string"]);
			}
			else if (undefined != param["uigamble"])
			{
				setDetailOfGamble(param);
			}
			
			m_fireAni.begin();
			m_scrollAni.beginUnfold();
		}
		
		//显示内容为字符串
		private function setDetailOfStr(str:String):void
		{
			var tformat:TextFormat = new TextFormat();
			tformat.leading = 3;
			tformat.letterSpacing = 1;
			tformat.color = 0xFFE251;
			tformat.align = "center";
			tformat.font = "STXINWEI";
			
			var tf:TextField = new TextField();
			tf.width = 314;
			tf.height = 50;
			tf.x = 100;
			tf.y = 35;
			tf.defaultTextFormat = tformat;
			tf.htmlText = str;
			m_bgCP.addChild(tf);
		}
		
		//酒馆赌博界面中，结果显示
		private function setDetailOfGamble(param:Object):void
		{
			var dian:int = 0;
			if (undefined != param["uigamble"])
			{
				dian = param["uigamble"] as int;
			}
			
			if (0 == dian)
			{
				return;
			}
			
			var dianDG:DigitComponent = new DigitComponent(m_gkContext.m_context, m_bgCP, 115, 35);
			dianDG.setParam("commoncontrol/digit/gambledigit", 30, 43);
			dianDG.digit = dian;
			
			var dianPnl:Panel = new Panel(m_bgCP, 200, 30);
			dianPnl.setPanelImageSkin("commoncontrol/digit/gambledigit/dian.png");
			
			var descPnl:Panel = new Panel(m_bgCP);
			if(dian < 11)
			{// 小
				descPnl.setPanelImageSkin("commoncontrol/digit/gambledigit/small.png");
				descPnl.setPos(280, 33);	// 如果是小的话，需要调整一下位置
			}
			else
			{// 大
				descPnl.setPanelImageSkin("commoncontrol/digit/gambledigit/big.png");
				descPnl.setPos(280, 30);
			}
		}
		
		private function onBgAniComplete(event:Event):void
		{
			m_ui.onAniRewardedEnd();
		}
		
	}

}