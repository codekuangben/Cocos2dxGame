package app.login.uiheroselect 
{
	import net.loginUserCmd.stLoginUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stLoadSelectCharacterUIOverCmd extends stLoginUserCmd 
	{
		
		public function stLoadSelectCharacterUIOverCmd() 
		{
			super();
			byParam = PARA_LOAD_SELECT_CHARACTER_UI_OVER_CMD;
		}
		
	}

}


//选择角色界面加载完成
   /* const BYTE PARA_LOAD_SELECT_CHARACTER_UI_OVER_CMD = 14; 
    struct stLoadSelectCharacterUIOverCmd : public stLogonUserCmd
    {   
        stLoadSelectCharacterUIOverCmd()
        {   
            byParam = PARA_LOAD_SELECT_CHARACTER_UI_OVER_CMD;
        }   
    }; */