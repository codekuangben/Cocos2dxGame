package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import login.PlatformMgr;
	import modulecommon.scene.radar.RadarMgr;
	/**
	 * ...
	 * @author ...
	 * 论坛
	 */
	public class TalkBtn extends BtnBase
	{
		
		public function TalkBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_Talk, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			var talkURL:URLRequest = new URLRequest("http://bbs.games.sina.com.cn/forum-1242-1.html");
			var fangshi:String = "_blank";
			var platForm:String = m_gkContext.m_context.m_platformMgr.platform;
			
			if (PlatformMgr.TYPE_wanwan == platForm)
			{
				talkURL.url = "http://bbs.games.sina.com.cn/forum-1242-1.html";
			}
			else if (PlatformMgr.TYPE_weiyouxi == platForm)
			{
				talkURL.url = "http://game.weibo.com/club/forum-387-1";
			}
			
			navigateToURL(talkURL, fangshi);
		}
		
	}

}