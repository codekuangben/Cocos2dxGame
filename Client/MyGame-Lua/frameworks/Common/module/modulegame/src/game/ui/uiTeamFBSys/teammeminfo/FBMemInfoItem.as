package game.ui.uiTeamFBSys.teammeminfo
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import ui.player.PlayerResMgr;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	//import game.ui.uiTeamFBSys.msg.quickInviteOtherAddMultiCopyUserCmd;
	import modulecommon.uiinterface.IUITeamFBSys;
	import modulecommon.ui.UIFormID;

	public class FBMemInfoItem extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		protected var m_tag:uint;
		protected var m_rootJoined:Component;
		protected var m_rootNJoined:Component;
		
		//protected var m_pnlBg:Panel;	// 背景
		protected var m_pnlImage:Panel;	// 半身像
		protected var m_lblName:Label;	// 名字
		protected var m_pnlLeader:Panel;	// 队长
		protected var m_lvlZL:Label;		// 武将战力
		//protected var m_zhanliDC:DigitComponent;
		
		protected var m_lblJoin:Label;		// 等待加入
		protected var m_btnZH:ButtonText;	// 召唤队友
		//protected var m_lblNum:Label;		// 编号
		
		public function FBMemInfoItem(value:UITFBSysData, tag:uint, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			this.setSize(220, 60);
			m_TFBSysData = value;
			m_tag = tag;
			
			//m_pnlBg = new Panel(this);
			//m_pnlBg.autoSizeByImage = false;
			//m_pnlBg.setSize(150, 70);
			//m_pnlBg.setSkinGrid9Image9(ResGrid9.StypeOne);

			m_rootJoined = new Component(null);
			m_rootNJoined = new Component(null);
			
			//m_lblNum = new Label(m_rootJoined, 10, 18, m_tag + "", UtilColor.WHITE_Yellow);
			
			m_pnlImage = new Panel(m_rootJoined, 40, 11);
			//m_pnlImage.scaleX = 0.2;
			//m_pnlImage.scaleY = 0.2;

			m_lblName = new Label(m_rootJoined, 78, 13, "名字", UtilColor.WHITE_Yellow);
			m_lvlZL = new Label(m_rootJoined, 78, 32, "武将战力: ", UtilColor.WHITE_Yellow);
			
			m_pnlLeader = new Panel(m_rootJoined, 160, 4);
			//m_zhanliDC = new DigitComponent(m_TFBSysData.m_gkcontext.m_context, m_rootJoined, 80, 45);
			//m_zhanliDC.setParam("commoncontrol/digit/digit01", 10, 18);
			//m_zhanliDC.digit = 0;
			
			m_lblJoin = new Label(m_rootNJoined, 20, 18, "等待加入...", UtilColor.WHITE_Yellow);
			m_btnZH = new ButtonText(m_rootNJoined, 90, 9 , "", onBtnClickZH);
			m_btnZH.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btnzhaohuanduiyou");
			
			this.addEventListener(MouseEvent.CLICK, onItemClk);
			updateUI();
			
			// test
			//m_zhanliDC.digit = 90;
			//m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(1, 1, PlayerResMgr.HDBigHalf));
			
			/*
			// test
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
			
			this.addChild(m_rootJoined);
			m_lblName.text = "名字";
			//m_zhanliDC.digit = 150;
			m_lvlZL.text = "武将战力: 500";
			m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(1, 1, PlayerResMgr.HDMid));
			m_pnlLeader.visible = true;
			m_pnlLeader.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dzbz");
			*/
		}
		
		protected function onBtnClickZH(e:MouseEvent):void
		{
			//var cmd:quickInviteOtherAddMultiCopyUserCmd = new quickInviteOtherAddMultiCopyUserCmd();
			//m_TFBSysData.m_gkcontext.sendMsg(cmd);
			
			var form:IUITeamFBSys = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSys) as IUITeamFBSys;
			if(form && form.isUIReady())
			{
				form.openUI(UIFormID.UITeamFBInvite);
			}
		}
		
		public function updateUI():void
		{
			if(!m_TFBSysData.m_teamMemInfo)
			{
				return;
			}
			if(m_tag < m_TFBSysData.m_teamMemInfo.size)
			{
				if(this.contains(m_rootNJoined))
				{
					this.removeChild(m_rootNJoined);
					//if(m_rootNJoined.contains(m_lblNum))
					//{
					//	m_rootNJoined.removeChild(m_lblNum);
					//}
				}
				if(!this.contains(m_rootJoined))
				{
					this.addChild(m_rootJoined);
					//if(!m_rootJoined.contains(m_lblNum))
					//{
					//	m_rootJoined.addChild(m_lblNum);
					//}
				}
				
				m_lblName.text = m_TFBSysData.m_teamMemInfo.data[m_tag].name;
				// m_zhanliDC.digit = m_TFBSysData.m_teamMemInfo.data[m_tag].zhanli;
				m_lvlZL.text = "武将战力:" + m_TFBSysData.m_teamMemInfo.data[m_tag].zhanli;
				
				m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(m_TFBSysData.m_teamMemInfo.data[m_tag].job, m_TFBSysData.m_teamMemInfo.data[m_tag].sex, PlayerResMgr.HDMid));
				
				if(m_TFBSysData.isLeader(m_TFBSysData.m_teamMemInfo.data[m_tag].id))	// 如果是队长
				{
					m_pnlLeader.visible = true;
					m_pnlLeader.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dzbz");
				}
				else
				{
					m_pnlLeader.visible = false;
				}
			}
			else
			{
				if(this.contains(m_rootJoined))
				{
					this.removeChild(m_rootJoined);
					//if(m_rootJoined.contains(m_lblNum))
					//{
					//	m_rootJoined.removeChild(m_lblNum);
					//}
				}
				if(!this.contains(m_rootNJoined))
				{
					this.addChild(m_rootNJoined);
					//if(!m_rootNJoined.contains(m_lblNum))
					//{
					//	m_rootNJoined.addChild(m_lblNum);
					//}
				}
			}
		}
		
		override public function dispose():void
		{
			if(!this.contains(m_rootNJoined))
			{
				m_rootNJoined.dispose();
			}
			if(!this.contains(m_rootJoined))
			{
				m_rootJoined.dispose();
			}
			
			this.removeEventListener(MouseEvent.CLICK, onItemClk);

			super.dispose();
		}
		
		public function onItemClk(e:MouseEvent):void
		{
			
		}
	}
}