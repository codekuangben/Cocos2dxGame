#pragma once
#ifndef __MSrvMapTile_H__
#define __MSrvMapTile_H__

/**
* @brief ��ͼ�ļ��е��赲���¼
* */
class MSrvMapTile
{
public:
	MSrvMapTile();
	~MSrvMapTile();

	public var flags : uint;
	public var type : uint;
	public var m_x : uint;	// ��¼����λ��
	public var m_y : uint;	// ��¼����λ��
};

#endif