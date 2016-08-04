package modulefight.scene.beings
{
	import flash.display.BitmapData;
	//import flash.geom.Point;
	
	//import modulecommon.scene.prop.object.Package;

	/**
	 * @brief 人物的拖尾保存信息，直接绘制到贴图上，不再保存图片内容了
	 * */
	public class BeingTail
	{
		//public var m_defID:String = "";	// KBEN: 这个是模板定义 ID  
		//public var m_insID:String = "";	// KBEN: 这个是实例化 ID 
		public var m_posX:int = 0;			// 位置
		public var m_posY:int = 0;			// 位置
		public var m_offX:int = 0;			// 偏移信息
		public var m_offY:int = 0;			// 偏移信息
		public var m_image:BitmapData;		// 人物的显示数据
		public var m_alpha:Number = 0;			// 当前 alpha 值
	}
}