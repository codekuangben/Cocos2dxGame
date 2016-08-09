package common
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 * @brief 注册各种类型，方便底层调用上层的类型   
	 */
	public class TypeReg 
	{
		public var m_classes:Dictionary = new Dictionary();
		
		public function addClass(classID:uint, classObject:Class):void
		{
			m_classes[classID] = classObject;			
		}
		
		// bug: 战斗模块由于没有删除注册，导致这个模块卸载不了
		public function delClass(classID:uint):void
		{
			m_classes[classID] = null;
			delete m_classes[classID]; 
		}
	}
}