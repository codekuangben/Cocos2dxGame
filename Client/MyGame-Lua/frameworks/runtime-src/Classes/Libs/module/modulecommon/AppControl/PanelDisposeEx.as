package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 * 当鼠标移到道具上时,出现框
	 */
	public class PanelDisposeEx extends PanelContainer 
	{
		
		public function PanelDisposeEx() 
		{
			
		}
		
		//重写dispose(),目的是:当执行此dispos函数时，不释放里面的数据
		override public function dispose():void 
		{
			
		}
		public function disposeEx():void
		{
			super.dispose();
		}
		public function show(p:DisplayObjectContainer):void
		{
			if (this.parent != p)
			{
				p.addChild(this);
			}
		}
		public function hide(container:DisplayObjectContainer):void
		{
			if (this.parent == container)
			{
				container.removeChild(this);
			}
		}
		public function isShowFor(container:DisplayObjectContainer):Boolean
		{
			return (this.parent == container);
		}
		
	}

}