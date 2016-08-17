#pragma once
#ifndef __MMapFileHeader_H__
#define __MMapFileHeader_H__

/**
* @brief 阻挡点文件头
* */
class MMapFileHeader
{
public:
	MMapFileHeader();
	~MMapFileHeader();

	public var ver : uint;
	public var width : uint;
	public var height : uint;
};

#endif