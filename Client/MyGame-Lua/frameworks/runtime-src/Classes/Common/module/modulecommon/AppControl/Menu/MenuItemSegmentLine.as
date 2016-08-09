package modulecommon.appcontrol.menu 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.display.DisplayObjectContainer;
	public class MenuItemSegmentLine extends MenuItemBase 
	{
		
		public function MenuItemSegmentLine(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);			
			this.autoSizeByImage = false;
			this.setPanelImageSkin("commoncontrol/panel/splitline.png");
			this.mouseEnabled = false;
		}
		
	}

}