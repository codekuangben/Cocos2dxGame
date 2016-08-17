#include "MNewCellEvent.h"

MNewCellEvent::MNewCellEvent()
{

}

MNewCellEvent::~MNewCellEvent()
{

}

public function fNewCellEvent(type:String, bNotDepthSort:Boolean = true)
{
	super(type);	
	m_needDepthSort = bNotDepthSort;
}