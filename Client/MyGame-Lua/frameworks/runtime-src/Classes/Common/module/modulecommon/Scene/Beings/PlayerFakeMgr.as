package modulecommon.scene.beings 
{
	import com.pblabs.engine.core.ITickedObject;
	import modulecommon.GkContext;
	import org.ffilmation.engine.core.fScene;
	import com.pblabs.engine.entity.EntityCValue;
	/**
	 * ...
	 * @author 
	 */
	public class PlayerFakeMgr implements ITickedObject 
	{
		protected var m_gkContext:GkContext;
		protected var m_beingList:Vector.<NpcPlayerFake>;
		public function PlayerFakeMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_beingList = new Vector.<NpcPlayerFake>();
		}
		public function dispose():void
		{
			m_gkContext.m_context.m_processManager.removeTickedObject(this);			
		}
		
		// 每一帧都更新      
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_gkContext.m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			for each (var abeing:NpcPlayerFake in m_beingList)
			{
				// 如果可视就更新，如果不可视，就不更新   
				if (abeing.needUpdate())
				{
					abeing.onTick(deltaTime);
				}
			}
		}
		
		public function addBeingByTmpID(tmpid:uint, being:NpcPlayerFake):void
		{
			if (m_beingList.length == 0)
			{
				m_gkContext.m_context.m_processManager.addTickedObject(this, EntityCValue.PrioritySceneFake);
			}
			m_beingList.push(being);	
		}
		
		public function getBeingByTempID(tmpid:uint):NpcPlayerFake
		{
			var ret:NpcPlayerFake;
			for each(ret in m_beingList)
			{
				if (ret.tempid == tmpid)
				{
					return ret;
				}
			}
			return null;			
		}
		public function destroyBeingByTmpID(tmpid:uint, bRemove:Boolean = true):void
		{
			var player:NpcPlayerFake = getBeingByTempID(tmpid);			
			if (player == null)
			{
				return;
			}
			
			// 逻辑释放保存的指针
			m_gkContext.m_sceneLogic.disposeElement(player);
			
			var idx:int = m_beingList.indexOf(player);			
			m_beingList.splice(idx, 1);
			
			if (bRemove == true)
			{
				m_gkContext.m_context.m_sceneView.scene().removeCharacter(player);
			}			
			
			if (m_beingList.length == 0)
			{
				m_gkContext.m_context.m_processManager.removeTickedObject(this);
			}
		}
		
		public function preInit(oldScene:fScene, destroyRender:Boolean = true, bdispose:Boolean = false):void
		{
			var i:int;
			var size:int = m_beingList.length;
			if (size == 0)
			{
				return;
			}
			for (i = 0; i < size; i++)
			{
				oldScene.removeCharacter(m_beingList[i], true);
				// 逻辑释放保存的指针
				m_gkContext.m_sceneLogic.disposeElement(m_beingList[i]);
			}
			m_beingList.length = 0;
			m_gkContext.m_context.m_processManager.removeTickedObject(this);
		}
		
		// 场景加载完后进行初始化
		public function postInit(newScene:fScene):void
		{
			
		}
	}

}