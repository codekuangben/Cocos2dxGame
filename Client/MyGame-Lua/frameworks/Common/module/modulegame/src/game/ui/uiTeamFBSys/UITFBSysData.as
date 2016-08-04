package game.ui.uiTeamFBSys
{
	import com.bit101.components.Panel;
	import game.ui.uiTeamFBSys.msg.Item;
	import game.ui.uiTeamFBSys.xmldata.XmlData;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.TeamUser;
	import modulecommon.net.msg.teamUserCmd.stNotifyTeamMemberListUserCmd;
	import modulecommon.ui.Form;
	
	import game.ui.uiTeamFBSys.msg.HeroData;
	import game.ui.uiTeamFBSys.msg.UserHeroData;
	import game.ui.uiTeamFBSys.msg.reqChangeAssginHeroUserCmd;
	import game.ui.uiTeamFBSys.msg.retFightHeroDataUserCmd;
	import game.ui.uiTeamFBSys.teamfbsel.FBSelFBItem;
	import game.ui.uiTeamFBSys.xmldata.XmlFBItem;
	import game.ui.uiTeamFBSys.xmldata.XmlPage;

	/**
	 * @ 模块数据
	 * */
	public class UITFBSysData
	{
		public var m_gkcontext:GkContext;
		public var m_form:Form;
		public var m_pageLst:Vector.<XmlPage>;
		public var m_xmlData:XmlData;
		
		public var m_xmlParseEndCB:Function;	// xml 解析结束执行的回调
		public var m_clkFBObjCB:Function;		// 点击更新物品
		public var m_clkFBOpenedCB:Function;	// 点击开启的副本
		public var m_clkFBItemCB:Function;		// 点击副本回调 
		
		public var m_curUIFB:Vector.<FBSelFBItem>;		// 当前点击的副本 界面
		public var m_curFB:Vector.<XmlFBItem>;		// 当前点击的副本
		public var m_curFBIdx:Vector.<int>;			// 当前点击的副本的相对索引， 0 左边 1 右边
		
		public var m_curPageIdx:int = -1;
		public var m_onUIClose:Function;
		public var m_openedFBLst:Array;			// 开启的副本列表
		public var m_teamMemInfo:stNotifyTeamMemberListUserCmd;	// 组队成员
		
		public var m_overPanel:Panel;
		public var m_selectPanel:Panel;
		
		public var m_curFBMgerItemIdx:int = -1;		// 当前的副本管理点击的索引
		
		public var m_inviteClkCB:Function;			// 邀请的时候电机某一项回调
		public var m_selfRow:uint;			// 布阵界面自己所在的行,以服务器的行编号为准
		public var m_selfitemUD:UserDispatch;	// 自己所在行的武将保存，以便后面点击重新上阵上一场武将
		
		public var m_ud:Vector.<UserDispatch>;	// 布阵数据
		public var m_breqZXData:Boolean;			// 是否请求阵法数据，只请求一次
		
		public var m_strEventID:String;
		public var m_questID:uint;
		public var m_embranchmentId:uint;
		
		public var m_heroData:retFightHeroDataUserCmd;	// 这个是出战武将的数据,用来显示当鼠标移动到出战武将上面的时候显示一些信息
		public var m_showOrder:Boolean;
		public var m_usecnt:int;	// 副本收益使用次数
		
		public var m_exp:uint;
		public var m_preClickTime:Number;
		
		public var m_rankLst:Array;			// 排行榜列表
		public var m_resLoader:ModuleResLoader;
		
		public var m_assistv:uint;
		public var m_gainflag:uint;			// 已经领取的礼包
		public var m_lastGiftId:uint;		// 可领取的礼包 id
		
		public function UITFBSysData()
		{
			m_pageLst = new Vector.<XmlPage>();
			m_curUIFB = new Vector.<FBSelFBItem>(3, true);
			m_curFB = new Vector.<XmlFBItem>(3, true);
			m_curFBIdx = new Vector.<int>(3, true);
			
			m_preClickTime = 0;
			/*
			// test
			m_teamMemInfo = new stNotifyTeamMemberListUserCmd();
			m_teamMemInfo.size = 3;
			m_teamMemInfo.leader = 0;
			m_teamMemInfo.data = new Vector.<TeamUser>(3, true);
			
			var idx:int = 0;
			while(idx < 3)
			{
				m_teamMemInfo.data[idx] = new TeamUser();
				m_teamMemInfo.data[idx].id = idx + 1;
				m_teamMemInfo.data[idx].name = idx + "";
				m_teamMemInfo.data[idx].corps = idx + "";
				m_teamMemInfo.data[idx].zhanli = idx;
				m_teamMemInfo.data[idx].sex = 1;
				m_teamMemInfo.data[idx].job = 1;
				++idx;
			}
			*/
			m_xmlData = new XmlData();
		}
		
		public function dispose():void
		{
			m_resLoader.unloadRes();
			m_resLoader = null;
			
			m_gkcontext = null;
			m_pageLst = null;
			m_xmlParseEndCB = null;
			m_clkFBObjCB = null;
			m_clkFBOpenedCB = null;
			m_curFB = null;
			m_curFBIdx = null;
			m_onUIClose = null;
		}
		
		// 判断自己是不是队长
		public function isSelfLeader():Boolean
		{
			var item:TeamUser;
			for each(item in m_teamMemInfo.data)
			{
				if(item.id == m_teamMemInfo.leader)
				{
					break;
				}
			}
			
			if(item)
			{
				if(item.name == m_gkcontext.m_playerManager.hero.name)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function isLeader(id:uint):Boolean
		{
			var ret:Boolean = false;
			if(id == m_teamMemInfo.leader)
			{
				ret = true;
			}
			
			return ret;
		}
		
		// 判断索引里面的数据是不是自己
		public function isSelf(idx:uint):Boolean
		{
			if(m_curFBMgerItemIdx >= 0)
			{
				if(m_teamMemInfo.data && idx < m_teamMemInfo.data.length)
				{
					if(m_teamMemInfo.data[idx].name == m_gkcontext.m_playerManager.hero.name)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function getUserInfo(id:uint):TeamUser
		{
			var item:TeamUser;
			if (m_teamMemInfo && m_teamMemInfo.data)
			{
				for each(item in m_teamMemInfo.data)
				{
					if (item)
					{
						if(item.id == id)
						{
							return item;
						}
					}
				}
			}
			
			return null;
		}
		
		public function isSelfRow(row:int):Boolean
		{
			return (m_selfRow == row);
		}
		
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
			
			var col:int = 0;
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
					col = 0;
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
						if(destdh)
						{
							destdh.ds = (destdh.ds & 0x01) | (item.ds & 0xFE);	// (destdh.ds & 0x01) 取出类型， (item.ds & 0xFE) 取出位置  
						}
						row.dh[col] = destdh;
					}
					row.dh[dh.ds>>1] = dh;
				}
				else	// 添加
				{
					row.dh[dh.ds>>1] = dh;
				}
			}
			else
			{
				col = -1;
			}
			
			if (col == 3)
			{
				col = -1;
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
						coldh = rowud.dh[idx];
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
							coldh = rowud.dh[col];
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
		
		public function getUserDispatchByNo(row:int):UserDispatch
		{
			var itemUD:UserDispatch;
			
			if(m_ud)
			{
				itemUD = m_ud[row];
			}
			
			return itemUD;
		}
		
		// 通过编号获取
		public function getDispatchHeroByNo(row:int, col:int):DispatchHero
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			
			if(m_ud)
			{
				itemUD = m_ud[row];
				if(itemUD)
				{
					itemDH = itemUD.dh[col];
				}
			}
			
			return itemDH;
		}
		
		// 根据用户 id 和 武将 id 获取武将显示数据
		public function getDispatchHero(dwUserID:uint, wjid:uint):DispatchHero
		{
			var idxud:int = 0;
			var idxdh:int = 0;
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var retDH:DispatchHero;
			
			// 排序
			var lst:Vector.<HeroData> = new Vector.<HeroData>();
			var wuidx:int = 0;
			
			if(m_ud)
			{
				while(idxud < m_ud.length)
				{
					itemUD = m_ud[idxud];
					if(itemUD)
					{
						if(dwUserID == itemUD.charid)		// 如果是主角自己
						{
							idxdh = 0;
							while(idxdh < itemUD.dh.length)
							{
								itemDH = itemUD.dh[idxdh]
								if(itemDH && itemDH.id == wjid)
								{
									retDH = itemDH;
									break;
								}
								++idxdh;
							}
							break;
						}
					}
					
					++idxud;
				}
			}
			
			return retDH;
		}
		
		// 根据用户 id 和 武将 id 获取武将显示数据
		public function getHeroData(dwUserID:uint, wjid:uint):HeroData
		{
			var item:HeroData;
			var useridx:int = 0;
			var wjidx:int = 0;
			
			if(m_heroData)
			{
				while(useridx < m_heroData.data.length)
				{
					if(m_heroData.data[useridx].dwUserID == dwUserID)
					{
						break;
					}
					++useridx;
				}
				
				if(useridx < m_heroData.data.length)
				{
					while(wjidx < m_heroData.data[useridx].data.length)
					{
						if(m_heroData.data[useridx].data[wjidx].id == wjid)
						{
							item = m_heroData.data[useridx].data[wjidx];
							break;
						}
						
						++wjidx;
					}
				}
			}
			
			return item;
		}
		
		// 计算上阵武将的出手顺序
		public function sortZXWJ():void
		{			
			// 排序
			var lst:Vector.<HeroData> = new Vector.<HeroData>();
			var wuidx:int = 0;
			
			var herocharid:uint = m_gkcontext.m_playerManager.hero.charID;
			
			// 排序
			var itemUserHeroData:UserHeroData;
			var itemHeroData:HeroData;
			var idxUHD:int = 0;
			var idxHD:int = 0;
			var itemDH:DispatchHero;
			
			while(idxUHD < m_heroData.data.length)
			{
				itemUserHeroData = m_heroData.data[idxUHD];
				if(itemUserHeroData)
				{
					//if(itemUserHeroData.dwUserID == herocharid)	// 如果是自己
					//{
						idxHD = 0;
						while(idxHD < itemUserHeroData.data.length)
						{
							itemHeroData = itemUserHeroData.data[idxHD];
							if(itemHeroData)
							{
								itemDH = getDispatchHero(itemUserHeroData.dwUserID, itemHeroData.id);
								if(itemDH)
								{
									lst.push(itemHeroData);
								}
							}
							++idxHD;
						}
					//}
					//else
					//{
						// 取出武将
						//wuidx = 0;
						//while(wuidx < itemUserHeroData.data.length)
						//{
							//lst.push(itemUserHeroData.data[wuidx]);
							//++wuidx;
						//}
					//}
				}
				++idxUHD;
			}
			
			// 排序
			insertion(lst);
			// 设置标志
			buildSortID(lst);
		}
		
		// 插入排序，从大到小排序
		public function insertion(a:Vector.<HeroData>):void
		{
			var l:int = 0;
			var r:int = a.length - 1;
			
			var i:int;
			for (i = l + 1; i <= r; i++)
			{
				var j:int = i;
				var v:HeroData = a[i];
				while(j > 0 && v.speed > a[j - 1].speed)
				{
					a[j] = a[j - 1];
					j--;
				}
				a[j] = v;
			}
		}
		
		public function buildSortID(a:Vector.<HeroData>):void
		{
			var idx:int = 0;
			while(idx < a.length)
			{
				a[idx].m_sortID = idx + 1;
				
				++idx;
			}
		}
		
		// 保存自己最后一次武将，以便一键重置
		public function saveSelfLastWu():void
		{
			m_selfitemUD = new UserDispatch();
			m_selfitemUD.copyFrom(getUserDispatchByNo(m_selfRow));
		}
		
		// 一键还原最后一次武将
		public function resetLastWu():void
		{
			var send:reqChangeAssginHeroUserCmd;
			var itemready:UserDispatch = getUserDispatchByNo(m_selfRow);
			var item:DispatchHero;
			var idx:int = 0;
			
			var btip:Boolean = true;	// 如果没有是否探出提示
			
			if(m_selfitemUD)
			{
				//for each(var item:DispatchHero in m_selfitemUD.dh)
				while(idx < 3)
				{
					item = m_selfitemUD.dh[idx];

					if(!itemready || !itemready.dh || !itemready.dh[idx])	// 只有阵型上这个位置没有武将才可以设置武将
					{
						if(item)
						{
							send = new reqChangeAssginHeroUserCmd();
							send.type = 0;
							send.dh.copyFrom(item);
							m_gkcontext.sendMsg(send);
							btip = false;
						}
					}
					
					++idx;
				}
			}
			
			if(btip)
			{
				m_gkcontext.m_systemPrompt.prompt("无上次出阵信息或上次出阵武将已经全部在阵上");
			}
		}
		
		public function getHeroRank():uint
		{
			var item:Item;
			for each(item in m_rankLst)
			{
				if (item.name == m_gkcontext.m_playerManager.hero.name)
				{
					return item.rank;
				}
			}
			
			return 0;
		}
		
		// 数据校验
		public function checkDataCorrect(row:int, col:int):Boolean
		{	
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			
			if(m_ud)
			{
				if (row < m_ud.length)
				{
					itemUD = m_ud[row];
					if(itemUD)
					{
						if (itemUD.dh && col < itemUD.dh.length)
						{
							itemDH = itemUD.dh[col];
						}
					}
				}
			}
			
			return (itemUD && itemDH);
		}
		
		// 输出日志
		public function logInfo(extrainfo:String = ""):void
		{
			var str:String = extrainfo;
			var itemUD:UserDispatch;
			
			var row:int = 0;
			if(m_ud)
			{
				while (row < m_ud.length)
				{
					itemUD = m_ud[row];
					if(itemUD)
					{
						str += itemUD.logInfo();
						str += " \n ";
					}
					
					++row;
				}
			}
			
			if (m_gkcontext.m_teamFBSys.logCnt < 5)
			{
				m_gkcontext.m_teamFBSys.logCnt = m_gkcontext.m_teamFBSys.logCnt + 1;
				m_gkcontext.m_context.sendErrorToDataBase(str);
			}
		}
	}
}