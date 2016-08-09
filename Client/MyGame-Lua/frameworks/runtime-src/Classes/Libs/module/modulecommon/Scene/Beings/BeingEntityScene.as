package modulecommon.scene.beings
{
	import flash.utils.Dictionary;
	import com.pblabs.engine.entity.BeingEntity;
	/**
	 * ...
	 * @author 
	 * @brief 表示一个场中的玩家数据   
	 */
	public class BeingEntityScene 
	{
		public var m_beingList:Vector.<BeingEntity>;	// 生物管理器，方便遍历   
		public var m_tmpid2BeingDic:Dictionary;	// tmpid 到 being 的映射，方便进行查找，这个服务器 tmpid 映射   
		
		public function BeingEntityScene() 
		{
			m_beingList = new Vector.<BeingEntity>();
			m_tmpid2BeingDic = new Dictionary();
		}
	}
}