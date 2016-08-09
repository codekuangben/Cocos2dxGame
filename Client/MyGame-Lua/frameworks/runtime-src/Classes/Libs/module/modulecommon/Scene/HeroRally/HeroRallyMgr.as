package modulecommon.scene.herorally 
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.MatchUserInfo;
	import modulecommon.net.msg.sgQunYingCmd.stGetVicBoxCmd;
	import modulecommon.net.msg.sgQunYingCmd.stMatchUserInfoCmd;
	import modulecommon.net.msg.sgQunYingCmd.stQunYingHuiOnlineCmd;
	import modulecommon.net.msg.sgQunYingCmd.stUpdateUserInfoCmd;
	import modulecommon.net.msg.sgQunYingCmd.stUpdateUserZhanJiCmd;
	import modulecommon.net.msg.sgQunYingCmd.UserZhanJi;
	import modulecommon.scene.dazuo.DaZuoMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.time.TimeItem;
	import time.TimeL;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHeroRally;
	import modulecommon.uiinterface.IUIRadar;
	/**
	 * ...
	 * @author 
	 */
	public class HeroRallyMgr 
	{
		public static const MAXLISTNUM:uint = 3;	
		private var m_gkcontext:GkContext;
		private var m_rule:String;
		private var m_FieldTimeDic:Dictionary;//[id,FieldTimeParam]
		private var m_groupInfoDic:Dictionary;//[id,groupInfo];
		private var m_rank:uint//排行榜我的排名
		private var m_score:uint//排行榜我的积分
		private var m_curgroup:uint//我的级段
		private var m_recordList:Array;//我的战绩信息维护 最多3个FieldData 界面显示的 非前端补充的 
		private var m_userInfo:MatchUserInfo;//中间的对手信息 每场结束时为null
		private var m_isAct:Boolean;
		public function HeroRallyMgr(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_recordList = new Array();
			m_isAct = false;
		}
		/**
		 * 读xml
		 */
		public function loadConfig():void
		{
			if (m_rule)
			{
				return;
			}
			m_FieldTimeDic = new Dictionary();
			m_groupInfoDic = new Dictionary();
			var xml:XML = m_gkcontext.m_dataXml.getXML(DataXml.XML_Sanguoqunyinghui);
			m_rule = xml.child("rule").toString();
			var xmlItem:XML;
			for each (xmlItem in xml.elements("time"))
			{
				var timeParam:FieldTimeParam = new FieldTimeParam();
				timeParam.parse(xmlItem);
				m_FieldTimeDic[timeParam.m_id] = timeParam;
			}
			for each (xmlItem in xml.elements("group"))
			{
				var groupinfo:groupInfo = new groupInfo();
				groupinfo.parse(xmlItem);
				m_groupInfoDic[groupinfo.m_id] = groupinfo;
			}
		}
		/**
		 * 进入群英会功能
		 */
		public function enterHeroRally():void
		{
			if(!m_gkcontext.m_context.m_sceneView.isLoading)
			{
				// 进入场景，这个场景用完了就卸载了
				var nameFileName:String;				
				m_gkcontext.playerMain.stopMoving();
				m_gkcontext.m_mapInfo.m_bInSGQYH = true;
				nameFileName = m_gkcontext.m_context.m_path.getPathByName("x" + m_gkcontext.m_mapInfo.m_heroRallfilename + ".swf", EntityCValue.PHXMLTINS);				
				m_gkcontext.m_context.m_sceneView.gotoSceneUI(nameFileName, m_gkcontext.m_mapInfo.m_heroRallSceneID);								
			}
			var formRadar:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIRadar);
			(formRadar as IUIRadar).updateBtnRadar();
			var form:Form=m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIHeroRally);
			form.show();
			m_gkcontext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkcontext.m_taskMgr.hideUITaskTrace();
			m_gkcontext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			m_gkcontext.m_dazuoMgr.setStateOfDaZuo(DaZuoMgr.STATE_NODAZUO);
		}
		
		public function onMapLoaded():void
		{
			m_gkcontext.m_context.m_sceneView.curCamera(EntityCValue.SCUI).gotoPos(960, 510, 0);
		}
		/**
		 * 退出群英会功能
		 */
		public function exitHeroRally():Boolean
		{
			if (!m_gkcontext.m_context.m_sceneView.isLoading)
			{
				m_gkcontext.m_mapInfo.m_bInSGQYH = false;
				
				// 关闭界面
				var form:Form;
				form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIHeroRally);
				if (form)
				{
					form.exit();
				}
				m_gkcontext.m_context.m_sceneView.leaveSceneUI();
				
				m_gkcontext.m_screenbtnMgr.showUIScreenBtn();		
				m_gkcontext.m_taskMgr.showUITaskTrace();
				m_gkcontext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
				
				return true;
			}
			
			return false;
		}
		/**
		 * 上线消息
		 */
		public function process_stQunYingHuiOnlineCmd(byte:ByteArray, param:uint):void
		{
			var rev:stQunYingHuiOnlineCmd = new stQunYingHuiOnlineCmd();
			rev.deserialize(byte);
			m_rank = rev.m_myrank;
			m_curgroup = rev.m_group;
			m_score = rev.m_score;
			m_recordList = swithToEffect(rev.m_zjList);
			addDingshiqi();
			showScreenBtnAni();
		}
		/**
		 * 对手信息 轮空本消息会收到 内部为空 未配对本消息收不到
		 */
		public function process_stMatchUserInfoCmd(byte:ByteArray, param:uint):void
		{
			var rev:stMatchUserInfoCmd = new stMatchUserInfoCmd();
			rev.deserialize(byte);
			m_userInfo = rev.m_userInfo;
			if (m_gkcontext.m_UIs.heroRally && m_gkcontext.m_UIs.heroRally.isVisible())
			{
				m_gkcontext.m_UIs.heroRally.updataHalfImage();
			}
		}
		/**
		 * 段位 积分 名次更新消息
		 */
		public function process_stUpdateUserInfoCmd(byte:ByteArray, param:uint):void
		{
			var rev:stUpdateUserInfoCmd = new stUpdateUserInfoCmd();
			rev.deserialize(byte);
			m_rank = rev.m_myRank;
			m_score = rev.m_score;
			m_curgroup = rev.m_group;
			if (m_gkcontext.m_UIs.heroRally && m_gkcontext.m_UIs.heroRally.isVisible())
			{
				m_gkcontext.m_UIs.heroRally.upDataGroup();
			}
		}
		/**
		 *战绩更新消息 
		 */
		public function process_stUpdateUserZhanJiCmd(byte:ByteArray, param:uint):void
		{
			var rev:stUpdateUserZhanJiCmd = new stUpdateUserZhanJiCmd();
			rev.deserialize(byte);
			if (FieldData.EffectiveData(m_gkcontext,rev.m_userZhanJi))
			{
				if (m_recordList.length>0&&(m_recordList[m_recordList.length-1] as FieldData).isThisField(rev.m_userZhanJi))
				{	
					(m_recordList[m_recordList.length-1] as FieldData).setdata(rev.m_userZhanJi);
					if (m_gkcontext.m_UIs.heroRally)
					{
						m_gkcontext.m_UIs.heroRally.updataRecord(false,m_recordList[m_recordList.length-1]);
					}
				}
				else
				{
					if (m_recordList.length >= 3)
					{
						m_recordList.shift();
					}
					var field:FieldData = new FieldData(m_gkcontext);
					field.setdata(rev.m_userZhanJi);
					m_recordList.push(field);
					if (m_gkcontext.m_UIs.heroRally)
					{
						m_gkcontext.m_UIs.heroRally.updataRecord(true,field);
					}
				}
			}
			showScreenBtnAni();
		}
		/**
		 * 我的战绩宝箱领取
		 */
		public function process_stGetVicBoxCmd(byte:ByteArray, param:uint):void
		{
			var rev:stGetVicBoxCmd = new stGetVicBoxCmd();
			rev.deserialize(byte);
			var fieldNum:uint;
			var bracketNum:uint;
			for (var i:uint = 0; i < m_recordList.length; i++ )
			{
				var num:uint = (m_recordList[i] as FieldData).setBoxState(rev.m_zhanjiId);
				if (num != 3)
				{
					fieldNum = i;
					bracketNum = num;
					break;
				}
			}
			showScreenBtnAni();
			if (m_gkcontext.m_UIs.heroRally)//一定打开
			{
				m_gkcontext.m_UIs.heroRally.upDataBox(fieldNum, bracketNum);
			}
		}
		
		/**
		 * 按钮特效显示
		 */
		private function showScreenBtnAni():void
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_SGQunyinghui, whetherShowEffect());
			}
		}
		/**
		 * 按钮是否显示特效
		 * @return true：显示
		 */
		public function whetherShowEffect():Boolean
		{	
			if (m_isAct)
			{
				return true;
			}
			for each(var item:FieldData in m_recordList)
			{
				if (item.showEffect())
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 过滤消息发来的战绩列表中不显示在界面的条目，并填充空缺位置
		 */
		private function swithToEffect(revarr:Array):Array
		{
			var sortOnTime:Function = function(a:UserZhanJi, b:UserZhanJi):Number
			{
				if (a.m_time <= b.m_time)
					return 1;
				else
					return -1;
			}
			revarr.sort(sortOnTime);//传来的数据按时间降序排列，最新数据index为0
			var fieldDataList:Array = new Array();
			for (var i:uint = 0; i < revarr.length; i++ )
			{
				if (FieldData.EffectiveData(m_gkcontext, revarr[i]))
				{
					var createnew:Boolean = true;
					for (var j:uint = 0; j < fieldDataList.length; j++ )
					{
						if ((fieldDataList[j] as FieldData).isThisField(revarr[i]))
						{
							createnew = false;
							(fieldDataList[j] as FieldData).setdata(revarr[i]);
							break;
						}
					}
					if (createnew)
					{
						if (fieldDataList.length >= 3)
						{
							return fieldDataList;
						}
						var field:FieldData = new FieldData(m_gkcontext);
						field.setdata(revarr[i]);
						fieldDataList.unshift(field);
					}
				}
			}
			return fieldDataList;
		}
		/**
		 * 获取级段信息
		 * @param	groupid默认为玩家自身区段
		 */
		public function groupIfor(groupid:uint=0):groupInfo
		{
			if (groupid == 0)
			{
				groupid = m_curgroup;
			}
			return m_groupInfoDic[groupid];
		}
		public function get timeParam():Dictionary
		{
			if (!m_FieldTimeDic)
			{
				loadConfig();
			}
			return m_FieldTimeDic;
		}
		public function get userInfo():MatchUserInfo
		{
			return m_userInfo;
		}
		/**
		 * 返回界面显示的 包含前端补充的信息
		 */
		public function get recordList():Array
		{
			return m_recordList;
		}
		public function get rule():String
		{
			return m_rule;
		}
		/**
		 * 我的排行 0未上榜
		 */
		public function get rank():uint
		{
			return m_rank;
		}
		public function get score():String
		{
			return m_score.toString();
		}
		public function get curgroupid():uint
		{
			return m_curgroup;
		}
		/**
		 * 级段id数组 排行界面翻页使用
		 */
		public function get grouparr():Array
		{
			var arr:Array = new Array();
			for each(var item:groupInfo in m_groupInfoDic)//根据配置需求排序 
			{
				arr.push(item.m_id);
			}
			return arr;
		}
		public function process7ClockUserCmd():void
		{
			if (m_gkcontext.m_UIs.heroRally && m_gkcontext.m_UIs.heroRally.isVisible())
			{
				m_gkcontext.m_UIs.heroRally.addDingshiqi();
			}
			addDingshiqi();
		}
		/**
		 * 添加定时器 为了处于活动时间时显示screenbtn效果 服务器不好做
		 */
		public function addDingshiqi():void
		{
			loadConfig();
			var vec:Vector.<TimeItem> = new Vector.<TimeItem>();
			for each(var item:FieldTimeParam in m_gkcontext.m_heroRallyMgr.timeParam)
			{
				var setimelist:Array = item.m_timearea.split("-");
				var timeitem:TimeItem = new TimeItem();
				timeitem.parse_hourAndMinute(setimelist[0]);
				vec.push(timeitem);
				timeitem = new TimeItem();
				timeitem.parse_hourAndMinute(setimelist[1]);
				vec.push(timeitem);
			}
			var serverTimeNow:TimeL = m_gkcontext.m_context.m_timeMgr.getServerTimeL();
			var timeNowSecond:Number = serverTimeNow.m_hour * 3600 + serverTimeNow.m_minute * 60 + serverTimeNow.m_second;
			var data:Object = new Object();//携带参数 1：活动是否开始bool 2：第几场
			if (7 * 3600 <= timeNowSecond && timeNowSecond < vec[0].elpasedTimeToZero)//上午场开始
			{
				m_isAct = false;
				var m_dingshiItem:TimeItem = vec[0];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else if (vec[0].elpasedTimeToZero <= timeNowSecond && timeNowSecond < vec[1].elpasedTimeToZero)//上午场结束
			{
				m_isAct = true;
				m_dingshiItem = vec[1];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else if (vec[1].elpasedTimeToZero <= timeNowSecond && timeNowSecond < vec[2].elpasedTimeToZero)//下午场开始
			{
				m_isAct = false;
				m_dingshiItem = vec[2];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else if (vec[2].elpasedTimeToZero <= timeNowSecond && timeNowSecond < vec[3].elpasedTimeToZero)//下午场结束
			{
				m_isAct = true;
				m_dingshiItem = vec[3];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else if (vec[3].elpasedTimeToZero <= timeNowSecond && timeNowSecond < vec[4].elpasedTimeToZero)//晚场开始
			{
				m_isAct = false;
				m_dingshiItem = vec[4];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else if (vec[4].elpasedTimeToZero <= timeNowSecond && timeNowSecond < vec[5].elpasedTimeToZero)//晚场结束
			{
				m_isAct = true;
				m_dingshiItem = vec[5];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, showEffByTime);
			}
			else
			{
				m_isAct = false;
			}
		}
		/**
		 * 根据时间显示screenbtn效果
		 * @param	data
		 */
		private function showEffByTime(data:Object):void
		{
			addDingshiqi();
			showScreenBtnAni();
		}
	}

}