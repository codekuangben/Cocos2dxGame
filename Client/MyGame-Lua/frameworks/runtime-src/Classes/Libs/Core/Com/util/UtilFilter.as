package com.util
{
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UtilFilter
	{
		public static var m_sFilter:ColorMatrixFilter;
		
		public static function createGrayFilter():ColorMatrixFilter
		{
			if (m_sFilter == null)
			{
				var matrix:Array = new Array();
				/*matrix = matrix.concat([0., 0.3, 0.3, 0.0, 0]);
				   matrix = matrix.concat([0.3, 0.3, 0.3, 0.0, 0]);
				   matrix = matrix.concat([0.3, 0.3, 0.3, 0.0, 0]);
				 matrix = matrix.concat([0, 0, 0, 1, 0]);*/
				
				matrix = matrix.concat([0.5, 0.5, 0.5, 0.0, 0]);
				matrix = matrix.concat([0.5, 0.5, 0.5, 0.0, 0]);
				matrix = matrix.concat([0.5, 0.5, 0.5, 0.0, 0]);
				matrix = matrix.concat([0, 0, 0, 1, 0]);
				
				m_sFilter = new ColorMatrixFilter(matrix);
			}
			return m_sFilter;
		}
		
		public static function createLuminanceFilter(lum:Number):ColorMatrixFilter
		{
			var matrix:Array = new Array();
			
			matrix = matrix.concat([lum, 0, 0, 0.0, 0]);
			matrix = matrix.concat([0, lum, 0, 0.0, 0]);
			matrix = matrix.concat([0, 0, lum, 0.0, 0]);
			matrix = matrix.concat([0, 0, 0, 1, 0]);
			
			var ret:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return ret;
		}
	
	}

}