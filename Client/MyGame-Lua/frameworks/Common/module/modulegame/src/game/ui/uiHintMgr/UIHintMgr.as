package game.ui.uiHintMgr 
{
	import com.util.DebugBox;
	import flash.sampler.NewObjectSample;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.SysOptions;
	import game.ui.uiHintMgr.addobject.UIHintAddObjectAni;
	import game.ui.uiHintMgr.subform.UIActFeatureToDo;
	import game.ui.uiHintMgr.subform.UIGotoQanpc;
	import game.ui.uiHintMgr.subform.UIJinnangLevelUp;
	import game.ui.uiHintMgr.subform.UIRecruitHero;
	import game.ui.uiHintMgr.subform.UIZhenfaAddGrid;
	
	import flash.utils.Dictionary;
	
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiHintMgr.subform.UIAddHeroHint;
	import game.ui.uiHintMgr.subform.UIAddObjectHint;
	import game.ui.uiHintMgr.subform.UIAddSlaveHint;
	import game.ui.uiHintMgr.subform.UIHint;
	import game.ui.uiHintMgr.subform.UIFGFail;
	
	/**
	 * ...
	 * @author 
	 * 右下角的提示信息界面
	 * UIHintMgr对象一旦创建，便一直存在。不会被释放。系统中只会存在一份此对象
	 */
	public class UIHintMgr extends Form 
	{
		private var m_dicUIHint:Dictionary;
		private var m_uiHintAddObjectAni:UIHintAddObjectAni;
		
		public function UIHintMgr() 
		{
			m_dicUIHint = new Dictionary();
		}
		override public function onReady():void 
		{
			super.onReady();
			this.hideOnCreate = true;		
			m_gkcontext.m_hintMgr.uiHintMgr = this;
			
		}
		override public function onDestroy():void 
		{
			super.onDestroy();
			m_gkcontext.m_hintMgr.uiHintMgr = null;
		}
		public function createNewUIHint(hintClass:Class):Form
		{
			var formIDBegin:uint = UIFormID.UIHintMgr + 1;
			var formIDEnd:uint = UIFormID.UIHintMgr + 199;
			var formID:uint;
			for (formID = formIDBegin; formID <= formIDEnd; formID++)
			{
				if (m_dicUIHint[formID] == undefined)
				{
					break;
				}
			}
			
			if (formID > formIDEnd)
			{
				DebugBox.info("右下角的提示信息界面ID分配失败");
			}
			
			var ret:Form = new hintClass(this);
			ret.id = formID;
			m_dicUIHint[formID] = ret;
			m_gkcontext.m_UIMgr.addForm(ret);
			ret.show();
			
			return ret;			
		}
		
		public function createHintAddObjectAni():void
		{
			if (m_uiHintAddObjectAni == null)
			{
				m_uiHintAddObjectAni = new UIHintAddObjectAni();
				m_gkcontext.m_UIMgr.addForm(m_uiHintAddObjectAni);
			}
		}
		public function onUIHintDestroy(ui:Form):void
		{
			delete m_dicUIHint[ui.id];
		}
		
		override public function updateData(param:Object = null):void 
		{
			var type:int = param[HintMgr.HINTTYPE]as int;
			switch(type)
			{
				case HintMgr.HINTTYPE_AddObject: addObject(param); break;
				case HintMgr.HINTTYPE_AddWu: addWu(param); break;
				case HintMgr.HINTTYPE_AddSlave: addSlave(param); break;
				case HintMgr.HINTTYPE_FGFail: addFGFail(param); break;
				case HintMgr.HINTTYPE_ZhenfaAddGrid: zhenfaAddGrid(param); break;
				case HintMgr.HINTTYPE_JnLevelUp: jinnangLevelUp(param); break;
				case HintMgr.HINTTYPE_ActFeature: actFeatureToDo(param); break;
				case HintMgr.HINTTYPE_QAsys: goToQaNpc(); break;
			}
		}
		
		private function addObject(param:Object):void
		{
			var obj:ZObject = param["obj"];
			var heroID:uint = HintTool.getHeroIDWithInferiorEquip(m_gkcontext, obj);
			if (heroID != 0)
			{
				if (m_uiHintAddObjectAni == null)
				{
					createHintAddObjectAni();
				}
				m_uiHintAddObjectAni.addObject(obj);
				m_uiHintAddObjectAni.begin();
				m_uiHintAddObjectAni.show();
				//var srcType:int = param["srcType"] as int;
				//var ui:UIAddObjectHint = createNewUIHint(UIAddObjectHint) as UIAddObjectHint;
				//ui.addObject(obj, srcType);
			}
		}
		
		public function onUIHintAddObjectAniDispose():void
		{
			m_uiHintAddObjectAni = null;
		}
		
		private function addWu(param:Object):void
		{
			var wu:WuHeroProperty = param["wuhero"];
			var infotype:int = param[HintMgr.ADDHEROACTION] as int;
			
			//招募武将已有，刷新数量
			if(infotype == HintMgr.ADDHERO_REFRESHNUM)
			{
				var uirefresh:UIAddHeroHint = createNewUIHint(UIAddHeroHint) as UIAddHeroHint;
				uirefresh.setInfoType(infotype);
				uirefresh.addWuHero(wu);
				
				showRecruitHero(wu);
				return;
			}
			
			var collector:Vector.<WuHeroProperty> = new Vector.<WuHeroProperty>();
			var collectParam:Object = new Object();
			collectParam["hero"] = wu;
			collectParam["collector"] = collector;
			
			if(HintTool.judgeChangeMatrix(m_gkcontext,wu))
			{
				infotype = HintMgr.ADDHERO_CHANGMATRIX;
				var uicm:UIAddHeroHint = createNewUIHint(UIAddHeroHint) as UIAddHeroHint;
				uicm.setInfoType(infotype);
				uicm.addWuHero(wu);
			}
			else
			{
				//TODO 激活判断
				m_gkcontext.m_wuMgr.exeFunForEachHero(HintTool.collectActivedHerosByhero, collectParam);
				if(collector.length)
				{
					infotype = HintMgr.ADDHERO_HEROACTIVE;
					var uiactive:UIAddHeroHint = createNewUIHint(UIAddHeroHint) as UIAddHeroHint;
					uiactive.setInfoType(infotype);
					uiactive.addWuHero(wu);
				}
			}
			
			//TODO转生判断
			collector.length = 0;
			var wuTemp:WuHeroProperty;
			m_gkcontext.m_wuMgr.exeFunForEachHero(HintTool.collectRebirthHeros, collectParam);
			if(collector)
			{
				infotype = HintMgr.ADDHERO_REBIRTH;
				for(var i:int = 0; i < collector.length; i++)
				{
					wuTemp = collector[i];
					if (wuTemp.tableID == WuHeroProperty.WUID_MaTeng && false == m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_HEROFIRSTREBIRTH))					
					{
						//在马腾进行第一次转生之前，不显示马腾转生提示
						continue;
					}
					if (wuTemp.xiaye)
					{
						continue;
					}
					var uirebirth:UIAddHeroHint = createNewUIHint(UIAddHeroHint) as UIAddHeroHint;
					uirebirth.setInfoType(infotype);
					uirebirth.addWuHero(wuTemp);
				}
			}
			
			showRecruitHero(wu);
		}
		
		//每次招募武将均显示该提示
		private function showRecruitHero(wu:WuHeroProperty):void
		{
			var uirecruit:UIRecruitHero = createNewUIHint(UIRecruitHero) as UIRecruitHero;
			uirecruit.addWuHero(wu);
			DebugBox.addLog("武将（" + wu.fullName + "）加入，右下角显示提示界面已创建");
		}
		
		//加入一个奴隶
		private function addSlave(param:Object):void
		{
			var slave:String = param["slave"];
			
			var ui:UIAddSlaveHint = createNewUIHint(UIAddSlaveHint) as UIAddSlaveHint;
			ui.addSlave(slave);
		}
		
		// 战斗失败
		private function addFGFail(param:Object):void
		{
			/*
			if (m_gkcontext.playerMain.level <= 10)
			{
				return;
			}
			
			var ui:UIFGFail = createNewUIHint(UIFGFail) as UIFGFail;
			ui.addDesc();
			*/
		}
		
		//开启新阵位
		private function zhenfaAddGrid(param:Object):void
		{
			var ui:UIZhenfaAddGrid = createNewUIHint(UIZhenfaAddGrid) as UIZhenfaAddGrid;
			ui.addDesc();
		}
		
		//锦囊等级提升
		private function jinnangLevelUp(param:Object):void
		{
			var wuhero:WuHeroProperty = param["wuhero"];
			var ui:UIJinnangLevelUp = createNewUIHint(UIJinnangLevelUp) as UIJinnangLevelUp;
			ui.addDesc(wuhero);
		}
		
		//活动功能开始
		private function actFeatureToDo(param:Object):void
		{
			var type:int = param["featuretype"];
			
			//王城争霸、三国战场、世界BOSS功能未开启时，不显示提示框
			if ((HintMgr.ACTFUNC_CITYBATTLE == type && !m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CITYBATTLE))
				|| (HintMgr.ACTFUNC_SANGUOZHANCHANG == type && !m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_SANGUOZHANCHANG))
				|| (HintMgr.ACTFUNC_WORLDBOSS == type && !m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_WORLDBOSS))
				|| (HintMgr.ACTFUNC_CORPSTREASURE == type && !m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CORPSTREASURE)))
			{
				return;
			}
			
			var ui:UIActFeatureToDo = createNewUIHint(UIActFeatureToDo) as UIActFeatureToDo;
			ui.addDesc(type);
		}
		private function goToQaNpc():void
		{
			var ui:UIGotoQanpc = createNewUIHint(UIGotoQanpc) as UIGotoQanpc;
			ui.addDesc();
		}
	}

}