/*
	* Contructor for the fElement class.
	*
	* @param defObj: XML definition for this element. The XML attributes that will be parsed are ID,X,Y and Z
	*
	* @param scene: the scene where this element will be reated
	*/
function fElement(defObj:XML, con:Context):void
{
	// Id
	this.xmlObj = defObj;
	var temp:XMLList = defObj.@id;
			
	this.uniqueId = fElement.count++;
	if (temp.length() == 1)
		this.id = temp.toString();
	else
		this.id = "fElement_" + this.uniqueId;
			
	// Reference to container scene
	this.m_context = con;
			
	// Current cell position
	this.cell = null;
			
	// Basic coordinates
	this.x = new Number(defObj.@x[0]);
	this.y = new Number(defObj.@y[0]);
	this.z = new Number(defObj.@z[0]);
	if (isNaN(this.x))
		this.x = 0;
	if (isNaN(this.y))
		this.y = 0;
	if (isNaN(this.z))
		this.z = 0;
			
	this.customData = new Object();
}
		
/**
	* Assigns a controller to this element
	* @param controller: any controller class that implements the fEngineElementController interface
	*/
public function set controller(controller:fEngineElementController):void
{
	if (this._controller != null)
		this._controller.disable();
	this._controller = controller;
	if (this._controller)
		this._controller.assignElement(this);
}
		
/**
	* Retrieves controller from this element
	* @return controller: the class that is currently controlling the the fElement
	*/
public function get controller():fEngineElementController
{
	return this._controller;
}
		
/**
	* Moves the element to a given position
	*
	* @param x: New x coordinate
	*
	* @param y: New y coordinate
	*
	* @param z: New z coordinate
	*
	*/
public function moveTo(x:Number, y:Number, z:Number):void
{			
	// Set new coordinates			   
	this.x = x;
	this.y = y;
	this.z = z;			
}
		
/**
	* Makes element follow target element
	*
	* @param target: The filmation element to be followed
	*
	* @param elasticity: How strong is the element attached to what is following. 0 Means a solid bind. The bigger the number, the looser the bind.
	*
	*/
public function follow(target:fElement, elasticity:Number = 0):void
{
	this.offx = target.x - this.x;
	this.offy = target.y - this.y;
	this.offz = target.z - this.z;
			
	this.elasticity = 1 + elasticity;
	// KBEN: 如果这个地方跟随者没有移动，moveListener 这个函数就不会被调用
	target.addEventListener(fElement.MOVE, this.moveListener, false, 0, true);
}
		
/**
	* Stops element from following another element
	*
	* @param target: The filmation element to be followed
	*
	*/
public function stopFollowing(target:fElement):void
{
	target.removeEventListener(fElement.MOVE, this.moveListener);
}
		
// Listens for another element's movements
/** @private */
public function moveListener(evt:fMoveEvent):void
{
	if (this.elasticity == 1)
		this.moveTo(evt.target.x - this.offx, evt.target.y - this.offy, evt.target.z - this.offz);
	else
	{
		this.destx = evt.target.x - this.offx;
		this.desty = evt.target.y - this.offy;
		this.destz = evt.target.z - this.offz;
		fEngine.stage.addEventListener('enterFrame', this.followListener, false, 0, true);
	}
}
		
/** Tries to catch up with the followed element
	* @private
	*/
public function followListener(evt:Event):void
{
	var dx:Number = this.destx - this.x;
	var dy:Number = this.desty - this.y;
	var dz:Number = this.destz - this.z;
	try
	{
		this.moveTo(this.x + dx / this.elasticity, this.y + dy / this.elasticity, this.z + dz / this.elasticity);
	}
	catch (e:Error)
	{
	}
			
	// Stop ?
	if (dx < 1 && dx > -1 && dy < 1 && dy > -1 && dz < 1 && dz > -1)
	{
		fEngine.stage.removeEventListener('enterFrame', this.followListener);
	}
}
		
/**
	* Returns the distance of this element to the given coordinate
	*
	* @return distance
	*/
public function distanceTo(x:Number, y:Number, z:Number):Number
{
	//return mathUtils.distance3d(x, y, z, this.x, this.y, this.z);
	return mathUtils.distance(x, y, this.x, this.y);
}
		
// Clean resources
		
/** @private */
public function disposeElement():void
{
	this.xmlObj = null;
	this.cell = null;
	this._controller = null;
	if (fEngine.stage)
		fEngine.stage.removeEventListener('enterFrame', this.followListener);
			
	// KBEN: 上层逻辑销毁自己的时候，不用了，上层直接重载 dispose  
	//dispatchEvent(new Event(fElement.DISPOSE));
	this.m_context = null;
}
		
/** @private */
public function dispose():void
{
	this.customData.flash9Renderer = null;
	this.disposeElement();
}
		
// KBEN:
public function onTick(deltaTime:Number):void
{
			
}