package org.ffilmation.engine.core
{
	// Imports
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.events.fNewMaterialEvent;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.utils.polygons.fPolygon;
	
	
	/**
	 * <p>fPlanes are the 2d surfaces that provide the main structure for any scene. Once created, planes can't be altered
	 * as the render engine relies heavily on precalculations that depend on the structure of the scene.</p>
	 *
	 * <p>Planes cannot be instantiated directly. Instead, fWall and fFloor are used.</p>
	 *
	 * <p>fPlane contains all the lighting, occlusions and shadowcasting code. They also support bump mapping</p>
	 *
	 * <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT</p>
	 */
	public class fPlane extends fRenderableElement
	{
		// Static properties
		
		/**
		 * The fPlane.NEWMATERIAL constant defines the value of the
		 * <code>type</code> property of the event object for a <code>planenewmaterial</code> event.
		 * The event is dispatched when an new material is assigned to a plane
		 *
		 * @eventType elementmove
		 */
		public static const NEWMATERIAL:String = "planenewmaterial";
		
		// Public properties
		
		/**
		 * Array of holes in this plane.
		 * You can't create holes dynamically, they must be in the plane's material, but you can open and close them
		 *
		 * @see org.ffilmation.engine.core.fHole
		 */
		public var holes:Array; // Array of holes in this plane
		
		/**
		 * Material currently applied to this plane. This object is shared between all planes using the same definition
		 */
		public var material:fMaterial;
		
		// Private properties
		
		/**
		 * @private
		 * This polygon represents 2D shape of the plane. For each plane the irrelevant axis is not taken into account
		 */
		public var shapePolygon:fPolygon;
		
		/** @private */
		public var zIndex:Number;
		
		private var planeWidth:Number;
		private var planeHeight:Number;
		public var scene:fScene;
		
		// Constructor
		/** @private */
		function fPlane(defObj:XML, scene:fScene, width:Number, height:Number):void
		{
			// Previous
			this.scene = scene;
			super(defObj, scene.engine.m_context, defObj.@src.length() != 1);
			
			// 2D dimensions
			this.planeWidth = width;
			this.planeHeight = height;
			
			// Prepare material & holes
			this.shapePolygon = new fPolygon();
			this.holes = [];
			if (defObj.@src.length() == 1 && defObj.@src.toString().length)
				this.assignMaterial(defObj.@src);
				
			_resDic[0] = new Vector.<SWFResource>(1, true);
		}
		
		/**
		 * Changes the material for this plane.
		 *
		 * @param id Material Id
		 */
		public function assignMaterial(id:String):void
		{
			this.material = fMaterial.getMaterial(id, this.scene);
			var contours:Array = this.material.getContours(this, this.planeWidth, this.planeHeight);
			this.shapePolygon.contours = contours;
			this.holes = this.material.getHoles(this, this.planeWidth, this.planeHeight);
			this.dispatchEvent(new fNewMaterialEvent(fPlane.NEWMATERIAL, id, this.planeWidth, this.planeHeight));
			
			// Handle invisible
			//if (id.toLowerCase() == "invisible")
			//{
			//	this.castShadows = this.receiveShadows = this.receiveLights = false;
			//}
		}
		
		// Planes don't move
		/** @private */
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			throw new Error("Filmation Engine Exception: You can't move a fPlane. (" + this.id + ")");
		}
		
		// Is this plane in front of other plane ?
		/** @private */
		public function inFrontOf(p:fPlane):Boolean
		{
			return false;
		}
		
		/** @private */
		public function setZ(zIndex:Number):void
		{
			this.zIndex = zIndex;
			this.setDepth(zIndex);
		}
		
		/** @private */
		public function disposePlane():void
		{
			// KBEN: 移除，否则会宕机
			if (_resDic[0] && _resDic[0][0])
			{
				_resDic[0][0].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
				_resDic[0][0].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
				
				//_resDic[0][0].decrementReferenceCount();
				//this.scene.engine.m_context.m_resMgrNoProg.unload(_resDic[0][0].filename, SWFResource);
				this.m_context.m_resMgr.unload(_resDic[0][0].filename, SWFResource);
				_resDic[0][0] = null;
			}
		
			_resDic[0] = null;
			delete _resDic[0];
				
			_resDic = null;
			
			this.material = null;
			var hl:int = this.holes.length;
			for (var i:Number = 0; i < hl; i++)
				delete this.holes[i];
			this.holes = null;
			this.shapePolygon.contours = null;
			this.disposeRenderable();
		}
		
		/** @private */
		public override function dispose():void
		{
			this.disposePlane();
		}
		
		// KBEN: 主要用来加载图片资源   
		override public function loadRes(act:uint, direction:uint):void
		{
			// 有些是没有材质的，就不加载了
			if(this.material == null)
				return;
			// KBEN: 这个就是图片加载，配置文件需要兼容两者，渲染文件单独写就行了 
			
			// 图片需要自己手工创建资源，启动解析配置文件的时候不再加载  
			var path:String;
			path = this.m_context.m_path.getPathByName(material.definition.mediaPath, m_resType);
			
			//_resDic[act][direction] = scene.engine.m_context.m_resMgrNoProg.load(path, SWFResource, onResLoaded, onResFailed);
			
			//var res:SWFResource = this.scene.engine.m_context.m_resMgrNoProg.getResource(path, SWFResource) as SWFResource;
			var res:SWFResource = this.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource;
			if (!res)
			{
				//_resDic[act][direction] = this.scene.engine.m_context.m_resMgrNoProg.load(path, SWFResource, onResLoaded, onResFailed);
				_resDic[act][direction] = this.m_context.m_resMgr.load(path, SWFResource, onResLoaded, onResFailed);
			}
			else if(!res.isLoaded)
			{
				_resDic[act][direction] = res;
				res.incrementReferenceCount();
				res.addEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
				res.addEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			}
			else
			{
				_resDic[act][direction] = res;
				res.incrementReferenceCount();
				onResLoaded(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
			}
		}
		
		// 资源加载成功     
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			var res:SWFResource = event.resourceObject as SWFResource;
			var r:fFlash9ElementRenderer = customData.flash9Renderer;
			// bug : 可能渲染器被卸载了资源才被加载进来，结果就宕机了 
			if (r != null)
			{
				r.init(res, 0, 0);
			}
			Logger.info(null, null, res.filename + "load loaded");
		}
		
		// 资源加载失败    
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			//_resDic[0][0].decrementReferenceCount();
			_resDic[0][0] = null;
	
			//this.scene.engine.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
	
			var res:SWFResource = event.resourceObject as SWFResource;
			Logger.error(null, null, res.filename + "load failed");
		}
	}
}