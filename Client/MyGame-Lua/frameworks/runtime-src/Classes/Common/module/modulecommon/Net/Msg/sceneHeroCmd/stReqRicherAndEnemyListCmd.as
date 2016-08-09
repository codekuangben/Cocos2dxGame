package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stReqRicherAndEnemyListCmd extends stSceneHeroCmd
	{
		public var m_baowuId:uint;
		public function stReqRicherAndEnemyListCmd() 
		{
			byParam = PARA_REQ_RICHER_AND_ENEMY_LIST_USERCMD;
			m_baowuId = 0;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_baowuId);
		}
	}

}
/*
	//请求财主宿敌列表
	const BYTE PARA_REQ_RICHER_AND_ENEMY_LIST_USERCMD = 25;
	struct stReqRicherAndEnemyListCmd : public stSceneHeroCmd
	{
		stReqRicherAndEnemyListCmd()
		{
			byParam = PARA_REQ_RICHER_AND_ENEMY_LIST_USERCMD;
			baowuid = 0;
		}
		DWORD baowuid;
	};
*/