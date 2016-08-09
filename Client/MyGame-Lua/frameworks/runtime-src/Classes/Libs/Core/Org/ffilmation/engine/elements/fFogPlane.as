package org.ffilmation.engine.elements
{
	//import com.gskinner.motion.easing.Back;
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ffilmation.engine.core.fPlane;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fNewMaterialEvent;

	/**
	 * ...
	 * @author 
	 */
	public class fFogPlane extends fPlane
	{
		// 雾区域改变    
		public static const FOGREGION:String = "fogregion";
		
		/**
		 * Floor width in pixels. Size along x-axis
		 */
		public var width:Number;
		
		/**
		 * Floor depth in pixels. Size along y-axis
		 */
		public var depth:Number;
		
		// 模糊使用的过滤器参数  
		public var m_blurX:uint = 50;
		public var m_blurY:uint = 50;
		public var m_border:Number = 50;		// 除了 view 区域，边界需要保留的区域，为了避免一移动就更新区域   
		
		// 雾化需要绘制的多边形的点的列表 
		public var m_ptList:Vector.<Point>;
		
		// 绘制图元的方法   
		public var m_drawMethod:uint = 0;
		public var m_centerX:Number = 0;	// 主玩家所在中心
		public var m_centerY:Number = 0;	// 主玩家所在中心
		public var m_radius:Number = 300;	// 主玩家所在半径
		public var m_segments:Number = 6;
		
		// 任意区域所在
		public var m_anycenterX:Number = 0;	// 主玩家所在中心
		public var m_anycenterY:Number = 0;	// 主玩家所在中心
		public var m_anyradius:Number = 300;	// 主玩家所在半径
		
		public function fFogPlane(defObj:XML, scene:fScene) 
		{
			super(defObj, scene, scene.width, scene.height);
			if (defObj.@blurx.length())
			{
				//m_blurX = parseInt(xmlObj.@blurx);
			}
			if (defObj.@blury.length())
			{
				//m_blurY = parseInt(xmlObj.@blury);
			}
			if (defObj.@border.length())
			{
				//m_border = parseInt(xmlObj.@border);
			}
			if (defObj.@radius.length())
			{
				m_radius = parseInt(xmlObj.@radius);
			}
			
			this.width = scene.width;
			this.depth = scene.depth;
			
			var c1:Point = fScene.translateCoords(this.width, 0, 0);
			var c2:Point = fScene.translateCoords(this.width, this.depth, 0);
			var c3:Point = fScene.translateCoords(0, this.depth, 0);
			this.bounds2d = new Rectangle(0, c1.y, c2.x, c3.y - c1.y);
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			// fogplane 直接赋值 contour ，就不通过 material 进行赋值了， fogplane 没有 material 
			var contours:Array = this.getContours(this.width, this.depth);
			this.shapePolygon.contours = contours;
			
			m_ptList = new Vector.<Point>();
			//m_drawMethod = EntityCValue.MTReg;
			//m_centerX = 0;
			//m_centerY = 0;
			//m_radius = 0;
			//m_segments = 0;
			
			// bug: 总是释放不了 xml ,这里直接释放
			this.xmlObj = null;
		}
		
		public function getContours(width:Number, height:Number):Array
		{
			return [[new Point(0, 0), new Point(width, 0), new Point(width, height), new Point(0, height)]];
		}
		
		// 绘制规则多边形参数  
		//public function drawParam(centerX:Number, centerY:Number, radius:Number, segments:Number):void
		public function drawParam(centerX:Number, centerY:Number, segments:Number):void
		{
			m_drawMethod = EntityCValue.MTCircle;
			m_centerX = centerX;
			m_centerY = centerY;
			//m_radius = radius;
			m_segments = segments;
		}
		
		// 任意绘制雾参数
		public function drawParamAny(centerX:Number, centerY:Number, radius:Number):void
		{
			m_anycenterX = centerX;
			m_anycenterY = centerY;
			m_anyradius = radius;
		}
		
		// 填充点的开始函数 
		public function drawMethod(method:uint):void
		{
			m_drawMethod = EntityCValue.MTNoReg;
		}
		
		// 填充数据 
		public function pushPt(pt:Point):void
		{
			
		}
		
		// 绘制整个雾，这个是更新玩家所在区域的雾
		public function drawFog():void
		{
			// 通知渲染器进行重新绘制    
			//this.dispatchEvent(new fNewMaterialEvent(fPlane.NEWMATERIAL, id, this.width, this.depth));
			this.dispatchEvent(new fNewMaterialEvent(fPlane.NEWMATERIAL, EntityCValue.CenterMain, this.width, this.depth));
		}
		
		// 在地形上任意区域绘制雾，但是不能超过地形大小，回之前要填写参数
		public function drawFogAny(centerX:Number, centerY:Number, radius:Number, bupdate:Boolean = false):void
		{
			m_anycenterX = centerX;
			m_anycenterY = centerY;
			m_anyradius = radius;
			// 通知渲染器进行重新绘制    
			this.dispatchEvent(new fNewMaterialEvent(fPlane.NEWMATERIAL, EntityCValue.CenterAny, this.width, this.depth));
			
			if(bupdate)
			{
				updateFog();
			}
		}
		
		// 更新雾的区域，这个是主角移动的时候需要调用的，绘制主角在雾中区域      
		public function updateFog():void
		{
			// 通知渲染器进行重新绘制    
			this.dispatchEvent(new Event(fFogPlane.FOGREGION));
		}
		
		// KBEN: 这个是监听摄像机移动的，摄像机移动的时候就要更新显示区域 
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			var distX:Number = Math.abs(this.x - x);
			var distY:Number = Math.abs(this.y - y);
			
			// 需要重新计算   
			if (distX >= this.m_border ||
				distY >= this.m_border)
			{
				this.x = x;
				this.y = y;
				this.z = z;
				
				// bug: 不能移动这个，以为渲染器有裁剪矩形的，只能绘制范围内的  
				//this.scene.renderEngine.updateFogPosition(this);
				
				// 重新更新雾的区域   
				updateFog();
			}
		}
		
		// 更新一个区域的内容
	}
}