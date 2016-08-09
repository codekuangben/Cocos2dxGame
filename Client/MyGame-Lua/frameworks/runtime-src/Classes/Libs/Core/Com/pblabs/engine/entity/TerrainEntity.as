package com.pblabs.engine.entity
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.debug.Logger;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * ...
	 * @author 
	 * @biref 地形    
	 */
	public class TerrainEntity implements ITickedObject
	{
		public var m_scene:fScene;		// 场景
		// KBEN: 地形特效放在这里
		protected var m_groundEffVec:Vector.<EffectEntity>;		
		// 锦囊持续特效
		//protected var m_jnPostEffVec:Vector.<DeferEffect>;
		
		
		
		// 地上物
		protected var m_thingVec:Vector.<EffectEntity>;
		
		public function TerrainEntity() 
		{
			m_groundEffVec = new Vector.<EffectEntity>();			
			m_thingVec = new Vector.<EffectEntity>();
		}
		
		public function onTick(deltaTime:Number):void
		{
			var defereff:DeferEffect;
			
			// 更新地物特效
			var eff:EffectEntity;
			var idx:int = m_groundEffVec.length - 1;
			while(idx >= 0)
			{
				eff = m_groundEffVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeGroundEff(eff, idx);
				}
				else
				{
					if(eff._visible)	// 只要设置不隐藏，就更新逻辑，显示数据需要真可见的时候才更新
					{
						eff.onTick(deltaTime);
					}
				}
				
				--idx;
			}		
			
			// 地物
			idx = m_thingVec.length - 1;
			while(idx >= 0)
			{
				eff = m_thingVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeThing(eff, idx);
				}
				else
				{
					if(eff._visible)
					{
						eff.onTick(deltaTime);
					}
				}
				
				--idx;
			}
		}
		
		public function getGroundEffect(idx:uint):EffectEntity
		{
			if (idx < m_groundEffVec.length)
			{
				return m_groundEffVec[idx];
			}
			
			return null;
		}
		
		// 已知特效，创建地面特效
		public function addGroundEffect(eff:EffectEntity):void
		{
			//eff.addEventListener(fElement.DISPOSE, disposeGroundEff);
			m_groundEffVec.push(eff);
		}
		
		// 通过 id 创建地面非移动的长效特效
		public function addGroundEffectByID(def:String, startx:Number, starty:Number, repeat:Boolean = true):EffectEntity
		{
			var eff:EffectEntity = this.m_scene.createEffect(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), def, startx, starty, 0, 0, 0, 0, 0);
			eff.type = EntityCValue.EFFTerrain;
			eff.repeat = repeat;
			eff.start();
			addGroundEffect(eff);
			
			return eff;
		}
		
		
		public function disposeGroundEff(eff:EffectEntity, idx:int = -1):void
		{
			if ( -1 == idx)
			{
				idx = m_groundEffVec.indexOf(eff);
			}
			if (idx >= 0)
			{
				//m_groundEffVec[idx].removeEventListener(fElement.DISPOSE, disposeGroundEff);
				eff.scene.removeEffect(eff);
				m_groundEffVec.splice(idx, 1);
			}
		}		
		
		// 释放地物
		public function disposeThing(eff:EffectEntity, idx:int = -1):void
		{
			if ( -1 == idx)
			{
				idx = m_thingVec.indexOf(eff);
			}
			if (idx >= 0)
			{
				eff.scene.removeEffect(eff);
				m_thingVec.splice(idx, 1);
			}
		}
		
		public function disposeAll():void
		{
			var eff:EffectEntity;
			// 场景特效，基本是长时间存在地形上，不删除的基本不动的，需要排序
			for each(eff in m_groundEffVec)
			{
				eff.scene.removeEffect(eff);
			}
			m_groundEffVec.length = 0;			
			
			// 地物
			for each(eff in m_thingVec)
			{
				eff.scene.removeEffect(eff);
			}
			m_thingVec.length = 0;
		}
		
		// 插入排序，进行深度排序，因为很多时候基本是有序的，因此使用插入排序
		public static function insortSort(sortarr:Vector.<EffectEntity>):void
		{
			var i:int = 0;
			var k:int = 0;
			var val:EffectEntity = null;
			
			for(i = 1; i < sortarr.length ; i++)
			{
				k = i - 1;
				val = sortarr[i];
				while(k >= 0 && sortarr[k].y > val.y)
				{
					sortarr[k+1] = sortarr[k];
					k--;
				}
				
				sortarr[k + 1] = val;
				
				
				// 如果 _depth 相等，就比较距离
				if (k >= 0 && sortarr[k].y == val.y)
				{
					// 如果正好前面这个距离比后面这个距离大
					if (val.x < sortarr[k].x)
					{
						// 交换最后这两个
						sortarr[k + 1] = sortarr[k];
						sortarr[k] = val;
					}
				}
			}
		}
		
		public function addThingByID(def:String, startx:Number, starty:Number, repeat:Boolean = true):EffectEntity
		{
			var eff:EffectEntity = this.m_scene.createEffect(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), def, startx, starty, 0, 0, 0, 0, 0);
			eff.type = EntityCValue.EFFTerrain;
			eff.repeat = repeat;
			eff.start();
			m_thingVec.push(eff);
			
			return eff;
		}
	}
}