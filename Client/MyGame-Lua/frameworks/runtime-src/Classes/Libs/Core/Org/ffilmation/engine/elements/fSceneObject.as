package org.ffilmation.engine.elements 
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.Event;
	import flash.geom.Point;
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.events.fMoveEvent;
	import org.ffilmation.engine.events.fNewCellEvent;
	import org.ffilmation.engine.helpers.fEngineCValue;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class fSceneObject extends fObject 
	{
		public var scene:fScene;
		public function fSceneObject(defObj:XML, scene:fScene):void
		{
			this.scene = scene;
			super(defObj, scene.engine.m_context);
			
		}
		override public function moveTo(x:Number, y:Number, z:Number):void
		{			
			// Last position
			var dx:Number = this.x;
			var dy:Number = this.y;
			var dz:Number = this.z;
			
			// Set new coordinates			   
			this.x = x;
			this.y = y;
			this.z = z;
			
			// Check if element moved into a different cell
			var cell:fCell = this.scene.translateToCell(x, y, z);
			if (this.cell == null || cell == null || cell != this.cell)
			{
				this.cell = cell;
				dispatchEvent(new fNewCellEvent(fElement.NEWCELL));
			}
						
			// Dispatch event			
			this.dispatchEvent(new fMoveEvent(fElement.MOVE, this.x - dx, this.y - dy, this.z - dz));
		}
		// KBEN: 清除标签    
		public function clearFloorInfo(type:uint):void
		{
			if (this.scene.m_sceneConfig.optimizeCutting)
			{
				var floor:fFloor = this.scene.translateToFloor(this.x, this.y);
				if (type == EntityCValue.TEfffect)
				{
					//floor.clearDynamic(uniqueId);
					floor.clearDynamic(this.id);
				}
				else if (type == EntityCValue.TPlayer || type == EntityCValue.TVistNpc || type == EntityCValue.TBattleNpc || type == EntityCValue.TNpcPlayerFake)
				{
					//floor.clearCharacter(uniqueId);
					floor.clearCharacter(this.id);
				}
			}
		}
		// KBEN: 调用这个更新面板信息   
		//public function updateFloorInfo(type:uint):void
		//{
		//	if (this.scene.m_sceneConfig.optimizeCutting)
		//	{
				//m_floorIdx = this.scene.translateToFloorAndIdx(this.x, this.y, m_floorIdx, this.uniqueId, this.id, type);
		//		m_floorIdx = this.scene.translateToFloorAndIdx(this.x, this.y, m_floorIdx, this.id, type);
		//	}
		//}
		/**
		 * Updates zIndex of this object so it displays with proper depth inside the scene
		 * @private
		 */
		public function updateDepth():void
		{			
			var c:fCell = (this.cell == null) ? (this.scene.translateToCell(this.x, this.y, this.z)) : (this.cell);
			var nz:Number = c.zIndex;
			this.setDepth(nz);
		}
		override public function set orientation(angle:Number):void
		{
			// KBEN: 选择对应的动画 			
			if (this.scene.m_sceneConfig.mapType == fEngineCValue.Engine2d)
			{
				angle += 45;
			}			
			setOrientation(angle);
		}
		
		public function toUIPos():Point
		{
			return scene.convertToUIPos(this.x, this.y);
		}		
	}
}