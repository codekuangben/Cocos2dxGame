package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 */
	public class DailyActivites extends FunBtnBase
	{
		
		public function DailyActivites(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_DailyActivities, parent);
		}
		
		override public function onClick(e:MouseEvent):void
		{
			super.onClick(e);
			
		}
		
	}

}