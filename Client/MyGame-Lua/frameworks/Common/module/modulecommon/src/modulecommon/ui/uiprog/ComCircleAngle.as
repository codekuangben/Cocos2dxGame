package modulecommon.ui.uiprog
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	//import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author ...
	 * @brief 一个角度
	 */
	public class ComCircleAngle extends Sprite
	{
		public function ComCircleAngle(bmd:BitmapData, angle:Number) 
		{
			var bm:Bitmap = new Bitmap(bmd);
			this.addChild(bm);
			var mat:Matrix = this.transform.matrix;
			mat.translate( -bmd.width / 2, 20);
			mat.rotate((angle/180) * Math.PI);
			
			this.transform.matrix = mat;
		}	
	}
}