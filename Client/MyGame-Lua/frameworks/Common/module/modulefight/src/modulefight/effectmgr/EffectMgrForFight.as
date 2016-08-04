package modulefight.effectmgr 
{
	import com.pblabs.engine.entity.DeferEffect;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.TerrainEntity;
	import modulecommon.GkContext;
	import com.pblabs.engine.core.ITickedObject;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.pblabs.engine.debug.Logger;
	/**
	 * ...
	 * @author 
	 */
	public class EffectMgrForFight  implements ITickedObject
	{
		private var m_gkContext:GkContext;
		private var m_scene:fScene;
		
		// KBEN: 飞行特效，攻击特，延迟飞行特效也放在这里
		protected var m_flyEffVec:Vector.<EffectEntity>;
		// KBEN: 延迟飞行特效
		protected var m_deferFlyEffVec:Vector.<DeferEffect>;
		// 场景 UI 底层特效,锦囊特效使用
		protected var m_sceneUIBtmEffVec:Vector.<EffectEntity>;
		protected var m_sceneJinNangEffVec:Vector.<EffectEntity>;
		
		// KBEN:延迟场景特效，现在是锦囊特效在用
		protected var m_deferSceneUIEffVec:Vector.<DeferEffect>;
		// 场景 UI 顶层特效,锦囊特效使用
		protected var m_sceneUITopEffVec:Vector.<EffectEntity>;		
		
		public function EffectMgrForFight(gk:GkContext)
		{
			m_gkContext = gk;
			m_flyEffVec = new Vector.<EffectEntity>();
			m_deferFlyEffVec = new Vector.<DeferEffect>();
			m_sceneJinNangEffVec = new Vector.<EffectEntity>();
			m_deferSceneUIEffVec = new Vector.<DeferEffect>();
			m_sceneUIBtmEffVec = new Vector.<EffectEntity>();
			m_sceneUITopEffVec = new Vector.<EffectEntity>();
		}
		
		public function onEnterFight():void
		{
			m_gkContext.m_context.m_processManager.addTickedObject(this);
			m_scene = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
		}
		
		public function onLeaveFight():void
		{
			m_gkContext.m_context.m_processManager.removeTickedObject(this);
			disposeAllEffect();
			m_scene = null;
		}
		public function onTick(deltaTime:Number):void
		{
			var defereff:DeferEffect;
			var eff:EffectEntity;
			var idx:int;
			
			idx = m_flyEffVec.length - 1;
			while(idx >= 0)
			{
				eff = m_flyEffVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeFlyEff(eff, idx);
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
			
			// 遍历锦囊特效延迟特效
			idx = m_sceneJinNangEffVec.length - 1;
			while(idx >= 0)
			{
				eff = m_sceneJinNangEffVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeSceneJinNangEff(eff, idx);
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
			// 更新场景 UI 特效
			idx = m_sceneUIBtmEffVec.length - 1;
			while(idx >= 0)
			{
				eff = m_sceneUIBtmEffVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeSceneUIEff(eff, EntityCValue.EFFSceneBtm, idx);
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
			idx = m_sceneUITopEffVec.length - 1;
			while(idx >= 0)
			{
				eff = m_sceneUITopEffVec[idx];
				// 如果特效销毁    
				if (eff.bdispose)
				{
					disposeSceneUIEff(eff, EntityCValue.EFFSceneTop, idx);
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
			
			// 延迟场景 UI 特效
			idx = m_deferSceneUIEffVec.length - 1;
			while (idx >= 0)
			{
				m_deferSceneUIEffVec[idx].m_delay -= deltaTime;
				if (m_deferSceneUIEffVec[idx].m_delay < 0)
				{
					// 生成特效
					createDeferSceneUIEffect(m_deferSceneUIEffVec[idx]);
					// 删除特效
					m_deferSceneUIEffVec.splice(idx, 1);
				}
				--idx;
			}
			
			// 遍历延迟特效
			idx = m_deferFlyEffVec.length - 1;
			while (idx >= 0)
			{
				m_deferFlyEffVec[idx].m_delay -= deltaTime;
				if (m_deferFlyEffVec[idx].m_delay < 0)
				{
					// 生成特效
					createDeferFlyEffect(m_deferFlyEffVec[idx]);
					// 删除特效
					m_deferFlyEffVec.splice(idx, 1);
				}
				--idx;
			}
			
		}
		public function disposeAllEffect():void
		{
			var eff:EffectEntity;
			//飞行特效，主要是战斗 
			for each(eff in m_flyEffVec)
			{
				eff.scene.removeEffect(eff);
			}
			m_flyEffVec.length = 0;
			
			m_deferFlyEffVec.splice(0, m_deferFlyEffVec.length);
			
			// 释放锦囊特效
			for each(eff in m_sceneJinNangEffVec)
			{
				eff.scene.removeEffectNIScene(eff);
			}
			m_sceneJinNangEffVec.length = 0;
			// 释放延迟特效结构			
			m_deferSceneUIEffVec.length = 0;
			
			// 释放延迟 UI 特效
			for each(eff in m_sceneUIBtmEffVec)
			{
				eff.scene.removeEffectNIScene(eff);
			}
			m_sceneUIBtmEffVec.length = 0;
			
			// 释放延迟 UI 特效
			for each(eff in m_sceneUITopEffVec)
			{
				eff.scene.removeEffectNIScene(eff);
			}
			m_sceneUITopEffVec.length = 0;
		}
		public function addDeferFlyEffect(defer:DeferEffect):void
		{
			m_deferFlyEffVec.push(defer);
		}
		public function addFlyEffect(eff:EffectEntity):void
		{
			//eff.addEventListener(fElement.DISPOSE, disposeFlyEff);
			m_flyEffVec.push(eff);
		}
		// 这个就是增加攻击特效
		public function addSceneUIEffect(defID:String, startx:Number, starty:Number, startz:Number, framerate:uint = 0, repeat:Boolean = false):EffectEntity
		{
			var type:uint = fUtil.effLinkLayer(defID, this.m_scene.engine.m_context) + 3;
			
			var eff:EffectEntity = this.m_scene.createEffectNIScene(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), defID, startx, starty, startz, type);
			if (framerate)
			{
				eff.frameRate = framerate;
			}
			if (repeat)
			{
				eff.repeat = repeat
			}
			
			// bug: 这个地方没有设置偏移总是出错,这个地方 beingid 传递进入 0 就行了,直接从特效表中读取
			var offpt:Point = this.m_scene.engine.m_context.linkOff(uint.MAX_VALUE, fUtil.modelInsNum(eff.m_insID));
			if(offpt)
			{
				if(eff.bFlip)
				{
					eff.modeleffOff(-offpt.x, offpt.y);
				}
				else
				{
					eff.modeleffOff(offpt.x, offpt.y);
				}
			}
			
			eff.type = type;
			eff.start();
			
			if(type == EntityCValue.EFFSceneBtm)
			{
				m_sceneUIBtmEffVec.push(eff);
			}
			else
			{
				m_sceneUITopEffVec.push(eff);
			}
			
			return eff;
		}
		public function disposeFlyEff(eff:EffectEntity, idx:int = -1):void
		{
			if ( -1 == idx)
			{
				idx = m_flyEffVec.indexOf(eff);
			}
			if (idx >= 0)
			{
				//m_flyEffVec[idx].removeEventListener(fElement.DISPOSE, disposeFlyEff);
				eff.scene.removeEffect(eff);
				m_flyEffVec.splice(idx, 1);
			}
		}
		// 释放场景 UI 特效
		public function disposeSceneUIEff(eff:EffectEntity, type:uint, idx:int = -1):void
		{
			if ( -1 == idx)
			{
				if(type == EntityCValue.EFFSceneBtm)
				{
					idx = m_sceneUIBtmEffVec.indexOf(eff);
				}
				else
				{
					idx = m_sceneUITopEffVec.indexOf(eff);
				}
			}
			if (idx >= 0)
			{
				eff.scene.removeEffectNIScene(eff);
				if(type == EntityCValue.EFFSceneBtm)
				{
					m_sceneUIBtmEffVec.splice(idx, 1);
				}
				else
				{
					m_sceneUITopEffVec.splice(idx, 1);
				}
			}
		}
		// 释放场景锦囊持续特效
		public function disposeSceneJinNangEff(eff:EffectEntity, type:uint, idx:int = -1):void
		{
			if ( -1 == idx)
			{
				idx = m_sceneJinNangEffVec.indexOf(eff);
			}
			if (idx >= 0)
			{
				eff.scene.removeEffectNIScene(eff);
				m_sceneJinNangEffVec.splice(idx, 1);
			}
		}
		// 这个就是增加攻击特效    
		public function createDeferFlyEffect(defer:DeferEffect):EffectEntity
		{
			var hurt:fEmptySprite;
			
			var eff:EffectEntity = defer.m_scene.createEffect(fUtil.elementID(defer.m_scene.engine.m_context, EntityCValue.TEfffect), defer.m_defID, defer.m_startX, defer.m_startY, 0, defer.m_endX, defer.m_endY, 0, defer.m_effectSpeed);
			if (defer.m_framerate)
			{
				eff.frameRate = defer.m_framerate;
			}
			if (defer.m_flyvel)
			{
				eff.vel = defer.m_flyvel;
			}
			eff.bFlip = defer.m_bFlip;
			var offpt:Point = defer.m_scene.engine.m_context.linkOff(fUtil.modelInsNum(defer.m_insID), fUtil.modelInsNum(eff.m_insID));
			if(offpt)
			{
				if(eff.bFlip)
				{
					eff.modeleffOff(-offpt.x, offpt.y);
				}
				else
				{
					eff.modeleffOff(offpt.x, offpt.y);
				}
			}
			
			eff.type = EntityCValue.EFFFly;
			eff.start();
			
			eff.callback = defer.m_callback;
			
			addFlyEffect(eff);
			
			return eff;
		}
		
		// 创建延迟的场景 UI 特效
		public function createDeferSceneUIEffect(defer:DeferEffect):EffectEntity
		{
			// 创建上层特效
			var type:uint;
			var eff:EffectEntity;
			var offpt:Point;
			if(defer.m_defID.length)
			{
				type = fUtil.effLinkLayer(defer.m_defID, this.m_scene.engine.m_context) + 3;
				eff = this.m_scene.createEffectNIScene(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), defer.m_defID, defer.m_startX, defer.m_startY, 0, type);
				if (defer.m_framerate)
				{
					eff.frameRate = defer.m_framerate;
				}
				if (defer.m_repeat)
				{
					eff.repeat = defer.m_repeat;
				}
				// bug: 这个地方没有设置偏移总是出错,这个地方 beingid 传递进入 0 就行了,直接从特效表中读取
				offpt = this.m_scene.engine.m_context.linkOff(uint.MAX_VALUE, fUtil.modelInsNum(eff.m_insID));
				if(offpt)
				{
					if(eff.bFlip)
					{
						eff.modeleffOff(-offpt.x, offpt.y);
					}
					else
					{
						eff.modeleffOff(offpt.x, offpt.y);
					}
				}
				
				eff.type = type;
				eff.startTof(defer.m_startX, defer.m_startY, 0, defer.m_endX, defer.m_endY, 0);
				eff.start();
				
				if(type == EntityCValue.EFFSceneBtm)
				{
					m_sceneUIBtmEffVec.push(eff);
					depthSortJinNangPostEff(m_sceneUIBtmEffVec, EntityCValue.SLSceneUIBtm);
				}
				else
				{
					m_sceneUITopEffVec.push(eff);
					depthSortJinNangPostEff(m_sceneUITopEffVec, EntityCValue.SLSceneUITop);
				}
			}
			
			// 创建底层特效
			if(defer.m_defID1.length)
			{
				type = fUtil.effLinkLayer(defer.m_defID1, this.m_scene.engine.m_context) + 3;
				
				eff = this.m_scene.createEffectNIScene(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), defer.m_defID1, defer.m_startX1, defer.m_startY1, 0, type);
				if (defer.m_framerate1)
				{
					eff.frameRate = defer.m_framerate1;
				}
				if (defer.m_repeat)
				{
					eff.repeat = defer.m_repeat1;
				}
				
				// bug: 这个地方没有设置偏移总是出错,这个地方 beingid 传递进入 0 就行了,直接从特效表中读取
				offpt = this.m_scene.engine.m_context.linkOff(uint.MAX_VALUE, fUtil.modelInsNum(eff.m_insID));
				if(offpt)
				{
					if(eff.bFlip)
					{
						eff.modeleffOff(-offpt.x, offpt.y);
					}
					else
					{
						eff.modeleffOff(offpt.x, offpt.y);
					}
				}
				
				eff.type = type;
				eff.startTof(defer.m_startX1, defer.m_startY1, 0, defer.m_endX1, defer.m_endY1, 0);
				eff.start();
				
				if(type == EntityCValue.EFFSceneBtm)
				{
					m_sceneUIBtmEffVec.push(eff);
					depthSortJinNangPostEff(m_sceneUIBtmEffVec, EntityCValue.SLSceneUIBtm);
				}
				else
				{
					m_sceneUITopEffVec.push(eff);
					depthSortJinNangPostEff(m_sceneUITopEffVec, EntityCValue.SLSceneUITop);
				}
			}
			
			return eff;
		}
		// 锦囊持续特效排序
		public function depthSortJinNangPostEff(efflist:Vector.<EffectEntity>, layer:uint):void
		{
			// KBEN: 深度排序
			TerrainEntity.insortSort(efflist);
			var i:int = efflist.length;
			if (i == 0)
				return;
			var p:Sprite = this.m_scene.m_SceneLayer[layer];
			for each(var el:fRenderableElement in efflist)
			{
				var oldD:int = el.depthOrder;
				// KBEN: 插入排序
				var newD:int = efflist.indexOf(el as EffectEntity);
				if (newD != oldD)
				{
					el.depthOrder = newD;
					try
					{
						if(p.getChildIndex(el.container) != newD)
						{
							p.setChildIndex(el.container, newD);
						}
					}
					catch (e:Error)
					{
						Logger.info(null, null, "depthSortJinNangPostEff error");
					}
				}
			}
		}
		public function addDeferSceneUIEffect(defer:DeferEffect):void
		{
			m_deferSceneUIEffVec.push(defer);
		}
		// 添加锦囊持续特效，这个特效不移动
		public function createJinNangPostEff(defer:DeferEffect):EffectEntity
		{
			//var type:uint = fUtil.effLinkLayer(defer.m_defID, this.m_scene.engine.m_context) + 3;
			
			var eff:EffectEntity = this.m_scene.createEffectNIScene(fUtil.elementID(this.m_scene.engine.m_context, EntityCValue.TEfffect), defer.m_defID, defer.m_startX, defer.m_startY, 0, defer.m_type);
			if (defer.m_framerate)
			{
				eff.frameRate = defer.m_framerate;
			}
			if (defer.m_repeat)
			{
				eff.repeat = defer.m_repeat
			}
			
			// bug: 这个地方没有设置偏移总是出错,这个地方 beingid 传递进入 0 就行了,直接从特效表中读取
			var offpt:Point = this.m_scene.engine.m_context.linkOff(uint.MAX_VALUE, fUtil.modelInsNum(eff.m_insID));
			if(offpt)
			{
				if(eff.bFlip)
				{
					eff.modeleffOff(-offpt.x, offpt.y);
				}
				else
				{
					eff.modeleffOff(offpt.x, offpt.y);
				}
			}
			
			eff.type = defer.m_type;
			eff.start();
			m_sceneJinNangEffVec.push(eff);
			
			return eff;
		}
		// 释放所有的锦囊持续特效
		public function disposeAllSceneJinNangEff():void
		{
			var eff:EffectEntity;
			for each(eff in m_sceneJinNangEffVec)
			{
				eff.scene.removeEffectNIScene(eff);
			}
			m_sceneJinNangEffVec.length = 0;
		}
		
	}

}