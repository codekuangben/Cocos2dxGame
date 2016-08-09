package modulecommon.scene.beings
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TMouseItem;
	import modulecommon.scene.prop.table.TNpcVisitItem;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fObject;
	import org.ffilmation.engine.helpers.fActDefinition;
	import org.ffilmation.engine.helpers.fActDirectDefinition;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.engine.helpers.fActDirOff;
	
	/**
	 * @brief 一批马匹数据
	 * */
	public class MountsEntity extends fObject
	{
		protected var m_horseID:uint;		// 坐骑的坐骑表中的 id
		protected var m_horseHost:fObject;	// 坐骑的主人
		protected var m_mountserActDirOff:fActDirOff;	// 坐骑骑乘者偏移，这个偏移是每一帧都需要配置的，主要是有些坐骑动作比较夸张，需要每一帧都去调整，因此需要去单独配置

		public function MountsEntity(horseid:uint, host:fObject, modelstr:String = "")
		{
			m_horseID = horseid;
			m_horseHost = host;
			var idchar:String = fUtil.elementID(m_horseHost.m_context, EntityCValue.TRideHorse);
			var definitionObject:XML;
			if (modelstr.length)
			{
				definitionObject = <character id={idchar} definition={modelstr} x={0} y={0} z={0} orientation={0}/>;
			}
			else	// 查找 npc 表
			{
				//var tNpcVisitItem:TNpcVisitItem;
				//tNpcVisitItem = (((m_horseHost as BeingEntity).context.m_gkcontext as GkContext).m_dataTable.getItem(DataTable.TABLE_NPCVISIT, m_horseID)) as TNpcVisitItem;
				//if (tNpcVisitItem)
				//{
				//	definitionObject = <character id={idchar} definition={tNpcVisitItem.m_strModel} x={0} y={0} z={0} orientation={0}/>;
				//}
				
				var mountsItem:TMouseItem;
				mountsItem = (((m_horseHost as BeingEntity).context.m_gkcontext as GkContext).m_dataTable.getItem(DataTable.TABLE_MOUNTS, m_horseID)) as TMouseItem;
				if (mountsItem)
				{
					definitionObject = <character id={idchar} definition={mountsItem.m_strModel} x={0} y={0} z={0} orientation={0}/>;
				}
				else
				{
					definitionObject = <character id={idchar} definition={"c2_c800"} x={0} y={0} z={0} orientation={0}/>;
				}
			}
			super(definitionObject, m_horseHost.m_context);
			
			// 修改连接点的高度信息
			this.definition.link1fHeight = this.m_context.getLink1fHeight(fUtil.modelInsNum(this.m_insID));
			this.m_mountserActDirOff = this.m_context.modelMountserOffAll(fUtil.modelInsNum(this.m_insID));
		}
		
		override public function dispose():void
		{
			this.disposeMount();
			super.dispose();
		}
		
		public function disposeMount():void
		{
			// 释放显示存放的数据
			this.customData.flash9Renderer.dispose();
		}

		public function get horseID():uint
		{
			return m_horseID;
		}

		public function set horseID(value:uint):void
		{
			m_horseID = value;
		}
		
		override public function get horseHost():fObject
		{
			return m_horseHost;
		}
		
		public function set horseHost(value:fObject):void
		{
			m_horseHost = value;
		}
		
		override public function changeInfoByActDir(act:uint, dir:uint):void
		{
			var action:fActDefinition;
			var actdir:fActDirectDefinition;
			action = this.definition.dicAction[act];
			var render:fFlash9ElementRenderer = m_horseHost.customData.flash9Renderer as fFlash9ElementRenderer;
			if (action)
			{
				actdir = action.directDic[dir];
				// 初始化一下方向信息    
				if (actdir)
				{
					// 获取中心点偏移
					if (!m_LinkOff)
					{
						var pt:Point = getTableModelOff(this.m_insID, act, dir);
						if (pt)
						{
							if (actdir.flipMode) // X 轴翻转
							{
								modeleffOff(-pt.x, pt.y);
							}
							else
							{
								modeleffOff(pt.x, pt.y);
							}
						}
						else
						{
							modeleffOff(0, 0);
						}
					}
					
					this.bounds2d.x = actdir.spriteVec[render.currentFrame].origin.x + m_LinkOff.x;
					this.bounds2d.y = actdir.spriteVec[render.currentFrame].origin.y + m_LinkOff.y;

					this.bounds2d.width = actdir.spriteVec[render.currentFrame].picWidth;
					this.bounds2d.height = actdir.spriteVec[render.currentFrame].picHeight;
					
					// Screen area
					this.screenArea = this.bounds2d.clone();
					this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
				}
			}
		}
		
		// 资源加载成功     
		override public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);

			var act:int = 0;
			var dir:int = 0;
			var mirrordir:uint = 0; // 映射的方向
			var curdir:uint = 0; // 模型当前方向
			
			// 资源加载成功
			act = int(fUtil.getActByPath(event.resourceObject.filename));
			dir = int(fUtil.getDirByPath(event.resourceObject.filename));
			mirrordir = fUtil.getMirror(dir);
			
			var hostact:int = fUtil.getPlayerActByMountAct(act);
			
			if (m_horseHost)	// 判断主人是否存在
			{
				// 也有可能是两个映射方向同时加载，这个时候优先初始化当前模型动作方向
				if (m_horseHost.getAction() == hostact)
				{
					var hostrender:fFlash9ElementRenderer = m_horseHost.customData.flash9Renderer;		// 这个地方获取的是主人的坐骑数据
					var render:fFlash9ElementRenderer = customData.flash9Renderer;
					// bug : 可能渲染器被卸载了资源才被加载进来，结果就宕机了，原来是主角过场景的时候从场景移除，结果 flash9Renderer 就为空了，结果这个时候资源加载进来了
					if (render && hostrender)
					{
						curdir = hostrender.actDir;	// 方向取坐骑主人的方向
						if (curdir == dir || curdir == mirrordir)
						{
							dir = curdir;
							render.init(event.resourceObject as SWFResource, act, dir);	// 资源初始化初始化坐骑自己的资源
						}
					}
				}
			}
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
		}
		
		// 资源加载失败    
		override public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed");
			
			var act:int = 0;
			var dir:int = 0;
			var mirrordir:uint = 0; // 映射的方向
			
			// 资源加载成功
			act = int(fUtil.getActByPath(event.resourceObject.filename));
			dir = int(fUtil.getDirByPath(event.resourceObject.filename));
			
			mirrordir = fUtil.getMirror(dir);
			_resDic[act][dir] = null;
			delete _resDic[act][dir];
			
			if (_resDic[act][mirrordir])
			{
				_resDic[act][mirrordir] = null;
				delete _resDic[act][mirrordir];
			}
			
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			
			// 如果其他方向都没有
			var hasRes:Boolean = false;
			for(dir in _resDic[act])
			{
				if (_resDic[act][dir] != null)
				{
					hasRes = true;
					break;
				}
			}
			
			if (!hasRes)
			{
				_resDic[act] = null;
				delete _resDic[act];
			}
		}
		
		// 坐骑的动作和方向和 Player 的动作和方向是否相匹配，不是相等，映射方向一样也是相同，并且返回匹配的方向
		override public function isEqualAndGetDirMount2PlayerActDir(mountact:int, mountdir:int):int
		{
			var hostact:int = fUtil.getPlayerActByMountAct(mountact);	// 坐骑动作到主人的动作
			var mirrordir:int = fUtil.getMirror(mountdir);				// 坐骑的映射方向
			
			var hostrender:fFlash9ElementRenderer = horseHost.customData.flash9Renderer;	// h主人的 render
			var hostdir:int = hostrender.actDir;		// 主人的方向
			if (m_horseHost.getAction() == hostact)
			{
				if (hostdir == mountdir || hostdir == mirrordir)
				{
					mountdir = hostdir;
					return mountdir;
				}
			}
			
			return -1;
		}
		
		// 坐骑的动作和方向和 Player 的动作和方向是否完全相等
		override public function isEqualMount2PlayerActDir(mountact:int, mountdir:int):Boolean
		{
			var hostact:int = fUtil.getPlayerActByMountAct(mountact);	// 坐骑动作到主人的动作
			var hostrender:fFlash9ElementRenderer = horseHost.customData.flash9Renderer;	// h主人的 render
			var hostdir:int = hostrender.actDir;		// 主人的方向
			if (m_horseHost.getAction() == hostact)
			{
				if (hostdir == mountdir)
				{
					return true;
				}
			}
			
			return false;
		}
		
		// 加载对象定义 xml 配置文件   
		override public function loadObjDefRes():void
		{
			// bug: 如果一个 fObject 正在加载配置文件,在没有加载完成的时候如果在此调用这个函数,就会导致资源的引用计数增加,但是监听器只有一个,导致资源卸载不了
			if(this.m_ObjDefRes || m_binsXml)	// this.m_ObjDefRes 存在说明正在加载， m_binsXml 存在说明配置文件已经初始化完成
			{
				return;
			}
			var insdef:fObjectDefinition = this.m_context.m_sceneResMgr.getInsDefinition(this.m_insID);
			if (insdef)
			{
				initObjDef();
				
				// 如果可视，加载资源    
				if (m_horseHost.customData.flash9Renderer && (m_horseHost.customData.flash9Renderer as fFlash9ElementRenderer).screenVisible)
				{
					if (m_horseHost.canUpdataRide(m_horseHost.subState, m_horseHost.getAction()))
					{
						var mountact:int = fUtil.getMountActByPlayerAct(m_horseHost.getAction());
						this.loadRes(mountact, (m_horseHost.customData.flash9Renderer as fFlash9ElementRenderer).actDir);
					}
				}
			}
			else
			{
				var filename:String = "x" + this.m_insID;
				var type:int = fUtil.xmlResType(filename);
				filename = this.m_context.m_path.getPathByName(filename + ".swf", type);
				
				//var res:SWFResource = this.m_context.m_resMgrNoProg.getResource(filename, SWFResource) as SWFResource;
				var res:SWFResource = this.m_context.m_resMgr.getResource(filename, SWFResource) as SWFResource;
				if (!res)
				{
					//this.m_ObjDefRes = this.m_context.m_resMgrNoProg.load(filename, SWFResource, this.onObjDefResLoaded, this.onObjDefResFailed) as SWFResource;
					this.m_ObjDefRes = this.m_context.m_resMgr.load(filename, SWFResource, this.onObjDefResLoaded, this.onObjDefResFailed) as SWFResource;
				}
				else if (!res.isLoaded)
				{
					this.m_ObjDefRes = res;
					res.incrementReferenceCount();
					
					res.addEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
					res.addEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
				}
				else if (!res.didFail) // bug: 加载成功才能设置 
				{
					this.m_ObjDefRes = res;
					res.incrementReferenceCount();
					onObjDefResLoaded(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
				}
			}
		}
		
		override public function onObjDefResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			initObjDef();
			// 是不是初始化完成资源，就可以移除这个资源啊
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			this.m_ObjDefRes = null;
			
			// 如果可视，加载资源
			if (m_horseHost.customData.flash9Renderer && (m_horseHost.customData.flash9Renderer as fFlash9ElementRenderer).screenVisible)
			{
				if (m_horseHost.canUpdataRide(m_horseHost.subState, m_horseHost.getAction()))
				{
					var mountact:int = fUtil.getMountActByPlayerAct(m_horseHost.getAction());
					this.loadRes(mountact, (m_horseHost.customData.flash9Renderer as fFlash9ElementRenderer).actDir);
				}
			}
		}
		
		override public function get mountserActDirOff():fActDirOff
		{
			return m_mountserActDirOff;
		}
		
		public function set mountserActDirOff(value:fActDirOff):void
		{
			m_mountserActDirOff = value;
		}
	}
}