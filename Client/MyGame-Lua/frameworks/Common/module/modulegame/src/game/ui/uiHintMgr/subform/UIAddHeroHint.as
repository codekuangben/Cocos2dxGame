package game.ui.uiHintMgr.subform
{
	/**
	 * ...
	 * @author wangtianzhu
	 * 获得武将时提示
	 */
	
	import com.ani.AniPropertys;
	import com.bit101.components.Panel;
	import modulecommon.ui.Form;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiHintMgr.HintTool;
	import game.ui.uiHintMgr.UIHintMgr;
	
	public class UIAddHeroHint extends UIHint
	{
		private var m_wu:WuHeroProperty;	//加入的武将
		private var m_wuHeadPanel:Panel;	//武将头像卡牌
		private var infotype:int;	//提示类型
		
		public function UIAddHeroHint(mgr:UIHintMgr)
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{			
			m_wuHeadPanel = new Panel(this,20,35);
			m_wuHeadPanel.setSize(WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
			
			m_wuHeadPanel.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_wuHeadPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			super.onReady();
		}
		
		public function addWuHero(wu:WuHeroProperty):void
		{
			m_wu = wu;
			m_wuHeadPanel.setPanelImageSkin(m_wu.squareHeadPathName);
			
			var str:String = "";
			UtilHtml.beginCompose();
			switch(infotype)
			{
				case HintMgr.ADDHERO_REFRESHNUM:
				{
					UtilHtml.add(m_wu.fullName,m_wu.colorValue);
					UtilHtml.addStringNoFormat("率领");
					UtilHtml.addStringNoFormat(m_wu.soldierName);
					UtilHtml.addStringNoFormat("【");
					UtilHtml.addStringNoFormat(m_wu.zhenweiName);
					UtilHtml.addStringNoFormat("】");
					UtilHtml.addStringNoFormat("加入您的势力,");
					UtilHtml.add(m_wu.fullName,m_wu.colorValue);
					UtilHtml.addStringNoFormat("拥有数量+1");
					str = UtilHtml.getComposedContent();
					m_funBtn.label = "知道了";
				}
				break;
				case HintMgr.ADDHERO_CHANGMATRIX:
				{
					UtilHtml.add(m_wu.fullName,m_wu.colorValue);
					UtilHtml.addStringNoFormat("加入您的势力。他比出战武将更威猛,是否立刻让他上阵?");
					str = UtilHtml.getComposedContent();
					m_funBtn.label = "立刻变阵";
				}
				break;
				case HintMgr.ADDHERO_HEROACTIVE:
				{
					UtilHtml.add(m_wu.fullName,m_wu.colorValue);
					UtilHtml.addStringNoFormat("率领");
					UtilHtml.addStringNoFormat(m_wu.soldierName);
					UtilHtml.addStringNoFormat("【");
					UtilHtml.addStringNoFormat(m_wu.zhenweiName);
					UtilHtml.addStringNoFormat("】");
					UtilHtml.addStringNoFormat("加入您的势力,");
					var collector:Vector.<WuHeroProperty> = new Vector.<WuHeroProperty>();
					var collectParam:Object = new Object();
					collectParam["hero"] = m_wu;
					collectParam["collector"] = collector;
					m_gkcontext.m_wuMgr.exeFunForEachHero(HintTool.collectActivedHerosByhero, collectParam);
					var i:int;
					for(i = 0; i < collector.length; i++)
					{
						UtilHtml.add(collector[i].fullName,collector[i].colorValue);
						if(i < collector.length -1)
						{
							UtilHtml.addStringNoFormat("、");
						}
					}
					UtilHtml.addStringNoFormat("获得激活，属性提升。");
					str = UtilHtml.getComposedContent();
					m_funBtn.label = "知道了";
				}
				break;
				case HintMgr.ADDHERO_REBIRTH:
				{
					UtilHtml.add(m_wu.fullName,m_wu.colorValue);
					UtilHtml.addStringNoFormat("可以转生了，转生后可获得更强大的属性,是否立刻转生?");
					str = UtilHtml.getComposedContent();
					m_funBtn.label = "立刻转生";
				}
				break;
			}
			
			this.setText(str);
		}
		
		override protected function onFunBtnClick(e:MouseEvent):void 
		{
			switch(infotype)
			{
				case HintMgr.ADDHERO_CHANGMATRIX:
				{
					//TODO 打开阵法界面
					if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa) == false)
					{				
						m_gkcontext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);						
					}
				}
				break;
				case HintMgr.ADDHERO_REBIRTH:
				{
					//TODO 打开转生界面(人物界面)
					var formPack:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBackPack);
					if (formPack)
					{
						if (false == formPack.isVisible())
						{
							formPack.show();
						}
					}
					else
					{					
						m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIBackPack);
					}
				}
				break;
			}
			
			exit();		
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			//TODO 隐藏武将tips
			m_gkcontext.m_uiTip.hideTip();
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			//TODO 显示武将tips
			var pt:Point = m_wuHeadPanel.localToScreen(new Point(m_wuHeadPanel.width, 0));
			if (m_gkcontext.m_uiTip)
			{
				m_gkcontext.m_uiTip.hintWu(pt, m_wu.m_uHeroID, m_wuHeadPanel.width);
			}
		}
		
		public function setInfoType(itype:int):void
		{
			infotype = itype;
		}
		
	}
}