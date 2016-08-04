package game.ui.uipaoshangsys
{
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import game.ui.uipaoshangsys.bg.UIBg;
	import game.ui.uipaoshangsys.close.UIClose;
	import game.ui.uipaoshangsys.goods.UIGoods;
	import game.ui.uipaoshangsys.info.UIInfo;
	import game.ui.uipaoshangsys.mark.MarkData;
	import game.ui.uipaoshangsys.msg.retStartBusinessUserCmd;
	import modulecommon.uiinterface.IUIChat;
	import modulecommon.uiinterface.IUiSysBtn;
	//import game.ui.uipaoshangsys.msg.addOneRoberInfoUserCmd;
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import game.ui.uipaoshangsys.msg.GoodsInfo;
	//import game.ui.uipaoshangsys.msg.notifyBusinessDataUserCmd;
	import game.ui.uipaoshangsys.msg.retBeginBusinessUserCmd;
	import game.ui.uipaoshangsys.msg.stRetBusinessUiDataUserCmd;
	import game.ui.uipaoshangsys.start.UIStart;
	import game.ui.uipaoshangsys.title.UITitle;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.ui.UISubSys;
	import modulecommon.uiinterface.IUIPaoShangSys;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.commonfuntion.imloader.ModuleResLoadingItem;
	import game.ui.uipaoshangsys.xml.XmlParse;
	
	/**
	 * @brief
	 */
	public class UIPaoShangSys extends UISubSys implements IUIPaoShangSys
	{
		protected var m_DataPaoShang:DataPaoShang;
		
		public function UIPaoShangSys()
		{
			this.id = UIFormID.UIPaoShangSys;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			m_DataPaoShang = new DataPaoShang();
			m_DataPaoShang.m_gkcontext = m_gkcontext;
			m_DataPaoShang.m_form = this;
			m_DataPaoShang.m_onUIClose = onUIClose;
			
			m_DataPaoShang.m_markData = new MarkData(m_DataPaoShang);
			
			m_DataPaoShang.m_resLoader = new ModuleResLoader(m_gkcontext);
			var item:ModuleResLoadingItem = new ModuleResLoadingItem();
			item.m_path = CommonImageManager.toPathString("module/paoshang/uipaoshang.swf");
			item.m_classType = SWFResource;
			
			// 初始化配置文件
			var parse:XmlParse = new XmlParse(m_DataPaoShang.m_xmlData);
			parse.parse(m_gkcontext.m_dataXml.getXML(DataXml.XML_Paoshang));
			
			openUI(UIFormID.UIBg);
			//openUI(UIFormID.UIGoods);
			openUI(UIFormID.UIInfo);
			//openUI(UIFormID.UIStart);
			openUI(UIFormID.UITitle);
			openUI(UIFormID.UIClose);
			
			m_DataPaoShang.m_resLoader.addResName(item);
			m_DataPaoShang.m_resLoader.addEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			m_DataPaoShang.m_resLoader.loadRes();
			
			m_gkcontext.m_rankSys.bOpenPaoShang = true;	// 主要是战斗退出的时候，会将 UIChat 界面放到最下面
			
			// UIChat 提到第二层最上面
			var uichat:IUIChat = m_gkcontext.m_UIMgr.getForm(UIFormID.UIChat) as IUIChat;
			if(uichat)
			{
				uichat.moveToLayer(UIFormID.SecondLayer);
			}
			
			// UIChat 提到第二层最上面
			var uisysbtn:IUiSysBtn = m_gkcontext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
			if(uisysbtn)
			{
				uisysbtn.moveToLayer(UIFormID.SecondLayer);
			}
		}
		
		public function onResReady(event:Event):void
		{
			m_DataPaoShang.m_resLoader.removeEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			this.swfRes = m_DataPaoShang.m_resLoader.m_resLoadedDic["asset/uiimage/module/paoshang/uipaoshang.swf"];
			
			// 初始化资源
			var uititle:UITitle = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UITitle) as UITitle;
			if (uititle)
			{
				uititle.initRes();
			}
			var uistart:UIStart = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIStart) as UIStart;
			if(uistart)
			{
				uistart.initRes();
			}
			
			var uigoods:UIGoods = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIGoods) as UIGoods;
			if(uigoods)
			{
				uigoods.initRes();
			}
			var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
			if(uiinfo)
			{
				uiinfo.initRes();
			}
			
			var uibg:UIBg = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIBg) as UIBg;
			m_DataPaoShang.m_gkcontext.m_sceneUILogic.addHandle(uibg, uibg);
			
			/*
			// 测试代码
			// 放置一个玩家
			var stateinfo:BusinessUser = new BusinessUser();
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试1";
			stateinfo.id = 10000;
			stateinfo.bTime = 1.5;
			stateinfo.time = 60;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试2";
			stateinfo.id = 10001;
			stateinfo.bTime = 1.5;
			stateinfo.time = 70;
			stateinfo.vel = m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen/stateinfo.time;
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试3";
			stateinfo.id = 10002;
			stateinfo.bTime = 1.5;
			stateinfo.time = 80;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试3";
			stateinfo.id = 10003;
			stateinfo.bTime = 1.5;
			stateinfo.time = 90;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试4";
			stateinfo.id = 10004;
			stateinfo.bTime = 1.5;
			stateinfo.time = 100;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试5";
			stateinfo.id = 10005;
			stateinfo.bTime = 1.5;
			stateinfo.time = 110;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试6";
			stateinfo.id = 10006;
			stateinfo.bTime = 1.5;
			stateinfo.time = 120;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试7";
			stateinfo.id = 10007;
			stateinfo.bTime = 1.5;
			stateinfo.time = 130;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			stateinfo.sex = 1;
			stateinfo.job = 1;
			stateinfo.name = "测试8";
			stateinfo.id = 10008;
			stateinfo.bTime = 1.5;
			stateinfo.time = 140;
			stateinfo.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			m_DataPaoShang.m_markData.createHero(stateinfo);
			
			// 货物
			var goodsinfo:GoodsInfo;
			
			goodsinfo = new GoodsInfo();
			goodsinfo.m_goodsID = 10106;
			goodsinfo.m_bBest = true;
			goodsinfo.m_bgType = 1;
			m_DataPaoShang.m_basicInfo.m_goodsLst[0] = goodsinfo;
			
			goodsinfo = new GoodsInfo();
			goodsinfo.m_goodsID = 10106;
			goodsinfo.m_bBest = true;
			goodsinfo.m_bgType = 1;
			m_DataPaoShang.m_basicInfo.m_goodsLst[1] = goodsinfo;
			
			goodsinfo = new GoodsInfo();
			goodsinfo.m_goodsID = 10106;
			goodsinfo.m_bBest = true;
			goodsinfo.m_bgType = 1;
			m_DataPaoShang.m_basicInfo.m_goodsLst[2] = goodsinfo;
			
			goodsinfo = new GoodsInfo();
			goodsinfo.m_goodsID = 10107;
			goodsinfo.m_bBest = false;
			goodsinfo.m_bgType = 2;
			m_DataPaoShang.m_basicInfo.m_goodsLst[3] = goodsinfo;
			
			goodsinfo = new GoodsInfo();
			goodsinfo.m_goodsID = 10107;
			goodsinfo.m_bBest = false;
			goodsinfo.m_bgType = 2;
			m_DataPaoShang.m_basicInfo.m_goodsLst[4] = goodsinfo;
			
			m_DataPaoShang.insortSort(m_DataPaoShang.m_basicInfo.m_goodsLst);
			
			if (uigoods)
			{
				uigoods.updateGoodsRes();
				uigoods.updateExtraLbl();
			}
			*/
		}
		
		public function isResReady():Boolean
		{
			return m_DataPaoShang.m_resLoader.m_resLoaded;
		}
		
		override public function dispose():void
		{
			m_DataPaoShang.m_resLoader.removeEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			// UIChat 提到第二层最上面
			var uichat:IUIChat = m_gkcontext.m_UIMgr.getForm(UIFormID.UIChat) as IUIChat;
			if(uichat)
			{
				uichat.moveBackFirstLayer();
			}
			
			// UIChat 提到第二层最上面
			var uisysbtn:IUiSysBtn = m_gkcontext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
			if(uisysbtn)
			{
				uisysbtn.moveBackFirstLayer();
			}
			
			m_DataPaoShang.dispose();
			//m_DataPaoShang.m_gkcontext.m_sceneUILogic.removeHandle();
			m_gkcontext.m_rankSys.bOpenPaoShang = false;
			super.dispose();
		}
		
		public function openUI(formid:uint):void
		{
			// 如果已经打开了
			if(!addOpenFlag(formid))
			{
				return;
			}
			var form:Form;

			if(UIFormID.UIBg == formid)
			{
				form = new UIBg();
				(form as UIBg).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UIGoods == formid)
			{
				form = new UIGoods();
				(form as UIGoods).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UIInfo == formid)
			{
				form = new UIInfo();
				(form as UIInfo).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UIStart == formid)
			{
				form = new UIStart();
				(form as UIStart).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITitle == formid)
			{
				form = new UITitle();
				(form as UITitle).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UIClose == formid)
			{
				form = new UIClose();
				(form as UIClose).m_DataPaoShang = m_DataPaoShang;
				m_DataPaoShang.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
		}
		
		//public function psnotifyBusinessDataUserCmd(msg:ByteArray):void
		//{
		//	var cmd:notifyBusinessDataUserCmd = new notifyBusinessDataUserCmd();
		//	cmd.deserialize(msg);
		//	cmd.syncData();
			
		//	m_DataPaoShang.m_basicInfo = cmd;
			
		//	if (cmd.time)		// 当前在跑商中
		//	{
		//		// 等待后面跑商人员消息的时候添加自己的数据进去
		//	}
		//	else				// 当前没有在跑商中
		//	{
		//		if (cmd.times < 2)	// 如果还有跑商次数
		//		{
		//			openUI(UIFormID.UIStart);
		//			var uistart:UIStart = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIStart) as UIStart;
		//			if(uistart)
		//			{
		//				uistart.psnotifyBusinessDataUserCmd(cmd);
		//			}
					
		//			var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
		//			if(uiinfo)
		//			{
		//				uiinfo.psnotifyBusinessDataUserCmd(cmd);
		//			}
		//		}
		//	}
		//}
		
		// 收到这个消息，需要显示跑商的标示
		public function psstRetBusinessUiDataUserCmd(msg:ByteArray):void
		{
			var cmd:stRetBusinessUiDataUserCmd = new stRetBusinessUiDataUserCmd();
			cmd.deserialize(msg);
			
			//m_DataPaoShang.m_markInfo = cmd;
			m_DataPaoShang.m_basicInfo = cmd;
			
			// 如果被打劫，需要自己减去被打劫的值，服务器没有减去
			m_DataPaoShang.m_basicInfo.adjustValue();
			
			// 排序一下
			if (m_DataPaoShang.m_basicInfo.shop[0])
			{
				m_DataPaoShang.insortSortInt(m_DataPaoShang.m_basicInfo.shop);
			}
			// 同步一下数据
			m_DataPaoShang.m_basicInfo.syncData(m_DataPaoShang.m_xmlData.m_type2ObjIdDic);
			var bhasself:Boolean;
			// 创建所有跑商的
			var item:BusinessUser;
			for each(item in m_DataPaoShang.m_basicInfo.data)
			{
				if (item.name == m_gkcontext.m_playerManager.hero.name)
				{
					bhasself = true;
				}
				item.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
				m_DataPaoShang.m_markData.createHero(item);
			}
			
			if (cmd.bTime)		// 当前在跑商中
			{
				// 等待后面跑商人员消息的时候添加自己的数据进去
				if (!bhasself)
				{
					addSelfMark();
				}
				
				// 只有开始跑商才显示信息界面的内容
				var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
				if(uiinfo)
				{
					uiinfo.psnotifyBusinessDataUserCmd(cmd);
				}
			}
			else				// 当前没有在跑商中
			{
				if (cmd.times < 2)	// 如果还有跑商次数
				{
					openUI(UIFormID.UIStart);
					var uistart:UIStart = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIStart) as UIStart;
					if(uistart)
					{
						uistart.psstRetBusinessUiDataUserCmd(cmd);
					}
					
					//var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
					//if(uiinfo)
					//{
					//	uiinfo.psnotifyBusinessDataUserCmd(cmd);
					//}
				}
			}
			
			//var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
			//if(uiinfo)
			//{
			//	uiinfo.psnotifyBusinessDataUserCmd(cmd);
			//}
		
			// 创建所有跑商的
			//var item:BusinessUser;
			//for each(item in m_DataPaoShang.m_basicInfo.data)
			//{
			//	m_DataPaoShang.m_markData.createHero(item);
			//}
		}
		
		// 添加自己,brun 是否强迫自己开始运动
		public function addSelfMark(brun:Boolean = false):void
		{
			// 添加自己信息到最后
			var playerMain:PlayerMain = m_gkcontext.m_playerManager.hero;
			var self:BusinessUser = new BusinessUser();
			self.id = 0;		// 自己 id 是 0
			self.job = playerMain.job;
			self.sex = playerMain.gender;
			self.name = playerMain.name;
			self.bTime = m_DataPaoShang.m_basicInfo.bTime;
			self.brun = brun;	// 如果 bTime 是 0 是否强制运动
			self.time = m_DataPaoShang.m_basicInfo.time;
			self.sum = m_DataPaoShang.m_basicInfo.value;
			self.calcVel(m_DataPaoShang.m_xmlData.m_xmlPath.m_totalLen);
			self.robValue = 0;
			
			m_DataPaoShang.m_basicInfo.data[m_DataPaoShang.m_basicInfo.data.length] = self;
			m_DataPaoShang.m_markData.createHero(self);
			
			m_DataPaoShang.m_basicInfo.brun = brun;
			if (brun)
			{
				var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
				if(uiinfo)
				{
					uiinfo.updateLbl();
				}
			}
		}
		
		public function psretBeginBusinessUserCmd(msg:ByteArray):void
		{
			var cmd:retBeginBusinessUserCmd = new retBeginBusinessUserCmd();
			cmd.deserialize(msg);
			
			// 更新基本信息
			m_DataPaoShang.m_basicInfo.time = cmd.time;
			m_DataPaoShang.m_basicInfo.value = cmd.value;
			m_DataPaoShang.m_basicInfo.shop = cmd.shop;
			
			// 排序一下
			if (m_DataPaoShang.m_basicInfo.shop[0])
			{
				m_DataPaoShang.insortSortInt(m_DataPaoShang.m_basicInfo.shop);
			}
			
			m_DataPaoShang.m_basicInfo.syncData(m_DataPaoShang.m_xmlData.m_type2ObjIdDic);
			
			// 显示换货界面
			openUI(UIFormID.UIGoods);
			
			var uigoods:UIGoods = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIGoods) as UIGoods;
			if(uigoods)
			{
				// 隐藏之前的换货动画
				if (m_DataPaoShang.m_bChanging)
				{
					uigoods.stopAni();
				}
				uigoods.psnotifyBusinessDataUserCmd(m_DataPaoShang.m_basicInfo);
			}
			
			var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
			if(uiinfo)
			{
				uiinfo.psnotifyBusinessDataUserCmd(m_DataPaoShang.m_basicInfo);
			}
		}
		
		public function psretStartBusinessUserCmd(msg:ByteArray):void
		{
			// 开始发车
			var cmd:retStartBusinessUserCmd = new retStartBusinessUserCmd();
			if (cmd.ret == 0)
			{
				// 增加跑商次数
				++m_DataPaoShang.m_basicInfo.times;
				// 添加自己
				addSelfMark(true);
				// 发车后才能显示信息界面的内容
				var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
				if(uiinfo)
				{
					uiinfo.psnotifyBusinessDataUserCmd(m_DataPaoShang.m_basicInfo);
				}
			}
			else	// 不能发出
			{
				m_DataPaoShang.m_gkcontext.m_systemPrompt.prompt("条件不满足不能发车");
			}
		}
		
		//public function psaddOneRoberInfoUserCmd(msg:ByteArray):void
		//{
		//	var cmd:addOneRoberInfoUserCmd = new addOneRoberInfoUserCmd();
		//	cmd.deserialize(msg);
			
		//	if (m_DataPaoShang.m_basicInfo.rob[0].time)
		//	{
		//		m_DataPaoShang.m_basicInfo.rob[1] = cmd.rob;
		//	}
		//	else
		//	{
		//		m_DataPaoShang.m_basicInfo.rob[0] = cmd.rob;
		//	}
			
		//	var uiinfo:UIInfo = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfo) as UIInfo;
		//	if(uiinfo)
		//	{
		//		uiinfo.updateRob();
		//	}
		//}
	}
}