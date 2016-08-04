package game.ui.uiTeamFBSys.teamhall
{
	import com.ani.AniMiaobian;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.dailyactivities.ItemProps;
	import modulecommon.scene.benefithall.dailyactivities.Rewards;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import game.ui.uiTeamFBSys.msg.stGainTeamAssistGiftUserCmd;
	import game.ui.uiTeamFBSys.msg.stRetTeamAssistInfoUserCmd;
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * ...
	 * @author ...
	 * 活跃度奖励
	 */
	public class RewardBox extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		//private var m_reward:Rewards;
		private var m_boxPanel:Panel;
		private var m_actValueLabel:Label;
		//private var m_isReceive:Boolean;	//是否可领取奖励
		//private var m_value:uint;			//奖励宝箱对应活跃度值 例:10,40,70,100
		private var m_aniMiaobian:AniMiaobian;
		
		public function RewardBox(data:UITFBSysData, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			
			m_boxPanel = new Panel(this, 8, 0);
			m_boxPanel.addEventListener(MouseEvent.ROLL_OVER, onBoxRollOver);
			m_boxPanel.addEventListener(MouseEvent.ROLL_OUT, onBoxRollOut);
			m_boxPanel.addEventListener(MouseEvent.CLICK, onBoxClick);
			
			m_actValueLabel = new Label(this, 8, 42, "", UtilColor.GOLD);
			
			this.setSize(60, 60);
		}
		
		//public function setDatas(imagename:String, reward:Rewards):void
		public function setDatas(imagename:String):void
		{
			//m_reward = reward;
			//m_value = m_reward.m_value;
			
			m_boxPanel.setPanelImageSkin("commoncontrol/panel/box/" + imagename + ".png");
			//if (m_reward)
			//{
			//	m_actValueLabel.text = m_reward.m_value.toString() + "活跃";
			//}
			
			//updateBoxState(m_reward.m_bReceive);
		}
		
		//更新奖励宝箱状态显示  bReceive:是否已领取奖励 true已领取 false未领取
		public function updateBoxState(bReceive:Boolean):void
		{
			if (bReceive)
			{
				this.becomeGray();
				//m_isReceive = false;
				m_boxPanel.buttonMode = false;
				
				if (m_aniMiaobian)
				{
					m_aniMiaobian.stop();
					m_aniMiaobian.dispose();
					m_aniMiaobian = null;
				}
			}
			else// if (m_gkContext.m_dailyActMgr.m_actValue >= m_reward.m_value)
			{
				//m_isReceive = true;
				m_boxPanel.buttonMode = true;
				if (null == m_aniMiaobian)
				{
					m_aniMiaobian = new AniMiaobian();
					m_aniMiaobian.sprite = m_boxPanel;
					m_aniMiaobian.setParam(6, UtilColor.GREEN, 1, 5);
				}
				m_aniMiaobian.begin();
			}
		}
		
		private function onBoxRollOver(event:MouseEvent):void
		{
			//var panel:Panel = event.currentTarget as Panel;
			//panel.filtersAttr(true);
			//panel.scaleX = 1.1;
			//panel.scaleY = 1.1;
			//panel.setPos(8 - (panel.width * 0.1) / 2, 0 - (panel.height * 0.1) / 2);
			
			//var str:String;
			//var propslist:Vector.<ItemProps>;
			//var obj:ZObject;
			//UtilHtml.beginCompose();
			//UtilHtml.add(m_reward.m_value + "活跃奖励：", UtilColor.GOLD, 14);
			//UtilHtml.breakline();
			//propslist = m_reward.m_vecProps;
			//for (var i:int = 0; i < propslist.length; i++)
			//{
			//	obj = ZObject.createClientObject(propslist[i].m_id);
			//	UtilHtml.add(obj.name, obj.colorValue, 14);
			//	UtilHtml.add(" x" + propslist[i].m_num + "      ", obj.colorValue, 12);
			//}
			
			//var pt:Point = this.localToScreen(new Point(50, 40));
			//m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent());
			
			if (!m_TFBSysData.m_gainflag)
			{
				return;
			}
			
			var pt:Point = m_boxPanel.localToScreen();
			
			var obj:ZObject = ZObject.createClientObject(m_TFBSysData.m_lastGiftId);
			if (obj != null)
			{
				m_TFBSysData.m_gkcontext.m_uiTip.hintObjectInfo(pt, obj);
			}
			
			//if (m_isReceive)
			//{
			//	m_boxPanel.buttonMode = true;
			//}
		}
		
		private function onBoxRollOut(event:MouseEvent):void
		{
			//if (event.currentTarget is Panel)
			//{
				//var panel:Panel = event.target as Panel;
				//panel.filtersAttr(false);
				//panel.scaleX = 1;
				//panel.scaleY = 1;
				//panel.setPos(8, 0);
			//}
			
			m_TFBSysData.m_gkcontext.m_uiTip.hideTip();

			//m_boxPanel.buttonMode = false;
		}
		
		private function onBoxClick(event:MouseEvent):void
		{
			//if (m_isReceive)
			//{
			//	var list:Array = new Array();
			//	list.push(m_reward.m_value);
			//	m_gkContext.m_dailyActMgr.getPerDayActiveRewards(list);
				
			//	m_reward.m_bReceive = true;
			//	this.becomeGray();
				
			//	if (m_aniMiaobian)
			//	{
			//		m_aniMiaobian.stop();
			//		m_aniMiaobian.dispose();
			//		m_aniMiaobian = null;
			//	}
			//}

			if (m_TFBSysData.m_lastGiftId)
			//if(hasExtraZHZ())
			{
				var idx:int = 1;
				if (m_TFBSysData.m_gainflag)	// 如果有值，需要从第一位开始查找，下标从 0 开始
				{
					while (idx < 32)
					{
						if (!(m_TFBSysData.m_gainflag & (1 << idx)))	// 找到第一个 0 
						{
							break;
						}
						
						++idx;
					}
				}
				else
				{
					idx = 1;
				}
				
				var cmd:stGainTeamAssistGiftUserCmd = new stGainTeamAssistGiftUserCmd();
				cmd.giftno = idx;
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
			}
		}
		
		//public function get actValue():uint
		//{
		//	return m_value;
		//}
		
		override public function dispose():void
		{
			if (m_aniMiaobian)
			{
				m_aniMiaobian.stop();
				m_aniMiaobian.dispose();
			}
			
			super.dispose();
		}
		
		public function psstRetTeamAssistInfoUserCmd(cmd:stRetTeamAssistInfoUserCmd):void
		{
			//if (!m_TFBSysData.m_lastGiftId)
			if(!hasExtraZHZ())
			{
				updateBoxState(true);
			}
			else
			{
				updateBoxState(false);
			}
		}
		
		public function psstGainTeamAssistGiftUserCmd(cmd:stGainTeamAssistGiftUserCmd):void
		{
			//m_TFBSysData.m_gainflag |= (1 << cmd.giftno);
			//if (!m_TFBSysData.m_lastGiftId)
			if(!hasExtraZHZ())
			{
				updateBoxState(true);
			}
			else
			{
				updateBoxState(false);
			}
		}
		
		// 是否有足够的祝福值
		public function hasExtraZHZ():Boolean
		{
			var idx:uint = 0;
			//var value:uint = 0;
			
			var valueVec:Vector.<uint> = new Vector.<uint>(5, true);
			valueVec[0] = 10;		// 10 的时候可以领取一个
			valueVec[1] = 30;		// 30 的时候可以领取一个
			valueVec[2] = 50;		// 50 的时候可以领取一个
			valueVec[3] = 70;		// 70 的时候可以领取一个
			valueVec[4] = 90;		// 90 的时候可以领取一个
			var valueidx:uint = 0;
			
			while (idx < 32)
			{
				if (m_TFBSysData.m_gainflag & (1 << idx))
				{
					//value += valueVec[valueidx];
					
					++valueidx;
				}
				
				++idx;
			}
			
			if (valueidx < 5)
			{
				if (m_TFBSysData.m_assistv >= valueVec[valueidx])
				{
					return true;
				}	
			}
			
			return false;
		}
	}
}