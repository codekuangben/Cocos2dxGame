#include "MElement.h"

unsigned int MElement::count = 0;

static const MOVE : String = "elementmove";
public static const NEWCELL : String = "elementnewcell";

MElement::MElement()
	: destx(0), desty(0), destz(0), 
	  offx(0), offy(0), offz(0), elasticity(0), 
	  _controller(nullptr)
{

}

MElement::~MElement()
{

}

MElement::MElement(XML defObj, Context con)
	:destx(0), desty(0), destz(0), 
	 offx(0), offy(0), offz(0), elasticity(0), 
	 _controller(nullptr)
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

void MElement::setController(MEngineElementController controller)
{
	if (this._controller != null)
		this._controller.disable();
	this._controller = controller;
	if (this._controller)
		this._controller.assignElement(this);
}

MEngineElementController MElement::getController()
{
	return this._controller;
}

void MElement::moveTo(float x, float y, float z)
{			
	// Set new coordinates			   
	this.x = x;
	this.y = y;
	this.z = z;			
}

void MElement::follow(MElement target, float elasticity)
{
	this.offx = target.x - this.x;
	this.offy = target.y - this.y;
	this.offz = target.z - this.z;
			
	this.elasticity = 1 + elasticity;
	// KBEN: 如果这个地方跟随者没有移动，moveListener 这个函数就不会被调用
	target.addEventListener(fElement.MOVE, this.moveListener, false, 0, true);
}

void MElement::stopFollowing(MElement target)
{
	target.removeEventListener(fElement.MOVE, this.moveListener);
}

void MElement::moveListener(MMoveEvent evt)
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

void MElement::followListener(Event evt)
{
	float dx = this.destx - this.x;
	float dy = this.desty - this.y;
	float dz = this.destz - this.z;
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

float MElement::distanceTo(float x, float y, float z)
{
	//return mathUtils.distance3d(x, y, z, this.x, this.y, this.z);
	return mathUtils.distance(x, y, this.x, this.y);
}

void MElement::disposeElement()
{
	this.xmlObj = nullptr;
	this.cell = nullptr;
	this._controller = nullptr;
	if (fEngine.stage)
		fEngine.stage.removeEventListener('enterFrame', this.followListener);
			
	// KBEN: 上层逻辑销毁自己的时候，不用了，上层直接重载 dispose  
	//dispatchEvent(new Event(fElement.DISPOSE));
	this.m_context = nullptr;
}

void MElement::dispose()
{
	this.customData.flash9Renderer = nullptr;
	this.disposeElement();
}

void MElement::onTick(float deltaTime)
{
			
}