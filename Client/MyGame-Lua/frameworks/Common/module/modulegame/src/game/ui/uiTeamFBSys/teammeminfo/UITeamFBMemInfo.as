package game.ui.uiTeamFBSys.teammeminfo
{
	import com.ani.AniPosition;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.dgrigg.image.Image;
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.events.MouseEvent;
	
	//import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBSys;
	
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * @brief 组队成员信息
	 * */
	public class UITeamFBMemInfo extends Form
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_rootCnter:Component;
		protected var m_btnMgr:PushButton;		// 管理
		//protected var m_lblInfo:Label;			// 队伍信息
		//protected var m_btnLayout:PushButton;	// 布阵
		protected var m_menLst:Vector.<FBMemInfoItem>;	// 队员列表
		protected var m_bgPanel:Panel;
		
		private var m_bSpread:Boolean;
		private var m_indentBtn:PushButton;
		private var m_ani:AniPosition;
		
		public function UITeamFBMemInfo()
		{
			this.id = UIFormID.UITeamFBMemInfo;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this.setSize(245, 280);
			//this.setFormSkin("form1", 250);
			//this.title = "副本成员信息功能";
			
			this.draggable = false;
			
			alignHorizontal = LEFT;
			alignVertial = TOP;
			
			this._marginTop = 200;
			this.marginLeft = 1;
			
			m_rootCnter = new Component(this);
			m_btnMgr = new ButtonText(m_rootCnter, 157, 22, "管理", onBtnClickJoin);
			m_btnMgr.setSize(60, 26);
			m_btnMgr.autoSizeByImage = false;
			m_btnMgr.setSkinButton1Image("commoncontrol/button/button8.png");
			
			//m_lblInfo = new Label(m_rootCnter, 30, 10, "队伍信息", UtilColor.WHITE_Yellow);

			m_menLst = new Vector.<FBMemInfoItem>(3, true);
			var idx:uint = 0;
			while(idx < 3)
			{
				m_menLst[idx] = new FBMemInfoItem(m_TFBSysData, idx, m_rootCnter, 13, 63 + 70 * idx);
				++idx;
			}
			
			//m_btnLayout = new ButtonText(m_rootCnter, 30, 280, "布阵", onBtnClickLayout);
			//m_btnLayout.setSize(60, 26);
			//m_btnLayout.autoSizeByImage = false;
			//m_btnLayout.setSkinButton1Image("commoncontrol/button/button8.png");
			
			m_bgPanel = new Panel(null);
			this.addBackgroundChild(m_bgPanel);
			m_bgPanel.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.bgduiwuxinxi");
			
			m_bSpread = true;
			m_indentBtn = new PushButton(this, 242, 59, onIndentBtn);			
			m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
		}
		
		protected function onBtnClickJoin(e:MouseEvent):void
		{
			var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.openUI(UIFormID.UITeamFBMger);
			}
		}
		
		//protected function onBtnClickLayout(e:MouseEvent):void
		//{
		//	var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
		//	if(form)
		//	{
		//		form.openUI(UIFormID.UITeamFBZX);
		//	}
		//}
		
		public function psstNotifyTeamMemberListUserCmd():void
		{
			var item:FBMemInfoItem;
			for each(item in m_menLst)
			{
				item.updateUI();
			}
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		public function psnotifyTeamMemberLeaderChangeUserCmd():void
		{
			psstNotifyTeamMemberListUserCmd();
		}
		
		public function pstakeOffTeamMemberUserCmd():void
		{
			psstNotifyTeamMemberListUserCmd();
		}
		
		private function onIndentBtn(e:MouseEvent):void
		{
			if (null == m_ani)
			{
				m_ani = new AniPosition();
				m_ani.sprite = this;
				m_ani.duration = 0.8;
			}
			
			m_ani.setBeginPos(this.x, this.y);
			if (m_bSpread)
			{
				m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
				m_ani.setEndPos(this.x - 246, this.y);
				this.marginLeft = -245;
			}
			else
			{
				m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
				m_ani.setEndPos(this.x + 246, this.y);
				this.marginLeft = 1;
			}
			m_ani.begin();
			
			m_bSpread = !m_bSpread;
		}
		
		override public function dispose():void
		{
			if (m_ani)
			{
				m_ani.dispose();
				m_ani = null;
			}
			
			super.dispose();
		}
	}
}