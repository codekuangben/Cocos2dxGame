package modulecommon.scene
{
	// Imports
	//import com.gamecursor.GameCursor;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	//import flash.events.Event;
	import flash.utils.Dictionary;
	import modulecommon.scene.scene.FightSceneCtrol;
	import modulecommon.scene.scene.SceneCtrolBase;
	import modulecommon.scene.scene.ServerSceneCtrol;
	import modulecommon.scene.scene.UISceneCtrol;
	//import org.ffilmation.engine.core.fElement;
	
	import common.scene.ISceneView;
	import modulecommon.GkContext;
	import flash.display.Sprite;
	import org.ffilmation.engine.core.fEngine;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.core.fCamera;
	//import org.ffilmation.engine.events.fEventIn;
	//import org.ffilmation.engine.events.fProcessEvent;
	//import org.ffilmation.engine.core.sceneInitialization.fSceneLoader;
	
	/**
	 * ...
	 * @author
	 * @brief 视口，场景相关内容放在这里
	 */ /** @private */
	public class SceneViewer implements ISceneView
	{
		// Variables
		public var _container:Sprite;
		private var _engine:fEngine;
		/*private var _scene:Vector.<fScene>;	// 当前场景
		   //public var _hero:BeingEntity;	// 当前主角
		   public var _scenes:Object;	// 场景映射，路径到场景的映射
		
		   public var _curCamera:Vector.<fCamera>;	// 当前摄像机
		   public var _cameras:Object;		// 摄像机映射，路径到摄像机的映射
		 private var _path:Vector.<String>;		// 记录当前场景目录的，获取场景目录就从这里获取     */
		//public var _destination:XML;
		
		//protected var m_context:Context;
		protected var m_gkcontext:GkContext;
		
		protected var m_sorSceneType:int = -1;
		protected var m_curSceneType:int = -1; // 当前显示的场景类型
		
		/*从玩家角度来看，主角当前所在的场景类型（EntityCValue.SCGAME, EntityCValue.SCUI）
		 * 当且仅当在进出UI场景时，该变量的值会变化
		 */
		protected var m_curSceneType_PlayerMain:int = -1;
		
		protected var m_dicSceneCtrl:Dictionary;
		protected var m_serverCtrl:ServerSceneCtrol;
		protected var m_fightCtrl:FightSceneCtrol;
		protected var m_UICtrl:UISceneCtrol;
		
		// Init demo
		public function SceneViewer(container:Sprite, context:GkContext)
		{
			m_gkcontext = context;
			this._container = container;
			this._container.y = m_gkcontext.m_context.m_config.m_viewOff;
			
			// Create engine
			this._engine = new fEngine(this._container, m_gkcontext.m_context);
			
			// Goto first scene
			//this.gotoScene(src);
			
			m_dicSceneCtrl = new Dictionary();
			
			m_serverCtrl = new ServerSceneCtrol(m_gkcontext, _engine, this);
			m_dicSceneCtrl[m_serverCtrl.sceneType] = m_serverCtrl;
			m_fightCtrl = new FightSceneCtrol(m_gkcontext, _engine, this);
			m_dicSceneCtrl[m_fightCtrl.sceneType] = m_fightCtrl;
			m_UICtrl = new UISceneCtrol(m_gkcontext, _engine, this);
			m_dicSceneCtrl[m_UICtrl.sceneType] = m_UICtrl;
		}
		
		// Load scene start     
		// destroyRender : 如果隐藏的话，是否销毁渲染相关的资源     
		// bdispose : 销毁还是隐藏之前的场景   
		// 这个是正常的场景跳转
		// 任何跳地图必须做 if(m_gkcontext.m_context.m_sceneState == EntityCValue.SSRead) 的判断，只有前一个地图 ready 了才可以
		public function gotoScene(path:String, sceneid:uint):void
		{
			if (m_curSceneType_PlayerMain == -1)
			{
				m_curSceneType_PlayerMain = EntityCValue.SCGAME;
			}
			if (m_curSceneType_PlayerMain == EntityCValue.SCGAME)
			{				
				if (m_curSceneType == -1)
				{
					m_curSceneType = EntityCValue.SCGAME;					
				}
				else if (m_curSceneType == EntityCValue.SCGAME)
				{
					m_sorSceneType = EntityCValue.SCGAME;
				}
			}
			m_serverCtrl.gotoScene(path, sceneid);
		}
		
		//从EntityCValue.SCGAME场景进入SceneUI。
		public function gotoSceneUI(path:String, sceneid:uint):void
		{
			if (m_curSceneType_PlayerMain != EntityCValue.SCGAME)
			{
				return;
			}
			m_curSceneType_PlayerMain = EntityCValue.SCUI;
			
			m_serverCtrl.hideScene(false);
			m_sorSceneType = m_curSceneType;
			m_curSceneType = EntityCValue.SCUI;
			m_UICtrl.gotoScene(path, sceneid);
		}
		
		//离开UI场景。只有当游戏画面处于UI场景时，才可以执行此函数
		public function leaveSceneUI():void
		{
			if (m_curSceneType_PlayerMain != EntityCValue.SCUI)
			{
				return;
			}
			m_curSceneType_PlayerMain = EntityCValue.SCGAME;
			
			m_sorSceneType = m_curSceneType;
			m_curSceneType = EntityCValue.SCGAME;
			m_UICtrl.leaveScene();
			followHero(m_gkcontext.m_playerManager.hero);
			m_serverCtrl.activateScene();
			
			m_gkcontext.m_arenaMgr.onLeaveAreaAndAfterNewMapLoaded();
		}
		
		public function gotoSceneFight(path:String, sceneid:uint):void
		{
			m_sorSceneType = m_curSceneType;
			m_curSceneType = EntityCValue.SCFIGHT;
			
			if (m_curSceneType_PlayerMain == EntityCValue.SCGAME)
			{
				m_serverCtrl.hideScene(false);
			}
			else
			{
				m_UICtrl.hideScene(false);
			}
			
			m_fightCtrl.gotoScene(path, sceneid);
		}
		
		public function leaveSceneFight():void
		{
			var cur:int = m_sorSceneType;
			m_sorSceneType = m_curSceneType;
			m_curSceneType = cur;
			m_fightCtrl.leaveScene();
			
			m_gkcontext.m_context.m_processManager.onResize();
			if (m_curSceneType_PlayerMain == EntityCValue.SCGAME)
			{
				m_serverCtrl.camera.m_bInit = false;
				m_serverCtrl.activateScene();
				followHero(m_gkcontext.m_playerManager.heroDirect);		
			}
			else
			{				
				m_UICtrl.activateScene();
			}			
		}
		
		// 切换场景  
		/*public function INlistener(evt:fEventIn):void
		   {
		   if (evt.name == "TELEPORT")
		   {
		   this._destination = evt.xml;
		   this.gotoScene(evt.xml.destination, 10000);
		   }
		 }*/
		
		// 获取游戏引擎    
		public function get engine():fEngine
		{
			return _engine;
		}
		
		// 获取当前场景    
		public function scene(which:uint = EntityCValue.SCGAME):fScene
		{
			return (m_dicSceneCtrl[which] as SceneCtrolBase).scene;
		}
		
		public function curScene():fScene
		{
			if (m_curSceneType >= 0)
			{
				return (m_dicSceneCtrl[m_curSceneType] as SceneCtrolBase).scene;
			}
			return null;
		}
		
		// 获取当前摄像机    
		public function curCamera(which:uint = EntityCValue.SCGAME):fCamera
		{
			return (m_dicSceneCtrl[which] as SceneCtrolBase).camera
		}
		
		public function set gkcontext(value:GkContext):void
		{
			m_gkcontext = value;
		}
		
		public function get sorSceneType():int
		{
			return m_sorSceneType;
		}
		
		public function path(which:uint = EntityCValue.SCGAME):String
		{
			return (m_dicSceneCtrl[which] as SceneCtrolBase).scene.m_path;
		}
		
		public function hasScene(path:String):Boolean
		{
			return getScene(path) != null;
		}
		
		public function followHero(hero:BeingEntity, which:uint = EntityCValue.SCGAME):void
		{
			if (!hero)
				return;
			
			var base:SceneCtrolBase = m_dicSceneCtrl[which] as SceneCtrolBase;
			
			var scene:fScene = base.scene;
			if (scene.IAmBeingRendered == false)
			{
				return;
			}
			var camera:fCamera = base.camera;
			camera.gotoPos(hero.x, hero.y, hero.z);
			camera.follow(hero, 5);
			//camera.dispatchEvent(new Event(fElement.NEWCELL));
			
			if (scene.m_sceneConfig.fogOpened)
			{
				scene.fogPlane.moveTo(hero.x, hero.y, hero.z);
				scene.fogPlane.follow(camera, 0);
			}
			
			// 军团争夺战相机位置固定
			if (m_gkcontext.m_mapInfo.m_servermapconfigID == MapInfo.MAPID_CORPSCITY || m_gkcontext.m_mapInfo.mapType() == MapInfo.CorpsCitySys)	// 在军团争夺战城市场景或者据点场景
			{
				stopFollowHero(hero);
				camera.gotoPos(958, 520, 0);
			}
		}
		
		public function stopFollowHero(hero:BeingEntity, which:uint = EntityCValue.SCGAME):void
		{
			if (!hero)
				return;
			var base:SceneCtrolBase = m_dicSceneCtrl[which] as SceneCtrolBase;
			var scene:fScene = base.scene;
			var camera:fCamera = base.camera;
			
			camera.stopFollowing(hero);
			if (scene.m_sceneConfig.fogOpened)
			{
				scene.fogPlane.stopFollowing(camera);
			}
		}
		
		// 根据场景获取场景路径
		/*public function getScenePath(sc:fScene):String
		   {
		   for (var key:String in _scenes)
		   {
		   if (_scenes[key] == sc)
		   {
		   return key;
		   }
		   }
		
		   return "";
		 }*/
		
		public function getScene(path:String):fScene
		{
			var base:SceneCtrolBase;
			var ret:fScene;
			for each (base in m_dicSceneCtrl)
			{
				ret = base.getScene(path);
				if (ret)
				{
					return ret;
				}
			}
			
			return null;
		}
		
		public function getGameScene():fScene
		{
			return m_serverCtrl.scene;
		}
		
		public function get curSceneType():int
		{
			return m_curSceneType;
		}
		
		public function get isLoading():Boolean
		{
			return m_serverCtrl.isLoading || m_fightCtrl.isLoading || m_UICtrl.isLoading;
		}
	}
}