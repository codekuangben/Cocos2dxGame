package com.pblabs.engine.entity 
{
	//import being.Npc;
	//import being.Player;
	//import com.bit101.components.Panel;
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.core.InputKey;
	import com.util.DebugBox;
	import com.util.UtilFilter;	
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import common.Context;
	import common.scene.fight.FightList;
	import common.scene.fight.HurtItem;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.IntPoint;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.elements.fCharacter;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.interfaces.fMovingElement;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9SceneObjectSeqRenderer;
	import org.ffilmation.utils.mathUtils;
	import org.ffilmation.engine.elements.fObject;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @brief npc 玩家 
	 */
	public class BeingEntity extends fCharacter implements IBeingEntity, ITickedObject, fMovingElement
	{
		//protected var m_state:uint;				// 玩家的状态，已经在 fObject 中定义了		
		protected var m_type:int;				// 实体类型  
		//protected var m_serverState:uint = state:uint = EntityCValue.TRun;		// 服务器状态，外部如果要改变状态改变这个状态，主要用作是走还是跑状态          
		
		// Effect speed
		public var m_effectSpeed:Number = 140;
		public var m_angle:Number = 0;
		public var m_vx:Number = 0;
		public var m_vy:Number = 0;
		public var m_vz:Number = 0;
		protected var m_vel:Number = 220;	// 标量速度, 默认值: 220
		
		public var m_currentPath:Array = null;
		public var m_dx:Number = 0;
		public var m_dy:Number = 0;
		public var m_dz:Number = 0;
		protected var m_g:Number = -10;	// 重力加速度   
		
		protected var m_effVec:Vector.<EffectEntity>;	// 玩家身上添加特效  
		protected var m_fightList:FightList;
				
		protected var m_tempid:uint;	// 服务器 tmpid 
		protected var m_name:String;	// 名字 
		protected var m_level:uint;		//等级
		protected var m_nameDisc:String;	//用于在人物头上显示文字
		
		//protected var m_hp:uint = 100;		// 血量    		
		 
		protected var m_alpha:Number;				// 死亡淡出 alpha 值
		protected var m_greyFilter:ColorMatrixFilter; // 灰度滤镜
		
		protected var m_subState:uint; // 子状态，主要是跳
		protected var m_horseSys:IMountsSys;		// 马匹数据
		
		public function BeingEntity(defObj:XML, scene:fScene) 
		{
			m_resType = EntityCValue.PHBEING;
			super(defObj, scene);
			m_state = EntityCValue.TStand;
			m_effVec = new Vector.<EffectEntity>();
			
			m_alpha = 1.0;
			this.m_angle = 0;
			this.m_vx = 0;
			this.m_vy = 0;
			this.m_vz = 0;
			// fObject 读取配置    
			//this.orientation = this.m_angle;
			
			// KBEN: 更新 floor 位置 
			//updateFloorInfo(EntityCValue.TPlayer);
			
			m_subState = EntityCValue.STNone;
		}
		
		override public function onTick(deltaTime:Number):void
		{
			// 更新移动
			this.updateMove(deltaTime);

			/*if (m_state == EntityCValue.TAttack)
			{
				if (this.customData.flash9Renderer.aniOver())
				{
					// 播放攻击特效   
					addFlyEffect(EntityCValue.EFFExplosion);
					// 将攻击后的受伤变现分发出去    
					//attack2Hurt();
					// 清理最近一次攻击的状态    					
				}
			}
			else if (m_state == EntityCValue.THurt)
			{
				// 受伤后自动回复站立状态        
				if (this.customData.flash9Renderer.aniOver())
				{
					//clearHurtState();
				}
			}		*/	

			// 更新特效  
			var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while(idx >= 0)
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
					eff.onTick(deltaTime);
				}
				--idx;
			}

			// 更新动作    
			super.onTick(deltaTime);
		}
		
		/**
		 * @param	defID: 这个就是配置文件 <effect id="eff1" definition="effseqpic" solid="false" x="200" y="200" z="0" start="true"/> 中的 definition="effseqpic" 这个 definition 的值，这个是重复特效     
		 */
		public function addLinkEffect(defID:String, framerate:uint = 0, repeat:Boolean = false, efftype:uint = 0):EffectEntity
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
			//if (this.side == eff.definition.effDir)
			//{
			//	eff.bFlip = EntityCValue.FLPX;
			//}
			// 设置偏移
			var offpt:Point = this.context.linkOff(fUtil.modelInsNum(this.m_insID), fUtil.modelInsNum(eff.m_insID));
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
			
			//eff.repeatDic[0] = repeat;
			// bug: 特效是否重复播放定义在定义文件中    
			//eff.definition.dicAction[0].repeat = repeat;
			//eff.linkedBeing = this;	// 一个链接特效只能关联到一个特效上面  
			// 设置偏移
			//var offpt:Point = this.scene.engine.m_context.linkOff(fUtil.modelInsNum(this.m_insID), fUtil.modelInsNum(eff.m_insID));
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
				
				this.scene.renderEngine.showElement(eff);
				eff.start();
			}
			
			/*var r:fFlash9ElementRenderer = this.customData.flash9Renderer;
			// KBEN: 如果当前人物屏幕可视，那么让特效也可视吧    
			if (r.screenVisible)
			{
				this.scene.renderEngine.showElement(eff);
				eff.start();
			}*/
			return eff;
		}
		
		
		// KBEN: 链接特效删除时候的回调函数 
		public function removeLinkEffect(effect:EffectEntity, idx:int = -1):void
		{
			if (idx == -1)
			{
				idx = m_effVec.indexOf(effect);
			}
			if (idx >= 0)
			{
				this.scene.removeEffectNIScene(effect);
				m_effVec.splice(idx, 1);
			}
		}
		
		// 主要是玩家过场景的时候如果场景内容不清除，可用这个函数清理一些事件信息 
		public function enable():void
		{

		}
		
		// 主要是玩家过场景的时候如果场景内容不清除，可用这个函数清理一些事件信息 
		public function disable():void
		{
			//this.stopRunning();
			//this.stopWalking();
			this.startMoving();
			//this.gotoAndPlay("Stand");
			this.m_vx = this.m_vy = this.m_vz = 0;
		}
		
		// KBEN: 
		public function updateMove(deltaTime:Number):void
		{
			if (isMoving())
			{
				// 判断是否到达终点，放在这里可以少计算一次  
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
						this.moveToPosNoAIf(dest3D.x, dest3D.y);
					}
					else
					{
						this.stopMoving();
						return;
					}
				}
				
				var angleRad:Number = this.m_angle * Math.PI / 180;
				this.m_vx = m_vel * Math.cos(angleRad);
				this.m_vy = m_vel * Math.sin(angleRad);
				//this.m_vz = this.m_vz + m_g * deltaTime;
				
				var disx:Number = this.m_vx * deltaTime;
				var disy:Number = this.m_vy * deltaTime;
				//var disz:Number = this.m_vz * deltaTime;
				//var disz:Number = this.m_vz * deltaTime + 0.5 * m_g * deltaTime * deltaTime;
				//this.m_vz = this.m_vz + m_g * deltaTime;
				var disz:Number = 0;
				
				if (Math.abs(this.m_dx - this.x) < Math.abs(disx))
				{
					disx = this.m_dx - this.x;
				}
				if (Math.abs(this.m_dy - this.y) < Math.abs(disy))
				{
					disy = this.m_dy - this.y;
				}
				if (Math.abs(this.m_dz - this.z) < Math.abs(disz))
				{
					disz = this.m_dz - this.z;
				}
				
				//if (disx != 0 || disy != 0 || disz != 0)
				//{
					this.moveTo(this.x + disx, this.y + disy, this.z + disz);
				//}
				//else
				//{
					//if (this.m_currentPath && this.m_currentPath.length > 0)
					//{
						//this.walkTo(this.m_currentPath.shift());
					//}
					//else
					//{
						//this.stopWalking();
					//}
				//}
			}
		}
		
		/*
		// 开始跳跃    
		public function jump():void
		{
			
		}
		
		// 开始跑动   
		public function run():void
		{
			//this.m_state = EntityCValue.TRun;
			
			// If dodging, ignore
			//if (this.m_state == EntityCValue.TRoll)
			//	return;
			
			//if (this.m_state == EntityCValue.TRun)
			//{
			//	this.gotoAndPlay("runLoop");
			//}
			state = EntityCValue.TRun;
		}
		
		// 停止跑动  
		public function stopRunning():void
		{
			//this.m_state = EntityCValue.TStand;
			
			// If dodging, ignore
			//if (this.m_state == EntityCValue.TRoll)
			//	return;
			
			//if (this.m_state == EntityCValue.TWalk)
			//{
			//	this.gotoAndPlay("walkLoop");
			//}
			
			state = EntityCValue.TStand;
		}
		
		// 开始总动   
		public function walk():void
		{
			//this.updateAngle();
			
			// If already walking, don't reset animation
			if (this.m_state == EntityCValue.TWalk)
				return;
			
			//this.m_state = EntityCValue.TWalk;
			
			// If dodging, ignore
			//if (this.m_state == EntityCValue.TRoll || this.m_state == EntityCValue.TJump)
			//	return;
			
			//if (this.m_state == EntityCValue.TRun)
			//	this.gotoAndPlay("Run");
			//else
			//	this.gotoAndPlay("Walk");
			
			state = EntityCValue.TWalk;
		}
		
		public function stopWalking():void
		{
			// 停止移动不用更新角度了吧 
			// this.updateAngle();
			// 只有主角才有键盘控制    
			//if (this.m_context.m_inputManager.isKeyDown(InputKey.W.keyCode) || 
				//this.m_context.m_inputManager.isKeyDown(InputKey.S.keyCode) || 
				//this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode) || 
				//this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
				//return;
			
			if (this.m_state != EntityCValue.TRoll && this.m_state != EntityCValue.TJump)
			{
				//this.m_state = EntityCValue.TStand;
				//this.gotoAndPlay("Stand");
				state = EntityCValue.TStand;
			}
		}
		*/
		
		// 停止移动，对外统一接口      
		public function stopMoving(bSendPos:Boolean = true):void
		{
			state = EntityCValue.TStand;
			clearPath();
			this.m_dx = this.x;
			this.m_dy = this.y;
			this.m_dz == this.z;
		}
		
		// 开始一定，对外统一接口，默认是跑，外部直接调用这个接口，只有在玩家按下方向键的时候才会调用，其它时候不要外部调用，因为角度是未知的         
		public function startMoving():void
		{
			// 在主角按下方向键的时候这个调用更新方向   
			this.updateAngle();
			
			//if (this.m_state == m_serverState)
			//{
			//	return;
			//}
			
			//this.state = m_serverState;
		}
		
		// 这个主要是检测主角是否按下方向键    
		public function updateAngle():void
		{			
			this.orientation = this.m_angle;
		}
		
		// Makes our character walk towards a given point    
		// KBEN: 这个是从一个点走到另外一个点，中间没有阻挡点，等价 moveToPosNoAIPt，内部使用 walkTo ，外部使用 moveToPosNoAIPt     
		//public function walkTo(where:fPoint3d):void 
		//{
			//this.m_dx = where.x
			//this.m_dy = where.y
			//this.m_dz = where.z
			//this.m_angle = mathUtils.getAngle(this.x,this.y,this.m_dx,this.m_dy)
			//this.orientation = this.m_angle
			//this.walk()
		//}
		
		protected function disposeEffect():void
		{
			var eff:EffectEntity;
			for each(eff in m_effVec)
			{
				this.scene.removeEffectNIScene(eff);
				// bug: 是不是得从后向前删除啊，需要测试    				
			}
			m_effVec.length =0;
		}
		// KBEN: 这个being 释放的时候释放自己的资源 
		public function disposeBeingEntity():void
		{
			disposeEffect();
		}
		
		// KBEN: 释放资源     
		override public function dispose():void
		{
			//this.m_context.m_playerManager.disposeBeing(this as Player);
			this.disposeBeingEntity();
			super.dispose();
		}
		
		// KBEN: 渲染显示会回调这个函数     
		override public function showRender():void
		{
			// 显示的时候促发一次调用这个函数，保证加载图片资源，可能刚加载完 xml 资源，就隐藏 BeingEntity ，结果图片资源就没有加载，这个时候再次显示BeingEntity 的时候，可能不能加载图片资源
			this.gotoAndPlay(state2StateStr(m_state));
			
			var eff:EffectEntity;
			for each(eff in m_effVec)
			{
				eff.show();
				eff.isVisibleNow = true;				
				eff.start();
				this.scene.renderEngine.showElement(eff);
			}
		}
		
		// KBEN: 渲染隐藏会回调这个函数     
		override public function hideRender():void
		{
			var eff:EffectEntity;
			for each(eff in m_effVec)
			{
				eff.stop(false);
				this.scene.renderEngine.hideElement(eff);
			}
		}
		
		// KBEN: 重载这个函数    
		override public function show():void
		{
			super.show();
			
			// bug: 不要再调用这个函数，特效显示在 showRender 这个函数中处理  
			//var eff:EffectEntity;
			//for each(eff in m_effVec)
			//{
			//	eff.show();
			//	eff.start();
			//}
		}
		
		override public function hide():void
		{
			super.hide();
			
			// bug: 不要再调用这个函数，特效隐藏在 hideRender 这个函数中处理  
			//var eff:EffectEntity;
			//for each(eff in m_effVec)
			//{
			//	eff.hide();
			//	eff.stop();
			//}
		}
		
		override public function get type():int 
		{
			return m_type;
		}
		
		// fObject 中有个 state 函数了 
		//public function get state2f():uint 
		//{
			//return m_state;
		//}
		
		public function get fightList():FightList 
		{
			return m_fightList;
		}
		
		public function set vel(value:Number):void 
		{
			m_vel = value;
		}
		
		public function set tempid(value:uint):void 
		{
			m_tempid = value;
		}
		
		public function get tempid():uint 
		{
			return m_tempid;
		}
		  
		public function set name(value:String):void 
		{
			m_name = value;
			updateNameDesc();
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		// 移动到 dest 这个点，需要通过寻路查找路径然后一个一个点走的      
		public function moveToPos(dest:Point, ste:uint = EntityCValue.TRun):void
		{
			//this.state = ste;
			
			var pt:Point;
			var dest3D:fPoint3d = new fPoint3d(dest.x, dest.y, 0);
			var cur3D:fPoint3d = new fPoint3d(this.x, this.y, this.z);
			try
			{
				this.m_currentPath = this.scene.AI.findPath(cur3D, dest3D);
			}
			catch (e:Error)
			{
				var str:String = fUtil.keyValueToString("name", this.name, "class", getQualifiedClassName(this), "map", this.scene.m_serverSceneID, "curpos", cur3D.toString(), "dest3D", dest3D.toString());
				str += e.getStackTrace();
				DebugBox.sendToDataBase(str);
				m_currentPath = null;
			}
			
			if (this.m_currentPath && this.m_currentPath.length > 0) 
			{
				//this.walkTo(this.m_currentPath.shift());
				//pt = new Point();
				dest3D = this.m_currentPath.shift();
				//pt.x = dest3D.x;
				//pt.y = dest3D.y;
				//this.moveToPosNoAIPt(pt, ste);
				this.moveToPosNoAIf(dest3D.x, dest3D.y, ste);
			}
			else
			{
				var start:fCell = this.scene.translateToCell(this.x, this.y, this.z);
				var goal:fCell = this.scene.translateToCell(dest3D.x, dest3D.y, 0);
				if (start == goal && (this.x != dest3D.x || this.y != dest3D.y))
				{
					//this.walkTo(dest3D);
					//pt = new Point();
					//pt.x = dest3D.x;
					//pt.y = dest3D.y;
					//this.moveToPosNoAIPt(pt, ste);
					this.moveToPosNoAIf(dest3D.x, dest3D.y, ste);
				}
			}
		}
		
		// KBEN: 这个是从一个点走到另外一个点，中间没有阻挡点，不用寻路，等价 walkTo，内部使用 walkTo ，外部使用 moveToPosNoAIPt ，有目的点的移动         
		public function moveToPosNoAIPt(where:Point, ste:uint = EntityCValue.TRun):void 
		{
			this.state = ste;
			
			this.m_dx = where.x;
			this.m_dy = where.y;
			this.m_dz = 0;
			this.m_angle = mathUtils.getAngle(this.x, this.y, this.m_dx, this.m_dy);
			// updateAngle 这个函数中统一更新方向      
			//this.orientation = this.m_angle;
			// this.walk();
			this.startMoving();
		}
		
		public function moveToPosNoAIf(wherex:Number, wherey:Number, ste:uint = EntityCValue.TRun):void 
		{
			this.state = ste;
			
			this.m_dx = wherex;
			this.m_dy = wherey;
			this.m_dz = 0;
			this.m_angle = mathUtils.getAngle(this.x, this.y, this.m_dx, this.m_dy);
			// updateAngle 这个函数中统一更新方向   
			//this.orientation = this.m_angle
			//this.walk()
			this.startMoving();
		}
		
		// KBEN: 直接移动到某一个位置 
		public function goToPosPt(where:Point, ste:uint = EntityCValue.TRun):void
		{
			this.state = ste;
			
			this.moveTo(where.x, where.y, 0);
		}
		
		// KBEN: 直接移动到某一点  
		public function goToPosf(posx:Number, posy:Number):void
		{
			this.moveTo(posx, posy, 0);
			this.m_dx = this.x;
			this.m_dy = this.y;
		}
		
		public function isKeyDown():Boolean
		{
			if (this.m_context.m_inputManager.isKeyDown(InputKey.W.keyCode) || 
				this.m_context.m_inputManager.isKeyDown(InputKey.S.keyCode) || 
				this.m_context.m_inputManager.isKeyDown(InputKey.A.keyCode) || 
				this.m_context.m_inputManager.isKeyDown(InputKey.D.keyCode))
			{
				return true;
			}
			
			return false;
		}
		
		
		public function attackTo(hurt:BeingEntity):void
		{
			this.m_angle = mathUtils.getAngle(this.x, this.y, hurt.x, this.y);
			this.orientation = this.m_angle;
			this.attack()
		}
		
		// 目前普通攻击和技能攻击在一起
		protected function attack():void
		{
			this.updateAngle();
			//this.m_state = EntityCValue.TAttack;
			//this.gotoAndPlay(EntityCValue.TSAttack);
			// 攻击和反击
			if (m_fightList.m_attackVec[0].attackType == EntityCValue.ATSingleAtt)
			{
				state = EntityCValue.TAttack;
			}
			else
			{
				state = EntityCValue.TCAttack;
			}
		}
		
		protected function hurt(item:HurtItem):void
		{
			
		}
		
		protected function die(item:HurtItem):void
		{
			
		}
		
		override public function state2StateStr(state:uint):String
		{
			// 兼容 swf 播放，重载这个函数   
			switch(state)
			{
				case EntityCValue.TStand:
					return EntityCValue.TSStand;
				case EntityCValue.TRun:
					return EntityCValue.TSRun;
				case EntityCValue.TJump:
					return EntityCValue.TSJump;
				case EntityCValue.TAttack:
					return EntityCValue.TSAttack;
				case EntityCValue.THurt:
					return EntityCValue.TSHurt;
				case EntityCValue.TDaZuo:
					return EntityCValue.TSDaZuo;
				case EntityCValue.TRide:
					return EntityCValue.TSRide;
				default:
					return EntityCValue.TSStand;
			}
		}
		
		public function needUpdate():Boolean
		{
			// 只要设置不隐藏 this._visible == true，就更新逻辑，显示数据需要真可见的时候才更新 this._visible == true && this.isVisibleNow == true
			//if (this._visible && this.isVisibleNow)
			if (this._visible)
			{
				return true;
			}
			
			if (state == EntityCValue.TRun || state == EntityCValue.TJump)
			{
				return true;
			}
			return false;
		}
		public function updateNameDesc():void
		{
			
		}
		
		// KBEN: 是否处于某种状态    
		public function isState(rh:uint):Boolean
		{
			return (m_state == rh);
		}

		public function set level(level:uint):void
		{
			m_level = level;
		}
		public function get level():uint
		{
			return m_level;
		}

		// KBEN: 设置方向，这个可能以后去掉    
		//输入:angle - 角度。取值范围(0-360)
		public function set direction(angle:Number):void
		{
			this.m_angle = angle;
			this.orientation = this.m_angle;
		}
		
		public function get nameDisc():String
		{
			return m_nameDisc;
		}
		
		
		public function get context():Context
		{
			return this.m_context;
		}
		
		//public function get serverState():uint 
		//{
			//return m_serverState;
		//}
		//
		//public function set serverState(value:uint):void 
		//{
			//m_serverState = value;
		//}
		
		// 是否处于移动状态中    
		protected function isMoving():Boolean
		{
			if (this.m_state == EntityCValue.TRun)
			{
				return true;
			}
			
			return false;
		}
		
		public function clearPath():void
		{
			// 将寻路中的节点全部清除   
			if (this.m_currentPath && this.m_currentPath.length)
			{
				this.m_currentPath.splice(0, this.m_currentPath.length);
			}
		}
		
		// 不重复播放的动作有这个结束标志  
		public function aniOver():Boolean
		{
			var act:uint = getAction();
			//var repeat:Boolean = repeatDic[act];
			var repeat:Boolean = this.definition.dicAction[act].repeat;
			if (!repeat)
			{
				if (this.customData.flash9Renderer.aniOver())
				{
					return true;
				}
			}
			
			return false;
		}

		// 根据不同的状态下，切换攻击动作   
		override public function getAction():uint
		{
			switch(m_state)
			{
				case EntityCValue.TStand:
				{
					if(m_subState == EntityCValue.TRide)
					{
						return EntityCValue.TActRideStand;
					}
					return EntityCValue.TActStand;
				}
				case EntityCValue.TRun:
				{
					if(m_subState == EntityCValue.TRide)
					{
						return EntityCValue.TActRideRun;
					}
					return EntityCValue.TActRun;
				}
				case EntityCValue.TJump:
				{
					return EntityCValue.TActJump;
				}
				case EntityCValue.TAttack:	// 攻击分为普通攻击和技能攻击        
				{
					return EntityCValue.TActAttack;
				}
				case EntityCValue.THurt:
				{
					return EntityCValue.TActHurt;
				}
				case EntityCValue.TDie:
				{
					return EntityCValue.TActDie;
				}
				case EntityCValue.TDaZuo:
				{
					return EntityCValue.TActDaZuo;
				}
				default:
				{
					return EntityCValue.TActStand;
				}
			}
		}
		
		public function get bredraBillBoard():Boolean 
		{
			return false;
		}
		
		public function set bredraBillBoard(value:Boolean):void 
		{
			
		}
		
		// NpcBattle 中重载这个函数
		public function get shiqi():uint 
		{
			return 0;
		}
		
		public function get shiQiEff():EffectEntity
		{
			return null;
		}
		
		public function set shiQiEff(value:EffectEntity):void
		{
			
		}
		
		/*public function get topEmptySprite():fEmptySprite 
		{
			return null;
		}
		
		public function get botEmptySprite():fEmptySprite 
		{
			return null;
		}*/
		
		public function getGridPos():IntPoint
		{
			return new IntPoint(this.x / this.scene.gridSize, this.y / this.scene.gridSize);
		}
		// 返回头顶名字应该距离重心点的偏移
		//override public function getTagHeight():int
		//{
			//return this.scene.engine.m_context.getTagHeight(fUtil.modelInsNum(this.m_insID));
		//}
		
		// 获取人物中心点偏移
		//override public function getTableModelOff(beingid:String, act:uint, dir:uint):Point
		//{
			//return this.scene.engine.m_context.modelOff(fUtil.modelInsNum(beingid), act, dir);
		//}
		
		// 战斗 npc 所在哪一边
		public function get side():uint 
		{
			return 0;
		}
		
		// 访问的 npc 是否是可攻击的
		public function get canAttacked():Boolean
		{
			return false;
		}
		
		// 战斗 npc 紧身攻击攻击特效是否播放完毕
		public function bAttEffOver():Boolean
		{
			return true;
		}
		
		public function get alpha():Number
		{
			return m_alpha;
		}
		public function set alpha(a:Number):void
		{
			m_alpha = a;
			if(this.customData.flash9Renderer != null)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).container.alpha = a;
			}
		}
		
		public function get baseObj():Sprite
		{
			var render:fFlash9SceneObjectSeqRenderer = customData.flash9Renderer as fFlash9SceneObjectSeqRenderer;
			if (render != null)
			{
				return render.getBaseObj();
			}
			return null;
		}
		
		public function get uiLayObj():Sprite
		{
			var render:fFlash9SceneObjectSeqRenderer = customData.flash9Renderer as fFlash9SceneObjectSeqRenderer;
			if (render != null)
			{
				return render.getUILayObj();
			}
			return null;
		}
		
		public function get assetsCreated():Boolean
		{
			var render:fFlash9SceneObjectSeqRenderer = customData.flash9Renderer as fFlash9SceneObjectSeqRenderer;
			if (render && render.assetsCreated)
			{
				return true;
			}
			return false;
		}
		
		//执行fFlash9SceneObjectSeqRenderer::createAssets后，调用此函数
		public function onCreateAssets():void
		{
			
		}
		
		// 是否更改灰度
		public function grayChange(bgrey:Boolean):void
		{
			var filterList:Array;
			if (bgrey)
			{
				if (m_greyFilter == null)
				{
					m_greyFilter = UtilFilter.createGrayFilter();
				}
				
				filterList = [m_greyFilter];
			}
			else
			{
				m_greyFilter = null;
			}
			
			var render:fFlash9SceneObjectSeqRenderer = customData.flash9Renderer as fFlash9SceneObjectSeqRenderer;
			if (render)
			{
				render.filters = filterList;
			}
		}
		
		override public function set subState(value:uint):void
		{
			if (value == m_subState)
			{
				return;
			}
			
			m_subState = value;
			// 如果取消跳跃子状态，需要更新一下动作，否则总是跳跃动作
			if (value == EntityCValue.STNone)
			{
				this.gotoAndPlay(state2StateStr(m_state));
			}
			else
			{
				this.gotoAndPlay(state2StateStr(m_subState));
			}
		}
		
		override public function get subState():uint
		{
			return m_subState;
		}
		
		// 当前是否有马匹在骑乘
		override public function get curHorseData():fObject
		{
			if (m_horseSys)
			{
				return m_horseSys.curHorseData;
			}
			
			return null;
		}
		
		// 当前是否有马匹在骑乘
		override public function get curHorseRenderData():fFlash9ElementRenderer
		{
			if (m_horseSys)
			{
				return m_horseSys.curHorseRenderData;
			}
			
			return null;
		}
		
		public function get horseSys():IMountsSys
		{
			return m_horseSys;
		}
		
		public function set horseSys(value:IMountsSys):void
		{
			m_horseSys = value;
		}
	}
}