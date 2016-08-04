package modulecommon.scene.fight
{
	import com.util.DebugBox;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import modulecommon.GkContext;
	//import modulecommon.login.LoginData;
	import modulecommon.net.MessageBuffer;
	//import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TCommonBaseItem;
	import modulecommon.game.IMFight;
	
	/**
	 * ...
	 * @author
	 */
	public class BattleMgr
	{
		private var m_dicMapToMusic:Dictionary;
		private var m_gkContext:GkContext;
		
		private var m_ModuleFight:IMFight; //ModuleFightRoot
		public var m_bClientBattleSimulation:Boolean;
		
		private var m_msgsAfterBattle:MessageBuffer; //记录战斗后需要处理的消息
		// 战斗第几回合显示按钮，如果是 0 ，就按照正常的规则
		public var m_fastover:uint;
		
		public var m_InfoOutputTeam:int = -1;
		public var m_InfoOutputGridNO:int = -1;
		public var m_stopInfo:Boolean; //战斗动画停止播放方面的日志输出
		
		//private var m_battleList:Vector.<ByteArray>;
		//private var m_battleListFlag:int;
		public function BattleMgr(gk:GkContext, moduleFight:IMFight)
		{
			m_gkContext = gk;
			m_ModuleFight = moduleFight;
		}
		
		public function addBattle(byte:ByteArray):void
		{
			/*m_battleList.push(byte);
			   if (m_battleList.length > 40)
			   {
			   m_battleList.splice(0, 20);
			 }*/
			try
			{
				
				var name:String = m_gkContext.m_context.m_timeMgr.dataStringWithoutYear;
				var sharObject:SharedObject = SharedObject.getLocal(name);
				sharObject.data.battleData = byte;
			}
			catch (e:Error)
			{
				var str:String = "保存战斗出问题";
				m_gkContext.addLog(str);
			}
		
		}
		
		public function getBattle(name:String):ByteArray
		{
			var byte:ByteArray;
			var sharObject:SharedObject = SharedObject.getLocal(name);
			if (sharObject.data.battleData != undefined)
			{
				byte = sharObject.data.battleData;
				byte.endian = Endian.LITTLE_ENDIAN;
				return byte;
			}
			return null;
		}
		
		// 根据服务器的地图 id 获取地图的音乐. id:服务器的地图 id
		public function getBattleMapMusic(id:uint):String
		{
			if (m_dicMapToMusic == null)
			{
				m_dicMapToMusic = new Dictionary();
				
				// 解析地图音乐配置 id ,通用配置.xlsx 这个表中 id 1001,结构是这样的 mapid:musicname;mapid:musicname ,例如 9000:aaa;9001:bbb
				var item:TCommonBaseItem;
				var semiSplitArr:Array;
				var colonSplitArr:Array;
				//item = m_gkContext.m_dataTable.getItem(DataTable.TABLE_COMMON, 1001) as TCommonBaseItem;//暂时注释掉
				if (item)
				{
					semiSplitArr = item.m_value.split(";");
					var key:String;
					for (key in semiSplitArr)
					{
						colonSplitArr = semiSplitArr[key].split(":");
						if (colonSplitArr.length == 2)
						{
							m_dicMapToMusic[colonSplitArr[0]] = m_dicMapToMusic[1];
						}
					}
				}
			}
			
			// 查找具体音乐
			if (!(id in m_dicMapToMusic))
			{
				return "";
			}
			
			return m_dicMapToMusic[id] + ".mp3";
		}
		
		public function addMsgForBuffer(msg:ByteArray, cmd:int, param:int = 0):void
		{
			if (m_msgsAfterBattle == null)
			{
				m_msgsAfterBattle = new MessageBuffer();
				m_msgsAfterBattle.isInBufferState = true;
			}
			m_msgsAfterBattle.pushTwoParam(msg, cmd, param);
		}
		
		public function execMsgInBuffer():void
		{
			if (m_msgsAfterBattle)
			{
				m_msgsAfterBattle.executeTwoParam(m_gkContext.m_context.m_gameHandleMsg.handleMsg);
			}
		}
		
		public function get moduleFight():IMFight
		{
			return m_ModuleFight;
		}
	}

}
