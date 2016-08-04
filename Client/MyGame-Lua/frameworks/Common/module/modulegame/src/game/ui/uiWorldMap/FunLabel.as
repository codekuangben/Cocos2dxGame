package game.ui.uiWorldMap 
{
	import com.bit101.components.Component;	
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class FunLabel extends PanelContainer
	{
		private var m_label:Label2;
		public function FunLabel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_label = new Label2(this);
			m_label.setPos(10, 8);
			var lf:LabelFormat = new LabelFormat();
			lf.lineRotation = LabelFormat.ROTATE_90;
			m_label.labelFormat = lf;
			this.setPanelImageSkin("commoncontrol/panel/wordmapredbg.png");
		}
		
		public function setCaption(str:String):void
		{
			var ls:uint = 0;
			if (str.length == 2)
			{
				ls = 7;
			}
			else if(str.length == 3)
			{
				ls = 3;
			}
			else
			{
				ls = 0;
			}
			
			m_label.letterspace = ls;
			m_label.text = str;
		}
		
	}

}