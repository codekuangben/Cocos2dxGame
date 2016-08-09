package app
{
	//import com.pblabs.engine.resource.ResourceManager;
	//import flash.display.Loader;
	//import flash.display.Shape;
	import base.IModuleApp;
	import flash.display.Sprite;
	//import flash.events.ErrorEvent;
	import flash.events.Event;
	//import flash.events.IOErrorEvent;
	//import flash.events.ProgressEvent;
	//import flash.net.URLRequest;
	//import modulecommon.game.ConstValue;
	
	//import modulecommon.game.IMApp;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleApp extends Sprite implements IModuleApp
	{
		protected var m_root:ModuleAppRoot;
		
		public function ModuleApp() 
		{
			m_root = new ModuleAppRoot();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		
		private function onadd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onadd);
			init();
		}
		
		// 放到场景图中后才初始化 
		public function init():void 
		{
			// 加载基本模块库  
			m_root.init(this);
			//m_root.loadLogin();
			// 需要等到 version 加载完成后才能加载这个			
		}
		public function beginProcess():void
		{
			m_root.beginProcess();
		}
		public function destroy():void
		{
			m_root.destroy();
			m_root = null;
		}
	}
}