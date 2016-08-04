package game.ui.herorally 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.ui.herorally.bracket.BracketComponent;
	import game.ui.herorally.msg.stReqQunYingHuiRankCmd;
	import game.ui.herorally.myrecord.RecordComponent;
	import modulecommon.net.msg.sgQunYingCmd.MatchUserInfo;
	import modulecommon.scene.herorally.FieldData;
	import modulecommon.scene.herorally.FieldTimeParam;
	import modulecommon.time.TimeItem;
	import time.TimeL;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHeroRally;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIHeroRally extends Form implements IUIHeroRally
	{
		private var m_record:RecordComponent;
		private var m_bracket:BracketComponent;
		private var m_vsHero:HeroHalfImage;
		private var m_myBracketLabel:Label;
		private var m_fieldTimeArea:Vector.<Label>;
		private var m_dingshiAct:uint;//0-开始 1-匹配完 2-结束
		private var m_dingshiFieldNum:uint;//场数
		private var m_dingshiItem:TimeItem;
		private var m_yugaoTime:Label;
		public function UIHeroRally() 
		{
			super();
			draggable = false;
			this.id = UIFormID.UIHeroRally;
		}
		override public function onReady():void 
		{
			super.onReady();
			this.setSize(1332,654);
			this.alignVertial = CENTER;
			this.alignHorizontal = CENTER;
			m_gkcontext.m_UIs.heroRally = this;
			m_gkcontext.m_heroRallyMgr.loadConfig();
			m_myBracketLabel = new Label(this, 673, 13, "", UtilColor.YELLOW, 24);
			m_myBracketLabel.align = CENTER;
			if (m_gkcontext.m_heroRallyMgr.groupIfor())
			{
				m_myBracketLabel.text = m_gkcontext.m_heroRallyMgr.groupIfor().m_rankText;
			}
			var m_myHero:HeroHalfImage = new HeroHalfImage(m_gkcontext,false, this, 394, 113);
			m_myHero.setmydata();
			m_vsHero = new HeroHalfImage(m_gkcontext,true,this, 708, 221);
			var vsPanel:Panel = new Panel(this,550,170);//vs图片
			vsPanel.setPanelImageSkin("commoncontrol/panel/herorally/vs.png");
			for (var i:uint = 0; i < 3; i++ )//场次的时间区段
			{
				var label:Label = new Label(this, i * 276 + 482, 67, "", UtilColor.YELLOW);
				if (i == 1)
				{
					label.x = label.x + 14;
				}
				label.align = CENTER;
				label.text = m_gkcontext.m_heroRallyMgr.timeParam[i].m_timearea;
			}
			m_fieldTimeArea = new Vector.<Label>();
			for (i = 0; i < 3; i++ )//主角面板下方的时间提示
			{
				label = new Label(this, 475, i * 22 + 471, "", UtilColor.BLUE, 14);
				label.setLetterSpacing(1);
				m_fieldTimeArea.push(label);
			}
			m_yugaoTime = new Label(this, 646, 449, "", UtilColor.BLUE, 14)
			m_yugaoTime.setLetterSpacing(1);
			m_yugaoTime.align = RIGHT;
			m_record = new RecordComponent(m_gkcontext,this, 76, 150);
			m_record.setDatas(m_gkcontext.m_heroRallyMgr.recordList);
			m_bracket = new BracketComponent(m_gkcontext, this, 1018, 90);
			
			
		}
		override public function onShow():void 
		{
			super.onShow();
			if (m_gkcontext.m_heroRallyMgr.groupIfor())
			{
				var send:stReqQunYingHuiRankCmd = new stReqQunYingHuiRankCmd();
				send.m_rankNo = m_gkcontext.m_heroRallyMgr.groupIfor().m_id;
				m_gkcontext.sendMsg(send);
			}
			var serverTimeNow:TimeL = m_gkcontext.m_context.m_timeMgr.getServerTimeL();
			var timeNowSecond:Number = serverTimeNow.m_hour * 3600 + serverTimeNow.m_minute * 60 + serverTimeNow.m_second;
			var showLabel:Boolean = false;
			var num:Array = [ "一", "二", "三" ];
			var field:Array = ["上午场 匹配对手：","下午场 匹配对手：","晚场 匹配对手："];
			for (var i:uint = 0; i < 3; i++ )
			{
				var timeItem:FieldTimeParam = m_gkcontext.m_heroRallyMgr.timeParam[i];
				if (timeItem.m_startTime <= timeNowSecond && timeNowSecond <= timeItem.m_endTime)
				{
					if ( timeNowSecond < timeItem.m_startTime + 1800 )
					{
						m_vsHero.setdata(true, m_gkcontext.m_heroRallyMgr.userInfo,i);
					}
					else
					{
						m_vsHero.setdata(true, m_gkcontext.m_heroRallyMgr.userInfo);
					}
					showLabel = true;
					m_yugaoTime.text = field[i] + timeItem.m_pipeiTime;
					for (i = 0; i < 3; i++ )
					{
						m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeItem.m_fightTime[i];
					}
					break;
				}
			}
			if (!showLabel)
			{
				m_vsHero.setdata(false);
				var timeDic:Dictionary = m_gkcontext.m_heroRallyMgr.timeParam;
				if (timeNowSecond <= timeDic[0].m_endTime)
				{
					for (i = 0; i < 3; i++ )
					{
						m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeDic[0].m_fightTime[i];
					}
					m_yugaoTime.text = field[0] + timeDic[0].m_pipeiTime;
				}
				else if (timeNowSecond <= timeDic[1].m_endTime)
				{
					for (i = 0; i < 3; i++ )
					{
						m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeDic[1].m_fightTime[i];
					}
					m_yugaoTime.text = field[1] + timeDic[1].m_pipeiTime;
				}
				else if (timeNowSecond <= timeDic[2].m_endTime)
				{
					for (i = 0; i < 3; i++ )
					{
						m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeDic[2].m_fightTime[i];
					}
					m_yugaoTime.text = field[2] + timeDic[2].m_pipeiTime;
				}
				else
				{
					for (i = 0; i < 3; i++ )
					{
						m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeDic[0].m_fightTime[i];
					}
					m_yugaoTime.text = field[0] + timeDic[0].m_pipeiTime;
				}
			}
			addDingshiqi();
		}
		/**
		 * 开始定时器
		 */
		public function addDingshiqi():void
		{
			//loadConfig();
			var vec:Vector.<TimeItem> = new Vector.<TimeItem>();
			for each(var item:FieldTimeParam in m_gkcontext.m_heroRallyMgr.timeParam)
			{
				var setimelist:Array = item.m_timearea.split("-");
				var timeitem:TimeItem = new TimeItem();
				timeitem.parse_hourAndMinute(setimelist[0]);
				vec.push(timeitem);
				timeitem = new TimeItem();
				timeitem.parse_hourAndMinute(setimelist[0]);
				timeitem.min = timeitem.min + 30;//这里如果起始的分钟数大于30就有问题了 要改就改TimeItem类 这里暂时没有需求
				vec.push(timeitem);
				timeitem = new TimeItem();
				timeitem.parse_hourAndMinute(setimelist[1]);
				vec.push(timeitem);
			}
			var serverTimeNow:TimeL = m_gkcontext.m_context.m_timeMgr.getServerTimeL();
			var timeNowSecond:Number = serverTimeNow.m_hour * 3600 + serverTimeNow.m_minute * 60 + serverTimeNow.m_second;
			var data:Object = new Object();//携带参数 1：活动是否开始bool 2：第几场
			if (7 * 3600 < timeNowSecond && timeNowSecond < vec[0].elpasedTimeToZero)//上午场开始
			{
				m_dingshiAct = 0;
				m_dingshiFieldNum = 0;
				m_dingshiItem = vec[0];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[0].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[1].elpasedTimeToZero)//上午场匹配结束
			{
				m_dingshiAct = 1;
				m_dingshiItem = vec[1];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[1].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[2].elpasedTimeToZero)//上午场结束
			{
				m_dingshiAct = 2;
				m_dingshiFieldNum = 1;
				m_dingshiItem = vec[2];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[2].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[3].elpasedTimeToZero)//下午场开始
			{
				m_dingshiAct = 0;
				m_dingshiFieldNum = 1;
				m_dingshiItem = vec[3];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[3].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[4].elpasedTimeToZero)//下午场匹配结束
			{
				m_dingshiAct = 1;
				m_dingshiItem = vec[4];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[4].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[5].elpasedTimeToZero)//下午场结束
			{
				m_dingshiAct = 2;
				m_dingshiFieldNum = 2;
				m_dingshiItem = vec[5];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[5].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[6].elpasedTimeToZero)//晚场开始
			{
				m_dingshiAct = 0;
				m_dingshiFieldNum = 2;
				m_dingshiItem = vec[6];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[6].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[7].elpasedTimeToZero)//晚场匹配结束
			{
				m_dingshiAct = 1;
				m_dingshiItem = vec[7];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else if (vec[7].elpasedTimeToZero < timeNowSecond && timeNowSecond < vec[8].elpasedTimeToZero)//晚场结束
			{
				m_dingshiAct = 2;
				m_dingshiFieldNum = 0;
				m_dingshiItem = vec[8];
				m_gkcontext.m_dingshiqiMgr.addByTimeItem(m_dingshiItem, updataMidPart);
			}
			else
			{
				m_dingshiAct = 2;
			}
		}
		
		override public function onHide():void 
		{
			if (m_dingshiItem)
			{
				m_gkcontext.m_dingshiqiMgr.removeTimeItem(m_dingshiItem);
			}
			super.onHide();
		}
		override public function adjustPosWithAlign():void 
		{
			super.adjustPosWithAlign();
			adjustBothComPos();
		}
		private function adjustBothComPos():void
		{
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			if (widthStage <= 940)
			{
				m_record.x = 196;
				m_bracket.x = 858;
			}
			else if (widthStage >= 1240)
			{
				m_record.x = 46;
				m_bracket.x = 1008;
			}
			else
			{
				m_record.x = 46 + (1240-widthStage) / 2;
				m_bracket.x = 1008 - (1240-widthStage) / 2;
			}
		}
		/**
		 * 排行榜更新级段
		 */
		public function upDataGroup():void
		{
			if (m_gkcontext.m_heroRallyMgr.groupIfor())
			{
				m_myBracketLabel.text = m_gkcontext.m_heroRallyMgr.groupIfor().m_rankText;
			}
			m_bracket.upDataGroup();
		}
		public function processCmd(byte:ByteArray, param:uint):void
		{
			m_bracket.process_stRetQunYingHuiRankCmd(byte, param);
		}
		public function updataRecord(ispush:Boolean,arr:FieldData):void
		{
			m_record.upData(ispush, arr);
		}
		public function upDataBox(fieldnum:uint,bracketnum:uint):void
		{
			m_record.upDataBox(fieldnum, bracketnum);
		}
		private function updataMidPart(data:Object):void
		{
			if (m_dingshiAct == 0)
			{
				m_vsHero.setdata(true,m_gkcontext.m_heroRallyMgr.userInfo,m_dingshiFieldNum);
			}
			else if (m_dingshiAct == 1)
			{
				m_vsHero.setdata(true,m_gkcontext.m_heroRallyMgr.userInfo);
			}
			else
			{
				var timeItem:FieldTimeParam = m_gkcontext.m_heroRallyMgr.timeParam[m_dingshiFieldNum];
				var num:Array = [ "一", "二", "三" ];
				var field:Array = ["上午场 匹配对手：","下午场 匹配对手：","晚场 匹配对手："];
				m_vsHero.setdata(false);
				m_yugaoTime.text = field[m_dingshiFieldNum] + timeItem.m_pipeiTime;
				for (var i:uint = 0; i < 3; i++ )
				{
					m_fieldTimeArea[i].text ="第"+num[i]+"局 "+ timeItem.m_fightTime[i];
				}
			}
			addDingshiqi();
		}
		/**
		 * 收到对手信息立即显示，对手信息不会为null
		 */
		public function updataHalfImage():void
		{
			m_vsHero.setdata(true,m_gkcontext.m_heroRallyMgr.userInfo);
		}
		override public function dispose():void 
		{
			if (m_dingshiItem)
			{
				m_gkcontext.m_dingshiqiMgr.removeTimeItem(m_dingshiItem);
			}
			super.dispose();
		}
		
	}

}