package com.dgrigg.image
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.helpers.fUtil;
	import com.util.PBUtil;
	
	public class ImageAni extends Image
	{
		private var m_vecData:Vector.<BitmapData>;
		
		public function ImageAni()
		{
		
		}
		
		public function get frameCount():uint
		{
			if (m_vecData == null)
			{
				return 0;
			}
			return m_vecData.length;
		}
		
		public function getFrame(index:uint):BitmapData
		{
			return m_vecData[index];
		}
		
		override public function mirrorImage(mode:String):Image
		{
			var ret:ImageAni = new ImageAni();
			var i:int;
			var count:int = m_vecData.length;
			var execFun:Function;
			if (mode == MirrorMode_HOR)
			{
				execFun = PBUtil.flipBitmapDataHori;				
			}
			else if(mode == MirrorMode_VER)
			{
				execFun = PBUtil.flipBitmapDataVer;				
			}
			else if(mode == MirrorMode_ClockwiseRotation90)
			{
				execFun = PBUtil.flipBitmapDataClockwiseRotation90;				
			}
			else if(mode == MirrorMode_AnticlockwiseRotation90)
			{
				execFun = PBUtil.flipBitmapDataAnticlockwiseRotation90;				
			}		
		
			ret.m_vecData = new Vector.<BitmapData>(count);
			for (i = 0; i < count; i++)
			{				
				ret.m_vecData[i] = execFun(m_vecData[i]);
			}
			return ret;
		}
		
		override public function parseSWF(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			
			var classname:String;
			var data:BitmapData;
			namePackage = "art." + namePackage + ".m";
			m_vecData = new Vector.<BitmapData>();
			var k:int = 0;
			while (1)
			{
				classname = namePackage + k;
				data = (res.getExportedAsset(classname)) as BitmapData;
				if (data == null)
				{
					break;
				}
				m_vecData.push(data.clone());
				k++;
			}
			return true;
		}
	}

}