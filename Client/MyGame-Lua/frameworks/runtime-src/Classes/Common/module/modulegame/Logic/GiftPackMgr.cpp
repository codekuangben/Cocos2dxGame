package game.logic
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.UtilCommon;
	import modulecommon.net.msg.giftCmd.stNotifyActLiBaoStateCmd;
	import modulecommon.uiinterface.IUILQWJ;
	//import modulecommon.uiinterface.IUIDaoJiShiWuJiang;
	import modulecommon.uiinterface.IUIRecruit;
	//import flash.desktop.ClipboardFormats;
	import flash.utils.ByteArray;
	//import flash.utils.Dictionary;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	
	import game.netmsg.giftCmd.stNotifyOnlineGiftUserCmd;
	import modulecommon.net.msg.giftCmd.stFirstChargeBoxInfoCmd;
	import modulecommon.net.msg.giftCmd.stFirstChargeBoxStateCmd;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.GiftAniData;
	import modulecommon.logicinterface.IGiftPackMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIGiftPack;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.net.msg.giftCmd.reqOnlineGiftContentUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class GiftPackMgr implements IGiftPackMgr
	{
		public var m_gkcontext:GkContext;
		public var m_uilist:Vector.<uint>;
		private var m_daojishi:Daojishi;
		private var m_LastTime:uint;	// 礼包倒计时
		private var m_id:uint;			// 礼包的 id
		private var m_binit:Boolean;	// 倒计时礼包按钮是否创建
		private var m_showBtn:Boolean;	// 是否需要显示按钮
		private var m_giftAniData:GiftAniData;
		private var m_firstRechargeState:uint;	//首充礼包状态 //按位 第一位:是否充值 第二位:是否领取礼包
		private var m_frgList:Array;	//首充礼包奖励
		private var m_bGetFRGift:Boolean = true;//是否已经领取首充奖励 ture:已领取
		private var m_hdlbState:uint = 0;		//活动礼包状态 //1-开始(显示) 0-结束(消失)
		private var m_bHDLBClickBtn:Boolean = false;//是否点击 活动礼包“领取奖励”按钮
		
		private var m_lingquType:uint;		// 领取礼包还是武将 0 礼包 1 武将
		private var m_reqType:uint;			// 0 点击请求在线礼包数据， 1 自己主动请求数据，主要是判断道具数据， 20137 这个是武将 id
		private var m_WJID:uint;			// 武将的id
		
		private var m_curIconName:String;	// 当前图标名字
		
		public function GiftPackMgr(value:GkContext) 
		{
			m_gkcontext = value;
			m_uilist = new Vector.<uint>();
			m_giftAniData = new GiftAniData;
		}
		
		public function showGiftPack(id:uint):void
		{
			var form:Form = m_gkcontext.m_UIMgr.getForm(id);
			if (!form)
			{
				form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack);
				if (!form)	// 说明模块没有加载
				{
					if (m_uilist.indexOf(id) == -1)
					{
						m_uilist.push(id);
						m_gkcontext.m_UIMgr.loadForm(UIFormID.UIGiftPack);
					}
				}
				else
				{
					(form as IUIGiftPack).newForm(id);
				}
			}
			else
			{
				form.show();
			}
		}
		
		public function get uilist():Vector.<uint>
		{
			return m_uilist;
		}
		
		private function beginDaojishi():void
		{
			m_daojishi.funCallBack = updateDaojishi;
			
			m_daojishi.initLastTime = 1000*m_LastTime;
			if(m_LastTime > 0)
			{
				m_daojishi.begin();
			}
			
			// 显示 UI
			if (m_gkcontext.m_UIs.screenBtn)
			{
				if(!m_binit)
				{
					m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_GiftPack);
					m_binit = true;
				}
				m_gkcontext.m_UIs.screenBtn.updateGiftTime(m_daojishi.timeSecond);
			}
		}
		
		private function updateDaojishi(d:Daojishi):void
		{
			// 如果没有停止 bug ：如果开始的时候倒计时就是  0，那么
			//if (!m_daojishi.isStop())
			//{
				var time:String = UtilTools.formatTimeToString(m_daojishi.timeSecond);
				var ui:IUIScreenBtn = m_gkcontext.m_UIs.screenBtn;
				if (ui != null)
				{
					if (!m_binit)
					{
						ui.addBtnByID(ScreenBtnMgr.Btn_GiftPack);
						if (m_lingquType == 1)
						{
							ui.changeBtnIcon(ScreenBtnMgr.Btn_GiftPack, getIcon());
						}
						m_binit = true;
					}
					ui.updateGiftTime(m_daojishi.timeSecond);
				}
				
				if (m_lingquType == 0)
				{
					// 更新界面显示
					var gf:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
					if (gf)
					{
						gf.updateTimeLabel(UIFormID.UIGPOnCntDw, m_daojishi.timeSecond);
					}
				}
				else
				{
					// 更新武将领取奖励
					//var uiDaoJiShiWuJiang:IUIDaoJiShiWuJiang = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDaoJiShiWuJiang) as IUIDaoJiShiWuJiang;
					//if (uiDaoJiShiWuJiang)
					//{
					//	uiDaoJiShiWuJiang.updateTimeLabel(m_daojishi.timeSecond);
					//}
					
					var uilqwj:IUILQWJ = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UILQWJ) as IUILQWJ;
					if (uilqwj)
					{
						uilqwj.updateTimeLabel(m_daojishi.timeSecond);
					}
					
					//if (m_curIconName != getIcon(false))
					//{
						ui = m_gkcontext.m_UIs.screenBtn;
						if (ui != null)
						{
							ui.changeBtnIcon(ScreenBtnMgr.Btn_GiftPack, getIcon());
						}
					//}
				}
				
				// 记录时间
				m_LastTime = m_daojishi.timeSecond;
			//}
			if (m_daojishi.isStop())
			///else	// 如果停止就把按钮去掉
			{
				m_daojishi.end();
			}
		}

		public function processNotifyOnlineGift(msg:ByteArray):void
		{
			m_showBtn = true;
			var cmd:stNotifyOnlineGiftUserCmd = new stNotifyOnlineGiftUserCmd();
			cmd.deserialize(msg);
			
			m_id = cmd.id;
			changeDJS(cmd.time);
		}
		
		public function changeDJS(totaltime:uint):void
		{
			m_LastTime = totaltime;
			
			if (!m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkcontext.m_context);
			}
			beginDaojishi();
		}
		
		public function get lastTime():Number
		{
			return m_LastTime;
		}
		
		public function get id():uint
		{
			return m_id;
		}
		
		public function set showBtn(value:Boolean):void
		{
			m_showBtn = value;
		}
		
		public function get showBtn():Boolean
		{
			return m_showBtn; 
		}
		
		public function set binit(value:Boolean):void
		{
			m_binit = value; 
		}
		
		public function get binit():Boolean
		{
			return m_binit;
		}
		
		public function get giftAniData():GiftAniData
		{
			return m_giftAniData;
		}
		
		//首充礼包信息
		public function processFirstChargeGiftboxInfoCmd(msg:ByteArray):void
		{
			var ret:stFirstChargeBoxInfoCmd = new stFirstChargeBoxInfoCmd();
			ret.deserialize(msg);
			
			m_bGetFRGift = false;
			m_firstRechargeState = ret.m_state;
			m_frgList = ret.m_giftList;
		}
		
		//首充礼包状态
		public function processFirstChargeBoxStateCmd(msg:ByteArray):void
		{
			var ret:stFirstChargeBoxStateCmd = new stFirstChargeBoxStateCmd();
			ret.deserialize(msg);
			
			m_firstRechargeState = ret.m_state;
			
			if (UtilCommon.isSetUint(m_firstRechargeState, 1))
			{
				m_bGetFRGift = true;
			}
			else
			{
				m_bGetFRGift = false;
			}
			
			if (m_bGetFRGift && m_gkcontext.m_UIs.screenBtn)
			{
				//m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_FirstRecharge, false);
				m_gkcontext.m_UIs.screenBtn.firstRechargeVisible(false);
			}
		}
		
		//通知活动礼包活动状态
		public function processNotifyActLibaoStateCmd(msg:ByteArray):void
		{
			var ret:stNotifyActLiBaoStateCmd = new stNotifyActLiBaoStateCmd();
			ret.deserialize(msg);
			
			m_hdlbState = ret.m_state;
			
			if (m_gkcontext.m_UIs.screenBtn)
			{
				if (1 == m_hdlbState)
				{
					m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_Huodonglibao);//显示
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_Huodonglibao, true);
				}
				else
				{
					m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_Huodonglibao, false);//消失
					// 关闭活动礼包
					var gift:IUIGiftPack = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGiftPack) as IUIGiftPack;
					if(gift)
					{
						gift.delForm(UIFormID.UIGPHuodong);
					}
				}
			}
			
			if (m_gkcontext.m_giftPackMgr.bHDLBClickBtn)
			{
				var param:Object = new Object();
				param["funtype"] = "yuanbao";
				m_gkcontext.m_hintMgr.addToUIZhanliAddAni(param);
				m_gkcontext.m_giftPackMgr.bHDLBClickBtn = false;
			}
		}
		
		//是否充值
		public function get isFirstRecharge():Boolean
		{
			return UtilCommon.isSetUint(m_firstRechargeState, 0);
		}
		
		//是否领取首充奖励
		public function get isGetFRGift():Boolean
		{
			return m_bGetFRGift;
		}
		
		//获得首充礼包奖励信息
		public function getFRGList():Array
		{
			return m_frgList;
		}
		
		public function get hdlbState():uint
		{
			return m_hdlbState;
		}
		
		public function set bHDLBClickBtn(bool:Boolean):void
		{
			m_bHDLBClickBtn = bool;
		}
		
		public function get bHDLBClickBtn():Boolean
		{
			return m_bHDLBClickBtn;
		}
		
		public function get lingquType():uint
		{
			return m_lingquType;
		}
		
		public function set lingquType(value:uint):void
		{
			m_lingquType = value;
			
			// 如果是领取武将,如果已经结束,显示的特效需要单独配置
			if (m_lingquType == 1)
			{
				var ui:IUIScreenBtn = m_gkcontext.m_UIs.screenBtn;
				if (ui != null)
				{
					if (m_binit)		// 如果已经显示按钮了
					{
						if (m_LastTime == 0)		// 如果倒计时为 0 ，已经显示特效了
						{
							ui.updateGiftTime(m_LastTime);
						}	
					}
				}
			}
		}
		
		public function get reqType():uint
		{
			return m_reqType;
		}
		
		public function set reqType(value:uint):void
		{
			m_reqType = value;
		}
		
		// 不是通过点击按钮，而是自己主动请求请求礼包数据，以便进行一些判断
		public function reqLB():void
		{
			m_gkcontext.m_giftPackMgr.reqType = 1;
			// 请求礼包数据
			var cmd:reqOnlineGiftContentUserCmd = new reqOnlineGiftContentUserCmd();
			m_gkcontext.sendMsg(cmd);
		}
		
		// 打开武将领取界面
		public function showWuJiang():void
		{
			//var uiDaoJiShiWuJiang:IUIDaoJiShiWuJiang = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDaoJiShiWuJiang) as IUIDaoJiShiWuJiang;
			//if (uiDaoJiShiWuJiang)
			//{
			//	uiDaoJiShiWuJiang.setData(m_WJID);
			//}
			//else
			//{
			//	var uirecruit:IUIRecruit = m_gkcontext.m_UIMgr.getForm(UIFormID.UIRecruit) as IUIRecruit;
			//	if (uirecruit)
			//	{
			//		uirecruit.addUIDaoJiShiWuJiang();
			//		uiDaoJiShiWuJiang = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDaoJiShiWuJiang) as IUIDaoJiShiWuJiang;
			//		if (uiDaoJiShiWuJiang)
			//		{
			//			uiDaoJiShiWuJiang.setData(m_WJID);
			//		}
			//	}
			//	else
			//	{
			//		m_gkcontext.m_contentBuffer.addContent("uiDaoJiShiWuJiang_wuID", m_WJID);
			//		m_gkcontext.m_UIMgr.loadForm(UIFormID.UIRecruit);
			//	}
			//}
			
			var uilqwj:IUILQWJ = m_gkcontext.m_UIMgr.getForm(UIFormID.UILQWJ) as IUILQWJ;
			if (uilqwj)
			{
				uilqwj.setData(m_WJID);
			}
			else
			{
				uilqwj = this.m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UILQWJ) as IUILQWJ;
				uilqwj.setData(m_WJID);
				(uilqwj as Form).show();
			}
		}

		public function get WJID():uint
		{
			return m_WJID;
		}
		
		public function set WJID(value:uint):void
		{
			if (value == EntityCValue.WUJIANG)
			{
				m_WJID = EntityCValue.NPCBattleWUJIANG;
			}
			else if (value == EntityCValue.WUJIANG1f)
			{
				m_WJID = EntityCValue.NPCBattleWUJIANG1f;
			}
			else if (value == EntityCValue.WUJIANG2f)
			{
				m_WJID = EntityCValue.NPCBattleWUJIANG2f;
			}
			else
			{
				m_WJID = EntityCValue.NPCBattleWUJIANG;
			}
		}
		
		// 是否记录当前
		public function getIcon(brecode:Boolean = true):String
		{
			if (m_WJID == EntityCValue.NPCBattleWUJIANG)
			{
				if (brecode)
				{
					m_curIconName = "lingquzijiang"
				}
				return "lingquzijiang";
			}
			else if (m_WJID == EntityCValue.NPCBattleWUJIANG1f)
			{
				if (brecode)
				{
					m_curIconName = "lingquhuanzhong"
				}
				return "lingquhuanzhong";
			}
			else if (m_WJID == EntityCValue.NPCBattleWUJIANG2f)
			{
				if (brecode)
				{
					m_curIconName = "lingquguanyu"
				}
				return "lingquguanyu";
			}
			else
			{
				if (brecode)
				{
					m_curIconName = "lingquzijiang"
				}
				return "lingquzijiang";
			}
		}
		
		// 又添加校验数据流程
		public function logInfo(wjid):void
		{
			if (m_WJID != 0 && m_WJID == wjid)	// 如果两次武将 id 相同，就是有问题的
			{
				var str:String = "";
				str += ("m_WJID=" + m_WJID + "; iconname=" + getIcon());
				m_gkcontext.m_context.sendErrorToDataBase(str);
			}
		}
	}
}