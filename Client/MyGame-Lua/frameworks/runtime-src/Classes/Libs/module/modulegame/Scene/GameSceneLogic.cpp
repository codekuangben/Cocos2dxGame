package game.scene
{
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.core.InputManager;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.BeingEntity;
	import com.util.DebugBox;
	import common.Context;
	import modulecommon.scene.dazuo.DaZuoMgr;
	//import game.ui.uibenefithall.UIBenefitHall;
	import modulecommon.scene.beings.PlayerOther;
	import modulecommon.scene.beings.UserState;
	//import modulecommon.ui.Form;
	//import modulecommon.uiinterface.IUIBenefitHall;
	//import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import modulecommon.CommonEn;
	import modulecommon.commonfuntion.LocalDataMgr;
	//import modulecommon.game.ConstValue;
	import modulecommon.GkContext;
	import modulecommon.logicinterface.ISceneLogic;
	//import modulecommon.net.msg.sceneUserCmd.stAttackUserCmd;
	import modulecommon.scene.beings.FallObjectEntity;
	import modulecommon.scene.beings.NpcVisitBase;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUILog;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.elements.fFloor;
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9FogRenderer;
	import org.ffilmation.engine.datatypes.fCell;
	import com.pblabs.engine.entity.TerrainEntity;
	
	//import modulecommon.scene.beings.MountsSys;
	import modulecommon.net.msg.mountscmd.stSetRideMountStateCmd;
	
	/**
	 * ...
	 * @author
	 * @brief 场景逻辑处理
	 */
	public class GameSceneLogic implements ISceneLogic
	{
		public var m_context:Context;
		public var m_gkcontext:GkContext;
		protected var m_elementUnderMouse:fRenderableElement;
		
		public function GameSceneLogic(gk:GkContext):void
		{
			m_gkcontext = gk;
			m_context = m_gkcontext.m_context;
		}
		public function init():void
		{
			(this.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			(this.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			(this.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			(this.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		public function destroy():void
		{
			(this.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			(this.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			(this.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			(this.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			m_gkcontext = null;
		}
		
		public function removeKeyEventListener():void
		{
			(this.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		public function addKeyEventListener():void
		{
			(this.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		// Receives keypresses		
		public function keyPressed(evt:KeyboardEvent):void
		{
			if (m_context.m_LoginMgr.m_receivesynOnlineFinDataUserCmd == 0)
			{
				return;
			}
			
			if (m_gkcontext.m_localMgr.isShieldKeyEvent)
			{
				return;
			}
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			// 竞技场不允许鼠标
			if (m_gkcontext.m_mapInfo.m_bInArean == true)
			{
				return;
			}
			
			switch (evt.keyCode)
			{
				case InputKey.SPACE.keyCode: 
				{
					// 骑乘不能跳跃
					if (!this.m_gkcontext.m_playerManager.hero.horseSys.curHorseID) // 骑乘
					{
						(this.m_gkcontext.m_playerManager.hero as PlayerMain).subState = EntityCValue.TJump;
					}
				}
					break;
				case InputKey.SHIFT.keyCode: 
				{
					//this.m_context.m_playerManager.hero.run();
					this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
					this.m_gkcontext.m_playerManager.hero.startMoving();
				}
					break;
				//case InputKey.W.keyCode: 
				//case InputKey.D.keyCode: 
				//case InputKey.A.keyCode: 
				//case InputKey.S.keyCode: 
				//{
				//	//this.m_gkcontext.m_context.m_playerManager.hero.walk();
				//	if (this.m_gkcontext.m_playerManager.hero.stopMoveFlag)
				//	{
				//		break;
				//	}
				//	// 将自动寻路的路径清理掉
				//	if (m_gkcontext.m_UIs.npcTalk && m_gkcontext.m_UIs.npcTalk.inTalk)
				//	{
				//		break;
				//	}
				//	if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIUprightPrompt) == true)
				//	{
				//		break;
				//	}
				//	this.m_gkcontext.m_playerManager.hero.clearPath();
				//	// 设置状态
				//	this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
				//	// 开始移动
				//	this.m_gkcontext.m_playerManager.hero.startMoving();
				//}
				//	break;
				case InputKey.M.keyCode: 
				{
					// KBEN: 发动攻击测试    
					//this.m_context.m_fightControl.attack();
					//this.m_gkcontext.m_fightControl.enterFightScene();
					// 切换战斗模块    
					//this.m_gkcontext.m_loadModuleF(ConstValue.ModuleFight);
				}
					break;
				case InputKey.N.keyCode: 
				{
					// 测试攻击   
					//this.m_context.m_fightControl.attack();
					//this.m_gkcontext.m_fightControl.buildActionSeq();
				}
					break;
				case InputKey.Q.keyCode: 
				{
					//this.m_gkcontext.m_fightControl.endFight();
				}
					break;
				case InputKey.Z.keyCode: 
				{
					
				}
					break;
				case InputKey.L.keyCode: 
				{
					//testLog(true);
				}
					break;
				case InputKey.X.keyCode: 
				{
					
				}
					break;
				case InputKey.ESCAPE.keyCode: 
				{
					
				}
					break;
				case InputKey.O.keyCode: 
				{
					//this.m_gkcontext.m_context.m_stats.visible = !this.m_gkcontext.m_context.m_stats.visible;
				}
					break;
				case InputKey.T.keyCode: // 切换骑马
				{
					//if (!this.m_gkcontext.m_playerManager.hero.horseSys)
					//{
					//	this.m_gkcontext.m_playerManager.hero.horseSys = new MountsSys(this.m_gkcontext.m_playerManager.hero, this.m_gkcontext);
					//}
					//this.m_gkcontext.m_playerManager.hero.horseSys.toggleRideHorse(0);
					// 取消打坐
					if (this.m_gkcontext.m_playerManager.hero.isUserSet(UserState.USERSTATE_DAZUO))
					{
						m_gkcontext.m_dazuoMgr.setStateOfDaZuo(DaZuoMgr.STATE_NODAZUO);
					}
					
					var cmd:stSetRideMountStateCmd = new stSetRideMountStateCmd();
					if (this.m_gkcontext.m_playerManager.hero.horseSys.curHorseID) // 骑乘
					{
						// 下马
						cmd.isset = 0;
					}
					else // 没有骑乘
					{
						// 上马
						cmd.isset = 1;
					}
					m_gkcontext.sendMsg(cmd);
				}
					break;
				default: 
					break;
			}
		}
		
		// Receives key releases
		public function keyReleased(evt:KeyboardEvent):void
		{
			if (m_context.m_LoginMgr.m_receivesynOnlineFinDataUserCmd == 0)
			{
				return;
			}
			if (m_gkcontext.m_localMgr.isShieldKeyEvent)
			{
				return;
			}
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			// 竞技场不允许鼠标
			if (m_gkcontext.m_mapInfo.m_bInArean == true)
			{
				return;
			}
						
			/*switch (evt.keyCode)
			{
				case InputKey.SHIFT.keyCode: 
					//this.m_gkcontext.m_context.m_playerManager.hero.stopRunning();
					this.m_gkcontext.m_playerManager.hero.stopMoving();
					break;
				case InputKey.W.keyCode: 
					//this.m_gkcontext.m_context.m_playerManager.hero.stopWalking();
					this.m_gkcontext.m_playerManager.hero.stopMoving();
					break;
				case InputKey.D.keyCode: 
					//this.m_gkcontext.m_context.m_playerManager.hero.stopWalking();
					this.m_gkcontext.m_playerManager.hero.stopMoving();
					break;
				case InputKey.A.keyCode: 
					//this.m_gkcontext.m_context.m_playerManager.hero.stopWalking();
					this.m_gkcontext.m_playerManager.hero.stopMoving();
					break;
				case InputKey.S.keyCode: 
					//this.m_gkcontext.m_context.m_playerManager.hero.stopWalking();
					this.m_gkcontext.m_playerManager.hero.stopMoving();
					break;
				case InputKey.T.keyCode: 
				{
					// test: 保存雾图片    
					//var scene:fScene = this.m_gkcontext.m_context.m_sceneView.scene();
					//var fog:fFlash9FogRenderer = scene.fogPlane.customData.flash9Renderer as fFlash9FogRenderer;
					//fog.savePic();
					
						// test: 保存主角当前动作的序列帧    
						//var play:BeingEntity = this.m_gkcontext.m_context.m_playerManager.hero;
						//var render:fFlash9ObjectSeqRenderer = play.customData.flash9Renderer as fFlash9ObjectSeqRenderer;
						//render.savePic();
					
						// test: 保存地形  
						//var floor:fFloor = this.m_gkcontext.m_context.m_sceneView.scene().floors[0] as fFloor;
						//var render:fFlash9PlaneRenderer = floor.customData.flash9Renderer as fFlash9PlaneRenderer;
						//render.savePic();
				}
					break;
				default: 
					break;
			}*/
		}
		
		// KBEN: 点击场景处理        
		public function onClick(evt:MouseEvent):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			if (m_context.m_gameCursor.cmdState == GameCursor.CMDSTATE_DragItem)
			{
				return;
			}
			// 竞技场不允许鼠标
			if (m_gkcontext.m_mapInfo.m_bInArean == true)
			{
				return;
			}
			
			var globalx:Number = this.m_context.mainStage.mouseX;
			var globaly:Number = this.m_context.mainStage.mouseY;
			
			var ret:Array = this.m_context.m_sceneView.scene().translateStageCoordsToElements(globalx, globaly);
			
			// 清空输入焦点
			this.m_context.mainStage.focus = null;
			var terEnt:TerrainEntity;
			var scene:fScene;
			if (ret)
			{
				var some:Boolean = false;
				var role:Player;
				
				var destiny:fPoint3d;
				var i:int = 0;
				var curScene:fScene = m_context.m_sceneView.curScene();
				// KBEN: 从最上面的开始访问     
				for (i = 0; !some && i < ret.length; ++i)
					//for (i = ret.length - 1; !some && i >= 0; --i)
				{
					var element:fRenderableElement = ret[i].element;
					if (element["scene"] != undefined && element["scene"] != curScene)
					{
						return;
					}
					// 如果点击的是玩家或者 npc 
					if (element is BeingEntity) // 玩家  
					{
						some = true;
						var player:BeingEntity = element as BeingEntity;
						if (player.type == EntityCValue.TPlayer)
						{
							var other:PlayerOther;
							other = player as PlayerOther;
							//role = m_gkcontext.m_playerManager.hero as Player;
							if (other)
							{
								if (m_gkcontext.m_sanguozhanchangMgr.inZhanchang)
								{
									if (other.m_zhenying != m_gkcontext.m_sanguozhanchangMgr.zhenying)
									{
										other.onClick();
									}
								}
								else if (m_gkcontext.m_worldBossMgr.m_bInWBoss)
								{
									return; //世界BOSS地图，点击玩家不显示查看界面
								}
								else
								{
									var formOther:IForm = m_gkcontext.m_UIMgr.getForm(UIFormID.UIOtherPlayer) as IForm;
									if (formOther == null)
									{
										m_gkcontext.m_contentBuffer.addContent("uiOtherPlayer_data", other);
										m_gkcontext.m_UIMgr.loadForm(UIFormID.UIOtherPlayer);
									}
									else
									{
										formOther.updateData(other);
										formOther.show();
									}
										// KBEN: 释放攻击特效   
										//destiny = new fPoint3d(player.x, player.y, player.z);
										// test: 发送攻击消息 
									/*var cmd1:stAttackUserCmd = new stAttackUserCmd();
									   cmd1.byAttTempID = role.tempid;
									   cmd1.byDefTempID = other.tempid;
									   cmd1.attackType = CommonEn.ATTACKTYPE_U2U;
									 m_context.sendMsg(cmd1);*/
								}
								
							}
						}
						else if (player.type == EntityCValue.TVistNpc) // Npc    
						{
							// KBEN: 移动过去 
							(player as NpcVisitBase).onClick();
						}
						else if (player.type == EntityCValue.TNpcPlayerFake) // Npc    
						{
							// KBEN: 移动过去 
							(player as NpcVisitBase).onClick();
						}
					}
					else if (element is FallObjectEntity) // 掉落物  
					{
						some = true;
						(element as FallObjectEntity).onClick();
					}
					else if (element is fFloor) // 地面 
					{
						some = true;
						var floor:fFloor = element as fFloor;
						some = true;
						destiny = ret[i].coordinate;
						// 检查是否点击在阻挡点上，在阻挡点上就不移动了，主要是计算太耗时了
						var cell:fCell;
						cell = m_gkcontext.playerMain.scene.translateToCell(destiny.x, destiny.y, 0);
						if (cell)
						{
							if (!cell.stoppoint.isStop)
							{
								terEnt = m_context.m_terrainManager.terrainEntityByScene(m_context.m_sceneView.scene(EntityCValue.SCGAME));
								scene = this.m_context.m_sceneView.scene()
								var spt:Point = scene.convertG2S(globalx, globaly);
								terEnt.addGroundEffectByID("e4_e506", spt.x, spt.y, false)
								playerMove(new Point(destiny.x, destiny.y));
							}
						}
					}
					else
					{
						Logger.info(null, null, "不能点选此物品")
					}
				}
			}
			else
			{
				Logger.info(null, null, "clic is null");
			}
		}
		
		public function onMouseMove(evt:MouseEvent):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			if (this.m_gkcontext.m_UIs.gmInfoShow)
			{
				this.m_gkcontext.m_UIs.gmInfoShow.updateData();
			}
			
			// 竞技场不允许鼠标
			if (m_gkcontext.m_mapInfo.m_bInArean == true)
			{
				return;
			}
			
			var globalx:Number = this.m_context.mainStage.mouseX;
			var globaly:Number = this.m_context.mainStage.mouseY;
			
			var curScene:fScene = m_context.m_sceneView.curScene();
			if (curScene == null)
			{
				DebugBox.sendToDataBase("GameSceneLogic::onMouseMove curScene==null");
				return;
			}
			var ret:Array = curScene.translateStageCoordsToElements(globalx, globaly);
			
			var curEle:fRenderableElement;
			if (ret && ret.length > 0)
			{
				//curEle = ret[ret.length - 1].element;
				curEle = ret[0].element;
			}
			
			/*if (curEle["scene"] != undefined && curEle["scene"] != curScene)
			{
				return;
			}*/
			
			if (m_elementUnderMouse && m_elementUnderMouse.isDisposed)
			{
				m_elementUnderMouse = null;
			}
			if (curEle != m_elementUnderMouse)
			{
				if (m_elementUnderMouse != null)
				{
					m_elementUnderMouse.onMouseLeave();
				}
				
				m_elementUnderMouse = curEle;
				if (m_elementUnderMouse != null)
				{
					m_elementUnderMouse.onMouseEnter();
				}
			}
		}
		
		public function onMouseOut(evt:MouseEvent):void
		{
			// 竞技场不允许鼠标
			if (m_gkcontext.m_mapInfo.m_bInArean == true)
			{
				return;
			}
			
			if (m_elementUnderMouse && m_elementUnderMouse.isDisposed)
			{
				m_elementUnderMouse = null;
			}
			
			if (m_elementUnderMouse != null)
			{
				m_elementUnderMouse.onMouseLeave();
				m_elementUnderMouse = null;
			}
		}
		
		// KBEN: 点击人物移动 
		public function playerMove(destiny:Point):void
		{
			var playermain:PlayerMain = this.m_gkcontext.m_playerManager.hero;
			if (playermain)
			{
				// 开始移动  				
				if (!playermain.cancleAutoWalk())
				{
					return
				}
				playermain.moveToPos(destiny);
				
			}
		}
		
		// 开启日志窗口    
		protected function testLog(bopen:Boolean):void
		{
			//var form:IUIBenefitHall = new UIBenefitHall();
			//m_gkcontext.m_UIMgr.addForm(form as Form);
			//form.show();
			
			var log:IUILog = m_gkcontext.m_UIMgr.getForm(UIFormID.UILog) as IUILog;
			if (bopen)
			{
				if (log)
				{
					m_gkcontext.m_UIMgr.showForm(UIFormID.UILog);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UILog);
				}
			}
			else
			{
				if (log)
				{
					log.exit();
				}
			}
		
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UICopysAwards);
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIEquipSys);
			//m_gkcontext.m_cangbaokuMgr.processRetCreateCopyUserCmd(null, 1);
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UICopyCountDown);
			//if(!this.m_context.m_inputManager.isKeyDown(InputKey.SHIFT.keyCode))
			//{
			//this.m_context.m_soundMgr.stopAll();
			//}
			//else
			//{
			//this.m_context.m_soundMgr.play("tst.mp3");
			//}
		}
		
		// 释放元素,主要是用来释放当前鼠标下面的对象
		public function disposeElement(element:fRenderableElement):void
		{
			if (m_elementUnderMouse == element)
			{
				m_elementUnderMouse = null;
			}
		}
	}
}