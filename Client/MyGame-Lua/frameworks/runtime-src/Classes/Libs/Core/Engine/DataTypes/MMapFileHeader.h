#pragma once
#ifndef __MMapFileHeader_H__
#define __MMapFileHeader_H__

/**
* @brief �赲���ļ�ͷ
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