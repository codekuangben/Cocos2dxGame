package game.ui.recharge 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.getRechargeBackRewardCmd;
	import modulecommon.scene.benefithall.rebate.RechargeRebateObj;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	
	/**
	 * ...
	 * @author 
	 */
	public class RechargeRebateItem extends CtrolVHeightComponent 
	{
		protected var m_gkcontext:GkContext;
		private var m_catchYBText:TextNoScroll;
		private var m_cumulativePanel:Panel;
		private var m_digitYB:DigitComponent;
		protected var m_btnReceive:PushButton;
		private var m_wuPanel:PanelContainer;
		private var m_wuid:uint;
		protected var m_id:uint;//条目id 发消息用
		private var m_bgPanel:Panel;
		public function RechargeRebateItem(param:Object=null) 
		{
			super();
			m_gkcontext = param.gk as GkContext;
			m_catchYBText = param.Text;
			m_catchYBText.x = 10;
			m_catchYBText.y = 84;
			m_bgPanel = new Panel(this, -2, 103);
			m_bgPanel.setPanelImageSkin("module/benefithall/rebate/itembg.png");
			
			m_cumulativePanel = new Panel(this, 7, 9);
			m_cumulativePanel.setPanelImageSkin("module/benefithall/rebate/ybbg.png");
			m_digitYB = new DigitComponent(m_gkcontext.m_context, m_cumulativePanel, 130, 26);
			m_digitYB.align = Component.RIGHT;
			m_digitYB.setParam("commoncontrol/digit/gambledigit", 22, 40);
			m_btnReceive = new PushButton(this, 513, 37, receiveClick);
			m_btnReceive.recycleSkins = true;
			//m_rewardList = new Vector.<PanelContainer>();
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
			m_id = m_data.m_id;
			m_digitYB.digit = m_data.m_numYB;
			updateBtn();
			
			var rewardPanelleft:uint = 227;
			var rewardPaneltop:uint = 31;
			var rewardPanelwidth:uint = 58;
			for (var i:uint = 0; i < m_data.m_rebateObjList.length; i++)
			{
				var item:RechargeRebateObj = m_data.m_rebateObjList[i];
				var rewardPanel:PanelContainer;
				if (item.m_type == 2)//武将类
				{
					rewardPanel = new PanelContainer(this, rewardPanelleft + i * rewardPanelwidth-5, rewardPaneltop-15);
					rewardPanel.setPanelImageSkin(m_gkcontext.m_npcBattleBaseMgr.squareHeadResName(item.m_id));
					rewardPanel.setLiuguangParam(2, 6, -2, 1.5, -100, 400);
					rewardPanel.beginLiuguang();
					if (item.m_upgrade > 0)
					{
						var m_addNamePanel:Panel = new Panel(rewardPanel, -2, -2);
						var arr:Array = ["icon.gui", "icon.xian","icon.shen"];//最多一个武将不提出去了
						m_addNamePanel.setPanelImageSkin(arr[item.m_upgrade-1]);
					}
					rewardPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
					rewardPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);	
					m_wuPanel = rewardPanel;
					m_wuid = item.m_id;
					m_ani = new Ani(m_gkcontext.m_context);
					rewardPanel.addChild(m_ani);
					m_ani.x = 30;
					m_ani.y = 37;
					m_ani.duration = 2;
					m_ani.repeatCount = 0;
					m_ani.centerPlay = true;
					m_ani.mouseEnabled = false;
					m_ani.setImageAni("ejwujiangzhuan.swf");
					m_ani.setAutoStopWhenHide();
					m_ani.begin();
				}
				else//物品类
				{
					rewardPanel = new ObjectPanel(m_gkcontext, this, rewardPanelleft + i * rewardPanelwidth, rewardPaneltop);
					rewardPanel.setPanelImageSkin(ZObject.IconBg);
					var objZ:ZObject = ZObject.createClientObject(item.m_id, item.m_num, item.m_upgrade);
					if (item.m_num == 1)
					{
						(rewardPanel as ObjectPanel).objectIcon.showNum = false;
					}
					else
					{
						(rewardPanel as ObjectPanel).objectIcon.showNum = true;
					}
					(rewardPanel as ObjectPanel).objectIcon.setZObject(objZ);
					(rewardPanel as ObjectPanel).showObjectTip = true;	
					var m_ani:Ani = new Ani(m_gkcontext.m_context);
					rewardPanel.addChild(m_ani);
					m_ani.x = 23;
					m_ani.y = 23;
					m_ani.duration = 2;
					m_ani.repeatCount = 0;
					m_ani.centerPlay = true;
					m_ani.mouseEnabled = false;
					m_ani.setImageAni(ZObjectDef.getObjAniResName(item.m_anicolor));
					m_ani.setAutoStopWhenHide();
					m_ani.begin();
				}
				//m_rewardList.push(rewardPanel);
			}
			
		}
		protected function updateBtn():void
		{
			if (m_gkcontext.m_rechargeRebateMgr.isReceived(m_id))//已经领取过
			{
				updateBtnToReceive();
			}
			else 
			{
				updateNoReceiveBtn();
			}
		}
		protected function receiveClick(e:MouseEvent):void
		{
			var send:getRechargeBackRewardCmd = new getRechargeBackRewardCmd();
			send.m_index = m_id;
			m_gkcontext.sendMsg(send);
		}
		public function updateNoReceiveBtn():void
		{
			if (m_gkcontext.m_rechargeRebateMgr.cumulativeYB >= m_data.m_numYB)
			{
				m_btnReceive.setSkinButton1Image("module/benefithall/xianshifangsong/btnable.png");
				m_btnReceive.enabled = true;
			}
			else
			{
				m_btnReceive.setSkinButton1Image("module/benefithall/rebate/btnnotcatch.png");
				m_btnReceive.enabled = false;
			}
		}
		public function updateBtnToReceive():void
		{
			m_btnReceive.setSkinButton1Image("module/benefithall/rebate/btnreceived.png");
			m_btnReceive.enabled = false;
		}
		private function onMouseRollOver(event:MouseEvent):void
		{
			if (event.currentTarget != m_wuPanel)
			{
				return;
			}
			if (m_wuPanel && m_wuid != 0)
			{
				var pt:Point = m_wuPanel.localToScreen(new Point(m_wuPanel.width, 0));
				m_gkcontext.m_uiTip.hintWuBaseInfo(pt, m_wuid);
			}
		}
		public function onShowNext():void 
		{
			super.onSelected();
			addChild(m_catchYBText);
		}
		public function onNotShowNext():void 
		{
			super.onNotSelected();
			removeChild(m_catchYBText);
		}
	}

}