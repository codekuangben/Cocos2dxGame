package com.dgrigg.image 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.BitmapData;
	public class Image 
	{
		public static const MirrorMode_HOR:String = "_MirrorHOR";	//横向镜像
		public static const MirrorMode_VER:String = "_MirrorVer";	//纵向镜像
		public static const MirrorMode_ClockwiseRotation90:String = "_ClockwiseRotation90";	//图片顺时针旋转
		public static const MirrorMode_AnticlockwiseRotation90:String = "_AnticlockwiseRotation90";	//图片逆时针旋转
		public static const MirrorMode_LR:String = "_MirrorLeft";	//只提供左边部分，右边部分由左边部分镜像得到，然后左右合成一张图片
		public static const MirrorMode_LT:String = "_MirrorLeftTop";	//只提供左上部分，其它部分镜像得到，然后合成一张图片
		public static const MirrorMode_L_VER:String = MirrorMode_LR + MirrorMode_HOR;	//分2步：1.提供左边部分，右边由左边镜像得到，然后左右合成一张图片
																						//		 2.纵向镜像
		public static const MirrorMode_Top_TopBottom:String = "_MirrorMode_Top_TopBottom";	//只提供上边部分，最终的图的上边部分是原图，下部分是原图的垂直方向映射
		
		public static const None:int = 0;	//初始状态
		public static const Loading:int = 1;	//下载中
		public static const Loaded:int = 2;		//下载成功
		public static const Failed:int = 3;		//下载失败
		
		private var m_Name:String;
		private var m_useCount:uint;
		private var m_loadState:int;
		public function Image() 
		{
			m_useCount = 0;
		}
		
		public function parseSWF(res:SWFResource):Boolean
		{
			return false;
		}
		public function mirrorImage(mode:String):Image
		{
			return null;
		}
		public function set name(name:String):void
		{
			m_Name = name;
		}
		
		public function get name():String
		{
			return m_Name;
		}		
		public function increase():void
		{
			m_useCount++;
		}
		public function decrease():void
		{
			if (m_useCount > 0)
			{
				m_useCount--;
			}
		}
		public function get useCount():uint
		{
			return m_useCount;
		}
		public function get loaded():Boolean
		{
			return loadState == Loaded;
		}
		public function set loadState(state:int):void
		{
			m_loadState = state;
		}
		public function get loadState():int
		{
			return m_loadState;
		}
		public function parseBitmapData(data:BitmapData):void
		{
			
		}
	}

}