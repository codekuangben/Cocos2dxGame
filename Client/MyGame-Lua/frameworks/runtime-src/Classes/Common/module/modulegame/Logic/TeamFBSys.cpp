package game.logic
{
	import game.netmsg.teamcmd.retUserProfitInCopyUserCmd;
	import modulecommon.ui.Form;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.logicinterface.ITeamFBSys;
	import modulecommon.net.msg.propertyUserCmd.stPickUpObjPropertyUserCmd;
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;

	/**
	 * @brief 组队副本系统
	 * */
	public class TeamFBSys implements ITeamFBSys
	{
		public static const MAXCOUNTS_Fight:uint = 2;	//每日组队副本最大挑战次数
		
		protected var m_gkcontext:GkContext;
		protected var m_buseNum:Boolean;		// 是否使用收益次数
		protected var m_bshowType:uint;		// 1 只显示本军团 0 全部
		
		protected var m_clkBtn:Boolean;		// 是否点击按钮
		protected var m_teamMemInfo:stTeamCmd;	// 组队成员
		
		protected var m_inviterName:String;		// 暂存,邀请者名字
		protected var m_copyname:String;		// 暂存,邀请者名字
		protected var m_copytempid:uint;		// 暂存,邀请者名字
		
		protected var m_teamid:uint;			// 当前自己加入的队伍的id，没有什么用，就是回传给服务器的时候回传给服务器
		
		protected var m_bShowTip:Boolean;		//屏幕中间是否出黄字提示
		protected var m_vecGrid:Vector.<uint>;
		//protected var m_ud:Vector.<UserDispatch>;	// 布阵数据
		//protected var m_serverX:uint;
		//protected var m_serverY:uint;
		protected var m_thisid:uint;
		
		protected var m_delMemID:uint;			// 删除的成员的 id
		protected var m_leftCounts:uint;		// 今日挑战剩余次数
		
		protected var m_usecnt:int;	// 副本收益使用次数,这个是使用的次数，剩余次数，需要 2 - m_usecnt
		protected var m_count:uint;	// 同步今日打到第多少层
		protected var m_historyLayer_TeamBoss:int;	//组队boss-历史最高层 zero-based
		protected var m_copyType:uint;		// 1： 组队副本 2 组队闯关

		protected var m_openHallMulMsg:Boolean;		// 打开界面请求数据，注意打开别的界面还需要请求数据
		protected var m_bInMap:Boolean;		//是否在组队副本中
		
		protected var m_logCnt:int = 0;		// 日志次数
		
		public function TeamFBSys(value:GkContext)
		{
			m_gkcontext = value;
			
			/*
			// test
			m_ud = new Vector.<UserDispatch>(3, true);
			var item:UserDispatch;
			var idx:int = 0;
			var idxh:int = 0;
			while(idx < 3)
			{
				item = new UserDispatch();
				m_ud[idx] = item;
				item.charid = idx + 1;
				item.pos = idx;
				item.dh = new Vector.<DispatchHero>(3, true);
				
				idxh = 0;
				while(idxh < 3)
				{
					if(idxh != 1)
					{
						if(idxh == 0)	// 0 非主角
						{
							item.dh[idxh] = new DispatchHero();
							item.dh[idxh].ds = idxh << 1;
							item.dh[idxh].id = 101 + idx * 10 + idxh;
							item.dh[idxh].id *= 10;
						}
						else if(idxh == 2)	// 2 主角
						{
							item.dh[idxh] = new DispatchHero();
							item.dh[idxh].ds = idxh << 1 | 1;
							item.dh[idxh].id = item.charid;
						}
					}
					++idxh;
				}
				
				++idx;
			}
			*/
		}
		
		// 清理不用的数据
		public function clearData():void
		{
			m_vecGrid = null;
			//m_ud = null;
			m_buseNum = false;
			m_bshowType = 0;
			m_clkBtn = false;
			m_teamMemInfo = null;
			m_bShowTip = false;
			m_delMemID = 0;
		}
		
		public function set buseNum(value:Boolean):void
		{
			m_buseNum = value;
		}
		
		public function get buseNum():Boolean
		{
			return m_buseNum;
		}
		
		public function set bshowType(value:uint):void
		{
			m_bshowType = value;
		}
		
		public function get bshowType():uint
		{
			return m_bshowType;
		}
		
		public function set clkBtn(value:Boolean):void
		{
			m_clkBtn = value;
		}
		
		public function get clkBtn():Boolean
		{
			return m_clkBtn;
		}
		
		public function set teamMemInfo(value:stTeamCmd):void
		{
			m_teamMemInfo = value;
		}
		
		public function get teamMemInfo():stTeamCmd
		{
			return m_teamMemInfo;
		}
		
		public function set inviterName(value:String):void
		{
			m_inviterName = value;
		}
		
		public function get inviterName():String
		{
			return m_inviterName;
		}
		
		public function set copyname(value:String):void
		{
			m_copyname = value;
		}
		
		public function get copyname():String
		{
			return m_copyname;
		}
		
		public function set copytempid(value:uint):void
		{
			m_copytempid = value;
		}
		
		public function get copytempid():uint
		{
			return m_copytempid;
		}
		
		public function set teamid(value:uint):void
		{
			m_teamid = value;
		}
		
		public function get teamid():uint
		{
			return m_teamid;
		}
		
		public function set bShowTip(value:Boolean):void
		{
			m_bShowTip = value;
		}
		
		public function get bShowTip():Boolean
		{
			return m_bShowTip;
		}
		
		public function isGridOpen(gridNo:int):Boolean
		{
			return true;
		}
		
		public function getGrids(NO:uint):uint
		{
			//return m_vecGrid[NO];
			return 0;
		}
		
		public function get bInMap():Boolean
		{
			return m_bInMap;
		}
		
		//进入过关斩将地图
		public function enterIn():void
		{
			m_bInMap = true;
			
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			m_gkcontext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkcontext.m_taskMgr.hideUITaskTrace();
			m_gkcontext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
		}
		
		
		//离开过关斩将地图
		public function leave():void
		{
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			
			m_gkcontext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkcontext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			
			m_gkcontext.m_taskMgr.showUITaskTrace();
			
			m_bInMap = false;
		}
		
		//public function pickObj(serverX:uint, serverY:uint):void
		public function pickObj(thisid:uint):void
		{
			//m_serverX = serverX;
			//m_serverY = serverY;
			m_thisid = thisid;
		}
		
		public function psretUserProfitInCopyUserCmd(msg:Object):void
		{
			var rev:retUserProfitInCopyUserCmd = msg as retUserProfitInCopyUserCmd;
			//if(m_gkcontext.m_mapInfo.mapType() == MapInfo.MTTeamFB)	// 如果在副本组队中
			//{
				if(0 == rev.type)
				{
					// 说明不是主角，给出提示
					UtilHtml.beginCompose();
					UtilHtml.add("本副本中您未使用奖励次数，请问您要在此副本中使用吗? ", UtilColor.WHITE_Yellow, 14);
					m_gkcontext.m_confirmDlgMgr.showMode1(UIFormID.UITeamFBSys, UtilHtml.getComposedContent(), NoConfirmFn, ConfirmFn, "不使用", "使用");
				}
				else
				{
					m_gkcontext.m_systemPrompt.prompt("您已用完拾取奖励次数，请明天继续努力！");
				}
			//}
			//else	// 不在，就更新界面
			//{
			//	var form:IUITeamFBSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			//	if(form)
			//	{
			//		form.psretUserProfitInCopyUserCmd(rev.type);
			//	}
			//	if(1 == rev.type)
			//	{
			//		m_gkcontext.m_systemPrompt.prompt("您已用完拾取奖励次数，请明天继续努力！");
			//	}
			//}
		}
		
		private function ConfirmFn():Boolean
		{
			buseNum = true;	// 设置使用副本收益使用次数，以后不再发送了

			var pickmsg:stPickUpObjPropertyUserCmd;
			pickmsg = new stPickUpObjPropertyUserCmd();
			//pickmsg.x = this.m_serverX;
			//pickmsg.y = this.m_serverY;
			pickmsg.thisid = this.m_thisid;
			this.m_gkcontext.sendMsg(pickmsg);
			
			return true;
		}
		
		private function NoConfirmFn():Boolean
		{
			return true;
		}
		
		public function set delMemID(value:uint):void
		{
			m_delMemID = value;
		}
		
		public function get delMemID():uint
		{
			return m_delMemID;
		}
		
		public function get maxCountsFight():uint
		{
			return MAXCOUNTS_Fight;
		}
		
		public function set leftCounts(value:uint):void
		{
			m_leftCounts = value;
		}
		
		public function get leftCounts():uint
		{
			return m_leftCounts;
		}
		/*
		public function set ud(value:Vector.<UserDispatch>):void
		{
			m_ud = value;
		}
		
		public function get ud():Vector.<UserDispatch>
		{
			return m_ud;
		}
		
		public function psretChangeAssginHeroUserCmd(pos:uint, type:uint, dh:DispatchHero):int
		{
			// 测试代码
			var testcol:int = dh.ds >> 1;
			if(testcol < 0 || testcol > 2 || pos < 0 || pos > 2)
			{
				return -1;
			}
			var row:UserDispatch;
			var find:Boolean;
			for each(row in m_ud)
			{
				if(row && row.pos == pos)
				{
					find = true;
					break;
				}
			}
			
			if(find)
			{
				if(2 == type)
				{
					row.dh[dh.ds>>1] = null;
				}
				else if(1 == type)	// 移动
				{
					// 查找到武将的位置，然后交换
					var col:int = 0;
					var item:DispatchHero;
					while(col < 3)
					{
						item = row.dh[col];
						if(item && item.id == dh.id)
						{
							break;
						}
						++col;
					}
					if(col < 3)
					{
						// 交换两个的位置
						var destdh:DispatchHero;
						destdh = row.dh[dh.ds>>1];
						destdh.ds = item.ds;
						row.dh[col] = destdh;
					}
					row.dh[dh.ds>>1] = dh;
				}
				else	// 添加
				{
					row.dh[dh.ds>>1] = dh;
				}
			}
			
			return col;
		}
		
		// 获取一行的武将数量
		public function getRowWJCnt(row:int):int
		{
			var rowud:UserDispatch;
			var coldh:DispatchHero;
			var cnt:int;
			var idx:uint = 0;
			if(m_ud)
			{
				rowud = m_ud[row];
				if(rowud)
				{
					while(idx < 3)
					{
						coldh = rowud[idx];
						if(coldh)
						{
							++cnt;
						}
						++idx;
					}
				}
			}
			
			return cnt;
		}
		
		public function getAllWJCnt():int
		{
			var rowud:UserDispatch;
			var coldh:DispatchHero;
			var cnt:int;
			var row:uint = 0;
			var col:uint = 0;
			if(m_ud)
			{
				while(row < 3)
				{
					rowud = m_ud[row];
					if(rowud)
					{
						col = 0;
						while(col < 3)
						{
							coldh = rowud[col];
							if(coldh)
							{
								++cnt;
							}
							++col;
						}
					}
					
					++row;
				}
			}
			
			return cnt;
		}
		*/
		
		public function get usecnt():int
		{
			return m_usecnt;
		}
		
		public function set usecnt(value:int):void
		{
			m_usecnt = value;
		}
		
		public function get leftUseCnt():int
		{
			return 2 - m_usecnt;
		}
		
		// 根据副本名字返回副本等级
		public function getFBLevelByName(fbname:String):int
		{
			var xml:XML = m_gkcontext.m_dataXml.getXML(DataXml.XML_Teamfbsys);
			
			var cityList:XMLList;
			var cityXML:XML;
			var fubenList:XMLList;
			var fubenXML:XML;
			
			cityList = xml.child("page");
			for each(cityXML in cityList)
			{
				fubenList = cityXML.child("copy");
				for each(fubenXML in fubenList)
				{
					if(fubenXML.@name == fbname)
					{
						return parseInt(fubenXML.@level);
					}
				}
			}
			
			return 0;
		}
		
		public function get count():uint
		{
			return (m_count + 1);	// 这个值需要加上 1
		}
		
		public function set count(value:uint):void
		{
			m_count = value;
		}
		
		
		public function get historyLayer_TeamBoss():int
		{
			return m_historyLayer_TeamBoss + 1;
		}
		
		public function set historyLayer_TeamBoss(value:int):void
		{
			m_historyLayer_TeamBoss = value;
		}
		
		public function get copyType():uint
		{
			return m_copyType;
		}
		
		public function set copyType(value:uint):void
		{
			m_copyType = value;
		}
		
		public function isEqualCopyType(copytype:uint):Boolean
		{
			return (m_copyType == copyType);
		}
		
		public function get openHallMulMsg():Boolean
		{
			return m_openHallMulMsg;
		}
		
		public function set openHallMulMsg(value:Boolean):void
		{
			m_openHallMulMsg = value;
		}
		
		public function get logCnt():int
		{
			return m_logCnt;
		}
		
		public function set logCnt(value:int):void
		{
			m_logCnt = value;
		}
	}
}