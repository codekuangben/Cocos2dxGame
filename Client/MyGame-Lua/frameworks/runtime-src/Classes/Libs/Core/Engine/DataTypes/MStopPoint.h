#pragma once
#ifndef __MStopPoint_H__
#define __MStopPoint_H__

/**
* KBEN: �赲����Ϣ
*/
class MStopPoint
{
public:
	MStopPoint();
	~MStopPoint();

	protected var m_xmlObj : XML;	// �赲��� XML ���� 
	protected var m_type : int;		// �赲������     
	protected var m_isStop : Boolean;	// �Ƿ����赲�㣬��Ҫ��Ϊ��ͳһ���̲ż����������ֻ����������� true ��ʱ��������������ݲ�����Ч�ģ���������Ч��
};

#endif