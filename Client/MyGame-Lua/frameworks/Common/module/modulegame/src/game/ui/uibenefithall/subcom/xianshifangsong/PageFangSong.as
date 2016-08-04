package game.ui.uibenefithall.subcom.xianshifangsong 
{
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import modulecommon.time.Daojishi;
	import com.bit101.components.Component;
	import time.TimeL;
	
	/**
	 * ...
	 * @author 
	 */
	public class PageFangSong extends PageBase 
	{
		private var m_list:ControlListVHeight;
		private var m_daojishi:Daojishi;
		private var m_lefttimebg:Panel;
		//private var m_timebg:Panel;
		private var m_letftimeList:Vector.<DigitComponent>;
		private var m_timeList:Vector.<DigitComponent>;
		private var m_pageid:int;
		public function PageFangSong(data:DataBenefitHall, parent:DisplayObjectContainer, pageid:int, xpos:Number = 0, ypos:Number = 0)
		{
			super(data, parent, xpos, ypos);
			m_pageid = pageid;
			
			this.setPanelImageSkin("module/benefithall/xianshifangsong/xianshibg.png");
			var bgpanel:Panel = new Panel(this,1,2);
			bgpanel.setPanelImageSkin("module/benefithall/xianshifangsong/bgonbg.png");
			var wordbg:Panel = new Panel(this,42,15);
			wordbg.setPanelImageSkin("module/benefithall/xianshifangsong/word" + pageid + ".png");
			var manbg:Panel = new Panel(this, 298,-60);
			manbg.setPanelImageSkin("module/benefithall/xianshifangsong/man" + pageid + ".png");
			m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.loadconfig();
			m_list = new ControlListVHeight(this,0,180);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = ItemFangSong;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_dataBenefitHall.m_gkContext;
			dataParam["parent"] = this;
			param.m_dataParam = dataParam;
			param.m_width = 634;
			param.m_height = 64;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_heightList = 320;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 0;
			param.m_bCreateScrollBar = true;
			m_list.setParam(param);
			m_list.setDatas(m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.m_LimitBigSendActItemListOfDay[pageid].m_LimitBigSendActItemList);
			m_daojishi = new Daojishi(m_dataBenefitHall.m_gkContext.m_context);
			m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_daojishi.funCallBack = TimeUpdate;
			sortListData();
			
			m_lefttimebg = new Panel(this);
			m_lefttimebg.setPanelImageSkin("module/benefithall/xianshifangsong/timebg.png");
			m_letftimeList = new Vector.<DigitComponent>();
			for (var i:uint = 0; i < 3; i++ )
			{
				var score:DigitComponent = new DigitComponent(m_dataBenefitHall.m_gkContext.m_context, this, 0, 3);
				score.align = Component.CENTER;
				score.setParam("commoncontrol/digit/digit02", 13, 25);
				m_letftimeList.push(score);
			}
			m_letftimeList[0].x = 136;
			m_letftimeList[1].x = 212;
			m_letftimeList[2].x = 300;			
			
			/*m_timebg = new Panel(this,234,113);
			m_timebg.setPanelImageSkin("module/benefithall/xianshifangsong/gettimebg.png")
			var startDate:TimeL = m_dataBenefitHall.m_gkContext.m_timeMgr.calendarToTimeL(m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.startTime(pageid));
			var endDate:TimeL = m_dataBenefitHall.m_gkContext.m_timeMgr.calendarToTimeL(m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.endTime(pageid));
			m_timeList = new Vector.<DigitComponent>();
			var timeNum:Array = new Array(startDate.m_month + 1, startDate.m_date, startDate.m_hour, endDate.m_month + 1, endDate.m_date, endDate.m_hour);
			var timePos:Array = new Array(107, 153, 204, 286, 332, 386);
			for (i = 0; i < 6; i++ )
			{
				score = new DigitComponent(m_dataBenefitHall.m_gkContext.m_context, this, timePos[i]+234, 116);
				score.align = Component.CENTER;
				score.setParam("commoncontrol/digit/digit02", 13, 25);
				score.digit = timeNum[i];
				m_timeList.push(score);
			}*/
		}
		override public function onShow():void 
		{
			super.onShow();
			if (m_daojishi)
			{
				m_daojishi.initLastTime_Second = m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.leftTime(m_pageid);
				m_daojishi.begin();
				m_daojishi.onTimeUpdate();
			}
			for (var i:uint = 0; i < m_list.controlList.length; i++)
			{
				m_list.controlList[i].updata();
			}
			//sortListData();
		}
		override public function onHide():void 
		{
			m_daojishi.pause();
			super.onHide();
		}
		private function TimeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
			updataLabel(m_daojishi.timeSecond);
		}
		private function updataLabel(time:Number):void
		{
			m_letftimeList[0].digit = Math.floor(time / (3600 * 24));
			m_letftimeList[1].digit = Math.floor((time % (3600 * 24)) / 3600);
			m_letftimeList[2].digit = Math.floor((time % 3600) / 60);
		}
		
		public function sortListData():void
		{
			m_list.sortList(sortMethod);
		}
		private function sortMethod(itemA:ItemFangSong,itemB:ItemFangSong):Number
		{
			if (itemA.over==itemB.over)
			{
				if (itemA.id > itemB.id)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else
			{
				if (itemA.over)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			return 0;
		}
		override public function updateData(param:Object = null):void 
		{
			var item:ItemFangSong = m_list.findCtrl(s_compare, param) as ItemFangSong;
			if (item)
			{
				var oldCanDuihuan:Boolean = item.over;
				item.updata();
				if (item.over ==true && oldCanDuihuan != item.over)
				{
					sortListData();
				}				
			}
		}
		private function s_compare(data:Object, param:Object):Boolean
		{
			if (data.m_id == param)
			{
				return true;
			}
			return false;
		}
		
	}

}