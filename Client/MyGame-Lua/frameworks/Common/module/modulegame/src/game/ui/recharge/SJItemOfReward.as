package game.ui.recharge 
{
	import com.bit101.components.Ani;
	import com.bit101.components.controlList.CtrolHComponent;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.rebate.RechargeRebateObj;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	/**
	 * 奖励区的一个物品
	 * @author 
	 */
	public class SJItemOfReward extends CtrolHComponent 
	{
		/**
		 * 物品数据
		 */
		protected var m_itemData:RechargeRebateObj;
		/**
		 * 物品icon面板
		 */
		protected var m_rewardPanel:PanelContainer;
		/**
		 * 公共字段
		 */
		protected var m_gkcontext:GkContext
		/**
		 * 特效
		 */
		private var m_ani:Ani;
		public function SJItemOfReward(param:Object=null) 
		{
			super(param);
			m_gkcontext = param.gk;
			mouseEnabled = false;
			
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
			m_itemData = m_data as RechargeRebateObj;
			clearContainer();
			var rewardPanelleft:uint = 6;
			var rewardPaneltop:uint = 15;
			if (m_itemData.m_type == 2)//武将类
			{
				m_rewardPanel = new PanelContainer(this, rewardPanelleft -5, rewardPaneltop - 15);
				m_rewardPanel.setPanelImageSkin(m_gkcontext.m_npcBattleBaseMgr.squareHeadResName(m_itemData.m_id));
				m_rewardPanel.setLiuguangParam(2, 6, -2, 1.5, -100, 400);
				m_rewardPanel.beginLiuguang();
				if (m_itemData.m_upgrade > 0)
				{
					var addNamePanel:Panel = new Panel(m_rewardPanel, -2, -2);
					var arr:Array = ["icon.gui", "icon.xian","icon.shen"];
					addNamePanel.setPanelImageSkin(arr[m_itemData.m_upgrade-1]);
				}
				m_rewardPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
				m_rewardPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);
				
			}
			else//物品类
			{
				setObjpanelBg();
				m_rewardPanel = new ObjectPanel(m_gkcontext, this, rewardPanelleft , rewardPaneltop);
				m_rewardPanel.setPanelImageSkin(ZObject.IconBg);
				var objZ:ZObject = ZObject.createClientObject(m_itemData.m_id, m_itemData.m_num, m_itemData.m_upgrade);
				if (m_itemData.m_num == 1)
				{
					(m_rewardPanel as ObjectPanel).objectIcon.showNum = false;
				}
				else
				{
					(m_rewardPanel as ObjectPanel).objectIcon.showNum = true;
				}
				(m_rewardPanel as ObjectPanel).objectIcon.setZObject(objZ);
				
				
			}
			setPanelAni();
		}
		/**
		 * 设置物品武将的特效
		 */
		protected function setPanelAni():void
		{
			if (m_itemData.m_type == 2)//武将类
			{
				m_ani = new Ani(m_gkcontext.m_context);
				m_rewardPanel.addChild(m_ani);
				m_ani.x = 30;
				m_ani.y = 37;
				m_ani.duration = 2;
				m_ani.repeatCount = 0;
				m_ani.centerPlay = true;
				m_ani.setImageAni("ejwujiangzhuan.swf");
				m_ani.setAutoStopWhenHide();
				m_ani.begin();
			}
			else
			{
				(m_rewardPanel as ObjectPanel).showObjectTip = true;	
				m_ani = new Ani(m_gkcontext.m_context);
				m_rewardPanel.addChild(m_ani);
				m_ani.x = 23;
				m_ani.y = 23;
				m_ani.duration = 2;
				m_ani.repeatCount = 0;
				m_ani.centerPlay = true;
				m_ani.mouseEnabled = false;
				m_ani.setImageAni(ZObjectDef.getObjAniResName(m_itemData.m_anicolor));
				m_ani.setAutoStopWhenHide();
				m_ani.begin();
			}
		}
		/**
		 * 设置物品背景底
		 */
		protected function setObjpanelBg():void
		{
			
		}
		/**
		 * 更新奖励区时先清除原来的数据特效
		 */
		private function clearContainer():void
		{
			if (!m_rewardPanel)
			{
				return
			}
			if (m_rewardPanel.parent)
			{
				m_rewardPanel.parent.removeChild(m_rewardPanel);
			}
			m_rewardPanel.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_rewardPanel.removeEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);	
			m_rewardPanel.dispose();
			m_rewardPanel = null;
		}
		/**
		 * 鼠标移到icon上显示tips
		 * @param	event
		 */
		protected function onMouseRollOver(event:MouseEvent):void
		{
			if (event.currentTarget is ObjectPanel)
			{
				return;
			}
			if (m_rewardPanel && m_itemData.m_id != 0)
			{
				var pt:Point = m_rewardPanel.localToScreen(new Point(m_rewardPanel.width, 0));
				m_gkcontext.m_uiTip.hintWuBaseInfo(pt, m_itemData.m_id);
			}
		}
		override public function dispose():void 
		{
			if (m_ani)
			{
				m_ani.disposeEx();
			}
			if (m_rewardPanel)
			{
				m_rewardPanel.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
				m_rewardPanel.removeEventListener(MouseEvent.ROLL_OUT, m_gkcontext.hideTipOnMouseOut);	
			}
			super.dispose();
		}
	}

}