package game.ui.uiTeamFBSys.teammger
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import ui.player.PlayerResMgr;
	import modulecommon.res.ResGrid9;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import com.util.UtilColor;
	
	public class FBMgerItem extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		protected var m_tag:uint; 
		
		protected var m_rootJoined:Component;
		protected var m_rootNJoined:Component;
		
		//protected var m_pnlBg:Panel;	// 背景
		protected var m_pnlImage:Panel;	// 半身像
		protected var m_lblLvl:Label;	// 等级
		protected var m_lblName:Label;	// 名字
		protected var m_lblCorpsName:Label;	// 团名字
		protected var m_pnlLeader:Panel;	// 队长
		
		protected var m_btnTJ:ButtonText;	// 添加成员
		protected var m_SelectedPanel:Panel;

		public function FBMgerItem(value:UITFBSysData, tag:uint, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			
			this.setSize(146, 200);
			
			m_TFBSysData = value;
			m_tag = tag;
			
			//m_pnlBg = new Panel(this);
			//m_pnlBg.autoSizeByImage = false;
			//m_pnlBg.setSize(this.width, this.height);
			//m_pnlBg.setSkinGrid9Image9(ResGrid9.StypeOne);
			//m_pnlBg.mouseEnabled = false;
			
			m_rootJoined = new Component(null);
			m_rootNJoined = new Component(null);
			m_rootJoined.mouseEnabled = false;
			m_rootJoined.mouseChildren = false;
			m_rootNJoined.mouseEnabled = false;
			
			m_pnlLeader = new Panel(m_rootJoined, 42, 10);

			m_pnlImage = new Panel(m_rootJoined, 30, 30);	// roundsmall
			m_lblLvl = new Label(m_rootJoined, 95, 97, "180", UtilColor.WHITE_Yellow);
			m_lblLvl.align = Component.CENTER;
			m_lblLvl.text = "0";
			m_lblName = new Label(m_rootJoined, 65, 120, "名字", UtilColor.WHITE_Yellow);
			m_lblName.align = Component.CENTER;
			m_lblName.text = "名字";
			m_lblCorpsName = new Label(m_rootJoined, 65, 150, "军团名字", UtilColor.WHITE_Yellow);
			m_lblCorpsName.align = Component.CENTER;
			m_lblCorpsName.text = "军团名字";
			
			//m_btnTJ = new ButtonText(m_rootNJoined, 20, 50, "", onBtnClickTJ);
			//m_btnTJ.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.btntianjiachengyuan");
			
			m_SelectedPanel = new Panel(this);
			m_SelectedPanel.setPos(-3, -3);
			m_SelectedPanel.setSize(this.width + 6, this.height + 6);
			m_SelectedPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
			m_SelectedPanel.mouseEnabled = false;
			m_SelectedPanel.visible = false;
			
			updateUI();
			
			// test
			//m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(1, 1, PlayerResMgr.HDSmall));
			
			/*
			// test
			if(this.contains(m_rootNJoined))
			{
				this.removeChild(m_rootNJoined);
			}
			if(!this.contains(m_rootJoined))
			{
				this.addChild(m_rootJoined);
			}
			
			m_lblName.text = "名字";
			m_lblCorpsName.text = "军团名字";
			m_lblLvl.text = "20";
			m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(1, 1, PlayerResMgr.HDSmall));
			
			m_pnlLeader.visible = true;
			m_pnlLeader.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dzbz");
			*/
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
				}
				if(!this.contains(m_rootJoined))
				{
					this.addChild(m_rootJoined);
				}
				
				m_lblName.text = m_TFBSysData.m_teamMemInfo.data[m_tag].name;
				m_lblCorpsName.text = m_TFBSysData.m_teamMemInfo.data[m_tag].corps;
				m_lblLvl.text = m_TFBSysData.m_teamMemInfo.data[m_tag].level;
				m_pnlImage.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(m_TFBSysData.m_teamMemInfo.data[m_tag].job, m_TFBSysData.m_teamMemInfo.data[m_tag].sex, PlayerResMgr.HDSmall));
				
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
				}
				if(!this.contains(m_rootNJoined))
				{
					this.addChild(m_rootNJoined);
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
			
			super.dispose();
		}
		
		protected function onBtnClickTJ(e:MouseEvent):void
		{
			
		}
		
		public function hideSel():void
		{
			m_SelectedPanel.visible = false;
		}
		
		public function showSel():void
		{
			m_SelectedPanel.visible = true;
		}
	}
}