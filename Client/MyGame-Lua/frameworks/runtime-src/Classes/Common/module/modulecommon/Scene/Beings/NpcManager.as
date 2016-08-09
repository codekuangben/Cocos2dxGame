package modulecommon.scene.beings
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import org.ffilmation.utils.mathUtils;

	import common.Context;
	import modulecommon.GkContext;
	import org.ffilmation.engine.core.fScene;

	/**
	 * ...
	 * @author 
	 * @brief 所有的 npc 
	 */
	public class NpcManager implements ITickedObject
	{
		protected var m_context:Context;
		protected var m_list:Vector.<NpcVisit>;
		
		public function NpcManager(context:Context) 
		{
			m_context = context;
			m_list = new Vector.<NpcVisit>();			
			m_context.m_processManager.addTickedObject(this, EntityCValue.PrioritySceneNpc);			
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
			
			for each(var abeing:NpcVisit in m_list)
			{
				// 如果可视就更新，如果不可视，就不更新   
				if (abeing.needUpdate())
				{
					abeing.onTick(deltaTime);
				}
			}
		}

		
		public function getBeingByNpcID(npcID:uint):NpcVisit
		{
			for each(var abeing:NpcVisit in m_list)
			{
				if (abeing.npcBase.m_uID == npcID)
				{
					return abeing;
				}
			}
			return null;			
		}
		
		/*找到满足下面2个条件的npc，
		 * 1. npcID是npcID
		 * 1. 与点(_x, _y)的距离小于等于dis
		 * 
		 */ 
		public function findNpcInRange(npcID:uint, _x:Number, _y:Number, dis:Number):NpcVisit
		{
			var abeing:NpcVisit;
			var sqDis:Number = dis * dis;
			for each(abeing in m_list)
			{
				if (abeing.npcBase.m_uID == npcID)
				{
					if (mathUtils.distanceSquare(_x, _y, abeing.x, abeing.y) <= sqDis)
					{
						return abeing;
					}
				}
			}
			
			return null;
		}
				
		public function getBeingByTmpID(tmpid:uint):NpcVisit
		{
			for each(var abeing:NpcVisit in m_list)
			{
				if (abeing.tempid == tmpid)
				{
					return abeing;
				}
			}
			return null;
		}
		
		/*public function getBeingOfOnly():NpcVisit
		{
			if (1 == m_list.length)
			{
				return m_list[0];
			}
			return null;
		}*/
		
		public function destroyBeingByTmpID(tmpid:uint, bRemove:Boolean = true):void
		{
			if (m_list.length == 0)
			{
				return;
			}
			var i:int;
			for (i = 0; i < m_list.length; i++)
			{
				if (m_list[i].tempid == tmpid)
				{
					break;
				}
			}
			if (i == m_list.length)
			{
				return;
			}
						
			var player:NpcVisit = m_list[i];			
			// 逻辑释放保存的指针
			((m_context.m_gkcontext) as GkContext).m_sceneLogic.disposeElement(player);
			
			if (bRemove == true)
			{
				var serverScene:fScene = m_context.m_sceneView.scene();
				if (serverScene)
				{
					serverScene.removeCharacter(player);
				}
				else
				{
					DebugBox.sendToDataBase("NpcManager::destroyBeingByTmpID delNpc id=" + player.npcBase.m_uID);
				}
			}
			m_list.splice(i, 1);
			
		}
		
		public function execFunForEachNpc(fun:Function):void
		{
			var npc:NpcVisit;
			for each(npc in m_list)
			{
				fun(npc);
			}
		}
		
		public function addBeingByTmpID(tmpid:uint, being:Npc):void
		{
			m_list.push(being);			
		}
		
		public function preInit(oldScene:fScene, destroyRender:Boolean = true, bdispose:Boolean = false):void
		{
			for each(var abeing:NpcVisit in m_list)
			{
				oldScene.removeCharacter(abeing, true);
				((m_context.m_gkcontext) as GkContext).m_sceneLogic.disposeElement(abeing);
			}
			m_list.length = 0;			
		}
	}
}