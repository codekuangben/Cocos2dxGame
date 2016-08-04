package game.ui.uibenefithall.subcom.peoplerank.pagestyle2 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
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
	public class RankAwardItemFirst extends Component 
	{
		private var m_dataBenefitHall:DataBenefitHall;
		private var m_ranks_Style1:Ranks_Style1;
		private var m_objPanel:ObjectPanel;
		private var m_rankReward:RankReward;
		private var m_myRankLabel:Label;
		private var m_ani:Ani;
		public function RankAwardItemFirst(param:Object=null,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = param["data"];
			m_ranks_Style1 = param["ranks"];
			m_objPanel = new ObjectPanel(m_dataBenefitHall.m_gkContext, this,147,110);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.showObjectTip = true;	
		}
		public function setData(_data:Object):void 
		{
			m_rankReward = _data as RankReward;
			var obj:RankRewardObj = m_rankReward.m_obj;
			var objZ:ZObject = ZObject.createClientObject(obj.m_id, obj.m_num, obj.m_upgrade);
			m_ani = new Ani(m_dataBenefitHall.m_gkContext.m_context,m_objPanel,23,23);
			m_ani.duration = 2;
			m_ani.repeatCount = 0;
			m_ani.centerPlay = true;
			m_ani.mouseEnabled = false;
			m_ani.setImageAni(ZObjectDef.getObjAniResName(obj.m_upgrade));
			m_ani.setAutoStopWhenHide();
			m_ani.begin();
			if (objZ.m_object.m_equipData)
			{
				objZ.m_object.m_equipData.enhancelevel = obj.m_enchance;
				objZ.m_object.m_equipData.basePropEnhance = objZ.computeBasePropEnhance();
			}
			if (obj.m_num == 1)
			{
				m_objPanel.objectIcon.showNum = false;
			}
			m_objPanel.objectIcon.setZObject(objZ);
		}
		public function update():void 
		{
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
				m_myRankLabel = new Label(this, 136, 178, "我的排名", UtilColor.WHITE_Yellow, 14);
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