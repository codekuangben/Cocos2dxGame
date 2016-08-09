package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 * 用于界面中的页。当功能拥有多页时，显示其中1页，则自动隐藏其它页
	 */
	public class PanelPage extends PanelShowAndHide 
	{
		
		public function PanelPage(parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
		}
		
		override public function show():void 
		{
			super.show();
			notifyOthers();
		}
		protected function notifyOthers():void
		{
			if (this.parent != null)
			{
				var i:int;
				var page:PanelPage;
				for (i = 0; i < this.parent.numChildren; i++)
				{
					page = this.parent.getChildAt(i) as PanelPage;
					if (page != null && page != this)
					{
						page.hide();
					}
				}
			}
		}
	}

}