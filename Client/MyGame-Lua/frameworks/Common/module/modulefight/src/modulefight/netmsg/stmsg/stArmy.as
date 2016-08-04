package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import com.pblabs.engine.debug.Logger;
	
	public class stArmy 
	{		
		public var m_team:int;
		public var m_gkContext:GkContext;
		public var users:Vector.<stUserInfo>;
		public var dicUsers:Dictionary;
		public var matrixList:Vector.<stMatrixInfo>;		
		public function stArmy(team:int):void
		{
			m_team = team;
		}
		public function deserialize(byte:ByteArray):void
		{
			var size:int;
			var idx:uint = 0;
			var user:stUserInfo;
			users = new Vector.<stUserInfo>();
			dicUsers = new Dictionary();
			size = byte.readUnsignedByte();
			while (idx < size)
			{
				user = new stUserInfo();
				user.deserialize(byte);
				users.push(user);
				dicUsers[user.charID] = user;
				idx++;
			}
			
			matrixList ||= new Vector.<stMatrixInfo>();		
			
			var gridNo:uint;
			var value:stMatrixInfo;
			
			idx = 0;
			size = byte.readUnsignedByte();
			while (idx < size)
			{				
				value = new stMatrixInfo();
				value.deserialize(byte);
				matrixList.push(value);				
				++idx;
			}			
		}
		
		public function init(gk:GkContext):void
		{
			var i:int;
			var count:int = matrixList.length;
			
			var mat:stMatrixInfo;
			var npcID:uint;
			var user:stUserInfo;
			
			m_gkContext = gk;
			for (i = 0; i < count; i++)
			{
				mat = matrixList[i];
				mat.m_gkContext = gk;
				if (mat.masterid)
				{
					user = dicUsers[mat.masterid];
				}
				else
				{
					user = users[0];
				}
				mat.userInfo = user;
				if (mat.masterid)
				{					
					if (mat.tempid == user.charID)
					{
						npcID = gk.m_context.m_playerResMgr.battleNpcID(user.job, user.sex);
						mat.m_beingType = stMatrixInfo.BEINGTYPE_Player;
					}
					else
					{
						npcID = mat.tempid / 10;
						mat.m_beingType = stMatrixInfo.BEINGTYPE_Wu;
					}
				}
				else
				{
					npcID = mat.tempid;					
				}
				
				mat.m_npcBase = gk.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, npcID) as TNpcBattleItem;
				if (mat.masterid == 0)
				{
					if (mat.m_npcBase.m_iType == TNpcBattleItem.TYPE_BOSS)
					{
						mat.m_beingType = stMatrixInfo.BEINGTYPE_BOSS;
					}
					else if (mat.m_npcBase.m_iType == TNpcBattleItem.TYPE_Jingying)
					{
						mat.m_beingType = stMatrixInfo.BEINGTYPE_Jingying;
					}
					else
					{
						mat.m_beingType = stMatrixInfo.BEINGTYPE_Monster;
					}
				}
				
				// 打日志
				if(mat.m_npcBase == null)
				{
					Logger.info(null, null, "npcid cannot find: " + npcID);
				}
			}
		}
		
		//判断此兵团是否由玩家(主角或其它玩家)主导
		public function get isPlayer():Boolean
		{
			return users[0].job != 0;
		}
		
		public function getMatrix(noIdx:uint):stMatrixInfo
		{
			var mat:stMatrixInfo;
			for each(mat in matrixList)
			{
				if(mat.gridNo == noIdx)
				{
					return mat;
				}
			}
			
			return null;
		}
		
		public function get userInfoForHeadportrait():stUserInfo
		{
			var user:stUserInfo = dicUsers[m_gkContext.playerMain.charID];
			if (user == null)
			{
				user = users[0];
			}
			return user;
		}
		
		public function isPlayerInThisArmy(charID:uint):Boolean
		{
			return dicUsers[charID] != undefined;
		}
		public function generateLog():String
		{
			return "";
		}
	}

}

/*
struct stArmy
	{
		BYTE usersize;
		stUserInfo user[0];
		BYTE matrixsize;
		stMatrixInfo matrix[0];
		stArmy()
		{
			usersize = 0;
			//bzero(&user,sizeof(stUserInfo));
			matrixsize = 0;
		}
	};*/