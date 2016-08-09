package com.util 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author 
	 */
	public class UtilGraphics 
	{
		
		/*绘制正方形的饼图
		 * radian - 角度（弧度制），顺时针方向画饼图
		 * halfL - 正方形边长的一半
		 */ 
		public static function drawSquarePie(gp:Graphics, radian:Number, halfL:Number):void
		{
			radian -= Math.PI / 2;
			var dl:Number = halfL * 1.414213562373095;//diagonalLine
			var dlX:Number = dl * Math.cos(radian);
			var dlY:Number = dl * Math.sin(radian);
			
			var x:Number;
			var y:Number;
			var index:int = 0;
			if (dlY >= halfL || dlY <= -halfL)
			{
				if (dlY >= halfL)
				{
					index = 2;
					y = halfL;
				}
				else
				{
					y = -halfL;
					if (dlX > 0)
					{
						index = 0;
					}
					else
					{
						index = 4;
					}
				}
				
				x = y * dlX / dlY;
			}
			else
			{
				if (dlX >= 0)
				{
					x = halfL;
					index = 1
				}
				else
				{
					x = -halfL;
					index = 3;
				}
				
				y = x * dlY / dlX;
			}
			
			var pointList:Array = [halfL, -halfL,  halfL, halfL,   -halfL, halfL,    -halfL, -halfL,   0, -halfL];
						
			gp.moveTo(0, 0);
			gp.lineTo(x, y);
			
			var i:int = index * 2;
			for (; i < pointList.length; i += 2)
			{
				gp.lineTo(pointList[i], pointList[i+1]);
			}
			//gp.lineTo(0, y);			
		}
		
	}

}