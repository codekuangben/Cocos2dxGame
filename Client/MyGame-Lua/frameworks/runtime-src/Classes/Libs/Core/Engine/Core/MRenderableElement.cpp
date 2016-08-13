// Constructor
/** @private */
function fRenderableElement(defObj:XML, con:Context, noDepthSort:Boolean = false):void
{
	// Previous
	super(defObj, con);
			
	// Lights enabled ?
	//var temp:XMLList = defObj.@receiveLights;
	//if (temp.length() == 1)
	//	this.receiveLights = (temp.toString() == "true");
			
	// Shadows enabled ?
	//temp = defObj.@receiveShadows;
	//if (temp.length() == 1)
	//	this.receiveShadows = (temp.toString() == "true");
			
	// Projects shadow ?
	//temp = defObj.@castShadows;
	//if (temp.length() == 1)
	//	this.castShadows = (temp.toString() == "true");
			
	// Solid ?
	//temp = defObj.@solid;
	//if (temp.length() == 1)
	//	this.solid = (temp.toString() == "true");
				
	// KBEN: 关闭所有灯光影响    
	this.receiveLights = false;
			
	// Screen area
	this.screenArea = this.bounds2d.clone();
	this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
	_resDic = new Dictionary();
}
		
/**
	* Mouse management
	*/
public function disableMouseEvents():void
{
	dispatchEvent(new Event(fRenderableElement.DISABLE));
}
		
/**
	* Mouse management
	*/
public function enableMouseEvents():void
{
	dispatchEvent(new Event(fRenderableElement.ENABLE));
}
		
/**
	* Makes element visible
	*/
public function show():void
{
	if (!this._visible)
	{
		this._visible = true
		dispatchEvent(new Event(fRenderableElement.SHOW))
	}
}
		
/**
	* Makes element invisible
	*/
public function hide():void
{
	if (this._visible)
	{
		this._visible = false;
		dispatchEvent(new Event(fRenderableElement.HIDE));
	}
}
		
/**
	* Passes the stardard gotoAndPlay command to the base clip of this element
	*
	* @param where A frame number or frame label
	*/
public function gotoAndPlay(where:*):void
{
	if (this.flashClip)
		this.flashClip.gotoAndPlay(where);
	else
	{
		this.pendingDestiny = where;
		this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
		this.addEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
	}
}
		
private function delayedGotoAndPlay(e:Event):void
{
	this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
	if (this.flashClip && this.pendingDestiny)
		this.flashClip.gotoAndPlay(this.pendingDestiny);
}
		
/**
	* Passes the stardard gotoAndStop command to the base clip of this element
	*
	* @param where A frame number or frame label
	*/
public function gotoAndStop(where:*):void
{
	if (this.flashClip)
		this.flashClip.gotoAndStop(where);
	else
	{
		this.pendingDestiny = where;
		this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
		this.addEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
	}
}
		
private function delayedGotoAndStop(e:Event):void
{
	this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
	if (this.flashClip && this.pendingDestiny)
		this.flashClip.gotoAndStop(this.pendingDestiny);
}
		
/**
	* Calls a function of the base clip
	*
	* @param what Name of the function to call
	*
	* @param param An optional extra parameter to pass to the function
	*/
public function call(what:String, param:* = null):void
{
	if (this.flashClip)
		this.flashClip[what](param);
}
		
// Depth management
// dispatchmsg:Boolean = true 是否分发消息
/** @private */
public final function setDepth(d:Number, dispatchmsg:Boolean = true):void
{
	this._depth = d;
			
	// Reorder all objects
	if(dispatchmsg)
	{
		this.dispatchEvent(new Event(fRenderableElement.DEPTHCHANGE));
	}
}
		
/**
	* Return the 2D distance from this element to any world coordinate
	*/
public function distance2d(x:Number, y:Number, z:Number):Number
{
	var p2d:Point = fScene.translateCoords(x, y, z);
	return this.distance2dScreen(p2d.x, p2d.y);
}
		
/**
	* Return the 2D distance from this element to any screen coordinate
	*/
public function distance2dScreen(x:Number, y:Number):Number
{
	// Characters move. Update their screen Area
	if (this is fMovingElement)
	{
		this.screenArea = this.bounds2d.clone();
		this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
	}
			
	// Test bounds
	var bounds:Rectangle = this.screenArea;
	var pos2D:Point = new Point(x, y);
	var dist:Number = Infinity;
	if (bounds.contains(pos2D.x, pos2D.y))
		return 0;
			
	var corner1:Point = new Point(bounds.left, bounds.top);
	var corner2:Point = new Point(bounds.left, bounds.bottom);
	var corner3:Point = new Point(bounds.right, bounds.bottom);
	var corner4:Point = new Point(bounds.right, bounds.top);
			
	var d:Number = mathUtils.distancePointToSegment(corner1, corner2, pos2D);
	if (d < dist)
		dist = d;
	d = mathUtils.distancePointToSegment(corner2, corner3, pos2D);
	if (d < dist)
		dist = d;
	d = mathUtils.distancePointToSegment(corner3, corner4, pos2D);
	if (d < dist)
		dist = d;
	d = mathUtils.distancePointToSegment(corner4, corner1, pos2D);
	if (d < dist)
		dist = d;
			
	return dist;
}
		
/** @private */
public function disposeRenderable():void
{
	this.flashClip = null;
	this.container = null;			
}
		
/** @private */
public override function dispose():void
{
	m_bDisposed = true;
	super.dispose();
	this.disposeRenderable();
}
		
public function loadRes(act:uint, direction:uint):void
{
			
}
		
public function loadObjDefRes():void
{
			
}
		
// KBEN: 渲染显示会回调这个函数     
public function showRender():void
{
			
}
		
// KBEN: 渲染隐藏会回调这个函数     
public function hideRender():void
{
			
}	
		
// 判断某个资源的动作是否加载 
public function actLoaded(act:uint, direction:uint):Boolean
{
	// bug: 性能
	//return (this._resDic[act] && this._resDic[act][direction] && this._resDic[act][direction].isLoaded && !this._resDic[act][direction].didFail)
	// 分开写提高性能
	//var resact:Vector.<SWFResource>;
	var resact:Dictionary;
	resact = this._resDic[act];
	if (resact)
	{
		if (resact[direction])
		{
			if (resact[direction].isLoaded)
			{
				if (!resact[direction].didFail)
				{
					return true;
				}
			}
		}
	}
			
	return false;
}
		
public function actByRes(res:SWFResource):uint
{
	for (var key:String in _resDic)
	{
		if (_resDic[key] == res)
		{
			return parseInt(key);
		}
	}
			
	return 0;
}
		
public function get resDic():Dictionary 
{
	return _resDic;
}
		
public function onMouseEnter():void
{
			
}
public function onMouseLeave():void
{
			
}
		
// 这个主要用在有些 npc 需要放在的地物层，永远放在人物层下面，不排序
public function get layer():uint
{
	return 0;
}
		
public function set layer(value:uint):void
{
			
}
public function get isDisposed():Boolean
{
	return m_bDisposed;
}
		
// KBEN:
override public function onTick(deltaTime:Number):void
{
	// KBEN: 可视化判断，需要添加
	if (this._visible && this.isVisibleNow)
	{
		if (customData.flash9Renderer)
		{
			customData.flash9Renderer.onTick(deltaTime);
		}
	}
}
		
public function set needDepthSort(bNeed:Boolean):void
{
	m_needDepthSort = bNeed;
}