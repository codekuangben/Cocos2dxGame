#include "MMapFileHeader.h"

MMapFileHeader::MMapFileHeader()
{

}

MMapFileHeader::~MMapFileHeader()
{

}

public function parseByteArray(bytes:ByteArray):void
{
	ver = bytes.readUnsignedInt();
	width = bytes.readUnsignedInt();
	height = bytes.readUnsignedInt();
}

//struct stMapFileHeader
//{
//	DWORD ver;        /**< 版本 MAP_VERSION */
//	DWORD width;      /**< 宽度 */
//	DWORD height;      /**< 高度 */
//};