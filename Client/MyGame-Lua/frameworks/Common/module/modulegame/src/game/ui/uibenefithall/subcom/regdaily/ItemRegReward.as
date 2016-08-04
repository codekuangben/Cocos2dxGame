package game.ui.uibenefithall.subcom.regdaily 
{
	import com.bit101.components.Component;
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
	/**
	 * ...
	 * @author ...
	 */
	public class ItemRegReward extends Component
	{
		private var m_gkContext:GkContext;
		private var m_regDailyPage:RegDailyPage;
		private var m_formPanel:Panel;
		private var m_boxPanel:Panel;
		private var m_level:uint;	//签到奖励等级 0、1、2、3、4对应2、5、10、17、26
		private var m_reward:Rewards;
		private var m_objList:Vector.<ZObject>;
		public var m_bHasReward:Boolean;	//是否已经领取奖励 true已领取 false 未领取
		
		public function ItemRegReward(gk:GkContext, regdailypage:RegDailyPage, parent:DisplayObjectContainer) 
		{
			super(parent);
			m_gkContext = gk;
			m_regDailyPage = regdailypage;
			
			m_formPanel = new Panel(this, 0, 0);
			m_boxPanel = new Panel(this, 3, 13);
			m_objList = new Vector.<ZObject>();
			
			this.setSize(50, 58);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public function initData(name:String, level:uint, data:Rewards):void
		{
			m_level = level;
			m_reward = data;
			
			m_formPanel.setPanelImageSkin("commoncontrol/panel/rewardForm/" + name + ".png");
			m_boxPanel.setPanelImageSkin("commoncontrol/panel/box/" + name + ".png");
			
			var i:int;
			var itemprops:ItemProps;
			var obj:ZObject;
			for (i = 0; i < m_reward.m_vecProps.length; i++)
			{
				itemprops = m_reward.m_vecProps[i];
				obj = ZObject.createClientObject(itemprops.m_id, itemprops.m_num, itemprops.m_upgrade);
				m_objList.push(obj);
			}
			
			if (data.m_bReceive)
			{
				setBoxFromGray();
			}
			
			this.tag = m_reward.m_value;
		}
		
		public function onShowRegRewards():void
		{
			m_regDailyPage.onSelectRegRewardsBox(this, 26, 34);
			m_regDailyPage.onShowRegRewards(m_objList, m_reward.m_value);
		}
		
		private function onClick(event:MouseEvent):void
		{
			onShowRegRewards();
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			var str:String;
			var propslist:Vector.<ItemProps>;
			var obj:ZObject;
			UtilHtml.beginCompose();
			UtilHtml.add(m_reward.m_value + "次签到奖励：", UtilColor.GOLD, 14);
			UtilHtml.breakline();
			propslist = m_reward.m_vecProps;
			for (var i:int = 0; i < propslist.length; i++)
			{
				obj = ZObject.createClientObject(propslist[i].m_id);
				UtilHtml.add(obj.name, obj.colorValue, 14);
				UtilHtml.add(" x" + propslist[i].m_num + "      ", obj.colorValue, 12);
			}
			
			var pt:Point = this.localToScreen(new Point(48, 50));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent());
			
			m_boxPanel.scaleX = 1.1;
			m_boxPanel.scaleY = 1.1;
			m_boxPanel.setPos(3 - (m_boxPanel.width * 0.1) / 2, 13 - (m_boxPanel.height * 0.1) / 2);
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			
			m_boxPanel.scaleX = 1;
			m_boxPanel.scaleY = 1;
			m_boxPanel.setPos(3, 13);
		}
		
		public function setBoxFromGray():void
		{
			m_bHasReward = true;
			m_formPanel.becomeGray();
			m_boxPanel.becomeGray();
		}
		
	}

}