#pragma once
#ifndef __MSrvMapTile_H__
#define __MSrvMapTile_H__

/**
* @brief 地图文件中的阻挡点记录
* */
class MSrvMapTile
{
public:
	MSrvMapTile();
	~MSrvMapTile();

	public var flags : uint;
	public var type : uint;
	public var m_x : uint;	// 记录格子位置
	public var m_y : uint;	// 记录格子位置
};

#endif