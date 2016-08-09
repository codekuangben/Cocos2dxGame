package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 
	 * 负责管理PanelPage的管理
	 */
	public class PanelPageParent extends Component 
	{
		protected var m_dicPage:Dictionary;
		public function PanelPageParent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dicPage = new Dictionary();
		}
		
		
		override public function dispose():void 
		{
			var page:PanelPage;
			for each(page in m_dicPage)
			{
				if (page.parent==null)
				{
					page.dispose();
				}
			}
			super.dispose();
		}
		
	}

}