package game.ui.uiTeamFBSys.teamfbsel
{
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	//import modulecommon.net.msg.copyUserCmd.reqUserProfitInCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.retOpenMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.xmldata.XmlFBReward;
	import game.ui.uiTeamFBSys.xmldata.XmlPage;

	public class FBSelPage extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		protected var m_leftCner:Component;
		protected var m_rightCner:Component;
		protected var m_lista:ControlListVHeight;	// 列表框
		
		protected var m_btnPnl:Panel;
		protected var m_btnCreate:PushButton; 	// 新建立副本
		//protected var m_btnRadio1f:ButtonRadio;
		protected var m_pnlSLZT:Panel;		// 试练之塔
		protected var m_tfLevelDesc:TextNoScroll;	// 奖励说明
		protected var m_tfReward:TextNoScroll;	// 奖励说明
		protected var m_lblNote:Label;		// 注释
		protected var m_lblCnt:Label;		// 次数
		//protected var m_lblGain:Label;		// 收益
		
		protected var m_pnlObjList:Vector.<ObjectPanel>;		// 奖励的道具
		//protected var m_usecnt:int;	// 副本收益使用次数
		
		public var m_xmlPage:XmlPage;
		
		public function FBSelPage(data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
		}
		
		public function initComp():void
		{
			m_leftCner = new Component(this, 56, 28);
			//m_leftCner.graphics.beginFill(0xff0000);
			//m_leftCner.graphics.drawRect(0, 0, 100, 100);
			//m_leftCner.graphics.endFill();
			
			// 第一个列表
			m_lista = new ControlListVHeight(m_leftCner, 14, 10);
			var m_param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			m_param.m_class = FBSelFBItem;
			m_param.m_marginTop = 0;
			m_param.m_marginBottom = 0;
			m_param.m_intervalV = 2;
			m_param.m_width = 374;
			m_param.m_heightList = m_param.m_marginTop + 103 + (103 + m_param.m_intervalV) * 3 + m_param.m_marginBottom;
			m_param.m_lineSize = m_param.m_heightList;
			m_param.m_scrollType = 0;
			m_param.m_bCreateScrollBar = false;
			m_lista.setParam(m_param);
			
			m_rightCner = new Component(this, 462, 28);
			//m_rightCner.graphics.beginFill(0xff0000);
			//m_rightCner.graphics.drawRect(0, 0, 100, 100);
			//m_rightCner.graphics.endFill();
			
			// 试练之塔
			m_pnlSLZT = new Panel(m_rightCner, 18, 8);
			m_pnlSLZT.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.slzt");
			
			m_tfLevelDesc = new TextNoScroll();
			m_tfLevelDesc.textColor = UtilColor.WHITE_Yellow;
			m_tfLevelDesc.x = 18 + 110;
			m_tfLevelDesc.y = 2;
			m_tfLevelDesc.width = 220;
			m_tfLevelDesc.height = 180;
			m_rightCner.addChild(m_tfLevelDesc);
			
			m_tfReward = new TextNoScroll();
			m_tfReward.x = 18 + 110;
			m_tfReward.y = 18;
			m_tfReward.width = 220;
			m_tfReward.height = 180;
			m_rightCner.addChild(m_tfReward);
			
			m_lblNote = new Label(m_rightCner, 15, 310, "注:有奖励次数时才能获得通关奖励!", UtilColor.WHITE_Yellow);
			m_lblCnt = new Label(m_rightCner, 80, 335, "1/1", UtilColor.GREEN);
			//m_lblGain = new Label(m_rightCner, 150, 333, "使用收益次数", UtilColor.WHITE_Yellow);
			
			//m_btnRadio1f = new ButtonRadio(m_rightCner, 128, 333, onBtnClk1f);
			//m_btnRadio1f.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			
			// 默认使用收益
			//m_btnRadio1f.selected = true;
			//m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum = true;
			
			m_btnCreate = new PushButton(m_rightCner, 58, 382, onBtnClk);
			//m_btnCreate.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.createfb");
			m_btnCreate.setSize(180, 40);
			m_btnCreate.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			
			m_btnPnl = new Panel(m_btnCreate, (m_btnCreate.width - 102)/2, (m_btnCreate.height - 22)/2);
			m_btnPnl.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.createfb");
			
			m_pnlObjList = new Vector.<ObjectPanel>(5, true);
			var idx:uint = 0;
			while(idx < 5)
			{
				m_pnlObjList[idx] = new ObjectPanel(m_TFBSysData.m_gkcontext, m_rightCner, 17 + ZObject.IconBgSize * idx, 235);
				m_pnlObjList[idx].addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_pnlObjList[idx].addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				++idx;
			}
			setDatas(m_xmlPage.m_itemLst);
		}
		
		override public function dispose():void
		{
			var idx:uint = 0;
			while(idx < 5)
			{
				m_pnlObjList[idx].removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_pnlObjList[idx].removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				++idx;
			}
			
			super.dispose();
		}
		
		private function onBtnClk(event:MouseEvent):void
		{
			var cmd:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
			cmd.copyid = m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_id[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]];
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum)
			{
				cmd.type = 0;
			}
			else
			{
				cmd.type = 1;
			}
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			var form:Form = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSel);
			if (form)
			{
				form.exit();
			}
		}

		private function onBtnClk1f(event:MouseEvent):void
		{
			//m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum = m_btnRadio1f.selected;
			m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum = false;
			
			//var cmd:reqUserProfitInCopyUserCmd = new reqUserProfitInCopyUserCmd();
			//m_TFBSysData.m_gkcontext.sendMsg(cmd);
		}
		
		public function setDatas(datas:Array):void
		{
			var param:Object = new Object();
			param["data"] = m_TFBSysData;
			
			m_lista.setDatas(datas, param);
		}
		
		public function updateObj():void
		{
			// 跟新物品显示
			var itemxml:XmlFBReward;
			var idx:uint = 0;
			for each(itemxml in m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_rewardLst[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]])
			{
				if(idx < 5)
				{
					m_pnlObjList[idx].objectIcon.setZObject(itemxml.m_obj);
				}
				
				++idx;
			}
			if(idx < 5)
			{
				while(idx < 5)
				{
					m_pnlObjList[idx].objectIcon.removeZObject();
					++idx;
				}
			}
			
			var str:String;
			
			// 更新等级
			str = "进入等级: " + m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_level[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]];
			m_tfLevelDesc.htmlText = str;
			
			// 更奖励描述
			//m_tfReward.text = m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_rewardDesc[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]];
			str = m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_rewardDesc[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]];
			m_tfReward.htmlText = str;
			
			// 更新选中信息
			//m_btnRadio1f.selected = m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if (m_TFBSysData.m_gkcontext)
			{
				m_TFBSysData.m_gkcontext.m_uiTip.hideTip();
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				pt = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					m_TFBSysData.m_gkcontext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
		
		public function psretOpenMultiCopyUiUserCmd(msg:retOpenMultiCopyUiUserCmd):void
		{
			m_TFBSysData.m_usecnt = msg.count;
			m_TFBSysData.m_gkcontext.m_teamFBSys.usecnt = msg.count;		// 记录次数，有个确认对话框还要用这个值
			m_lblCnt.text = msg.count + "/" + m_TFBSysData.m_gkcontext.m_teamFBSys.maxCountsFight;
			
			updateTeamFBSysUsecnt(msg.count);

			// 更新副本领取标志
			//msg.copyid[0] = 1;
			//msg.copyid[1] = 1;
			if (msg.copyid[0] || msg.copyid[1])
			{
				var lst:Vector.<CtrolComponentBase> = m_lista.controlList;
				var item:FBSelFBItem;
				for each(item in lst)
				{
					if (msg.copyid[0])
					{
						item.updateLQFlags(msg.copyid[0]);
					}
					if (msg.copyid[1])
					{
						item.updateLQFlags(msg.copyid[1]);
					}
				}
			}
		}
		
		public function psretUserProfitInCopyUserCmd(type:int):void
		{
			if(0 == type)
			{
				//m_btnRadio1f.selected = true;
				m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum = true;
				
				// 更新使用次数
				m_lblCnt.text = (m_TFBSysData.m_usecnt - 1) + "/" + m_TFBSysData.m_gkcontext.m_teamFBSys.maxCountsFight;
				updateTeamFBSysUsecnt(m_TFBSysData.m_usecnt - 1);
			}
			else
			{
				//m_btnRadio1f.selected = false;
				m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum = false;				
			}
		}
		
		//活动按钮、任务推荐，相关剩余次数刷新
		private function updateTeamFBSysUsecnt(count:uint):void
		{
			if (m_TFBSysData.m_gkcontext.m_UIs.taskPrompt)
			{
				m_TFBSysData.m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_TeamFBSys, -1, count);
			}
			
			if (m_TFBSysData.m_gkcontext.m_UIs.screenBtn)
			{
				m_TFBSysData.m_gkcontext.m_UIs.screenBtn.updateLblCnt(count, ScreenBtnMgr.Btn_TeamFB);
			}
		}
	}
}