package modulecommon.net.msg.sceneHeroCmd 
{
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stReqMatrixInfoCmd extends stSceneHeroCmd 
	{
		
		public function stReqMatrixInfoCmd() 
		{
			byParam = PARA_REQ_MATRIX_INFO_USERCMD;
		}
		
	}

}

/*
 * //请求阵法信息
	const BYTE PARA_REQ_MATRIX_INFO_USERCMD = 7;
	struct stReqMatrixInfoCmd : public stSceneHeroCmd
	{
		stReqMatrixInfoCmd()
		{
			byParam = PARA_REQ_MATRIX_INFO_USERCMD;
		}
	};
*/