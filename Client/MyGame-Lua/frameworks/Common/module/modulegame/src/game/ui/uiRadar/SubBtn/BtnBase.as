package game.ui.uiRadar.SubBtn 
{
	import com.ani.AniMiaobian;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import com.util.UtilColor;
	import game.ui.uiRadar.UIRadar;
	/**
	 * ...
	 * @author ...
	 */
	public class BtnBase extends Component
	{
		protected var m_gkContext:GkContext;
		protected var m_uiRadar:UIRadar;
		protected var m_id:int;
		protected var m_btn:PushButton;
		protected var m_effectAni:AniMiaobian;
		
		public function BtnBase(id:int, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_id = id;
			
			m_btn = new PushButton(this, 0, 0, onBtnClick);
			
			this.setSize(32, 32);
		}
		
		public function setGKUI(gk:GkContext, ui:UIRadar, icon:String):void
		{
			m_gkContext = gk;
			m_uiRadar = ui;
			
			var iconRes:String = "commoncontrol/button/radarbtn/" + icon + ".swf";
			m_btn.setPanelImageSkin(iconRes);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
		}
		
		public function get btnID():int
		{
			return m_id;
		}
		
		public function showEffectAni():void
		{
			if (null == m_effectAni)
			{
				m_effectAni = new AniMiaobian();
				m_effectAni.sprite = m_btn;
				m_effectAni.setParam(6, UtilColor.GOLD);
			}
			m_effectAni.begin();
		}
		
		public function hideEffectAni():void
		{
			if (m_effectAni)
			{
				m_effectAni.stop();
			}
		}
		
		override public function dispose():void
		{
			if (m_effectAni)
			{
				m_effectAni.dispose();
			}
			
			super.dispose();
		}
	}

}