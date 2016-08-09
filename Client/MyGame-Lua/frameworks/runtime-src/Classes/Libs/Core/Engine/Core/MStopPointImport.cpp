package org.ffilmation.engine.core
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.ffilmation.engine.datatypes.stMapFileHeader;
	import org.ffilmation.engine.datatypes.stSrvMapTile;
	import org.ffilmation.engine.datatypes.stopPoint;

	/**
	 * KBEN: 导入阻挡点
	 */
	public class fStopPointImport
	{
		public function fStopPointImport()
		{
			
		}
		
		// 导入阻挡点文件
		public function importStopPoint(bytes:ByteArray, scene:fScene):void
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			var hdr:stMapFileHeader = new stMapFileHeader();
			hdr.parseByteArray(bytes);
			
			var tile:stSrvMapTile = new stSrvMapTile();
			var stoppoint:stopPoint;
			var x:uint = 0;
			var y:uint = 0;
			
			y = 0;
			while(y < hdr.height)
			{
				x = 0;
				while(x < hdr.width)
				{
					tile.parseByteArray(bytes);
					
					if(tile.flags != 0)
					{
						var definitionObject:XML = <item x={x} y={y} type="1" />;
						stoppoint = new stopPoint(definitionObject, scene);
						scene.addStopPoint(x, y, stoppoint);
					}
					
					++x;
				}
				++y;
			}
		}
	}
}