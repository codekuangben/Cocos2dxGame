package datast.reuse 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 */
	public class ObjectForReuse_Component extends Component implements IObjectForReuse 
	{
		protected var m_funReserveSelf:Function;
		public function ObjectForReuse_Component(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
		}
		
		/* INTERFACE datast.reuse.IObjectForReuse */
		
		public function set funReserveSelf(value:Function):void 
		{
			m_funReserveSelf = value;
		}
		
		public function initData(param:Object = null):void 
		{
			
		}
		
		protected function reserveSelf():void
		{
			m_funReserveSelf(this);
		}	
		
	}

}