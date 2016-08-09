package modulecommon.scene.fight
{
	import com.dnd.DragManager;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.stNotifyFightNumLimitUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.stNotifyOpenZhenWeiCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRetKitListCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRetMatrixInfoCmd;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroPositionCmd;
	import modulecommon.net.msg.sceneHeroCmd.stSetJinNangCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownKitCmd;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import com.util.UtilCommon;
	import modulecommon.uiinterface.IUIWuXiaye;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ZhenfaMgr
	{
		//阵法格子编号定义
		static public const ZHENFAGRID_NO1:int = 0;
		static public const ZHENFAGRID_NO2:int = 1;
		static public const ZHENFAGRID_NO3:int = 2;
		static public const ZHENFAGRID_NO4:int = 3;
		static public const ZHENFAGRID_NO5:int = 4;
		static public const ZHENFAGRID_NO6:int = 5;
		static public const ZHENFAGRID_NO7:int = 6;
		static public const ZHENFAGRID_NO8:int = 7;
		static public const ZHENFAGRID_NO9:int = 8;
		static public const ZHENFAGRID_NUM:int = 9;
		static public const ZHENFAGRID_INVALID:int = -1;
		
		static public const ZHENFAJINNANG_NO1:int = 0;
		static public const ZHENFAJINNANG_NO2:int = 1;
		static public const ZHENFAJINNANG_NO3:int = 2;
		static public const ZHENFAJINNANG_NO4:int = 3;
		static public const ZHENFAJINNANG_INVALID:int = -1;
		
		static public const ZHENWEI_FRONT:int = 1; //阵位 - 前军
		static public const ZHENWEI_MIDDLE:int = 2; //阵位 - 中军
		static public const ZHENWEI_BACK:int = 3; //阵位 - 后军
		
		static public const ZHENFA_MAX_HEROS:int = 5;	//上阵武将总数(包括玩家自己)
		//------------------
		private var m_vecGrid:Vector.<uint>;
		private var m_vecJinnang:Vector.<uint>;
		private var m_wuScore:uint;
		private var m_zhanfaScore:int;
		private var m_gridOpenFlag:uint;
		private var m_swapEquipWuSor:WuProperty;
		private var m_swapEquipWuDest:WuProperty;
		
		private var m_gkContext:GkContext;
		private var m_dataLoaded:Boolean;
		public var m_bShowTip:Boolean;		//屏幕中间是否出黄字提示
		public var m_zhenfaHerosUp:uint;	//当前上阵武将最大数
		
		public function ZhenfaMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_bShowTip = false;
		}
		
		public function initData(msg:ByteArray):void
		{
			var rev:stRetMatrixInfoCmd = new stRetMatrixInfoCmd();
			rev.deserialize(msg);
			m_dataLoaded = true;
			
			m_gridOpenFlag = rev.zhenweiOpenFlag;
			
			m_vecGrid = rev.grid;
			m_vecJinnang = rev.jinnang;
			m_wuScore = rev.wuScore;
			m_zhanfaScore = rev.zhanfaScore;					
			if (m_gkContext.m_UIs.teamFBZX)
			{
				m_gkContext.m_UIs.teamFBZX.onLoadZhenfaData();
			}
			m_gkContext.m_ggzjMgr.onLoadWu();
		}
		
		public function processNotifyOpenZhenWeiCmd(msg:ByteArray):void
		{
			var rev:stNotifyOpenZhenWeiCmd = new stNotifyOpenZhenWeiCmd();
			rev.deserialize(msg);
			m_gridOpenFlag = UtilCommon.setStateUint(m_gridOpenFlag, rev.pos);
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.openGrid(rev.pos);
			}
		}
		
		public function getGrids(NO:uint):uint
		{
			return m_vecGrid[NO];
		}
		
		public function takeDownFromZhenfa(msg:ByteArray):void
		{			
			var rev:stTakeDownFromMatrixCmd = new stTakeDownFromMatrixCmd();
			rev.deserialize(msg);
			takeDownHero(rev.heroid);			
		}
		public function takeDowHeros(list:Array):void
		{
			var i:int = 0;
			for (i = 0; i < list.length; i++)
			{
				takeDownHero(list[i]);
			}
		}
		//将指定武将从阵法中删除
		public function takeDownHero(heroID:uint, bDelete:Boolean=false):void
		{
			if (m_dataLoaded == false) return;
			
			var wu:WuProperty = m_gkContext.m_wuMgr.getWuByHeroID(heroID);
			if (wu == null)
			{
				return;
			}
			var pos:int = heroToPos(heroID);
			if (pos == -1)
			{
				return;
			}
			
			DragManager.drop();
			m_gkContext.m_wuMgr.setWuAntiChuzhan(wu);
			
			m_vecGrid[pos] = 0;
			//更新武将列表
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.generateBtnList();
			}
			//更新阵法列表
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.clearWuByPos(pos);
				m_gkContext.m_UIs.zhenfa.buildList();
			}
			//更新武将库列表
			var uiwuxiaye:IUIWuXiaye = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye) as IUIWuXiaye;
			if (uiwuxiaye)
			{
				uiwuxiaye.updateNotXiayeList();
			}
			
			if (bDelete == false && m_gkContext.m_UIs.equipSys)
			{
				m_gkContext.m_UIs.equipSys.sortList();
			}
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIGgzjWuList) as IForm;
			if (ui)
			{
				ui.updateData(1);
			}
			
			if (m_bShowTip)
			{
				m_gkContext.m_systemPrompt.prompt(wu.fullName + "  下阵");
				m_bShowTip = false;
			}
		}
		
		public function setWuPos(msg:ByteArray):void
		{
			if (m_dataLoaded == false) return;
			var rev:stSetHeroPositionCmd = new stSetHeroPositionCmd();
			rev.deserialize(msg);
			var sorPos:int = heroToPos(rev.heroid);
			var destHeroid:uint = m_vecGrid[rev.pos];
			var wuSor:WuProperty = m_gkContext.m_wuMgr.getWuByHeroID(rev.heroid);
			
			var strSorPrompt:String;
			var strDestPrompt:String;
			if (DragManager.isDragging() == true)
			{
				m_bShowTip = true;
			}
			DragManager.drop();
			if (destHeroid != 0)
			{
				if (m_gkContext.m_UIs.zhenfa)
				{
					m_gkContext.m_UIs.zhenfa.clearWuByPos(rev.pos);
				}
			}
			if (sorPos != ZHENFAGRID_INVALID)
			{
				if (m_gkContext.m_UIs.zhenfa)
				{
					m_gkContext.m_UIs.zhenfa.clearWuByPos(sorPos);
				}
				
				strSorPrompt = " 更换阵位";
			}
			else
			{
				
				strSorPrompt = " 上阵";
			}
			
			strSorPrompt = wuSor.fullName + strSorPrompt;
			if (destHeroid != 0)
			{				
				var wuDest:WuProperty = m_gkContext.m_wuMgr.getWuByHeroID(destHeroid);
				if (sorPos == ZHENFAGRID_INVALID)
				{
					showSwapEquipsPrompt(wuSor, wuDest);
					
					m_gkContext.m_wuMgr.setWuAntiChuzhan(wuDest);					
					strDestPrompt = wuDest.fullName+ " 下阵";
				}
				else
				{
					m_vecGrid[sorPos] = destHeroid;
					if (m_gkContext.m_UIs.zhenfa)
					{						
						m_gkContext.m_UIs.zhenfa.setWuPos(destHeroid, sorPos);
					}
					
					strDestPrompt = wuDest.fullName+ " 更换阵位";
				}
			}
			
			if (sorPos != ZHENFAGRID_INVALID)
			{				
				if (destHeroid == 0)
				{
					m_vecGrid[sorPos] = 0;					
				}				
			}
			else
			{
				m_gkContext.m_wuMgr.setWuChuzhan(wuSor);				
			}
			
			m_vecGrid[rev.pos] = rev.heroid;
			
			//更新武将列表
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.generateBtnList();
			}
			//更新阵法列表
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.setWuPos(rev.heroid, rev.pos);
				m_gkContext.m_UIs.zhenfa.buildList();
			}
			//更新武将库列表
			var uiwuxiaye:IUIWuXiaye = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye) as IUIWuXiaye;
			if (uiwuxiaye)
			{
				uiwuxiaye.updateNotXiayeList();
			}
			if (m_gkContext.m_UIs.equipSys)
			{
				m_gkContext.m_UIs.equipSys.sortList();
			}
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIGgzjWuList) as IForm;
			if (ui)
			{
				ui.updateData(1);
			}
			
			if (m_bShowTip)
			{
				if (strDestPrompt)
				{
					strSorPrompt += "   "+strDestPrompt;
				}
				m_gkContext.m_systemPrompt.prompt(strSorPrompt);
				
				m_bShowTip = false;
			}
		}
		
		public function setJinnangPos(msg:ByteArray):void
		{
			if (m_dataLoaded == false) return;
			
			var rev:stSetJinNangCmd = new stSetJinNangCmd();
			rev.deserialize(msg);
			
			var sorPos:int = jinnangToPos(rev.jinnangID);
			var destID:uint = m_vecJinnang[rev.dstID];
						
			DragManager.drop();
			if (sorPos != ZHENFAJINNANG_INVALID)
			{
				if (destID != 0)
				{
					m_vecJinnang[sorPos] = destID;
					if (m_gkContext.m_UIs.zhenfa)
					{
						m_gkContext.m_UIs.zhenfa.setJinnang(destID, sorPos);
					}
				}
				else
				{
					m_vecJinnang[sorPos] = destID;
					if (m_gkContext.m_UIs.zhenfa)
					{
						m_gkContext.m_UIs.zhenfa.clearJinnang(sorPos);
					}
				}
			}
			
			m_vecJinnang[rev.dstID] = rev.jinnangID;
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.setJinnang(rev.jinnangID, rev.dstID);
			}
			
		}
		
		public function takeDownKit(msg:ByteArray):void
		{
			if (m_dataLoaded == false) return;
			var rev:stTakeDownKitCmd = new stTakeDownKitCmd();
			rev.deserialize(msg);
			m_vecJinnang[rev.kitPos] = 0;
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.clearJinnang(rev.kitPos);
			}
			DragManager.drop();
		}
		
		public function setJinnangList(msg:ByteArray):void
		{
			var rev:stRetKitListCmd = new stRetKitListCmd();
			rev.deserialize(msg);
			m_vecJinnang = rev.jinnang;
		}
		public function getJinnangList():Vector.<uint>
		{
			return m_vecJinnang;
		}
		public function heroToPos(heroID:uint):int
		{
			return m_vecGrid.indexOf(heroID);
		}
		
		public function jinnangToPos(jinnangID:uint):int
		{
			return m_vecJinnang.indexOf(jinnangID);
		}
		
		public function get dataLoaded():Boolean
		{
			return m_dataLoaded;
		}
		
		public function isGridOpen(gridNo:int):Boolean
		{
			return UtilCommon.isSetUint(m_gridOpenFlag, gridNo);
		}
		
		//获得武将在阵法中的所在阵位
		public function heroInZhenWei(heroID:uint):int
		{
			var ret:int;
			var pos:int = m_vecGrid.indexOf(heroID);
			if (pos < 3)
			{
				ret = ZHENWEI_FRONT;
			}
			else if (pos < 6)
			{
				ret = ZHENWEI_MIDDLE;
			}
			else if (pos < 9)
			{
				ret = ZHENWEI_BACK;
			}
			else
			{
				ret = -1;
			}
			
			return ret;
		}
		
		public function processNotifyFightnumLimitUserCmd(msg:ByteArray):void
		{
			var ret:stNotifyFightNumLimitUserCmd = new stNotifyFightNumLimitUserCmd();
			ret.deserialize(msg);
			m_zhenfaHerosUp = ret.m_num;
			
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.updateZhenfaHerosUp();
			}
		}
		
		//显示两武将交换装备提示
		public function showSwapEquipsPrompt(wuSor:WuProperty, wuDest:WuProperty):void
		{
			if (m_gkContext.m_objMgr.hasEquipForWus(wuDest.m_uHeroID))
			{
				m_swapEquipWuSor = wuSor;
				m_swapEquipWuDest = wuDest;
				
				UtilHtml.beginCompose();
				UtilHtml.add("请问您是否要将 ", 0xfbdda2, 14);
				UtilHtml.add(wuDest.fullName, wuDest.colorValue, 14);
				UtilHtml.add(" 和 ", 0xfbdda2, 14);
				UtilHtml.add(wuSor.fullName, wuSor.colorValue, 14);
				UtilHtml.add(" 身上的装备进行交换?", 0xfbdda2, 14);
				
				m_gkContext.m_confirmDlgMgr.showMode1(0, UtilHtml.getComposedContent(), onConfirmFun, null, "确定", "取消");
			}
		}
		
		private function onConfirmFun():Boolean
		{
			if (m_swapEquipWuSor && m_swapEquipWuDest)
			{
				m_gkContext.m_objMgr.swapEquipsOfTwoHero(m_swapEquipWuSor.m_uHeroID, m_swapEquipWuDest.m_uHeroID);
				
				m_swapEquipWuSor = null;
				m_swapEquipWuDest = null;
			}
			
			return true;
		}
	}

}