package com.pblabs.engine.entity 
{
	/**
	 * @brief 
	 */
	import org.ffilmation.engine.core.fScene;
	public interface IBeingManager 
	{
		/*
		function addBeing(being:Player):void;
		function disposeBeing(being:Player):void;
		function get hero():Player;
		function set hero(value:Player):void;
		function getBeingByID(id:String):Player;
		
		function destroyBeingByID(id:String):void;
		function getBeingByTmpID(tmpid:uint):Player;
		function destroyBeingByTmpID(tmpid:uint):void;
		function addBeingByTmpID(tmpid:uint, being:Player):void;
		*/
		
		function addBeing(being:BeingEntity):void;
		function disposeBeing(being:BeingEntity):void;
		//function get hero():BeingEntity;
		//function set hero(value:BeingEntity):void;
		function getBeingByID(id:String):BeingEntity;
		
		function destroyBeingByID(id:String):void;
		function getBeingByTmpID(tmpid:uint):BeingEntity;
		function destroyBeingByTmpID(tmpid:uint, bRemove:Boolean = true):void;
		function addBeingByTmpID(tmpid:uint, being:BeingEntity):void;
		
		function preInit(oldScene:fScene):void;
		function postInit(newScene:fScene):void;
	}
}