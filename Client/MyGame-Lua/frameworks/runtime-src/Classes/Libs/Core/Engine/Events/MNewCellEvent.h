#pragma once
#ifndef __MNewCellEvent_H__
#define __MNewCellEvent_H__

/**
* ...
* @author
* This event is dispatched whenever the fCell of an element changes.
*/
public class MNewCellEvent : public Event
{
public:
	MNewCellEvent();
	~MNewCellEvent();

	public var m_needDepthSort : Boolean;	//dispatch���¼�ʱ����Ҫ�������
};

#endif