package modulefight.scene
{
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.core.InputManager;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.net.msg.copyUserCmd.stReqLeaveCopyUserCmd;
	//import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.entity.BeingEntity;
	//import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	//import modulefight.scene.beings.NpcBattleMgr;
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	//import flash.geom.Point;
	
	import modulecommon.GkContext;
	//import modulecommon.game.ConstValue;
	import modulecommon.logicinterface.ISceneLogic;
	//import modulecommon.scene.beings.FallObjectEntity;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUILog;
	
	//import modulefight.FightEn;
	//import modulefight.scene.beings.NpcBattle;
	
	import org.ffilmation.engine.core.fRenderableElement;
	//import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.elements.fFloor;
	//import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9PlaneRenderer;
	//import org.ffilmation.utils.mathUtils;
	//import modulefight.scene.fight.GameFightController;

	/**
	 * ...
	 * @author 
	 */
	public class FightSceneLogic implements ISceneLogic
	{
		public var m_gkcontext:GkContext;
		protected var m_elementUnderMouse:fRenderableElement;
		public function FightSceneLogic() 
		{
			
		}
		
		public function init():void
		{
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		public function destroy():void
		{
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			m_elementUnderMouse = null;
			m_gkcontext = null;
		}
		
		public function removeKeyEventListener():void
		{
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		public function addKeyEventListener():void
		{
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			(this.m_gkcontext.m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		public function keyPressed(evt:KeyboardEvent):void
		{
			return;
			switch (evt.keyCode)
			{
				case InputKey.W.keyCode:
					{
						//return;
						//this.m_gkcontext.m_context.m_playerManager.hero.walk();
						//this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
						//this.m_gkcontext.m_playerManager.hero.startMoving();
					}
					break;
				case InputKey.D.keyCode: 
					{
						//return;
						//this.m_gkcontext.m_context.m_playerManager.hero.walk();
						//this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
						//this.m_gkcontext.m_playerManager.hero.startMoving();
					}
					break;
				case InputKey.A.keyCode: 
					{
						//return;
						//this.m_gkcontext.m_context.m_playerManager.hero.walk();
						//this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
						//this.m_gkcontext.m_playerManager.hero.startMoving();
					}
					break;
				case InputKey.S.keyCode: 
					{
						//return;
						//this.m_gkcontext.m_context.m_playerManager.hero.walk();
						//this.m_gkcontext.m_playerManager.hero.state = EntityCValue.TRun;
						//this.m_gkcontext.m_playerManager.hero.startMoving();
					}
					break;
				case InputKey.M.keyCode: 
					{
						//return;
						// KBEN: 发动攻击测试    
						//this.m_context.m_fightControl.attack();
						//this.m_gkcontext.m_fightControl.enterFightScene();
					}
					break;
				case InputKey.N.keyCode: 
					{
						//return;
						// 测试攻击   
						//this.m_context.m_fightControl.attack();
						//this.m_gkcontext.m_fightControl.buildActionSeq();
						var cmd:stReqLeaveCopyUserCmd = new stReqLeaveCopyUserCmd();
						m_gkcontext.sendMsg(cmd);
					}
					break;
				case InputKey.Q.keyCode: 
					{
						// 场景地图没有加载完成不能卸载，因为数据这个时候是乱的
						if (this.m_gkcontext.m_context.m_sceneView.isLoading)
						{
							//this.m_gkcontext.m_fightControl.endFight();
							// 退出场景 
							//this.m_gkcontext.m_loadModuleF(ConstValue.ModuleGame);
							//this.m_gkcontext.m_quitFight();
							
							// 正常流程
							// bug 走 bip 限制
							//(this.m_gkcontext.m_fightControl as GameFightController).m_fightDB.m_UIReplay.onClkReplay(null);
							//(this.m_gkcontext.m_fightControl as GameFightController).m_fightDB.m_UIReplay.replay();
						}
					}
					break;
				case InputKey.T.keyCode: 
					{
						//this.m_gkcontext.m_fightControl.savePic();
						//return;
						// test: 保存雾图片    
						//var scene:fScene = this.m_gkcontext.m_context.m_sceneView.scene;
						//var fog:fFlash9FogRenderer = scene.fogPlane.customData.flash9Renderer as fFlash9FogRenderer;
						//fog.savePic();
						
						// test: 保存主角当前动作的序列帧    
						//var play:BeingEntity = this.m_gkcontext.m_context.m_playerManager.hero;
						//var render:fFlash9ObjectSeqRenderer = play.customData.flash9Renderer as fFlash9ObjectSeqRenderer;
						//render.savePic();
						
						// test: 保存地形  
						var floor:fFloor = this.m_gkcontext.m_context.m_sceneView.scene((EntityCValue.SCFIGHT)).floors[0] as fFloor;
						var render:fFlash9PlaneRenderer = floor.customData.flash9Renderer as fFlash9PlaneRenderer;
						//render.savePic(0);
					}
					break;
				case InputKey.Y.keyCode: 
					{
						// test: 保存雾图片    
						//var scene:fScene = this.m_gkcontext.m_context.m_sceneView.scene;
						//var fog:fFlash9FogRenderer = scene.fogPlane.customData.flash9Renderer as fFlash9FogRenderer;
						//fog.savePic();
						
						// test: 保存主角当前动作的序列帧    
						//var play:BeingEntity = this.m_gkcontext.m_context.m_playerManager.hero;
						//var render:fFlash9ObjectSeqRenderer = play.customData.flash9Renderer as fFlash9ObjectSeqRenderer;
						//render.savePic();
						
						// test: 保存地形  
						//var floor1:fFloor = this.m_gkcontext.m_context.m_sceneView.scene((EntityCValue.SCFIGHT)).floors[0] as fFloor;
						//var render1:fFlash9PlaneRenderer = floor1.customData.flash9Renderer as fFlash9PlaneRenderer;
						//render1.savePic(1);
						
						// 保存战斗 npc 模型
						//var npc:NpcBattle;
						//for each(npc in (this.m_gkcontext.m_context.m_npcBattleMgr as NpcBattleMgr).m_beingList)
						//{
						//	if(npc.fightGrid.side == 0)
						//	{
						//		if(npc.fightGrid.gridNO == 5)
						//		{
						//			var render1:fFlash9ObjectSeqRenderer = npc.customData.flash9Renderer as fFlash9ObjectSeqRenderer;
						//			render1.savePic();
						//			break;
						//		}
						//	}
						//}
					}
					break;
				case InputKey.L.keyCode:
					{
						//return;
						//testLog(true);
					}
					break;
				case InputKey.ESCAPE.keyCode:
					{
						
					}
					break;
				default:
					break;
			}
		}
		
		public function keyReleased(evt:KeyboardEvent):void
		{
			
		}
		
		public function onClick(evt:MouseEvent):void
		{		
			
			// 清空输入焦点
			/*this.m_gkcontext.m_context.mainStage.focus = null;
			
			if (ret)
			{
				var some:Boolean = false;
				var destiny:fPoint3d;
				var i:int = 0;
				// KBEN: 从最上面的开始访问     
				//for (i = 0; !some && i < ret.length; ++i)
				for (i = ret.length - 1; !some && i >= 0; --i)
				{
					// 如果点击的是玩家或者 npc 
					if (ret[i].element as BeingEntity)	// 玩家  
					{
						some = true;
						var player:BeingEntity = ret[i].element as BeingEntity;
						if (player.type == EntityCValue.TPlayer)
						{
							if (ret[i].element != this)	// 排除自己    
							{
								// KBEN: 释放攻击特效   
								destiny = new fPoint3d(player.x, player.y, player.z);
								// bug: 坐标不对会宕机 
								//testEffect(destiny);
							}
						}
						else if (player.type == EntityCValue.TBattleNpc)	// Npc    
						{
							// KBEN: 移动过去 
							//destiny = new Point(player.x, player.y);
							//testMove(new Point(player.x, player.y));
						}
					}
					else if (ret[i].element as FallObjectEntity)	// 掉落物  
					{
						some = true;
						var fallobj:FallObjectEntity = ret[i].element as FallObjectEntity;
					}
					else if (ret[i].element as fFloor)	// 地面 
					{
						some = true;
						var floor:fFloor = ret[i].element as fFloor;
						some = true;
						destiny = ret[i].coordinate;
						//testEffect(destiny);
						// bug: 坐标不对会宕机 
						//testMove(new Point(destiny.x, destiny.y));
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
			*/
		}
		
		public function onMouseMove(evt:MouseEvent):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_gkcontext.m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			var globalx:Number = this.m_gkcontext.m_context.mainStage.mouseX;
			var globaly:Number = this.m_gkcontext.m_context.mainStage.mouseY;

			var ret:Array = this.m_gkcontext.m_context.m_sceneView.scene((EntityCValue.SCFIGHT)).translateStageCoordsToElements(globalx, globaly);
							
			var curEle:fRenderableElement;
			if (ret && ret.length > 0)
			{				
				curEle = ret[0].element;				
			}
			      
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
			
			if (this.m_gkcontext.m_UIs.gmInfoShow)
			{
				this.m_gkcontext.m_UIs.gmInfoShow.updateData();
			}
		}
		
		public function onMouseOut(evt:MouseEvent):void
		{			
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
		//public function testMove(destiny:Point):void 
		//{
		//	if (this.m_gkcontext.m_playerManager && this.m_gkcontext.m_playerManager.hero)
		//	{
		//		this.m_gkcontext.m_playerManager.hero.moveToPos(destiny)
		//	}
		//}
		
		//public function testEffect(destiny:fPoint3d):void
		//{
		//	if (this.m_gkcontext.m_playerManager.hero.state ==	EntityCValue.TRoll ||
		//		this.m_gkcontext.m_playerManager.hero.state ==	EntityCValue.TJump)
		//		return;
			
		//	var angle:Number = mathUtils.getAngle(this.m_gkcontext.m_playerManager.hero.x, this.m_gkcontext.m_playerManager.hero.y, destiny.x, destiny.y);
		//	this.m_gkcontext.m_playerManager.hero.orientation = this.m_gkcontext.m_playerManager.hero.m_angle = angle;

			//var eff:EffectEntity = this.m_context.m_sceneView.scene.createEffect(fUtil.elementID(this.m_context.m_sceneView.scene.engine.m_context, EntityCValue.TEfffect), "effseqpic", this.m_context.m_playerManager.hero.x, this.m_context.m_playerManager.hero.y, this.m_context.m_playerManager.hero.z, destiny.x, destiny.y, destiny.z, this.m_context.m_playerManager.hero.m_effectSpeed, this.m_context.m_playerManager.hero.m_effectSpeed, 0);
		//	var eff:EffectEntity = this.m_gkcontext.m_context.m_sceneView.scene((EntityCValue.SCFIGHT)).createEffect(fUtil.elementID(this.m_gkcontext.m_context, EntityCValue.TEfffect), EntityCValue.EFFExplosion, this.m_gkcontext.m_playerManager.hero.x, this.m_gkcontext.m_playerManager.hero.y, this.m_gkcontext.m_playerManager.hero.z, destiny.x, destiny.y, destiny.z, this.m_gkcontext.m_playerManager.hero.m_effectSpeed);

		//	this.m_gkcontext.m_context.m_sceneView.scene((EntityCValue.SCFIGHT)).engine.m_context.m_terrainManager.terrainEntity(EntityCValue.SCFIGHT).addFlyEffect(eff);
			
		//	eff.type = EntityCValue.EFFFly;
		//	eff.start();
		//}
		
		// 开启日志窗口    
		protected function testLog(bopen:Boolean):void
		{
			var log:IUILog = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBattleLog) as IUILog;
			if (bopen)
			{
				if (log)
				{
					m_gkcontext.m_UIMgr.showForm(UIFormID.UIBattleLog);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UIBattleLog);
				}
			}
			else
			{
				if (log)
				{
					log.exit();
				}
			}
		}
		
		// 释放元素,主要是用来释放当前鼠标下面的对象
		public function disposeElement(element:fRenderableElement):void
		{
			if(m_elementUnderMouse == element)
			{
				m_elementUnderMouse = null;
			}
		}
	}
}