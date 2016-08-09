// CAMERA
package org.ffilmation.engine.core
{
	// Imports
	//import com.pblabs.engine.entity.EntityCValue;
	
	//import flash.display.BlendMode;
	import com.util.DebugBox;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.ffilmation.engine.events.fNewCellEvent;
	import org.ffilmation.engine.helpers.fUtil;
	
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.events.fMoveEvent;

	public class fCamera extends fElement
	{
		// Constants
		private static var count:Number = 0;
		
		/**
		 * Constructor for the fCamera class
		 *
		 * @param scene The scene associated to this camera
		 *
		 * @private
		 */
		private var m_scene:fScene;
		private var m_rect:Rectangle;			// 不用经常申请释放资源
		//public var m_scrollRect:Rectangle;		// 用来裁剪矩形，与 m_rect 不一样，有一点误差
		//public var m_logicPosX:Number = 0;		// 逻辑位置，就是完全和玩家的位置一样的
		//public var m_logicPosY:Number = 0;		// 逻辑位置，就是完全和玩家的位置一样的
		public var m_bInit:Boolean = false;
		
		function fCamera(scene:fScene)
		{
			var myId:String = "fCamera_" + (fCamera.count++);
			
			// Previous
			this.m_scene = scene;
			super(<camera id={myId}/>, m_scene.engine.m_context);

			m_rect = new Rectangle();
			// 这里宽度和高度赋值一个具体的值，裁剪的时候使用这个句型
			m_rect.width = this.m_context.m_config.m_curWidth;
			m_rect.height = this.m_context.m_config.m_curHeight;
			
			//m_scrollRect = new Rectangle();
		}
		
		override public function follow(target:fElement, elasticity:Number = 0):void
		{
			// 摄像机要根据逻辑上的点进行计算，跟随的时候设置成和跟随者一个位置
			//this.m_logicPosX = target.x;
			//this.m_logicPosY = target.y;
			this.offx = 0;
			this.offy = 0;
			this.offz = 0;
			
			this.elasticity = 1 + elasticity;
			// KBEN: 如果这个地方跟随者没有移动，moveListener 这个函数就不会被调用
			target.addEventListener(fElement.MOVE, this.moveListener, false, 0, true);

			// 检查位置是否有问题
			var berr:Boolean = false;
			berr = adjustPos(target.x, target.y, target.z);
			
			if(berr)
			{
				this.destx = m_rect.x + m_rect.width/2;
				this.desty = m_rect.y + m_rect.height/2;
				this.destz = 0;
				
				var dx:Number = this.destx - this.x;
				var dy:Number = this.desty - this.y;
				var dz:Number = this.destz - this.z;

				if (!(dx < 1 && dx > -1 && dy < 1 && dy > -1 && dz < 1 && dz > -1))	// 如果很小的移动就不移动了
				{
					this.moveTo(this.destx, this.desty, target.z - this.offz);
				}
			}
		}
		
		// 摄像机重载跟随，因为摄像机不能靠近地图的边缘
		override public function moveListener(evt:fMoveEvent):void
		{
			// 先检测是否能到达地图边缘
			// bug 在这个地方判断有点问题，裁剪是根据摄像机的位置裁剪的，不是根据视口，视口仅仅是显示
			var berr:Boolean = false;
			berr = adjustPos(evt.target.x, evt.target.y, evt.target.z);
			
			// 记录逻辑位置
			//m_logicPosX = evt.target.x - this.offx;
			//m_logicPosY = evt.target.y - this.offy;
			
			if(!berr)
			{
				if (this.elasticity == 1)
				{
					this.moveTo(evt.target.x - this.offx, evt.target.y - this.offy, evt.target.z - this.offz);
				}
				else
				{
					this.destx = evt.target.x - this.offx;
					this.desty = evt.target.y - this.offy;
					this.destz = evt.target.z - this.offz;

					fEngine.stage.addEventListener('enterFrame', this.followListener, false, 0, true);
				}
			}
			else
			{
				this.destx = m_rect.x + m_rect.width/2;
				this.desty = m_rect.y + m_rect.height/2;
				this.destz = 0;
				
				var dx:Number = this.destx - this.x;
				var dy:Number = this.desty - this.y;
				var dz:Number = this.destz - this.z;
				
				if (this.elasticity == 1)
				{
					this.moveTo(this.destx, this.desty, evt.target.z - this.offz);
				}
				else if (!(dx < 1 && dx > -1 && dy < 1 && dy > -1 && dz < 1 && dz > -1))	// 如果很小的移动就不移动了
				{
					fEngine.stage.addEventListener('enterFrame', this.followListener, false, 0, true);
				}
			}
		}
		
		override public function followListener(evt:Event):void
		{
			var dx:Number = this.destx - this.x;
			var dy:Number = this.desty - this.y;
			var dz:Number = this.destz - this.z;
			try
			{
				this.moveTo(this.x + dx / this.elasticity, this.y + dy / this.elasticity, this.z + dz / this.elasticity);
			}
			catch (e:Error)
			{
			}
			
			// Stop ?
			if (dx < 1 && dx > -1 && dy < 1 && dy > -1 && dz < 1 && dz > -1)
			{
				fEngine.stage.removeEventListener('enterFrame', this.followListener);
			}
		}
				// 调用 moveTo 函数之前一定要先调用 adjustPos 这个函数，如果没有调用，一定要在外面手工调用一次
		override public function moveTo(x:Number, y:Number, z:Number):void
		{
			// 这个就不需要了，如果只调用 fCamera moveTo 没有调用 follow ，如果位置有问题，就会有问题，如果也调用了 follow ，但是跟随者没有移动，如果位置有问题，也会有问题
			/*
			// 判断是否需要移动
			var berr:Boolean = false;
			berr = adjustPos(x, y, z);
			
			// 记录逻辑位置
			m_logicPosX = x;
			m_logicPosY = y;
			
			if(berr)	// 如果位置不符合条件
			{
				// 调整到正确的位置
				x = int(m_rect.x + m_rect.width/2);
				y = int(m_rect.y + m_rect.height/2);
				z = 0;
			}
			*/
			
			// Last position
			var dx:Number = this.x;
			var dy:Number = this.y;
			var dz:Number = this.z;
			
			// Set new coordinates			   
			this.x = x;
			this.y = y;
			this.z = z;
			
			// Check if element moved into a different cell
			var cell:fCell = this.m_scene.translateToCell(x, y, z);
			if (cell == null)
			{
				var str:String = fUtil.getStackInfo("");
				DebugBox.sendToDataBase("fCamera::moveTo cell x="+x+" ,y="+y+str);
			}
			if (this.cell == null || cell == null || cell != this.cell)
			{
				// 修真相机的裁剪视口
				//setViewportSize(this.m_scene.engine.m_context.m_config.m_curWidth, this.m_scene.engine.m_context.m_config.m_curHeight);
				this.cell = cell;
				dispatchEvent(new fNewCellEvent(fElement.NEWCELL));
			}
						
			// Dispatch event			
			this.dispatchEvent(new fMoveEvent(fElement.MOVE, this.x - dx, this.y - dy, this.z - dz));
		}
		
		// 如果需要调整位置返回 true
		protected function adjustPos(targetx:Number, targety:Number, targetz:Number):Boolean
		{
			var berr:Boolean = false;
			//if(this.m_scene.m_sceneType != EntityCValue.SCFight)
			//{
				var lcdestx:Number = targetx - this.offx;
				var lcdesty:Number = targety - this.offy;
				var lcdestz:Number = targetz - this.offz;
				// 假设不会进行坐标转换，不用调用这个函数了
				// var p:Point = fScene.translateCoords(camera.x, camera.y, camera.z);
				m_rect.width = m_context.m_config.m_curWidth;
				m_rect.height = m_context.m_config.m_curHeight;
				m_rect.x = Math.round(-m_context.m_config.m_curWidth / 2 + lcdestx);
				m_rect.y = Math.round(-m_context.m_config.m_curHeight / 2 + lcdesty);
				if (m_rect.x < 0)
				{
					m_rect.x = 0;
					berr = true;
				}
				else if (m_rect.x > this.m_scene.m_scenePixelXOff + this.m_scene.widthpx() - m_rect.width)		// 战斗地形需要添加 m_scenePixelXOff
				{
					m_rect.x = this.m_scene.m_scenePixelXOff + this.m_scene.widthpx() - m_rect.width;
					berr = true;
				}
				if (m_rect.y < 0)
				{
					m_rect.y = 0;
					berr = true;
				}
				else if (m_rect.y > this.m_scene.heightpx() - m_rect.height)
				{
					m_rect.y = this.m_scene.heightpx() - m_rect.height;
					berr = true;
				}
			//}
			
			return berr;
		}
		
		// 这个也是移动相机到指定位置，类似 moveTo ，只不过很多函数都要走 moveTo ，如果很多逻辑写到 moveTo 里面就重复了
		public function gotoPos(xtarget:Number, ytarget:Number, ztarget:Number):void
		{
			// 第一次调用这个函数，就说明初始化了
			m_bInit = true;
			if(adjustPos(xtarget, ytarget, ztarget))
			{
				moveTo(m_rect.x + m_rect.width/2, m_rect.y + m_rect.height/2, 0);
			}
			else
			{
				moveTo(xtarget, ytarget, ztarget);
			}
		}
		
		// 相机也保存一份数据视口数据，其它地方会用到
		public function setViewportSize(width:Number, height:Number):void
		{
			gotoPos(this.x, this.y, this.z);
			/*m_scrollRect.width = int(width);
			m_scrollRect.height = int(height);
			m_scrollRect.x = int(Math.round(-width / 2 + this.x));
			m_scrollRect.y = int(Math.round( -height / 2 + this.y));*/
		}
	}
}