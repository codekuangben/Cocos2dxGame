package game.ui.uibackpack.fastswapequips 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.propertyUserCmd.stReqBatchMoveObjPropertyUserCmd;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIFastSwapEquips;
	import game.ui.uibackpack.wujiang.EquipBgShare;
	/**
	 * ...
	 * @author ...
	 * 一键换装备
	 */
	public class UIFastSwapEquips extends FormStyleNine implements IUIFastSwapEquips
	{
		public static const SITE_Left:uint = 0;			//左
		public static const SITE_Right:uint = 1;		//右
		
		private var m_vecDicPanel:Vector.<Dictionary>;
		private var m_leftWulist:Swap_BtnWuList;		//左边武将列表
		private var m_rightWulist:Swap_BtnWuList;		//右边武将列表
		private var m_vecEquipBgShare:Vector.<EquipBgShare>;
		private var m_fastSwapBtn:Swap_FastSwapBtn;
		
		public function UIFastSwapEquips() 
		{
			this.id = UIFormID.UIFastSwapEquips;
			this.hideOnCreate = true;
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			m_vecDicPanel = new Vector.<Dictionary>(2);
			m_vecDicPanel[SITE_Left] = new Dictionary();
			m_vecDicPanel[SITE_Right] = new Dictionary();
			
			m_leftWulist = new Swap_BtnWuList(m_gkcontext, this, this, 18, 20);
			m_rightWulist = new Swap_BtnWuList(m_gkcontext, this, this, 710, 20);
			
			m_vecEquipBgShare = new Vector.<EquipBgShare>(2);
			m_vecEquipBgShare[SITE_Left] = new EquipBgShare();
			m_vecEquipBgShare[SITE_Right] = new EquipBgShare();
			
			m_fastSwapBtn = new Swap_FastSwapBtn(m_gkcontext, this, this, 380, 340);
			
			var panelContainer:PanelContainer;
			var panel:Panel;
			beginPanelDrawBg(862, 560);
			//m_bgPart.addContainer();
			panelContainer = new PanelContainer(null, 155, 35);
			panelContainer.setSize(268, 458);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeTwo);
			m_bgPart.addDrawCom(panelContainer);
			
			panel = new Panel(null, 160, 42);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/wuEquipBG.png");
			m_bgPart.addDrawCom(panel);
			
			panelContainer = new PanelContainer(null, 435, 35);
			panelContainer.setSize(268, 458);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeTwo);
			m_bgPart.addDrawCom(panelContainer);
			
			panel = new Panel(null, 440, 42);
			panel.setPanelImageSkin("commoncontrol/panel/backpack/wuEquipBG.png");
			m_bgPart.addDrawCom(panel);
			
			panel = new Panel(null, 14, 495);
			panel.autoSizeByImage = false;
			panel.setSize(834, 52);
			panel.setHorizontalImageRepeatSkin("commoncontrol/horizontalrepeat/decorate.swf");
			m_bgPart.addDrawCom(panel);
			
			endPanelDraw();
			setTitleDraw(282, "commoncontrol/panel/backpack/swapequips/word_swapequips.png", null, 90);
		}
		
		public function initData(curheroid:uint):void
		{
			var curHeroIDRight:uint = getHeroIdOpposite(curheroid);
			
			m_leftWulist.initData(curheroid, SITE_Left);
			m_rightWulist.initData(curHeroIDRight, SITE_Right);
			
			showPanel(curheroid, SITE_Left);
			showPanel(curHeroIDRight, SITE_Right);
		}
		
		public function updateWuData(heroid:uint):void
		{
			var wupanel:Swap_Equip;
			
			wupanel = m_vecDicPanel[SITE_Left][heroid] as Swap_Equip;
			if (wupanel)
			{
				wupanel.updateWuData();
			}
			
			wupanel = m_vecDicPanel[SITE_Right][heroid] as Swap_Equip;
			if (wupanel)
			{
				wupanel.updateWuData();
			}
		}
		
		public function showPanel(heroID:uint, site:uint):void
		{
			var wu:WuProperty;
			var panel:Swap_Equip;
			
			if (m_vecDicPanel[site][heroID] == undefined)
			{
				wu = m_gkcontext.m_wuMgr.getWuByHeroID(heroID);
				panel = new Swap_Equip(this, this, m_gkcontext, wu);
				if (SITE_Left == site)
				{
					panel.setPos(160, 42);
				}
				else
				{
					panel.setPos(440, 42);
				}
				
				m_vecDicPanel[site][heroID] = panel;
			}
			
			for each(var item:Swap_Equip in m_vecDicPanel[site])
			{
				panel = item;
				if (panel.heroID == heroID)
				{
					panel.show();
					panel.onShowThisWu(m_vecEquipBgShare[site]);
				}
				else
				{
					panel.hide();				
				}
			}
		}
		
		override public function updateData(param:Object = null):void
		{
			super.updateData(param);
			
			var obj:ZObject = param as ZObject;
			var panel:Swap_Equip;
			
			for (var i:int = 0; i < 2; i++)
			{
				panel = m_vecDicPanel[i][obj.m_object.m_loation.heroid] as Swap_Equip;
				if (panel)
				{
					panel.addObject(obj);
				}
			}
		}
		
		override public function dispose():void
		{
			m_vecEquipBgShare[SITE_Left].disposAll();
			m_vecEquipBgShare[SITE_Right].disposAll();
			
			var wupanel:Swap_Equip;
			for each(wupanel in m_vecDicPanel[SITE_Left])
			{
				wupanel.disposeWhenParentEqualNull();
			}
			
			for each(wupanel in m_vecDicPanel[SITE_Right])
			{
				wupanel.disposeWhenParentEqualNull();
			}
			
			super.dispose();
		}
		
		public function startSwapEquips():void
		{
			if (m_leftWulist.curSelectHeroID == m_rightWulist.curSelectHeroID)
			{
				m_gkcontext.m_systemPrompt.prompt("相同武将不能交换装备");
				return;
			}
			
			var i:int;
			var idx:int;
			var vecThisID:Vector.<uint> = new Vector.<uint>();
			var vecLocation:Vector.<stObjLocation> = new Vector.<stObjLocation>;
			var objpanel:ObjectPanel;
			
			var vecEquipLeft:Vector.<ObjectPanel> = (m_vecDicPanel[SITE_Left][m_leftWulist.curSelectHeroID] as Swap_Equip).vecObjPanel;
			var vecEquipRight:Vector.<ObjectPanel> = (m_vecDicPanel[SITE_Right][m_rightWulist.curSelectHeroID] as Swap_Equip).vecObjPanel;
			
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				if (vecEquipLeft[i].thisID)
				{
					vecThisID.push(vecEquipLeft[i].thisID);
					vecLocation.push(vecEquipRight[i].objLocation);
					
					vecEquipLeft[i].objectIcon.removeZObject();
				}
				
				if ((0 == vecEquipLeft[i].thisID) && vecEquipRight[i].thisID)
				{
					vecThisID.push(vecEquipRight[i].thisID);
					vecLocation.push(vecEquipLeft[i].objLocation);
					
					vecEquipRight[i].objectIcon.removeZObject();
				}
			}
			
			var cmd:stReqBatchMoveObjPropertyUserCmd = new stReqBatchMoveObjPropertyUserCmd();
			for (i = 0; i < vecThisID.length; i++)
			{
				cmd.push(vecThisID[i], vecLocation[i]);
			}
			m_gkcontext.sendMsg(cmd);
		}
		
		//获得右边显示武将id
		public function getHeroIdOpposite(heroid:uint):uint
		{
			var ret:uint;
			var arOut:Array = m_gkcontext.m_wuMgr.getFightWuList(true, true);
			var arIn:Array = m_gkcontext.m_wuMgr.getFightWuList(false, true);
			
			var wu:WuProperty = m_gkcontext.m_wuMgr.getWuByHeroID(heroid);
			if (wu.chuzhan)
			{
				if (arIn.length)
				{
					ret = (arIn[0] as WuProperty).m_uHeroID;
				}
				else
				{
					ret = (arOut[arOut.length - 1] as WuProperty).m_uHeroID;
				}
			}
			else
			{
				ret = WuProperty.MAINHERO_ID;
			}
			
			return ret;
		}
		
	}

}