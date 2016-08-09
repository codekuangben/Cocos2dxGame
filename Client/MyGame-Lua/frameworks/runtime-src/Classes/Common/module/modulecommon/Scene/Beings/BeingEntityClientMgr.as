package modulecommon.scene.beings 
{
	/**
	 * ...
	 * @author 
	 */
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.pblabs.engine.core.ITickedObject;
	
	public class BeingEntityClientMgr  implements ITickedObject
	{
		protected var m_gkContext:GkContext;
		protected var m_dicBeing:Dictionary;
		private var m_num:int;
		public function BeingEntityClientMgr(gk:GkContext) 
		{
			m_dicBeing = new Dictionary();
			m_gkContext = gk;
			
		}
		
		public function addBeing(being:BeingEntity):void
		{
			if (m_dicBeing[being.id] == undefined)
			{
				m_dicBeing[being.id] = being;
				m_num++;
				if (m_num == 1)
				{
					m_gkContext.m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityScenePlayer);
				}
			}
			
			
		}
		
		public function destroyBeing(being:BeingEntity):void
		{
			if (m_dicBeing[being.id] != undefined)
			{
				delete m_dicBeing[being.id];
				if (being.scene)
				{
					being.scene.removeCharacter(being);
				}	
				m_num--;
				if (m_num == 0)
				{
					m_gkContext.m_context.m_processManager.removeTickedObject(this);
				}
			}
		}
		
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_gkContext.m_context.m_sceneView.isLoading)
			{
				return;
			}
			var abeing:BeingEntity;
			for each (abeing in m_dicBeing)
			{
				abeing.onTick(deltaTime);
			}
		}
		
		public function dispose():void
		{
			m_gkContext.m_context.m_processManager.removeTickedObject(this);			
		}
		
	}

}