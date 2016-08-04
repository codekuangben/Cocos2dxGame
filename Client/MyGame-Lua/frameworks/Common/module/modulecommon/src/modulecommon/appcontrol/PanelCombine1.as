package modulecommon.appcontrol 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	//import modulecommon.ui.Frame;
	/**
	 * ...
	 * @author 
	 */
	public class PanelCombine1 extends PanelContainer 
	{
		private var m_bg:Panel;
		public function PanelCombine1(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_bg = new Panel(this);
		}
		
		//在调用次函数前，需要先设置PanelCombine1对象的宽和高
		public function setParam(strFrame:String, strBG:String, wFrame:Number,hFrame:Number):void
		{
			m_bg.setPos(wFrame, hFrame);
			m_bg.setSize(this.width - wFrame * 2, this.height - hFrame * 2);
			
			this.setSkinGrid9Image9(strFrame);
			m_bg.setSkinImagePinjie(strBG);
		}
		
	}

}