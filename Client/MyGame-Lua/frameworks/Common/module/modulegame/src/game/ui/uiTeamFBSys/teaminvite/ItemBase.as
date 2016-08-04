package game.ui.uiTeamFBSys.teaminvite
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.InviteUiData;
	
	/**
	 * @brief 一个好友请求
	 * */
	public class ItemBase extends CtrolVHeightComponent
	{
		protected var m_TFBSysData:UITFBSysData;

		public var m_lblName:Label;		// 姓名
		public var m_lblLvl:Label;		// 等级
		public var m_lblZL:Label;		// 战力
		
		protected var m_overPanel:Panel;
		protected var m_selectPanel:Panel;
		
		public function ItemBase(param:Object)
		{
			super();
			m_TFBSysData = param["data"] as UITFBSysData;
			m_overPanel = param["over"];
			m_selectPanel = param["select"];
			
			this.setSize(308, 20);

			m_lblName = new Label(this, 35, 0, "名字");
			m_lblLvl = new Label(this, 160, 0, "等级");
			m_lblZL = new Label(this, 230, 0, "战力");

			this.doubleClickEnabled = true;
		}
		
		// 设置数据
		override public function setData(data:Object):void
		{
			super.setData(data);
			var item:InviteUiData = data as InviteUiData;
			
			// 设置 UI
			m_lblName.text = item.name;
			m_lblLvl.text = item.level + "";
			m_lblZL.text = item.zhanli + "";
		}

		override public function onOver():void 
		{
			if (this.select == false && m_overPanel.parent != this)
			{				
				this.addChildAt(m_overPanel, 0);
			}
		}
		
		override public function onOut():void 
		{
			if (this.select == false && m_overPanel.parent == this)
			{
				this.removeChild(m_overPanel);
			}
		}
		
		override public function onSelected():void 
		{
			super.onSelected();
			if (m_selectPanel.parent != this)
			{
				this.addChildAt(m_selectPanel, 0);		
			}
			
			// 选择某一项
			m_TFBSysData.m_inviteClkCB(this.index);
		}
		
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			if (m_selectPanel.parent == this)
			{
				this.removeChild(m_selectPanel);
			}
		}
	}
}