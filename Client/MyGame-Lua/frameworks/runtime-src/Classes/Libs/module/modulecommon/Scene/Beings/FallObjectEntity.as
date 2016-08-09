package modulecommon.scene.beings
{
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import modulecommon.GkContext;
	import modulecommon.logicinterface.IVisitSceneObject;
	import modulecommon.net.msg.copyUserCmd.reqUserProfitInCopyUserCmd;
	import modulecommon.net.msg.propertyUserCmd.stPickUpObjPropertyUserCmd;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.prop.table.TFObjectItem;
	
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fSceneObject;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.interfaces.fMovingElement;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * ...
	 * @author
	 * @biref 掉落物，可以移动的，fObjectDefinition 创建，允许移动
	 */
	public class FallObjectEntity extends fSceneObject implements fMovingElement, ITickedObject, IVisitSceneObject
	{
		protected var m_tempid:uint; // 服务器 tmpid 
		protected var m_effVec:Vector.<EffectEntity>; // 掉落物只有链接特效  
		protected var m_fobjBase:TFObjectItem; // 表中数据    
		protected var m_name:String;
		public var m_moneyType:int;
		public var m_moneyNum:int;
		
		//protected var m_serverX:uint; // 记录服务器格子坐标
		//protected var m_serverY:uint; // 记录服务器格子坐标
		protected var m_thisid:uint;	// 现在是 thisid ，不用格子坐标了
		
		public function FallObjectEntity(defObj:XML, scene:fScene)
		{
			m_resType = EntityCValue.PHFOBJ;
			super(defObj, scene);
			m_effVec = new Vector.<EffectEntity>();
		}
		
		public function onClick():void
		{
			var hero:PlayerMain = this.gkContext.m_playerManager.hero as PlayerMain;
			if (hero == null)
			{
				return;
			}
			if (!hero.cancleAutoWalk())
			{
				return;
			}
			if (mathUtils.distance(this.x, this.y, hero.x, hero.y) <= NpcVisitBase.DISTANCE_VISIT)
			{
				execFunction();
			}
			else
			{
				hero.toSceneObject(this);
			}
		}
		
		public function onMainPlayerNewcell(e:Event):void
		{
			
			var mainPlayer:BeingEntity = this.gkContext.m_playerManager.hero;
			if (mainPlayer != null)
			{
				if (mathUtils.distanceSquare(mainPlayer.x, mainPlayer.y, this.x, this.y) < 18096)
				{
					execFunction();
				}
			}
		}
		
		public function onPlayerMainArrive():void
		{
			var hero:PlayerMain = this.gkContext.m_playerManager.hero as PlayerMain;
			if (hero == null)
			{
				return;
			}
			
			if (mathUtils.distance(this.x, this.y, hero.x, hero.y) <= NpcVisitBase.DISTANCE_VISIT + 10)
			{
				execFunction();
			}
		}
		
		public function execFunction():void
		{
			var pickmsg:stPickUpObjPropertyUserCmd;
			// 如果在组队副本中，捡取箱子的时候需要给出提示
			if(MapInfo.MTTeamFB == this.gkContext.m_mapInfo.mapType())
			{
				if(m_fobjBase.m_type == 2)	// 2 类型需要通知服务器
				{
					if(!gkContext.m_teamFBSys.buseNum)
					{
						//gkContext.m_teamFBSys.pickObj(this.serverX, this.serverY);
						gkContext.m_teamFBSys.pickObj(this.thisid);
						var cmdreq:reqUserProfitInCopyUserCmd = new reqUserProfitInCopyUserCmd();
						this.gkContext.sendMsg(cmdreq);
					}
					else
					{
						pickmsg = new stPickUpObjPropertyUserCmd();
						//pickmsg.x = this.serverX;
						//pickmsg.y = this.serverY;
						pickmsg.thisid = this.thisid;
						this.gkContext.sendMsg(pickmsg);						
					}
				}
				else
				{
					pickmsg = new stPickUpObjPropertyUserCmd();
					//pickmsg.x = this.serverX;
					//pickmsg.y = this.serverY;
					pickmsg.thisid = this.thisid;
					this.gkContext.sendMsg(pickmsg);					
				}
			}
			else
			{
				pickmsg = new stPickUpObjPropertyUserCmd();
				//pickmsg.x = this.serverX;
				//pickmsg.y = this.serverY;
				pickmsg.thisid = this.thisid;
				this.gkContext.sendMsg(pickmsg);
			}
		}
		
		public function registerAutoPick():void
		{
			var mainPlayer:BeingEntity = this.gkContext.m_playerManager.hero;
			if (mainPlayer != null)
			{
				mainPlayer.addEventListener(fElement.NEWCELL, onMainPlayerNewcell, false, 0, true);
			}
		}
		
		public function unRegisterAutoPick():void
		{
			var mainPlayer:BeingEntity = this.gkContext.m_playerManager.hero;
			if (mainPlayer != null)
			{
				mainPlayer.removeEventListener(fElement.NEWCELL, onMainPlayerNewcell);
			}
		}
		
		override public function onTick(deltaTime:Number):void
		{
			// 更新特效  
			var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while (idx >= 0)
			{
				eff = m_effVec[idx];
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
		
		public function addLinkEffect(defID:String, repeat:Boolean = true):void
		{
			var eff:EffectEntity = this.scene.createEffectNIScene(fUtil.elementID(this.m_context, EntityCValue.TEfffect), defID, 0, 0, 0);
			eff.type = EntityCValue.EFFLink;
			eff.definition.dicAction[0].repeat = repeat;
			//eff.linkedBeing = this;	// 一个链接特效只能关联到一个特效上面  
			
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
		
		// KBEN: 释放资源     
		override public function dispose():void
		{
			if (isAutoPick)
			{
				unRegisterAutoPick();
			}
			this.disposeFObjEntity();
			// bug: 掉落物这个只有一个动作，某一个方向有资源，如果按照玩家资源释放会遍历 7 * 8 这么多次数，因此重写
			this.disposeObject();
		}
		
		// KBEN: 这个 FObject 释放的时候释放自己的资源 
		public function disposeFObjEntity():void
		{
			var eff:EffectEntity;
			for each (eff in m_effVec)
			{
				this.scene.removeEffectNIScene(eff);
				// bug: 是不是得从后向前删除啊，需要测试    
				m_effVec.shift();
			}
		}
		
		/*
		override public function disposeObject():void
		{
			// KBEN: 移除，否则会宕机
			// bug: 这个地方会遍历 7 * 8 这么多次数
			var dir:int = 0;
			var key:String = "0";
			dir = 0;
			while (dir < this.definition.yCount)
			{
				if (_resDic[key][dir])
				{
					_resDic[key][dir].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
					_resDic[key][dir].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
					
					//_resDic[key][dir].decrementReferenceCount();
					this.m_context.m_resMgr.unload(_resDic[key][dir].filename, SWFResource);
					_resDic[key][dir] = null;
				}
				
				++dir;
			}
			
			_resDic[key] = null;
			_resDic = null;
			
			// 释放加载的定义文件，否则特效释放后资源才加载进来，就会宕机   
			if (this.m_ObjDefRes)
			{
				this.m_ObjDefRes.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
				this.m_ObjDefRes.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
				this.m_context.m_resMgr.unload(this.m_ObjDefRes.filename, SWFResource);
				this.m_ObjDefRes = null;
			}
			
			this.definition = null;
			this.sprites = null;
			this.collisionModel = null;
			
			this.disposeRenderable();
		}
		*/
		
		public function get tempid():uint
		{
			return m_tempid;
		}
		
		public function set tempid(value:uint):void
		{
			m_tempid = value;
		}
		
		public function get fobjBase():TFObjectItem
		{
			return m_fobjBase;
		}
		
		public function set fobjBase(value:TFObjectItem):void
		{
			m_fobjBase = value;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function set name(value:String):void
		{
			m_name = value;
		}
		
		//public function set serverX(value:uint):void
		//{
		//	m_serverX = value;
		//}
		
		//public function get serverX():uint
		//{
		//	return m_serverX;
		//}
		
		//public function set serverY(value:uint):void
		//{
		//	m_serverY = value;
		//}
		
		//public function get serverY():uint
		//{
		//	return m_serverY;
		//}
		
		public function set thisid(value:uint):void
		{
			m_thisid = value;
		}
		
		public function get thisid():uint
		{
			return m_thisid;
		}
		
		public function get isAutoPick():Boolean
		{
			if (m_fobjBase != null)
			{
				if (m_fobjBase.m_type == 1)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get gkContext():GkContext
		{
			return this.m_context.m_gkcontext as GkContext;
		}
		
		override public function onMouseEnter():void
		{
			m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_Pickup);
			if (m_fobjBase.m_type == 1)
			{
				execFunction();
			}
		}
		
		override public function onMouseLeave():void
		{
			m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
		}
		
		public function get curBitmap():Bitmap
		{
			return (this.customData.flash9Renderer as fFlash9ObjectSeqRenderer).curBitmap;
		}
		
		//实现IVisitSceneObject接口函数
		public function get posX():Number
		{
			return x;
		}
		public function get posY():Number
		{
			return y;
		}
	}
}