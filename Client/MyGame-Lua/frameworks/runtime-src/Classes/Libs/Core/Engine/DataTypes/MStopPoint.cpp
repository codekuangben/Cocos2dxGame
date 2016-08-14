#include "MStopPoint.h"

MStopPoint::MStopPoint()
{

}

MStopPoint::~MStopPoint()
{

}

public function stopPoint(defObj:XML, scene:fScene)
{
	m_type = parseInt(defObj.@type);	// defObj.@type 这个数值要和 EntityCValue.STTLand 中一致    
	m_isStop = true;
}
		
public function get isStop():Boolean 
{
	return m_isStop;
}
		
public function set isStop(value:Boolean):void 
{
	m_isStop = value;
}