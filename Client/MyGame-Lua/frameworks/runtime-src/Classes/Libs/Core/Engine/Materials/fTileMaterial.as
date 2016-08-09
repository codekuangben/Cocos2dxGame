package org.ffilmation.engine.materials
{
	// Imports
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	//import flash.display.Shape;
	import flash.display.Sprite;
	//import flash.geom.Matrix;
	import flash.geom.Point;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.helpers.fMaterialDefinition;
	import org.ffilmation.engine.interfaces.fEngineMaterial;
	
	/**
	 * This class creates a material by "Tiling" an image in the imported libraries
	 *
	 * <p>This class is automatically selected when you define a material as "tile" in your XMLs. You don't need to use
	 * it or worry about how it works</p>
	 * @private
	 */
	public class fTileMaterial implements fEngineMaterial
	{
		// Private vars
		private var definition:fMaterialDefinition; // Definition data
		private var image:BitmapData; // The etxture itself
		protected var _res:SWFResource;	// 资源 
		
		// Constructor
		public function fTileMaterial(definition:fMaterialDefinition):void
		{
			this.definition = definition;
			// KBEN: 加载完成后再初始化    
			//var clase:Class = getDefinitionByName(this.definition.xmlData.diffuse) as Class;
			//this.image = new clase(0, 0) as BitmapData;
		}
		
		/**
		 * Frees all allocated resources for this material. It is called when the scene is destroyed and we want to free as much RAM as possible
		 */
		public function dispose():void
		{
			this.definition = null;
			if (this.image)
				this.image.dispose();
			this.image = null;
			this._res = null;
		}
		
		/**
		 * Retrieves the diffuse map for this material. If you write custom classes, make sure they return the proper size.
		 * 0,0 of the returned DisplayObject corresponds to the top-left corner of material
		 *
		 * @param element: Element where this map is to be applied
		 * @param width: Requested width
		 * @param height: Requested height
		 *
		 * @return A DisplayObject (either Bitmap or MovieClip) that will be display onscreen
		 *
		 */
		//public function getDiffuse(element:fRenderableElement, width:Number, height:Number):DisplayObject
		public function getDiffuse(element:fRenderableElement, width:Number, height:Number):BitmapData
		{
			//var temp:Shape = new Shape;
			//var matrix:Matrix = new Matrix();
			// bug: 现在每一个 floor 都是单独的一张贴图，不再一张上，因此就不偏移了 
			//if (element is fFloor)
			//	matrix.translate(-element.x, -element.y);
			//if (element is fWall)
			//{
			//	var tempw:fWall = element as fWall;
			//	if (tempw.vertical)
			//		matrix.translate(-element.y, -element.z);
			//	else
			//		matrix.translate(-element.x, -element.z);
			//}
			
			//temp.graphics.beginBitmapFill(this.image, matrix, false, true);
			//temp.graphics.drawRect(0, 0, width, height);
			//temp.graphics.drawRect(0, 0, this.image.width, this.image.height);
			//temp.graphics.endFill();
			
			//return temp;
			
			// 现在直接返回 BitmapData 对象不再重复绘制
			return this.image;
		}
		
		/**
		 * Retrieves the bump map for this material. If you write custom classes, make sure they return the proper size
		 * 0,0 of the returned DisplayObject corresponds to the top-left corner of material
		 *
		 * @param element: Element where this map is to be applied
		 * @param width: Requested width
		 * @param height: Requested height
		 *
		 * @return A DisplayObject (either Bitmap or MovieClip) that will used as BumpMap. If it is a MovieClip, the first frame will we used
		 *
		 */
		public function getBump(element:fRenderableElement, width:Number, height:Number):DisplayObject
		{
			var ret:Sprite = new Sprite;
			// KBEN:
			//var clase:Class = getDefinitionByName(this.definition.xmlData.bump) as Class;
			var clase:Class = _res.getAssetClass(this.definition.xmlData.bump) as Class;
			var image:BitmapData = new clase(0, 0) as BitmapData;
			ret.graphics.beginBitmapFill(image, null, false, true);
			ret.graphics.drawRect(0, 0, width, height);
			ret.graphics.endFill();
			return ret;
		}
		
		/**
		 * Retrieves an array of holes (if any) of this material. These holes will be used to render proper lights and calculate collisions
		 * and bullet impatcs
		 *
		 * @param element: Element where the holes will be applied
		 * @param width: Requested width
		 * @param height: Requested height
		 *
		 * @return An array of Rectangle objects, one for each hole. Positions and sizes are relative to material origin of coordinates
		 *
		 */
		public function getHoles(element:fRenderableElement, width:Number, height:Number):Array
		{
			return [];
		}
		
		/**
		 * Retrieves an array of contours that define the shape of this material. Every contours is an Array of Points
		 *
		 * @param element The element( wall or floor ) where the holes will be applied
		 * @param width: Requested width
		 * @param height: Requested height
		 *
		 * @return An array of arrays of points, one for each contour. Positions and sizes are relative to material origin of coordinates
		 *
		 */
		public function getContours(element:fRenderableElement, width:Number, height:Number):Array
		{
			return [[new Point(0, 0), new Point(width, 0), new Point(width, height), new Point(0, height)]];
		}
		
		/**
		 * Retrieves the graphic element that is to be used to block a given hole when it is closed
		 *
		 * @param index The hole index, as returned by the getHoles() method
		 * @return A MovieClip that will used to close the hole. If null is returned, the hole won't be "closeable".
		 */
		public function getHoleBlock(element:fRenderableElement, index:Number):MovieClip
		{
			return null;
		}
		
		// KBEN:初始化资源    
		public function init(res:SWFResource):void
		{
			// 初始化   
			_res = res;
			//var clase:Class = _res.getAssetClass(this.definition.xmlData.diffuse) as Class;
			var clase:Class = _res.getAssetClass(this.definition.m_diffuse) as Class;
			if (clase)
			{
				this.image = new clase() as BitmapData;
			}
		}
	}
}