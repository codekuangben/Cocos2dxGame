package game.ui.uiTeamFBSys.teamfbsel
{
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.pageturn.PageTurn;
	import com.dgrigg.image.Image;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import modulecommon.net.msg.teamUserCmd.reqAddMultiCopyUserCmd;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.UnFullCopyData;
	import game.ui.uiTeamFBSys.msg.retClickMultiCopyUiUserCmd;

	//import game.ui.uiTeamFBSys.xmldata.XmlFBItem;

	public class FBSelOpenedPage extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		protected var m_bg:Panel;
		protected var m_bg1f:Panel;
		protected var _exitBtn:PushButton;
		
		protected var m_rootCnter:Component;
		protected var m_pnlTitle:Panel;
		protected var m_listb:ControlListVHeight;	// 列表框
		protected var m_turnPage:PageTurn;
		
		protected var m_btnRadio1f:ButtonRadio;
		protected var m_lbl1f:Label;
		protected var m_btnRadio2f:ButtonRadio;
		protected var m_lbl2f:Label;
		protected var m_btnJoin:PushButton;		// 快速加入
		
		protected var m_lblDesc:Label;			// 当前没有人创建该副本
		
		public function FBSelOpenedPage(data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			this.setSize(256, 482);
			
			m_TFBSysData.m_clkFBOpenedCB = updateOpenedLst;
			
			m_bg = new Panel(this);
			m_bg.setSize(256, 500);
			m_bg.autoSizeByImage = false;
			m_bg.setSkinForm("form4.swf");
			
			m_bg1f = new Panel(this, 11, 26);
			m_bg1f.setPanelImageSkinMirrorBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.rightback2", Image.MirrorMode_LR);
			
			// 关闭按钮
			_exitBtn = new PushButton(this, 199, 4);
			_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			_exitBtn.m_musicType = PushButton.BNMClose;
			
			m_rootCnter = new Component(null);
			
			m_pnlTitle = new Panel(this, 78, 34);
			m_pnlTitle.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.xyfb")
			
			// 第二个列表
			m_listb = new ControlListVHeight(m_rootCnter, 20, 64);
			var m_param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			m_param.m_class = FBSelOpenedItem;
			m_param.m_marginTop = 0;
			m_param.m_marginBottom = 0;
			m_param.m_intervalV = 2;
			m_param.m_width = 210;
			m_param.m_heightList = m_param.m_marginTop + 24 + (24 + m_param.m_intervalV) * 9 + m_param.m_marginBottom;
			m_param.m_lineSize = m_param.m_heightList;
			m_param.m_scrollType = 0;
			m_param.m_bCreateScrollBar = false;
			m_listb.setParam(m_param);
			
			m_turnPage = new PageTurn(m_rootCnter, 82, 372);
			m_turnPage.setBtnPos(0, 0, 60, 0, 0, 18);
			m_turnPage.setParam(onPageTurn);
			m_turnPage.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			
			//m_turnPage.pageCount = m_listb.pageCount;
			m_turnPage.pageCount = 0;
			m_turnPage.curPage = 0;
			
			m_btnRadio1f = new ButtonRadio(m_rootCnter, 26, 408, onBtnClk1f);
			m_btnRadio1f.setPanelImageSkin("commoncontrol/button/bb_buttoncheck.swf");
			
			m_lbl1f = new Label(m_rootCnter, 50, 412, "只显示本军团", UtilColor.WHITE_Yellow);
			
			m_btnRadio2f = new ButtonRadio(m_rootCnter, 26, 436, onBtnClk2f);
			m_btnRadio2f.setPanelImageSkin("commoncontrol/button/bb_buttoncheck.swf");
			m_btnRadio2f.selected = true;	// 默认选择这个
			
			m_lbl2f = new Label(m_rootCnter, 50, 440, "全部", UtilColor.WHITE_Yellow);
			
			m_btnJoin = new ButtonText(m_rootCnter, 155, 432, "快速加入", onBtnClickJoin);
			m_btnJoin.setSize(60, 26);
			m_btnJoin.autoSizeByImage = false;
			m_btnJoin.setSkinButton1Image("commoncontrol/button/button8.png");
			
			// 默认显示这个
			m_lblDesc = new Label(this, 50, 60, "当前没有人创建该副本", UtilColor.WHITE_Yellow);
		}
		
		private function onBtnClk1f(event:MouseEvent):void
		{
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType == 0)
			{
				m_btnRadio1f.selected = true;
			}
			m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType = 0;
		}
		
		private function onBtnClk2f(event:MouseEvent):void
		{
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType == 1)
			{
				m_btnRadio2f.selected = true;
			}
			m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType = 1;
		}
		
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_listb.toPreLine();
			}
			else
			{
				m_listb.toNextLine();
			}
		}
		
		protected function onExitBtnClick(e:MouseEvent):void
		{
			// 关闭
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		protected function onBtnClickJoin(e:MouseEvent):void
		{
			// 快速加入原则为，自动加入剩余1人就可战斗的副本，如果没有就随机进入已开启的其他副本，如果没有副本开着，就显示黄字提示，当前没有副本可加入
			var cmd:reqAddMultiCopyUserCmd;
			var item:UnFullCopyData;
			for each(item in m_TFBSysData.m_openedFBLst)
			{
				if(item.num == 2)
				{
					cmd = new reqAddMultiCopyUserCmd();
					cmd.copytempid = item.copytempid;
					if(m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum)
					{
						cmd.type = 0;
					}
					else
					{
						cmd.type = 1;
					}
					m_TFBSysData.m_gkcontext.sendMsg(cmd);
					return;
				}
			}
			// 如果没有只差 1 个人的副本,就随便进入一个
			if(m_TFBSysData.m_openedFBLst && m_TFBSysData.m_openedFBLst.length)
			{
				item = m_TFBSysData.m_openedFBLst[0];
				cmd = new reqAddMultiCopyUserCmd();
				cmd.copytempid = item.copytempid;
				if(m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum)
				{
					cmd.type = 0;
				}
				else
				{
					cmd.type = 1;
				}
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
			}
			else	// 一个副本都没有,直接给提示
			{
				m_TFBSysData.m_gkcontext.m_systemPrompt.prompt("没有副本可以进入");
			}
		}
		
		protected function updateOpenedLst():void
		{
			if(!this.parent)
			{
				return;
			}
			//setDatas(m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_openedFBLst[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]]);
			if(m_TFBSysData.m_openedFBLst && m_TFBSysData.m_openedFBLst.length)
			{
				if(!this.contains(this.m_rootCnter))
				{
					this.addChild(this.m_rootCnter);
				}
				if(this.contains(this.m_lblDesc))
				{
					this.removeChild(this.m_lblDesc);
				}
				
				setDatas(m_TFBSysData.m_openedFBLst);
				m_turnPage.pageCount = m_TFBSysData.m_openedFBLst.length;
				m_turnPage.curPage = 0;
			}
			else
			{
				if(this.contains(this.m_rootCnter))
				{
					this.removeChild(this.m_rootCnter);
				}
				if(!this.contains(this.m_lblDesc))
				{
					this.addChild(this.m_lblDesc);
				}
			}
		}
		
		public function setDatas(datas:Array):void
		{
			var param:Object = new Object();
			param["data"] = m_TFBSysData;
			
			m_listb.setDatas(datas, param);
		}
		
		public function psretClickMultiCopyUiUserCmd(msg:retClickMultiCopyUiUserCmd):void
		{
			updateOpenedLst();
		}
	}
}