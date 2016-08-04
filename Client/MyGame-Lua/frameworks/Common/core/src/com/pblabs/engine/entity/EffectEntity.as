package com.pblabs.engine.entity
{
	//import com.bit101.components.Panel;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.events.fNewCellEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.elements.fFloor;
	//import org.ffilmation.engine.elements.fObject;
	import org.ffilmation.engine.elements.fSceneObject;
	import org.ffilmation.engine.events.fMoveEvent;
	import org.ffilmation.engine.helpers.fActDefinition;
	import org.ffilmation.engine.helpers.fActDirectDefinition;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.interfaces.fMovingElement;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.utils.mathUtils;

	/**
	 * ...
	 * @author 
	 * @brief 特效，是可以移动的，地物特效参与深度排序，飞行特效参与深度排序，人物身上的特效不参与深度排序         
	 */
	public class EffectEntity extends fSceneObject implements fMovingElement
	{
		// KBEN: 终点位置，存储一个位置向量，只要里面有内容就要移动        
		protected var m_currentPath:Vector.<fPoint3d>;
		protected var m_angle:Number = 0;
		protected var m_dx:Number = 0;
		protected var m_dy:Number = 0;
		protected var m_dz:Number = 0;
		protected var m_vel:Number = 100;	// 标量速度
		// KBEN: 飞行速度 
		protected var m_vx:Number = 0;
		protected var m_vy:Number = 0;
		protected var m_vz:Number = 0;
		protected var m_g:Number = -10;	// 重力加速度   
		
		protected var m_type:int = EntityCValue.EFFTerrain;		// 特效类型    
		protected var m_start:Boolean = false;	// 是否开始播放特效   
		protected var m_bdispose:Boolean = false;	// 是否销毁当前特效   
		//protected var m_linkedBeing:IBeingEntity;	// 链接特效的时候记录链接者  
		
		protected var m_effResDic:Dictionary;		// 字符串到资源的映射    
		protected var m_frameRate:uint;			// 更改的特效帧率    
		protected var m_loadEff:Dictionary;		// 已经在加载的特效文件名字   
		protected var m_bresLoad:Boolean;			// 资源是否调用加载过程 
		//protected var m_cntLoaded:uint = 0;		// 加载的资源数量    
		
		protected var m_bchangeRepeat:Boolean;	// repeat 这个属性是否更改过
		protected var m_repeat:Boolean;			// repeat 属性设置
		
		protected var m_bFlip:uint = 0;			// 是否特效需要翻转
		protected var m_scaleWidth2Orig:int;	// x 方向缩放后的宽度，图片中心点作为参考点， -1 表示不需要缩放
		protected var m_scaleHeight2Orig:int;	// y 方向缩放后的高度，图片中心点作为参考点
		protected var m_scaleWidth2Left:int;	// x 方向缩放后的宽度，图片左边作为参考点， -1 表示不需要缩放
		protected var m_scaleHeight2Top:int;	// x 方向缩放后的高度，图片顶边作为参考点， -1 表示不需要缩放

		protected var m_callback:Function;		// 这个是回调函数，飞行特效用来通知其它进行相关的处理
		protected var m_frame2scale:Dictionary;	// 帧数到缩放的映射，指向特效基本表
		protected var m_origx:Number;			// 飞行可缩放特效原点
		protected var m_origy:Number;			// 飞行可缩放特效原点
		
		protected var m_scaleXY:Number;			// XY 方向缩放因子，大小都一样
		
		public function EffectEntity(defObj:XML, scene:fScene) 
		{
			m_resType = EntityCValue.PHEFF;
			super(defObj, scene);
			this.m_start = (defObj.@start == "true");
			m_currentPath = new Vector.<fPoint3d>();
			m_effResDic = new Dictionary();
			m_loadEff = new Dictionary();
			
			m_frameRate = 0;
			m_bresLoad = false;
			
			m_scaleWidth2Orig = 0;
			m_scaleHeight2Orig = 0;
			m_scaleWidth2Left = 0;
			m_scaleHeight2Top = 0;
			
			// KBEN: 更新 floor 位置，地形特效不用更新，不会移动，链接特效根据链接信息进行裁剪，不进行场景裁剪 
			//if (m_type == EntityCValue.EFFFly)
			//{
				//updateFloorInfo(EntityCValue.TEfffect);
			//}
			
			// bug: 释放资源
			this.xmlObj = null;
			m_scaleXY = 1;		// 默认是 1 不缩放
		}
		
		// KBEN: 特效添加移动   		
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			// Last position
			var lx:Number = this.x;
			var ly:Number = this.y;
			var lz:Number = this.z;
			
			// Movement
			var dx:Number = x - lx;
			var dy:Number = y - ly;
			var dz:Number = z - lz;
			
			if (dx == 0 && dy == 0 && dz == 0)
			{
				return;
			}
			try
			{ 
				this.x = x;
				this.y = y;
				this.z = z;
				
				var cell:fCell = this.scene.translateToCell(x, y, z);
				if (this.cell == null || cell == null || cell != this.cell)
				{
					this.cell = cell;
					dispatchEvent(new fNewCellEvent(fElement.NEWCELL)); 
					
					// 继续判断是否是新的 district
					var dist:fFloor = this.scene.getFloorAtByPos(this.x, this.y);
					if(m_district == null || dist == null || m_district != dist)
					{
						// 到达新的区域没有什么好做的，仅仅是将自己的信息移动到新的区域
						m_district.clearDynamic(this.id);
						m_district = dist;
						m_district.addDynamic(this.id);
					}
				}
				
				// Dispatch event
				this.dispatchEvent(new fMoveEvent(fElement.MOVE, this.x - dx, this.y - dy, this.z - dz));
			}
			catch (e:Error)
			{
				// This means we tried to move outside scene limits
				this.x = lx;
				this.y = ly;
				this.z = lz;
			}
		}
		
		override public function onTick(deltaTime:Number):void
		{
			var angleRad:Number = 0;
			var disx:Number = 0;
			var disy:Number = 0;
			var disz:Number = 0;
			
			var cell:fCell;
			var tmpdx:Number = 0;
			var tmpdy:Number = 0;
			var tmpdz:Number = 0;
			
			var frame:int = 0;	// 当前帧数
			var scale:Point;
			
			if (m_start)
			{
				if (EntityCValue.EFFFly == m_type)
				{
					// 移动位置以及显示位置
					if (!this.definition.bscale)
					{
						angleRad = this.m_angle * Math.PI / 180;
						this.m_vx = m_vel * Math.cos(angleRad);
						this.m_vy = m_vel * Math.sin(angleRad);
						//this.m_vz = this.m_vz + m_g * deltaTime;
						
						disx = this.m_vx * deltaTime;
						disy = this.m_vy * deltaTime;
						//disz = this.m_vz * deltaTime;
						disz = 0;
						
						// 检测是否移出边界
						tmpdx = this.x + disx;
						tmpdy = this.y + disy;
						tmpdz = this.z + disz;
						// 检测是否出边界 
						cell = this.scene.translateToCell(tmpdx, tmpdy, tmpdz);
						if (!cell)
						{
							if (tmpdx < 0)
							{
								tmpdx = 0;
							}
							else if (tmpdx >= this.scene.widthpx()) // 坐标范围 [0, maxwidth - 1]
							{
								tmpdx = this.scene.widthpx() - 1;
							}
							
							if (tmpdy < 0)
							{
								tmpdy = 0;
							}
							else if (tmpdy >= this.scene.heightpx())
							{
								tmpdy = this.scene.heightpx() - 1;
							}
							
							// 路径错误，直接设置终点吧    
							m_dx = tmpdx;
							m_dy = tmpdy;
							m_dz = tmpdz;
						}

						if (Math.abs(this.m_dx - this.x) < Math.abs(disx))
						{
							disx = this.m_dx - this.x;
						}
						if (Math.abs(this.m_dy - this.y) < Math.abs(disy))
						{
							disy = this.m_dy - this.y;
						}
						//if (Math.abs(this.m_dz - this.z) < Math.abs(disz))
						//{
							//disz = this.m_dz - this.z;
						//}
						
						if (disx != 0 || disy != 0 || disz != 0)
						{
							// 如果特效不能重复播放，播放完了就消失吧  
							//if (!repeatDic[0] && this.customData.flash9Renderer.aniOver())
							if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
							{
								stop();
							}
							else
							{
								this.moveTo(this.x + disx, this.y + disy, this.z + disz);
							}
						}
						else	// 已经移动到终点了     
						{
							if (this.m_currentPath && this.m_currentPath.length > 0)
							{
								this.nextPt(this.m_currentPath.shift());
							}
							else 
							{
								stop();
								// KBEN: 现在主动销毁特效，不是被动销毁了    
								// this.scene.removeEffect(this);	// 直接将特效销毁   
							}
						}
					}
					else 	// 飞行特效可缩放，直接缩放特效
					{
						// 只有在特效启动后，并且没有停止才处理
						if (m_start)
						{
							frame = getCurFrame(deltaTime);
							if(m_frame2scale && m_frame2scale[frame])
							{
								scale = m_frame2scale[frame] as Point;
								// 宽度缩放如果是 0 ，就不缩放，原图大小
								if(scale.x == 0)
								{
									//m_scaleWidth = this.definition.dicAction[0].directDic[0].spriteVec[frame].picWidth;
									m_scaleWidth2Orig = -1;
								}
								else
								{
									// 这个是从图像需要扩展到的位置，玩家脚底为原点
									m_scaleWidth2Orig = mathUtils.distance(this.x, this.y, m_dx, m_dy) * (scale.x / 100);
								}
								m_scaleHeight2Orig = (scale.y/100) * this.definition.dicAction[0].directDic[0].spriteVec[frame].picHeight;
							}
							else
							{
								m_scaleWidth2Orig = this.definition.dicAction[0].directDic[0].spriteVec[frame].picWidth;
								m_scaleHeight2Orig = this.definition.dicAction[0].directDic[0].spriteVec[frame].picHeight;
							}
						}
						if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
						{
							stop();
						}
					}
				}
				else if(EntityCValue.EFFLink == m_type)
				{
					//if (!repeatDic[0] && this.customData.flash9Renderer.aniOver())
					if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
					{
						stop();
						// KBEN: 现在主动销毁特效，不是被动销毁了    
						// this.scene.removeEffectNIScene(this);	// 直接将特效销毁
					}
				}
				else if (EntityCValue.EFFTerrain == m_type)
				{
					// 地形特效从上面释放
					if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
					{
						stop();
					}
				}
				else if(EntityCValue.EFFSceneBtm == m_type || EntityCValue.EFFSceneTop == m_type)
				{
					// 这种类型的特效也分缩放和不缩放
					if (!this.definition.bscaleV)
					{
						if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
						{
							stop();
						}
					}
					else	// 垂直缩放，这个和水平处理正好相反，高处理方式变成宽的处理方式，宽的处理方式变成高的处理方式
					{
						// 只有在特效启动后，并且没有停止才处理
						if (m_start)
						{
							frame = getCurFrame(deltaTime);
							if(m_frame2scale && m_frame2scale[frame])
							{
								scale = m_frame2scale[frame] as Point;
								// 高度缩放如果是 0 ，就不缩放，原图大小
								if(scale.y == 0)
								{
									m_scaleHeight2Orig = -1;
								}
								else
								{
									// 这个是从图像需要扩展到的位置，玩家脚底为原点
									m_scaleHeight2Orig = mathUtils.distance(this.x, this.y, m_dx, m_dy) * (scale.y / 100);
								}
								m_scaleWidth2Orig = (scale.x/100) * this.definition.dicAction[0].directDic[0].spriteVec[frame].picHeight;
							}
							else
							{
								m_scaleWidth2Orig = this.definition.dicAction[0].directDic[0].spriteVec[frame].picWidth;
								m_scaleHeight2Orig = this.definition.dicAction[0].directDic[0].spriteVec[frame].picHeight;
							}
						}
						
						if (!this.definition.dicAction[0].repeat && this.customData.flash9Renderer.aniOver())
						{
							stop();
						}
					}
				}
				
				// 更新显示帧的绘制
				super.onTick(deltaTime);
			}
		}
		
		public function nextPt(where:fPoint3d):void
		{
			this.m_angle = mathUtils.getAngle(this.m_dx, this.m_dy, where.x, where.y);
			this.m_dx = where.x;
			this.m_dy = where.y;
			this.m_dz = where.z;
		}
		
		public function set dx(value:Number):void 
		{
			m_dx = value;
		}
		
		public function set dy(value:Number):void 
		{
			m_dy = value;
		}
		
		public function set dz(value:Number):void 
		{
			m_dz = value;
		}
		
		public function set vx(value:Number):void 
		{
			m_vx = value;
		}
		
		public function set vy(value:Number):void 
		{
			m_vy = value;
		}
		
		public function set vz(value:Number):void 
		{
			m_vz = value;
		}
		
		override public function get type():int 
		{
			return m_type;
		}
		
		public function set type(value:int):void 
		{
			m_type = value;
			
			// 飞行特效需要设置角度
			if(EntityCValue.EFFFly == value)
			{
				if(this.customData.flash9Renderer)
				{
					// 需要计算弧度
					var angleRad:Number = 0;
					if(m_bFlip)
					{
						// 加上 180 就是使坐标轴 X 轴与 flash 的 X 坐标轴方向相同
						angleRad = (this.m_angle + 180) * Math.PI / 180;
					}
					else
					{
						angleRad = this.m_angle * Math.PI / 180;
					}
					(this.customData.flash9Renderer as fFlash9ElementRenderer).changeAngle(angleRad);
				}
			}
		}
		
		public function set vel(value:Number):void 
		{
			m_vel = value;
		}
		
		//public function set linkedBeing(value:IBeingEntity):void 
		//{
			//m_linkedBeing = value;
		//}
		
		public function get bdispose():Boolean 
		{
			return m_bdispose;
		}

		// 启动
		public function start():void 
		{
			m_start = true;
		}
		
		// 停止, disp 停止的时候是否释放资源
		public function stop(disp:Boolean = true):void 
		{
			m_start = false;
			// 目前停止播放就销毁特效    
			//m_bdispose = true;
			m_bdispose = disp;
			
			if(m_callback != null)
			{
				m_callback();
				m_callback = null;
			}
		}
		
		// 暂停
		public function pause():void 
		{
			m_start = false;
		}
		
		public function addEffectPath(pt:fPoint3d):void
		{
			m_currentPath.push(pt);
		}
		
		// 设置起始点，结束点，如果继续加点，用 addEffectPath 函数     
		public function startToPt(from:fPoint3d, to:fPoint3d):void
		{
			this.m_origx = from.x;
			this.m_origy = from.y;
			
			this.m_dx = to.x;
			this.m_dy = to.y;
			this.m_dz = to.z;
			this.m_angle = mathUtils.getAngle(from.x, from.y, to.x, to.y);
		}
		
		public function startTof(fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number):void
		{
			this.m_origx = fromx;
			this.m_origy = fromy;
			
			this.m_dx = tox;
			this.m_dy = toy;
			this.m_dz = toz;
			this.m_angle = mathUtils.getAngle(fromx, fromy, tox, toy);
		}
		
		override public function dispose():void
		{
			//if (m_type == EntityCValue.EFFTerrain)
			//{
			//	this.scene.engine.m_context.m_terrainManager.terrainEntity.disposeGroundEff(this);
			//}
			//else if (m_type == EntityCValue.EFFFly)
			//{
			//	this.scene.engine.m_context.m_terrainManager.terrainEntity.disposeFlyEff(this);
			//}
			//if (m_type == EntityCValue.EFFLink)
			//{
				// bug : 现在都是主动释放，没有被动释放   
				//m_linkedBeing.removeLinkEffect(this);
			//}
			
			//this.clearFloorInfo(EntityCValue.TEfffect);
			this.disposeEffect();
			this.disposeObject();
		}
		
		public function disposeEffect():void
		{
			var key:String;
			var keylist:Vector.<String> = new Vector.<String>();
			for (key in m_effResDic)
			{
				keylist.push(key);
				if (m_effResDic[key])
				{
					m_effResDic[key].removeEventListener(ResourceEvent.LOADED_EVENT, this.onResLoaded);
					m_effResDic[key].removeEventListener(ResourceEvent.FAILED_EVENT, this.onResFailed);
						
					//this.m_context.m_resMgrNoProg.unload(m_effResDic[key].filename, SWFResource);
					this.m_context.m_resMgr.unload(m_effResDic[key].filename, SWFResource);
					m_effResDic[key] = null;
				}
			}
			
			for each(key in keylist)
			{
				delete m_effResDic[key];
			}
			
			keylist.splice(0, keylist.length);
			m_effResDic = null;
		}
		
		override public function overwriteAtt(to:fObjectDefinition, from:fObjectDefinition):void
		{
			super.overwriteAtt(to, from);
			// 特效需要自己拷贝动作中是否重复字段  
			to.dicAction[0].repeat = from.dicAction[0].repeat;
			
			// 如果自己想更改重复
			if (m_bchangeRepeat)
			{
				to.dicAction[0].repeat = m_repeat;
			}
		}
		
		// KBEN: 主要用来加载图片资源   
		override public function loadRes(act:uint, direction:uint):void
		{
			// KBEN: 这个就是图片加载，配置文件需要兼容两者，渲染文件单独写就行了      
			// 图片需要自己手工创建资源，启动解析配置文件的时候不再加载
			// 注意 load 中如果直接调用 onResLoaded ，可能这个时候 _resDic 中对应 key 的内容还没有放到 _resDic 中 
			//var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			
			//var path:String;
			//path = this.m_context.m_path.getPathByName(this.definition.dicAction[act].directArr[direction].spriteVec[render.currentFrame].mediaPath, m_resType);
			
			//var res:SWFResource = this.m_context.m_resMgrNoProg.getResource(path, SWFResource) as SWFResource;
			//if (!res)
			//{
				//m_effResDic[path] = this.m_context.m_resMgrNoProg.load(path, SWFResource, onResLoaded, onResFailed);
			//}
			
			if(m_bresLoad)
			{
				return;
			}
			
			m_bresLoad = true;
			
			// 特效一次加载所有的请求     
			var filename:String;
			var path:String;
			var xcount:uint = this.definition.dicAction[act].xCount;
			var idx:uint = 0;
			var res:SWFResource;
			
			// 现在特效都在一个包里
			//while(idx < xcount)
			{
				filename = this.definition.dicAction[act].directDic[direction].spriteVec[idx].mediaPath;
				path = this.m_context.m_path.getPathByName(filename, m_resType);
				
				// 如果没有加载这个资源   
				if(!m_loadEff[filename])
				{
					m_loadEff[filename] = 1;
					//res = this.m_context.m_resMgrNoProg.getResource(path, SWFResource) as SWFResource;
					res = this.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource;
					if (!res)
					{
						//m_effResDic[path] = this.m_context.m_resMgrNoProg.load(path, SWFResource, onResLoaded, onResFailed);
						m_effResDic[path] = this.m_context.m_resMgr.load(path, SWFResource, onResLoaded, onResFailed);
					}
					else if(!res.isLoaded)
					{
						m_effResDic[path] = res;
						res.incrementReferenceCount();
						// bug: 内存泄露，如果正确加载，就会有问题
						res.addEventListener(ResourceEvent.LOADED_EVENT, onResLoaded, false, 0, true);
						res.addEventListener(ResourceEvent.FAILED_EVENT, onResFailed, false, 0, true);
					}
					else if(!res.didFail)	// bug: 加载成功才能设置 
					{
						m_effResDic[path] = res;
						res.incrementReferenceCount();
					}
				}
				
				++idx;
			}
		}
		
		override public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			// 特效加载成功什么都不用做了，每一帧都会更新图像的   
			//var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			//var cur:uint = render.currentFrame;
			//Logger.info(null, null, cur + " framecount");
			
			//++m_cntLoaded;
			//if(m_cntLoaded == 6)
			//{
				//trace("加载完成");
			//}
		}
		
		override public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " failed");
			
			m_effResDic[event.resourceObject.filename] = null;
			delete m_effResDic[event.resourceObject.filename];
			//this.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
		}
		
		override public function onObjDefResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			initObjDef();
			
			// 如果可视，加载资源    
			if (this.customData.flash9Renderer && (this.customData.flash9Renderer as fFlash9ElementRenderer).screenVisible)
			{
				this.loadRes(this.getAction(), (this.customData.flash9Renderer as fFlash9ElementRenderer).actDir);
			}
		}
		
		// 判断某个资源的动作是否加载 
		override public function actLoaded(act:uint, direction:uint):Boolean
		{
			var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			var path:String;
			path = this.m_context.m_path.getPathByName(this.definition.dicAction[act].directDic[direction].spriteVec[render.currentFrame].mediaPath, m_resType);
			
			return (this.m_effResDic[path] && this.m_effResDic[path].isLoaded && !this.m_effResDic[path].didFail)
		}
		
		override public function get resDic():Dictionary 
		{
			return this.m_effResDic;
		}
		
		public function get frameRate():uint 
		{
			return m_frameRate;
		}
		
		public function set frameRate(value:uint):void 
		{
			m_frameRate = value;
			updateFrameRate();
		}
		
		// 改变动作方向的时候更改相关的数据  
		override public function changeInfoByActDir(act:uint, dir:uint):void
		{
			var action:fActDefinition;
			var actdir:fActDirectDefinition;
			action = this.definition.dicAction[act]
			
			var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			var currentFrame:int = render.currentFrame;
			
			var scaleadjusth:int = 0;
			var scaleadjustw:int = 0;
			var right2orig:int = 0;		// 图片右边距离中心点的距离，小于 0 ，就是在中心点的左边
			var bot2orig:int = 0;		// 图片底边距离中心点的距离，小于 0 ，就是在中心点的左边
			
			if (action)
			{
				//actdir = action.directArr[dir];
				actdir = action.directDic[dir];
				
				// 初始化一下方向信息    
				if(actdir)
				{
					// 特效不需要缩放
					if (this.definition.bscale)		// 如果水平缩放
					{
						// 如果有设置从人物脚底中心缩放的大小
						if (m_scaleWidth2Orig >= 0)
						{
							if (m_LinkOff)
							{
								right2orig = actdir.spriteVec[currentFrame].origin.x + actdir.spriteVec[currentFrame].picWidth + m_LinkOff.x;
								m_scaleWidth2Left = actdir.spriteVec[currentFrame].picWidth + m_scaleWidth2Orig - right2orig;	// 如果缩放，宽度就是缩放过的
							}
							else
							{
								right2orig = actdir.spriteVec[currentFrame].origin.x + actdir.spriteVec[currentFrame].picWidth;
								m_scaleWidth2Left = actdir.spriteVec[currentFrame].picWidth + m_scaleWidth2Orig - right2orig;	// 如果缩放，宽度就是缩放过的
							}
						}
						else	// -1 就表示没有缩放
						{
							m_scaleWidth2Left = actdir.spriteVec[currentFrame].picWidth;		// 如果没有缩放，就是原始宽度
						}
						
						scaleadjusth = (actdir.spriteVec[currentFrame].picHeight - m_scaleHeight2Orig)/2;
					}
					else if(this.definition.bscaleV)	// 如果垂直缩放
					{
						// 如果有设置从人物脚底中心缩放的大小
						if (m_scaleHeight2Orig >= 0)
						{
							if (m_LinkOff)
							{
								bot2orig = actdir.spriteVec[currentFrame].origin.y + actdir.spriteVec[currentFrame].picHeight + m_LinkOff.y;
								m_scaleHeight2Top = actdir.spriteVec[currentFrame].picHeight + m_scaleHeight2Orig - bot2orig;	// 如果缩放，宽度就是缩放过的
							}
							else
							{
								bot2orig = actdir.spriteVec[currentFrame].origin.y + actdir.spriteVec[currentFrame].picHeight;
								m_scaleHeight2Top = actdir.spriteVec[currentFrame].picHeight + m_scaleHeight2Orig - bot2orig;	// 如果缩放，宽度就是缩放过的
							}
						}
						else	// -1 就表示没有缩放
						{
							m_scaleHeight2Top = actdir.spriteVec[currentFrame].picHeight;		// 如果没有缩放，就是原始高度
						}
						
						scaleadjustw = (actdir.spriteVec[currentFrame].picWidth - m_scaleWidth2Orig)/2;
					}
					else
					{
						m_scaleWidth2Left = actdir.spriteVec[currentFrame].picWidth;		// 如果没有缩放，就是原始宽度
						m_scaleHeight2Top = actdir.spriteVec[currentFrame].picHeight;		// 如果没有缩放，就是原始宽度
					}
					// KBEN: 默认是取中心点
					if(!m_bFlip)
					{
						if (m_LinkOff)
						{
							this.bounds2d.x = actdir.spriteVec[currentFrame].origin.x + m_LinkOff.x + scaleadjustw;
							this.bounds2d.y = actdir.spriteVec[currentFrame].origin.y + m_LinkOff.y + scaleadjusth;
						}
						else
						{
							this.bounds2d.x = actdir.spriteVec[currentFrame].origin.x + scaleadjustw;
							this.bounds2d.y = actdir.spriteVec[currentFrame].origin.y + scaleadjusth;
						}
					}
					else
					{
						if (m_LinkOff)
						{
							// 注意 m_LinkOff.x 如果是镜像的话，已经做了取反了，如果正常是 5 ，那么镜像后就是 -5 了，因此才放到最外面
							this.bounds2d.x = -(actdir.spriteVec[currentFrame].origin.x + m_scaleWidth2Left + scaleadjustw) + m_LinkOff.x;
							this.bounds2d.y = actdir.spriteVec[currentFrame].origin.y + m_LinkOff.y + scaleadjusth;
						}
						else
						{
							this.bounds2d.x = -(actdir.spriteVec[currentFrame].origin.x + m_scaleWidth2Left + scaleadjustw);
							this.bounds2d.y = actdir.spriteVec[currentFrame].origin.y + scaleadjusth;
						}
					}
					
					this.bounds2d.width = actdir.spriteVec[currentFrame].picWidth;
					this.bounds2d.height = actdir.spriteVec[currentFrame].picHeight;
				}
			}
		}
		
		// 这个函数调用后，对象定义才算初始化完毕
		override public function initObjDef():void
		{
			m_binsXml = true;
			var insdef:fObjectDefinition = this.m_context.m_sceneResMgr.getInsDefinition(this.m_insID);
			
			if (!insdef && this.m_ObjDefRes)
			{
				var bytes:ByteArray;
				var clase:String = fUtil.xmlResClase(this.m_ObjDefRes.filename);
				bytes = this.m_ObjDefRes.getExportedAsset(clase) as ByteArray;
			
				var xml:XML;
				xml = new XML(bytes.readUTFBytes(bytes.length));
				
				insdef = new fObjectDefinition(xml.copy(), this.m_ObjDefRes.filename);
				this.m_context.m_sceneResMgr.addInsDefinition(insdef);
			}
			if (insdef)
			{
				// 重载属性     
				overwriteAtt(this.definition, insdef);
			}
			
			// 更新一遍帧率
			updateFrameRate();
			updateRepeat();
			
			// 初始化渲染一些数据    
			var render:fFlash9ElementRenderer = customData.flash9Renderer;
			// bug : 可能渲染器被卸载了资源才被加载进来，结果就宕机了 
			if (render != null)
			{
				render.init(null, 0, 0);
			}
		}
		
		// 重新定义模型动作属性   
		override protected function updateFrameRate():void
		{
			var action:fActDefinition;
			//if (this.definition && m_frameRate)
			if (binitXmlDef() && m_frameRate)
			{
				action = this.definition.dicAction[0];
				action.framerate = m_frameRate;
			}
			
			// test 缩放特效只取第一帧作为测试
			if(this.definition.bscale || this.definition.bscaleV)
			{
				action = this.definition.dicAction[0];
				
				m_frame2scale = this.m_context.effFrame2scale(fUtil.modelInsNum(this.m_insID));
				
				var cnt:int;
				cnt = this.m_context.effFrame(fUtil.modelInsNum(this.m_insID));
				if(cnt)
				{
					action.xCount = cnt;
					//action.directArr[0].changeFrameCnt(action.xCount, 2);
					//action.directArr[0].extendSprite(action.xCount);
					action.directDic[0].extendSprite(action.xCount);
					
					// 把实例中的定义也改一下吧
					// bug 实例定义不能改，如果把这个特效的类型改成 e6 就会有问题
					//var insdef:fObjectDefinition = this.m_context.m_sceneResMgr.getInsDefinition(this.m_insID);
					//if(insdef)
					//{
						//insdef.dicAction[0].xCount = cnt;
						//insdef.dicAction[0].directArr[0].extendSprite(action.xCount);
					//}
				}
			}
		}
		
		public function set repeat(value:Boolean):void
		{
			m_bchangeRepeat = true;
			m_repeat = value;
			
			//if (binitXmlDef())
			//{
				//this.definition.dicAction[0].repeat = m_repeat;
			//}
			updateRepeat();
		}
		
		protected function updateRepeat():void
		{
			if (binitXmlDef() && m_bchangeRepeat)
			{
				this.definition.dicAction[0].repeat = m_repeat;
			}
		}
		
		public function set bFlip(value:uint):void
		{
			m_bFlip = value;
		}
		
		override public function get bFlip():uint
		{
			return m_bFlip;
		}
		
		override public function get angle():Number
		{
			return m_angle;
		}
		
		override public function get scaleHeight2Orig():int
		{
			return m_scaleHeight2Orig;
		}
		
		override public function get scaleWidth2Left():int
		{
			return m_scaleWidth2Left;
		}
		
		override public function get scaleHeight2Top():uint
		{
			return m_scaleHeight2Top;
		}
		
		override public function get scaleWidth2Orig():uint
		{
			return m_scaleWidth2Orig;
		}
		
		public function set callback(value:Function):void
		{
			m_callback = value;
		}
		
		public function get callback():Function
		{
			return m_callback;
		}
		
		// 获取当前渲染的帧数
		public function getCurFrame(deltaTime:Number):int
		{
			var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			return render.getCurFrame(deltaTime);
		}
		
		override public function hasScale():Boolean
		{
			return (m_scaleXY != 1);
		}
		
		override public function get scaleFactor():Number
		{
			return m_scaleXY;
		}
	}
}