#pragma once
#ifndef __MStopPoint_H__
#define __MStopPoint_H__

/**
* KBEN: 阻挡点信息
*/
class MStopPoint
{
public:
	MStopPoint();
	~MStopPoint();

	protected var m_xmlObj : XML;	// 阻挡点的 XML 描述 
	protected var m_type : int;		// 阻挡点类型     
	protected var m_isStop : Boolean;	// 是否是阻挡点，主要是为了统一流程才加这个变量，只有这个变量是 true 的时候，里面的其它内容才是有效的，否则是无效的
};

#endif