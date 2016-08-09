package modulecommon.scene.beings
{
	import modulecommon.scene.beings.FallObjectEntity;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 * @brief 掉落物数据   
	 */
	public class FObjectScene 
	{
		public var m_FObjectList:Vector.<FallObjectEntity>;	// 掉落物管理器，方便遍历              
		public var m_tmpid2FObjectDic:Dictionary;	// tmpid 到 FallObjectEntity 的映射，方便进行查找，这个服务器 tmpid 映射   
		
		public function FObjectScene() 
		{
			m_FObjectList = new Vector.<FallObjectEntity>();
			m_tmpid2FObjectDic = new Dictionary();
		}
	}
}