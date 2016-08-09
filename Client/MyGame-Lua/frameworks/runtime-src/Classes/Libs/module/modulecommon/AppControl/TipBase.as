package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import org.ffilmation.utils.objectPool;

	
	/**
	 * ...
	 * @author 
	 */
	public class TipBase extends PanelContainer 
	{
		protected var m_gkContext:GkContext;
		protected var m_usedCtrols:Vector.<Object>;
		public function TipBase(gk:GkContext, parent:DisplayObjectContainer=null) 
		{
			m_gkContext = gk;
			super(parent);
			m_usedCtrols = new Vector.<Object>();
		}
		
		public function onHide():void
		{
			var i:int;
			var count:int = m_usedCtrols.length;
			var obj:Object;
			for (i = 0; i < count; i++)
			{
				obj = m_usedCtrols[i];
				this.removeChild(obj as DisplayObject);
				if (obj is Component)
				{
					(obj as Component).dispose();
				}
				objectPool.returnInstance(obj);
			}
			m_usedCtrols.length = 0;
		}
		
		protected function addUsedCtrol(c:Class):Object
		{
			var obj:Object = objectPool.getInstanceOf(c);
			m_usedCtrols.push(obj);
			this.addChild(obj as DisplayObject);
			return obj;
		}		
		
	}

}