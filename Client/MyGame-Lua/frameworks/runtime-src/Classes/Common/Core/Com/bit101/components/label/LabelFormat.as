package com.bit101.components.label 
{
	import flash.text.engine.TextRotation;
	/**
	 * ...
	 * @author 
	 */
	public class LabelFormat 
	{
		public static const ROTATE_0:String = TextRotation.ROTATE_0;
		public static const ROTATE_90:String = TextRotation.ROTATE_90;
		
		public var color:uint;
		public var size:uint;
		public var letterspace:Number=1;
		
		public var fontName:String;		
		public var lineRotation:String;
		public var text:String;
		public var miaobianColor:uint = 0x101010;
		public var bMiaobian:Boolean = true;		
		public var bBold:Boolean = false;
	}

}