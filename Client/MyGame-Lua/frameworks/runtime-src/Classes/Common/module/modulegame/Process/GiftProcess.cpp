package game.process
{
	//import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.netmsg.giftCmd.stRetQuickCoolOnlineGiftCmd;
	import game.netmsg.giftCmd.stRetSecretStoreObjListCmd;
	import game.ui.uimysteryshop.msg.stReqSecretStoreObjListCmd;
	import modulecommon.net.msg.giftCmd.stBuySecretStoreObjCmd;
	import modulecommon.uiinterface.IUILQWJ;
	import modulecommon.uiinterface.IUIMysteryShop;
	
	import modulecommon.net.msg.giftCmd.retOnlineGiftContentUserCmd;
	//import modulecommon.uiinterface.IUIDaoJiShiWuJiang;
	//import game.netmsg.giftCmd.stNotifyOnlineGiftUserCmd;
	import modulecommon.GkContext;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	import modulecommon.uiinterface.IUIGiftPack;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIScreenBtn;
	
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.uiinterface.IUIAniGetGiftObj;
	//import modulecommon.ui.Form;
	
	/**
	 * ...
	 * @author 
	 * @brief 礼包处理
	 */
	public class GiftProcess 
	{
		private var m_gkcontext:GkContext;
		private var m_dicFun:Dictionary;
		
		public function GiftProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			m_dicFun = new Dictionary();
			m_dicFun[stGiftCmd.NOTIFY_ONLINE_GIFT_USERCMD] = processNotifyOnlineGift;
			m_dicFun[stGiftCmd.RET_ONLINE_GIFT_CONTENT_USERCMD] = processOnlineGiftContent;
			m_dicFun[stGiftCmd.NOTIFY_ONLINE_GIFT_END_USERCMD] = processnotifyOnlineGiftEnd;
			m_dicFun[stGiftCmd.RET_LEVEL_GIFT_CONTENT_USERCMD] = processLevelGiftContent;
			m_dicFun[stGiftCmd.RET_GET_GIFT_SUCCESS_USERCMD] = processGetGiftSuccess;
			m_dicFun[stGiftCmd.SYN_SEND_GIFT_OBJS_END_USERCMD] = processsynSendGiftObjsEnd;
			m_dicFun[stGiftCmd.RET_RANDOM_GIFT_CONTENT_USERCMD] = processRetRandomGiftContent;
			m_dicFun[stGiftCmd.PARA_FIRSTCHARGE_GIFTBOX_INFO_CMD] = processFirstChargeGiftboxInfoCmd;
			m_dicFun[stGiftCmd.PARA_FIRSTCHARGE_BOX_STATE_CMD] = processFirstChargeBoxStateCmd;
			m_dicFun[stGiftCmd.PARA_NOTIFY_ACTLIBAO_STATE_CMD] = processNotifyActLibaoStateCmd;
			m_dicFun[stGiftCmd.PARA_RET_ACTLIBAO_CONTENT_CMD] = processRetActLibaoContentCmd;
			m_dicFun[stGiftCmd.PARA_ALREADY_PURCHASE_YZLB_OBJLIST_CMD] = processStAlreadyPurchaseYZLBObjListCmd;
			
			m_dicFun[stGiftCmd.PARA_NOTIFY_REFRESH_SECRET_STORE_OBJLIST_CMD] = psstNotifyRefreshSecretStoreObjListCmd;
			m_dicFun[stGiftCmd.PARA_RET_SECRET_STORE_OBJLIST_CMD] = psstRetSecretStoreObjListCmd;
			m_dicFun[stGiftCmd.PARA_BUY_SECRET_STORE_OBJ_CMD] = psstBuySecretStoreObjCmd;
			m_dicFun[stGiftCmd.RET_QUICK_COOL_ONLINE_GIFT_CMD] = psstRetQuickCoolOnlineGiftCmd;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			if (m_dicFun[param] != undefined)
			{
				m_dicFun[param](msg, param);
			}
		}
		
		// 启动的时候通知在线礼包
		public function processNotifyOnlineGift(msg:ByteArray, param:uint):void
		{	
			// 处理显示
			m_gkcontext.m_giftPackMgr.processNotifyOnlineGift(msg);
			
			// 如果在线礼包界面还打开着,就继续请求下一次的礼包数据
			var form:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
			if (form)
			{
				form.reqOnlineGiftContent();
			}
			else		// 请求一次数据，判断是否是武将 20137 
			{
				m_gkcontext.m_giftPackMgr.reqLB();
			}
		}
		
		public function processOnlineGiftContent(msg:ByteArray, param:uint):void
		{	
			// 检查是否有武将id 20137
			var cmd:retOnlineGiftContentUserCmd = new retOnlineGiftContentUserCmd();
			cmd.deserialize(msg);
			if (cmd.hasWuJiang())
			{
				// 添加日志啊，都是日志啊。
				m_gkcontext.m_giftPackMgr.logInfo(cmd.getWuJiang());
				
				m_gkcontext.m_giftPackMgr.WJID = cmd.getWuJiang();
				var ui:IUIScreenBtn = m_gkcontext.m_UIs.screenBtn;
				// 切换按钮图标
				if (ui)
				{
					ui.changeBtnIcon(ScreenBtnMgr.Btn_GiftPack, m_gkcontext.m_giftPackMgr.getIcon());
				}
				m_gkcontext.m_giftPackMgr.lingquType = 1;
				//m_gkcontext.m_giftPackMgr.changeDJS(20000);
				
				// 关闭在先礼包
				var gift:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
				if(gift)
				{
					gift.delForm(UIFormID.UIGPOnCntDw);
				}
			}
			else		// 只有没有武将的时候才更新
			{
				m_gkcontext.m_giftPackMgr.lingquType = 0;
				var form:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
				if (form)
				{
					msg.position = 0;
					form.processOnlineGiftContent(msg);
				}
			}
			m_gkcontext.m_giftPackMgr.reqType = 0;
		}
		
		public function processnotifyOnlineGiftEnd(msg:ByteArray, param:uint):void
		{
			// 删除礼包按钮,不能删除，需要继续领取武将
			var ui:IUIScreenBtn = m_gkcontext.m_UIs.screenBtn;
			if (ui != null)
			{
				ui.toggleBtnVisible(ScreenBtnMgr.Btn_GiftPack, false);
			}
			m_gkcontext.m_giftPackMgr.showBtn = false;
			
			// 关闭在先礼包
			var gift:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
			if(gift)
			{
				gift.delForm(UIFormID.UIGPOnCntDw);
			}
			
			// 关闭领取武将界面
			//var uiDaoJiShiWuJiang:IUIDaoJiShiWuJiang = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDaoJiShiWuJiang) as IUIDaoJiShiWuJiang;
			//if (uiDaoJiShiWuJiang)
			//{
			//	uiDaoJiShiWuJiang.exit();
			//}
			var uilqwj:IUILQWJ = m_gkcontext.m_UIMgr.getForm(UIFormID.UILQWJ) as IUILQWJ;
			if (uilqwj)
			{
				uilqwj.exit();
			}
		}
		
		// 等级礼包已经没有了
		// 等级礼包
		public function processLevelGiftContent(msg:ByteArray, param:uint):void
		{
			var form:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
			if (form && m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIGPLvl))
			{
				form.processLevelGiftContent(msg);
			}
			else
			{
				// 保存礼包数据
				m_gkcontext.m_contentBuffer.addContent("uiGPLvl_data", msg);
				m_gkcontext.m_giftPackMgr.showGiftPack(UIFormID.UIGPLvl);
			}
		}
		
		//通知客户端领取礼包成功,客户端需要播放礼包领取动画
		public function processGetGiftSuccess(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_giftPackMgr.giftAniData.m_giftState = 1;		// 进入道具屏蔽状态
		}
		
		// 礼包领取奖励后,服务器发送的物品领取结束的消息
		public function processsynSendGiftObjsEnd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_giftPackMgr.giftAniData.m_giftState = 0;		// 进入道具屏蔽状态
			var form:IUIAniGetGiftObj = m_gkcontext.m_UIMgr.getForm(UIFormID.UIAniGetGiftObj) as IUIAniGetGiftObj;
			if(form)
			{
				// 直接生成
				form.buildFly();
			}
			else
			{
				// 加载完成再飞行
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIAniGetGiftObj);
			}
		}
		
		//随机礼包数据
		public function processRetRandomGiftContent(msg:ByteArray, param:uint):void
		{
			var form:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
			//if (form && m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIGPRandom))
			if (form && m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIGPRandomNew))
			{
				form.processRetRandomGiftContent(msg);
			}
			else
			{
				// 保存礼包数据
				m_gkcontext.m_contentBuffer.addContent("uiGPRandom_data", msg);
				//m_gkcontext.m_giftPackMgr.showGiftPack(UIFormID.UIGPRandom);
				m_gkcontext.m_giftPackMgr.showGiftPack(UIFormID.UIGPRandomNew);
			}
		}
		
		//首充礼包信息
		public function processFirstChargeGiftboxInfoCmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_giftPackMgr.processFirstChargeGiftboxInfoCmd(msg);
		}
		
		//首充礼包状态
		public function processFirstChargeBoxStateCmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_giftPackMgr.processFirstChargeBoxStateCmd(msg);
		}
		
		//通知活动礼包活动状态
		public function processNotifyActLibaoStateCmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_giftPackMgr.processNotifyActLibaoStateCmd(msg);
		}
		
		//活动礼包道具信息
		public function processRetActLibaoContentCmd(msg:ByteArray, param:uint):void
		{
			var form:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
			if (form && m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIGPHuodong))
			{
				form.processRetActLibaoContentCmd(msg);
				
				if (m_gkcontext.m_giftPackMgr.bHDLBClickBtn)
				{
					var info:Object = new Object();
					info["funtype"] = "yuanbao";
					m_gkcontext.m_hintMgr.addToUIZhanliAddAni(info);
					m_gkcontext.m_giftPackMgr.bHDLBClickBtn = false;
				}
			}
			else
			{
				// 保存礼包数据
				m_gkcontext.m_contentBuffer.addContent("uiGPHuodong_data", msg);
				m_gkcontext.m_giftPackMgr.showGiftPack(UIFormID.UIGPHuodong);
			}
		}
		
		//一折礼包信息
		public function processStAlreadyPurchaseYZLBObjListCmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_yizhelibaoMgr.process_stAlreadyPurchaseYZLBObjListCmd(msg);
		}
		
		protected function psstNotifyRefreshSecretStoreObjListCmd(msg:ByteArray, param:uint):void
		{
			//var form:IUIMysteryShop = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMysteryShop) as IUIMysteryShop;
			//if (form)
			//{
				var cmd:stReqSecretStoreObjListCmd = new stReqSecretStoreObjListCmd();
				m_gkcontext.sendMsg(cmd);
			//}
		}
		
		protected function psstRetSecretStoreObjListCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRetSecretStoreObjListCmd = new stRetSecretStoreObjListCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_rankSys.objlist = cmd.objlist;
			
			var form:IUIMysteryShop = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMysteryShop) as IUIMysteryShop;
			if (form)
			{
				form.psstRetSecretStoreObjListCmd();
			}
		}
		
		public function psstBuySecretStoreObjCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stBuySecretStoreObjCmd = new stBuySecretStoreObjCmd();
			cmd.deserialize(msg);
			
			if (m_gkcontext.m_rankSys.objlist && m_gkcontext.m_rankSys.objlist.length)
			{
				var idx:int = 0;
				while (idx < 6)
				{
					if (m_gkcontext.m_rankSys.objlist[idx] / 10 == cmd.objno)
					{
						m_gkcontext.m_rankSys.objlist[idx] = cmd.objno * 10 + 1;
						break;
					}
					++idx;
				}
			}
			
			var form:IUIMysteryShop = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMysteryShop) as IUIMysteryShop;
			if (form)
			{
				form.updateUI();
			}
		}
		
		public function psstRetQuickCoolOnlineGiftCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRetQuickCoolOnlineGiftCmd = new stRetQuickCoolOnlineGiftCmd();
			cmd.deserialize(msg);
			
			if (cmd.ret == 0)
			{
				m_gkcontext.m_giftPackMgr.changeDJS(0);
			}
		}
	}
}