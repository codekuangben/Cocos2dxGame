package start 
{
	import flash.display.Sprite;
	/**
	 * @brief 启动界面
	 */
	public class UIStart extends Sprite
	{
		public var m_progBarLoading:ProgCom;			// 加载进度条 swf

		public function UIStart(baseurl:String) 
		{
			m_progBarLoading = new ProgCom(baseurl);
			this.addChild(m_progBarLoading);
		}
		
		public function postInit():void
		{
			// 和正常加载的进度条重合
			var dela:uint = 200;
			m_progBarLoading.x = (this.stage.stageWidth - m_progBarLoading.m_selfWidth) / 2;
			m_progBarLoading.y = this.stage.stageHeight - dela - 30;
		}
	}
}