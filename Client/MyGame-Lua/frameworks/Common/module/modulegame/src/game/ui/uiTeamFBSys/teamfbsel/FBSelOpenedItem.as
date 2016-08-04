package game.ui.uiTeamFBSys.teamfbsel
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import flash.events.MouseEvent;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.UnFullCopyData;
	import modulecommon.net.msg.teamUserCmd.reqAddMultiCopyUserCmd;

	//import game.ui.uiTeamFBSys.xmldata.XmlOpenedFBItem;
	import com.util.UtilColor;

	/**
	 * @brief 副本选择中开启的副本一项
	 * */
	public class FBSelOpenedItem extends CtrolVHeightComponent
	{
		public var m_TFBSysData:UITFBSysData;
		//protected var m_XmlOpenedFBItem:XmlOpenedFBItem;
		protected var m_XmlOpenedFBItem:UnFullCopyData;

		protected var m_btnJoin:PushButton;
		protected var m_lblDesc:Label;

		public function FBSelOpenedItem(param:Object)
		{
			super();
			m_TFBSysData = param["data"] as UITFBSysData;
			
			this.setSize(210, 24);
			m_btnJoin = new PushButton(this, 155, 0, onBtnClick);
			m_lblDesc = new Label(this, 0, 0, "", UtilColor.WHITE_Yellow);
			//this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		// 设置数据
		override public function setData(data:Object):void
		{
			super.setData(data);
			//m_XmlOpenedFBItem = data as XmlOpenedFBItem;
			m_XmlOpenedFBItem = data as UnFullCopyData;

			m_btnJoin.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.join");
			//m_lblDesc.text = m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_name[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]] + "(" + m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_level[m_TFBSysData.m_curFBIdx[[m_TFBSysData.m_curPageIdx]]] + ")" + "    " + m_XmlOpenedFBItem.m_fbcurnum + "/" + m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_maxplayer[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]];
			m_lblDesc.text = m_XmlOpenedFBItem.name + "(" + m_XmlOpenedFBItem.level + "级) " + m_XmlOpenedFBItem.num + "/3";
		}
		
		override public function dispose():void
		{
			//this.removeEventListener(MouseEvent.CLICK, onClick);
			super.dispose();
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			var cmd:reqAddMultiCopyUserCmd = new reqAddMultiCopyUserCmd();
			cmd.copytempid = m_XmlOpenedFBItem.copytempid;
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
	}
}