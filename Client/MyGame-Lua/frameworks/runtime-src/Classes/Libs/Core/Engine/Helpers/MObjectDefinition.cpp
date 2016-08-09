package org.ffilmation.engine.helpers
{
	// Imports
	import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.logicSolvers.collisionSolver.collisionModels.fBoxCollisionModel;
	import org.ffilmation.engine.logicSolvers.collisionSolver.collisionModels.fCilinderCollisionModel;
	import org.ffilmation.engine.logicSolvers.collisionSolver.collisionModels.fEngineCollisionModel;
	
	import flash.events.Event;
	//import flash.geom.Rectangle;
	import org.ffilmation.engine.datatypes.fPoint3d;
	
	/**
	 * @private
	 * THIS IS A HELPER OBJECT. OBJECTS IN THE HELPERS PACKAGE ARE NOT SUPPOSED TO BE USED EXTERNALLY. DOCUMENTATION ON THIS OBJECTS IS
	 * FOR DEVELOPER REFERENCE, NOT USERS OF THE ENGINE
	 *
	 * This object stores an object definition loaded from a definition XML
	 */
	public class fObjectDefinition extends fResourceDefinition
	{
		// Public vars
		public var _sprites:Array;
		public var receiveLights:Boolean;
		//public var receiveShadows:Boolean;
		//public var castShadows:Boolean;
		//public var solid:Boolean;
		// KBEN:
		private var _objType:int = fEngineCValue.MdMovieClip;	// 对象类型，如果是 0 模型就是 MovieClip， 1 是图片序列 2 是全部在整张图上      
        /**
         * The width of each frame.
         */
        public var _width:int = 32;	// 如果是在一张图片上就会用到这个字段
        
        /**
         * The height of each frame.
         */
        public var _height:int = 32;	// 如果是在一张图片上就会用到这个字段
		
		/**
         * The number of cells in the x direction.
         */
        //public var _xCount:int = 1;
		
		// 动作数量  
		private var _actionCnt:int = 1;
        
        /**
         * The number of cells in the y direction.
         */
        public var _yCount:int = 1;
        
        /**
         * The horizonal spacing between frames
         */	  
        public var _horizontalSpacing:int = 0;
        
        /**
         * The vertical spacing between frames
         */	  
        public var _verticalSpacing:int = 0;
		
		// 如果是图片序列 
		private var _dicAction:Dictionary;	// 这里存放所有的动作信息. [act,fActDefinition]的集合
		
		// KBEN: media 资源文件的路径，这个字段不要用了，直接从 fPictureSequenceDefinition 中取数据
		//private var _mediaPath:String;
		// KBEN: 资源定义是否初始化了 
		private var _bInit:Boolean = false;
		protected var _overwrite:Boolean = false;	// </insDef> 定义文件中，决定是否覆盖模板中的定义     
		//protected var m_tagWidth:uint = 32;
		protected var m_tagHeight:int = 0;
		
		protected var m_name:String = "";	// 对应 name="e2" 这个字段  
		// 链接特效用这个字段说明是绑定到上层还是下层    0: 上层   1 : 下层   
		protected var m_layer:uint = 0;
		protected var m_effDir:uint = 0;	// 特效方向 飞行特效: 0 从左向右  1 从右向左  连接特效: 0: 从左向右攻击时候受伤特效 1 从右向左攻击时候受伤特效
		// protected var m_version:uint = 0;	// 版本号 0 说明是模板 1 说明是老版本实例定义 2 说明是新版本实例定义 ，现在都是新版本，去掉这个字段 
		
		protected var m_bindType:uint = 0;	// 主要是战斗飞行和受伤特效， 0 绑定到格子上面， 1 绑定到每一个人身上
		protected var m_hurtMove:uint = 0;	// 受伤时候玩家后退，这个特效是否跟着移动， 0 移动 1 不移动
		protected var m_scale:uint = 0;	// 特效是否可以缩放，如果可以缩放，飞行特效的时候就直接缩放特效，特效位置不移动。 0 是不可缩放 1 是可缩放，这个是横着缩放
		protected var m_scaleV:uint = 0;	// 特效是否可以缩放，如果可以缩放，场景UI特效缩放，0 是不可缩放 1 是可缩放，这个是竖着缩放
		
		protected var m_link1fHeight:int = 0;	// 骑乘的连接点的高度，没有水平偏移，只有高度偏移，人物特效没有使用这个变量
		
		// Constructor
		// KBEN: data 这个参数就是 objectDefinition 这个元素，以及父类 fResourceDefinition 中的 xmlData 这个数据     
		public function fObjectDefinition(data:XML, basepath:String):void
		{
			super(data, basepath);
			
			var directIdx:int = 0;
			
			// Definition Lights enabled ?
			//this.receiveLights = data.@receiveLights.toString() != "false";
			//this.receiveShadows = data.@receiveShadows.toString() != "false";
			//this.castShadows = data.@castShadows.toString() != "false";
			//this.solid = data.@solid.toString() != "false";
			
			// KBEN:    
			this._objType = parseInt(data.@type.toString());
			// 图片序列就是每一个小图片的大小，整个图片就是整个图片的大小    
			if (data.@width.length())
			{
				this._width = parseInt(data.@width.toString());
			}
			if (data.@height.length())
			{
				this._height = parseInt(data.@height.toString());
			}
			//if (data.@tagwidth.length())
			//{
				//this.m_tagWidth = parseInt(data.@tagwidth.toString());
			//}
			if (data.@tagheight.length())
			{
				this.m_tagHeight = parseInt(data.@tagheight.toString());
			}
			
			if (data.@name.length())
			{
				m_name = data.@name;
			}
			
			// 图片序列就是每一个动作的帧的数量    
			//this._xCount = parseInt(data.@xcount.toString());
			// 这个是方向的个数，默认是 8 个 
			//this._yCount = parseInt(data.@ycount.toString());
			if (data.@overwrite && data.@overwrite == "1")
			{
				_overwrite = true;
			}
			
			var tpl:int = 0;	// 这个是指定是否是模板
			if (data.@tpl && data.@tpl == "1")
			{
				tpl = parseInt(data.@tpl.toString());
			}
			
			if (isNaN(this._objType))
				this._objType = 0;
			//if (isNaN(this._width))
			//	this._width = 0;
			//if (isNaN(this._height))
			//	this._height = 0;
			//if (isNaN(this._xCount))
			//	this._xCount = 8;
			if (isNaN(this._yCount))
				this._yCount = 8;
			
			var state:int = 0;
			var idx:int = 0;
			//var xcnt:uint = 0;	// KBEN: 每一个动作的帧数    
			var action:fActDefinition;
			var actDirect:fActDirectDefinition;
			var sprite:fSpriteDefinition;
			_actionCnt = 0;
			_dicAction ||= new Dictionary();
			var itemModel:XML;
			var angle:int;
			//var resPack:Boolean = false;		// 每一个动作的资源是否打包在一个包里   
			var total:uint;	// 特效使用  
			var itemSprite:XML;
			var itemmapdata:XML;
			//var version:uint = 0;		// 当前版本检查 0 : 模板定义 1 老版本的实例定义  2 新版本的实例定义
				
			if (_objType == fEngineCValue.MdPicSeq)	// 图片序列   
			{
				this._yCount = 8;
				// 每一个动作遍历    
				for each (itemModel in this.xmlData.displayModel)
				{
					action = new fActDefinition();					
					// 公共属性，将模型宽度和高度赋值给动作     
					//action.width = _width;
					//action.height = _height;
					action.horizontalSpacing = _verticalSpacing;
					action.verticalSpacing = _verticalSpacing;
					action.objType = _objType;
					action.yCount = _yCount;
					
					if (itemModel.@xcount.length())
					{
						action.xCount = parseInt(itemModel.@xcount);
						
						// bug: 有的现在是 0，因此纠正一下，以后去掉
						//if(!action.xCount)
						//{
						//	action.xCount = 1;
						//}
					}
					if (itemModel.@framerate.length())
					{
						action.framerate = parseInt(itemModel.@framerate);
						
						// bug: 有的现在是 0，因此纠正一下，以后去掉
						//if(!action.framerate)
						//{
						//	action.framerate = 1;
						//}
					}
					//if (itemModel.@media.length())
					//{
					//	action.mediaPath = itemModel.@media;
					//}
					
					if (itemModel.@repeat && itemModel.@repeat == "true")
					{
						action.repeat = true;
					}
					else
					{
						action.repeat = false;
					}
					//if (itemModel.@pack && itemModel.@pack == "1")
					//{
					//	action.resPack = true;
					//}
					//else
					//{
					//	action.resPack = false;
					//}
					
					idx = parseInt(itemModel.@act);
					action.actID = idx;
					_dicAction[idx] = action;
					
					var startName:String = "";
					//var mediaPath:String;	
					//var repeat:int;
					var cnt:uint = 0;	// 注意从 0 开始还是从 1 开始    
					
					// 每一个方向遍历     
					for each (itemSprite in itemModel.child("sprite"))
					{
						actDirect = new fActDirectDefinition();
						angle = parseInt(itemSprite.@angle);
						directIdx = (angle / 360) * this.yCount;
						action.directDic[directIdx] = actDirect;
						// 默认直接将动作资源路径存放在方向资源路径里面去   
						//actDirect.mediaPath = action.mediaPath
						
						// KBEN: 直接写在配置文件，不同过角度判断了 
						//if (isFlip(angle))	// 图像需要映射，默认都是 X 映射      
						//{
						//	actDirect.flipMode = EntityCValue.FLPX;
						//}
						if (itemSprite.@flip.length() > 0)
						{
							actDirect.flipMode = parseInt(itemSprite.@flip);
						}
						//if (itemSprite.@media.length() > 0)
						//{
							//actDirect.mediaPath = itemSprite.@media;
						//}
						
						// 图片坐标原点偏移   
						if (itemSprite.@xorig.length() > 0)
						{
							actDirect.origin.x = parseInt(itemSprite.@xorig);
							//version = 1;	// 说明是老版本的实例定义 
						}
						if (itemSprite.@yorig.length() > 0)
						{
							actDirect.origin.y = parseInt(itemSprite.@yorig);
						}
						
						actDirect.angle = angle;
						
						if (itemSprite.@src.length() > 0)
						{
							startName = itemSprite.@src;	// 起始图片名字，名字一次增加    
						}
						
						cnt = 0;	// 注意从 0 开始还是从 1 开始
						
						//while (cnt < action.xCount)
						//{
							//sprite = new fSpriteDefinition(cnt, null, null);
							// 图片是行 0 开始编号还是从 1 开始编号的 
							//sprite.startName = fUtil.mergeFileName(startName, cnt);	
							//actDirect.spriteVec.push(sprite);
							//++cnt;
						//}
						
						// 生成新的图片序列
						if (itemSprite)
						{
							//itemmapdata = itemSprite.mapdata[0];
							// 说明是模板，模板直接赋值    
							if (tpl == 1)
							{
								// 如果是老版本的模板定义，新版本如果图片为空 actDirect.origin.x 也是 0，这个时候如果 startName 不为 "" ，才是模板
								//if(0 == version && startName != "")
								if(startName != "")
								{
									sprite = new fSpriteDefinition(angle, null, null);
									// 图片是行 0 开始编号还是从 1 开始编号的 
									//sprite.startName = fUtil.mergeFileName(startName, cnt);
									sprite.startName = startName;
									actDirect.spriteVec.push(sprite);
									++cnt;
								}
								//else if(1 == version)	// 如果是老版本的实例定义
								//{
									// 老版本需要处理的数据，不要放在 while 里面，那是 bug 
								//	if(this.m_tagHeight > 0)
								//	{
								//		this.m_tagHeight = -this.m_tagHeight;
								//	}
								//	actDirect.origin.x = -actDirect.origin.x;
								//	actDirect.origin.y = -actDirect.origin.y;
									
								//	while (cnt < action.xCount)
								//	{
								//		sprite = new fSpriteDefinition(angle, null, null);
										
								//		sprite.origin.x = actDirect.origin.x;
								//		sprite.origin.y = actDirect.origin.y;
								//		sprite.picWidth = this._width;
								//		sprite.picHeight = this._height;
										
								//		sprite.startName = fUtil.mergeFileName(startName, cnt)
								//		actDirect.spriteVec.push(sprite);
										
								//		++cnt;
								//	}
								//}
							}
							else	// 实例需要取出具体的配置       
							{
								itemmapdata = itemSprite.mapdata[0];
								//version = 2;
								for each (itemmapdata in itemSprite.child("mapdata"))
								{
									sprite = new fSpriteDefinition(angle, null, null);
									// 图片坐标原点偏移   
									if (itemmapdata.@xorig.length() > 0)
									{
										sprite.origin.x = parseInt(itemmapdata.@xorig);
									}
									if (itemmapdata.@yorig.length() > 0)
									{
										sprite.origin.y = parseInt(itemmapdata.@yorig);
									}
									
									if (itemmapdata.@width.length())
									{
										sprite.picWidth = parseInt(itemmapdata.@width);
									}
									if (itemmapdata.@height.length())
									{
										sprite.picHeight = parseInt(itemmapdata.@height);
									}
									
									actDirect.spriteVec.push(sprite);
									
									++cnt;
								}
								
								// test: 帧数和 mapdata 的配置一定要相同数量，只能以最小的为标准     
								// 现在某些动作的有些方向是没有的，但是配置文件中仍然导出来了，只不过图片是没有的
								//if (cnt < action.xCount)
								//{
								//	throw new Event("mapdata count net equal xcount");
								//}
							}
						}
					}
					
					// KBEN: 这个地方也是排序，注意每一个方向的动作不要大于 45 个  
					//action.directArr.sort(sortFunc);
					++_actionCnt;
				}
			}
			else if (_objType == fEngineCValue.MdPicOne)	// 模型在一张贴图上      
			{
				for each (itemModel in this.xmlData.displayModel)
				{
					action = new fActDefinition();					
					// 公共属性   
					//action.width = _width;
					//action.height = _height;
					action.horizontalSpacing = _verticalSpacing;
					action.verticalSpacing = _verticalSpacing;
					action.objType = _objType;
					action.yCount = _yCount;
					
					action.xCount = parseInt(itemModel.@xcount);
					action.framerate = parseInt(itemModel.@framerate);
					//action.mediaPath = itemModel.@media;
					if (itemModel.@repeat == "true")
					{
						action.repeat = true;
					}
					else
					{
						action.repeat = false;
					}
					
					idx = parseInt(itemModel.@act);
					_dicAction[idx] = action;
					
					itemSprite = itemModel.sprite[0];
					
					if (itemSprite)
					{
						angle = parseInt(itemSprite.@angle);
						sprite = new fSpriteDefinition(angle, null, null);
						sprite.startName = itemSprite.@src;
						//action.directArr.push(sprite);
						directIdx = (angle / 360) * this.yCount;
						action.directDic[directIdx] = sprite;
					}
				}
			}
			else if (_objType == fEngineCValue.MdEffPicOne)	// 特效图片一张贴图         
			{
				itemModel = this.xmlData.displayModel[0];	// 粒子只有一个动作，一个方向    
				action = new fActDefinition();
				
				// 公共属性   
				//action.width = _width;
				//action.height = _height;
				action.horizontalSpacing = _verticalSpacing;
				action.verticalSpacing = _verticalSpacing;
				action.objType = _objType;
				action.yCount = _yCount;
				
				action.xCount = parseInt(itemModel.@xcount);
				action.framerate = parseInt(itemModel.@framerate);
				//action.mediaPath = itemModel.@media;
				if (itemModel.@repeat == "true")
				{
					action.repeat = true;
				}
				else
				{
					action.repeat = false;
				}
				
				action.total = parseInt(itemModel.@total);	// 特效总数    
				
				idx = parseInt(itemModel.@act);
				_dicAction[idx] = action;
				
				actDirect = new fActDirectDefinition();
				//action.directArr.push(actDirect);
				action.directDic[0] = actDirect;
				
				angle = 0;	// 特效只有一个方向，赋值默认值就行了  
				actDirect.angle = angle;
				itemSprite = itemModel.sprite[angle];
				
				if (itemSprite)
				{
					sprite = new fSpriteDefinition(angle, null, null);
					sprite.startName = itemSprite.@src;
					actDirect.spriteVec.push(sprite);
				}
			}
			else if (_objType == fEngineCValue.MdEffPicSeq)	// 特效在不同的图上       
			{
				if (data.@layer.length())
				{
					m_layer = parseInt(data.@layer);
				}
				// 特效方向
				if (data.@effdir.length())
				{
					m_effDir = parseInt(data.@effdir);
				}
				// 特效绑定类型，绑定到格子上还是人身上
				if (data.@bindtype.length())
				{
					m_bindType = parseInt(data.@bindtype);
				}
				// 人物受伤的时候，特效是否跟随格子移动
				if(data.@hurtmove.length())
				{
					m_hurtMove = parseInt(data.@hurtmove);
				}
				// 特效是否可以横着缩放
				if (data.@scale.length())
				{
					m_scale = parseInt(data.@scale);
				}
				// 特效竖着缩放
				if (data.@scalev.length())
				{
					m_scaleV = parseInt(data.@scalev);
				}
				
				this._yCount = 1;
				itemModel = this.xmlData.displayModel[0];	// 粒子只有一个动作，一个方向 
				action = new fActDefinition();
				// 公共属性   
				//action.width = _width;
				//action.height = _height;
				action.horizontalSpacing = _verticalSpacing;
				action.verticalSpacing = _verticalSpacing;
				action.objType = _objType;
				//action.yCount = _yCount;	// 这个默认 1 配置文件不需要写这个字段     
				action.yCount = 1;
				
				action.xCount = parseInt(itemModel.@xcount);
				action.framerate = parseInt(itemModel.@framerate);
				//action.mediaPath = itemModel.@media;
				if (itemModel.@repeat == "true")
				{
					action.repeat = true;
				}
				else
				{
					action.repeat = false;
				}
				
				// action.total = parseInt(itemModel.@total);	// 特效总数  
				action.total = action.xCount;
			
				idx = parseInt(itemModel.@act);
				_dicAction[idx] = action;
				
				actDirect = new fActDirectDefinition();
				//action.directArr.push(actDirect);
				action.directDic[0] = actDirect;
				
				angle = 0; 	// 特效只有一个方向，赋值默认值就行了  	
				actDirect.angle = angle;
				itemSprite = itemModel.sprite[angle];
				
				// 每一个动作方向的序列    
				// 如果是特效模板的话，sprite 肯定存在，如果是实例， sprite 就不存在
				if (itemSprite)
				{
					//itemmapdata = itemSprite.mapdata[0];
					// 说明是模板，模板直接赋值    
					//if (!itemmapdata)
					if(tpl == 1)
					{
						while (cnt < action.xCount)
						{
							sprite = new fSpriteDefinition(angle, null, null);
							//sprite.startName = fUtil.mergeFileName(itemSprite.@src, cnt)
							sprite.startName = itemSprite.@src;
							actDirect.spriteVec.push(sprite);
							
							++cnt;
							++_actionCnt;
						}
					}
					else	// 实例需要取出具体的配置       
					{
						//version = 1;
						itemmapdata = itemSprite.mapdata[0];
						for each (itemmapdata in itemSprite.child("mapdata"))
						{
							sprite = new fSpriteDefinition(angle, null, null);
							// 图片坐标原点偏移   
							if (itemmapdata.@xorig.length() > 0)
							{
								sprite.origin.x = parseInt(itemmapdata.@xorig);
							}
							if (itemmapdata.@yorig.length() > 0)
							{
								sprite.origin.y = parseInt(itemmapdata.@yorig);
							}
							
							if (itemmapdata.@width.length())
							{
								sprite.picWidth = parseInt(itemmapdata.@width);
								//version = 2;
							}
							if (itemmapdata.@height.length())
							{
								sprite.picHeight = parseInt(itemmapdata.@height);
							}
							
							//if(1 == version)
							//{
							//	if (itemmapdata.@mediapath.length())
							//	{
							//		sprite.mediaPath = itemmapdata.@mediapath;
							//	}
							//}
							//else	// 新打包
							//{
								if (itemmapdata.@mediaPath.length())	// 本来打算如果一个特效资源太大，就分成好几个包，但是最后逻辑太复杂，就全放在一个包里了，因此这里好保留这个
								{
									sprite.mediaPath = itemmapdata.@mediaPath;
								}
							//}
							
							actDirect.spriteVec.push(sprite);
							
							++cnt;
							++_actionCnt;
						}
						
						// test: 帧数和 mapdata 的配置一定要相同数量     
						if (cnt != action.xCount)
						{
							throw new Event("mapdata count net equal xcount");
						}
					}
				}
			}
			
			//m_version = version;

			// bug: 总是释放不了 xml ,这里直接释放,其它地方还要用
			//this.xmlData = null;
		}
		
		// Return display model
		public function get sprites():Array
		{
			// Parse display model
			// KBEN: 这个放在初始化 init 代码里面，直接返回结果就行了 
			//if (!this._sprites)
			//{
				//this._sprites = new Array;
				//var sprites:XMLList = this.xmlData.displayModel.child("sprite");
				//for (var i:Number = 0; i < sprites.length(); i++)
				//{
					//var spr:XML = sprites[i];
					//
					// Check for library item
					//var clase:Class = getDefinitionByName(spr.@src) as Class;
					//
					// Check for shadow definition or use default
					//try
					//{
						//var shadow:Class = getDefinitionByName(spr.@shadowsrc) as Class;
					//}
					//catch (e:Error)
					//{
						//shadow = clase;
					//}
					//this._sprites[this._sprites.length] = new fSpriteDefinition(parseInt(spr.@angle), clase, shadow);
				//}
				//
				// Sort _sprites and add first one to the end of the list
				//this._sprites.sortOn("angle", Array.NUMERIC);
				//this._sprites[this._sprites.length] = this._sprites[0];
			//}
			
			return this._sprites;
		}
		
		// Return a collision model for this definition
		public function get collisionModel():fEngineCollisionModel
		{
			// Retrieve collision model
			if (this.xmlData.collisionModel.cilinder.length() > 0)
			{
				return new fCilinderCollisionModel(this.xmlData.collisionModel.cilinder[0]);
			}
			else if (this.xmlData.collisionModel.box.length() > 0)
			{
				return new fBoxCollisionModel(this.xmlData.collisionModel.box[0]);
			}
			// KBEN: 默认创建一个，不再抛出异常  
			//else
			//	throw new Error("Can't find a collision model");
			else
			{
				// KBEN: 默认创建一个   
				var definitionObject:XML = <collisionModel><cilinder radius="8" height="130"/></collisionModel>;
				
				this.xmlData.insertChildAfter(this.xmlData.displayModel[this.xmlData.displayModel.length() - 1], definitionObject)
				return new fCilinderCollisionModel(this.xmlData.collisionModel.cilinder[0]);
			}
		}
		
		// KBENN:		
		//public function get xCount():int
		//{
			//return  _xCount;
		//}
		//
		public function get yCount():int
		{
			return  _yCount;
		}
		
		/**
         * @inheritDoc
         */
        //public function get frameCount():int
        //{            
            //return _xCount * _yCount;
        //}
		
		// 获取帧的总共的数量 
		//public function get totalFrameCount():int
		//{
			//return _actionCnt * _xCount * _yCount;
		//}
		
		public function get objType():int 
		{
			return _objType;
		}
		
		public function set objType(value:int):void 
		{
			_objType = value;
		}
		
		public function get actionCnt():int 
		{
			return _actionCnt;
		}
		
		public function set actionCnt(value:int):void 
		{
			_actionCnt = value;
		}
		
		public function get dicAction():Dictionary 
		{
			return _dicAction;
		}
		
		public function set dicAction(value:Dictionary):void 
		{
			_dicAction = value;
		}
		
		public function get overwrite():Boolean 
		{
			return _overwrite;
		}
		
		public function set overwrite(value:Boolean):void 
		{
			_overwrite = value;
		}
		
		//public function get tagWidth():uint 
		//{
			//return m_tagWidth;
		//}
		
		//public function set tagWidth(value:uint):void 
		//{
			//m_tagWidth = value;
		//}
		
		public function get tagHeight():int 
		{
			return m_tagHeight;
		}
		
		public function set tagHeight(value:int):void 
		{
			m_tagHeight = value;
		}
		
		public function get link1fHeight():int 
		{
			return m_link1fHeight;
		}
		
		public function set link1fHeight(value:int):void 
		{
			m_link1fHeight = value;
		}
		
		public function get name():String 
		{
			return m_name;
		}
		
		//public function get mediaPath():String 
		//{
			//return _mediaPath;
		//}
		//
		//public function set mediaPath(value:String):void 
		//{
			//_mediaPath = value;
		//}
        
        /**
         * @inheritDoc
         */
        //public function getFrameArea(index:int):Rectangle
        //{
			//if (_objType == fEngineCValue.MdPicOne)
			//{
				//var x:int = index % _xCount;
				//var y:int = Math.floor(index / _yCount);
				//
				//return new Rectangle(x * (_width + _horizontalSpacing), y * (_height + _verticalSpacing), _width, _height);
			//}
			//else
			//{
				//return new Rectangle(0, 0, _width, _height);
			//}
        //}
		
		// KBEN:主要是图片类初始化类常量，不需要这个函数了，类都是直接从 SWFResource 中获取，不再自己 new 了，因为是图片，共享    
		public function init(res:SWFResource, act:uint):void
		{
			var idx:uint = 0;
			var totalCnt:uint = 0;
			var action:fActDefinition;
			var actDirect:fActDirectDefinition;
			var sprite:fSpriteDefinition;
			var angle:int;
			var cnt:uint = 0;
			var directIdx:int = 0;
			var itemModel:XML;
			
			if (fEngineCValue.MdPicSeq == _objType)
			{
				action = _dicAction[act];
				if (action.bInit)
				{
					return;
				}
				action.bInit = true;
				// 遍历每一个动作    
				for each (itemModel in this.xmlData.displayModel)
				{
					if (parseInt(itemModel.@act) == act)
					{
						break;
					}
				}
				//for each (itemModel in this.xmlData.displayModel)
				{
					//idx = parseInt(itemModel.@act);
					
					// 遍历每一个方向   
					for each (var itemSprite:XML in itemModel.child("sprite"))
					{
						angle = parseInt(itemSprite.@angle);
						//directIdx = (angle / 360) * action.directArr.length;
						directIdx = (angle / 360) * this.yCount;
						actDirect = action.directDic[directIdx];
						cnt = 0;
						while (cnt < action.xCount)
						{
							sprite = actDirect.spriteVec[cnt];
						
							// Check for library item
							sprite.sprite = res.getAssetClass(sprite.startName);
							if (!sprite.sprite)
							{
								// KBEN: 输出日志  
								Logger.error(null, null, "resource failed: " + sprite.startName);
							}
							++cnt;
						}
					}
				}
			}
			else if (fEngineCValue.MdMovieClip == _objType)	// 资源是 MovieClip 
			{
				if (_bInit)
				{
					return;
				}
				_bInit = true;
				// Parse display model
				// KBEN: 不存在的时候再初始化，存在就不初始化了，外面已经判断是否初始化了     
				//if (!this._sprites)
				{
					this._sprites = new Array;
					var sprites:XMLList = this.xmlData.displayModel.child("sprite");
					for (var i:Number = 0; i < sprites.length(); i++)
					{
						var spr:XML = sprites[i];
						
						// Check for library item
						var clase:Class = res.getAssetClass(spr.@src) as Class;
						
						// Check for shadow definition or use default
						try
						{
							var shadow:Class = res.getAssetClass(spr.@shadowsrc) as Class;
						}
						catch (e:Error)
						{
							shadow = clase;
						}
						this._sprites[this._sprites.length] = new fSpriteDefinition(parseInt(spr.@angle), clase, shadow);
					}
 					
					// Sort _sprites and add first one to the end of the list
					this._sprites.sortOn("angle", Array.NUMERIC);
					this._sprites[this._sprites.length] = this._sprites[0];
				}
			}
			else if (_objType == fEngineCValue.MdPicOne)	// 模型动作在一张贴图上    
			{
				
			}
			else if (_objType == fEngineCValue.MdEffPicOne)	// 特效在一个图上  
			{
				
			}
			else if (_objType == fEngineCValue.MdEffPicSeq)	// 特效图片序列  
			{
				//itemModel = this.xmlData.displayModel[0];
				//idx = parseInt(itemModel.@act);
				action = _dicAction[act];
				if (action.bInit)
				{
					return;
				}
				action.bInit = true;
				
				angle = 0;
				//directIdx = (angle / 360) * action.directArr.length;
				directIdx = (angle / 360) * this.yCount;
				actDirect = action.directDic[directIdx];
				
				// Check for library item
				while (cnt < action.xCount)
				{
					sprite = actDirect.spriteVec[cnt];
					sprite.sprite = res.getAssetClass(sprite.startName);
					if (!sprite.sprite)
					{
						// KBEN: 输出日志  
						Logger.error(null, null, "resource failed: " + sprite.startName);
					}
					
					++cnt;
				}
			}
			else
			{
				Logger.error(null, null, "fObjectDefinition: _objType" + _objType + "cannot read");
			}
		}
		
		// KBEN: (this.sprites[newSprite] as fSpriteDefinition).angle 这种方式的获取都改成这种方式，数组下标到角度的转换 angle="0" angle="45" angle="90" angle="135" angle="180" angle="225" angle="270" angle="315"       
		public function angle(idx:int):int
		{
			switch(idx)
			{
				case 0:
					return 0;
				case 1:
					return 45;
				case 2:
					return 90;
				case 3:
					return 135;
				case 4:
					return 180;
				case 5:
					return 225;
				case 6:
					return 270;
				case 7:
					return 315;
				default:
					return 0;
			}
		}
		
		// KBEN: 排序算法 
		public function sortFunc(item1:fActDirectDefinition, item2:fActDirectDefinition):Number
		{
			if (item1.angle < item2.angle)
			{
				return -1;
			}
			
			return 1;
		}
		
		// KBEN: 是否镜像图像 
		protected function isFlip(degree:uint):Boolean
		{
			if (degree == 180 ||
				degree == 225 ||
				degree == 270)
				{
					return true;
				}
			
			return false;
		}
		
		protected function conv2FlipDegree(degree:uint):uint
		{
			if (degree == 180)
			{
				return 90;
			}
			else if (degree == 225)
			{
				return 45;
			}
			else if (degree == 270)
			{
				return 0;
			}
			
			return 0;
		}
		
		// 从一个对象拷贝另外一个对象    
		public function copyFrom(rh:fObjectDefinition):void
		{
			var destspritedef:fSpriteDefinition;
			var srcspritedef:fSpriteDefinition;
			_sprites = new Array();
			for (var i:Number = 0; i < rh.sprites.length(); i++)
			{
				srcspritedef = rh._sprites[i];
				destspritedef = new fSpriteDefinition(srcspritedef.angle,  srcspritedef.sprite, srcspritedef.shadow);
				destspritedef.copyFrom(srcspritedef);
				this._sprites[this._sprites.length] = destspritedef
			}
			this._sprites.sortOn("angle", Array.NUMERIC);
			
			this.receiveLights = rh.receiveLights;
			//this.receiveShadows = rh.receiveShadows;
			//this.castShadows = rh.castShadows;
			//this.solid = rh.solid;
			
			this._objType = rh._objType;
			this._width = rh._width;
			this._height = rh._height;
			this._actionCnt = rh._actionCnt;
			
			this._yCount = rh._yCount;
			this._horizontalSpacing = rh._horizontalSpacing;
			this._verticalSpacing = rh._verticalSpacing;
			
			var srcaction:fActDefinition;
			var destaction:fActDefinition;
			var srcactDirect:fActDirectDefinition;
			var destactDirect:fActDirectDefinition;
			
			var key:String;
			for (key in rh._dicAction)
			{
				srcaction = this._dicAction[key];
				destaction = new fActDefinition();
				destaction.copyFrom(srcaction);
				this._dicAction[key] = destaction;
			}
			this._bInit = rh._bInit;
			this._overwrite = rh.overwrite;
		}
		
		public function overwriteAtt(rh:fObjectDefinition, ins:String):void
		{
			if (rh._objType)
			{
				this._objType = rh._objType;
			}
			if (rh._width)
			{
				this._width = rh._width;
			}
			if (rh._height)
			{
				this._height = rh._height;
			}
			if (rh._yCount)
			{
				this._yCount = rh._yCount;
			}
			if (rh.m_tagHeight)
			{
				this.m_tagHeight = rh.tagHeight;
			}
			
			//if(rh.m_version == 0)
			//{
			//	throw new Event("version error");
			//}
			
			var key:String;
			for (key in rh._dicAction)
			{
				//this._dicAction[key].overwriteAtt(rh._dicAction[key], ins, rh.m_version);
				if(rh._dicAction[key])	// 只有目标数据存在的时候才处理
				{
					this._dicAction[key].overwriteAtt(rh._dicAction[key], ins);
				}
			}
		}
		
		// 根据实力 ID 调整默认的属性     
		public function adjustAtt(insID:String):void
		{
			// 这些都不修改  
			// this._objType;
			// this._width;
			// this._height;
			var key:String;
			for (key in this._dicAction)
			{
				this._dicAction[key].adjustAtt(insID);
			}
		}
		
		public function getOrigin(act:int, dir:int):fPoint3d
		{
			var dirAction:fActDefinition = _dicAction[act];
			if (dirAction == null)
			{
				return null;
			}
			return dirAction.getOrigin(dir);
		}
		
		public function get layer():uint
		{
			return m_layer;
		}
		
		public function get effDir():uint
		{
			return m_effDir;
		}
		
		public function get bindType():uint
		{
			return m_bindType;
		}
		
		public function set bindType(value:uint):void
		{
			m_bindType = value;
		}
		
		public function get hurtMove():uint
		{
			return m_hurtMove;
		}
		
		public function set hurtMove(value:uint):void
		{
			m_hurtMove = value;
		}
		
		public function get bscale():uint
		{
			return m_scale;
		}
		
		public function set bscale(value:uint):void
		{
			m_scale = value;
		}
		
		public function get bscaleV():uint
		{
			return m_scaleV;
		}
		
		public function set bscaleV(value:uint):void
		{
			m_scaleV = value;
		}
	}
}