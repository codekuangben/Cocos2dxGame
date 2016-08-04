package game.ui.uibackpack.wujiang
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uibackpack.UIBackPack;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuPanel extends Component
	{
		private var m_allWuPanel:AllWuPanel;
		private var m_wu:WuProperty; //0 - 主角, 其它值表示武将(即战斗npc表内npcID)
		private var m_gkContext:GkContext;
		private var m_vecPanel:Vector.<SubBase>;
		private var m_parent:DisplayObjectContainer;
		public  var m_relationWu:WuRelationPanel;
		
		public function WuPanel(allPanel:AllWuPanel, parent:DisplayObjectContainer, gk:GkContext, heroid:uint)
		{
			m_allWuPanel = allPanel;
			
			m_gkContext = gk;
			m_wu = m_gkContext.m_wuMgr.getWuByHeroID(heroid);
			m_parent = parent;
			
			m_vecPanel = new Vector.<SubBase>(AllWuPanel.PAGE_NUM);
			
			if (m_wu is WuHeroProperty)
			{
				m_relationWu = new WuRelationPanel(allPanel, m_gkContext, null, 0, 188);
				m_relationWu.setWu(m_wu as WuHeroProperty);
			}
		}
		
		public function show(subID:uint):void
		{
			if (this.parent != m_parent)
			{
				m_parent.addChild(this);
				showSubPanel(subID);
			}
			update();
			
			//if (m_relationWu)
			//{
			//	m_relationWu.newHnadMoveToCard();
			//}
		}
		
		public function hide():void
		{
			if (this.parent == m_parent)
			{
				m_parent.removeChild(this);
			}
		}
		
		public function update():void
		{
			var subBase:SubBase;
			for (var i:int = 0; i < AllWuPanel.PAGE_NUM; i++)
			{
				subBase = m_vecPanel[i];
				if (subBase)
				{
					subBase.invalidate();
				}
			}
			
			if (m_relationWu)
			{
				m_relationWu.update();
			}
			
			(m_gkContext.m_UIs.backPack as UIBackPack).updateRelationWuPanel();
		}
		
		public function showSubPanel(subID:uint):void
		{
			var subBase:SubBase;
			for (var i:int = 0; i < AllWuPanel.PAGE_NUM; i++)
			{
				subBase = m_vecPanel[i];
				if (i == subID)
				{
					if (subBase == null)
					{
						createSubPanel(subID);
						//subBase = m_vecPanel[i];
						//if (this.parent)
						//{
						//	subBase.onShowThisWu();
						//}
					}
					subBase = m_vecPanel[i];
					subBase.show();
					if (this.parent)
					{
						subBase.onShowThisWu();
					}
				}
				else
				{
					if (subBase)
					{
						subBase.hide();
					}
				}
			}
		}
		
		private function createSubPanel(subID:uint):void
		{
			var cl:Class;
			if (subID == AllWuPanel.PAGE_EQUIP)
			{
				cl = SubEquip;
			}
			else if (subID == AllWuPanel.PAGE_ATTR)
			{
				cl = SubAttr;
			}
			else
			{
				cl = SubTrain;
			}
			m_vecPanel[subID] = new cl(m_allWuPanel, this, m_gkContext, m_wu);
			m_vecPanel[subID].setPos(6, 8);
		}
		
		override public function dispose():void
		{
			var subBase:SubBase;
			for (var i:int = 0; i < AllWuPanel.PAGE_NUM; i++)
			{

				subBase = m_vecPanel[i];
				if (subBase && subBase.parent == null)
				{
					subBase.dispose();
				}
			}
			super.dispose();
		}
		
		public function addObject(obj:ZObject):void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				(subBase as SubEquip).addObject(obj);
			}		
		}
		
		public function removeObject(obj:ZObject):void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				(subBase as SubEquip).removeObject(obj);
			}			
		}
		
		public function updateObject(obj:ZObject):void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				(subBase as SubEquip).updateObject(obj);
			}
		}
		public function onEquipDrag(obj:ZObject):void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				(subBase as SubEquip).onEquipDrag(obj);
			}			
		}
		public function onEquipDrop(obj:ZObject):void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				(subBase as SubEquip).onEquipDrop(obj);
			}			
		}
		public function get heroID():uint
		{
			return m_wu.m_uHeroID;
		}
		public function onUIBackPackShow():void
		{
			var subBase:SubBase = m_vecPanel[AllWuPanel.PAGE_EQUIP];
			if (subBase)
			{
				subBase.onUIBackPackShow()
			}
		}
		public function updateTraniDatas():void
		{
			(m_vecPanel[AllWuPanel.PAGE_TRAIN] as SubTrain).updateTraniData();
		}
		
		public function updateZhanshu():void
		{
			var subequip:SubEquip = m_vecPanel[AllWuPanel.PAGE_EQUIP] as SubEquip;
			if (subequip)
			{
				subequip.updateZhanshu();
			}
		}
	}

}