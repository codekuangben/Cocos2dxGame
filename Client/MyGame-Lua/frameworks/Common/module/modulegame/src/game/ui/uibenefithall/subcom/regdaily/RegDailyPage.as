package game.ui.uibenefithall.subcom.regdaily 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.net.msg.dailyactivitesCmd.stPerDayRegUserCmd;
	import modulecommon.scene.prop.object.ZObject;
	import time.TimeL;
	import com.util.UtilColor;
	import ui.IImageSWFHost;
	import ui.ImageSWFLoader;
	/**
	 * ...
	 * @author ...
	 * 每日签到
	 */
	public class RegDailyPage extends PageBase implements IImageSWFHost
	{
		
		private var m_backPD:PanelDraw;
		private var m_monthIcon:Panel;			//月份
		private var m_monthPanel:MonthPanel;
		private var m_regLabel:Label;			//已签到次数
		private var m_regDateBar:BarInProgress2;//签到进度条
		private var m_regBtn:PushButton;		//签到按钮
		private var m_vecRegReward:Vector.<ItemRegReward>;
		private var m_regRewardList:Array;		//签到奖励列表
		private var m_dicReward:Dictionary;
		private var m_selectBoxAni:Ani;
		
		private var m_oldMonth:Number;			//上次打开界面时的月份 0,1,2,3...10,11
		private var m_bCreateImage:Boolean;		//是否已经创建该显示的Image
		private var m_bUpdateData:Boolean;		//是否更新数据
		private var m_swfLoader:ImageSWFLoader;
		
		public function RegDailyPage(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(data, parent, xpos, ypos);
			
			m_bCreateImage = false;
			m_bUpdateData = false;
			
			initData();
			
			m_swfLoader = new ImageSWFLoader(data.m_gkContext.m_context, this);
			m_swfLoader.load("module/uibenefithallregdaily.swf");			
		}
		
		private function initData():void
		{
			m_dataBenefitHall.m_gkContext.m_dailyActMgr.loadConfig();
			
			m_backPD = new PanelDraw(this, 0, 0);
			m_backPD.setSize(667, 507);
			
			m_monthIcon = new Panel(this, 132, 61);
			m_monthIcon.recycleSkins = true;
			
			var label:Label;
			label = new Label(this, 265, 326, "次", UtilColor.GOLD);
			m_regLabel = new Label(this, 247, 326, "", UtilColor.YELLOW);
			
			m_regDateBar = new BarInProgress2(this, 168, 344);
			m_regDateBar.setSize(378, 19);
			m_regDateBar.maximum = 1;
			m_regDateBar.initValue = 0.5;
			
			m_regRewardList = m_dataBenefitHall.m_gkContext.m_dailyActMgr.getCurRegReward();
			
			m_vecRegReward = new Vector.<ItemRegReward>(5);
			
			var arr:Array = ["gray", "green", "blue", "purple", "orange"];
			var item:ItemRegReward;
			var i:int;
			var interval:int = 67;
			var panel:Panel;
			if (m_regRewardList.length > 0)
			{
				for (i = 0; i < 5; i++)
				{
					panel = new Panel(this, 235 + i * interval, 346);
					panel.setPanelImageSkin("commoncontrol/panel/lattice2.png");
					
					item = new ItemRegReward(m_dataBenefitHall.m_gkContext, this, this);
					item.setPos(211 + i * interval, 359);
					item.initData(arr[i], i, m_regRewardList[i]);
					
					m_vecRegReward[i] = item;
				}
			}
			
			m_regBtn = new PushButton(this, 117, 329, onRegistrationBtn);
			m_regBtn.setSize(84, 85);
			m_regBtn.beginLiuguang();
			
			m_dicReward = new Dictionary();
			
			m_monthPanel = new MonthPanel(m_dataBenefitHall.m_gkContext, this, this, 111, 125);// 6, 76);
		}
		
		public function createImage(resource:SWFResource):void
		{
			this.setPanelImageSkinBySWF(resource, "regdaily.back");
			
			var panel:Panel;
			
			panel = new Panel(null, 105, 48);
			m_backPD.addDrawCom(panel);
			panel.setPanelImageSkinBySWF(resource, "regdaily.regform");
			panel = new Panel(null, 2, 35);
			m_backPD.addDrawCom(panel);
			panel.setPanelImageSkinBySWF(resource, "regdaily.lantern");
			panel = new Panel(null, 535, 35);
			m_backPD.addDrawCom(panel);
			panel.setPanelImageSkinMirrorBySWF(resource, "regdaily.lantern", Image.MirrorMode_HOR);
			panel = new Panel(null, 158, 60);
			m_backPD.addDrawCom(panel);
			panel.setPanelImageSkinBySWF(resource, "regdaily.month");
			m_backPD.drawPanel();
			
			m_monthPanel.initData();
			
			m_regDateBar.setPanelImageSkinBySWF(resource, "regdaily.bar");
			m_regBtn.setPanelImageSkinBySWF(resource, "regdaily.registrationBtn");
			
			m_bCreateImage = true;
			if (m_bUpdateData)
			{
				updateData();
			}
		}
		
		//更新签到按钮状态
		private function updateRegBtnState(bReg:Boolean):void
		{
			if (true == bReg)
			{
				m_regBtn.stopLiuguang();
				m_regBtn.mouseEnabled = false;
				m_regBtn.becomeGray();
				m_dataBenefitHall.m_gkContext.m_sysOptions.set(SysOptions.COMMONSET_REG)
				m_dataBenefitHall.m_gkContext.m_dailyActMgr.updateCommonsetReg();//每日必做 活动按钮特效
			}
			else
			{
				m_regBtn.becomeUnGray();
				m_regBtn.mouseEnabled = true;
				m_regBtn.beginLiuguang();
			}
		}
		
		//点击“签到”按钮
		private function onRegistrationBtn(event:MouseEvent):void
		{
			var cmd:stPerDayRegUserCmd = new stPerDayRegUserCmd();
			m_dataBenefitHall.m_gkContext.sendMsg(cmd);
			
			m_monthPanel.onRegistration();
			m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_regCounts += 1;
			m_regLabel.text = m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_regCounts.toString();
			updateShowRegRewards();
			updateRegBtnState(true);
			updateRegDateBar();
			
			m_dataBenefitHall.m_gkContext.m_systemPrompt.prompt("签到成功！");
		}
		
		//更新签到进度条显示 bool: true初始化数据
		public function updateRegDateBar(bool:Boolean = false):void
		{
			var i:int;
			var v:Number;
			for (i = 0; i < 5; i++)
			{
				if ((null != m_vecRegReward[i]) && (false == m_vecRegReward[i].m_bHasReward))
				{
					break;
				}
			}
			v = (i * 67 + getRegProgressRate(i) * 67) / m_regDateBar.width;
			if (bool)
			{
				m_regDateBar.initValue = v;
			}
			else
			{
				m_regDateBar.value = v;
			}
		}
		
		private function updateShowRegRewards():void
		{
			var i:int;
			var item:ItemRegReward;
			for (i = 0; i < 5; i++)
			{
				item = m_vecRegReward[i];
				if (item)
				{
					if (m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_regCounts < item.tag)
					{
						item.onShowRegRewards();
						break;
					}
					else
					{
						item.setBoxFromGray();
					}
				}
				else
				{
					DebugBox.sendToDataBase("RegDailyPage.as::updateShowRegRewards -> m_vecRegReward[" + i + "] == null");
				}
			}
			
			if (5 == i && (null != m_vecRegReward[4]))
			{
				m_vecRegReward[4].onShowRegRewards();
			}
		}
		
		public function onSelectRegRewardsBox(parent:ItemRegReward, xpos:Number, ypos:Number):void
		{
			if (m_selectBoxAni == null)
			{
				m_selectBoxAni = new Ani(m_dataBenefitHall.m_gkContext.m_context);
				m_selectBoxAni.setImageAni("ejzhuangbeixuanzhong.swf");
				m_selectBoxAni.duration = 1;
				m_selectBoxAni.centerPlay = true;
				m_selectBoxAni.repeatCount = 0;
				m_selectBoxAni.mouseEnabled = false;
			}
			m_selectBoxAni.x = xpos;
			m_selectBoxAni.y = ypos;
			
			if (m_selectBoxAni.parent != parent)
			{
				parent.addChild(m_selectBoxAni);
			}
			m_selectBoxAni.begin();
		}
		
		//显示签到奖励宝箱道具
		public function onShowRegRewards(objlist:Vector.<ZObject>, value:uint):void
		{
			var panel:ShowRegRewards;
			if (m_dicReward[value] == undefined)
			{
				panel = new ShowRegRewards(m_dataBenefitHall.m_gkContext, this, 120, 427);
				panel.setDatas(objlist, value);
				
				m_dicReward[value] = panel;
			}
			
			for each(panel in m_dicReward)
			{
				if (value == panel.tag)
				{
					panel.visible = true;
				}
				else
				{
					panel.visible = false;
				}
				
				panel.setObjectsBecomeGray(panel.tag);
			}
		}
		
		//计算当前签到奖励段签到进度
		private function getRegProgressRate(i:uint):Number
		{
			var retcount:uint = m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_regCounts;
			var count:uint;
			var ret:Number;
			if (i >= 0)
			{
				ret = (retcount - count) / 2;
				count = 2;
			}
			if (i >= 1)
			{
				ret = (retcount - count) / 3;
				count += 3;
			}
			if (i >= 2)
			{
				ret = (retcount - count) / 5;
				count += 5;
			}
			if (i >= 3)
			{
				ret = (retcount - count) / 7;
				count += 7;
			}
			if (i >= 4)
			{
				ret = (retcount - count) / 9;
				count += 9;
			}
			if (i >= 5)
			{
				ret = 0;
			}
			
			return ret;
		}
		
		override public function onShow():void
		{
			super.onShow();
			
			m_dataBenefitHall.m_gkContext.m_dailyActMgr.reqOpenPerDayToDo();
		}
		
		override public function updateData(param:Object = null):void
		{
			super.updateData(param);
			
			var timeL:TimeL = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.getServerTimeL();
			var breg:Boolean = false;
			var bnewmonth:Boolean = false;
			
			if (!isNaN(m_oldMonth) && m_oldMonth != timeL.m_month)
			{
				bnewmonth = true;
			}
			m_oldMonth = timeL.m_month;
			
			m_regLabel.text = m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_regCounts.toString();
			m_monthIcon.setPanelImageSkin("commoncontrol/digit/monthdigit/" + (timeL.m_month + 1).toString() + ".png");
			
			if (m_dataBenefitHall.m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_REG) || m_dataBenefitHall.m_gkContext.m_dailyActMgr.isReg(timeL.m_date - 1))
			{
				breg = true;
			}
			updateRegBtnState(breg);
			
			if (m_bCreateImage)
			{
				updateShowRegRewards();
				updateRegDateBar(true);
				
				m_monthPanel.updateRegInfo(bnewmonth);
			}
			
			m_bUpdateData = true;
		}
		
		public function get resource():SWFResource
		{
			return m_swfLoader.resource;
		}
		
		override public function dispose():void
		{
			m_swfLoader.dispose();
			
			super.dispose();
		}
	}

}