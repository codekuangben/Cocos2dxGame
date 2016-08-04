package modulefight.scene 
{
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import common.scene.fight.AttackItem;
	import flash.geom.Point;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	/**
	 * ...
	 * @author 
	 */
	public class fEmptySpriteForFight extends fEmptySprite 
	{
		public var m_fightDB:FightDB;
		public function fEmptySpriteForFight(defObj:XML, scene:fScene) 
		{
			super(defObj, scene);
			
		}
		// 这个就是增加攻击特效    
		public function addFlyEffect(defID:String, framerate:uint = 0, flyvel:Number = 0):EffectEntity
		{			
			var item:AttackItem = m_followBeing.fightList.m_attackVec[0];
			//var hurt:BeingEntity;
			var hurt:fEmptySprite;
			
			//if (EntityCValue.TPlayer == item.targetList[0].hurtType)
			//{
				//hurt = this.m_context.m_playerManager.getBeingByID(item.targetList[0].hurtID);
			//}
			//else if (EntityCValue.TBattleNpc == item.targetList[0].hurtType)
			//{
				//hurt = this.m_context.m_npcBattleMgr.getBeingByID(item.targetList[0].hurtID);
			//}
			if(EntityCValue.TEmptySprite == item.targetList[0].hurtType)
			{
				hurt = this.m_context.m_npcBattleMgr.getEmptySpriteByID(item.targetList[0].hurtID);
			}
			
			var eff:EffectEntity = this.scene.createEffect(fUtil.elementID(this.m_context, EntityCValue.TEfffect), defID, m_followBeing.x, m_followBeing.y, m_followBeing.z, hurt.x + hurt.xOff, hurt.y + hurt.yOff, hurt.z, m_followBeing.m_effectSpeed);
			if (framerate)
			{
				eff.frameRate = framerate;
			}
			if (flyvel)
			{
				eff.vel = flyvel;
			}
			if (this.m_followBeing.side != eff.definition.effDir)
			{
				eff.bFlip = EntityCValue.FLPX;
			}
			var offpt:Point = this.m_context.linkOff(fUtil.modelInsNum(this.m_followBeing.m_insID), fUtil.modelInsNum(eff.m_insID));
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
			
			this.m_fightDB.m_effectMgr.addFlyEffect(eff);
			
			return eff;
		}
		
		// 这个地方返回特效，因为士气特效是加在 fEmptySprite 中的，efftype ，主要用来判断特效镜像的
		public function addLinkEffect(defID:String, framerate:uint = 0, repeat:Boolean = false, efftype:uint = 0):EffectEntity
		{			
			// 如果不是士气，就需要删除士气特效
			if(EntityCValue.EFFShiQi != defID)
			{
				if(m_followBeing.shiQiEff)
				{
					m_followBeing.shiQiEff.stop();
					if(fUtil.effLinkLayer(EntityCValue.EFFShiQi, this.m_context))
					{
						if(EntityCValue.EMPTBot == m_type)
						{
							removeLinkEffect(m_followBeing.shiQiEff);
						}
						else
						{
							if((m_followBeing as NpcBattle).botEmptySprite)
							{
								(m_followBeing as NpcBattle).botEmptySprite.removeLinkEffect(m_followBeing.shiQiEff);
							}
						}
					}
					else
					{
						if(EntityCValue.EMPTTop == m_type)
						{
							removeLinkEffect(m_followBeing.shiQiEff);
						}
						else
						{
							if((m_followBeing as NpcBattle).topEmptySprite)
							{
								(m_followBeing as NpcBattle).topEmptySprite.removeLinkEffect(m_followBeing.shiQiEff);
							}
						}
					}
					
					m_followBeing.shiQiEff = null;
				}
			}
			
			// 格子特效不需要偏移了吧
			var eff:EffectEntity = this.scene.createEffectNIScene(fUtil.elementID(this.m_context, EntityCValue.TEfffect), defID, m_xOff, m_yOff, 0);
			if(framerate)
			{
				eff.frameRate = framerate;
			}
			if (repeat)
			{
				eff.repeat = repeat
			}
			// 添加到身上的特效 0: 都是站在格子右边的人物正确的，从左到右一套攻击动作
			if(efftype == EntityCValue.EffAtt)
			{
				if (this.m_followBeing.side != eff.definition.effDir)
				{
					eff.bFlip = EntityCValue.FLPX;
				}
			}
			else
			{
				if (this.m_followBeing.side == eff.definition.effDir)
				{
					eff.bFlip = EntityCValue.FLPX;
				}
			}
			// 设置偏移
			var offpt:Point = this.m_context.linkOff(fUtil.modelInsNum(this.m_followBeing.m_insID), fUtil.modelInsNum(eff.m_insID));
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
			
			eff.type = EntityCValue.EFFLink;
			
			m_effVec.push(eff);
			
			// 切换特效父容器，这一行代码要在 activateScene 之后执行才行  
			(eff.customData.flash9Renderer as fFlash9ElementRenderer).changeContainerParent(this.container);
			
			// KBEN: 如果当前特效场景可视   
			if (this.isVisibleNow)
			{
				eff.show();
				eff.isVisibleNow = true;
			}
			
			var r:fFlash9ElementRenderer = this.customData.flash9Renderer;
			// KBEN: 如果当前特效屏幕可视    
			if (r.screenVisible)
			{
				this.scene.renderEngine.showElement(eff);
				eff.start();
			}
			
			return eff;
		}
		
		
		
		// KBEN: 链接特效删除时候的回调函数 
		override public function removeLinkEffect(effect:EffectEntity, idx:int = -1):void
		{
			// bug : 这个地方会宕机，不知道
			//var effid:String = effect.definition.name + "_" + effect.m_insID;
			var effid:String = effect.definitionID + "_" + effect.m_insID;
			if (idx == -1)
			{
				idx = m_effVec.indexOf(effect);
			}
			if (idx >= 0)
			{
				this.scene.removeEffectNIScene(effect);
				m_effVec.splice(idx, 1);
			}
			
			if(m_followBeing)	// 这个如果不存在就说明是最后释放资源的时候这个已经被释放了
			{
				if(m_followBeing && m_followBeing.state != EntityCValue.TDie)	// 没有死亡的时候才需要判断士气特效是否需要添加
				{
					// 如果没有特效，看是否显示士气 > 100 特效，并且当前清理的不是士气特效
					if(m_followBeing.shiqi >= 100)
					{
						if(effid != EntityCValue.EFFShiQi)
						{
							if(fUtil.effLinkLayer(EntityCValue.EFFShiQi, this.m_context))
							{
								if(EntityCValue.EMPTBot == m_type)
								{
									if(m_effVec.length == 0 && (m_followBeing as NpcBattle).topEmptySprite.effVec.length == 0)
									{
										m_followBeing.shiQiEff = addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
									}
								}
								else
								{
									if(m_effVec.length == 0 && (m_followBeing as NpcBattle).botEmptySprite.effVec.length == 0)
									{
										m_followBeing.shiQiEff = (m_followBeing as NpcBattle).botEmptySprite.addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
									}
								}
							}
							else
							{
								if(EntityCValue.EMPTTop == m_type)
								{
									if(m_effVec.length == 0 && (m_followBeing as NpcBattle).botEmptySprite.effVec.length == 0)
									{
										m_followBeing.shiQiEff = addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
									}
								}
								else
								{
									if(m_effVec.length == 0 && (m_followBeing as NpcBattle).topEmptySprite.effVec.length == 0)
									{
										m_followBeing.shiQiEff = (m_followBeing as NpcBattle).topEmptySprite.addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
									}
								}
							}
						}
					}
				}
			}
		}
	}

}