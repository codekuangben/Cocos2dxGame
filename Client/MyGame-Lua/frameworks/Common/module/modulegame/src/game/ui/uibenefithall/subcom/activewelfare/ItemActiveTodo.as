package game.ui.uibenefithall.subcom.activewelfare 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.dailyactivities.ItemToDo;
	import modulecommon.scene.benefithall.dailyactivities.TimeInterval;
	import time.TimeL;
	import time.UtilTime;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 活跃任务项
	 */
	public class ItemActiveTodo extends CtrolVHeightComponent
	{
		private var m_gkContext:GkContext;
		private var m_activetodopanel:ActiveTodoPanel;
		private var m_backPanel:Panel;					//背景
		private var m_nameLabel:Label;					//活跃任务名
		private var m_timeLabel:Label;					//活动时间
		private var m_todoLabel:Label;					//完成次数
		private var m_actValueLabel:Label;				//活跃值
		private var m_boxPanel:Panel;					//奖励宝箱
		private var m_tipDesc:String;
		private var m_itemtodo:ItemToDo;
		
		public function ItemActiveTodo(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;
			m_activetodopanel = param["actTodoPanel"] as ActiveTodoPanel;
			
			m_backPanel = new Panel(this, 0, 8);
			m_backPanel.autoSizeByImage = false;
			m_backPanel.setSize(625, 25);
			m_backPanel.setPanelImageSkinMirror("commoncontrol/panel/glodflightbottom.png", Image.MirrorMode_LR);
			
			m_nameLabel = new Label(this, 56, 10, "活跃任务", UtilColor.WHITE_Yellow);
			m_nameLabel.align = Component.CENTER;
			m_nameLabel.mouseEnabled = true;
			
			m_timeLabel = new Label(this, 189, 10, "活动时间", UtilColor.WHITE_Yellow);
			m_timeLabel.align = Component.CENTER;
			m_timeLabel.mouseEnabled = true;
			
			m_todoLabel = new Label(this, 310, 10, "0/0", UtilColor.WHITE_Yellow);
			m_todoLabel.align = Component.CENTER;
			m_todoLabel.mouseEnabled = true;
			
			m_actValueLabel = new Label(this, 442, 10, "活跃值", UtilColor.WHITE_Yellow);
			m_actValueLabel.align = Component.CENTER;
			m_actValueLabel.mouseEnabled = true;
			
			m_boxPanel = new Panel(this, 556, 8);
			m_boxPanel.setPanelImageSkin("commoncontrol/panel/box.png");
			m_boxPanel.addEventListener(MouseEvent.ROLL_OVER, onBoxRollOver);
			m_boxPanel.addEventListener(MouseEvent.ROLL_OUT, onBoxRollOut);
			
			this.buttonMode = true;
			this.setSize(625, 33);
			this.drawRectBG();
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_itemtodo = data as ItemToDo;
			
			update();
		}
		
		override public function update():void
		{
			m_nameLabel.text = m_itemtodo.m_name;
			m_timeLabel.text = getActTimeStr(m_itemtodo.m_vecTimes);
			m_actValueLabel.text = m_itemtodo.m_value.toString();
			
			if (m_itemtodo.bCompleted)
			{
				m_nameLabel.setFontColor(UtilColor.WHITE_B);
				m_timeLabel.setFontColor(UtilColor.WHITE_B);
				m_actValueLabel.setFontColor(UtilColor.WHITE_B);
				m_todoLabel.setFontColor(UtilColor.WHITE_B);
				m_todoLabel.text = "已完成";
			}
			else
			{
				m_todoLabel.text = m_itemtodo.m_curCounts + "/" + m_itemtodo.m_maxCounts;
			}
		}
		
		//获得活动时间状态
		private function getActTimeStr(vecTime:Vector.<TimeInterval>):String
		{
			var ret:String;
			
			if (null == vecTime)
			{
				return "全天";
			}
			
			var date:TimeL = m_gkContext.m_context.m_timeMgr.getServerTimeL();
			var i:int;
			var timeInterval:TimeInterval;
			
			for (i = 0; i < vecTime.length; i++)
			{
				timeInterval = vecTime[i];
				if (false == UtilTime.s_isGreaterOrEqualInDay(date, timeInterval.m_begin.hour, timeInterval.m_begin.min))
				{
					ret = timeInterval.timeStrHourMin;
					break;
				}
				else if (false == UtilTime.s_isGreaterOrEqualInDay(date, timeInterval.m_end.hour, timeInterval.m_end.min))
				{
					ret = "正在进行";
					break;
				}
			}
			
			if (null == ret)
			{
				ret = "已经结束";
			}
			
			return ret;
		}
		
		override public function onOver():void
		{
			var str:String = m_itemtodo.m_tips;
			var pt:Point = this.localToScreen(new Point(100, 0));
			
			m_gkContext.m_uiTip.hintCondense(pt, str);
			
			m_activetodopanel.showItemOverPanel(m_backPanel);
		}
		
		override public function onOut():void
		{
			m_gkContext.m_uiTip.hideTip();
			
			m_activetodopanel.hideItemOverPanel();
		}
		
		private function onClick(event:MouseEvent):void
		{
			m_activetodopanel.onClickItem(m_itemtodo.m_id);
			m_gkContext.m_uiTip.hideTip();
		}
		
		private function onBoxRollOver(event:MouseEvent):void
		{
			var pt:Point;
			var box:Panel = event.currentTarget as Panel;
			
			if (box)
			{
				box.filtersAttr(true);
				pt = box.localToScreen(new Point(22, -2));
				UtilHtml.beginCompose();
				UtilHtml.add(m_itemtodo.m_reward, UtilColor.WHITE_Yellow, 14);
				m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 200);
			}
		}
		
		private function onBoxRollOut(event:MouseEvent):void
		{
			var box:Panel = event.currentTarget as Panel;
			if (box)
			{
				box.filtersAttr(false);
			}
			
			m_gkContext.m_uiTip.hideTip();
		}
	}

}