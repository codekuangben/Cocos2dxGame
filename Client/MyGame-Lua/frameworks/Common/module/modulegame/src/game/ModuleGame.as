package game
{
	import common.Context;
	import flash.display.Sprite;
	import modulecommon.GkContext;
	
	import game.IMGame;

	/**
	 * ...
	 * @author ...
	 */
	public class ModuleGame extends Sprite implements IMGame
	{
		public var m_root:ModuleGameRoot;
		
		public function set closeHandle(rh:Function):void
		{
			
		}
		
		public function ModuleGame():void 
		{
			m_root = new ModuleGameRoot();
		}
		
		public function init():void 
		{
			m_root.init(this);
			//m_root.init(); 
		}
		
		public function destroy():void
		{
			//m_root.destroy();
			//m_root = null;
		}
		
		public function set context(rh:Context):void
		{
			m_root.m_context = rh;
		}
	}
}