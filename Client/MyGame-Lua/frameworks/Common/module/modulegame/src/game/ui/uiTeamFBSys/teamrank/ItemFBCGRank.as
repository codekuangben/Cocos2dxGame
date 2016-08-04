package game.ui.uiTeamFBSys.teamrank 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	
	import flash.events.MouseEvent;
	import modulecommon.net.msg.fndcmd.stViewFriendDataFriendCmd;
	import com.util.UtilColor;
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.Item;

	/**
	 * ...
	 * @author 
	 */
	public class ItemFBCGRank extends CtrolVHeightComponent 
	{
		private var m_dataApp:UITFBSysData;
		private var m_Rankdata:Item;
		private var m_rankLabel:Label;
		private var m_nameLabel:Label;
		private var m_scoreLabel:Label;
		private var m_watchBtn:PushButton;
		private var m_underLinePanel:Panel;
		
		public function ItemFBCGRank(param:Object) 
		{
			this.setSize(342, 30);
			m_dataApp = param["data"] as UITFBSysData;
			
			m_rankLabel = new Label(this, 58, 5, "", UtilColor.COLOR1);
			m_rankLabel.align = Component.CENTER;
			
			m_nameLabel = new Label(this, 178, 5, "", UtilColor.COLOR1);
			m_nameLabel.align = Component.CENTER;
			
			m_scoreLabel = new Label(this, 280, 5, "", UtilColor.COLOR1);
			m_scoreLabel.align = Component.CENTER;
			
			m_underLinePanel = new Panel(this, 5, this.height);
			m_underLinePanel.setSize(this.width - 10, 2);
			m_underLinePanel.autoSizeByImage = false;
			m_underLinePanel.setPanelImageSkin("commoncontrol/panel/splitline.png");
		}

		override public function setData(data:Object):void
		{
			super.setData(data);
			m_Rankdata = data as Item;
			updateData();
		}
		
		public function updateData():void
		{
			if (0 == m_Rankdata.rank)
			{
				if (m_watchBtn)
				{
					m_watchBtn.visible = false;
				}
				
				return;
			}
			
			m_rankLabel.text = m_Rankdata.rank.toString();
			m_nameLabel.text = m_Rankdata.name;
			m_scoreLabel.text = m_Rankdata.guan.toString();
			
			var color:uint = UtilColor.COLOR1;
			if (m_Rankdata.name == m_dataApp.m_gkcontext.playerMain.name)
			{
				color = UtilColor.GOLD;
			}
			
			m_rankLabel.setFontColor(color);
			m_nameLabel.setFontColor(color);
			m_scoreLabel.setFontColor(color);
			
			if (null == m_watchBtn)
			{
				m_watchBtn = new PushButton(this, 315, 5, onWatchBtnClick);
				m_watchBtn.setSkinButton1Image("commoncontrol/menuicon/watch.png");
			}
			m_watchBtn.visible = true;
			
			if (m_Rankdata.name == m_dataApp.m_gkcontext.playerMain.name)
			{
				m_watchBtn.mouseEnabled = false;
				m_watchBtn.becomeGray();
			}
			else
			{
				m_watchBtn.mouseEnabled = true;
				m_watchBtn.becomeUnGray();
			}
		}
		
		private function onWatchBtnClick(event:MouseEvent):void
		{
			var msg:stViewFriendDataFriendCmd = new stViewFriendDataFriendCmd();
			msg.friendName = m_Rankdata.name;
			msg.type = stViewFriendDataFriendCmd.VIEWTYPE_RANK;
			m_dataApp.m_gkcontext.sendMsg(msg);
		}
	}	
}