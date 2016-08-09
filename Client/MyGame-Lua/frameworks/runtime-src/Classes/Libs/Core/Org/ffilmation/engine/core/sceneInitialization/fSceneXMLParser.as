// XML PARSER
package org.ffilmation.engine.core.sceneInitialization
{
	// Imports
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EffectEntity;
	//import com.pblabs.engine.entity.EntityCValue;
	//import flash.display.Scene;
	import flash.utils.getDefinitionByName;
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fGlobalLight;
	import org.ffilmation.engine.core.fLight;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.stopPoint;
	import org.ffilmation.engine.elements.fFloor;
	import org.ffilmation.engine.elements.fFogPlane;
	import org.ffilmation.engine.elements.fOmniLight;
	import org.ffilmation.engine.helpers.fCellEventInfo;
	
	/**
	 * <p>The fSceneXMLParser class contains static methods that translate data from XML files into FFilmation Objects during initialization.</p>
	 *
	 * <p>Exception: Definitions ( objects, materials, etc ) are managed by the fSceneResourcemanager class</p>
	 *
	 * @private
	 */
	public class fSceneXMLParser
	{
		// bug: 现在不镶嵌了  
		/** Updates an scene's properties from an XML */
		//public static function parseSceneGeometryFromXML(scene:fScene, xmlObj:XML, tesselation:Boolean = true):void
		public static function parseSceneGeometryFromXML(scene:fScene, xmlObj:XML, tesselation:Boolean = false):void
		{
			// Grid initialization
			if (xmlObj.@gridsize.length() > 0)
			{
				scene.gridSize = xmlObj.@gridsize;
				scene.gridSizeHalf = scene.gridSize >> 1;
			}
				
			if (xmlObj.@levelsize.length() > 0)
				scene.levelSize = xmlObj.@levelsize;
			if (xmlObj.@cubeSize.length() > 0)
				scene.sortCubeSize = xmlObj.@cubeSize;
			if (xmlObj.@floorwidth.length() > 0)
				scene.m_floorWidth = xmlObj.@floorwidth;
			if (xmlObj.@floordepth.length() > 0)
				scene.m_floorDepth = xmlObj.@floordepth;
			if (xmlObj.@fog.length() > 0)
			{
				if (xmlObj.@fog == "true")
				{
					scene.m_sceneConfig.fogOpened = true;
				}
			}
			if (xmlObj.@isometric.length() > 0)
			{
				scene.m_sceneConfig.mapType = parseInt(xmlObj.@isometric);
			}
			// 这两个是为了战斗地形
			if (xmlObj.@xoff.length() > 0)
				scene.m_scenePixelXOff = parseInt(xmlObj.@xoff);
			if (xmlObj.@xoff.length() > 0)
				scene.m_scenePixelYOff = parseInt(xmlObj.@yoff);
			// 这两个是为了地形缩略图和战斗地图
			if (xmlObj.@pixelwidth.length() > 0)
				scene.m_scenePixelWidth = parseInt(xmlObj.@pixelwidth);
			if (xmlObj.@pixelheight.length() > 0)
				scene.m_scenePixelHeight = parseInt(xmlObj.@pixelheight);
			
			// Search for BOX tags and decompile into walls and floors
			var tempObj:XMLList = xmlObj.body.child("box");
			while (tempObj.length() > 0)
			{
				var box:XML = tempObj[0];
				if (box.@src1.length() > 0)
					xmlObj.body.appendChild(<wall id={box.@id + "_side1"} src={box.@src1} size={box.@sizex} height={box.@sizez} x={box.@x} y={box.@y} z={box.@z} direction="horizontal"/>);
				if (box.@src2.length() > 0)
					xmlObj.body.appendChild(<wall id={box.@id + "_side2"} src={box.@src2} size={box.@sizey} height={box.@sizez} x={parseInt(box.@x) + parseInt(box.@sizex)} y={box.@y} z={box.@z} direction="vertical"/>);
				if (box.@src3.length() > 0)
					xmlObj.body.appendChild(<wall id={box.@id + "_side3"} src={box.@src3} size={box.@sizex} height={box.@sizez} x={box.@x} y={parseInt(box.@y) + parseInt(box.@sizey)} z={box.@z} direction="horizontal"/>);
				if (box.@src4.length() > 0)
					xmlObj.body.appendChild(<wall id={box.@id + "_side4"} src={box.@src4} size={box.@sizey} height={box.@sizez} x={box.@x} y={box.@y} z={box.@z} direction="vertical"/>);
				if (box.@src5.length() > 0)
					xmlObj.body.appendChild(<floor id={box.@id + "_side5"} src={box.@src5} width={box.@sizex} height={box.@sizey} x={box.@x} y={box.@y} z={parseInt(box.@z) + parseInt(box.@sizez)}/>);
				if (box.@src6.length() > 0)
					xmlObj.body.appendChild(<floor id={box.@id + "_side6"} src={box.@src6} width={box.@sizex} height={box.@sizey} x={box.@x} y={box.@y} z={parseInt(box.@z)}/>);
				delete tempObj[0];
			}
			
			scene.top = 0;
			scene.gridWidth = 0;
			scene.gridDepth = 0;
			scene.gridHeight = 0;
			
			// KBEN: floor 区域X、Y个数
			scene.m_floorXCnt = 0;
			scene.m_floorYCnt = 0;
			
			// Parse FLOOR Tags
			var i:int;
			tempObj = xmlObj.body.child("floor");
			var xml:XML;
			for each(xml in tempObj)
			{
				fSceneXMLParser.parseFloorFromXML(scene, xml, tesselation);
			}			
			
			// Parse WALL Tags
			//tempObj = xmlObj.body.child("wall");
			//for (i = 0; i < tempObj.length(); i++)
			//	fSceneXMLParser.parseWallFromXML(scene, tempObj[i], tesselation);
			
			// Parse OBJECT Tags
			tempObj = xmlObj.body.child("object");
			for each(xml in tempObj)
			{
				if (fScene.allCharacters || xml.@dynamic == "true")
					fSceneXMLParser.parseCharacterFromXML(scene, xml);
			}				
			
			// KBEN: Parse EFFECT Tags 
			tempObj = xmlObj.body.child("effect");
			for each(xml in tempObj)
			{
				if (fScene.allCharacters || xml.@dynamic == "true")
					fSceneXMLParser.parseCharacterFromXML(scene, xml);
				else
					fSceneXMLParser.parseEffectFromXML(scene, xml);
			}			
			
			// fog 解析，一定要放在 floor 后面， character 前面      
			tempObj = xmlObj.body.child("fog");
			if (tempObj && tempObj.length())
			{
				fSceneXMLParser.parseFogFromXML(scene, tempObj[0]);
			}
			
			// 如果没有配置一些信息，这里设置一些默认值
			if (scene.m_scenePixelWidth == 0)
				scene.m_scenePixelWidth = scene.gridSize * scene.gridWidth;
			if (scene.m_scenePixelHeight == 0)
				scene.m_scenePixelHeight = scene.gridSize*scene.gridHeight;
			
			// Parse CHARACTER Tags
			tempObj = xmlObj.body.child("character");
			for (i = 0; i < tempObj.length(); i++)
				fSceneXMLParser.parseCharacterFromXML(scene, tempObj[i]);

			// KBEN: 解析阻挡点 
			tempObj = xmlObj.body.child("stoppoint");
			if (tempObj.length())
			{
				tempObj = xmlObj.body.child("stoppoint")[0].item;
				for each(xml in tempObj)
				{
					fSceneXMLParser.parseStopPointFromXML(scene, xml);
				}				
			}
				
			// Final geometry adjustments
			scene.top += scene.levelSize * 10;
			scene.gridHeight = int((scene.top / scene.levelSize) + 0.5);
			scene.height = scene.gridHeight * scene.levelSize;
		}
		
		/** Updates an scene's environment (lighting and sounds) from an XML */
		public static function parseSceneEnvironmentFromXML(scene:fScene, xmlObj:XML):void
		{
			// Parse environment light, if any
			scene.environmentLight = new fGlobalLight(xmlObj.head.child("light")[0], scene);
			
			// Parse dynamic lights
			var objfLight:XMLList = xmlObj.body.child("light");
			for (var i:int = 0; i < objfLight.length(); i++)
				fSceneXMLParser.parseLightFromXML(scene, objfLight[i]);
		}
		
		/** Updates an scene's controller from an XML */
		public static function parseSceneControllerFromXML(scene:fScene, xmlObj:XML):void
		{
			if (xmlObj.@controller.length() == 1)
			{
				var cls:String = xmlObj.@controller;
				var r:Class = getDefinitionByName(cls) as Class;
				scene.controller = new r();
			}
		}
		
		/** Updates an scene's events from an XML */
		public static function parseSceneEventsFromXML(scene:fScene, xmlObj:XML):void
		{
			// Retrieve events
			var tempObj:XMLList = xmlObj.body.child("event");
			for (var i:Number = 0; i < tempObj.length(); i++)
			{
				var evt:XML = tempObj[i];
				var tEvt:fCellEventInfo = new fCellEventInfo(evt, scene);
				
				var obi:int = tEvt.i;
				var obj:int = tEvt.j;
				var obk:int = tEvt.k;
				
				var height:int = tEvt.height / scene.levelSize;
				var width:int = tEvt.width / scene.gridSize;
				var depth:int = tEvt.depth / scene.gridSize;
				
				for (var n:int = obj; n < (obj + depth); n++)
				{
					for (var l:int = obi; l < (obi + width); l++)
					{
						for (var k:int = obk; k < (obk + height); k++)
						{
							try
							{
								var cell:fCell = scene.getCellAt(l, n, k);
								cell.events.push(tEvt);
							}
							catch (e:Error)
							{
							}
						}
					}
				}
				
				scene.events[scene.events.length] = tEvt;
			}
		}
		
		/** Inserts a new floor into an scene from an XML node */
		public static function parseFloorFromXML(scene:fScene, xmlObj:XML, tesselation:Boolean = true):void
		{
			if (xmlObj.@src.length() == 0)
				xmlObj.@src = "default";
			var nFloor:fFloor = new fFloor(xmlObj, scene);
			
			// Update scene bounds
			if (scene.gridWidth < (nFloor.i + nFloor.gWidth))
				scene.gridWidth = nFloor.i + nFloor.gWidth;
			if (scene.gridDepth < (nFloor.j + nFloor.gDepth))
				scene.gridDepth = nFloor.j + nFloor.gDepth;
			
			scene.width = scene.gridWidth * scene.gridSize;
			scene.depth = scene.gridDepth * scene.gridSize;
			if (nFloor.z > scene.top)
				scene.top = nFloor.z;
				
			// Floor X\Y 个数 
			scene.m_floorXCnt = scene.width/scene.m_floorWidth;
			scene.m_floorYCnt = scene.depth/scene.m_floorDepth;
			
			// Test if this floor should be tesselated. Tesselation returns the original floor if no tesselation
			// is performed
			if (tesselation)
			{
				var tesselated:Array = fPlaneTesselation.tesselateFloor(nFloor, scene.sortCubeSize);
				if (tesselated && tesselated.length)
				{
					for (var i:int = 0; i < tesselated.length; i++)
					{
						nFloor = tesselated[i];
						scene.floors.push(nFloor);
						scene.everything.push(nFloor);
						if (!scene.all[nFloor.id])
							scene.all[nFloor.id] = nFloor;
					}
				}
			}
			else
			{
				scene.floors.push(nFloor);
				scene.everything.push(nFloor);
				if (!scene.all[nFloor.id])
					scene.all[nFloor.id] = nFloor;
			}
		}
		
		/** Inserts a new wall into an scene from an XML node */
		/*
		public static function parseWallFromXML(scene:fScene, xmlObj:XML, tesselation:Boolean = true):void
		{
			if (xmlObj.@src.length() == 0)
				xmlObj.@src = "default";
			var nWall:fWall = new fWall(xmlObj, scene);
			
			// Update scene bounds
			if (nWall.top > scene.top)
				scene.top = nWall.top;
			
			// Test if this wall should be tesselated. Tesselation returns the original wall if no tesselation
			// is performed
			if (tesselation)
			{
				var tesselated:Array = fPlaneTesselation.tesselateWall(nWall, scene.sortCubeSize);
				if (tesselated && tesselated.length)
				{
					for (var i:int = 0; i < tesselated.length; i++)
					{
						nWall = tesselated[i];
						//scene.walls.push(nWall);
						scene.everything.push(nWall);
						if (!scene.all[nWall.id])
							scene.all[nWall.id] = nWall;
					}
				}
			}
			else
			{
				//scene.walls.push(nWall);
				scene.everything.push(nWall);
				if (!scene.all[nWall.id])
					scene.all[nWall.id] = nWall;
			}
		}
		*/
		
		/** Inserts a new character into an scene from an XML node */
		public static function parseCharacterFromXML(scene:fScene, xmlObj:XML):void
		{
			// KBEN: 人物自己的 BeingEntity     
			//var nCharacter:fCharacter = new fCharacter(xmlObj, scene);
			var nCharacter:BeingEntity;
			/*if (xmlObj.@type == "player")
			{
				//nCharacter = new Player(xmlObj, scene);
				nCharacter = new scene.engine.m_context.m_typeReg.m_classes[EntityCValue.TPlayer](xmlObj, scene);
			}
			else
			{
				//nCharacter = new Npc(xmlObj, scene);
				nCharacter = new scene.engine.m_context.m_typeReg.m_classes[EntityCValue.TNpc](xmlObj, scene);
			}*/
			
			scene.characters.push(nCharacter);
			scene.everything.push(nCharacter);
			scene.all[nCharacter.id] = nCharacter;
			
			// Update scene bounds
			if (nCharacter.top > scene.top)
				scene.top = nCharacter.top;
		}
		
		/** Inserts a new object into an scene from an XML node */
		public static function parseObjectFromXML(scene:fScene, xmlObj:XML):void
		{
			/*var nObject:fObject = new fObject(xmlObj, scene);
			scene.objects.push(nObject);
			scene.everything.push(nObject);
			scene.all[nObject.id] = nObject;
			
			// Update scene bounds
			if (nObject.top > scene.top)
				scene.top = nObject.top;*/
			
			// 静态不动的物体添加到这里
		}
		
		/** Inserts a new effect into an scene from an XML node */
		// KBEN: 特效解析，这些特效都是场景中地上物特效，其它特效在自己的管理器中         
		public static function parseEffectFromXML(scene:fScene, xmlObj:XML):void
		{
			//var nObject:fObject = new fObject(xmlObj, scene);
			var nObject:EffectEntity = new EffectEntity(xmlObj, scene);
			scene.engine.m_context.m_terrainManager.terrainEntityByScene(scene).addGroundEffect(nObject);
			// KBEN: 动态对象 
			scene.m_dynamicObjects.push(nObject);
			scene.everything.push(nObject);
			scene.all[nObject.id] = nObject;
			
			// Update scene bounds
			// KBEN:只有 fFloor 才能更改 fScene 的大小，其它的都不能更改    
			//if (nObject.top > scene.top)
			//	scene.top = nObject.top;
		}
		
		/** Inserts a new light into an scene from an XML node */
		public static function parseLightFromXML(scene:fScene, xmlObj:XML):void
		{
			var nfLight:fOmniLight = new fOmniLight(xmlObj, scene);
			
			// Events
			nfLight.addEventListener(fElement.NEWCELL, scene.processNewCell);
			nfLight.addEventListener(fElement.MOVE, scene.renderElement);
			nfLight.addEventListener(fLight.RENDER, scene.processNewCell);
			nfLight.addEventListener(fLight.RENDER, scene.renderElement);
			// KBEN: 环境灯光 GI 大小是不变的
			//nfLight.addEventListener(fLight.SIZECHANGE, scene.processNewLightDimensions);
			
			// Add to lists
			scene.lights.push(nfLight);
			scene.everything.push(nfLight);
			scene.all[nfLight.id] = nfLight;
		}
		
		// KBEN: 解析阻挡点
		public static function parseStopPointFromXML(scene:fScene, xmlObj:XML):void
		{
			var stoppoint:stopPoint = new stopPoint(xmlObj, scene);
			var xpos:int = parseInt(xmlObj.@x);
			var ypos:int = parseInt(xmlObj.@y);
			scene.addStopPoint(xpos, ypos, stoppoint);
		}
		
		// KBEN: 解析 fog  
		public static function parseFogFromXML(scene:fScene, xmlObj:XML):void
		{
			var fogplane:fFogPlane = new fFogPlane(xmlObj, scene);
			scene.fogPlane = fogplane;
		}
	}
}