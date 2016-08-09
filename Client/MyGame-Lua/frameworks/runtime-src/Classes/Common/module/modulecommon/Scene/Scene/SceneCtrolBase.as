package modulecommon.scene.scene 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.pblabs.engine.entity.EntityCValue;
	import flash.display.Scene;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.SceneViewer;
	import org.ffilmation.engine.core.fCamera;
	import org.ffilmation.engine.core.fEngine;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fProcessEvent;
	import org.ffilmation.engine.core.sceneInitialization.fSceneLoader;
	public class SceneCtrolBase 
	{
		protected var m_engine:fEngine;		
		protected var m_sceneViewer:SceneViewer;
		protected var m_gkContext:GkContext;
		protected var m_dicSceneBack:Dictionary;
		protected var m_dicCameraBack:Dictionary;
		
		protected var m_scene:fScene;
		protected var m_camera:fCamera;
		protected var m_sceneState:int = -1;	//EntityCValue.SSIniting\ EntityCValue.SSRead
		protected var m_sceneType:int;	//场景类型。见EntityCValue.SCGAME等定义
		
		public function SceneCtrolBase(gk:GkContext, engine:fEngine, sceneViewer:SceneViewer, sceneType:int)
		{
			m_gkContext = gk;
			m_engine = engine;
			m_sceneViewer = sceneViewer;
			m_sceneType = sceneType;
			
			m_dicSceneBack = new Dictionary();
			m_dicCameraBack = new Dictionary();
		}
		
		protected function switchToScene(path:String, sceneid:uint):void
		{			
			m_scene =m_dicSceneBack[path];		
			if (m_scene)
			{
				m_camera = m_dicCameraBack[path];			
				// 设置场景状态
				m_sceneState = EntityCValue.SSRead;			
			}
			else
			{
				// KBEN: 修改视口大小
				m_scene = this.m_engine.createScene(new fSceneLoader(path, sceneid), m_gkContext.m_context.m_config.m_curWidth, m_gkContext.m_context.m_config.m_curHeight);
				m_scene.m_path = path;
				m_scene.m_sceneType = m_sceneType;	// 设置场景类型
				m_dicSceneBack[path] = m_scene;
				//this._scene[loadm].addEventListener(fScene.LOADPROGRESS, this.loadProgressHandler);
				if(m_scene.ready)	// 如果场景资源有缓存，这个时候 initScene 这个函数中的 this.scene.dispatchEvent 这一行执行的时候，事件还没有监听，就会错过
				{
					processLoadCompleteHandler()
				}
				else
				{
					m_scene.addEventListener(fScene.LOADCOMPLETE, this.loadCompleteHandler);
				}
			}
		}
		public function loadCompleteHandler(evt:fProcessEvent):void
		{
			// 移除监听器
			m_scene.removeEventListener(fScene.LOADCOMPLETE, this.loadCompleteHandler);
			processLoadCompleteHandler();
		}
		
		private function processLoadCompleteHandler():void
		{						
			// Create camera
			m_camera = m_scene.createCamera();
			m_dicCameraBack[m_scene.m_path] = m_camera;			
			m_scene.setCamera(m_camera);
			
			m_sceneState = EntityCValue.SSRead;
		}
		
		protected function desposeScene(scene:fScene):void
		{
			this.m_engine.destroyScene(scene);
			var path:String = scene.m_path;
			if (m_dicSceneBack[path] != null)
			{
				delete m_dicSceneBack[path];
			}
			
			if (m_dicCameraBack[path] != null)
			{
				delete m_dicCameraBack[path];
			}			
		}
		public function activateScene():void
		{			
			this.m_engine.showScene(m_scene);
		}
		public function getScene(path:String):fScene
		{
			return m_dicSceneBack[path];
		}
		public function get sceneType():int
		{
			return m_sceneType;
		}
		public function get scene():fScene
		{
			return m_scene;
		}
		public function get camera():fCamera
		{
			return m_camera;
		}
		public function hideScene(destroyRender:Boolean):void
		{
			m_engine.hideScene(m_scene, destroyRender);
		}
		public function get isLoading():Boolean
		{
			return m_sceneState == EntityCValue.SSIniting;
		}
	}

}