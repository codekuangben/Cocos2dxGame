package com.dgrigg.utils 
{
	/**
	 * @brief UI风格     
	 */
	public class UIConst 
	{
	
		public static function Layer(ID:uint):int
		{
			return ID >> LAYER_BIT;
		}
		private static const LAYER_BIT:uint = 28;	//28~31位表示层		
		private static const INSTANCE_BIT:uint = 16;
		
		public static const FirstLayer:uint = 0;
		public static const SecondLayer:uint = 1;
		public static const MaxLayer:uint = 1;
		// 按钮状态改变   
		public static const EtBtnNormal:uint = 0;	// 鼠标没有按下移走
		public static const EtBtnDown:uint = 1;	// 鼠标按下  
		public static const EtBtnOver:uint = 2;	// 鼠标在按钮上面  
		public static const EtBtnSelected:uint = 3;	// 鼠标在按钮上面
		
		
		public static const UIProgLoading:uint = FirstLayer << LAYER_BIT | 0 << INSTANCE_BIT | 1;
		public static const UIHeroSelectNew:uint = FirstLayer << LAYER_BIT | 0 << INSTANCE_BIT | 2;
		public static const UIDebugLog:uint = SecondLayer << LAYER_BIT | 0 << INSTANCE_BIT | 2;		
		
	}
}