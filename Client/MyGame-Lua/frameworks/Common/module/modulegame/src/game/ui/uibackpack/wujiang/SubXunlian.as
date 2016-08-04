package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SubXunlian extends SubBase 
	{		
		public function SubXunlian(parent:DisplayObjectContainer, gk:GkContext, _heroID:uint)
		{
			this.heroID = _heroID;
			super(parent, gk);
		}
		
	}

}