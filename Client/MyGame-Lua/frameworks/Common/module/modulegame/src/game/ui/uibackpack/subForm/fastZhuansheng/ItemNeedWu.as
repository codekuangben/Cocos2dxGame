package game.ui.uibackpack.subForm.fastZhuansheng
{
	
	/**
	 * ...
	 * @author
	 */
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.jiuguan.ItemPurpleWu;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRecruit;
	import game.ui.uibackpack.UIBackPack;
	
	public class ItemNeedWu extends ItemNeedBase
	{
		private var m_heroID:uint;
		private var m_mgr:FastZhuanshengMgr;
		
		public function ItemNeedWu(gk:GkContext,mgr:FastZhuanshengMgr, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(gk, parent, xpos, ypos);
			m_mgr=mgr;
		}
		
		public function setHeroID(id:uint):void
		{
			m_heroID = id;
			var str:String;
			var color:uint;
			var bNeedObtain:Boolean = false;
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_heroID) as WuHeroProperty;
			if (wu)
			{
				str = wu.fullName;
				color = wu.colorValue;
			}
			else
			{
				var tableID:uint = m_heroID / 10;
				var add:int = m_heroID % 10;
				var base:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(tableID) as TNpcBattleItem;
				str = WuHeroProperty.s_fullName(add, base.m_name);
				color = WuHeroProperty.s_colorValue(base.m_uColor);
				bNeedObtain = true;
			}
			
			m_label.text = str;
			m_label.setFontColor(color);
			m_label.flush();
			if (bNeedObtain)
			{
				showObtainBtn();
				m_btnObtain.y = 2;
				m_btnObtain.x = m_label.width + 5;
				m_bSatisfied = false;
			}
			else
			{
				m_bSatisfied = true;
			}
			
		}
		
		override public function update():void
		{
			if (m_bSatisfied)
			{
				return;
			}
			
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_heroID) as WuHeroProperty;
			if (wu)
			{
				m_bSatisfied = true;
				hideObtainBtn();
			}
			else
			{
				m_bSatisfied = false;
			}
		}
		
		override protected function onClick(e:MouseEvent):void
		{
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getRelativeHighestWuByTableID(WuHeroProperty.tableIDOfWuID(m_heroID), WuHeroProperty.addOfWuID(m_heroID));
			if (wu && wu.add < WuHeroProperty.addOfWuID(m_heroID))
			{
				m_mgr.zhuansheng(wu);
			}
			else
			{
				if (false == m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JIUGUAN))
				{
					m_gkContext.m_systemPrompt.prompt("酒馆功能未开启");
					return;
				}
				
				var wuBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(WuHeroProperty.tableIDOfWuID(m_heroID));
				
				if (WuProperty.COLOR_PURPLE == wuBase.m_uColor)
				{
					if (!m_gkContext.m_jiuguanMgr.hasWu(wuBase.m_uID))
					{
						m_gkContext.m_systemPrompt.prompt(m_gkContext.m_jiuguanMgr.getOpenConditions(wuBase.m_uID) + " 可在酒馆中招募获得");
						return;
					}
					
					var item:ItemPurpleWu = m_gkContext.m_jiuguanMgr.getBaoWuPurpleWu(wuBase.m_uID);
					if (item)
					{
						m_gkContext.m_contentBuffer.addContent("uirecruitpurplewu_info", item);
						if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRecruitPurpleWu) == false)
						{
							m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruitPurpleWu);
						}
					}
				}
				else
				{
					var ui:IUIRecruit = m_gkContext.m_UIMgr.getForm(UIFormID.UIRecruit) as IUIRecruit;
					if (ui)
					{
						ui.setData(wuBase.m_uID);
					}
					else
					{
						m_gkContext.m_contentBuffer.addContent("uiRecruit_wuID", wuBase.m_uID);
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIRecruit);
					}
				}
			}
		
		}
	}

}