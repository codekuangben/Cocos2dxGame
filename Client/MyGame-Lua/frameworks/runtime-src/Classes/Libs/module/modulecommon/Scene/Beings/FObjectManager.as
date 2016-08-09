package modulecommon.scene.beings
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import modulecommon.scene.beings.FallObjectEntity;
	import common.Context;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fSceneObject;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 * @brief 掉落物管理器   
	 */
	public class FObjectManager implements ITickedObject
	{
		protected var m_context:Context;		
		protected var m_curFObjects:FObjectScene; // 当前场景玩家
		
		public function FObjectManager(context:Context) 
		{
			m_context = context;			
	
			m_curFObjects = new FObjectScene();
			m_context.m_processManager.addTickedObject(this, EntityCValue.PrioritySceneObj);
		}
		
		public function init():void
		{
		
		}
		
		public function dispose():void
		{
			m_context.m_processManager.removeTickedObject(this);
		}
		
		// 每一帧都更新      
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			for each (var fobj:FallObjectEntity in m_curFObjects.m_FObjectList)
			{
				// 如果可视就更新，如果不可视，就不更新 
				//if (fobj._visible && fobj.isVisibleNow)
				if (fobj._visible)
				{
					fobj.onTick(deltaTime);
				}
			}
		}
		
		public function getFOjectByTmpID(tmpid:uint):fSceneObject
		{
			return m_curFObjects.m_tmpid2FObjectDic[tmpid];
		}
		
		public function destroyFOjectByTmpID(tmpid:uint, bRemove:Boolean = true):void
		{
			var fobj:FallObjectEntity;
			fobj = m_curFObjects.m_tmpid2FObjectDic[tmpid];
			if (fobj == null)
			{
				return;
			}
			
			// 逻辑释放保存的指针
			((m_context.m_gkcontext) as GkContext).m_sceneLogic.disposeElement(fobj);
	
			if (bRemove == true)
			{
				var sc:fScene = m_context.m_sceneView.scene();
				if (sc)
				{
					sc.removeFObject(fobj);
				}
				else
				{
					DebugBox.sendToDataBase("FObjectManager::destroyFOjectByTmpID fScene=null");
				}
			}
			
			var idx:int = m_curFObjects.m_FObjectList.indexOf(fobj);
			if (idx >= 0)
			{
				m_curFObjects.m_FObjectList.splice(idx, 1);
			}

			m_curFObjects.m_tmpid2FObjectDic[tmpid] = null;
			delete m_curFObjects.m_tmpid2FObjectDic[tmpid];
		}
		
		public function addFObjectByTmpID(tmpid:uint, fobj:fSceneObject):void
		{
			var curfobj:FallObjectEntity;
			curfobj = m_curFObjects.m_tmpid2FObjectDic[tmpid];
			if (curfobj != null)
			{
				return;
			}
			
			m_curFObjects.m_tmpid2FObjectDic[tmpid] = fobj;
			m_curFObjects.m_FObjectList.push(fobj);
		}
		
		// 过场景之前初始化   bdispose : 是否将人物释放     
		public function preInit(oldScene:fScene):void
		{
			var i:int;
			var size:int = m_curFObjects.m_FObjectList.length;
			for (i = 0; i < size; i++)
			{
				// 逻辑释放保存的指针
				((m_context.m_gkcontext) as GkContext).m_sceneLogic.disposeElement(m_curFObjects.m_FObjectList[i]);
				oldScene.removeFObject(m_curFObjects.m_FObjectList[i], true);
			}
			m_curFObjects.m_FObjectList.length = 0;
			m_curFObjects.m_tmpid2FObjectDic = new Dictionary();		
		}
		
		// 场景加载完后进行初始化
		public function postInit(newScene:fScene):void
		{
			
		}
	}
}