package game.ui.recharge 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.utils.UIConst;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.scene.prop.object.ObjectPanel;
	
	/**
	 * ...
	 * @author 
	 */
	public class SJItemOfHlist extends SJItemOfReward 
	{
		/**
		 * 父节点ui
		 */
		private var m_ui:UIRechatge;
		/**
		 * 当前这个元宝阀值的状态 0-未达到 1-已达到未领取 2-已领取
		 */
		private var m_state:int;
		/**
		 * 可领奖励时显示动画
		 */
		private var m_receivedAni:Ani;
		/**
		 * 当前序号
		 */
		private var m_index:int;
		public function SJItemOfHlist(param:Object=null)
		{
			super(param);
			m_ui = param.ui;
			buttonMode = true;
		}
		override public function setData(_data:Object):void
		{
			super.setData(_data);
			update();
		}
		override public function update():void 
		{
			m_index = m_ui.getSJItemIndex(this);
			m_state = m_gkcontext.m_rechargeRebateMgr.getSJItemState(m_index);
			if (m_state == 0)
			{
				
			}
			else if (m_state == 1)
			{
				/*if (!m_receivedAni)
				{
					m_receivedAni = new Ani(m_gkcontext.m_context);
					addChild(m_receivedAni);
					m_receivedAni.x = 32;
					m_receivedAni.y = 36;
					m_receivedAni.duration = 2;
					m_receivedAni.repeatCount = 0;
					m_receivedAni.centerPlay = true;
					m_receivedAni.mouseEnabled = false;
					m_receivedAni.setImageAni("ejwujiangzhuan.swf");
					m_receivedAni.setAutoStopWhenHide();
					m_receivedAni.begin();
				}*/
			}
			else
			{
				/*if (m_receivedAni)
				{
					m_receivedAni.parent.removeChild(m_receivedAni);
					m_receivedAni.disposeEx();
					m_receivedAni = null;
				}*/
				enabled = false;
				mouseEnabled = mouseChildren = true;
			}
			if (m_ui.m_curSelectIndex == m_index)
			{
				m_ui.setBtnState(m_state);
			}
		}
		override protected function setPanelAni():void 
		{
			if (m_itemData.m_type == 2)//武将类
			{
				
			}
			else
			{
				(m_rewardPanel as ObjectPanel).showFrame = false;
				addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
				addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
			}
		}
		override protected function onMouseRollOver(event:MouseEvent):void 
		{
			if (m_rewardPanel)
			{
				var pt:Point = localToScreen(new Point(m_rewardPanel.width, 20));
				UtilHtml.beginCompose();
				var str:String = UtilHtml.formatBold("充值" + m_gkcontext.m_rechargeRebateMgr.rebateItemList[m_index].m_numYB + "元宝奖励");
				UtilHtml.add(str, UtilColor.GOLD);
				m_gkcontext.m_uiTip.hintHtiml(pt.x,pt.y, UtilHtml.getComposedContent(),180, true);
			}
			if (!select && enabled)
			{
				filters=PushButton.s_funGetFilters(UIConst.EtBtnOver);
			}
		}
		override protected function setObjpanelBg():void 
		{
			var bg:Panel = new Panel(this, 0, 1);
			bg.setPanelImageSkin("module/benefithall/rebate/objbg.png");
		}
		override public function onSelected():void 
		{
			super.onSelected();
			m_ui.openRewardByIndex(m_index, m_state);
			m_ui.setBtnState(m_state);
			if (!m_receivedAni)
			{
				m_receivedAni = new Ani(m_gkcontext.m_context);
				addChild(m_receivedAni);
				m_receivedAni.x = 32;
				m_receivedAni.y = 36;
				m_receivedAni.duration = 2;
				m_receivedAni.repeatCount = 0;
				m_receivedAni.centerPlay = true;
				m_receivedAni.mouseEnabled = false;
				m_receivedAni.setImageAni("ejwujiangzhuan.swf");
				m_receivedAni.setAutoStopWhenHide();
				m_receivedAni.begin();
			}
			/*if (enabled)
			{
				filters=PushButton.s_funGetFilters(UIConst.EtBtnDown);
			}*/
		}
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			if (m_receivedAni)
			{
				m_receivedAni.parent.removeChild(m_receivedAni);
				m_receivedAni.disposeEx();
				m_receivedAni = null;
			}
			/*if (enabled)
			{
				filters = PushButton.s_funGetFilters(UIConst.EtBtnNormal);
			}*/
		}
		/*override public function onOut():void 
		{
			super.onOut();
			if (!select && enabled)
			{
				filters=PushButton.s_funGetFilters(UIConst.EtBtnNormal);
			}
			
		}
		override public function onOver():void 
		{
			super.onOver();
			if (!select && enabled)
			{
				filters=PushButton.s_funGetFilters(UIConst.EtBtnOver);
			}
		}*/
		override public function dispose():void 
		{
			if (m_receivedAni)
			{
				m_receivedAni.disposeEx();
			}
			super.dispose();
		}
		
	}

}