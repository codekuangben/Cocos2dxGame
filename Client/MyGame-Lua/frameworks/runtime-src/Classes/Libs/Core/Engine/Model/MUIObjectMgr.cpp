package org.ffilmation.engine.model
{
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	
	import common.Context;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.ffilmation.engine.core.fElementContainer;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9RenderEngine;
	import org.ffilmation.utils.objectPool;
	import org.ffilmation.engine.core.fRenderableElement;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class fUIObjectMgr
	{
		private var m_context:Context;
		private var m_UIRoot:Sprite;
		private var m_dicObject:Dictionary;
		
		public function fUIObjectMgr(con:Context)
		{
			m_context = con;
			m_UIRoot = new Sprite();
			m_dicObject = new Dictionary();
		}
		

		
		/*
		public function getStaticFrame(objID:String, act:int, dir:int, orginOut:Point = null):BitmapData

		{
			var ret:BitmapData;
			var orgin:fPoint3d;
			
			var obj:fUIObject;
			for each(obj in m_dicObject)
			{
				if (obj.definitionID == def)
				{
					break;
				}
			}		
			
			if (obj != null)
			{
				ret = obj.getFrame(0, dir, act, orginOut);
				if (ret != null)
				{					
					return ret;
				}
			}
			
			var panelImage:PanelImage = m_context.m_commonImageMgr.getImage("defaultModel") as PanelImage;
			if (panelImage && panelImage.loadState == Image.Loaded)
			{
				orginOut.x = -panelImage.data.width/2;
				orginOut.y = -panelImage.data.height - 20;
				ret = panelImage.data;
			}
			return ret;
		}


		*/
		
		public function getStaticFrame(defid:String, act:int, dir:int, orginOut:Point = null):BitmapData
		{
			var ret:BitmapData;
			var pt:Point;
			// 查找时候已经有的图片资源
			var insID:String = fUtil.insStrFromModelStr(defid);
			var insdef:fObjectDefinition = this.m_context.m_sceneResMgr.getInsDefinition(insID);
			var path:String;
			if (insdef)
			{
				path = this.m_context.m_path.getPathByName(fUtil.resName(insID, act, dir), EntityCValue.PHBEING);
				var res:SWFResource = this.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource;
				if(res != null && res.isLoaded&&res.didFail==false)
				{
					//ret = res.getExportedAsset("art.scene.c" + dir +"0", true) as BitmapData;
					ret = res.getExportedAsset("art.scene."+insID+"_"+act+"_" + dir +"0", true) as BitmapData;
					if(ret != null)
					{
						// 设置偏移
						try
						{
							pt = m_context.modelOff(fUtil.modelInsNum(defid), act, dir);
							orginOut.x = insdef.dicAction[act].directDic[dir].spriteVec[0].origin.x + pt.x;
							orginOut.y = insdef.dicAction[act].directDic[dir].spriteVec[0].origin.y + pt.y;
						}
						catch (e: Error)
						{
							Logger.error(null, null, "严重错误：fUIObjectMgr::getStaticFrame, defid=" + defid + ", act=" + act + ", dir=" + dir);
						}
						return ret;
					}
				}
			}
			// 获取默认资源
			var panelImage:PanelImage = m_context.m_commonImageMgr.getImage("defaultModel") as PanelImage;
			if (panelImage && panelImage.loadState == Image.Loaded)
			{
				orginOut.x = -panelImage.data.width/2;
				orginOut.y = -panelImage.data.height - 20;
				ret = panelImage.data;
			}
			return ret;
		}
		
		public function getOrigin(def:String, act:int, dir:int):fPoint3d
		{
			var obj:fUIObject = m_dicObject[def];
			if (obj != null)
			{
				return obj.getOrigin(act, dir);
			}
			return null;
		}
		
		public function createUIObject(objID:String,def:String, objClass:Class):fUIObject
		{
			var obj:fUIObject = m_dicObject[objID];
			if (obj != null)
			{
				m_context.m_processManager.addTickedObject(obj, EntityCValue.PrioritySceneUI);
				return obj;
			}
			
			var idchar:String = fUtil.elementID(this.m_context, EntityCValue.TUIObject);
			
			var definitionObject:XML =   <character id={idchar} definition={def}/>;
			
			obj = new objClass(definitionObject, m_context);
			obj.m_objID = objID;
			//---------------------
			
			var spr:fElementContainer = objectPool.getInstanceOf(fElementContainer) as fElementContainer;
			//m_UIRoot.addChild(spr);
			var render:fFlash9ObjectSeqRenderer = new fFlash9ObjectSeqRenderer(null, spr, obj);
			obj.customData.flash9Renderer = render;
			
			m_context.m_processManager.addTickedObject(obj, EntityCValue.PrioritySceneUI);
			if (!render.assetsCreated)
			{
				render.createAssets();
			}
			
			render.screenVisible = true;
			m_dicObject[objID] = obj;
			return obj;
		}
		public function attachToTickMgr(obj:fUIObject):void
		{
			m_context.m_processManager.addTickedObject(obj, EntityCValue.PrioritySceneUI);
		}
		public function unAttachFromTickMgr(obj:fUIObject):void
		{
			m_context.m_processManager.removeTickedObject(obj);
		}
		public function releaseAllObjectByPartialName(partialName:String):void
		{
			var list:Vector.<String> = new Vector.<String>();
			var name:String;
			for (name in m_dicObject)
			{
				if (name.search(partialName) != -1)
				{
					list.push(name);
				}
			}
			
			for each(name in list)
			{
				releaseUIObject(m_dicObject[name]);
			}
		}
		public function releaseUIObject(obj:fUIObject):void
		{
			delete m_dicObject[obj.m_objID];
			unAttachFromTickMgr(obj);
			var render:fFlash9ObjectSeqRenderer = obj.customData.flash9Renderer as fFlash9ObjectSeqRenderer;
			obj.customData.flash9Renderer = null;
			render.dispose();
			
			fFlash9RenderEngine.recursiveDelete(obj.container);
			objectPool.returnInstance(obj.container);
			obj.dispose();
		}
		
		// 直接获取对象
		public function getSceneUILstUnderMouse(x:Number, y:Number):Array
		{
			var ret:Array = [];
			var el:fRenderableElement = null;
			// 查找其它
			for each(el in m_dicObject)
			{	
				if (el.customData.flash9Renderer.hitTest(x, y))
				{
					ret[ret.length] = el;
				}
			}

			if (ret.length == 0)
				return null;
			else
				return ret;
		}
	}
}