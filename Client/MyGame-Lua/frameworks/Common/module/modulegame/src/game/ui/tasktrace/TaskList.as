package game.ui.tasktrace 
{
	import com.bit101.components.controlList.ControlListVHeight;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 */
	public class TaskList extends ControlListVHeight 
	{
		
		public function TaskList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
		}
		
		override public function draw():void 
		{
			this.graphics.clear();
			this.graphics.beginFill(0x90301, 0.0);
			this.graphics.drawRect(m_aligParam.m_marginLeft, 0, width-m_aligParam.m_marginLeft, dataHeight);
			this.graphics.endFill();
		}
		
		override public function set dataHeight(value:int):void 
		{
			super.dataHeight = value;
			this.invalidate();
		}
		
	}

}