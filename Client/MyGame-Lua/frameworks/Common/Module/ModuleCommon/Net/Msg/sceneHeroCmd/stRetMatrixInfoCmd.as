package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stRetMatrixInfoCmd extends stSceneHeroCmd 
	{
		public var wuScore:uint;
		public var zhanfaScore:int;
		public var grid:Vector.<uint>;
		public var jinnang:Vector.<uint>;
		public var zhenweiOpenFlag:uint;
		public function stRetMatrixInfoCmd() 
		{
			byParam = PARA_RET_MATRIX_INFO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			wuScore = byte.readUnsignedInt();
			zhanfaScore = byte.readUnsignedInt();
			
			grid = new Vector.<uint>(9);
			jinnang = new Vector.<uint>(4);
			
			var i:int;
			for (i = 0; i < 9; i++)
			{
				grid[i] = byte.readUnsignedInt();
			}
			
			for (i = 0; i < 4; i++)
			{
				jinnang[i] = byte.readUnsignedInt();
			}
			
			zhenweiOpenFlag = byte.readUnsignedShort();
		}
	}

}

/*
enum{
		SCORE_WUJIANG = 0,	//武将分
		SCORE_ZF,		//战法分
		SCORE_MAX,
	};
	//返回阵法信息
	const BYTE PARA_RET_MATRIX_INFO_USERCMD = 8;
	struct stRetMatrixInfoCmd : public stSceneHeroCmd
	{
		stRetMatrixInfoCmd()
		{
			byParam = PARA_RET_MATRIX_INFO_USERCMD;
		}
		DWORD score[SCORE_MAX];
		DWORD grid[9];	//阵法中武将id
		DWORD kits[4];	//锦囊id
		WORD  zhenwei;  //开放的阵为信息

	};
	*/
	