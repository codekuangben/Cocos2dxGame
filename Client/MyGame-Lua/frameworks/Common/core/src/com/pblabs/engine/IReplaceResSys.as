package com.pblabs.engine
{	
	import flash.display.BitmapData;

	public interface IReplaceResSys
	{
		function load():void;
		function get shadowPlace():BitmapData;
		function get playerPlace():BitmapData;
		function get thingPlace():BitmapData;
	}
}