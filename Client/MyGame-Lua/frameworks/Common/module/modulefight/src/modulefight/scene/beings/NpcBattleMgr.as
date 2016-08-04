package modulefight.scene.beings 
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.INpcBattleMgr;
	import common.Context;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	
	import org.ffilmation.engine.elements.fEmptySprite;
	/**
	 * ...
	 * @author 
	 */
	public class NpcBattleMgr implements INpcBattleMgr
	{
		public var m_beingList:Vector.<NpcBattle>;
		public var m_emptySpriteList:Dictionary;
		public var m_id2BeingDic:Dictionary;
		protected var m_context:Context;
		
		public function NpcBattleMgr(context:Context) 
		{
			m_context = context;
			m_beingList = new Vector.<NpcBattle>();
			m_emptySpriteList = new Dictionary();
			m_id2BeingDic = new Dictionary();
		}
		
		// 每一帧都更新      
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			for each (var abeing:NpcBattle in m_beingList)
			{
				// 如果可视就更新，如果不可视，就不更新   
				abeing.onTick(deltaTime);
			}
		}
		
		public function addBeing(being:BeingEntity):void
		{
			m_beingList.push(being as NpcBattle);
			m_id2BeingDic[being.id] = being;
		}
		
		public function destroyBeingByID(id:String):void
		{			
			var being:NpcBattle;
			being = m_id2BeingDic[id];
			if (being == null)
			{
				return;
			}
			if ((m_context.m_gkcontext as GkContext).m_sceneLogic)
			{
				(m_context.m_gkcontext as GkContext).m_sceneLogic.disposeElement(being);
			}
			var idx:int = m_beingList.indexOf(being);
			if (idx >= 0)
			{
				m_beingList.splice(idx, 1);
			}
			
			if (m_id2BeingDic[being.id])
			{
				m_id2BeingDic[being.id] = null;
				delete m_id2BeingDic[being.id];
			}
			
			m_context.m_sceneView.scene(EntityCValue.SCFIGHT).removeCharacter(being);
		}
		
		public function getBeingByID(id:String):BeingEntity
		{
			return m_id2BeingDic[id];
		}
		
		/*public function destroyEmptySpriteByID(id:String):void
		{			
			var empty:fEmptySprite;
			empty = m_emptySpriteList[id];
			if (empty == null)
			{
				return;
			}
			
			var idx:int = m_emptySpriteList.indexOf(m_emptySpriteList);
			if (idx >= 0)
			{
				m_emptySpriteList.splice(idx, 1);
			}
			
			if (m_emptySpriteList[empty.id])
			{
				m_emptySpriteList[empty.id] = null;
				delete m_emptySpriteList[empty.id];
			}
			
			m_context.m_sceneView.scene(EntityCValue.SCFIGHT).removeEmptySprite(empty);
		}*/
		
		public function getEmptySpriteByID(id:String):fEmptySprite
		{
			return m_emptySpriteList[id];
		}
		
		public function addEmptySprite(empty:fEmptySprite):void
		{
			m_emptySpriteList[empty.id] = empty;
		}
	}
}