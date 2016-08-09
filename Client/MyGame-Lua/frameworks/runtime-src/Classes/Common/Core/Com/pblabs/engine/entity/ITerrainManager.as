package com.pblabs.engine.entity
{
	import org.ffilmation.engine.core.fScene;
	/**
	 * ...
	 * @author 
	 * @brief 地形接口  
	 */
	public interface ITerrainManager 
	{
		function terrainEntity(type:uint):TerrainEntity;
		function terrainEntityByPath(path:String):TerrainEntity;
		function terrainEntityByScene(sc:fScene):TerrainEntity;
		function preInit(oldScene:fScene, destroyRender:Boolean, bclose:Boolean):void;
		function postInit(newScene:fScene):void;
		function loadRes(norid:uint, fightid:uint):void;
		function load1000SceneRes():void;
	}
}