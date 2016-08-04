package game.ui.uibenefithall.subcom.peoplerank.pagestyle1
{
	import com.bit101.components.controlList.CtrolHComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.hurlant.util.der.Integer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stReqGetFixLevelRewardCmd;
	import modulecommon.scene.benefithall.peoplerank.FixReward;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author
	 */
	public class FixAwardItem extends CtrolHComponent
	{
		public static const STATE_YiLingqu:int = 0; //已领取
		public static const STATE_KeLingqu:int = 1; //可领取
		public static const STATE_BuKeLingqu:int = 2; //不可领取
		
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks_Style1:Ranks_Style1;
		protected var m_fixReward:FixReward;
		protected var m_boxPanel:Panel;
		protected var m_titleLabel:Label;
		protected var m_lingquLabel:Label;
		protected var m_state:int;
		
		public function FixAwardItem(param:Object = null)
		{
			super(param);
			m_dataBenefitHall = param["data"];
			m_ranks_Style1 = param["ranks"];
			
			m_boxPanel = new Panel(this);
			m_boxPanel.recycleSkins = true;
			
			m_titleLabel = new Label(this, 28, -25);
			m_titleLabel.align = CENTER;
			m_titleLabel.setFontColor(UtilColor.WHITE_Yellow);
			m_lingquLabel = new Label(this, 28, 60);
			m_lingquLabel.align = CENTER;
			this.width = 56;
			
			m_state = -1;
		}
		
		override public function setData(_data:Object):void
		{
			super.setData(_data);
			m_fixReward = _data as FixReward;
			
			var str:String;
			switch (m_ranks_Style1.m_type)
			{
				case PeopleRankMgr.RANKTYPE_Level: 
					str = "主角" + m_fixReward.m_level + "级";
					break;
				case PeopleRankMgr.RANKTYPE_Zhanli: 
					str = "战力" + m_fixReward.m_level;
					break;
				case PeopleRankMgr.RANKTYPE_Guoguan: 
					str = "第" + m_fixReward.m_level + "层";
					break;
				case PeopleRankMgr.RANKTYPE_TeamGuoguan: 
					str = "第" + m_fixReward.m_level + "关";
					break;
			}
			m_titleLabel.text = str;
			update();
		}
		
		private function stateSwitch(oldState:int, newState:int):void
		{
			m_state = newState;
			if (newState == STATE_YiLingqu)
			{
				m_boxPanel.setPanelImageSkin("module/benefithall/peoplerank/boxopen.png");
			}
			else if (oldState == -1)
			{
				m_boxPanel.setPanelImageSkin("module/benefithall/peoplerank/boxclose.png");
			}
			
			var lingquText:String;
			var color:uint;
			if (newState != STATE_BuKeLingqu)
			{
				if (newState == STATE_YiLingqu)
				{
					lingquText = "已领取";
					color = UtilColor.RED;
				}
				else if (newState == STATE_KeLingqu)
				{
					lingquText = "可领取";
					color = UtilColor.GREEN;
				}
				
				m_lingquLabel.setFontColor(color);
				m_lingquLabel.text = lingquText;
			}
			
			if (newState == STATE_KeLingqu)
			{
				m_boxPanel.addEventListener(MouseEvent.CLICK, onBoxClick);
				m_boxPanel.buttonMode = true;
			}
			else
			{
				m_boxPanel.removeEventListener(MouseEvent.CLICK, onBoxClick);
				m_boxPanel.buttonMode = false;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var oldState:int = m_state;
			var newState:int;
			if (m_ranks_Style1.m_day > m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7)
			{
				newState = STATE_BuKeLingqu;
			}
			else
			{
				if (m_dataBenefitHall.m_gkContext.m_peopleRankMgr.isLingqu(m_ranks_Style1.m_day, m_fixReward.m_id))
				{
					newState = STATE_YiLingqu;
				}
				else
				{
					var curValue:int = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.getHistoryValue(m_ranks_Style1.m_day);
					if (m_fixReward.m_level <= curValue)
					{
						newState = STATE_KeLingqu;
					}
					else
					{
						newState = STATE_BuKeLingqu;
					}
				}
			}
			if (oldState != newState)
			{
				stateSwitch(oldState, newState);
			}
		
		}
		
		override public function onOut():void
		{
			super.onOut();
			m_boxPanel.filtersAttr(false);
			m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		}
		
		override public function onOver():void
		{
			super.onOver();
			m_boxPanel.filtersAttr(true);
			
			if (m_fixReward.m_tip)
			{
				var pt:Point = m_boxPanel.localToScreen();
				m_dataBenefitHall.m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, m_fixReward.m_tip, 266, true);
			}
		}
		
		private function onBoxClick(e:MouseEvent):void
		{
			var send:stReqGetFixLevelRewardCmd = new stReqGetFixLevelRewardCmd();
			send.m_day = m_ranks_Style1.m_day;
			send.m_flag = m_fixReward.m_id;
			m_dataBenefitHall.m_gkContext.sendMsg(send);
		}
	}

}