package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author ...
	 * 调查问卷
	 */
	public class Questionnaire extends FunBtnBase
	{
		
		public function Questionnaire(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_Questionnaire, parent);
		}
		
		override public function onClick(event:MouseEvent):void
		{
			super.onClick(event);
			
			var url:URLRequest=new URLRequest("http://www.wenjuan.com/s/6jAJVn");
			var fangshi:String="_blank";
			navigateToURL(url, fangshi);
		}
	}

}