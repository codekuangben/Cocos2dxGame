package game.ui.herorally.myrecord 
{
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.UserZhanJi;
	import modulecommon.scene.herorally.FieldData;
	import modulecommon.scene.herorally.FieldTimeParam;
	import time.TimeL;
	import time.TimeMgr;
	import time.UtilTime;
	
	/**
	 * ...
	 * @author 
	 */
	public class FieldItem extends CtrolVHeightComponent 
	{
		private var m_timeLabel:Label;
		private var m_state:Label;
		private var m_bureauItemList:Vector.<BureauItem>;
		private var m_gkcontext:GkContext;
		public function FieldItem(param:Object)
		{
			super();
			m_gkcontext = param.gk;
			m_timeLabel = new Label(this);
			//m_state = new Label(this, 145, 0, "进行中");//这个要定时
			m_bureauItemList = new Vector.<BureauItem>();
			for (var i:uint = 0; i < 3; i++ )
			{
				var bureauitem:BureauItem = new BureauItem(m_gkcontext, this, 0, 20 + i * 22);
				m_bureauItemList.push(bureauitem);
			}
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
			var fielddata:FieldData = _data as FieldData;
			for (var i:uint = 0; i < 3; i++ )
			{
				m_bureauItemList[i].setDatas(fielddata.m_list[i],i);
			}
			/*var week:Array = ["日", "一", "二", "三", "四", "五", "六"];
			var curday:TimeL = m_gkcontext.m_timeMgr.calendarToTimeL((_data[0] as UserZhanJi).m_time);
			var str:String = "  周" + week[TimeMgr.s_weekByDate(curday.m_year, curday.m_month, curday.m_date)];
			var bureauTime:Number = _data[0].m_time-UtilTime.s_getDay_0(_data[0].m_time);
			var num:Array = [ "上午场", "下午场", "晚场" ];
			for ( i = 0; i < 3; i++ )
			{
				var timeItem:FieldTimeParam = m_gkcontext.m_heroRallyMgr.timeParam[i];
				if (timeItem.m_startTime <= bureauTime && bureauTime <= timeItem.m_endTime)
				{
					str += "  " + num[i];
					break;
				}
			}*/
			m_timeLabel.text = fielddata.m_tittleSting;
			/*if ((_data[2] as UserZhanJi).m_result == 2)
			{
				m_state.visible = true;
			}
			else
			{
				m_state.visible = false;
			}*/
		}
		public function upDataBox(bracketnum:uint):void
		{
			m_bureauItemList[bracketnum].updataBox();
		}
	}

}