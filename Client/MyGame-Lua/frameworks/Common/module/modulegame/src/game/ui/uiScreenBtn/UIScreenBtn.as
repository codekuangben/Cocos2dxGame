package game.ui.uiScreenBtn 
{	
	import com.bit101.components.ButtonAni;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import game.ui.uiScreenBtn.subcom.CorpsTreasure;
	import game.ui.uiScreenBtn.subcom.DTRechargeRebate;
	import game.ui.uiScreenBtn.subcom.MysteryShop;
	import game.ui.uiScreenBtn.subcom.PaoShang;
	import game.ui.uiScreenBtn.subcom.RechargeRebate;
	import game.ui.uiScreenBtn.subcom.SGQunyinghui;
	import game.ui.uiScreenBtn.subcom.VipTiYan;
	import modulecommon.scene.worldboss.WorldBossMgr;
	import game.ui.uiScreenBtn.subcom.BenefitHall;
	import game.ui.uiScreenBtn.subcom.HuodongLibao;
	import game.ui.uiScreenBtn.subcom.Questionnaire;
	import game.ui.uiScreenBtn.subcom.SanGuoZhanChang;
	import game.ui.uiScreenBtn.subcom.Shoucangli;
	import game.ui.uiScreenBtn.subcom.TenpercentGiftbox;
	import game.ui.uiScreenBtn.subcom.TreasureHunting;
	import game.ui.uiScreenBtn.subcom.WorldBoss;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIVipTiYan;
	import time.TimeL;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.net.msg.sceneUserCmd.showActivityIconUserCmd;
	import modulecommon.scene.saodang.SaodangMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	//import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIScreenBtn;
	
	import game.ui.uiScreenBtn.subcom.Arena;
	import game.ui.uiScreenBtn.subcom.Cangbaoku;
	import game.ui.uiScreenBtn.subcom.CorpsCitySys;
	import game.ui.uiScreenBtn.subcom.DailyActivites;
	import game.ui.uiScreenBtn.subcom.EliteBarrier;
	import game.ui.uiScreenBtn.subcom.FirstRecharge;
	import game.ui.uiScreenBtn.subcom.FuBenSaoDang;
	import game.ui.uiScreenBtn.subcom.FunBtnBase;
	import game.ui.uiScreenBtn.subcom.GiftPack;
	import game.ui.uiScreenBtn.subcom.Guoguanzhanjiang;
	import game.ui.uiScreenBtn.subcom.IngotBefall;
	import game.ui.uiScreenBtn.subcom.Jiuguan;
	import game.ui.uiScreenBtn.subcom.TeamFB;
	import game.ui.uiScreenBtn.subcom.Xuanshangrenwu;

	/**
	 * ...
	 * @author 
	 */
	public class UIScreenBtn extends Form implements IUIScreenBtn
	{
		public static const SCREENBTN_ROW_MAX:uint = 8;	//一行最多显示数量
		public static const BTN_WIDTH:uint = 80;		//按钮宽度
		
		protected var m_config:Dictionary;
		protected var m_list:Vector.<FunBtnBase>;
		protected var m_newBtnPos:Point;
		protected var m_zoomBtn:PushButton;				//展开收起按钮
		protected var m_bZoomHideBtns:Boolean = false;	//活动按钮是否已经收起隐藏
		protected var m_bBtnMoving:Boolean = false;		//btn正在移动中...
		protected var m_dicHideBtns:Dictionary;
		protected var m_firstRechargePanel:FirstRechargePanel;	//首冲特效
		
		public function UIScreenBtn() 
		{
			m_list = new Vector.<FunBtnBase>();
			m_newBtnPos = new Point();
			m_dicHideBtns = new Dictionary();
			
			m_config = new Dictionary();
			m_config[ScreenBtnMgr.Btn_CANGBAOKU] = [Cangbaoku, "cangbaoku"];
			m_config[ScreenBtnMgr.Btn_EliteBarrier] = [EliteBarrier, "zhanyitiaozhan"];
			m_config[ScreenBtnMgr.Btn_Jiuguan] = [Jiuguan, "jiuguan"];
			m_config[ScreenBtnMgr.Btn_Arena] = [Arena, "wujuleitai"];
			m_config[ScreenBtnMgr.Btn_Guoguanzhanjiang] = [Guoguanzhanjiang, "guoguanzhanjiang"];
			m_config[ScreenBtnMgr.Btn_Xuanshangrenwu] = [Xuanshangrenwu, "xuanshangrenwu"];
			m_config[ScreenBtnMgr.Btn_SaoDang] = [FuBenSaoDang, "saodang"];
			m_config[ScreenBtnMgr.Btn_GiftPack] = [GiftPack, "djslibao"];		// 倒计时礼包 
			m_config[ScreenBtnMgr.Btn_IngotBefall] = [IngotBefall, "ingotbefall"];
			//m_config[ScreenBtnMgr.Btn_DailyActivities] = [DailyActivites, "dailyactivites"];
			m_config[ScreenBtnMgr.Btn_CorpsCitySys] = [CorpsCitySys, "corpscitysys"];	// 军团城市系统
			//m_config[ScreenBtnMgr.Btn_FirstRecharge] = [FirstRecharge, "shouchongdali"];//首充大礼
			m_config[ScreenBtnMgr.Btn_TeamFB] = [TeamFB, "teamfb"];						// 组队副本
			m_config[ScreenBtnMgr.Btn_Sanguozhanchang] = [SanGuoZhanChang, "sanguozhanchang"];	// 三国战场
			m_config[ScreenBtnMgr.Btn_Huodonglibao] = [HuodongLibao, "huodonglibao"];			//活动礼包
			m_config[ScreenBtnMgr.Btn_TenpercentGiftbox] = [TenpercentGiftbox, "yizhelibao"];	//一折大礼包
			m_config[ScreenBtnMgr.Btn_WorldBoss] = [WorldBoss, "shijieboss"];					//世界BOSS
			m_config[ScreenBtnMgr.Btn_TreasureHunting] = [TreasureHunting, "xunbao"];			//寻宝
			m_config[ScreenBtnMgr.Btn_BenefitHall] = [BenefitHall, "fulidating"];				//福利大厅
			m_config[ScreenBtnMgr.Btn_SGQunyinghui] = [SGQunyinghui, "yingxionghui"];			//三国群英会
			m_config[ScreenBtnMgr.Btn_Shoucangli] = [Shoucangli, "shoucangdali"];				//收藏大礼
			m_config[ScreenBtnMgr.Btn_Questionnaire] = [Questionnaire, "diaochawenjuan"];		//调查问卷
			m_config[ScreenBtnMgr.Btn_MysteryShop] = [MysteryShop, "mysteryshop"];		//神秘商店
			m_config[ScreenBtnMgr.Btn_PaoShang] = [PaoShang, "paoshang"];		//跑商
			m_config[ScreenBtnMgr.Btn_RechargeRebate] = [RechargeRebate, "chongzhifanli"];		//充值返利
			m_config[ScreenBtnMgr.Btn_DTRechargeRebate] = [DTRechargeRebate, "dtchongzhifanli"];		//定时充值返利
			m_config[ScreenBtnMgr.Btn_VipTiYan] = [VipTiYan, "viptiyan"];		//VIP体验
			m_config[ScreenBtnMgr.Btn_CorpsTreasure] = [CorpsTreasure, "corpstreasure"];		//军团夺宝
		}
		
		override public function onReady():void 
		{
			super.onReady();
			this.m_gkcontext.m_UIs.screenBtn = this;
			this.alignHorizontal = Component.CENTER;
			this.alignVertial = Component.TOP;
			//this.marginRight = 300;
			this.adjustPosWithAlign();		
			
			updateFeatures();
			
			if(m_gkcontext.m_saodangMgr.state != SaodangMgr._FREE)
			{
				addBtnByID(ScreenBtnMgr.Btn_SaoDang);
			}
			
			// 礼包上线显示
			if(m_gkcontext.m_giftPackMgr.showBtn)
			{
				if(!m_gkcontext.m_giftPackMgr.binit)
				{
					addBtnByID(ScreenBtnMgr.Btn_GiftPack);
					m_gkcontext.m_giftPackMgr.binit = true;
					updateGiftTime(m_gkcontext.m_giftPackMgr.lastTime);
				}
			}
			
			//今日未签到，显示特效
			//if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_MEIRIBIZUO))
			//{
			//	if (!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_REG))
			//	{
			//		updateBtnEffectAni(ScreenBtnMgr.Btn_DailyActivities, true);
			//	}
			//}
			
			//活动礼包
			if (1 == m_gkcontext.m_giftPackMgr.hdlbState)//1-开始(显示) 0-结束(消失
			{
				addBtnByID(ScreenBtnMgr.Btn_Huodonglibao);
				updateBtnEffectAni(ScreenBtnMgr.Btn_Huodonglibao, true);
			}
			
			//军团夺宝
			updateBtnOfCorpsTreasure();
			
			//调查问卷
			//addBtnByID(ScreenBtnMgr.Btn_Questionnaire);
			//addBtnByID(ScreenBtnMgr.Btn_DTRechargeRebate);
			//addBtnByID(ScreenBtnMgr.Btn_VipTiYan);
			
			// 军团城市争夺战(王城争霸)、三国战场、军团夺宝
			showBtnEffectAniOfAct();
		}
		
		//军团夺宝（仅周一、周三、周五显示）
		public function updateBtnOfCorpsTreasure():void
		{
			var day:int = m_gkcontext.m_context.m_timeMgr.todayTimeL.m_week;
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CORPSTREASURE) && (1 == day || 3 == day || 5 == day))
			{
				addBtnByID(ScreenBtnMgr.Btn_CorpsTreasure);
			}
			else
			{
				toggleBtnVisible(ScreenBtnMgr.Btn_CorpsTreasure, false);
			}
		}
		
		//功能活动开始时，按钮上显示特效
		private function showBtnEffectAniOfAct():void
		{
			var list:Array = m_gkcontext.m_screenbtnMgr.m_showActIconList;
			var item:showActivityIconUserCmd;
			var bShowAni:Boolean;
			
			for each(item in list)
			{
				if (ScreenBtnMgr.ICON_CORPSFIGHT == item.type)
				{//王成争霸
					if (item.show)
					{
						m_gkcontext.m_corpsCitySys.inActive = true;
						bShowAni = true;
					}
					else
					{
						m_gkcontext.m_corpsCitySys.inActive = false;
						bShowAni = false;
					}
					
					updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsCitySys, bShowAni);
				}
				else if (ScreenBtnMgr.ICON_ROB_RESOURCE_COPY == item.type)
				{//三国战场
					if (item.show)
					{
						bShowAni = true;
					}
					else
					{
						bShowAni = false;
					}
					
					updateBtnEffectAni(ScreenBtnMgr.Btn_Sanguozhanchang, bShowAni);
				}
				else if (ScreenBtnMgr.ICON_RECHARGE_BACK == item.type)
				{
					if (item.show)
					{
						addBtnByID(ScreenBtnMgr.Btn_RechargeRebate);
					}
					else
					{
						removeBtn(ScreenBtnMgr.Btn_RechargeRebate)
					}
				}
				else if (ScreenBtnMgr.ICON_DT_RECHARGE_BACK == item.type)
				{
					if (item.show)
					{
						addBtnByID(ScreenBtnMgr.Btn_DTRechargeRebate);
					}
					else
					{
						removeBtn(ScreenBtnMgr.Btn_DTRechargeRebate)
					}
				}
				else if (ScreenBtnMgr.ICON_VIP_PRACTICE == item.type)
				{
					m_gkcontext.m_vipTY.binit = true;
					if (item.show) // 活动开始
					{
						addBtnByID(ScreenBtnMgr.Btn_VipTiYan);
					}
					else // 活动结束
					{
						//removeBtn(ScreenBtnMgr.Btn_VipTiYan);
						m_gkcontext.m_vipTY.clearDJS();
						m_gkcontext.m_vipTY.clearActiveIcon();
						//m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_VipTiYan, false);
						var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
						if (vipty)
						{
							vipty.exit();
						}
					}
				}
				else if (ScreenBtnMgr.ICON_CORPSTREASURE == item.type)
				{//军团夺宝
					if (item.show)
					{
						bShowAni = true;
					}
					else
					{
						bShowAni = false;
					}
					
					updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsTreasure, bShowAni);
				}
			}
			
			//保存数据清除
			m_gkcontext.m_screenbtnMgr.m_showActIconList.length = 0;
		}
		
		public function updateFeatures():void
		{
			addFeaturesBtn(SysNewFeatures.NFT_CANBAOKU);
			addFeaturesBtn(SysNewFeatures.NFT_ZHANYITIAOZHAN);
			addFeaturesBtn(SysNewFeatures.NFT_JIUGUAN);
			addFeaturesBtn(SysNewFeatures.NFT_JINGJICHANG);
			addFeaturesBtn(SysNewFeatures.NFT_TRIALTOWER);
			addFeaturesBtn(SysNewFeatures.NFT_XUANSHANG);
			addFeaturesBtn(SysNewFeatures.NFT_CAISHENDAO);
			addFeaturesBtn(SysNewFeatures.NFT_TEAMCOPY);
			addFeaturesBtn(SysNewFeatures.NFT_MEIRIBIZUO);
			addFeaturesBtn(SysNewFeatures.NFT_SANGUOZHANCHANG);
			addFeaturesBtn(SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX);
			addFeaturesBtn(SysNewFeatures.NFT_TENPERCENTGIFTBOX);
			addFeaturesBtn(SysNewFeatures.NFT_WORLDBOSS);
			addFeaturesBtn(SysNewFeatures.NFT_CITYBATTLE);
			addFeaturesBtn(SysNewFeatures.NFT_TREASUREHUNTING);
			addFeaturesBtn(SysNewFeatures.NFT_WELFAREHALL);
			addFeaturesBtn(SysNewFeatures.NFT_COLLECTGIFT);
			addFeaturesBtn(SysNewFeatures.NFT_SGQUNYINGHUI);
			addFeaturesBtn(SysNewFeatures.NFT_SECRETSTORE);
			addFeaturesBtn(SysNewFeatures.NFT_PAOSHANG);
			addFeaturesBtn(SysNewFeatures.NFT_VIPPRACTICE);
			
			updateShowZoomBtn();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			this.m_gkcontext.m_UIs.screenBtn = null;
		}
		
		public function getFunBtn(id:int):FunBtnBase
		{
			var i:int;
			var btn:FunBtnBase;
			
			for (i = 0; i < m_list.length; i++)
			{
				btn = m_list[i];
				if (btn && (btn.id == id))
				{
					return btn;
				}
			}
			
			return null;	
		}
		
		protected function sortWithID(btn1:FunBtnBase, btn2:FunBtnBase):int
		{
			if (btn1.id < btn2.id)
			{
				return -1;
			}
			else if(btn1.id > btn2.id)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		protected function createBtn(id:int):FunBtnBase
		{
			var config:Array = m_config[id];
			var cs:Class;
			
			var ret:FunBtnBase;
			ret = new (config[0])(this);
			ret.setGkUI(m_gkcontext, this);
			ret.initData(config[1]);
			ret.onInit();
			m_list.push(ret);
			//m_list.sort(sortWithID);
			addjustPos();
			return ret;
		}
		
		public function removeBtn(id:int):void
		{
			var base:FunBtnBase;
			for each(base in m_list)
			{
				if (base.id == id)
				{
					var i:int = m_list.indexOf(base);
					m_list.splice(i, 1);
					if (base.parent)
					{
						base.parent.removeChild(base);
						base.dispose();
					}
					addjustPos();
					return;
				}
			}
		}
		protected function addjustPos():void
		{
			var i:int = 0;
			var count:int = 0;
			var start:int = 0;
			var left:int = -BTN_WIDTH;
			var right:int = 0;
			var btn:FunBtnBase;
			
			for (i = 0; i < m_list.length; i++)
			{
				btn = m_list[i];
				if(btn && btn.bShowBtn && (false == inDicHideBtns(btn.id)))
				{
					if (count >= SCREENBTN_ROW_MAX)
					{
						btn.x = -(BTN_WIDTH * Math.floor(SCREENBTN_ROW_MAX/2)) + BTN_WIDTH * (count % SCREENBTN_ROW_MAX);
					}
					else
					{
						if ((count + 1) % 2)
						{
							btn.x = right;
							right += BTN_WIDTH;
						}
						else
						{
							btn.x = left;
							left -= BTN_WIDTH;
						}
					}
					btn.y = Math.floor(count / SCREENBTN_ROW_MAX) * BTN_WIDTH;
					count++;
				}
			}
		}
		
		public function toggleBtnVisible(btnid:uint, bvis:Boolean):void
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if (null != btn)
			{
				btn.bShowBtn = bvis;
				btn.visible = bvis;
				btn.hideEffectAni();
				addjustPos();
			}
		}
		
		//活动按钮是否可见
		public function isVisibleBtn(btnid:uint):Boolean
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if (btn && btn.bShowBtn)
			{
				return true;
			}
			
			return false;
		}
		
		public function addNewFeature(type:uint, btn:ButtonAni = null):void
		{
			addFeaturesBtn(type);
			showCreateBtnAni(ScreenBtnMgr.getBtnId(type));
			
			updateShowZoomBtn();
		}
		
		// 通过 id 添加按钮
		public function addBtnByID(btnid:uint):void
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if(null == btn)
			{
				btn = createBtn(btnid);
			}
			else
			{
				toggleBtnVisible(btnid, true);
			}
			
			updateShowZoomBtn();
		}

		private function addFeaturesBtn(type:uint):void
		{
			if (false == m_gkcontext.m_sysnewfeatures.isSet(type))
			{
				return;
			}
			
			var leftCounts:uint = 0;
			var btnid:int = -1;
			
			switch(type)
			{
			case SysNewFeatures.NFT_CANBAOKU:
				if(!getFunBtn(ScreenBtnMgr.Btn_CANGBAOKU))
				{
					createBtn(ScreenBtnMgr.Btn_CANGBAOKU);
				}
				break;
			case SysNewFeatures.NFT_ZHANYITIAOZHAN:
				if (!getFunBtn(ScreenBtnMgr.Btn_EliteBarrier))
				{
					createBtn(ScreenBtnMgr.Btn_EliteBarrier);
				}
				break;
			case SysNewFeatures.NFT_JIUGUAN:
				if (!getFunBtn(ScreenBtnMgr.Btn_Jiuguan))
				{
					createBtn(ScreenBtnMgr.Btn_Jiuguan);
				}
				break;
			case SysNewFeatures.NFT_JINGJICHANG:
				if (!getFunBtn(ScreenBtnMgr.Btn_Arena))
				{
					createBtn(ScreenBtnMgr.Btn_Arena);
				}
				break;
			case SysNewFeatures.NFT_TRIALTOWER:
				if (!getFunBtn(ScreenBtnMgr.Btn_Guoguanzhanjiang))
				{
					createBtn(ScreenBtnMgr.Btn_Guoguanzhanjiang);
				}
				break;
			case SysNewFeatures.NFT_XUANSHANG:
				if (!getFunBtn(ScreenBtnMgr.Btn_Xuanshangrenwu))
				{
					createBtn(ScreenBtnMgr.Btn_Xuanshangrenwu);
				}
				break;
			case SysNewFeatures.NFT_CAISHENDAO:
				if (!getFunBtn(ScreenBtnMgr.Btn_IngotBefall))
				{
					createBtn(ScreenBtnMgr.Btn_IngotBefall);
				}
				break;
			case SysNewFeatures.NFT_TEAMCOPY:
				if (!getFunBtn(ScreenBtnMgr.Btn_TeamFB))
				{
					createBtn(ScreenBtnMgr.Btn_TeamFB);
				}
				break;
			case SysNewFeatures.NFT_MEIRIBIZUO:
				//if (!getFunBtn(ScreenBtnMgr.Btn_DailyActivities))
				//{
				//	createBtn(ScreenBtnMgr.Btn_DailyActivities);
				//}
				break;
			case SysNewFeatures.NFT_SANGUOZHANCHANG:
				if (!getFunBtn(ScreenBtnMgr.Btn_Sanguozhanchang))
				{
					createBtn(ScreenBtnMgr.Btn_Sanguozhanchang);
				}
				break;
			case SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX:
				//if (!getFunBtn(ScreenBtnMgr.Btn_FirstRecharge))
				//{
				//	if (false == m_gkcontext.m_giftPackMgr.isGetFRGift)
				//	{
				//		createBtn(ScreenBtnMgr.Btn_FirstRecharge);
				//		updateBtnEffectAni(ScreenBtnMgr.Btn_FirstRecharge, true);
				//	}
				//}
				firstRechargeVisible(!m_gkcontext.m_giftPackMgr.isGetFRGift);
				break;
			case SysNewFeatures.NFT_TENPERCENTGIFTBOX:
				if (!getFunBtn(ScreenBtnMgr.Btn_TenpercentGiftbox))
				{
					createBtn(ScreenBtnMgr.Btn_TenpercentGiftbox);
					if (m_gkcontext.m_yizhelibaoMgr.whetherShowEffect())
					{
						updateBtnEffectAni(ScreenBtnMgr.Btn_TenpercentGiftbox, true);
					}
				}
				break;
			case SysNewFeatures.NFT_WORLDBOSS:
				if (!getFunBtn(ScreenBtnMgr.Btn_WorldBoss))
				{
					createBtn(ScreenBtnMgr.Btn_WorldBoss);
					
					var state:int = m_gkcontext.m_worldBossMgr.m_curState;
					var bAni:Boolean = false;
					if (WorldBossMgr.ACTSTATE_PRE == state || WorldBossMgr.ACTSTATE_START == state || WorldBossMgr.ACTSTATE_TIMER == state)
					{
						bAni = true;
					}
					
					updateBtnEffectAni(ScreenBtnMgr.Btn_WorldBoss, bAni);
				}
				break;
			case SysNewFeatures.NFT_CITYBATTLE:
				if (!getFunBtn(ScreenBtnMgr.Btn_CorpsCitySys))
				{
					createBtn(ScreenBtnMgr.Btn_CorpsCitySys);
				}
				break;
			case SysNewFeatures.NFT_TREASUREHUNTING:
				if (!getFunBtn(ScreenBtnMgr.Btn_TreasureHunting))
				{
					createBtn(ScreenBtnMgr.Btn_TreasureHunting);
				}
				break;
			case SysNewFeatures.NFT_WELFAREHALL:
				if (!getFunBtn(ScreenBtnMgr.Btn_BenefitHall))
				{
					createBtn(ScreenBtnMgr.Btn_BenefitHall);
				}
				break;
			case SysNewFeatures.NFT_COLLECTGIFT:
				if (!getFunBtn(ScreenBtnMgr.Btn_Shoucangli))
				{
					if (false == m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_SHOUCANG))
					{
						createBtn(ScreenBtnMgr.Btn_Shoucangli);
					}
				}
				break;
			case SysNewFeatures.NFT_SGQUNYINGHUI:
				if (!getFunBtn(ScreenBtnMgr.Btn_SGQunyinghui))
				{
					createBtn(ScreenBtnMgr.Btn_SGQunyinghui);
				}
				break;
			case SysNewFeatures.NFT_SECRETSTORE:
				if (!getFunBtn(ScreenBtnMgr.Btn_MysteryShop))
				{
					createBtn(ScreenBtnMgr.Btn_MysteryShop);
				}
				break;
			case SysNewFeatures.NFT_PAOSHANG:
				if (!getFunBtn(ScreenBtnMgr.Btn_PaoShang))
				{
					createBtn(ScreenBtnMgr.Btn_PaoShang);
				}
				break;
			case SysNewFeatures.NFT_VIPPRACTICE:
				if (!getFunBtn(ScreenBtnMgr.Btn_VipTiYan))
				{
					createBtn(ScreenBtnMgr.Btn_VipTiYan);
				}
				break;
			case SysNewFeatures.NFT_CORPSTREASURE:
				if (!getFunBtn(ScreenBtnMgr.Btn_CorpsTreasure))
				{
					createBtn(ScreenBtnMgr.Btn_CorpsTreasure);
				}
				break;
			}
		}
		
		//增加一个新功能按钮时，设置其显示位置
		public function setNewButtonPos(id:int):void
		{
			var i:int = 0;
			var count:int = 0;
			var indexLast:int = 0; //最后一个显示按钮下标
			var btn:FunBtnBase;
			for (i = 0; i < m_list.length; i++)
			{
				btn = m_list[i];
				if(btn && btn.bShowBtn && (false == inDicHideBtns(btn.id)))
				{
					count++;
					indexLast = i;
				}
			}
			
			if (0 == count)
			{
				m_newBtnPos.x = 0;
				m_newBtnPos.y = 0;
			}
			else if (count >= SCREENBTN_ROW_MAX)
			{
				m_newBtnPos.x = -(BTN_WIDTH * Math.floor(SCREENBTN_ROW_MAX/2)) + (Math.floor(count % SCREENBTN_ROW_MAX) * BTN_WIDTH);
				m_newBtnPos.y = Math.floor(count / 8) * BTN_WIDTH;
			}
			else
			{
				m_newBtnPos.x = - m_list[indexLast].x;
				m_newBtnPos.y = 0;
				if (count % 2)
				{
					m_newBtnPos.x -= BTN_WIDTH;
				}
			}
		}
		
		//获得新加功能按钮的显示位置
		public function getButtonPosInScreen(id:int):Point
		{
			var pt:Point;
			
			if (m_list.length > 0)
			{
				
				var funBtn:FunBtnBase = getFunBtn(id);
				if (funBtn)
				{
					return funBtn.localToScreen();
				}
				else
				{
					return this.localToScreen().add(m_newBtnPos);
				}
				
			}
			else
			{
				pt = this.localToScreen();
			}
			return pt;
		}
		
		public function getBtnPosInScreen(id:int):Point
		{
			if (ScreenBtnMgr.Btn_FirstRecharge == id)
			{
				if (m_firstRechargePanel)
				{
					return m_firstRechargePanel.getPosInScreen();
				}
				else
				{
					return null;
				}
			}
			
			var funBtn:FunBtnBase = getFunBtn(id);
			if (funBtn)
			{
				return funBtn.getCeneterPosInScreen();
			}
			return null;
		}
		public function getButtonPosInScreenEx(id:int):Point
		{			
			var funBtn:FunBtnBase = getFunBtn(id);
			if (funBtn)
			{				
				return funBtn.localToScreen();
			}
			return null;
		}
		
		public function vacateRoomForButton(type:uint):void
		{
			
		}
		
		public function getButton(id:int):ButtonAni
		{
			for (var i:int = 0; i < m_list.length; i++)
			{
				if (getFunBtn(id) && m_list[i].bShowBtn && (m_list[i].id == id))
				{
					return m_list[i].btn;
				}
			}
			return null;
		}
		
		public function updateSaoDangTime(time:uint):void
		{
			var btn:FuBenSaoDang = getFunBtn(ScreenBtnMgr.Btn_SaoDang) as FuBenSaoDang;
			if(null != btn)
			{
				btn.updateTimeLabel(time);
				
				var bShowAni:Boolean;
				if (0 == time)
				{
					bShowAni = true;
				}
				else
				{
					bShowAni = false;
				}
				
				updateBtnEffectAni(btn.id, bShowAni);
			}
		}
		
		public function saoDangBtnState():uint
		{
			for (var i:int = 0; i < m_list.length; i++)
			{
				if ((ScreenBtnMgr.Btn_SaoDang == m_list[i].id))
				{
					if (m_list[i].bShowBtn)
					{
						return 2;
					}
					else
					{
						return 1;
					}
				}
			}
			return 0;
		}
		
		public function updateGiftTime(time:uint):void
		{
			var btn:GiftPack = getFunBtn(ScreenBtnMgr.Btn_GiftPack) as GiftPack;
			if(null != btn)
			{
				btn.updateTimeLabel(time);
				
				var bShowAni:Boolean;
				if (0 == time)
				{
					bShowAni = true;
				}
				else
				{
					bShowAni = false;
				}
				
				updateBtnEffectAni(btn.id, bShowAni);
			}
		}
		
		public function updateVipTY(time:uint):void
		{
			var btn:VipTiYan = getFunBtn(ScreenBtnMgr.Btn_VipTiYan) as VipTiYan;
			if(null != btn)
			{
				btn.updateTimeLabel(time);
				
				var bShowAni:Boolean;
				if (0 == time)
				{
					bShowAni = true;
				}
				else
				{
					bShowAni = false;
				}
				
				updateBtnEffectAni(btn.id, bShowAni);
			}
		}
		
		//按钮特效显示(鼠标点击后特效消失),成功更新返回 true
		public function updateBtnEffectAni(btnid:int, bool:Boolean = false,path:String=null):Boolean
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if (btn)
			{
				if (bool)
				{
					btn.showEffectAni(path);
					showOneBtnOfHide(btn);
				}
				else
				{
					btn.hideEffectAni();
				}
				
				return true;
			}
			
			return false;
		}
		
		public function showCreateBtnAni(btnid:int):void
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if (btn)
			{
				btn.setCreateBtnAni();
			}
		}
		
		public function updateLblCnt(cnt:uint, btnid:uint, type:int = ScreenBtnMgr.LBLCNTBGTYPE_Red):void
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if(btn)
			{
				btn.setLblCnt(cnt, type);
			}
		}
		
		// 修改按钮图标
		public function changeBtnIcon(btnid:uint, iconname:String):Boolean
		{
			var btn:FunBtnBase = getFunBtn(btnid);
			if (btn)
			{
				btn.initData(iconname);
				return true;
			}
			
			return false;
		}
		
		/***Begin 活动按钮缩放显示***************************************/
		public function get zoomBtn():PushButton
		{
			return m_zoomBtn;
		}
		
		//正显示的按钮数量
		private function get visibleBtnNum():uint
		{
			var ret:uint = 0;
			var i:int;
			var btn:FunBtnBase;
			
			for (i = 0; i < m_list.length; i++)
			{
				btn = m_list[i];
				if (btn && btn.bShowBtn)
				{
					ret += 1;
				}
			}
			
			return ret;
		}
		
		//更新
		public function updateShowZoomBtn():void
		{
			if (m_list.length > SCREENBTN_ROW_MAX)
			{
				if (null == m_zoomBtn)
				{
					m_zoomBtn = new PushButton(this, 322, 6, onZoomBtnClick);
					m_zoomBtn.setSize(75, 77);
					m_zoomBtn.recycleSkins = true;
					m_zoomBtn.setSkinButton1Image("commoncontrol/panel/zoom_hide.png");
				}
				
				m_zoomBtn.visible = true;
			}
			else
			{
				if (m_zoomBtn)
				{
					m_zoomBtn.visible = false;
				}
			}
			
			updatePosFirstRecharge();
		}
		
		private function onZoomBtnClick(event:MouseEvent):void
		{
			//btn移动中点击无效
			if (true == m_bBtnMoving)
			{
				return;
			}
			
			if (m_bZoomHideBtns)
			{
				m_zoomBtn.setSkinButton1Image("commoncontrol/panel/zoom_hide.png");
				m_zoomBtn.stopLiuguang();
				m_bZoomHideBtns = false;
				
				beginBtnShowMove();
			}
			else
			{
				m_zoomBtn.setSkinButton1Image("commoncontrol/panel/zoom_show.png");
				m_bZoomHideBtns = true;
				
				beginBtnHideMove();
			}
			
			//首充大礼
			onShowAddHideFirstRecharge(!m_bZoomHideBtns);
		}
		
		private function beginBtnHideMove():void
		{
			m_bBtnMoving = true;
			updateZoomBtnState(false);
			updateListHideBtns();
			
			var lastBtn:FunBtnBase;
			var btn:FunBtnBase;
			for each(btn in m_list)
			{
				if (btn && btn.bShowBtn && btn.bNeedHide && !btn.bActing)
				{
					btn.btnHideMove();
					lastBtn = btn;
					m_dicHideBtns[btn.id] = btn;
				}
			}
			
			if (lastBtn)
			{
				lastBtn.funBtnHideMoveEndCallback = btnHideMoveEnd;
			}
			
			addjustPos();
		}
		
		private function btnHideMoveEnd():void
		{
			m_bBtnMoving = false;
			updateZoomBtnState(true);
			if (m_zoomBtn)
			{
				m_zoomBtn.beginLiuguang();
			}
		}
		
		private function beginBtnShowMove():void
		{
			m_bBtnMoving = true;
			updateZoomBtnState(false);
			updateBtnPos();
			
			var lastBtn:FunBtnBase;
			var btn:FunBtnBase;
			for each(btn in m_dicHideBtns)
			{
				if (btn)
				{
					btn.btnShowMove();
					lastBtn = btn;
					delete m_dicHideBtns[btn.id];
				}
			}
			
			if (lastBtn)
			{
				lastBtn.funBtnShowMoveEndCallback = btnShowMoveEnd;
			}
		}
		
		private function btnShowMoveEnd():void
		{
			m_bBtnMoving = false;
			updateZoomBtnState(true);
		}
		
		private function showOneBtnOfHide(btn:FunBtnBase):void
		{
			if (btn && btn.bActing && inDicHideBtns(btn.id))
			{
				delete m_dicHideBtns[btn.id];
				
				addjustPos();
				btn.m_showPt.x = btn.x;
				btn.m_showPt.y = btn.y;
				
				btn.btnShowMove();
			}
		}
		
		private function updateZoomBtnState(bclick:Boolean):void
		{
			if (bclick)
			{
				m_zoomBtn.mouseEnabled = true;
				m_zoomBtn.becomeUnGray();
			}
			else
			{
				m_zoomBtn.mouseEnabled = false;
				m_zoomBtn.becomeGray();
			}
		}
		
		private function updateBtnPos():void
		{
			var i:int = 0;
			var count:int = 0;
			var start:int = 0;
			var left:int = -BTN_WIDTH;
			var right:int = 0;
			var btn:FunBtnBase;
			
			for (i = 0; i < m_list.length; i++)
			{
				btn = m_list[i];
				if(btn && btn.bShowBtn)
				{
					if (count >= SCREENBTN_ROW_MAX)
					{
						btn.m_showPt.x = -(BTN_WIDTH * Math.floor(SCREENBTN_ROW_MAX/2)) + BTN_WIDTH * (count % SCREENBTN_ROW_MAX);
					}
					else
					{
						if ((count + 1) % 2)
						{
							btn.m_showPt.x = right;
							right += BTN_WIDTH;
						}
						else
						{
							btn.m_showPt.x = left;
							left -= BTN_WIDTH;
						}
					}
					btn.m_showPt.y = Math.floor(count / SCREENBTN_ROW_MAX) * BTN_WIDTH;
					
					if (false == inDicHideBtns(btn.id))
					{
						btn.setPos(btn.m_showPt.x, btn.m_showPt.y);
					}
					
					count++;
				}
			}
		}
		
		private function updateListHideBtns():void
		{
			var btn:FunBtnBase;
			
			for each(btn in m_list)
			{
				if (btn && btn.bShowBtn && btn.bNeedHide && !btn.bActing)
				{
					m_dicHideBtns[btn.id] = btn;
				}
			}
		}
		
		private function inDicHideBtns(id:int):Boolean
		{
			if (undefined == m_dicHideBtns[id])
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		/***End 活动按钮缩放显示***************************************/
		
		//首充大礼特效显示或隐藏 bvis: true-添加 false-删除
		public function firstRechargeVisible(bvis:Boolean):void
		{
			if (bvis)
			{
				if (null == m_firstRechargePanel)
				{
					m_firstRechargePanel = new FirstRechargePanel(m_gkcontext, this, this, 375, 60);
				}
			}
			else
			{
				if (m_firstRechargePanel)
				{
					if (m_firstRechargePanel.parent)
					{
						m_firstRechargePanel.parent.removeChild(m_firstRechargePanel);
					}
					m_firstRechargePanel.dispose();
					m_firstRechargePanel = null;
				}
			}
		}
		
		//首充大礼特效显示、隐藏
		private function onShowAddHideFirstRecharge(bshow:Boolean):void
		{
			if (m_firstRechargePanel)
			{
				if (bshow)
				{
					m_firstRechargePanel.onAniShow();
				}
				else
				{
					m_firstRechargePanel.onAniHide();
				}
			}
		}
		
		//更新首充大礼特效显示位置
		private function updatePosFirstRecharge():void
		{
			if (m_firstRechargePanel)
			{
				if (zoomBtn && zoomBtn.visible)
				{
					m_firstRechargePanel.setPos(zoomBtn.x + 53, zoomBtn.y + 129);
				}
				else
				{
					m_firstRechargePanel.setPos(375, 60);
				}
			}
		}
		
	}
}