package modulecommon.scene 
{
	import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TDataItem;
	import modulecommon.scene.prop.table.TWorldmapItem;
	//import modulecommon.ui.Form;
	//import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUINpcTalk;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class MapInfo 
	{
		public static const MAP_GRID_SIEZE:int = 32;	//地图格子大小
		//将一些常用地图ID列与此
		public static const MAPID_CHANGAN:uint = 1092; 	// 长安
		public static const MAPID_SanguoZhanchang:uint = 99; 	// 三国战场
		public static const MAPID_CORPSCITY:uint = 88; 	// 军团城市争夺战地图特殊地图 id,客户端地图的 id 是 8
		public static const MAPID_WORLDBOSS:uint = 77;	//世界Boss之十面埋伏
		
		public static const MAPID_TeamChuanGuan:uint = 9998;	// 这个是组队闯关地图的唯一一个 id
		public static const MAPID_JYBOSS:uint = 9997;	// 精英boss地图
		public static const GGZJBaseMapID:uint = 3110;
		
		
		//特殊副本ID
		public static const COPYID_GGZJ:uint = 10001;		//过关斩将
		
		
		public static const MTZhanYi:uint = 0; 	// 战役挑战
		public static const MTMain:uint = 1;		// 主城
		public static const MTFuBen:uint = 2;		// 副本
		public static const MTCBK:uint = 3;		// 藏宝库
		public static const MTGGZJ:uint = 4;		// 过关斩将
		public static const MTTeamFB:uint = 5;		// 组队副本
		public static const CorpsCitySys:uint = 6;		// 军团城市系统
		
		
		protected var m_gkContext:GkContext;
		protected var m_iCurMapID:int = 0;			// 以后不用这个 id 
		public var m_servermapconfigID:uint;		//服务器地图配置文件ID;就是服务器配置文件中 [mapid] 配置的字段
		protected var m_clientMapID:int = 0;		// 客户端的地图 id ，客户端根据这个作为地图文件名字查找资源
		protected var m_lastClientMapID:int = 0;	// 上一个地图 id，用于跳转地图的时候判断上一次的地图
		protected var m_lastservermapconfigID:uint = 0;	// 上一个地图服务器 id,用于卸载之前的地图资源
		public var m_strMapName:String = "";
		
		//地图跳转点信息（用于自动寻路）
		public var _npcIDSkip:uint;	//跳转点npcID，
		public var _xWorldmap:int;	//跳转点npc的坐标
		public var _yWorldmap:int;
		
		protected var m_fightMapName:uint = 0;		// 记录战斗地图的名字
		protected var m_lastfightMapName:uint = 0;		// 记录上一次战斗地图的名字
		public var m_mapPath:String;		// 地图资源完整的路径
		
		public var m_bInArean:Boolean = false;				// 是否在竞技场中，在竞技场中需要自己手工创建角色
		public var m_bInSGQYH:Boolean = false;				// 是否在三国群英会中
		public var m_bInBattleIScene:Boolean = false;
		public var m_areanSceneID:uint = 10;				// 竞技场 id
		public var m_areanmapfilename:uint = 10;			// 竞技场客户端地图文件 id
		
		public var m_heroRallSceneID:uint = 11;				// 英雄会 id
		public var m_heroRallfilename:uint = 11;			// 英雄会客户地图文件 id
		
		public var m_mapPathArean:String;		// 地图资源完整的路径
		
		public var m_curCopyId:uint;			//当前副本ID //每次创建副本返回消息中更新该值
		public var m_isInFuben:Boolean;			//true 当前处于副本中
		
		public var m_presceneMusic:String = "";		// 前一个场景音乐名字
		public var m_sceneMusic:String = "";		// 场景音乐名字
		public var m_ggzjMapID:uint;				// 过关战将更改地图名字，是通过地图 id 改变的，客户端根据地图 id 去修改地图名字
		public var m_ggzjCurLayer:uint = 1;			//过关斩将当前层数（每当进入某一层时更新）层数依次为:1,2,3,4...
		
		public function MapInfo(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		public function get inFubenPromptDesc():String
		{
			return "当前处于副本状态不可使用！";
		}

		public function promptInFubenDesc():void
		{
			m_gkContext.m_systemPrompt.prompt(inFubenPromptDesc);
		}
		
		public function setBaseParam(curMapID:uint, servermapconfigID:uint, clientMapID:int, fightMapName:uint, mapname:String):void
		{
			m_iCurMapID = curMapID;
			
			m_lastClientMapID = m_clientMapID;
			m_clientMapID = curMapID;
			
			m_lastservermapconfigID = m_servermapconfigID; 
			m_servermapconfigID = servermapconfigID;
			
			m_lastfightMapName = m_fightMapName;
			m_fightMapName = fightMapName;
			
			m_strMapName = mapname;
		}
		
		public function get lastClientMapID():int
		{
			return m_lastClientMapID;
		}

		public function get lastfightMapName():uint
		{
			return m_lastfightMapName;
		}
		
		public function get lastservermapconfigID():uint
		{
			return m_lastservermapconfigID;
		}

		public function get fightMapName():uint
		{
			return m_fightMapName;
		}

		

		public function getWorldmapPoint():Point
		{
			return m_gkContext.m_context.m_sceneView.scene().ServerPointToClientPoint2(_xWorldmap,_yWorldmap);
		}	

	
		public function get curMapID():int
		{
			return m_iCurMapID;
		}		
	
		public function get mapName():String
		{
			return m_strMapName;
		}
		
		public function set mapName(value:String):void
		{
			m_strMapName = value;
		}

		public function get clientMapID():int
		{
			return m_clientMapID;
		}
		
		public function set inBattleIScene(bIn:Boolean):void
		{
			if (m_bInBattleIScene == bIn)
			{
				return;
			}
			m_bInBattleIScene = bIn;
			if (m_bInBattleIScene == false)
			{
				m_gkContext.m_UIMgr.leaveFromBattleScene();				
			}
			else
			{
				m_gkContext.m_UIMgr.switchToBattleScene();
			}
		}
		
		public function get inBattleIScene():Boolean
		{
			return m_bInBattleIScene;
		}
		
		public function getCityIDByMapID(mapID:uint):int
		{
			var list:Vector.<TDataItem> = m_gkContext.m_dataTable.getTable(DataTable.TABLE_WORLDMAP);
			var item:TWorldmapItem;
			for each(item in list)
			{
				if (item.city_checkpoint == mapID)
				{
					return item.m_uID;
				}
			}
			return 0;
		}
		
		public function mapType():uint
		{
			if(3011 <= m_servermapconfigID && m_servermapconfigID <= 3200)		// m_servermapconfigID 和 m_iCurMapID 可能不一样,以后都用 m_servermapconfigID ,就是服务器配置文件中 [mapid] 配置的字段  
			{
				return MTGGZJ;
			}
			else if (9997 == m_servermapconfigID)//精英boss:m_iCurMapID=931**←（这玩意还能递增）&&m_servermapconfigID=9997
			{
				return MTFuBen;//返回这个走通用模式
			}
			else if((2000 <= m_servermapconfigID && m_servermapconfigID <= 2100) || (MAPID_TeamChuanGuan == m_servermapconfigID))	// 组队副本ID段，copy id=2000到2100  9998组队boss地图
			{
				return MTTeamFB;
			}
			else if((80 <= m_servermapconfigID && m_servermapconfigID <= 150) && m_servermapconfigID != 99)	// 99 是三国争霸地图
			{
				return CorpsCitySys;
			}
			else if((6101 <= m_iCurMapID) && (6200 >= m_iCurMapID))
			{
				return MTZhanYi;
			}
			else if ((1000 <= m_iCurMapID) && (2000 >= m_iCurMapID)) //主城区地图ID段
			{
				return MTMain;
			}
			else if (((93001 <= m_iCurMapID) && (93999 >= m_iCurMapID))) //93001~93999为藏宝窟地图 10000~80000为副本ID段
			{
				return MTCBK;
			}
			else if((10000 <= m_iCurMapID) && (80000 >= m_iCurMapID))
			{
				return MTFuBen;
			}
			
			return MTFuBen;		// 这个
		}
		
		public static function s_moveSpeedConvertFromServerToClient(s:uint):Number
		{
			return s * MAP_GRID_SIEZE;
		}
	
		public static function s_serverPointToClientPoint2(x:int, y:int):Point
		{
			var ptClient:Point = new Point();
			ptClient.x = x * MAP_GRID_SIEZE;
			ptClient.y = y * MAP_GRID_SIEZE;			
			return ptClient;
		}
		
		public function getGGZJMapName():String
		{
			if (m_ggzjMapID)
			{
				m_ggzjCurLayer = m_ggzjMapID - (MapInfo.GGZJBaseMapID - 1);
				return ("过关斩将第" + m_ggzjCurLayer + "层");
			}
			else
			{
				return m_strMapName;
			}
		}
		
	}
}