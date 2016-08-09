// EmptySprite class
package org.ffilmation.engine.elements
{	
	// Imports
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import common.scene.fight.AttackItem;
	import flash.events.Event;
	import flash.geom.Point;
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.events.fMoveEvent;
	import org.ffilmation.engine.events.fNewCellEvent;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.interfaces.fMovingElement;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	/**
	 * <p>This is an empty container that you can use to add user-controlled graphic elements to the scene. Sprites can be moved and
	 * are depthsorted, but don't collide, are not affected by lights, etc.</p>
	 *
	 * <p>The fEmptySprite class is useful to handle captions, rollovers and other interface elements that need to be placed in the proper
	 * depth and position, but are not part of the environment itself.</p>
	 *
	 * <p>Also note that the flashClip property for this element is always null, unless you set in manually to something of your convenience.</p>
	 *
	 * <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT.<br>
	 * Use scene.createEmptySprite() to add new Sprites to an scene.</p>
	 *
	 * @see org.ffilmation.engine.core.fScene#createEmptySprite()
	 */
	// 现在这个兼职玩家和 UI 的双重功能，玩家不显示玩家，要显示掉血和受伤特效  
	public class fEmptySprite extends fRenderableElement implements fMovingElement
	{
		// Constructor
		/** @private */
		public var scene:fScene;
		protected var m_followBeing:BeingEntity;	// 跟随的 being   
		
		protected var m_xOff:int = 0;			// 局部原点相对于格子中心点的X方向偏移
		protected var m_yOff:int = 0;			// 局部原点相对于格子中心点的Y方向偏移
		
		protected var m_xFollowOff:int = 0;	// 跟随者相对于局部原点 X 方向偏移，主要是跟随者的定位       
		protected var m_yFollowOff:int = 0;	// 跟随者相对于局部原点 Y 方向偏移 
		
		protected var m_effVec:Vector.<EffectEntity>;	// 玩家身上添加特效
		protected var m_type:uint;	// 底下的空精灵之渲染特效使用其它不使
		
		protected var m_hurtEffOffX:Number;				// 人物受伤时候偏移，与特效需要偏移的距离正好相反
		
		function fEmptySprite(defObj:XML, scene:fScene):void
		{
			// Previous
			this.scene = scene;
			super(defObj, scene.engine.m_context);
			m_effVec = new Vector.<EffectEntity>();
			
			m_type = EntityCValue.EMPTTop;
			m_hurtEffOffX = 0;
		}
		
		public function get type():uint
		{
			return m_type;
		}

		public function set type(value:uint):void
		{
			m_type = value;
		}

		/**
		 * Updates zIndex of this object so it displays with proper depth inside the scene
		 * @private
		 */
		public function updateDepth():void
		{
			var c:fCell = (this.cell == null) ? (this.scene.translateToCell(this.x, this.y, this.z)) : (this.cell);
			if (c)
			{
				var nz:Number = c.zIndex;
				this.setDepth(nz);
			}
			else
			{
				// This tries to deduce if we are in front of everything or behind everything
				if (this.x > this.scene.width || this.y < 0 || this.z < 0)
					this.setDepth(-Infinity);
				else
					this.setDepth(Infinity);
			}
		}
		
		public function get followBeing():BeingEntity 
		{
			return m_followBeing;
		}
		
		public function set followBeing(value:BeingEntity):void 
		{
			m_followBeing = value;
		}
		
		public function updatePos():void
		{
			var destX:Number = m_followBeing.x - m_xFollowOff;
			var destY:Number = m_followBeing.y - m_yFollowOff;
			if (destX != this.x || destY != this.y)
			{
				this.moveTo(destX, destY, m_followBeing.z);
			}
			
		}
		override public function onTick(deltaTime:Number):void
		{
			// 更新位置，每一帧都更新，因为受伤的时候，玩家不是移动状态但是也后退
			updatePos();
			// 每一帧检测是否需要重新绘制 bilboard 
			/*if (m_followBeing.bredraBillBoard)
			{
				if (customData.flash9Renderer)
				{
					(customData.flash9Renderer as fFlash9ElementRenderer).rawTextField = true;
				}
				
				m_followBeing.bredraBillBoard = false;
			}*/
			
			// 更新特效
			var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while(idx >= 0)
			{
				eff = m_effVec[idx];
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
					if(eff._visible)
					{
						eff.onTick(deltaTime);
					}
				}
				--idx;
			}
			
			// 只有顶端的空精灵才更新动作
			if(EntityCValue.EMPTTop == m_type)
			{
				super.onTick(deltaTime);
			}
		}
		
		public function removeLinkEffect(effect:EffectEntity, idx:int = -1):void
		{
			
		}		
		
		public function get yOff():int 
		{
			return m_yOff;
		}
		
		public function set yOff(value:int):void 
		{
			m_yOff = value;
		}
		
		public function get xOff():int 
		{
			return m_xOff;
		}
		
		public function set xOff(value:int):void 
		{
			m_xOff = value;
		}
		
		public function get xFollowOff():int 
		{
			return m_xFollowOff;
		}
		
		public function set xFollowOff(value:int):void 
		{
			m_xFollowOff = value;
		}
		
		public function get yFollowOff():int 
		{
			return m_yFollowOff;
		}
		
		public function set yFollowOff(value:int):void 
		{
			m_yFollowOff = value;
		}
		
		public override function moveTo(x:Number, y:Number, z:Number):void
		{			
			// KBEN: 防止 z 小于 0 
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
				
				// Check if element moved into a different cell
				var cell:fCell = this.scene.translateToCell(this.x, this.y, this.z);
				
				if (cell != this.cell || this.cell == null)
				{
					var lastCell:fCell = this.cell;
					this.cell = cell;
					
					var newCell:fNewCellEvent = new fNewCellEvent(fElement.NEWCELL, m_needDepthSort);
					newCell.m_needDepthSort = m_needDepthSort;				
					
					
					dispatchEvent(newCell);
					
					// 继续判断是否是新的 district
					var dist:fFloor = this.scene.getFloorAtByPos(this.x, this.y);
					if(m_district != dist)
					{
						// 到达新的区域没有什么好做的，仅仅是将自己的信息移动到新的区域
						if(m_district)
						{
							m_district.clearEmptySprite(this.id);
						}
						if(dist)
						{
							dist.addEmptySprite(this.id);
						}
						m_district = dist;
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
			}
		}
		
		public override function dispose():void
		{
			disposeEmptyprite();
			disposeRenderable()
		}
		
		// empty sprite 目前只在战斗场景中使用 
		public function disposeEmptyprite():void
		{
			removeAllEffect();		// 释放特效
			// 判断是否在场景中
			//if(this.scene)
			//{
				//m_context.m_sceneView.scene(EntityCValue.SCFIGHT).removeEmptySprite(this, false);
			//}
		}
		
		
		
		// KBEN: 渲染显示会回调这个函数     
		override public function showRender():void
		{
			var eff:EffectEntity;
			for each(eff in m_effVec)
			{
				this.scene.renderEngine.showElement(eff);
				eff.start();
			}
		}
		
		// KBEN: 渲染隐藏会回调这个函数     
		override public function hideRender():void
		{
			var eff:EffectEntity;
			for each(eff in m_effVec)
			{
				this.scene.renderEngine.hideElement(eff);
				eff.stop();
			}
		}
		
		public function get effVec():Vector.<EffectEntity>
		{
			return m_effVec;
		}
		
		// 移走所有的特效
		public function removeAllEffect():void
		{
			var idx:int;
			idx = m_effVec.length - 1;
			while(idx >= 0)
			{
				m_effVec[idx].stop();
				removeLinkEffect(m_effVec[idx], idx);
				
				--idx;
			}
		}
		
		// 判断特效是否播放完毕
		public function bEffOver(efflist:Vector.<String>):Boolean
		{
			var idx:int;
			var effid:String;
			for each(effid in efflist)
			{
				idx = m_effVec.length - 1;
				while(idx >= 0)
				{
					// 一旦有一个特效还存在，就说明特效没有释放完毕
					if(m_effVec[idx].definitionID + "_" + m_effVec[idx].m_insID == effid)
					{
						return false;
					}
					
					--idx;
				}
			}
			
			return true;
		}
		
		public function get hurtEffOffX():Number
		{
			return m_hurtEffOffX;
		}
		
		public function set hurtEffOffX(value:Number):void
		{
			m_hurtEffOffX = value;
			
			// 更新特效  
			var eff:EffectEntity;
			var idx:int;
			idx = m_effVec.length - 1;
			while(idx >= 0)
			{
				eff = m_effVec[idx];
				// 如果受伤的时候不移动，注意这个 eff 的 x 坐标此时一定要是 0，非 0 的没有考虑
				if(eff.definition && eff.definition.hurtMove)
				{
					eff.moveTo(-m_hurtEffOffX, eff.y, 0);
				}
				--idx;
			}
		}
		
		// 重新所有的数据，到最初状态
		public function clearAll():void
		{
			// scene 这个就不清理了			
			removeAllEffect();
			m_followBeing = null;					
		}
	}
}