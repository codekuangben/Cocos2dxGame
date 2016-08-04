package game.ui.uiScreenBtn 
{
	import com.ani.AniPropertys;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 首冲特效（特殊处理）
	 */
	public class FirstRechargePanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIScreenBtn;
		private var m_ani:Ani;
		private var m_moveAni:AniPropertys;
		
		public function FirstRechargePanel(gk:GkContext, ui:UIScreenBtn, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			m_ani = new Ani(m_gkContext.m_context, this, 0, 0);
			m_ani.centerPlay = true;
			m_ani.setImageAni("ejshouchong.swf");
			m_ani.duration = 2;
			m_ani.repeatCount = 0;
			m_ani.begin();
			
			m_moveAni = new AniPropertys();
			m_moveAni.sprite = m_ani;
			m_moveAni.useFrames = true;
			m_moveAni.duration = 20;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onAniShow():void
		{
			m_moveAni.onEnd = onAniShowEnd;
			m_moveAni.resetValues( { alpha: 1, scaleX:1, scaleY:1, x: 0, y: 0 } );
			m_moveAni.begin();
			
		}
		
		private function onAniShowEnd():void
		{
			m_ani.begin();
		}
		
		public function onAniHide():void
		{
			m_moveAni.onEnd = onAniHideEnd;
			m_moveAni.resetValues( { alpha: 0, scaleX:0, scaleY:0, x: -15, y: -91 } );
			m_moveAni.begin();
		}
		
		private function onAniHideEnd():void
		{
			m_ani.stop();
		}
		
		private function onClick(event:MouseEvent):void
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIFirstRecharge))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIFirstRecharge);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIFirstRecharge);
			}
		}
		
		public function getPosInScreen():Point
		{
			return this.localToScreen(new Point(m_ani.x, m_ani.y));
		}
		
		override public function dispose():void
		{
			m_moveAni.dispose();
			
			super.dispose();
		}
	}

}