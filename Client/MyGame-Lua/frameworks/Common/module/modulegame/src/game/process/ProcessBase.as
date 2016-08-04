package game.process 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.GkContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class ProcessBase 
	{
		protected var m_gkContext:GkContext;		
		protected var dicFun:Dictionary;
		public function ProcessBase(gk:GkContext) 
		{
			m_gkContext = gk;
			dicFun = new Dictionary();
		}
		public function process(msg:ByteArray, param:uint):void
		{
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg, param);
			}
		}
	}

}