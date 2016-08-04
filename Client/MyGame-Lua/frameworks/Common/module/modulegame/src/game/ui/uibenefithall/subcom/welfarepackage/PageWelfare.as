package game.ui.uibenefithall.subcom.welfarepackage 
{
	import com.bit101.components.Component;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.welfarepackage.WelfarePackageMgr;
	import time.TimeL;
	
	/**
	 * ...
	 * @author 
	 */
	public class PageWelfare extends PageBase 
	{
		private var m_welfareControlList:Dictionary;
		private var m_gkcontext:GkContext;
		//private var m_timebg:Panel;
		private var m_timeList:Vector.<DigitComponent>;
		private var m_buyTimeLabel:Label2;
		public function PageWelfare(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, xpos, ypos);
			m_gkcontext = data.m_gkContext;
			/*m_timebg = new Panel(this);
			m_timebg.setPanelImageSkin("module/benefithall/welfarepackage/timebg.png")*/
			this.setPanelImageSkin("module/benefithall/welfarepackage/welfarebg.png");
			m_welfareControlList = new Dictionary();
			var buyImagePath:String = "module/benefithall/welfarepackage/one.png";
			var receiveImagePath:String = "module/benefithall/welfarepackage/onedaily.png";
			m_welfareControlList[WelfarePackageMgr.WELFARE_TYPE_ONE] = new WelfareStateControl(WelfarePackageMgr.WELFARE_TYPE_ONE, buyImagePath, receiveImagePath,m_gkcontext ,this, 50, 270);
			buyImagePath = "module/benefithall/welfarepackage/five.png";
			receiveImagePath = "module/benefithall/welfarepackage/fivedaily.png";
			m_welfareControlList[WelfarePackageMgr.WELFARE_TYPE_FIV] = new WelfareStateControl(WelfarePackageMgr.WELFARE_TYPE_FIV, buyImagePath, receiveImagePath,m_gkcontext ,this, 380, 270);
			/*var startDate:TimeL = m_gkcontext.m_timeMgr.calendarToTimeL(m_gkcontext.m_welfarePackageMgr.m_actStartTime);
			var endBuyDate:TimeL = m_gkcontext.m_timeMgr.calendarToTimeL(m_gkcontext.m_welfarePackageMgr.m_actStartTime+30*24*3600);
			var endDate:TimeL = m_gkcontext.m_timeMgr.calendarToTimeL(m_gkcontext.m_welfarePackageMgr.m_actEndTime);
			m_buyTimeLabel = new Label2(this, 0, 38);
			var lf:LabelFormat = new LabelFormat();
			lf.letterspace = 1;
			lf.text = "购买时间："+(startDate.m_month + 1) + "月" + startDate.m_date + "日" + startDate.m_hour + "时-" + (endBuyDate.m_month + 1) + "月" + endBuyDate.m_date + "日" + endBuyDate.m_hour + "时";
			m_buyTimeLabel.labelFormat = lf;
			m_timeList = new Vector.<DigitComponent>();
			var timeNum:Array = new Array(startDate.m_month + 1, startDate.m_date, startDate.m_hour, endDate.m_month + 1, endDate.m_date, endDate.m_hour);
			var timePos:Array = new Array(126, 186, 249, 333, 388, 451);
			for (var i:uint = 0; i < 6; i++ )
			{
				var score:DigitComponent = new DigitComponent(m_gkcontext.m_context, this, timePos[i], 3);
				score.align = Component.CENTER;
				score.setParam("commoncontrol/digit/digit02", 13, 25);
				score.digit = timeNum[i];
				m_timeList.push(score);
			}*/
			
		}
		override public function updateData(param:Object = null):void //负责选择某一个管理类
		{
			m_welfareControlList[param.m_type].operatePackage(param.m_op);
			//param.m_type  0 1
			//param.m_op  0换类 1领取 2跨日
		}
		
	}

}