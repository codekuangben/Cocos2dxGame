package game.ui.uibenefithall.subcom.peoplerank.pagestyle2 
{
	import com.bit101.components.Ani;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import modulecommon.scene.benefithall.peoplerank.RankReward;
	import modulecommon.scene.benefithall.peoplerank.RankRewardObj;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankAwardItemV extends CtrolVHeightComponent 
	{
		private var m_dataBenefitHall:DataBenefitHall;
		private var m_ranks_Style1:Ranks_Style1;
		private var m_objPanel:ObjectPanel;
		private var m_rankReward:RankReward;
		private var m_myRankLabel:Label;
		private var m_ani:Ani;
		public function RankAwardItemV(param:Object=null) 
		{
			super();
			m_dataBenefitHall = param["data"];
			m_ranks_Style1 = param["ranks"];
			m_objPanel = new ObjectPanel(m_dataBenefitHall.m_gkContext, this, 158, 9);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.showObjectTip = true;	
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
			m_rankReward = _data as RankReward;
			
			var str:String;
			str = "第" + m_rankReward.m_fromrank + "-" + m_rankReward.m_torank + "名";
			var label:Label = new Label(this, 76, 24, str, UtilColor.WHITE_Yellow, 14);
			label.align = CENTER;
			label.setBold(true);				
			label.text = str;
			
			var obj:RankRewardObj = m_rankReward.m_obj;
			var objZ:ZObject = ZObject.createClientObject(obj.m_id, obj.m_num, obj.m_upgrade);
			if (objZ.m_object.m_equipData)
			{
				objZ.m_object.m_equipData.enhancelevel = obj.m_enchance;
			}
			m_ani = new Ani(m_dataBenefitHall.m_gkContext.m_context,m_objPanel,23,23);
			m_ani.duration = 2;
			m_ani.repeatCount = 0;
			m_ani.centerPlay = true;
			m_ani.mouseEnabled = false;
			m_ani.setImageAni(ZObjectDef.getObjAniResName(obj.m_upgrade));
			m_ani.setAutoStopWhenHide();
			m_ani.begin();
			if (obj.m_num != 1)
			{
				m_objPanel.objectIcon.showNum = true;
			}
			m_objPanel.objectIcon.setZObject(objZ);
		}
		override public function update():void 
		{
			super.update();
			
			var data:stRetRankRewardRankInfoCmd = m_dataBenefitHall.getRankByDay(m_ranks_Style1.m_day);
			if (data == null)
			{
				return;
			}
			
			if (data.selfrank >= m_rankReward.m_fromrank && data.selfrank <= m_rankReward.m_torank)
			{
				showMyRank();
			}
			else
			{
				hideMyRank();
			}
		}
		private function showMyRank():void
		{
			if (m_myRankLabel == null)
			{
				m_myRankLabel = new Label(this, 304, 24, "我的排名", UtilColor.WHITE_Yellow, 14);
				m_myRankLabel.underline = true;
				m_myRankLabel.setBold(true);
			}
			m_myRankLabel.mouseEnabled = true;
			m_myRankLabel.visible=true;
		}
		private function hideMyRank():void
		{
			if (m_myRankLabel)
			{
				m_myRankLabel.visible = false;
			}
		}
		override public function dispose():void 
		{
			m_ani.disposeEx();
			super.dispose();
		}
	}

}