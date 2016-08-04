package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 活动礼包
	 */
	public class HuodongLibao extends FunBtnBase
	{
		
		public function HuodongLibao(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_Huodonglibao, parent);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			m_gkContext.m_giftPackMgr.showGiftPack(UIFormID.UIGPHuodong);
			hideEffectAni();
		}
	}

}