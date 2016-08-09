// Object class
package org.ffilmation.engine.elements
{
	// Imports
	//import com.bit101.components.Panel;
	//import com.gskinner.motion.easing.Back;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import common.Context;
	
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.helpers.fActDefinition;
	import org.ffilmation.engine.helpers.fActDirOff;
	import org.ffilmation.engine.helpers.fActDirectDefinition;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.logicSolvers.collisionSolver.collisionModels.fEngineCollisionModel;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * <p>An Object is a graphic element that is part of the the environment and is not projected in any way.
	 * The library item is attached to the scene as is. Objects cast and receive shadows.</p>
	 *
	 * <p>Trees, statues and furniture are typical examples of objects.</p>
	 *
	 * <p>Objects can't be moved and can't be added/removed dynamically because this allows several rendering optimizations.
	 * If you want to move something or add/remove it on the fly use the "Character" class instead</p>
	 *
	 * <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT.<br>
	 * Objects are created when the scene is processed</p>
	 *
	 * @see org.ffilmation.engine.elements.fCharacter
	 */
	public class fObject extends fRenderableElement
	{
		// Constants
		
		/**
		 * Limits size of object shadow projection relative to X times the object's height (amount of stretching movieClips will suffer)
		 */
		public static const MAXSHADOW:int = 2;
		
		/**
		 * Shadows are harder or softer depending on the distance from the shadow origin to the plane where the shadow is drawn
		 * This constant defines the max distance in pixels at which a shadow will be seen. The shadow's alpha values will fade
		 * from 1 to 0 along this distance
		 */
		public static const SHADOWRANGE:int = 100;
		
		/**
		 * Shadows become bigger as they fade away. This is the scaling factor -1. 1 means the shadow doubles in size
		 */
		public static const SHADOWSCALE:Number = 0.7;
		
		// Private properties
		/** @private */
		// KBEN: 模板定义信息，内部数据最终会填写成实例化的数据使用  
		public var definition:fObjectDefinition;
		/** @private */
		//public var sprites:Array;
		/** @private */
		public var _orientation:Number;
		/** @private */
		//public var shadowRange:Number;
		private var _hasUpdateTagBounds2d:Boolean; //true 已经更新过m_tagBounds2d。角色建立后，只需更新m_tagBounds2d一次
		
		// Public properties
		
		/**
		 * The collision model for this object. A collision model is a matematical representation of an object's geometry
		 * that is used to manage collisions. For example, a box is a good collision model for a car, and a cilinder is a
		 * good collision model for people.<br>
		 * Collision models need to be simple geometry so the engine can solve collisions fast.
		 * @private
		 */
		public var collisionModel:fEngineCollisionModel;
		
		/**
		 * The definition ID for this fObject. It is useful for example when processing collision events, as it will allow
		 * you to know what kind of thing did you collide against.
		 */
		// KBEN: 这个是模板定义 ID  
		public var definitionID:String = "";
		// KBEN: 这个是实例化 ID 
		public var m_insID:String = "";
		
		/**
		 * This property provides a bit of rendering optimization.
		 * Non-Animated objects can be rendered faster if their cacheAsBitmap property is set to true.
		 * For animated objects this would slowdown performance as the cache would be redrawn continuously.
		 * Don't confuse "animated" ( a looping movieClip ) with "moveable".
		 * fObjects default to non-animated and fCharacters default to animated. You can use the <b>animated</b> attribute in your XMLs to change this
		 */
		public var animated:Boolean = false;
		
		// Events
		
		/**
		 * The fObject.NEWORIENTATION constant defines the value of the
		 * <code>type</code> property of the event object for a <code>objectNewOrientation</code> event.
		 * The event is dispatched when the object changes its orientation
		 *
		 * @eventType objectNewOrientation
		 */
		public static const NEWORIENTATION:String = "objectNewOrientation";
		
		/**
		 * The fObject.GOTOANDPLAY constant defines the value of the
		 * <code>type</code> property of the event object for a <code>objectGotoAndPlay</code> event.
		 * The event is dispatched when you execute a gotoAndPlay call in the object
		 *
		 * @eventType objectGotoAndPlay
		 */
		public static const GOTOANDPLAY:String = "objectGotoAndPlay";
		
		/**
		 * The fObject.GOTOANDSTOP constant defines the value of the
		 * <code>type</code> property of the event object for a <code>objectGotoAndStop</code> event.
		 * The event is dispatched when you execute a gotoAndPlay call in the object
		 *
		 * @eventType objectGotoAndStop
		 */
		public static const GOTOANDSTOP:String = "objectGotoAndStop";
		
		// KBEN: 记录当前的状态，默认待机状态    
		protected var m_state:uint = EntityCValue.TStand;
		// KBEN: 帧率，这个定义在 fObjectDefinition 这里面，然后自己保存，以方便更改 
		//protected var _framerateDic:Dictionary;
		//protected var _framerateInvDic:Dictionary;	// KBEN: 帧率倒数 
		protected var _leftInterval:Number = 0; // KBEN: 动画播放剩余的时间
		public var _totalTime:Number = 0; // KBEN: 动画播放的总的时间，插值计算帧
		
		//protected var _repeatDic:Dictionary;	// 动作是否重复播放  
		//protected var _frameInitDic:Dictionary;	// fFlash9ObjectSeqRenderer 中 _framesDic 有没有初始化   
		// 是否配置文件已经初始化 
		protected var m_binsXml:Boolean = false;
		// 所有的偏移都在这里
		public var m_ModelActDirOff:fActDirOff = null;
		// 特效使用来偏移中心，人物调整中心位置，这个只是某一个方向时候为了不使用中间变量使用的值
		protected var m_origLinkOff:Point;		// 这个保存的是最初的偏移，因为编辑器中会修改这个值，因此保存一份最初的
		protected var m_LinkOff:Point = null;
		protected var m_preAct:int = -1;		// 为了模型偏移只计算一次，前一次动作
		protected var m_preDir:int = -1;		// 为了模型偏移只计算一次，前一次方向
		protected var m_preFrame:int = -1;		// 前一次帧
		
		protected var m_MountserLinkOff:Point = null;		// 骑乘者偏移，可能没有，只有有些坐骑才需要每一帧都调整
		
		// KBEN: 是否接收全局光照的影响，主要是战斗中可能要变暗除战斗双方外其它的内容，地形肯定要变暗
		//public var m_affectByGI:Boolean = true;
		public var m_affectByGI:Boolean = false;	// 现在只有地形会变暗，其它的都不变，包括人物和特效
		
		// Constructor
		/** @private */
		function fObject(defObj:XML, con:Context):void
		{
			// Previous
			super(defObj, con);
			
			// Make sure this object has a definition in the scene. If it doesn't, throw an error
			//this.definitionID = defObj.@definition;
			var str:String = defObj.@definition;
			
			// this.definitionID 组成是这样子的， "aaa-bbb" : aaa 是模板的 ID ， bbb 是实例 ID 
			var delimit:int = defObj.@definition.indexOf("_");
			if (delimit != -1)
			{
				this.definitionID = str.substring(0, delimit);
				this.m_insID = str.substring(delimit + 1, str.length);
			}
			else
			{
				this.definitionID = defObj.@definition;
				this.m_insID = "";
				DebugBox.info("fObject:fObject()--模型定义文件名称格式错误" + defObj.@definition);
				//throw new Event("defObj.@definition error");
			}
			
			//this.definition = this.scene.resourceManager.getObjectDefinition(this.definitionID);
			// 现在自己保存一份拷贝，这样方便修改
			var srcdef:fObjectDefinition = this.m_context.m_sceneResMgr.getObjectDefinition(this.definitionID);
			
			//if (!this.definition)
			if (!srcdef)
			{
				DebugBox.info("The scene does not contain a valid object definition that matches definition id '" + this.definitionID + "'");
				//throw new Error("The scene does not contain a valid object definition that matches definition id '" + this.definitionID + "'");
			}
			
			this.definition = new fObjectDefinition(srcdef.xmlData, srcdef.basepath);
			
			// 属性的继承    
			//var insdef:fObjectDefinition = this.scene.resourceManager.getInsDefinition(this.m_insID);
			// 如果设置了重载属性，就重写    
			//if (insdef)
			//{
			//overwriteAtt(this.definition, insdef);
			//}
			//else	// 如果没有设置属性，就按照默认的规则进行处理    
			//{
			//adjustAtt(this.definition, m_insID);
			//}
			
			// Retrieve all sprites for this object
			// KBEN: 资源的初始化放到加载资源后面再初始化  
			//try
			//{
			//this.sprites = this.definition.sprites;
			//}
			//catch (e:Error)
			//{
			//throw new Error("Object definition '" + this.definitionID + "' contains an invalid display model or it can't be applied to object '" + this.id + "' " + e);
			//}
			
			// Initialize rotation for this object
			this._orientation = 0;
			
			// Is it animated ?
			if (defObj.@animated.length() == 1)
				this.animated = (defObj.@animated.toString() == "true");
			
			// Definition Lights enabled ?
			//if (defObj.@receiveLights.length() != 1)
			//	this.receiveLights = this.definition.receiveLights;
			
			// Definition Shadows enabled ?
			//if (defObj.@receiveShadows.length() != 1)
			//	this.receiveShadows = this.definition.receiveShadows;
			
			// Definition Projects shadow ?
			//if (defObj.@castShadows.length() != 1)
			//	this.castShadows = this.definition.castShadows;
			
			// Definition Solid ?
			//if (defObj.@solid.length() != 1)
			//	this.solid = this.definition.solid;
			
			// Retrieve collision model
			try
			{
				this.collisionModel = this.definition.collisionModel;
			}
			catch (e:Error)
			{
				throw new Error("Object definition '" + this.definitionID + "' contains an invalid collision model or it can't be applied to object '" + this.id + "'");
			}
			
			// Define shadowRange
			//this.shadowRange = this.height * fObject.MAXSHADOW * fEngine.DEFORMATION;
			
			// Define bounds. I need to load the symbol from the library to know its size. I will be destroyed immediately
			this.top = this.z + this.height;
			this.x0 = this.x - this.radius;
			this.x1 = this.x + this.radius;
			this.y0 = this.y - this.radius;
			this.y1 = this.y + this.radius;
			
			// KBEN: 宽高需要自己从定义中指定 
			//var clase:Class = this.sprites[0].sprite as Class;
			//var tempSprite:MovieClip = objectPool.getInstanceOf(clase) as MovieClip;
			//var w:Number = tempSprite.width;
			//var h:Number = tempSprite.height;
			// 这些每一帧切换图片的时候都需要更新的，初始值设置为 0 就行了
			var w:Number = this.definition._width;
			var h:Number = this.definition._height;
			this.bounds2d = new Rectangle(-w / 2, -h, w, h);
			w = this.definition._width;
			h = this.definition.tagHeight;
			this.m_tagBounds2d = new Rectangle(-w / 2, -h, w, h);
			// KBEN: 宽高需要自己从定义中指定 
			//objectPool.returnInstance(tempSprite);
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			// Initial orientation
			if (defObj.@orientation.length() > 0)
				this.orientation = new Number(defObj.@orientation[0]);
			else
				this.orientation = 0;
			
			// KBEN: 初始化帧率  
			//_repeatDic = new Dictionary();
			//_framerateDic = new Dictionary();
			//_framerateInvDic = new Dictionary();
			
			//var key:String;
			//for (key in this.definition.dicAction)
			//{
			//_framerateDic[key] = this.definition.dicAction[key].framerate;
			//_framerateInvDic[key] = 1 / _framerateDic[key];
			
			//_repeatDic[key] = this.definition.dicAction[key].repeat;
			//}
			
			// 生成自己数组 
			//_frameInitDic = new Dictionary();
			//var dir:int = 0;
			
			//var action:fActDefinition;
			//for (key in definition.dicAction)
			//{
			//	//action = definition.dicAction[key];
			//	//_resDic[key] = new Vector.<SWFResource>(definition.yCount, true);
			//	//_frameInitDic[key] = new Vector.<Boolean>(definition.yCount, true);
			//	_resDic[key] = this.m_context.m_SObjectMgr.m_actDirResList;
			//	_frameInitDic[key] = this.m_context.m_SObjectMgr.m_frameInitList;
			//}
			
			//m_LinkOff = new Point();
			
			// 加载自己定义的内容 
			loadObjDefRes();
		}
		
		/** @private */
		public override function distanceTo(x:Number, y:Number, z:Number):Number
		{
			//var n1:Number = mathUtils.distance3d(x, y, z, this.x, this.y, this.z);
			//var n2:Number = mathUtils.distance3d(x, y, z, this.x, this.y, this.top);
			
			var n1:Number = mathUtils.distance(x, y, this.x, this.y);
			var n2:Number = mathUtils.distance(x, y, this.x, this.y);
			
			return (n1 < n2) ? n1 : n2;
		}
		
		/**
		 * The orientation (in degrees) of the object along the Z axis. That is, if the object was a man standing anywhere on our scene, this
		 * would be where was his nose pointing. The default value of 0 indicates it is "looking" towards the positive X axis.
		 *
		 * The Axis in the Filmation Engine go like this.
		 *
		 *	<listing version="3.0">
		 *		 positive Z
		 *		         |
		 *		         |      / positive X
		 *		         |    /
		 *		         |  /
		 *	   (0,0,0) X/
		 *		          \
		 *		            \
		 *		              \
		 *		                \ positive Y
		 * </listing>
		 *
		 * @param angle The angle, in degrees, when want to set
		 */
		public function set orientation(angle:Number):void
		{
			angle += 45;
			setOrientation(angle);
		}
		
		protected function setOrientation(angle:Number):void
		{
			var correctedAngle:Number = angle % 360;
			if (correctedAngle < 0)
				correctedAngle += 360;
			this._orientation = correctedAngle;
			correctedAngle /= 360;
			if (isNaN(correctedAngle))
				return;
			
			// Update collision model
			// KBEN: 方向直接改成y 
			// var newSprite:int = int(correctedAngle * this.sprites.length);
			//this.collisionModel.orientation = (this.sprites[newSprite] as fSpriteDefinition).angle;
			var newSprite:int = int(correctedAngle * this.definition.yCount);
			this.collisionModel.orientation = this.definition.angle(newSprite);
			
			// Dispatch event so the render engine updates the screen
			this.dispatchEvent(new Event(fObject.NEWORIENTATION));
		}
		
		public function get orientation():Number
		{
			return this._orientation;
		}
		
		/**
		 * The height in pixels of an imaginary cilinder enclosing the object. It is used only for colision detection. You can change it anytime
		 * This is useful for example if a character has rolling or crawling movements and you want to change its collision height during those
		 * movements.
		 */
		public function set height(h:Number):void
		{
			this.collisionModel.height = h;
			this.top = this.z + h;
		}
		
		public function get height():Number
		{
			return this.collisionModel.height;
		}
		
		/**
		 * The radius in pixels of an imaginary cilinder enclosing the object. It is used only for colision detection.
		 */
		public function get radius():Number
		{
			return this.collisionModel.getRadius();
		}
		
		public function get state():uint
		{
			return m_state;
		}
		
		public function set state(value:uint):void
		{
			if (m_state == value)
			{
				return;
			}
			onStateChange(m_state, value);
			m_state = value;
			this.gotoAndPlay(state2StateStr(m_state));
		}
		
		public function onStateChange(oldState:uint, newState:uint):void
		{
			
		}
		
		public function get leftInterval():Number
		{
			return _leftInterval;
		}
		
		public function set leftInterval(value:Number):void
		{
			_leftInterval = value;
		}
		
		//public function get framerateInvDic():Dictionary 
		//{
		//return _framerateInvDic;
		//}
		
		//public function set framerateInvDic(value:Dictionary):void 
		//{
		//_framerateInvDic = value;
		//}
		
		//public function get repeatDic():Dictionary 
		//{
		//return _repeatDic;
		//_repeatDic[key] = this.definition.dicAction[key].repeat;
		//}
		
		//public function set repeatDic(value:Dictionary):void 
		//{
		//	_repeatDic = value;
		//}
		
		/**
		 * Passes the stardard gotoAndPLay command to the base clip
		 *
		 * @param where A frame number or frame label
		 */
		// KBEN: 这个就是切换状态的函数    
		public override function gotoAndPlay(where:*):void
		{
			// KBEN: MovieClip 资源的时候直接切换状态
			// bug: 性能
			//if (this.flashClip)
			//	this.flashClip.gotoAndPlay(where);
			
			// KBEN: 记录人物状态，现在是先设置人物状态，然后更新资源，然后播放动作，因此这里不需要再次设置这个状态了        
			//m_state = PBUtil.convStateStr2ID(where);
			// Dispatch event so the render engine updates the screen
			this.dispatchEvent(new Event(fObject.GOTOANDPLAY));
		}
		
		/**
		 * Passes the stardard gotoAndStop command to the base clip
		 *
		 * @param where A frame number or frame label
		 */
		// KBEN: 这个也是切换状态，有点多余，切换到站立状态的时候就是这个函数   
		public override function gotoAndStop(where:*):void
		{
			if (this.flashClip)
				this.flashClip.gotoAndStop(where);
			
			// KBEN: 记录人物状态 
			m_state = convStateStr2ID(where);
			// Dispatch event so the render engine updates the screen
			this.dispatchEvent(new Event(fObject.GOTOANDSTOP));
		}
		
		/**
		 * Calls a function of the base clip
		 *
		 * @param what Name of the function to call
		 *
		 * @param param An optional extra parameter to pass to the function
		 */
		public override function call(what:String, param:* = null):void
		{
			if (this.flashClip)
				this.flashClip[what](param);
		}
		
		/**
		 * Objects can't be moved
		 * @private
		 */
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			throw new Error("Filmation Engine Exception: You can't move a fObject. If you want to move " + this.id + " make it an fCharacter");
		}
		
		/** @private */
		public function disposeObject():void
		{
			// KBEN: 移除，否则会宕机
			// bug: 这个地方会遍历 7 * 8 这么多次数
			var dir:String;
			for (var key:String in _resDic)
			{
				//dir = 0;
				//while (dir < this.definition.yCount)
				for(dir in _resDic[key])
				{
					if (_resDic[key][dir])
					{
						_resDic[key][dir].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
						_resDic[key][dir].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
						
						//_resDic[key][dir].decrementReferenceCount();
						//this.m_context.m_resMgrNoProg.unload(_resDic[key][dir].filename, SWFResource);
						if (this.m_context.m_resMgr.getResource(_resDic[key][dir].filename, SWFResource))
						{
							this.m_context.m_resMgr.unload(_resDic[key][dir].filename, SWFResource);
						}
						_resDic[key][dir] = null;
					}
					
					//++dir;
				}
				
				_resDic[key] = null;
				// bug: 不要一边遍历一边删除    
				//delete _resDic[key];
			}
			_resDic = null;
			
			// 释放加载的定义文件，否则特效释放后资源才加载进来，就会宕机   
			if (this.m_ObjDefRes)
			{
				this.m_ObjDefRes.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
				this.m_ObjDefRes.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
				//this.m_context.m_resMgrNoProg.unload(this.m_ObjDefRes.filename, SWFResource);
				this.m_context.m_resMgr.unload(this.m_ObjDefRes.filename, SWFResource);
				this.m_ObjDefRes = null;
			}
			
			this.definition = null;
			//this.sprites = null;
			this.collisionModel = null;
			
			//this.disposeRenderable();
		}
		
		/** @private */
		public override function dispose():void
		{
			this.disposeObject();
			super.dispose();
		}
		
		public function state2StateStr(state:uint):String
		{
			switch (state)
			{
				case EntityCValue.TStand: 
					return EntityCValue.TSStand;
				case EntityCValue.TRun: 
					return EntityCValue.TSRun;
				case EntityCValue.TJump: 
					return EntityCValue.TSJump;
				case EntityCValue.TAttack: 
					return EntityCValue.TSAttack;
				case EntityCValue.THurt: 
					return EntityCValue.TSHurt;
				case EntityCValue.TDie: 
					return EntityCValue.TSDie;
				case EntityCValue.TDaZuo: 
					return EntityCValue.TSDaZuo;
				default: 
					return EntityCValue.TSStand;
			}
		}
		
		public function getAction():uint
		{
			switch (m_state)
			{
				case EntityCValue.TStand: 
					return EntityCValue.TActStand;
				case EntityCValue.TRun: 
					return EntityCValue.TActRun;
				case EntityCValue.TJump: 
					return EntityCValue.TActJump;
				case EntityCValue.TAttack: 
					return EntityCValue.TActAttack;
				case EntityCValue.THurt: 
					return EntityCValue.TActHurt;
				case EntityCValue.TDie: 
					return EntityCValue.TActDie;
				case EntityCValue.TDaZuo: 
					return EntityCValue.TActDaZuo;
				default: 
					return EntityCValue.TActStand;
			}
		}
		
		// KBEN:转换状态字符串到对应的状态数字   
		public static function convStateStr2ID(str:String):uint
		{
			if (EntityCValue.TSStand == str)
			{
				return EntityCValue.TStand;
			}
			else if (EntityCValue.TSRun == str)
			{
				return EntityCValue.TRun;
			}
			else if (EntityCValue.TSJump == str)
			{
				return EntityCValue.TJump;
			}
			else if (EntityCValue.TSAttack == str)
			{
				return EntityCValue.TAttack;
			}
			else if (EntityCValue.TSHurt == str)
			{
				return EntityCValue.THurt;
			}
			else if (EntityCValue.TSDie == str)
			{
				return EntityCValue.TDie;
			}
			else if (EntityCValue.TSDaZuo == str)
			{
				return EntityCValue.TDaZuo;
			}
			
			return EntityCValue.TStand;
		}
		
		// KBEN: 主要用来加载图片资源   
		override public function loadRes(act:uint, direction:uint):void
		{
			// bug: 如果一个 fObject 正在加载配置文件,在没有加载完成的时候如果在此调用这个函数,就会导致资源的引用计数增加,但是监听器只有一个,导致资源卸载不了
			if(this._resDic[act] && this._resDic[act][direction])	// 说明资源正在加载,但是没有加载完成,如果在此加载只能增加引用计数,但是监听器没有增加
			{
				return;
			}

			// KBEN: 这个就是图片加载，配置文件需要兼容两者，渲染文件单独写就行了      
			// 图片需要自己手工创建资源，启动解析配置文件的时候不再加载
			// 注意 load 中如果直接调用 onResLoaded ，可能这个时候 _resDic 中对应 key 的内容还没有放到 _resDic 中 
			var path:String;
			//if (this.definition.dicAction[act].resPack)
			//{
			//	path = this.m_context.m_path.getPathByName(this.definition.dicAction[act].mediaPath, m_resType);
			//}
			//else
			//{
				// 有时候如果没有资源这个值就是 null
				if (this.definition.dicAction[act].directDic[direction].mediaPath)
				{
					path = this.m_context.m_path.getPathByName(this.definition.dicAction[act].directDic[direction].mediaPath, m_resType);
				}
			//}
			
			// 路径存在才加载资源
			if (path)
			{
				//_resDic[act] ||= new Vector.<SWFResource>(8, true);
				_resDic[act] ||= new Dictionary();
				
				var mirrordir:uint = 0; // 映射的方向
				mirrordir = fUtil.getMirror(direction);
				
				//var res:SWFResource = this.m_context.m_resMgrNoProg.getResource(path, SWFResource) as SWFResource;
				var res:SWFResource = this.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource;
				if (!res)
				{
					//_resDic[act][direction] = this.m_context.m_resMgrNoProg.load(path, SWFResource, onResLoaded, onResFailed);
					_resDic[act][direction] = this.m_context.m_resMgr.load(path, SWFResource, onResLoaded, onResFailed);
					if (mirrordir != direction)
					{
						_resDic[act][mirrordir] = _resDic[act][direction];
						_resDic[act][mirrordir].incrementReferenceCount();		// 添加引用计数，释放的时候，这两个方向都会释放一次的
					}
				}
				else if (!res.isLoaded)
				{
					_resDic[act][direction] = res;
					res.incrementReferenceCount();
					res.addEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
					res.addEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
					
					if (mirrordir != direction)
					{
						_resDic[act][mirrordir] = _resDic[act][direction];
						_resDic[act][mirrordir].incrementReferenceCount();		// 添加引用计数，释放的时候，这两个方向都会释放一次的
					}
				}
				else if (!res.didFail) // bug: 加载成功才能设置 
				{
					_resDic[act][direction] = res;
					res.incrementReferenceCount();
					onResLoaded(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
					
					if (mirrordir != direction)
					{
						_resDic[act][mirrordir] = _resDic[act][direction];
						_resDic[act][mirrordir].incrementReferenceCount();		// 添加引用计数，释放的时候，这两个方向都会释放一次的
					}
				}
			}
		}
		
		// 资源加载成功     
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			//var act:uint = actByRes(event.resourceObject as SWFResource);
			var act:int = 0;
			var dir:int = 0;
			var mirrordir:uint = 0; // 映射的方向
			var curdir:uint = 0; // 模型当前方向
			// bug: 这个地方有问题，遍历检查资源
			/*
			// test: 这个地方循环遍历检查初始化，可能浪费时间
			for (var key:String in _resDic)
			{
			if (_resDic[key])
			{
			dir = 0;
			while (dir < definition.yCount)
			{
			if (_resDic[key][dir] == event.resourceObject)
			{
			act = parseInt(key);
			if (!_frameInitDic[act][dir])
			{
			_frameInitDic[act][dir] = true;
			//this.definition.init(_resDic[act], act);
			this.sprites = this.definition.sprites;
			var r:fFlash9ElementRenderer = customData.flash9Renderer;
			// bug : 可能渲染器被卸载了资源才被加载进来，结果就宕机了
			if (r != null)
			{
			r.init(_resDic[act][dir], act, dir);
			}
		
			Logger.info(null, null, _resDic[act][dir].filename + " loaded");
			}
			}
		
			++dir;
			}
			}
			}
			*/
			
			// 资源加载成功
			act = int(fUtil.getActByPath(event.resourceObject.filename));
			dir = int(fUtil.getDirByPath(event.resourceObject.filename));
			mirrordir = fUtil.getMirror(dir);
			// 确定最终的方向可能是镜像
			//if(!_resDic[act][dir])
			//{
			//	dir = mirrordir;
			//}
			// 也有可能是两个映射方向同时加载，这个时候优先初始化当前模型动作方向
			if (getAction() == act)
			{
				//if (!_frameInitDic[act] || !_frameInitDic[act][dir])
				//{
				//_frameInitDic[act] ||= new Vector.<Boolean>(8, true);	// 初始化动作 
				//_frameInitDic[act][dir] = true;
				
				//this.sprites = this.definition.sprites;
				var render:fFlash9ElementRenderer = customData.flash9Renderer;
				// bug : 可能渲染器被卸载了资源才被加载进来，结果就宕机了，原来是主角过场景的时候从场景移除，结果 flash9Renderer 就为空了，结果这个时候资源加载进来了 
				if (render)
				{
					curdir = render.actDir;
					if (curdir == dir || curdir == mirrordir)
					{
						dir = curdir;
						render.init(event.resourceObject as SWFResource, act, dir);
					}
				}
				//}
			}
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
		}
		
		// 资源加载失败    
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed");
			
			var act:int = 0;
			var dir:int = 0;
			var mirrordir:uint = 0; // 映射的方向
			
			/*
			for (var key:String in _resDic)
			{
			if (_resDic[key])
			{
			while (dir < definition.yCount)
			{
			if (_resDic[key][dir] == event.resourceObject)
			{
			// 删除资源，一定要减少引用计数
			var path:String = _resDic[act][dir].filename;
			//_resDic[act][dir].decrementReferenceCount();
			_resDic[act][dir] = null;
		
			this.m_context.m_resMgrNoProg.unload(path, SWFResource);
			}
		
			++dir;
			}
			}
			}
			*/
			
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
			
			//this.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			
			// 如果其他方向都没有
			//var idx:int = 0;
			//var dir:String = "";
			var hasRes:Boolean = false;
			//while (idx < _resDic[act].length)
			for(dir in _resDic[act])
			{
				if (_resDic[act][dir] != null)
				{
					hasRes = true;
					break;
				}
				//++idx;
			}
			
			if (!hasRes)
			{
				_resDic[act] = null;
				delete _resDic[act];
			}
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
				if (this.customData.flash9Renderer && (this.customData.flash9Renderer as fFlash9ElementRenderer).screenVisible)
				{
					this.loadRes(this.getAction(), (this.customData.flash9Renderer as fFlash9ElementRenderer).actDir);
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
		
		public function onObjDefResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			initObjDef();
			// 是不是初始化完成资源，就可以移除这个资源啊
			//this.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			this.m_ObjDefRes = null;
			
			// 如果可视，加载资源
			if (this.customData.flash9Renderer && (this.customData.flash9Renderer as fFlash9ElementRenderer).screenVisible)
			{
				this.loadRes(this.getAction(), (this.customData.flash9Renderer as fFlash9ElementRenderer).actDir);
			}
		}
		
		public function onObjDefResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed");
			
			this.m_ObjDefRes = null;
			//this.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
		}
		
		public function binitXmlDef():Boolean
		{
			//return (this.m_ObjDefRes != null) && this.m_ObjDefRes.isLoaded && !this.m_ObjDefRes.didFail;
			return m_binsXml;
		}
		
		//public function get frameInitDic():Dictionary 
		//{
		//	return _frameInitDic;
		//}
		
		// 将 from 中的属性覆盖到 to 中，实现重载的机制，只覆盖 from 中有的属性，如果 from 中没有属性就不覆盖，使用 to 中自己的属性         
		public function overwriteAtt(to:fObjectDefinition, from:fObjectDefinition):void
		{
			if (from.overwrite)
			{
				to.overwriteAtt(from, m_insID);
			}
			//else
			//{
			//	to.adjustAtt(m_insID);
			//}
		}
		
		// 调整默认的属性处理
		public function adjustAtt(objdef:fObjectDefinition, insID:String):void
		{
			objdef.adjustAtt(insID);
		}
		
		// 换全部的显示，不分各个部分外观 
		public function changeShow(def:String):void
		{
			// 重新设置动作方向，以便获取新模型的值
			m_preAct = -1;
			m_preDir = -1;
			m_ModelActDirOff = null;
			
			// 先把之前的属性清除 ，否则更改     
			//var dir:int = 0;
			var dir:String;
			var key:String
			//var action:fActDefinition;
			for (key in this.definition.dicAction)
			{
				//action = definition.dicAction[key];
				//dir = 0;
				if (key in _resDic)
				{
					//while (dir < _resDic[key].length)
					for (dir in _resDic[key])
					{
						if (_resDic[key][dir])
						{
							_resDic[key][dir].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
							_resDic[key][dir].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
							
							//this.m_context.m_resMgrNoProg.unload(_resDic[key][dir].filename, SWFResource);
							if (this.m_context.m_resMgr.getResource(_resDic[key][dir].filename, SWFResource))
							{
								this.m_context.m_resMgr.unload(_resDic[key][dir].filename, SWFResource);
							}
							_resDic[key][dir] = null;
						}
						
						//_frameInitDic[key][dir] = false;
						
						//++dir;
					}
				}
			}
			
			if (this.m_ObjDefRes)
			{
				this.m_ObjDefRes.removeEventListener(ResourceEvent.LOADED_EVENT, onObjDefResLoaded);
				this.m_ObjDefRes.removeEventListener(ResourceEvent.FAILED_EVENT, onObjDefResFailed);
				
				//this.m_context.m_resMgrNoProg.unload(this.m_ObjDefRes.filename, SWFResource);
				this.m_context.m_resMgr.unload(this.m_ObjDefRes.filename, SWFResource);
				this.m_ObjDefRes = null;
			}
			
			// 先把之前的属性清除 ，否则更改
			this.customData.flash9Renderer.disposeShow();
			
			var delimit:int = def.indexOf("_");
			var defID:String;
			var insID:String;
			if (delimit != -1)
			{
				defID = def.substring(0, delimit);
				insID = def.substring(delimit + 1, def.length);
			}
			else
			{
				throw new Event("changeShow error");
			}
			
			if (defID == this.definitionID && insID == this.m_insID)
			{
				return;
			}
			
			var srcdef:fObjectDefinition;
			// bug: 还是重新获取吧，否则如果修改了这个 define ，但是又重新替换回去，但是新的模型和 define 是一样的，结果就不能变换回原来的内容了   
			//if (defID != this.definitionID)
			{
				this.definitionID = defID;
				srcdef = this.m_context.m_sceneResMgr.getObjectDefinition(this.definitionID);
				
				if (!srcdef)
				{
					throw new Error("The scene does not contain a valid object definition that matches definition id '" + this.definitionID + "'");
				}
				
				this.definition = new fObjectDefinition(srcdef.xmlData, srcdef.basepath);
			}
			
			var insdef:fObjectDefinition;
			this.m_insID = insID;
			
			// 属性的继承    
			//insdef = this.m_context.m_sceneResMgr.getInsDefinition(this.m_insID);
			// 如果设置了重载属性
			//if (insdef)
			//{
			//overwriteAtt(this.definition, insdef);
			//}
			//else	// 如果没有设置属性，就按照默认的规则进行处理    
			//{
			//adjustAtt(this.definition, m_insID);
			//}
			
			// Define bounds. I need to load the symbol from the library to know its size. I will be destroyed immediately
			this.top = this.z + this.height;
			this.x0 = this.x - this.radius;
			this.x1 = this.x + this.radius;
			this.y0 = this.y - this.radius;
			this.y1 = this.y + this.radius;
			
			// KBEN: 宽高需要自己从定义中指定，这些每一帧都需要更新的就不用在这里设置了
			var w:Number = this.definition._width;
			var h:Number = this.definition._height;
			this.bounds2d = new Rectangle(-w / 2, -h, w, h);
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			//var key:String;
			//for (key in this.definition.dicAction)
			//{
			//_framerateDic[key] = this.definition.dicAction[key].framerate;
			//_framerateInvDic[key] = 1 / _framerateDic[key];
			
			//_repeatDic[key] = this.definition.dicAction[key].repeat;
			//}
			
			// 生成自己数组 
			//var dir:int = 0;
			//var action:fActDefinition;
			//for (key in this.definition.dicAction)
			//{
			//action = definition.dicAction[key];
			//dir = 0;
			//while (dir < _resDic[key].length)
			//{
			//if (_resDic[key][dir])
			//{
			//_resDic[key][dir].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			//_resDic[key][dir].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			//
			//this.m_context.m_resMgrNoProg.unload(_resDic[key][dir].filename, SWFResource);
			//_resDic[key][dir] = null;
			//}
			//
			//_frameInitDic[key][dir] = false;
			//
			//++dir;
			//}
			//}
			
			//this.customData.flash9Renderer.disposeShow();
			// 强制加载一次资源
			//this.loadRes(this.getAction(), this.customData.flash9Renderer.actDir);
			m_binsXml = false;
			loadObjDefRes();
		}
		
		// 这个函数调用后，对象定义才算初始化完毕，人物模型默认处理方式
		public function initObjDef():void
		{
			m_binsXml = true;
			
			var key:String;
			
			var insdef:fObjectDefinition = this.m_context.m_sceneResMgr.getInsDefinition(this.m_insID);
			if (!insdef && this.m_ObjDefRes)
			{
				var bytes:ByteArray;
				var clase:String = fUtil.xmlResClase(this.m_ObjDefRes.filename);
				bytes = this.m_ObjDefRes.getExportedAsset(clase) as ByteArray;
				
				var xml:XML;
				xml = new XML(bytes.readUTFBytes(bytes.length));
				
				// bug: 不再拷贝
				//insdef = new fObjectDefinition(xml.copy(), this.m_ObjDefRes.filename);
				insdef = new fObjectDefinition(xml, this.m_ObjDefRes.filename);
				xml = null;
				this.m_context.m_sceneResMgr.addInsDefinition(insdef);
				
				// 更改帧率
				var actfrate:Dictionary = this.m_context.modelFrameRate(fUtil.modelInsNum(this.m_insID));
				if (actfrate != null)
				{
					for (key in insdef.dicAction)
					{
						if (actfrate[key])
						{
							insdef.dicAction[key].framerate = actfrate[key];
						}
					}
				}
			}
			if (insdef)
			{
				// 重载属性     
				overwriteAtt(this.definition, insdef);
				// 调整名字   
				//adjustAtt(this.definition, m_insID);
			}
			
			//var w:Number = this.definition._width;
			//var h:Number = this.definition._height;
			//this.bounds2d.x = -w / 2;
			//this.bounds2d.y = -h;
			//this.bounds2d.width = w;
			//this.bounds2d.height = h;
			
			// Screen area
			//this.screenArea.x = -w / 2;
			//this.screenArea.y = -h;
			//this.screenArea.width = w;
			//this.screenArea.height = h;
			//this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			//var w:Number = this.definition.tagWidth;
			//var h:Number = this.definition.tagHeight;
			//this.m_tagBounds2d.x = -w / 2;
			//this.m_tagBounds2d.y = -h;
			//this.m_tagBounds2d.width = w;
			//this.m_tagBounds2d.height = h;
			
			// 初始化真正的数据结构，数据在这里又重新赋值
			//var action:fActDefinition;
			//for (key in this.definition.dicAction)
			//{
			//	action = definition.dicAction[key];
			//	_resDic[key] = new Vector.<SWFResource>(this.definition.yCount, true);
			//	_frameInitDic[key] = new Vector.<Boolean>(this.definition.yCount, true);
			//}
			
			updateFrameRate();
		}
		
		/*
		// 改变动作方向的时候更改相关的数据
		public function changeInfoByActDir(act:uint, dir:uint):void
		{
			var action:fActDefinition;
			var actdir:fActDirectDefinition;
			action = this.definition.dicAction[act]
			if (action)
			{
			actdir = action.directArr[dir];
			// 初始化一下方向信息
			if(actdir)
			{
			// 如果坐标原点没有偏移，就赋值默认值
			//if (actdir.origin.x == 0 && actdir.origin.y == 0)
			//{
			//actdir.origin.x = Math.abs(this.bounds2d.x);
			//actdir.origin.y = Math.abs(this.bounds2d.y);
			//}
			
			// KBEN: 默认是取中心点
			this.bounds2d.x = -actdir.origin.x;
			this.bounds2d.y = -actdir.origin.y;
			
			//this.bounds2d.width = action.width;
			//this.bounds2d.height = action.height;
			this.bounds2d.width = this.definition._width;
			this.bounds2d.height = this.definition._height;
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			// 中心点左边比较小
			if (2 * actdir.origin.x <= this.definition._width)
			{
			this.m_tagBounds2d.x = -actdir.origin.x;
			this.m_tagBounds2d.y = -this.definition.tagHeight;
			this.m_tagBounds2d.width = 2 * actdir.origin.x;
			}
			else
			{
			this.m_tagBounds2d.x = -(this.definition._width - actdir.origin.x);
			this.m_tagBounds2d.y = -this.definition.tagHeight;
			this.m_tagBounds2d.width = 2 * (this.definition._width - actdir.origin.x);
			}
			
			this.m_tagBounds2d.height = this.definition.tagHeight;
			}
			}
		}
		 */
		
		public function changeInfoByActDir(act:uint, dir:uint):void
		{
			var action:fActDefinition;
			var actdir:fActDirectDefinition;
			var curFrame:int;
			
			var render:fFlash9ElementRenderer = this.customData.flash9Renderer as fFlash9ElementRenderer;
			curFrame = render.currentFrame;
			
			if (m_preAct == act && m_preDir == dir && m_preFrame == curFrame)
			{
				return;
			}
			action = this.definition.dicAction[act];
			if (action)
			{
				//actdir = action.directArr[dir];
				actdir = action.directDic[dir];
				// 初始化一下方向信息    
				if (actdir)
				{
					// 如果坐标原点没有偏移，就赋值默认值  
					//if (actdir.origin.x == 0 && actdir.origin.y == 0)
					//{
					//actdir.origin.x = Math.abs(this.bounds2d.x);
					//actdir.origin.y = Math.abs(this.bounds2d.y);
					//}
					
					// KBEN: 默认是取中心点   
					//this.bounds2d.x = -actdir.origin.x;
					//this.bounds2d.y = -actdir.origin.y;
					
					// 人物获取中心点偏移
					//if (!m_LinkOff)
					//{
					//	var pt:Point = getTableModelOff(this.m_insID, act, dir);
					//	if (pt)
					//	{
					//		if (actdir.flipMode) // X 轴翻转
					//		{
					//			modeleffOff(-pt.x, pt.y);
					//		}
					//		else
					//		{
					//			modeleffOff(pt.x, pt.y);
					//		}
					//	}
					//	else
					//	{
					//		modeleffOff(0, 0);
					//	}
					//}
					
					if(m_preAct != act || m_preDir != dir)		// 只要动作或者方向有一个改变的就需要重新计算，现在由于有骑马，骑马的动作和其它动作分别单独使用一个偏移
					{
						updateModelOff(act, dir, 0, actdir.flipMode);
					}

					this.bounds2d.x = actdir.spriteVec[curFrame].origin.x + m_LinkOff.x;
					if (!canUpdataRide(subState, act))	// 如果不是骑乘状态
					{
						this.bounds2d.y = actdir.spriteVec[curFrame].origin.y + m_LinkOff.y;
					}
					else
					{
						updateMountserOff(act, dir, curFrame, actdir.flipMode);
						//if (!m_MountserLinkOff.x && !m_MountserLinkOff.y)		// 没有定义过这个骑乘者的偏移
						if(!m_context.m_SObjectMgr.m_hasOffInCurFrame)
						{
							this.bounds2d.y = actdir.spriteVec[curFrame].origin.y + m_LinkOff.y + curHorseData.definition.link1fHeight;
						}
						else
						{
							this.bounds2d.x = actdir.spriteVec[curFrame].origin.x + m_LinkOff.x + m_MountserLinkOff.x;
							this.bounds2d.y = actdir.spriteVec[curFrame].origin.y + m_LinkOff.y + m_MountserLinkOff.y;
						}
					}
					
					//this.bounds2d.width = action.width;
					//this.bounds2d.height = action.height;
					this.bounds2d.width = actdir.spriteVec[curFrame].picWidth;
					this.bounds2d.height = actdir.spriteVec[curFrame].picHeight;
					
					// Screen area
					this.screenArea = this.bounds2d.clone();
					this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
					
					if (_hasUpdateTagBounds2d == false)
					{
						var tagx:Number;
						var tagy:Number;
						var tagw:Number;
						var tagh:Number;
						
						// 中心点左边比较小 
						if (2 * Math.abs(actdir.spriteVec[curFrame].origin.x) <= this.bounds2d.width)
						{
							tagx = actdir.spriteVec[curFrame].origin.x;
							tagw = 2 * Math.abs(actdir.spriteVec[curFrame].origin.x);
						}
						else
						{
							tagx = -(this.bounds2d.width + actdir.spriteVec[curFrame].origin.x);
							tagw = 2 * (this.bounds2d.width + actdir.spriteVec[curFrame].origin.x);
						}
						
						if (this.definition.tagHeight == 0)
						{
							//this.definition.tagHeight = getTagHeight();
							this.definition.tagHeight = this.m_context.getTagHeight(fUtil.modelInsNum(this.m_insID));
						}
						tagy = this.definition.tagHeight;
						tagh = -this.definition.tagHeight;
						
						if (!canUpdataRide(subState, act))	// 如果不是骑乘状态
						{
							setTagBounds2d(tagx, tagy, tagw, tagh);
						}
						else
						{
							setTagBounds2d(tagx, tagy + curHorseData.definition.link1fHeight, tagw, tagh);
						}
						_hasUpdateTagBounds2d = true;
					}
				}
			}
			
			// 保存之前的数据
			m_preAct = act;
			m_preDir = dir;
			m_preFrame = curFrame;
		}
		
		public function setTagBounds2d(_x:Number, _y:Number, _w:Number, _h:Number):void
		{
			m_tagBounds2d.x = _x;
			m_tagBounds2d.y = _y;
			m_tagBounds2d.width = _w;
			m_tagBounds2d.height = _h;
			onSetTagBounds2d();
		}
		
		public function onSetTagBounds2d():void
		{
			
		}
		// 设置默认信息
		public function defaultPlaceInfo():void
		{
			var defaultset:Boolean = false; // 是否使用默认的设置
			var defaultWidth:uint = 50; // 默认宽度
			var defaultHeight:uint = 120; // 默认高度
			
			this.bounds2d.x = -int(defaultWidth / 2);
			this.bounds2d.y = -int(defaultHeight);
			
			this.bounds2d.width = int(defaultWidth);
			this.bounds2d.height = int(defaultHeight);
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			if (m_tagBounds2d.height == 1)
			{
				//如果不等于1，表示该值已经更新过了
				setTagBounds2d(this.bounds2d.x, this.bounds2d.y, this.bounds2d.width, this.bounds2d.y);
			}
			/*
			this.m_tagBounds2d.x = this.bounds2d.x;
			// bug 这个地方不能赋值，赋值就认为是已经调用 getTagHeight 获取了名字高度了
			//this.definition.tagHeight = this.bounds2d.height;
			this.m_tagBounds2d.y = this.bounds2d.y;
			this.m_tagBounds2d.width = this.bounds2d.width;
		
			this.m_tagBounds2d.height = this.m_tagBounds2d.y;
			*/
		}
		
		public function getOrigin(act:int, dir:int):fPoint3d
		{
			return definition.getOrigin(act, dir);
		}
		
		// 根据设置更新帧率    
		protected function updateFrameRate():void
		{
		
		}
		
		// 获取动作的帧数     
		public function getActFrameCnt(act:uint):uint
		{
			var action:fActDefinition;
			action = this.definition.dicAction[act];
			if (action)
			{
				return action.xCount;
			}
			
			return 1;
		}
		
		// 获取动作帧率     
		public function getActFrameRate(act:uint):uint
		{
			var action:fActDefinition;
			action = this.definition.dicAction[act];
			if (action)
			{
				return action.framerate;
			}
			
			return 1;
		}
		
		// 获取动作播放时间   
		public function getActLength(act:uint):Number
		{
			var action:fActDefinition;
			action = this.definition.dicAction[act];
			if (action)
			{
				return action.xCount / action.framerate;
			}
			
			return 1;
		}
		
		// 返回头顶名字应该距离重心点的偏移
		public function getTagHeight():int
		{
			//return this.m_context.getTagHeight(fUtil.modelInsNum(this.m_insID));
			return -this.definition.tagHeight;
		}
		
		// 现在由于骑乘者所起的坐骑如果动作比较大，需要每一帧都去调整，因此需要获取某一帧的偏移，而大部分只需要获取第0帧的偏移
		public function getTableModelOff(beingid:String, act:uint, dir:uint, frame:uint = 0):Point
		{
			//return this.m_context.modelOff(fUtil.modelInsNum(beingid), act, dir);
			if(!m_ModelActDirOff)
			{
				m_ModelActDirOff = getTableModelOffAll(beingid, act, dir);
			}
			
			m_context.m_SObjectMgr.m_keyOff = this.m_context.m_SObjectMgr.m_actDir2Key[act][dir];
			
			if(m_context.m_SObjectMgr.m_keyOff && m_ModelActDirOff)
			{
				return m_ModelActDirOff.m_ModelOffDic[m_context.m_SObjectMgr.m_keyOff].m_offLst[frame];
			}
			
			return null;
		}
		
		// 从表中直接读取数据
		public function getTableModelOffAll(beingid:String, act:uint, dir:uint):fActDirOff
		{
			return this.m_context.modelOffAll(fUtil.modelInsNum(beingid));
		}
		
		// 从表中直接读取骑乘者偏移数据，这个记录在坐骑身上
		public function getMountserTableModelOffAll(beingid:String):fActDirOff
		{
			return this.m_context.modelMountserOffAll(fUtil.modelInsNum(beingid));
		}
		
		// 设置模型特效的偏移
		public function modeleffOff(xoff:Number, yoff:Number):void
		{
			// 如果 m_LinkOff 已经有了，说明已经初始化了，就不用再初始化了 
			m_LinkOff ||= new Point();
			m_LinkOff.x = xoff;
			m_LinkOff.y = yoff;
		}
		
		public function get LinkOff():Point
		{
			m_LinkOff ||= new Point();
			return m_LinkOff;
		}
		
		public function get subState():uint
		{
			return EntityCValue.STNone;
		}
		
		public function set subState(value:uint):void
		{
			
		}
		
		// 特效是否需要翻转
		public function get bFlip():uint
		{
			return 0;
		}
		
		// 获取特效的类型
		public function get type():int
		{
			return 0;
		}
		
		public function get angle():Number
		{
			return 0;
		}
		
		// 特效使用控制缩放后的宽度和高度
		public function get scaleHeight2Orig():int
		{
			return 0;
		}
		
		public function get scaleWidth2Left():int
		{
			return 0;
		}
		
		public function get scaleHeight2Top():uint
		{
			return 0;
		}
		
		public function get scaleWidth2Orig():uint
		{
			return 0;
		}
		
		// 当前是否有马匹在骑乘
		public function get curHorseData():fObject
		{
			return null;
		}
		
		// 当前是否有马匹在骑乘
		public function get curHorseRenderData():fFlash9ElementRenderer
		{
			return null;
		}
		
		// 能否更新骑马的资源
		public function canUpdataRide(substate:uint, act:uint):Boolean
		{
			if (substate == EntityCValue.TRide)	// 如果骑乘
			{
				if(act == EntityCValue.TActRideStand || act == EntityCValue.TActRideRun)
				{
					if (curHorseData)	// 当前的坐骑存在
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function get hasUpdateTagBounds2d():Boolean
		{
			return _hasUpdateTagBounds2d;
		}
		
		public function set hasUpdateTagBounds2d(value:Boolean):void
		{
			_hasUpdateTagBounds2d = value;
		}
		
		public function get horseHost():fObject
		{
			return null;
		}
		
		public function isEqualAndGetDirMount2PlayerActDir(mountact:int, mountdir:int):int
		{
			return -1;
		}
		
		public function isEqualMount2PlayerActDir(mountact:int, mountdir:int):Boolean
		{
			return false;
		}
		
		// 这个是获取坐骑身上的
		public function get mountserActDirOff():fActDirOff
		{
			return null;
		}
		
		// 根据坐骑获取身上的骑乘的数据
		public function get mountserActDirOffFromMounts():fActDirOff
		{
			return curHorseData.mountserActDirOff;
		}
		
		protected function updateModelOff(act:uint, dir:uint, frame:uint, flipMode:Boolean):void
		{
			if (m_preAct != act)	// 如果动作更改了需要重新获取
			{
				m_origLinkOff = getTableModelOff(this.m_insID, act, dir);
			}
			if (!m_LinkOff)
			{
				m_LinkOff = new Point();
			}
			
			if(m_origLinkOff)
			{
				m_LinkOff.y = m_origLinkOff.y;
				if (flipMode) // X 轴翻转,方向修改了，需要根据是否翻转进行值的映射
				{
					m_LinkOff.x = -m_origLinkOff.x;
				}
				else
				{
					m_LinkOff.x = m_origLinkOff.x;
				}
			}
			else
			{
				m_LinkOff.x = 0;
				m_LinkOff.y = 0;
			}
		}
		
		// 更新骑乘者模型的改变
		protected function updateMountserOff(act:uint, dir:uint, frame:uint, flipMode:Boolean):void
		{
			if (!m_MountserLinkOff)
			{
				m_MountserLinkOff = new Point();
			}
			if (m_preFrame != frame)
			{
				m_context.m_SObjectMgr.m_tmpMountserActDirOff = this.mountserActDirOffFromMounts;		// 换一次就需要重新获取，因此每一帧都获取一次
				m_context.m_SObjectMgr.m_keyOff = this.m_context.m_SObjectMgr.m_mountserActDir2Key[act][dir];
				// 这个就比较复杂，如果没有配置，就直接获取坐骑的统一提升的高度
				if (!m_context.m_SObjectMgr.m_tmpMountserActDirOff || !m_context.m_SObjectMgr.m_tmpMountserActDirOff.m_ModelOffDic[m_context.m_SObjectMgr.m_keyOff])
				{
					m_context.m_SObjectMgr.m_hasOffInCurFrame = false;
					m_MountserLinkOff.x = 0;
					m_MountserLinkOff.y = 0;
				}
				else
				{
					m_context.m_SObjectMgr.m_hasOffInCurFrame = true;
					
					m_context.m_SObjectMgr.m_tmpModelOff = m_context.m_SObjectMgr.m_tmpMountserActDirOff.m_ModelOffDic[m_context.m_SObjectMgr.m_keyOff].m_offLst[frame];
					m_MountserLinkOff.y = m_context.m_SObjectMgr.m_tmpModelOff.y;
					if (!flipMode)
					{
						m_MountserLinkOff.x = m_context.m_SObjectMgr.m_tmpModelOff.x;
					}
					else
					{
						m_MountserLinkOff.x = -m_context.m_SObjectMgr.m_tmpModelOff.x;
					}
				}
			}
		}
		
		public function set preAct(value:int):void
		{
			m_preAct = value;
		}
		
		public function set preDir(value:int):void
		{
			m_preDir = value;
		}
		
		public function set preFrame(value:int):void
		{
			m_preFrame = value;
		}
		
		// 是否需要缩放
		public function hasScale():Boolean
		{
			return false;
		}
		
		public function get scaleFactor():Number
		{
			return 1;
		}
	}
}