package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 三国群英会
	 */
	public class SGQunyinghui extends FunBtnBase
	{
		public function SGQunyinghui(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_SGQunyinghui, parent);			
		}
		
		override public function onInit():void 
		{
			super.onInit();
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			m_gkContext.m_heroRallyMgr.enterHeroRally();
		}
	}

}