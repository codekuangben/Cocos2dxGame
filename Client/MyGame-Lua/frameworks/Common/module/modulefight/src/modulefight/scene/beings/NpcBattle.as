package modulefight.scene.beings
{
	//import com.bit101.components.VBox;
	import com.ani.AniPropertys;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.DeferEffect;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.IFightObject;
	import com.util.DebugBox;
	import modulefight.scene.fEmptySpriteForFight;
	import modulefight.scene.fight.FightDB;
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.elements.fCharacter;
	import org.ffilmation.engine.elements.fFloor;
	import org.ffilmation.engine.events.fCollideEvent;
	import org.ffilmation.engine.events.fMoveEvent;
	import org.ffilmation.engine.events.fNewCellEvent;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import common.scene.fight.AttackItem;
	//import common.scene.fight.AttackTarget;
	import common.scene.fight.FightList;
	import common.scene.fight.HurtItem;
	
	//import modulecommon.GkContext;
	import modulecommon.headtop.HeadTopBlockBase;
	//import modulecommon.headtop.NpcVisitHeadTopBlock;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.Npc;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	//import modulecommon.scene.prop.object.Package;
	//import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	//import com.util.UtilHtml;
	
	//import modulefight.FightEn;
	import modulefight.scene.fight.FightGrid;
	//import modulefight.scene.fight.HurtDigit;
	import modulefight.scene.fight.SkillData;
	//import modulefight.ui.HPStrip;
	import modulefight.ui.tip.UIBattleTip;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	import org.ffilmation.engine.helpers.fActDefinition;
	//import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9SceneObjectSeqRenderer;
	//import org.ffilmation.utils.mathUtils;
	
	//import modulecommon.headtop.TopBlockNpcBattle;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * @brief 战斗 npc 只在战斗场景中出现，不能在其它场景中出现，战斗 npc 攻击目标和受伤目标都是空的，都是自己控制播放动作的
	 */
	public class NpcBattle extends Npc implements IFightObject
	{
		protected var m_shiqi:uint;
		protected var m_side:uint; // 哪一边队伍
		public var m_fightDB:FightDB;
		protected var m_bredraBillBoard:Boolean = false;
		protected var m_topEmptySprite:fEmptySpriteForFight; // 顶层空精灵    
		protected var m_botEmptySprite:fEmptySpriteForFight; // 底层是空精灵    
		
		// 0:攻击准备 1:攻击 2:飞行 3:被击 
		private var m_effFrameRateList:Vector.<uint>; // 特效帧率
		private var m_effFrameRateList1:Vector.<uint>; // 特效帧率
		private var m_act2FrameRate:Dictionary; // 动作到帧率的映射
		
		public var m_ShiQiEff:EffectEntity; // 士气特效
		protected var m_fightGrid:FightGrid;
		protected var m_NpcbaseItem:TNpcBattleItem;
		
		private var m_alphaFadeAni:AniPropertys;	//alpha变化动画
		protected var m_hurtOrigPos:Point; // 受伤的时候后退的原始位置
		private var m_bHideOnHP:Boolean;	//当前，有这样的规则：当兵力减少，格子上的npc数量也减少。如果此对象就是那个减少的npc，则此字段设为true
		
		//protected var m_subState:uint; // 子状态，技能子状态记录在 m_skillData.skillState 这个里面
		protected var m_hurtVel:Point; // 受伤的时候运行速度，攻击时候如果需要改变位置，记录位置
		protected var m_hurtDist:int; // 受伤移动的距离，整数是向前移动，负数是向后移动
		
		public var m_beingTail:Vector.<BeingTail>; // 拖尾效果
		protected var m_fadeVel:Number; // 消失速度
		
		protected var m_attEffIDList:Vector.<String>; // 这个是攻击的时候释放的攻击特效，紧身攻击的时候需要判断攻击特效是否播放完的
		protected var m_hurtEffOffX:Number; // 人物受伤时候偏移，特效需要偏移的距离，域人物偏移距离这鞥好相反，例如人物偏移 10 ，那么这个值就是 -10
		protected var m_callback:Function; // 这个是回调函数，飞行特效用来通知其它进行相关的处理
		protected var m_onMoveComplete:Function; //移动到目的地点后回调此函数
		protected var m_skillitem:TSkillBaseItem; // 技能数据
		protected var m_skillData:SkillData; // 技能相关的数据
		//protected var m_bemove:Boolean;		// 最终被移除,死亡需要 alpha = 0 后才能移除
		protected var m_hp:uint = 100;		// 血量    
		public var m_index:int;
		// 调试使用
		protected var m_headTopBlockBase:HeadTopBlockBase;	
		
		public function NpcBattle(defObj:XML, scene:fScene)
		{
			super(defObj, scene);
			m_type = EntityCValue.TBattleNpc;
			m_topEmptySprite = null;
			m_botEmptySprite = null;
			m_ShiQiEff = null;
			m_subState = EntityCValue.STNone;
			m_hurtVel = new Point(20);
			m_hurtDist = -30;
			m_beingTail = new Vector.<BeingTail>();
			m_fadeVel = 5;
			
			m_attEffIDList = new Vector.<String>();
			m_hurtEffOffX = 0;
			m_skillData = new SkillData();
			m_fightList = new FightList(this);
		
			//m_headTopBlockBase = new TopBlockNpcBattle(gkcontext,this);
		}
		
		public function setUpdateCurrentFrameMode(mode:int):void
		{
			if (this.customData.flash9Renderer)
			{
				(customData.flash9Renderer as fFlash9ObjectSeqRenderer).setUpdateCurrentFrameMode(mode);
			}			
		}
		// 拷贝 BeingEntity ，注意同步更新    
		override public function onTick(deltaTime:Number):void
		{
			// 更新移动     
			this.updateMove(deltaTime);
			// 更新状态动作
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			
			// 重新计算速度
			var framerate:uint;
			var framecnt:uint;
			var nextPt:Number;
			var eff:EffectEntity;
			
			if (m_state == EntityCValue.TAttack)
			{
				// bug: 这个增加计数的放在最后吧，这样如果在 0 帧波特小才行   
				//m_skillData.incFrame();
				m_skillData.curFrame = (this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame;
				
				// 技能攻击需要记录攻击帧数   
				if (m_skillData.skillBaseItem)
				{
					if (this.customData.flash9Renderer.aniOver())
					{
						// 如果是技能攻击动作结束
						if (EntityCValue.SSATT == m_skillData.skillState)
						{
							// 攻击动作结束，如果有前后移动，就应该回到原来位置
							if (m_NpcbaseItem.npcBattleModel.m_attFrame != -1)
							{
								if (this.x != m_hurtOrigPos.x)
								{
									this.moveTo(this.m_hurtOrigPos.x, this.m_hurtOrigPos.y, 0);
								}
							}
							
							// 直接使用之前保存的表
							//skillitem = (this.m_context.m_gkcontext as GkContext).m_skillMgr.skillItem(m_skillData.skillID);
							skillitem = m_skillitem;
							if (skillitem)
							{
								// 所有的特效都是两层，上层
								// 这个地方这么判断好像有问题
								//if (skillitem.attActEffFrame() == 0)
								// 应该这样判断如果有飞行特效，并且飞行特效帧数为0，就说明在攻击动作结束后播放
								if (skillitem.hasAttFlyEff() && skillitem.attFlyEffFrame() == 0)
								{
									// 播放攻击特效
									// addFlyEffect(skillitem.attFlyEff());
									// 攻击飞行特效放在 emptysprite
									// 如果飞行特效以格子为单位，这个时候 bindType 表示攻击特效类型
									if (EntityCValue.EBGrid == m_fightGrid.bindType)
									{
										if (m_topEmptySprite)
										{
											eff = m_topEmptySprite.addFlyEffect(skillitem.attFlyEff(), m_effFrameRateList[2]);
											if (m_callback != null)
											{
												eff.callback = m_callback;
												m_callback = null;
											}
										}
											// 将攻击后的受伤变现分发出去    
											// attack2Hurt();
											// 清理最近一次攻击的状态    
											//clearAttackState();
									}
									else // 以每一个人为单位
									{
										// 检查飞行特效是否需要延迟播放
										if (m_fightList.m_attackVec[0].delayEff)
										{
											addDeferFlyEff(skillitem.attFlyEff(), m_effFrameRateList[2]);
										}
										else
										{
											eff = addFlyEffect(skillitem.attFlyEff(), m_effFrameRateList[2]);
											if (m_callback != null && m_topEmptySprite)
											{
												eff.callback = m_callback;
												m_callback = null;
											}
										}
									}
								}
								else if (skillitem.hasAttFlyEff1() && skillitem.attFlyEffFrame1() == 0) // 下层
								{
									// 播放攻击特效
									// addFlyEffect(skillitem.attFlyEff());
									// 攻击飞行特效放在 emptysprite
									// 如果飞行特效以格子为单位，这个时候 bindType 表示攻击特效类型
									if (EntityCValue.EBGrid == m_fightGrid.bindType)
									{
										if (m_topEmptySprite)
										{
											eff = m_topEmptySprite.addFlyEffect(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
												// 回调函数是不是只回调一个就行了
												//if(m_callback != null)
												//{
												//	eff.callback = m_callback;
												//	m_callback = null;
												//}
										}
											// 将攻击后的受伤变现分发出去    
											// attack2Hurt();
											// 清理最近一次攻击的状态    
											//clearAttackState();
									}
									else // 以每一个人为单位
									{
										// 检查飞行特效是否需要延迟播放
										if (m_fightList.m_attackVec[0].delayEff)
										{
											addDeferFlyEff(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
										}
										else
										{
											eff = addFlyEffect(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
												// 回调函数是不是只回调一个就行了
												//if(m_callback != null && m_topEmptySprite)
												//{
												//	eff.callback = m_callback;
												//	m_callback = null;
												//}
										}
									}
								}
							}
							// 清理最近一次攻击的状态    
							clearAttackState();
						}
						else // 技能准备动作结束   
						{
							m_skillData.skillState = EntityCValue.SSATT;
							// 改变技能动作  
							this.gotoAndPlay(null);
						}
					}
					else // 动作没有结束  
					{
						if (EntityCValue.SSPRE == m_skillData.skillState)
						{
							// 直接使用数据
							//skillitem = (this.m_context.m_gkcontext as GkContext).m_skillMgr.skillItem(m_skillData.skillID);
							skillitem = m_skillitem;
							// 准备阶段没有什么特殊需求 
							//if (skillitem.hasPreAct())
							//{
							// 技能前奏，直接添加前奏特效  
							//if (skillitem.hasAttPreEff() && m_skillData.curFrame == 0)
							// 所有的特效都是两层，上层
							if (skillitem.hasAttPreEff() && m_skillData.equal(0))
							{
								if (fUtil.effLinkLayer(skillitem.preActEff(), this.m_context))
								{
									if (m_botEmptySprite)
									{
										m_botEmptySprite.addLinkEffect(skillitem.preActEff(), m_effFrameRateList[3], false);
									}
								}
								else
								{
									if (m_topEmptySprite)
									{
										m_topEmptySprite.addLinkEffect(skillitem.preActEff(), m_effFrameRateList[0]);
									}
								}
							}
							else if (skillitem.hasAttPreEff1() && m_skillData.equal(0)) // 下层
							{
								if (fUtil.effLinkLayer(skillitem.preActEff1(), this.m_context))
								{
									if (m_botEmptySprite)
									{
										m_botEmptySprite.addLinkEffect(skillitem.preActEff1(), m_effFrameRateList1[3], false);
									}
								}
								else
								{
									if (m_topEmptySprite)
									{
										m_topEmptySprite.addLinkEffect(skillitem.preActEff1(), m_effFrameRateList1[0]);
									}
								}
							}
								//}
						}
						else if (EntityCValue.SSATT == m_skillData.skillState)
						{
							// 攻击动作中，如果有前后移动
							if (m_NpcbaseItem.npcBattleModel.m_attFrame != -1)
							{
								// 第一个阶段
								if (m_NpcbaseItem.npcBattleModel.m_attFrame <= m_skillData.curFrame)
								{
									if (EntityCValue.RKLeft == m_fightGrid.side)
									{
										this.moveTo(this.x + m_hurtVel.x * deltaTime, this.y, 0);
									}
									else
									{
										this.moveTo(this.x - m_hurtVel.x * deltaTime, this.y, 0);
									}
								}
								else // 第二个阶段
								{
									if (m_subState != EntityCValue.ATTForth)
									{
										m_subState = EntityCValue.ATTForth;
										
										framerate = this.getActFrameRate(EntityCValue.TActAttack);
										framecnt = this.getActFrameCnt(EntityCValue.TActAttack);
										m_hurtVel.x = (m_NpcbaseItem.npcBattleModel.m_attDist * framerate) / (framecnt - 1 - m_NpcbaseItem.npcBattleModel.m_attFrame);
									}
									
									if (EntityCValue.RKLeft == m_fightGrid.side)
									{
										// 判断位置是否移动过了
										nextPt = this.x - m_hurtVel.x * deltaTime;
										// 向前移动
										if (m_NpcbaseItem.npcBattleModel.m_attDist > 0)
										{
											if (nextPt > m_hurtOrigPos.x)
											{
												this.moveTo(nextPt, this.y, 0);
											}
										}
										else
										{
											if (nextPt < m_hurtOrigPos.x)
											{
												this.moveTo(nextPt, this.y, 0);
											}
										}
									}
									else
									{
										// 判断位置是否移动过了
										nextPt = this.x + m_hurtVel.x * deltaTime;
										if (m_NpcbaseItem.npcBattleModel.m_attDist > 0)
										{
											if (nextPt < m_hurtOrigPos.x)
											{
												this.moveTo(nextPt, this.y, 0);
											}
										}
										else
										{
											if (nextPt > m_hurtOrigPos.x)
											{
												this.moveTo(nextPt, this.y, 0);
											}
										}
									}
								}
							}
							
							// 攻击过程  
							// 数据直接使用
							//skillitem = (this.m_context.m_gkcontext as GkContext).m_skillMgr.skillItem(m_skillData.skillID);
							skillitem = m_skillitem;
							if (skillitem)
							{
								// 如果需要在某一帧释放攻击动作  
								//if (skillitem.hasAttActEff() && skillitem.attActEffFrame() != 0)
								// 所有的特效都是两层，上层
								if (skillitem.hasAttActEff())
								{
									//if (skillitem.attActEffFrame() == m_skillData.curFrame)
									if (m_skillData.equal(skillitem.attActEffFrame()))
									{
										if (fUtil.effLinkLayer(skillitem.attActEff(), this.m_context))
										{
											if (m_botEmptySprite)
											{
												if (m_fightGrid.attType != EntityCValue.ATTFar)
												{
													m_attEffIDList.push(skillitem.attActEff()); // 记录攻击特效
												}
												m_botEmptySprite.addLinkEffect(skillitem.attActEff(), m_effFrameRateList[3], false);
											}
										}
										else
										{
											if (m_topEmptySprite)
											{
												if (m_fightGrid.attType != EntityCValue.ATTFar)
												{
													m_attEffIDList.push(skillitem.attActEff()); // 记录攻击特效
												}
												m_topEmptySprite.addLinkEffect(skillitem.attActEff(), m_effFrameRateList[1]);
											}
										}
									}
								}
								else if (skillitem.hasAttActEff1()) // 下层
								{
									//if (skillitem.attActEffFrame() == m_skillData.curFrame)
									if (m_skillData.equal(skillitem.attActEffFrame1()))
									{
										if (fUtil.effLinkLayer(skillitem.attActEff1(), this.m_context))
										{
											if (m_botEmptySprite)
											{
												if (m_fightGrid.attType != EntityCValue.ATTFar)
												{
													m_attEffIDList.push(skillitem.attActEff1()); // 记录攻击特效
												}
												m_botEmptySprite.addLinkEffect(skillitem.attActEff1(), m_effFrameRateList1[3], false);
											}
										}
										else
										{
											if (m_topEmptySprite)
											{
												if (m_fightGrid.attType != EntityCValue.ATTFar)
												{
													m_attEffIDList.push(skillitem.attActEff1()); // 记录攻击特效
												}
												m_topEmptySprite.addLinkEffect(skillitem.attActEff1(), m_effFrameRateList1[1]);
											}
										}
									}
								}
								// 所有的特效都是两层，上层
								if (skillitem.hasAttFlyEff() && skillitem.attFlyEffFrame() != 0)
								{
									//if (skillitem.attFlyEffFrame() == m_skillData.curFrame)
									if (m_skillData.equal(skillitem.attFlyEffFrame()))
									{
										if (EntityCValue.EBGrid == m_fightGrid.bindType)
										{
											if (m_topEmptySprite)
											{
												eff = m_topEmptySprite.addFlyEffect(skillitem.attFlyEff(), m_effFrameRateList[2]);
												if (m_callback != null)
												{
													eff.callback = m_callback;
													m_callback = null;
												}
											}
										}
										else
										{
											if (m_fightList.m_attackVec[0].delayEff)
											{
												addDeferFlyEff(skillitem.attFlyEff(), m_effFrameRateList[2]);
											}
											else
											{
												eff = addFlyEffect(skillitem.attFlyEff(), m_effFrameRateList[2]);
												if (m_callback != null && m_topEmptySprite)
												{
													eff.callback = m_callback;
													m_callback = null;
												}
											}
										}
									}
								}
								else if (skillitem.hasAttFlyEff1() && skillitem.attFlyEffFrame1() != 0) // 下层
								{
									//if (skillitem.attFlyEffFrame() == m_skillData.curFrame)
									if (m_skillData.equal(skillitem.attFlyEffFrame1()))
									{
										if (EntityCValue.EBGrid == m_fightGrid.bindType)
										{
											if (m_topEmptySprite)
											{
												eff = m_topEmptySprite.addFlyEffect(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
													// 回调函数是不是只回调一个就行了
													//if(m_callback != null)
													//{
													//	eff.callback = m_callback;
													//	m_callback = null;
													//}
											}
										}
										else
										{
											if (m_fightList.m_attackVec[0].delayEff)
											{
												addDeferFlyEff(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
											}
											else
											{
												eff = addFlyEffect(skillitem.attFlyEff1(), m_effFrameRateList1[2]);
												
													// 回调函数是不是只回调一个就行了
													//if(m_callback != null && m_topEmptySprite)
													//{
													//	eff.callback = m_callback;
													//	m_callback = null;
													//}
											}
										}
									}
								}
							}
						}
					}
				}
				else // 普通攻击    
				{
					// 直接使用之前保存的表
					//battlenpcitem = (this.m_context.m_gkcontext as GkContext).m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, this.tempid) as TNpcBattleItem;
					battlenpcitem = m_NpcbaseItem;
					//攻击动作结束 
					if (this.customData.flash9Renderer.aniOver())
					{
						// 攻击动作结束，如果有前后移动，就应该回到原来位置
						if (m_NpcbaseItem.npcBattleModel.m_attFrame != -1)
						{
							if (this.x != m_hurtOrigPos.x)
							{
								this.moveTo(this.m_hurtOrigPos.x, this.m_hurtOrigPos.y, 0);
							}
						}
						
						// bug: 如果是主角，这个内容是空的，因此不能释放攻击特效
						if (battlenpcitem)
						{
							// 0 说明攻击动作完成，播放飞行特效
							// 所有的特效都是两层，上层
							if (battlenpcitem.npcBattleModel.attFlyEffFrame() == 0 && battlenpcitem.npcBattleModel.hasAttFlyEff())
							{
								if (EntityCValue.EBGrid == m_fightGrid.bindType)
								{
									if (m_topEmptySprite)
									{
										eff = m_topEmptySprite.addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
										if (m_callback != null)
										{
											eff.callback = m_callback;
											m_callback = null;
										}
									}
								}
								else
								{
									if (m_fightList.m_attackVec[0].delayEff)
									{
										addDeferFlyEff(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
									}
									else
									{
										eff = addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
										if (m_callback != null && m_topEmptySprite)
										{
											eff.callback = m_callback;
											m_callback = null;
										}
									}
								}
							}
							else if (battlenpcitem.npcBattleModel.attFlyEffFrame1() == 0 && battlenpcitem.npcBattleModel.hasAttFlyEff1()) // 下层
							{
								if (EntityCValue.EBGrid == m_fightGrid.bindType)
								{
									if (m_topEmptySprite)
									{
										eff = m_topEmptySprite.addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
											// 回调函数是不是只回调一个就行了
											//if(m_callback != null)
											//{
											//	eff.callback = m_callback;
											//	m_callback = null;
											//}
									}
								}
								else
								{
									if (m_fightList.m_attackVec[0].delayEff)
									{
										addDeferFlyEff(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
									}
									else
									{
										eff = addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
											// 回调函数是不是只回调一个就行了
											//if(m_callback != null && m_topEmptySprite)
											//{
											//	eff.callback = m_callback;
											//	m_callback = null;
											//}
									}
								}
							}
						}
						// 将攻击后的受伤变现分发出去    
						// attack2Hurt();
						// 清理最近一次攻击的状态    
						clearAttackState();
					}
					else // 攻击动作没有结束  
					{
						// 攻击动作中，如果有前后移动
						if (m_NpcbaseItem.npcBattleModel.m_attFrame != -1)
						{
							// 第一个阶段
							if (m_skillData.curFrame <= m_NpcbaseItem.npcBattleModel.m_attFrame)
							{
								if (EntityCValue.RKLeft == m_fightGrid.side)
								{
									this.moveTo(this.x + m_hurtVel.x * deltaTime, this.y, 0);
								}
								else
								{
									this.moveTo(this.x - m_hurtVel.x * deltaTime, this.y, 0);
								}
							}
							else // 第二个阶段
							{
								if (m_subState != EntityCValue.ATTForth)
								{
									m_subState = EntityCValue.ATTForth;
									
									framerate = this.getActFrameRate(EntityCValue.TActAttack);
									framecnt = this.getActFrameCnt(EntityCValue.TActAttack);
									m_hurtVel.x = (m_NpcbaseItem.npcBattleModel.m_attDist * framerate) / (framecnt - 1 - m_NpcbaseItem.npcBattleModel.m_attFrame);
								}
								
								if (EntityCValue.RKLeft == m_fightGrid.side)
								{
									// 判断位置是否移动过了
									nextPt = this.x - m_hurtVel.x * deltaTime;
									// 向前移动
									if (m_NpcbaseItem.npcBattleModel.m_attDist > 0)
									{
										if (nextPt > m_hurtOrigPos.x)
										{
											this.moveTo(nextPt, this.y, 0);
										}
									}
									else
									{
										if (nextPt < m_hurtOrigPos.x)
										{
											this.moveTo(nextPt, this.y, 0);
										}
									}
								}
								else
								{
									// 判断位置是否移动过了
									nextPt = this.x + m_hurtVel.x * deltaTime;
									if (m_NpcbaseItem.npcBattleModel.m_attDist > 0)
									{
										if (nextPt < m_hurtOrigPos.x)
										{
											this.moveTo(nextPt, this.y, 0);
										}
									}
									else
									{
										if (nextPt > m_hurtOrigPos.x)
										{
											this.moveTo(nextPt, this.y, 0);
										}
									}
								}
							}
						}
						
						if (battlenpcitem)
						{
							// bug: 攻击特效 0 帧播放就是在开始就播放    
							//if (battlenpcitem.hasAttActEff() && battlenpcitem.attActEffFrame() != 0)
							// 所有的特效都是两层，上层
							if (battlenpcitem.npcBattleModel.hasAttActEff())
							{
								// bug: 一帧中可能多次进入这个函数，可能1帧10秒，但是，每一个间隔都会走进来
								//if (battlenpcitem.attActEffFrame() == m_skillData.curFrame)
								if (m_skillData.equal(battlenpcitem.npcBattleModel.attActEffFrame()))
								{
									if (fUtil.effLinkLayer(battlenpcitem.npcBattleModel.attActEff(), this.m_context))
									{
										if (m_botEmptySprite)
										{
											if (m_fightGrid.attType != EntityCValue.ATTFar)
											{
												m_attEffIDList.push(battlenpcitem.npcBattleModel.attActEff()); // 记录攻击特效
											}
											m_botEmptySprite.addLinkEffect(battlenpcitem.npcBattleModel.attActEff(), m_effFrameRateList[3], false);
										}
									}
									else
									{
										if (m_topEmptySprite)
										{
											if (m_fightGrid.attType != EntityCValue.ATTFar)
											{
												m_attEffIDList.push(battlenpcitem.npcBattleModel.attActEff()); // 记录攻击特效
											}
											m_topEmptySprite.addLinkEffect(battlenpcitem.npcBattleModel.attActEff(), m_effFrameRateList[1]);
										}
									}
								}
							}
							else if (battlenpcitem.npcBattleModel.hasAttActEff1()) // 下层
							{
								// bug: 一帧中可能多次进入这个函数，可能1帧10秒，但是，每一个间隔都会走进来
								//if (battlenpcitem.attActEffFrame() == m_skillData.curFrame)
								if (m_skillData.equal(battlenpcitem.npcBattleModel.attActEffFrame1()))
								{
									if (fUtil.effLinkLayer(battlenpcitem.npcBattleModel.attActEff1(), this.m_context))
									{
										if (m_botEmptySprite)
										{
											if (m_fightGrid.attType != EntityCValue.ATTFar)
											{
												m_attEffIDList.push(battlenpcitem.npcBattleModel.attActEff1()); // 记录攻击特效
											}
											m_botEmptySprite.addLinkEffect(battlenpcitem.npcBattleModel.attActEff1(), m_effFrameRateList1[3], false);
										}
									}
									else
									{
										if (m_topEmptySprite)
										{
											if (m_fightGrid.attType != EntityCValue.ATTFar)
											{
												m_attEffIDList.push(battlenpcitem.npcBattleModel.attActEff1()); // 记录攻击特效
											}
											m_topEmptySprite.addLinkEffect(battlenpcitem.npcBattleModel.attActEff1(), m_effFrameRateList1[1]);
										}
									}
								}
							}
							// 所有的特效都是两层，上层
							if (battlenpcitem.npcBattleModel.hasAttFlyEff() && battlenpcitem.npcBattleModel.attFlyEffFrame() != 0)
							{
								//if (battlenpcitem.attFlyEffFrame() == m_skillData.curFrame)
								if (m_skillData.equal(battlenpcitem.npcBattleModel.attFlyEffFrame()))
								{
									if (EntityCValue.EBGrid == m_fightGrid.bindType)
									{
										if (m_topEmptySprite)
										{
											eff = m_topEmptySprite.addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
											if (m_callback != null)
											{
												eff.callback = m_callback;
												m_callback = null;
											}
										}
									}
									else
									{
										if (m_fightList.m_attackVec[0].delayEff)
										{
											addDeferFlyEff(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
										}
										else
										{
											eff = addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff(), m_effFrameRateList[2]);
											if (m_callback != null && m_topEmptySprite)
											{
												eff.callback = m_callback;
												m_callback = null;
											}
										}
									}
								}
							}
							else if (battlenpcitem.npcBattleModel.hasAttFlyEff1() && battlenpcitem.npcBattleModel.attFlyEffFrame1() != 0) // 下层
							{
								//if (battlenpcitem.attFlyEffFrame() == m_skillData.curFrame)
								if (m_skillData.equal(battlenpcitem.npcBattleModel.attFlyEffFrame1()))
								{
									if (EntityCValue.EBGrid == m_fightGrid.bindType)
									{
										if (m_topEmptySprite)
										{
											eff = m_topEmptySprite.addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
												// 回调函数是不是只回调一个就行了
												//if(m_callback != null)
												//{
												//	eff.callback = m_callback;
												//	m_callback = null;
												//}
										}
									}
									else
									{
										if (m_fightList.m_attackVec[0].delayEff)
										{
											addDeferFlyEff(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
										}
										else
										{
											eff = addFlyEffect(battlenpcitem.npcBattleModel.attFlyEff1(), m_effFrameRateList1[2]);
												// 回调函数是不是只回调一个就行了
												//if(m_callback != null && m_topEmptySprite)
												//{
												//	eff.callback = m_callback;
												//	m_callback = null;
												//}
										}
									}
								}
							}
						}
					}
				}
				
					// bug 这个帧数不应该每一次循环添加 1 ，应该取动作中的帧数
					// m_skillData.incFrame();
					// m_skillData.curFrame = (this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame;
			}
			else if (m_state == EntityCValue.THurt)
			{
				// 受伤后自动回复站立状态
				// 如果不是受伤向前返回子状态
				if (EntityCValue.HTForth != m_subState)
				{
					if (this.customData.flash9Renderer.aniOver())
					{
						// 如果在向后运动的时候结束动作
						if (EntityCValue.HTBack == m_subState)
						{
							m_subState = EntityCValue.HTForth;
							setUpdateCurrentFrameMode(EntityCValue.UpdateCurrentFrameMode_Decrease);
						}
							//else if(EntityCValue.HTForth == m_subState)	// 这个地方不可能进来的
							//{
							// 暂时直接回到原始状态
							// this.moveTo(this.m_hurtOrigPos.x, this.m_hurtOrigPos.y, 0);
						
							//clearHurtState();
							//}
					}
					else
					{
						// 如果是左边的队伍，向左后退
						if (EntityCValue.RKLeft == m_fightGrid.side)
						{
							nextPt = this.x + m_hurtVel.x * deltaTime;
							this.moveTo(nextPt, this.y, 0);
							hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
						}
						else
						{
							nextPt = this.x - m_hurtVel.x * deltaTime;
							this.moveTo(nextPt, this.y, 0);
							hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
						}
					}
				}
				else
				{
					// 受伤返回，结束帧是第 0 帧
					if ((this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame == 0)
					{
						setUpdateCurrentFrameMode(EntityCValue.UpdateCurrentFrameMode_Increase);
						// 如果没有回到原点，直接回到原点
						if (this.x != m_hurtOrigPos.x)
						{
							this.moveTo(this.m_hurtOrigPos.x, this.m_hurtOrigPos.y, 0);
							hurtEffOffX = 0;
						}
						clearHurtState();
					}
					else
					{
						// 在这里进行帧减少
						//(this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame -= 1;
						// 如果是左边的队伍，向左后退
						if (EntityCValue.RKLeft == m_fightGrid.side)
						{
							nextPt = this.x - m_hurtVel.x * deltaTime;
							
							// 判断位置是否移动过了
							if (m_hurtDist > 0)
							{
								if (nextPt > m_hurtOrigPos.x)
								{
									this.moveTo(nextPt, this.y, 0);
									hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
								}
							}
							else
							{
								if (nextPt < m_hurtOrigPos.x)
								{
									this.moveTo(nextPt, this.y, 0);
									hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
								}
							}
						}
						else
						{
							nextPt = this.x + m_hurtVel.x * deltaTime;
							// 判断位置是否移动过了
							if (m_hurtDist > 0)
							{
								if (nextPt < m_hurtOrigPos.x)
								{
									this.moveTo(nextPt, this.y, 0);
									hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
								}
							}
							else
							{
								if (nextPt > m_hurtOrigPos.x)
								{
									this.moveTo(nextPt, this.y, 0);
									hurtEffOffX = nextPt - this.m_hurtOrigPos.x;
								}
							}
						}
					}
				}
				
				if (m_topEmptySprite)
				{
					m_topEmptySprite.hurtEffOffX = m_hurtEffOffX;
					m_botEmptySprite.hurtEffOffX = m_hurtEffOffX;
				}
			}
			else if (m_state == EntityCValue.TCAttack) // 反击攻击
			{
				if (this.customData.flash9Renderer.aniOver())
				{
					// 清理最近一次攻击的状态    
					clearAttackState();
				}
			}
			else if (m_state == EntityCValue.TCHurt) // 反击受伤
			{
				// 受伤后自动回复站立状态        
				if (this.customData.flash9Renderer.aniOver())
				{
					clearHurtState();
				}
			}
			// 更新战斗  
			this.m_fightList.onTick(deltaTime);
			
			// 更新特效  
			//var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while (idx >= 0)
			{
				eff = m_effVec[idx];
				// KBEN: 特效不用移动，现在直接挂在实体身上   
				// eff.moveTo(this.x, this.y, this.z);
				if (eff.bdispose)
				{
					removeLinkEffect(eff, idx);
				}
				else
				{
					// 如果受伤的时候不移动，注意这个 eff 的 x 坐标此时一定要是 0，非 0 的没有考虑
					// bug 添加到这特效会移动
					//if(eff.definition.hurtMove)
					//{
					//eff.moveTo(-m_hurtEffOffX, eff.y, 0);
					//}
					eff.onTick(deltaTime);
				}
				--idx;
			}
			
						
			// 更新动作    
			//super.onTick(deltaTime);
			// KBEN: 可视化判断，需要添加    
			if (customData.flash9Renderer)
			{
				customData.flash9Renderer.onTick(deltaTime);
			}
			
			// 遍历所有的内容进行减少 alpha 
			var tail:BeingTail;
			var fadeoutcnt:uint = 0;
			for each (tail in m_beingTail)
			{
				tail.m_alpha -= m_fadeVel * deltaTime;
				if (tail.m_alpha < 0)
				{
					++fadeoutcnt;
				}
			}
			
			if (fadeoutcnt)
			{
				m_beingTail.splice(0, fadeoutcnt);
			}
		}
		
		
		public function alphaFade(bTo1:Boolean):void
		{
			var destValue:Number;
			if (bTo1)
			{
				destValue = 1;
			}
			else
			{
				destValue = 0;
			}
			
			if (m_alphaFadeAni == null)
			{
				m_alphaFadeAni = new AniPropertys();
				m_alphaFadeAni.sprite = this;
				m_alphaFadeAni.useFrames = true;
				m_alphaFadeAni.duration = 25;
				m_alphaFadeAni.repeatCount = 1;
			}
			m_alphaFadeAni.resetValues( { alpha:destValue });
			m_alphaFadeAni.begin();
		}
		//override public function updateMove(deltaTime:Number):void
		//{
		//super.updateMove(deltaTime);
		
		//if (isMoving())
		//{
		// 更新 EmptySprite 位置
		//if(m_topEmptySprite)
		//{
		//m_topEmptySprite.moveTo(this.x - m_topEmptySprite.xFollowOff, this.y - m_topEmptySprite.yFollowOff, this.z);
		//m_botEmptySprite.moveTo(this.x - m_botEmptySprite.xFollowOff, this.y - m_botEmptySprite.yFollowOff, this.z);
		//}
		//}
		//}
		
		override public function dispose():void
		{
			if (m_headTopBlockBase)
			{
				m_headTopBlockBase.dispose();
				m_headTopBlockBase = null;
			}
			
			if (m_fightDB.m_fightControl.getUIBattleTip() != null)
			{
				(m_fightDB.m_fightControl.getUIBattleTip() as UIBattleTip).onNpcBattleDispose(this);
			}
			var idx:uint = 0;
			
			m_onMoveComplete = null;
			m_callback = null;
			m_fightGrid = null;
			
			if (m_topEmptySprite)
			{
				m_topEmptySprite.followBeing = null;
				m_topEmptySprite = null;
			}
			if (m_botEmptySprite)
			{
				m_botEmptySprite.followBeing = null;
				m_botEmptySprite = null;
			}
			
			m_effFrameRateList = null;
			m_effFrameRateList1 = null;
			
			m_ShiQiEff = null;
			m_NpcbaseItem = null;
			m_act2FrameRate = null;
			m_hurtOrigPos = null;
			if (m_beingTail)
			{
				while (idx < m_beingTail.length)
				{
					if (m_beingTail[idx].m_image)
					{
						//m_beingTail[idx].m_image.dispose();
						// bug: 这个不要释放,会导致问题,公共资源释放
						m_beingTail[idx].m_image = null;
					}
					
					++idx;
				}
				m_beingTail.length = 0;
				m_beingTail = null;
			}
			
			if (m_attEffIDList)
			{
				m_attEffIDList.length = 0;
				m_attEffIDList = null;
			}
			
			m_skillitem = null;
			m_skillData = null;
			
			super.dispose();
			if (m_alphaFadeAni)
			{
				m_alphaFadeAni.dispose();
			}
		}
		
		// KBEN: 取出攻击动作进行处理     
		public function playAttack(item:AttackItem):void
		{
			// 取出技能 id  
			if (item.m_skillBaseitem)
			{
				m_skillData.skillBaseItem = item.m_skillBaseitem;
				// 获取技能数据
				m_skillitem = item.m_skillBaseitem as TSkillBaseItem;
			}
			else
			{
				m_skillData.skillBaseItem = null;
				m_skillitem = null;
			}
			// 飞行特效回调
			m_callback = item.callback;
			// 切换动作，添加特效，攻击只支持一个，只支持玩家和战斗npc，需要的再加
			attackTo(null);
			//playAttMsc();		// 播放音效
		}
		
		override public function attackTo(hurt:BeingEntity):void
		{
			if (EntityCValue.RKLeft == this.m_side)
			{
				this.m_angle = 0;
			}
			else
			{
				this.m_angle = 180;
			}
			
			this.orientation = this.m_angle;
			this.attack()
		}
		
		/**
		 * @param	defID: 这个就是配置文件 <effect id="eff1" definition="effseqpic" solid="false" x="200" y="200" z="0" start="true"/> 中的 definition="effseqpic" 这个 definition 的值，这个是重复特效
		 */
		override public function addLinkEffect(defID:String, framerate:uint = 0, repeat:Boolean = false, efftype:uint = 0):EffectEntity
		{
			var eff:EffectEntity = this.scene.createEffectNIScene(fUtil.elementID(this.m_context, EntityCValue.TEfffect), defID, 0, 0, 0);
			if (framerate)
			{
				eff.frameRate = framerate;
			}
			if (repeat)
			{
				eff.repeat = repeat
			}
			// 添加到身上的特效 0: 都是站在格子右边的人物正确的，BeingEntity 都是原始特效，只有战斗npc特效才需要翻转
			if (efftype == EntityCValue.EffAtt)
			{
				if (this.side != eff.definition.effDir)
				{
					eff.bFlip = EntityCValue.FLPX;
				}
			}
			else
			{
				if (this.side == eff.definition.effDir)
				{
					eff.bFlip = EntityCValue.FLPX;
				}
			}
			// 设置偏移
			var offpt:Point = this.m_context.linkOff(fUtil.modelInsNum(this.m_insID), fUtil.modelInsNum(eff.m_insID));
			if (offpt)
			{
				if (eff.bFlip)
				{
					eff.modeleffOff(-offpt.x, offpt.y);
				}
				else
				{
					eff.modeleffOff(offpt.x, offpt.y);
				}
			}
			eff.type = EntityCValue.EFFLink;
			
			//eff.repeatDic[0] = repeat;
			// bug: 特效是否重复播放定义在定义文件中    
			//eff.definition.dicAction[0].repeat = repeat;
			//eff.linkedBeing = this;	// 一个链接特效只能关联到一个特效上面  
			// 设置偏移
			//var offpt:Point = this.m_context.linkOff(fUtil.modelInsNum(this.m_insID), fUtil.modelInsNum(eff.m_insID));
			//if(offpt)
			//{
			//eff.modeleffOff(offpt.x, offpt.y);
			//}
			
			m_effVec.push(eff);
			
			// 切换特效父容器，这一行代码要在 activateScene 之后执行才行  
			// 判断是在那一层  
			
			var layer:DisplayObjectContainer;
			layer = ((this.customData.flash9Renderer) as fFlash9ElementRenderer).layerContainer(eff.definition.layer);
			(eff.customData.flash9Renderer as fFlash9ElementRenderer).changeContainerParent(layer);
			//(eff.customData.flash9Renderer as fFlash9ElementRenderer).changeContainerParent(this.container);
			
			// KBEN: 如果当前特效场景可视   
			if (this.isVisibleNow)
			{
				eff.show();
				eff.isVisibleNow = true;
			}
			
			var r:fFlash9ElementRenderer = this.customData.flash9Renderer;
			// KBEN: 如果当前人物屏幕可视，那么让特效也可视吧    
			if (r.screenVisible)
			{
				this.scene.renderEngine.showElement(eff);
				eff.start();
			}
			return eff;
		}
		
		// 这个就是增加攻击特效    
		public function addFlyEffect(defID:String, framerate:uint = 0, flyvel:Number = 0):EffectEntity
		{
			var item:AttackItem = fightList.m_attackVec[0];
			var hurt:fEmptySprite;
			
			if (EntityCValue.TEmptySprite == item.targetList[0].hurtType)
			{
				hurt = this.m_context.m_npcBattleMgr.getEmptySpriteByID(item.targetList[0].hurtID);
			}
			
			var eff:EffectEntity = this.scene.createEffect(fUtil.elementID(this.m_context, EntityCValue.TEfffect), defID, this.x, this.y, this.z, hurt.x + hurt.xOff, hurt.y + hurt.yOff, hurt.z, m_effectSpeed);
			if (framerate)
			{
				eff.frameRate = framerate;
			}
			if (flyvel)
			{
				eff.vel = flyvel;
			}
			if (this.side != eff.definition.effDir)
			{
				eff.bFlip = EntityCValue.FLPX;
			}
			var offpt:Point = this.m_context.linkOff(fUtil.modelInsNum(this.m_insID), fUtil.modelInsNum(eff.m_insID));
			if (offpt)
			{
				if (eff.bFlip)
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
		public function setNpcBaseItem(baseItem:TNpcBattleItem):void
		{
			m_NpcbaseItem = baseItem;
		}
		
		// 这个重载好像没有更改什么内容，因此重写了
		//override public function set tempid(value:uint):void 
		//{
		// 战斗 npc tempid 就是表中的 id ，如果是玩家，则m_tempid == uint.MAX_VALUE
		//m_tempid = value;
		//}
		
		override public function get shiqi():uint
		{
			return m_shiqi;
		}
		
		public function set shiqi(value:uint):void
		{
			m_shiqi = value;
			
			// test : 更新当前头顶显示  
			var content:String;
			var color:uint = 0xffffff;
			
			if (this.m_context.m_config.m_bShowShiQiHp)
			{
				content = this.name + "\n血量: " + this.hp + "\n士气: " + m_shiqi;
				//m_nameDisc = UtilHtml.formatPDirect(content, color, 18);
				m_bredraBillBoard = true;
			}
			//if (customData.flash9Renderer)
			//{
			//(customData.flash9Renderer as fFlash9SceneObjectSeqRenderer).rawTextField = true;
			//}
			
			updateNameDesc();
			
			// 如果士气 >= 100 需要显示特效
			if (m_shiqi >= 100)
			{
				if (!m_ShiQiEff)
				{
					// 如果没有特效，添加特效
					if (fUtil.effLinkLayer(EntityCValue.EFFShiQi, this.m_context))
					{
						if (m_botEmptySprite)
						{
							if (m_topEmptySprite.effVec.length == 0 && m_botEmptySprite.effVec.length == 0)
							{
								m_ShiQiEff = m_botEmptySprite.addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
							}
						}
					}
					else
					{
						if (m_topEmptySprite)
						{
							if (m_topEmptySprite.effVec.length == 0 && m_botEmptySprite.effVec.length == 0)
							{
								m_ShiQiEff = m_topEmptySprite.addLinkEffect(EntityCValue.EFFShiQi, 0, true, EntityCValue.EffHurt);
							}
						}
					}
				}
			}
			else // 如果之前有士气特效，并且 < 100 ，就移除这个特效
			{
				if (m_ShiQiEff)
				{
					if (fUtil.effLinkLayer(EntityCValue.EFFShiQi, this.m_context))
					{
						if (m_botEmptySprite)
						{
							m_botEmptySprite.removeLinkEffect(m_ShiQiEff);
							m_ShiQiEff = null;
						}
					}
					else
					{
						if (m_topEmptySprite)
						{
							m_topEmptySprite.removeLinkEffect(m_ShiQiEff);
							m_ShiQiEff = null;
						}
					}
				}
			}
		}
		public function get hp():uint 
		{
			return m_hp;
		}
		public function set hp(value:uint):void
		{
			m_hp = value;
			
			// test : 更新当前头顶显示  
			var content:String;
			var color:uint = 0xffffff;
			
			if (this.m_context.m_config.m_bShowShiQiHp)
			{
				content = this.name + "\n血量: " + this.hp + "\n士气: " + m_shiqi;
				//m_nameDisc = UtilHtml.formatPDirect(content, color, 18);
				m_bredraBillBoard = true;
			}
			//if (customData.flash9Renderer)
			//{
			//(customData.flash9Renderer as fFlash9SceneObjectSeqRenderer).rawTextField = true;
			//}
		}
		
		override public function get side():uint
		{
			return m_side;
		}
		
		public function set side(value:uint):void
		{
			m_side = value;
		}
		
		override public function get bredraBillBoard():Boolean
		{
			return m_bredraBillBoard;
		}
		
		override public function set bredraBillBoard(value:Boolean):void
		{
			m_bredraBillBoard = value;
		}
		
		public function get topEmptySprite():fEmptySpriteForFight
		{
			return m_topEmptySprite;
		}
		
		public function set topEmptySprite(value:fEmptySpriteForFight):void
		{
			m_topEmptySprite = value;
		}
		
		public function set fightGrid(grid:FightGrid):void
		{
			m_fightGrid = grid;
		}
		
		public function get fightGrid():FightGrid
		{
			return m_fightGrid;
		}
		
		public function get botEmptySprite():fEmptySpriteForFight
		{
			return m_botEmptySprite;
		}
		
		public function set botEmptySprite(value:fEmptySpriteForFight):void
		{
			m_botEmptySprite = value;
		}
		
		public function get effFrameRateList():Vector.<uint>
		{
			return m_effFrameRateList;
		}
		
		public function set effFrameRateList(value:Vector.<uint>):void
		{
			m_effFrameRateList = value;
		}
		
		public function get effFrameRateList1():Vector.<uint>
		{
			return m_effFrameRateList1;
		}
		
		public function set effFrameRateList1(value:Vector.<uint>):void
		{
			m_effFrameRateList1 = value;
		}
		
		public function get act2FrameRate():Dictionary
		{
			return m_act2FrameRate;
		}
		
		public function set act2FrameRate(value:Dictionary):void
		{
			m_act2FrameRate = value;
			updateFrameRate();
		}
		
		public function updateName():void
		{
			if (m_fightGrid == null)
			{
				return;
			}
			this.name = m_fightGrid.matrixInfo.name;
			updateNameDesc();
		}
		
		override public function updateNameDesc():void
		{
			var content:String;
			var color:uint = 0xffffff;
			
			content = this.name;
			//m_nameDisc = UtilHtml.formatPDirect(content, color, 18);
			m_bredraBillBoard = true;
			// 战斗 npc 就不重新绘制了  
			//if (customData.flash9Renderer)
			//{
			//(customData.flash9Renderer as fFlash9SceneObjectSeqRenderer).rawTextField = true;
			//}
			
			if (m_headTopBlockBase)
			{
				m_headTopBlockBase.invalidate();
			}
		}
		
		override public function onCreateAssets():void
		{
			if (!m_headTopBlockBase)
			{
				return;
			}
			var base:Sprite = this.uiLayObj;
			m_headTopBlockBase.addToDisplayList(base);
			if (m_tagBounds2d.height <= 1)
			{
				m_headTopBlockBase.visible = false;
			}
			//m_headTopBlockBase.setPos(m_tagBounds2d.x+m_tagBounds2d.width/2, -this.getTagHeight() - 20);
		}
		
		override public function onSetTagBounds2d():void
		{
			if (!m_headTopBlockBase)
			{
				return;
			}
			
			m_headTopBlockBase.setPos(m_tagBounds2d.x + m_tagBounds2d.width / 2, m_tagBounds2d.y);
			if (m_headTopBlockBase.visible == false)
			{
				m_headTopBlockBase.visible = true;
			}
		}
		
		// 战斗 npc 状态完全走自己的    
		override public function getAction():uint
		{
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			// 攻击动作需要特殊处理，其它动作都一样    
			if (EntityCValue.TAttack == m_state)
			{
				// 技能攻击    
				if (m_skillData.skillBaseItem)
				{
					// 如果技能攻击在准备状态 
					if (EntityCValue.SSPRE == m_skillData.skillState)
					{
						skillitem = m_skillData.skillBaseItem as TSkillBaseItem;
						if (skillitem)
						{
							// 如果有技能前奏动作 
							if (skillitem.hasPreAct())
							{
								// 技能前奏，直接添加前奏特效  
								//if (skillitem.hasAttPreEff())
								//{
								//addLinkEffect(skillitem.preActEff());
								//}
								return skillitem.preAct();
							}
							else // 没有技能前奏动作，直接进入攻击动作  
							{
								// 改变技能攻击状态 
								m_skillData.skillState = EntityCValue.SSATT;
								// 如果第 0 帧播放攻击特效，在这里播放  
								//if (skillitem.hasAttActEff() && skillitem.attActEffFrame() == 0)
								//{
								//addLinkEffect(skillitem.attActEff());
								//}
								return skillitem.attAct();
							}
						}
					}
					else
					{
						// m_skillData.skillState 在其它地方已经改了，因此这里不用改了  
						skillitem = m_skillData.skillBaseItem as TSkillBaseItem;
						if (skillitem)
						{
							//if (skillitem.hasAttActEff() && skillitem.attActEffFrame() == 0)
							//{
							//addLinkEffect(skillitem.attActEff());
							//}
							
							return skillitem.attAct();
						}
					}
				}
				else // 普通攻击，需要读取 npc 表，攻击特效可能不存在，但是飞行特效一定存在       
				{
					// 需要检查是否有特效  
					//battlenpcitem = (this.m_context.m_gkcontext as GkContext).m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, this.tempid) as TNpcBattleItem;
					// bug: 这个地方会不断添加特效的   
					// 为 0 说明立马播放    
					//if (battlenpcitem)
					//{
					//if (battlenpcitem.hasAttActEff() && battlenpcitem.attActEffFrame() == 0)
					//{
					//addLinkEffect(battlenpcitem.attActEff());
					//}
					//}
					return EntityCValue.TActAttack;
				}
			}
			else if (EntityCValue.TDie == m_state)
			{
				// 死亡直接挺在受伤的最后一帧
				// bug: 如果资源加载完成后,这个 flash9Renderer 已经没有了,就会出错. org.ffilmation.engine.elements::fObject/onResLoaded 会调用这个函数 
				if (this.customData.flash9Renderer)
				{
					(this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame = this.definition.dicAction[EntityCValue.TActHurt].xCount - 1;
				}
				return EntityCValue.TActHurt;
			}
			else if (EntityCValue.TCAttack == m_state) // 反击攻击对普通攻击
			{
				return EntityCValue.TActAttack;
			}
			else if (EntityCValue.TCHurt == m_state) // 反击受伤对应普通受伤
			{
				return EntityCValue.TActHurt;
			}
			
			return super.getAction();
		}
		
		override protected function hurt(item:HurtItem):void
		{
			//state = EntityCValue.THurt;
			if (item.m_hurtType == EntityCValue.HTFanJi)
			{
				state = EntityCValue.TCHurt;
			}
			else
			{
				state = EntityCValue.THurt;
			}
			if (item == null || m_fightGrid == null)
			{
				DebugBox.sendToDataBase("NpcBattle::hurt item="+item+",m_fightGrid="+m_fightGrid+","+this.m_bDisposed);
			}
			// 添加受伤特效，特效添加到格子上还是添加到每一个人身上
			// 所有的特效都是两层，上层
			if (item.hurtEffectID != "")
			{
				if (EntityCValue.EBGrid == m_fightGrid.bindType)
				{
					if (fUtil.effLinkLayer(item.hurtEffectID, this.m_context))
					{
						if (m_botEmptySprite)
						{
							m_botEmptySprite.addLinkEffect(item.hurtEffectID, m_effFrameRateList[3], false, EntityCValue.EffHurt);
						}
					}
					else
					{
						if (m_topEmptySprite)
						{
							m_topEmptySprite.addLinkEffect(item.hurtEffectID, m_effFrameRateList[3], false, EntityCValue.EffHurt);
						}
					}
				}
				else // 绑定到人身上
				{
					addLinkEffect(item.hurtEffectID, m_effFrameRateList[3], false, EntityCValue.EffHurt);
				}
			}
			if (item.hurtEffectID1 != "") // 下层
			{
				if (EntityCValue.EBGrid == m_fightGrid.bindType)
				{
					if (fUtil.effLinkLayer(item.hurtEffectID1, this.m_context))
					{
						if (m_botEmptySprite)
						{
							m_botEmptySprite.addLinkEffect(item.hurtEffectID1, m_effFrameRateList1[3], false, EntityCValue.EffHurt);
						}
					}
					else
					{
						if (m_topEmptySprite)
						{
							m_topEmptySprite.addLinkEffect(item.hurtEffectID1, m_effFrameRateList1[3], false, EntityCValue.EffHurt);
						}
					}
				}
				else // 绑定到人身上
				{
					addLinkEffect(item.hurtEffectID1, m_effFrameRateList1[3], false, EntityCValue.EffHurt);
				}
			}
		}
		
		override protected function die(item:HurtItem):void
		{
			state = EntityCValue.TDie;
			
			// 添加受伤特效 
			if (item.hurtEffectID != "")
			{
				if (fUtil.effLinkLayer(item.hurtEffectID, this.m_context))
				{
					if (m_botEmptySprite)
					{
						m_botEmptySprite.addLinkEffect(item.hurtEffectID, m_effFrameRateList[3], false, EntityCValue.EffHurt);
					}
				}
				else
				{
					if (m_topEmptySprite)
					{
						m_topEmptySprite.addLinkEffect(item.hurtEffectID, m_effFrameRateList[3], false, EntityCValue.EffHurt);
					}
				}
			}
		}
		
		// 重新定义模型动作属性   
		override protected function updateFrameRate():void
		{
			var action:fActDefinition;
			var key:String;
			if (m_act2FrameRate && this.definition)
			{
				for (key in this.m_act2FrameRate)
				{
					action = this.definition.dicAction[key];
					if (action)
					{
						action.framerate = m_act2FrameRate[key];
					}
				}
			}
		}
		
		override public function get shiQiEff():EffectEntity
		{
			return m_ShiQiEff;
		}
		
		override public function set shiQiEff(value:EffectEntity):void
		{
			m_ShiQiEff = value;
		}
		
		//public function set isPlayer(bFlag:Boolean):void
		//{
		//m_isPlayer = bFlag;
		//}
		
		public function get isPlayer():Boolean
		{
			//return m_isPlayer;
			return m_fightGrid.isPlayer;
		}
		
		override public function onMouseEnter():void
		{
			if (this.alpha == 0)
			{
				return;
			}
			if (m_fightDB.m_fightControl.getUIBattleTip() != null)
			{
				(m_fightDB.m_fightControl.getUIBattleTip() as UIBattleTip).showTipArmy(this.m_context.mouseScreenPos(), this);
			}
		}
		
		override public function onMouseLeave():void
		{
			if (m_fightDB.m_fightControl.getUIBattleTip() != null)
			{
				(m_fightDB.m_fightControl.getUIBattleTip() as UIBattleTip).hideTip();
			}
		}
		
		// 受伤和死亡的时候需要向后退一定的距离
		override public function set state(value:uint):void
		{
			if (m_state == value)
			{
				return;
			}
		
			var framerate:Number;
			var framecnt:uint;
			
			// 战斗 npc 受伤需要向后面退几步，然后再回到原来的地方
			if (EntityCValue.THurt == value)
			{
				//m_hurtVel.x = 20;
				m_hurtOrigPos ||= new Point();
				m_hurtOrigPos.x = this.x;
				m_hurtOrigPos.y = this.y;
				
				framerate = this.getActFrameRate(EntityCValue.TActHurt);
				framecnt = this.getActFrameCnt(EntityCValue.TActHurt);
				
				m_hurtVel.x = (m_hurtDist * framerate) / framecnt;
				
				m_subState = EntityCValue.HTBack;
			}
			else if (EntityCValue.TAttack == value) // 攻击如果配置也需要两个状态
			{
				m_hurtOrigPos ||= new Point();
				m_hurtOrigPos.x = this.x;
				m_hurtOrigPos.y = this.y;
				
				// 只有这个大于 0 才有两个阶段
				if (m_NpcbaseItem.npcBattleModel.m_attFrame != -1)
				{
					m_subState = EntityCValue.ATTBack;
					
					// 如果是技能攻击
					if (m_skillData.skillBaseItem)
					{
						framerate = this.getActFrameRate(EntityCValue.TActSkill);
					}
					else
					{
						framerate = this.getActFrameRate(EntityCValue.TActAttack);
						m_skillData.reset(); // 普通攻击也使用这个计数，因此清 0 ，如果是技能，在 SkillData.skillBaseItem 函数中清除 m_curFrame 这个值
					}
					
					m_hurtVel.x = (m_NpcbaseItem.npcBattleModel.m_attDist * framerate) / (m_NpcbaseItem.npcBattleModel.m_attFrame + 1);
				}
				else
				{
					m_subState = EntityCValue.ATTForth;
					
					if (!m_skillData.skillBaseItem)
					{
						m_skillData.reset(); // 普通攻击也使用这个计数，因此清 0 ，如果是技能，在 SkillData.skillBaseItem 函数中清除 m_curFrame 这个值
					}
				}
			}
			
			super.state = value;
		}
		
		override public function onStateChange(oldState:uint, newState:uint):void 
		{
			if (newState == EntityCValue.TDie)
			{
				alphaFade(false);
			}
			else if (oldState == EntityCValue.TDie)
			{
				alphaFade(true);
			}
			
			if (oldState == EntityCValue.THurt && EntityCValue.HTForth == m_subState)
			{				
				if ((this.customData.flash9Renderer as fFlash9ElementRenderer).currentFrame != 0 && newState != EntityCValue.TDie)
				{
					DebugBox.info("战斗：在受伤动作没有播放完的情况下，状态改变了");
				}
				setUpdateCurrentFrameMode(EntityCValue.UpdateCurrentFrameMode_Increase);
			}
		}
		
		override public function get level():uint
		{
			return 0
		}
		
		public function get colorValue():uint
		{
			if (isPlayer)
			{
				return 0xffffff;
			}
			else
			{
				return NpcBattleBaseMgr.colorValue(m_NpcbaseItem.m_uColor);
			}
		}
		
		// 只要一动就要添加拖影
		override public function moveTo(x:Number, y:Number, z:Number):void
		{
			// 先添加拖尾轨迹，然后在移动，当前位置为人物所在的位置，不用轨迹，只有可见的时候才处理
			if (this.isVisibleNow)
			{
				var tail:BeingTail;
				tail = new BeingTail();
				
				m_beingTail.push(tail);
				
				// 这个地方要把场景的 m_scenePixelXOff 偏移信息去掉，因为 BitmapRenderer已经偏移了
				tail.m_posX = this.customData.flash9Renderer.container.x - this.scene.m_scenePixelXOff;
				tail.m_posY = this.customData.flash9Renderer.container.y;
				tail.m_offX = this.bounds2d.x;
				tail.m_offY = this.bounds2d.y;
				
				tail.m_alpha = 1;
				
				tail.m_image = this.customData.flash9Renderer.curImage;
				if (!tail.m_image)
				{
					//tail.m_image = this.m_context.m_playerPlace;
					tail.m_image = this.m_context.m_replaceResSys.playerPlace;
				}
			}
			
			if (z < 0)
			{
				z = 0;
			}
			// Last position
			var lx:Number = this.x;
			var ly:Number = this.y;
			var lz:Number = this.z;
			
			// Movement
			var dx:Number = x - lx;
			var dy:Number = y - ly;
			var dz:Number = z - lz;
			
			// bug: 这个地方如果返回，没有 exit 
			if (dx == 0 && dy == 0 && dz == 0)		
			{
				return;
			}
			
			try
			{
				// Set new coordinates			   
				this.x = x;
				this.y = y;
				this.z = z;
				
				var radius:Number = this.radius;
				var height:Number = this.height;
				
				this.top = this.z + height;	
				
				// Check if element moved into a different cell
				var cell:fCell = this.scene.translateToCell(this.x, this.y, this.z);
				
				if (cell != this.cell || this.cell == null)
				{					
					var lastCell:fCell = this.cell;
					this.cell = cell;
					//this.updateOccupiedCells();
					var newCell:fNewCellEvent = new fNewCellEvent(fElement.NEWCELL, m_needDepthSort);
					newCell.m_needDepthSort = m_needDepthSort;
				
					dispatchEvent(newCell);
					
					// 继续判断是否是新的 district
					var dist:fFloor = this.scene.getFloorAtByPos(this.x, this.y);

					if(m_district == null || dist == null || m_district != dist)
					{
						// 到达新的区域没有什么好做的，仅仅是将自己的信息移动到新的区域
						if (m_district)
						{
							m_district.clearCharacter(this.id);
						}
						m_district = dist;
						if (m_district)
						{
							m_district.addCharacter(this.id);
						}
					}			
				}
				 
				// Dispatch move event
				if (this.x != lx || this.y != ly || this.z != lz)
					dispatchEvent(new fMoveEvent(fElement.MOVE, this.x - lx, this.y - ly, this.z - lz));
			}
			catch (e:Error)
			{
				// This means we tried to move outside scene limits
				this.x = lx;
				this.y = ly;
				this.z = lz;
				dispatchEvent(new fCollideEvent(fCharacter.COLLIDE, null));
			}
		}
		
		public function moveToPosCB(wherex:Number, wherey:Number, fun:Function):void
		{
			m_onMoveComplete = fun;
			this.moveToPosNoAIf(wherex, wherey);
		}
		
		override public function stopMoving(bSendPos:Boolean = true):void
		{
			super.stopMoving();
			if (m_onMoveComplete != null)
			{
				m_onMoveComplete();
				m_onMoveComplete = null;
			}
		}
		
		/*// 将攻击后的受伤结果传递给客户端
		   override protected function attack2Hurt():void
		   {
		   var item:AttackItem = m_fightList.m_attackVec[0];
		   var id:String;
		   var hurtBeing:NpcBattle;
		   var atttarget:AttackTarget;
		   for each (atttarget in item.targetList)
		   {
		   // 受伤信息
		   if (EntityCValue.TPlayer == atttarget.hurtType)
		   {
		   //hurtBeing = this.m_context.m_playerManager.getBeingByID(atttarget.hurtID);
		   }
		   else if (EntityCValue.TBattleNpc == atttarget.hurtType)
		   {
		   hurtBeing = this.m_context.m_npcBattleMgr.getBeingByID(atttarget.hurtID) as NpcBattle;
		   }
		
		   if (hurtBeing)
		   {
		   var dist:Number = mathUtils.distance(this.x, this.y, hurtBeing.x, hurtBeing.y);
		   var hurtitem:HurtItem = new HurtItem();
		   hurtitem.hurtAct = item.hurtAct;
		   hurtitem.dam = atttarget.dam;
		   hurtitem.delay = dist / this.m_effectSpeed;
		   hurtitem.attackID = this.id;
		   hurtitem.hurtEffectID = item.hurtEffectID;
		   hurtBeing.fightList.addHurtItem(hurtitem);
		
		   // 掉血信息
		   hurtBeing.hurtDigit.addHurtDigit(atttarget.dam, hurtitem.delay, EntityCValue.HDHurtDigit);
		   }
		   }
		 }*/
		protected function clearHurtState():void
		{
			//m_state = EntityCValue.TStand;
			//this.gotoAndPlay(EntityCValue.TSStand);
			// bug: 攻击距离计算需要使用跑到的终点位置 xlastPos ,而不是格子的 xPos ,由于这里计算错误,导致特效延迟很久播放,有时候下一次攻击都开始向前跑了,中途突然播放了受伤动作,然后把整个移动打断了,整个位置都错误了,这里判断一下,如果没有达到终点,继续移动吧,正常情况下应该不会有这个问题
			if (isArriveDest())
			{
				state = EntityCValue.TStand;
			}
			else
			{
				state = EntityCValue.TRun;
			}
		}
		
		// 取出受伤动作进行处理     
		public function playHurt(item:HurtItem):void
		{
			// KBEN: 播放受伤动作，添加特效
			if (fightGrid.curHp > 0)
			{
				hurt(item);
			}
			else
			{
				die(item);
			}
			//playHurtMsc(item);
			m_fightList.m_hurtVec.shift();
		}
		
		protected function clearAttackState():void
		{
			m_fightList.m_attackVec.shift();
			//m_fightList.m_attackVec.shift();
			// 将状态默认状态 
			//m_state = EntityCValue.TStand;
			//this.gotoAndPlay(EntityCValue.TSStand);
			state = EntityCValue.TStand;
		}
		
		// 判断特效是否播放完毕，特效可能在每个人为单位释放
		public function bEffOver(efflist:Vector.<String>):Boolean
		{
			var idx:int;
			var effid:String;
			for each (effid in efflist)
			{
				idx = m_effVec.length - 1;
				while (idx >= 0)
				{
					// 一旦有一个特效还存在，就说明特效没有释放完毕
					if (m_effVec[idx].m_insID == effid)
					{
						return false;
					}
					
					--idx;
				}
			}
			
			return true;
		}
		
		// 判断攻击特效是否播放完毕
		override public function bAttEffOver():Boolean
		{
			// 这个地方需要判断释放的特效是以什么为单位的，以格子还是每个人，暂时不处理
			if (m_attEffIDList.length)
			{
				if (m_topEmptySprite)
				{
					// 两个都结束才算是结束
					if (m_topEmptySprite.bEffOver(m_attEffIDList) && m_botEmptySprite.bEffOver(m_attEffIDList))
					{
						// 清除攻击特效列表
						m_attEffIDList.length = 0;
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			
			// 默认返回 true，就是结束了，以便整个流程统一处理
			m_attEffIDList.length = 0;
			return true;
		}
		
		public function set hurtEffOffX(value:Number):void
		{
			m_hurtEffOffX = value;
			
			// 更新特效  
			var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while (idx >= 0)
			{
				eff = m_effVec[idx];
				// 如果受伤的时候不移动，注意这个 eff 的 x 坐标此时一定要是 0，非 0 的没有考虑
				if (eff.definition && eff.definition.hurtMove)
				{
					eff.moveTo(-m_hurtEffOffX, eff.y, 0);
				}
				--idx;
			}
		}
		
		/*public function addHPStrip(hpStrip:HPStrip):void
		{
			var obj:Sprite = this.baseObj;
			if (obj == null)
			{
				return;
			}
			if (hpStrip.parent != obj)
			{
				//trace("addHPStrip");
				obj.addChild(hpStrip);
			}
		}*/
		
		// 添加延迟飞行特效
		public function addDeferFlyEff(defID:String, framerate:uint, flyvel:Number = 0):void
		{
			var defer:DeferEffect = new DeferEffect();
			var flip:uint = 0;
			var item:AttackItem = fightList.m_attackVec[0];
			var hurt:fEmptySprite;
			
			if (EntityCValue.TEmptySprite == item.targetList[0].hurtType)
			{
				hurt = this.m_context.m_npcBattleMgr.getEmptySpriteByID(item.targetList[0].hurtID);
			}
			
			if (this.side != EntityCValue.RKLeft)
			{
				flip = EntityCValue.FLPX;
			}
			
			defer.m_defID = defID;
			defer.m_framerate = framerate;
			defer.m_flyvel = flyvel;
			defer.m_delay = item.delayEff;
			
			defer.m_startX = this.x;
			defer.m_startY = this.y;
			defer.m_endX = hurt.x + hurt.xOff;
			defer.m_endY = hurt.y + hurt.yOff;
			
			defer.m_scene = this.scene;
			defer.m_bFlip = flip;
			defer.m_insID = this.m_insID;
			defer.m_effectSpeed = m_effectSpeed;
			
			if (m_callback != null && m_topEmptySprite)
			{
				defer.m_callback = m_callback;
			}
			
			this.m_fightDB.m_effectMgr.addDeferFlyEffect(defer);
		}
		
		// bug: 攻击距离计算需要使用跑到的终点位置 xlastPos ,而不是格子的 xPos ,由于这里计算错误,导致特效延迟很久播放,有时候下一次攻击都开始向前跑了,中途突然播放了受伤动作,然后把整个移动打断了,整个位置都错误了
		// 判断时候到达终点,如果受伤动作做完,如果还没有到达终点,继续移动
		protected function isArriveDest():Boolean
		{
			// 判断是否到达终点，放在这里可以少计算一次  
			if (this.m_dx == this.x && this.m_dy == this.y)
			{
				return true;
			}
			
			return false;
		}
		
		// 音效全部改成格子为单位,不是武将为单位
		// 播放攻击音效
		protected function playAttMsc():void
		{
			var mscid:uint;
			if (m_skillData.skillBaseItem) // 如果是技能攻击
			{
				if (m_fightGrid.isPlayer) // 如果是玩家
				{
					if (m_NpcbaseItem.m_uID == 1) // 男猛
					{
						mscid = 15;
					}
					else if (m_NpcbaseItem.m_uID == 2) // 女猛
					{
						mscid = 17;
					}
					else if (m_NpcbaseItem.m_uID == 3) // 男弓
					{
						mscid = 19;
					}
					else if (m_NpcbaseItem.m_uID == 4) // 女弓
					{
						mscid = 21;
					}
					else if (m_NpcbaseItem.m_uID == 5) // 男军
					{
						mscid = 23;
					}
					else if (m_NpcbaseItem.m_uID == 6) // 女军
					{
						mscid = 25;
					}
				}
				else // 如果是怪
				{
					switch (m_NpcbaseItem.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
							mscid = 39;
							break;
						case PlayerResMgr.JOB_JUNSHI: 
							mscid = 41;
							break;
						case PlayerResMgr.JOB_GONGJIANG: 
							mscid = 43;
							break;
					}
				}
			}
			else // 如果是普通攻击
			{
				if (m_fightGrid.isPlayer) // 如果是玩家
				{
					if (m_NpcbaseItem.m_uID == 1) // 男猛
					{
						mscid = 27;
					}
					else if (m_NpcbaseItem.m_uID == 2) // 女猛
					{
						mscid = 29;
					}
					else if (m_NpcbaseItem.m_uID == 3) // 男弓
					{
						mscid = 31;
					}
					else if (m_NpcbaseItem.m_uID == 4) // 女弓
					{
						mscid = 33;
					}
					else if (m_NpcbaseItem.m_uID == 5) // 男军
					{
						mscid = 35;
					}
					else if (m_NpcbaseItem.m_uID == 6) // 女军
					{
						mscid = 37;
					}
				}
				else // 如果是怪
				{
					switch (m_NpcbaseItem.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
							mscid = 45;
							break;
						case PlayerResMgr.JOB_JUNSHI: 
							mscid = 47;
							break;
						case PlayerResMgr.JOB_GONGJIANG: 
							mscid = 49;
							break;
					}
				}
			}
			
			gkcontext.m_commonProc.playMsc(mscid);
		}
		
		// 播放攻击音效
		protected function playHurtMsc(item:HurtItem):void
		{
			var mscid:uint;
			if (item.m_hurtType == EntityCValue.HTSkill) // 如果是技能受伤
			{
				if (m_fightGrid.isPlayer) // 如果是玩家
				{
					if (m_NpcbaseItem.m_uID == 1) // 男猛
					{
						mscid = 16;
					}
					else if (m_NpcbaseItem.m_uID == 2) // 女猛
					{
						mscid = 18;
					}
					else if (m_NpcbaseItem.m_uID == 3) // 男弓
					{
						mscid = 20;
					}
					else if (m_NpcbaseItem.m_uID == 4) // 女弓
					{
						mscid = 22;
					}
					else if (m_NpcbaseItem.m_uID == 5) // 男军
					{
						mscid = 24;
					}
					else if (m_NpcbaseItem.m_uID == 6) // 女军
					{
						mscid = 26;
					}
				}
				else // 如果是怪
				{
					switch (m_NpcbaseItem.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
							mscid = 40;
							break;
						case PlayerResMgr.JOB_JUNSHI: 
							mscid = 42;
							break;
						case PlayerResMgr.JOB_GONGJIANG: 
							mscid = 44;
							break;
					}
				}
			}
			else // 如果是普通受伤或者反击
			{
				if (m_fightGrid.isPlayer) // 如果是玩家
				{
					if (m_NpcbaseItem.m_uID == 1) // 男猛
					{
						mscid = 28;
					}
					else if (m_NpcbaseItem.m_uID == 2) // 女猛
					{
						mscid = 30;
					}
					else if (m_NpcbaseItem.m_uID == 3) // 男弓
					{
						mscid = 32;
					}
					else if (m_NpcbaseItem.m_uID == 4) // 女弓
					{
						mscid = 34;
					}
					else if (m_NpcbaseItem.m_uID == 5) // 男军
					{
						mscid = 36;
					}
					else if (m_NpcbaseItem.m_uID == 6) // 女军
					{
						mscid = 38;
					}
				}
				else // 如果是怪
				{
					switch (m_NpcbaseItem.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
							mscid = 46;
							break;
						case PlayerResMgr.JOB_JUNSHI: 
							mscid = 48;
							break;
						case PlayerResMgr.JOB_GONGJIANG: 
							mscid = 50;
							break;
					}
				}
			}
			
			gkcontext.m_commonProc.playMsc(mscid);
		}
		
		/*public function get bemove():Boolean
		   {
		   return m_bemove;
		 }*/
		
		public function get gridNO():uint
		{
			if (m_fightGrid)
			{
				return m_fightGrid.gridNO;
			}
			
			return 0;
		}
		
		//参数 bHide-true,由于兵力减少，本对象需要隐藏
		public function setHideOnHP(bHide:Boolean):void
		{
			if (m_bHideOnHP == bHide)
			{
				return;
			}
			m_bHideOnHP = bHide;
			
			if (m_bHideOnHP)
			{
				alphaFade(false);
			}
			else
			{
				alphaFade(true);
			}
		}
		public function get bHideOnHP():Boolean
		{
			return m_bHideOnHP;
		}
	}
}