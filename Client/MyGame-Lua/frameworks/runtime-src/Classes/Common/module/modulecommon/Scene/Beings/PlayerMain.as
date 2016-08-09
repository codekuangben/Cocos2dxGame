package modulecommon.scene.beings
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import adobe.utils.ProductManager;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.scene.MapInfo;
	import modulecommon.ui.Form;
	import org.ffilmation.engine.helpers.fUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	//import flash.ui.Mouse;
	
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.fun.BubbleHeadSprite;
	import modulecommon.headtop.PlayerMainHeadTopBlock;
	import modulecommon.logicinterface.IVisitSceneObject;
	import net.ContentBuffer;
	import modulecommon.net.msg.sceneUserCmd.stUserMoveMoveUserCmd;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.wu.WuMainProperty;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;

	import modulecommon.uiinterface.IUISanguoZhangchang;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.helpers.fEngineCValue;
	import org.ffilmation.utils.mathUtils;
	
	public class PlayerMain extends Player
	{
		protected var m_prop:BeingProp;
		
		private var m_ServerX:Number = 0; //只用在主角对象中
		private var m_ServerY:Number = 0; //只用在主角对象中
		private var m_pathDestSceneObject:IVisitSceneObject;
		private var m_pathDestNpcID:uint;
		private var m_wuProperty:WuMainProperty;
		
		//public static const m_jumpInitVel:Number = 100;	// 跳跃的初始速度
		protected var m_destDir:uint; // 目标方向，玩家静止时候面向
		protected var m_stopCallBack:Function;
		
		private var m_bubbleHeadSprite:BubbleHeadSprite;
		private var _stopMoveFlag:Boolean;
		private var m_autoWalk:Boolean;
		private var m_cancleAutoWalk:Boolean;
		
		// 军团城市争夺战 region
		protected var m_cooltime:Number;
		//protected var m_coolType:Number;		// 冷却类型
		
		public function PlayerMain(defObj:XML, scene:fScene)
		{
			super(defObj, scene);
			m_type = EntityCValue.TPlayerMain;
			this.gkcontext.m_playerManager.hero = this;
			
			m_destDir = 360; // 有效范围是 [0, 315]	360 是无效范围
			_stopMoveFlag = false;
			m_headTopBlockBase = new PlayerMainHeadTopBlock(gkcontext, this);
			
			// 主角直接初始化坐骑
			m_horseSys = new MountsSys(this, this.gkcontext);
		}
		
		public function setWuProperty(wu:WuMainProperty):void
		{
			m_wuProperty = wu;
			m_wuProperty.m_playerMain = this;
		}
		
		public function get wuProperty():WuMainProperty
		{
			return m_wuProperty;
		}
		
		override public function get level():uint
		{
			return m_wuProperty.m_uLevel;
		}
		
		override public function get job():uint
		{
			return m_wuProperty.m_uJob;
		}
		
		public function modelName():String
		{
			return this.m_context.m_playerResMgr.modelName(job, this.gender);
		}
		
		public function get halfingPathName():String
		{
			return m_wuProperty.halfingPathName;
		}
		
		//获取主角圆头像文件的路径
		public function get roundHeadPathName():String
		{
			return this.m_context.m_playerResMgr.roundHeadPathName(job, this.gender);
		}
		
		public function set prop(value:BeingProp):void
		{
			// 获取主角的属性    
			m_prop = value;
			
			// 初始化场景雾起始点       
			m_prop.m_charScene.m_fogLast.x = this.x;
			m_prop.m_charScene.m_fogLast.y = this.y;
			m_prop.m_charScene.m_fogLast.z = this.z;
		
			//this.scene.fogPlane.regParam(m_prop.m_charScene.m_fogLast.x, m_prop.m_charScene.m_fogLast.y, 200, 6);
			//this.scene.fogPlane.endPt();
		}
		
		public function get cooltime():Number
		{
			return m_cooltime;
		}
		
		public function set cooltime(value:Number):void
		{
			m_cooltime = value;
			
			if (m_cooltime < 0)
			{
				m_cooltime = 0;
			}
			
			m_headTopBlockBase.invalidate();
		}
		
		//public function get coolType():uint
		//{
		//	return m_coolType;
		//}
		
		//public function set coolType(value:uint):void
		//{
		//	m_coolType = value;
		//}
		
		//将主角从场景移除前，调用此函数
		public function beforeRemoveFromScene():void
		{
			disposeEffect();
			clearWuEff();
		}
		
		//将主角挂到新的场景后，调用此函数
		public function afterAddToScene():void
		{
			var tmptype:uint = m_wuEffType;
			m_wuEffType = EntityCValue.MWETNone;
			wuEffType = tmptype;
		}
		
		override public function dispose():void
		{
			throw new Error("dispose主角对象");
			
			if (m_bubbleHeadSprite != null)
			{
				m_bubbleHeadSprite.dispose();
			}
			
			super.dispose();
		}
		
		// 因为要更新军团城市争夺战的冷却时间，因此在添加一层
		override public function onTick(deltaTime:Number):void
		{
			if (gkcontext.m_corpsCitySys.inScene)
			{
				updataCorpsSys(deltaTime);
			}
			super.onTick(deltaTime);
		}
		
		override public function updateMove(deltaTime:Number):void
		{
			var cell:fCell;
			var tmpdx:Number = 0;
			var tmpdy:Number = 0;
			var tmpdz:Number = 0;
			
			var disz:Number = 0;
			
			if (isMoving())
			{
				// 判断是否到达终点，放在这里可以少计算一次
				// 如果主角方向键没有按下的时候才判断 
				if (!isKeyDown())
				{
					if (m_pathDestSceneObject != null)
					{
						if (mathUtils.distance(this.x, this.y, m_pathDestSceneObject.posX, m_pathDestSceneObject.posY) <= NpcVisitBase.DISTANCE_VISIT)
						{
							this.stopMoving();
							if (m_pathDestSceneObject is NpcVisit)
							{
								m_pathDestSceneObject = this.gkcontext.m_npcManager.getBeingByTmpID((m_pathDestSceneObject as NpcVisit).tempid) as IVisitSceneObject;
							}
							else if (m_pathDestSceneObject is NpcPlayerFake)
							{
								m_pathDestSceneObject = this.gkcontext.m_playerFakeMgr.getBeingByTempID((m_pathDestSceneObject as NpcPlayerFake).tempid) as IVisitSceneObject;
							}
							else if (m_pathDestSceneObject is FallObjectEntity)
							{
								m_pathDestSceneObject = this.gkcontext.m_fobjManager.getFOjectByTmpID((m_pathDestSceneObject as FallObjectEntity).tempid) as IVisitSceneObject;
							}
							
							if (m_pathDestSceneObject)
							{
								if (!m_pathDestSceneObject.isDisposed)
								{
									m_pathDestSceneObject.onPlayerMainArrive();
								}
								m_pathDestSceneObject = null;
							}
							return;
						}
					}
					else if (m_pathDestNpcID != 0)
					{
						var npc:NpcVisitBase;
						npc = this.gkcontext.m_npcManager.findNpcInRange(m_pathDestNpcID, this.x, this.y, NpcVisitBase.DISTANCE_VISIT) as NpcVisit;
						if (npc)
						{
							this.stopMoving();
							npc.execFunction();
							m_pathDestNpcID = 0;
							return;
						}
					}
					
					if (this.m_dx == this.x && this.m_dy == this.y && this.m_dz == this.z)
					{
						if (this.m_currentPath && this.m_currentPath.length > 0)
						{
							//this.walkTo(this.m_currentPath.shift());
							//var pt:Point = new Point();
							var dest3D:fPoint3d;
							dest3D = this.m_currentPath.shift();
							//pt.x = dest3D.x;
							//pt.y = dest3D.y;
							//this.moveToPosNoAIPt(pt);
							//this.moveToPosNoAIf(dest3D.x, dest3D.y, dest3D.z);
							// bug : moveToPosNoAIf 最后一个参数是运动状态，不是坐标了
							this.moveToPosNoAIf(dest3D.x, dest3D.y, EntityCValue.TRun);
						}
						else
						{
							this.stopMoving();
							return;
						}
					}
				}
				
				var angleRad:Number = this.m_angle * Math.PI / 180;
				this.m_vx = m_vel * Math.cos(angleRad);
				this.m_vy = m_vel * Math.sin(angleRad);
				//this.m_vz = this.m_vz + m_g * deltaTime;
				
				var disx:Number = this.m_vx * deltaTime;
				var disy:Number = this.m_vy * deltaTime;
				//var disz:Number = this.m_vz * deltaTime;
				
				// 如果键盘方向键按下，阻挡点判断是否能走  
				if (isKeyDown())
				{
					tmpdx = this.x + disx;
					tmpdy = this.y + disy;
					tmpdz = this.z + disz;
					// 检测是否出边界 
					
					if (!(this.scene.isCoordinateLegal(tmpdx, tmpdy) && this.scene.AI.hasStopBewteenPoint(this.x, this.y, tmpdx, tmpdy)))
					{
						return;
					}
					m_dx = tmpdx;
					m_dy = tmpdy;
					m_dz = tmpdz;
				}
				
				if (Math.abs(this.m_dx - this.x) < Math.abs(disx))
				{
					disx = this.m_dx - this.x;
				}
				if (Math.abs(this.m_dy - this.y) < Math.abs(disy))
				{
					disy = this.m_dy - this.y;
				}
				
				// 如果处于跳跃状态，高度方向移动
				if (m_subState == EntityCValue.TJump)
				{
					if (this.customData.flash9Renderer.aniOver())
					{
						subState = EntityCValue.STNone;
					}
				}
				
				// 如果键盘没有按下，也需要检测是否走出地图边界   
				if (!isKeyDown())
				{
					tmpdx = this.x + disx;
					tmpdy = this.y + disy;
					tmpdz = this.z + disz;
					// 检测是否出边界
					if (!(this.scene.isCoordinateLegal(tmpdx, tmpdy) && this.scene.AI.hasStopBewteenPoint(this.x, this.y, tmpdx, tmpdy)))
					{
						return;
					}
				}
				
				if (gkcontext.m_localMgr.isSet(LocalDataMgr.LOCAL_GM_ShowMainPlayerMoveLog))
				{
					var strLog:String = fUtil.keyValueToString("deltaTime", deltaTime, "m_vel", m_vel, "disx", disx, "disy", disy);
					gkcontext.addLog(strLog); 
				}
				this.moveTo(this.x + disx, this.y + disy, this.z + disz);
				if (gkcontext.m_UIs.collectProgress && gkcontext.m_UIs.collectProgress.isVisible())
				{
					gkcontext.m_UIs.collectProgress.exit();
				}
				
				//Logger.info(null, null, "主角移动到: " + "(" + this.x + "," + this.y + ")");
				
				//var oldgridX:int = m_prop.m_charScene.m_ServerX/
				if (Math.abs(this.x - m_ServerX) + Math.abs(this.y - m_ServerY) > 100)
				{
					sendPosToServer();
					// 不要频繁输出日至
					//Logger.info(null, null, "告诉服务器移动到: " + "(" + this.x + "," + this.y + ")" + "(" + this.x / this.scene.gridSize + "," + this.y / this.scene.gridSize + ")");
					
					//if (this.m_context.m_config.m_bDebug)
					//{
					//var gkcnt:GkContext = this.m_context.m_gkcontext as GkContext;
					//var chat:IUIChat = gkcnt.m_UIMgr.getForm(UIFormID.UIChat) as IUIChat;
					//var cell:fCell = this.scene.translateToCell(this.x, this.y, this.z);
					//if (chat)
					//{
					//chat.appendMsg("screen Coordinate: x = " + this.x + " y = " + this.y);
					//if (cell)
					//{
					//chat.appendMsg("cell Coordinate: x = " + cell.i + " y = " + cell.j);
					//}
					//}
					//}
					
					//if (this.m_context.m_config.m_bDebug)
					//{
					//	var gkcnt:GkContext = this.m_context.m_gkcontext as GkContext;
					//	var log:IUILog = gkcnt.m_UIMgr.getForm(UIFormID.UILog) as IUILog;
					//	
					//	cell = this.scene.translateToCell(this.x, this.y, this.z);
					//	if (log && (log as Form).isVisible())
					//	{
					//		log.clearText();
					//		log.addText("\nscreen Coordinate: \nx = " + this.x + " \ny = " + this.y);
					//		if (log)
					//		{
					//			log.addText("\ncell Coordinate: \nx = " + cell.i + " \ny = " + cell.j);
					//		}
					//	}
					//}
					
					
					
					
				}
				if (this.gkcontext.m_UIs.gmInfoShow != null)
				{
					this.gkcontext.m_UIs.gmInfoShow.updateData();
				}
					//}
					//else
					//{
					//if (this.m_currentPath && this.m_currentPath.length > 0)
					//this.walkTo(this.m_currentPath.shift());
					//else
					//this.stopWalking();
					//}
			}
			else
			{
				// 如果处于跳跃状态，高度方向移动
				if (m_subState == EntityCValue.TJump)
				{
					/*
					   disz = this.m_vz * deltaTime + 0.5 * m_g * deltaTime * deltaTime;
					   this.m_vz = this.m_vz + m_g * deltaTime;
					
					   // 如果是第一次循环，this.z 还没有改变，就不判断了
					   if(this.m_vz != m_jumpInitVel)
					   {
					   // 目标点落到地面以下就是停止了
					   if (this.z + disz < 0)
					   {
					   disz = - this.z;
					   // 去掉跳跃状态
					   m_subState = EntityCValue.STNone;
					   }
					   }
					   this.m_dz = this.z + disz;
					   this.moveTo(this.x, this.y, this.z + disz)
					 */
					// 跳跃已经做到美术资源里面了，只需要播放动画就行了
					// 如果跳跃动作结束
					if (this.customData.flash9Renderer.aniOver())
					{
						subState = EntityCValue.STNone;
					}
				}
			}
		}
		
		private function sendPosToServer():void
		{
			if (m_ServerX != x || m_ServerY != y)
			{
				var send:stUserMoveMoveUserCmd = new stUserMoveMoveUserCmd();
				send.dwUserTempID = this.tempid;
				send.x = this.x;
				send.y = this.y;
				this.gkcontext.sendMsg(send);
				m_ServerX = this.x;
				m_ServerY = this.y;
				//gkcontext.addLog("发送位置");
			}
		}
		
		//服务器直接将主角拉到指定位置，参数是主角的新位置（服务器长度单位）
		public function toPosDirectly_ServerPos(x:Number, y:Number):void
		{
			var pt:Point = MapInfo.s_serverPointToClientPoint2(x, y);
			moveTo(pt.x, pt.y,0);
			m_ServerX = pt.x;
			m_ServerY = pt.y;
		}
		public function updateFog():void
		{
			//this.scene.fogPlane.drawParam(m_prop.m_charScene.m_fogLast.x, m_prop.m_charScene.m_fogLast.y, 200, 6);
			this.scene.fogPlane.drawParam(m_prop.m_charScene.m_fogLast.x, m_prop.m_charScene.m_fogLast.y, 6);
			//this.scene.fogPlane.regParam(0, 0, 200, 6);
			this.scene.fogPlane.drawFog();
		
			//if((this.scene.renderEngine as fFlash9RenderEngine).getSceneLayer(fScene.SLFog))
			//{
			//if(!((this.scene.renderEngine as fFlash9RenderEngine).getSceneLayer(fScene.SLFog).visible))
			//{
			//throw new Event("hide fog");
			//}
			//}
		
			//var contain:fElementContainer = this.scene.fogPlane.customData.flash9Renderer.container;
			//if(!contain.visible || !contain.parent || !contain.parent.visible)
			//{
			//throw new Event("hide fog");
			//}
		}
		
		// 只要一动必然走这里  
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			// 主角的雾就放在这里了，就不跟随 follow 主角了，这个函数一定要放在  super.moveTo(x, y, z); 否则会先更新雾屏幕区域，然后才将人物区域绘制到雾区域   
			if (this.scene.m_sceneConfig.fogOpened)
			{
				// 计算雾是否需要绘制  
				//var distX:Number = mathUtils.distanceSquare(this.x, this.y, m_prop.m_charScene.m_fogLast.x, m_prop.m_charScene.m_fogLast.y);
				var distX:Number = Math.abs(x - m_prop.m_charScene.m_fogLast.x);
				var distY:Number = Math.abs(y - m_prop.m_charScene.m_fogLast.y);
				
				// 需要重新计算   
				if (distX >= this.scene.fogPlane.m_border || distY >= this.scene.fogPlane.m_border)
				{
					m_prop.m_charScene.m_fogLast.x = x;
					m_prop.m_charScene.m_fogLast.y = y;
					m_prop.m_charScene.m_fogLast.z = z;
					
					updateFog();
				}
			}
			
			super.moveTo(x, y, z);
		}
		
		public function moveToPos_ServerPos(destX:int, destY:int, ste:uint = EntityCValue.TRun):void
		{
			var pt:Point = m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(destX, destY));
			moveToPos(pt, ste);
		}
		
		public override function moveToPos(dest:Point, ste:uint = EntityCValue.TRun):void
		{			
			if (this.scene == null)
			{
				return;
			}
			if (!stopMoveFlag)
			{
				m_pathDestSceneObject = null;
				super.moveToPos(dest, ste);
			}
		}
		
		// 这个主要是检测主角是否按下方向键    
		public override function updateAngle():void
		{
			if (this.scene.m_sceneConfig.mapType == fEngineCValue.Engine2d)
			{
				if (this.m_context.m_inputManager.isKeyDown(InputKey.W.keyCode))
				{
					if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
						this.m_angle = 225;
					else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
						this.m_angle = 315;
					else
						this.m_angle = 270;
					
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.S.keyCode))
				{
					if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
						this.m_angle = 135;
					else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
						this.m_angle = 45;
					else
						this.m_angle = 90;
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
				{
					this.m_angle = 0;
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
				{
					this.m_angle = 180;
				}
			}
			else
			{
				if (this.m_context.m_inputManager.isKeyDown(InputKey.W.keyCode))
				{
					if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
						this.m_angle = 270;
					else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
						this.m_angle = 0;
					else
						this.m_angle = 315;
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.S.keyCode))
				{
					if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
						this.m_angle = 180;
					else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
						this.m_angle = 90;
					else
						this.m_angle = 135;
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
				{
					this.m_angle = 45;
				}
				else if (this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode))
				{
					this.m_angle = 225;
				}
			}
			this.orientation = this.m_angle;
		}
		
		//public override function stopWalking():void
		public override function stopMoving(bSendPos:Boolean = true):void
		{			
			if (state != EntityCValue.TRun)
			{
				return;
			}
			clearPath();
			this.m_dx = this.x;
			this.m_dy = this.y;
			this.m_dz == this.z;
			
			// 是否设置方向
			if (m_destDir != 360)
			{
				this.m_angle = m_destDir;
				m_destDir = 360;
			}
			
			// 主角如果由于方向键 up ，需要判断方向，例如按下 D ，再按 W ，然后释放 W ，这个时候需要更新方向    
			this.updateAngle();
			
			// 主角没有按方向键，才可以停止移动
			/*if (!_stopMoveFlag) // 如果没有设置停止移动标志，就需要判断键盘
			{
				if (!(this.m_context.m_inputManager.isKeyDown(InputKey.W.keyCode) || this.m_context.m_inputManager.isKeyDown(InputKey.S.keyCode) || this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode) || this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode)))
				{
					//this.m_state = EntityCValue.TStand;
					//this.gotoAndPlay("Stand");
					state = EntityCValue.TStand;
				}
			}
			else // 如果设置了停止移动标志，就必须停止
			{
				state = EntityCValue.TStand;
			}*/
			state = EntityCValue.TStand;
			this.setAutoWalk(false);
			if (m_stopCallBack != null)
			{
				m_stopCallBack();
				m_stopCallBack = null;
			}
			
			if (bSendPos)
			{
				sendPosToServer();
			}
		}
		
		public function computeExp(color:uint):uint
		{
			return PlayerResMgr.s_computeExp(this.level, color);
		}
		
		public function toSceneObject(visitObj:IVisitSceneObject):void
		{
			this.moveToPos(new Point(visitObj.posX, visitObj.posY));
			m_pathDestSceneObject = visitObj;
		}
		
		public function moveToNpcVisitByNpcID_ServerPos(destX:int, destY:int, npcID:uint):void
		{
			var pt:Point = m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(destX, destY));
			moveToNpcVisitByNpcID(pt.x, pt.y, npcID);
		}
		
		public function moveToNpcVisitByNpcID(destX:int, destY:int, npcID:uint):void
		{						
			m_pathDestNpcID = 0;
			
			var npc:NpcVisit;
			npc = this.gkcontext.m_npcManager.findNpcInRange(m_pathDestNpcID, this.x, this.y, NpcVisitBase.DISTANCE_VISIT) as NpcVisit;
			
			if (npc)
			{
				npc.execFunction();
			}
			else
			{
				this.moveToPos(new Point(destX, destY));
				m_pathDestNpcID = npcID;
			}
		}
		
		public function moveToWithCallBack(dest:Point, callBack:Function):void
		{
			this.moveToPos(dest);
			m_stopCallBack = callBack;
		}
		
		public function clearMoveToCallBack(callBack:Function):void
		{
			if (m_stopCallBack == callBack)
			{
				m_stopCallBack = null;
			}
		}
		
		//public function set subState(value:uint):void
		//{
		//	if (value == m_subState)
		//	{
		//		return;
		//	}
		
		//	m_subState = value;
		//	// 如果取消跳跃子状态，需要更新一下动作，否则总是跳跃动作
		//	if (value == EntityCValue.STNone)
		//	{
		//		this.gotoAndPlay(state2StateStr(m_state));
		//	}
		//	else
		//	{
		//		this.gotoAndPlay(state2StateStr(m_subState));
		//	}
		//}
		
		override public function getAction():uint
		{
			// 如果子状态是跳跃
			if (m_subState == EntityCValue.TJump)
			{
				return EntityCValue.TActJump;
			}
			else
			{
				return super.getAction();
			}
		}
		
		public function get destDir():uint
		{
			return m_destDir;
		}
		
		public function set destDir(value:uint):void
		{
			m_destDir = value
		}
		
		//清除玩家自动寻路的状态，玩家主动的操作会导致调用此函数
		public function clearAutoState():void
		{
			gkcontext.m_contentBuffer.delContent(ContentBuffer.KEY_GOTO);
			gkcontext.m_contentBuffer.delContent("uiWorldMap_runToCity");
			gkcontext.m_contentBuffer.delContent("uiFuben_runTofuben");
		}
		
		public function setHeadBubble(str:String, headName:String):void
		{
			if (m_bubbleHeadSprite == null)
			{
				m_bubbleHeadSprite = new BubbleHeadSprite(this.gkcontext);
			}
			
			m_bubbleHeadSprite.setText(str, headName);
			
			var h:Number = this.getTagHeight();
			if (h == 0)
			{
				h = 100;
			}
			
			m_bubbleHeadSprite.setPos(0, -h - 20);
			var base:Sprite = this.baseObj;
			if (base && m_bubbleHeadSprite.parent == null)
			{
				base.addChild(m_bubbleHeadSprite);
			}
		}
		
		public function hideHeadBubble():void
		{
			var base:Sprite = this.baseObj;
			if (base != null && m_bubbleHeadSprite != null)
			{
				if (base.contains(m_bubbleHeadSprite))
				{
					base.removeChild(m_bubbleHeadSprite);
				}
			}
		}
		
		public function get stopMoveFlag():Boolean
		{
			return _stopMoveFlag;
		}
		
		public function set stopMoveFlag(value:Boolean):void
		{
			_stopMoveFlag = value;
		}
		
		public function setAutoWalk(bAuto:Boolean):void
		{
			gkcontext.addInfoInUIChat("设置自动寻路状态:+" + bAuto);
			if (m_autoWalk == bAuto)
			{
				gkcontext.addInfoInUIChat("状态相同");
				if (m_autoWalk)
				{
					m_cancleAutoWalk = true;
				}
				return;
			}
			
			if (bAuto == true)
			{
				if (state != EntityCValue.TRun)
				{
					gkcontext.addLog("PlayerMain:setAutoWalk 设置自动寻路特效失败");
					return;
				}
			}
			if (!m_autoWalk)
			{
				m_cancleAutoWalk = true;
			}
			m_autoWalk = bAuto;
						
			if (this.gkcontext.m_UIs.hero)
			{
				this.gkcontext.m_UIs.hero.toggleAutoWay(m_autoWalk);
			}
		}
		
		override protected function onUserStateSet(id:uint):void
		{
			super.onUserStateSet(id);
			if (id == UserState.USERSTATE_DIE)
			{
				var form:Form = gkcontext.m_UIMgr.createFormInGame(UIFormID.UISanguoZhanchangRelive);
				form.updateData();				
				var ui:IForm = gkcontext.m_UIMgr.getForm(UIFormID.UIGgzjWuList) as IForm;
				if (ui)
				{
					ui.updateData(2);
				}
			}
			else if (id >= UserState.USERSTATE_ORE_GREEN && id <= UserState.USERSTATE_ORE_PURPLE)
			{
				var iUISanguoZhangchang:IUISanguoZhangchang
				iUISanguoZhangchang = gkcontext.m_UIMgr.getForm(UIFormID.UISanguoZhangchang) as IUISanguoZhangchang;
				if (iUISanguoZhangchang)
				{
					iUISanguoZhangchang.updateAutoBtn();
				}
			}
		}
		
		override protected function onUserStateClear(id:uint):void
		{
			super.onUserStateClear(id);
			if (id == UserState.USERSTATE_DIE)
			{
				var ui:IForm = gkcontext.m_UIMgr.getForm(UIFormID.UIGgzjWuList) as IForm;
				if (ui)
				{
					ui.updateData(3);
				}
				
				gkcontext.m_UIMgr.exitForm(UIFormID.UISanguoZhanchangRelive);
			}
			if (id >= UserState.USERSTATE_ORE_GREEN && id <= UserState.USERSTATE_ORE_PURPLE)
			{
				var iUISanguoZhangchang:IUISanguoZhangchang = gkcontext.m_UIMgr.getForm(UIFormID.UISanguoZhangchang) as IUISanguoZhangchang;
				if (iUISanguoZhangchang)
				{
					iUISanguoZhangchang.updateAutoBtn();
				}
			}
		}
		
		public function getClkNpc():NpcVisit
		{
			if (m_pathDestSceneObject && m_pathDestSceneObject is NpcVisit)
			{
				return m_pathDestSceneObject as NpcVisit;
			}
			
			return null;
		}
		
		protected function updataCorpsSys(deltaTime:Number):void
		{
			if (cooltime > 0)
			{
				cooltime -= deltaTime;
			}
		}
		override public function onStateChange(oldState:uint, newState:uint):void 
		{
			//super.onStateChange(oldState, newState);
			gkcontext.m_dazuoMgr.onPlayerMainStateChage(oldState, newState);			
		}
		public function cancleAutoWalk():Boolean
		{
			if (m_autoWalk && m_cancleAutoWalk)
			{
				m_cancleAutoWalk = false;
				gkcontext.m_systemPrompt.prompt("再次点击停止寻路");
				return false;
			}
			else if (m_autoWalk && !m_cancleAutoWalk)
			{
				gkcontext.m_systemPrompt.prompt("停止自动寻路");
				clearAutoState();
			}
			setAutoWalk(false);
			return true;
		}
	}
}