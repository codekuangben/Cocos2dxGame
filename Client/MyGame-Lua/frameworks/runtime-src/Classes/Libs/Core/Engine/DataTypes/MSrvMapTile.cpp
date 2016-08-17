#include "MSrvMapTile.h"

MSrvMapTile::MSrvMapTile()
{

}

MSrvMapTile::~MSrvMapTile()
{

}

public function parseByteArray(bytes:ByteArray):void
{
	flags = bytes.readUnsignedByte();
	type = bytes.readUnsignedByte();
}

//struct stSrvMapTile
//{
//	BYTE  flags;  // 格子属性
//	BYTE  type;  // 格子类型
//};