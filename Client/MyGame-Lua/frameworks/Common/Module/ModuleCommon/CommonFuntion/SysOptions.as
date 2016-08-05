package modulecommon.commonfuntion 
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.UtilCommon;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.stReqSetCommonSetUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetCommonSetUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class SysOptions 
	{		
		public static const COMMONSET_AUTOBUYKEY:int = 1;		// 自动购买-藏宝库
		//public static const COMMONSET_AUTOUSEKEY:int = 2;		// 自动使用包裹中的钥匙-藏宝库
		public static const COMMONSET_HEROFIRSTREBIRTH:int = 3; //武将首次转生
		public static const COMMONSET_REG:int = 4;				//今日是否已签到:为1 表示已经签到， 为0未签到
		public static const COMMONSET_SHOUCANG:int = 5; 		//收藏游戏地址
		
		//从第6位到第25位，客户端保留专用，服务器不需要理解其含义
		//COMMONSET_CLIENT_RESERVE_FIRST	=6//客户端保留专用的第一位
		//COMMONSET_CLIENT_RESERVE_LAST	=25//客户端保留专用的最后一位
		public static const COMMONSET_CLIENT_DebugBox:int = 6;	//在外网显示 DebugBox
		public static const COMMONSET_CLIENT_LDSSound:int = 7;	//游戏音乐(声音)播放  0-音乐开启(默认) 1-音乐关闭
		
		public static const COMMONSET_GET_GUANZHI:int = 26;		//领取官职俸禄
		public static const COMMONSET_NUM:int = 27;			// 总的数量
		
		public var m_gkContext:GkContext;
		private var m_sysOptions:Vector.<uint>;
		public function SysOptions(gk:GkContext)
		{
			m_gkContext = gk;
			var size:int = int((COMMONSET_NUM + UtilCommon.UNITSIZE - 1) / UtilCommon.UNITSIZE);
			m_sysOptions = new Vector.<uint>(size);
			set(COMMONSET_CLIENT_LDSSound);
		}
		
		public function isSet(id:int):Boolean
		{
			return UtilCommon.isSet(m_sysOptions, id);			
		}
		
		public function set(id:int):void
		{
			UtilCommon.setState(m_sysOptions, id);		
		}
		
		public function clear(id:int):void
		{
			UtilCommon.clearState(m_sysOptions, id);		
		}
		
		public function init(msg:ByteArray):void
		{
			var rev:stRetCommonSetUserCmd = new stRetCommonSetUserCmd();
			rev.deserialize(msg);
			var i:int = 0;
			for (; i < m_sysOptions.length; i++)
			{
				m_sysOptions[i] = msg.readUnsignedInt();
			}
			
			initSysOptionData();
		}
		
		public function changeState(msg:ByteArray):void
		{
			var rev:stReqSetCommonSetUserCmd = new stReqSetCommonSetUserCmd();
			rev.deserialize(msg);
			if (rev.m_bClear)
			{
				clear(rev.m_state);
			}
			else
			{
				set(rev.m_state);
			}
			
			updateSysOptionData(rev.m_state);
		}
		
		public function setAndSend(id:int):void
		{			
			set(id);
			
			var rev:stReqSetCommonSetUserCmd = new stReqSetCommonSetUserCmd();
			rev.m_state = id;
			rev.m_bClear = false;
			m_gkContext.sendMsg(rev);
		}
		public function clearAndSend(id:int):void
		{
			clear(id);
			
			var rev:stReqSetCommonSetUserCmd = new stReqSetCommonSetUserCmd();
			rev.m_state = id;
			rev.m_bClear = true;
			m_gkContext.sendMsg(rev);
		}
		
		private function initSysOptionData():void
		{
			//登陆游戏时，播放场景音乐
			if (!isSet(COMMONSET_CLIENT_LDSSound))
			{
				if (m_gkContext.m_mapInfo.m_sceneMusic.length)
				{
					m_gkContext.m_context.m_soundMgr.play(m_gkContext.m_mapInfo.m_sceneMusic, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
			}
			
			//每日是否签到数据更新
			updateSysOptionData(COMMONSET_REG);
			
			//官职名称
			updateSysOptionData(COMMONSET_GET_GUANZHI);
		}
		
		//更新系统通用设置相关数据
		public function updateSysOptionData(state:int):void
		{
			switch(state)
			{
				case COMMONSET_REG:
					m_gkContext.m_dailyActMgr.updateCommonsetReg();
					break;
				case COMMONSET_GET_GUANZHI:
					m_gkContext.m_arenaMgr.showGuanzhiName();
					break;
			}
			
		}
		
	}

}