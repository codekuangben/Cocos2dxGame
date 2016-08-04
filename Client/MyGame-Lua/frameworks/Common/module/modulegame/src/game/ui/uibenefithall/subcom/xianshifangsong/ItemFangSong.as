package game.ui.uibenefithall.subcom.xianshifangsong 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibenefithall.subcom.xianshifangsong.msg.stReqGetLBSARewardCmd;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.stLimitBigSendItem;
	import modulecommon.scene.benefithall.LimitBigSendAct.LimitBigSendActItem;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import com.bit101.components.Component;
	
	/**
	 * ...
	 * @author 
	 */
	public class ItemFangSong extends CtrolVHeightComponent 
	{
		private var m_gkContext:GkContext;
		private var m_parent:PageFangSong;
		private var m_nameLabel:Label;
		private var m_ruleBtn:ButtonText;
		private var m_rulestr:String;
		private var m_jinduLabel:Label;
		private var m_duihuanLabel:Label;
		private var m_button:PushButton;
		private var m_data:LimitBigSendActItem;
		private var m_objList:Vector.<ObjectPanel>;
		private var m_objPanel:com.bit101.components.Panel
		private var m_progress:uint//当前进度
		private var m_bOver:Boolean;	//true - 变灰置底 即剩余兑换次数不为零且与总兑换次数相等时 剩余兑换次数为零是无限次 
		
		public function ItemFangSong(param:Object=null) 
		{
			super();
			this.setPanelImageSkin("module/benefithall/xianshifangsong/xianshiitembg.png");
			m_gkContext = param.gk as GkContext;
			m_parent = param.parent as PageFangSong;
			m_nameLabel = new Label(this, 112, 16, "", UtilColor.YELLOW);
			m_nameLabel.align = Component.CENTER;
			m_jinduLabel = new Label(this, 112, 32, "", UtilColor.WHITE3);
			m_jinduLabel.align = Component.CENTER;
			m_duihuanLabel = new Label(this, 426, 32, "", UtilColor.GRAY);
			m_duihuanLabel.align = Component.CENTER;
			m_button = new PushButton(this,500, 15, btnfunc);
			m_objList = new Vector.<ObjectPanel>();
			m_ruleBtn = new ButtonText(this, 395, 16, "规则");
			m_ruleBtn.normalColor = UtilColor.YELLOW;
			m_ruleBtn.overColor = UtilColor.GREEN;
			m_ruleBtn.setSize(60, 20);
			m_ruleBtn.letterSpacing = 1;
			m_ruleBtn.labelComponent.underline = true;
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OUT, m_gkContext.hideTipOnMouseOut);
			m_bOver = false;
			
		}
		override public function setData(data:Object):void 
		{
			super.setData(data);
			m_data = data as LimitBigSendActItem;
			m_nameLabel.text = m_data.m_name;
			m_rulestr = m_data.m_rule;
			var op:ObjectPanel;
			var x:uint = 321-26*m_data.m_objList.length;
			var y:uint = 9;
			var xv:uint = 52;
			for each(var obj:Object in m_data.m_objList)//按照for each结构读取顺序应该正确，若不正确需要显示排序*****这里仅仅考虑奖励物品为物品种类
			{
				op = new ObjectPanel(m_gkContext, this, x, y);
				x += xv;
				op.setPanelImageSkin(ZObject.IconBg);
				var objZ:ZObject = ZObject.createClientObject(obj.m_id, obj.m_num, obj.m_upgrade);
				op.objectIcon.showNum = true;
				op.showObjectTip = true;
				op.objectIcon.setZObject(objZ);
			}
			updata(true);
		}
		override public function dispose():void 
		{
			if (m_ruleBtn)
			{
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OUT, m_gkContext.hideTipOnMouseOut);
			}
			super.dispose();
		}
		private function isbecomeGray():void
		{			
			mouseChildren = false;
			becomeGray();			
		}
		
		private function buttonState(btnIsEnable:Boolean):void
		{
			if (btnIsEnable)
			{
				m_button.setSkinButton1Image("module/benefithall/xianshifangsong/btnable.png");
				m_button.enabled = true;
			}
			else
			{
				m_button.setSkinButton1Image("module/benefithall/xianshifangsong/btnunable.png");
				m_button.enabled = false;
			}
		}
		public function updata(bool:Boolean = false):void 
		{
			var oldButtonEnable:Boolean = m_button.enabled;
			var itemInfo:stLimitBigSendItem = m_gkContext.m_LimitBagSendMgr.LimitBigSendItemList(m_data.m_id);
			if (itemInfo)
			{
				m_progress = itemInfo.m_progress - itemInfo.m_rewardtimes * m_data.m_condition;
				if (m_data.m_rewardtimes==0)
				{
					m_duihuanLabel.text = "可兑换无数次";
				}
				else
				{
					m_duihuanLabel.text = "可兑换 " + (m_data.m_rewardtimes - itemInfo.m_rewardtimes) + "次";
					if (m_data.m_rewardtimes == itemInfo.m_rewardtimes)
					{
						m_bOver = true;
					}
				}
			}
			else
			{
				m_progress = 0;
				if (m_data.m_rewardtimes==0)
				{
					m_duihuanLabel.text = "可兑换无数次";
				}
				else
				{
					m_duihuanLabel.text = "可兑换 " + m_data.m_rewardtimes + "次";
				}
			}
			
			var newButtonEnable:Boolean;
			if (m_progress >= m_data.m_condition && (m_data.m_rewardtimes != itemInfo.m_rewardtimes || m_data.m_rewardtimes == 0))
			{
				newButtonEnable = true;
			}
			else
			{
				newButtonEnable = false;
			}
			
			m_jinduLabel.text = "进度 " + m_progress + "/" + m_data.m_condition;
			
			if (m_bOver)
			{
				isbecomeGray();
			}
			
			if (bool || oldButtonEnable != newButtonEnable)
			{
				buttonState(newButtonEnable);
			}
		
		}
		private function onRuleMouseEnter(e:MouseEvent):void
		{
			var str:String = m_rulestr;
			if (str)
			{
				var pt:Point = m_ruleBtn.localToScreen();
				pt.x -= 5;
				pt.y += 20;
				m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, str);
			}
		}
		private function btnfunc(e:MouseEvent):void
		{
			var send:stReqGetLBSARewardCmd = new stReqGetLBSARewardCmd();
			send.m_actid = m_data.m_id;
			m_gkContext.sendMsg(send);
		}
		
		public function get over():Boolean
		{
			return m_bOver;
		}
		
		public function get id():int
		{
			return m_data.m_index;
		}
		
	}

}