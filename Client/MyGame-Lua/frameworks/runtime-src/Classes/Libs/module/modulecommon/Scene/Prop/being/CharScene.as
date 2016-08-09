package modulecommon.scene.prop.being
{
	import org.ffilmation.engine.datatypes.fPoint3d;
	/**
	 * ...
	 * @author 
	 * @brief 人物场景属性    
	 */
	public class CharScene 
	{		
		public var m_fogLast:fPoint3d;	// 上一次雾点  
		
		public function CharScene()
		{
			
			m_fogLast = new fPoint3d(0, 0, 0);
		}
	}
}