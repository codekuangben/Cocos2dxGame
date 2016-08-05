package modulecommon.scene.dazuo
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.dazuoCmd.stBuyFuYouExpPropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stBuyTimesChangePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stDaZuoOnlinePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stDZDataChangePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stEndDaZuoPropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stFuYouTimeChangePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stIncomeChangePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stReqOtherFuYouTimePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stRetDaZuoDataPropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stRetOtherFuYouTimePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stSaleFuYouExpToSysPropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stSetDaZuoStatePropertyUserCmd;
	import modulecommon.net.msg.dazuoCmd.stUserDZInfo;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.vip.VipPrivilegeMgr;
	import modulecommon.ui.Form;
	//import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.beings.UserState;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DaZuoMgr
	{
		public static const STATE_NODAZUO:uint = 0;		//非打坐
		public static const STATE_DAZUO:uint = 1;		//打坐
		
		private var m_gkContext:GkContext;
		private var m_uiBuyFuyouExp:UIBuyFuyouExp;
		
		public var m_state:uint; //打坐状态 0:非打坐  1:打坐
		public var m_xiulianExp:uint; //修炼经验
		public var m_corpsExp:uint; //军团科技加成经验
		public var m_xiulianTime:uint; //修炼时间
		public var m_fuyouTime:uint; //浮游时间
		public var m_income:uint; //收益(元宝)
		public var m_buyCounts:uint; //今日购买次数
		public var m_inTalkOnline:Boolean; //上线时，是否进入npc对话
		public var m_timer:Timer; //自动打坐倒计时
		
		public function DaZuoMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_inTalkOnline = false;
			m_uiBuyFuyouExp = new UIBuyFuyouExp(m_gkContext, this);
		}
		
		//打坐上线数据
		public function processDazuoOnlinePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stDaZuoOnlinePropertyUserCmd = new stDaZuoOnlinePropertyUserCmd();
			rev.deserialize(msg);
			
			m_state = rev.state;
			m_xiulianExp = rev.xiulianexp;
			m_corpsExp = rev.corpsexp;
			m_xiulianTime = rev.xiuliantime;
			m_fuyouTime = rev.fuyoutime;
			m_buyCounts = rev.buytime;
			m_income = rev.income;
			
			if (STATE_DAZUO == rev.state)
			{
				if (isCanDaZuo && !m_inTalkOnline)
				{
					beginDaZuo();
				}
				else
				{
					setStateOfDaZuo(STATE_NODAZUO);
				}
			}
		}
		
		//返回请求打坐的数据
		public function processRetDazuoDataPropertyUserCmd(msg:ByteArray):void
		{
			var rev:stRetDaZuoDataPropertyUserCmd = new stRetDaZuoDataPropertyUserCmd();
			rev.deserialize(msg);
			
			m_xiulianExp = rev.xiulianexp;
			m_corpsExp = rev.corpsexp;
			m_xiulianTime = rev.xiuliantime;
			m_fuyouTime = rev.fuyoutime;
			m_income = rev.income;
			
			if (STATE_DAZUO == m_state)
			{
				beginDaZuo();
			}
		}
		
		//打坐数据变化
		public function processDZDataChangePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stDZDataChangePropertyUserCmd = new stDZDataChangePropertyUserCmd();
			rev.deserialize(msg);
			
			m_xiulianExp = rev.xiulianexp;
			m_corpsExp = rev.corpsexp;
			m_xiulianTime = rev.xiuliantime;
			m_fuyouTime = rev.fuyoutime;
			
			//更新提示框中显示数据
			updateDatasUiform();
			updateDazuoBall();
		}
		
		//浮游时间变化
		public function processFuyouTimeChangePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stFuYouTimeChangePropertyUserCmd = new stFuYouTimeChangePropertyUserCmd();
			rev.deserialize(msg);
			
			m_fuyouTime = rev.fuyoutime;
			//更新剩余浮游时间显示
			updateDatasUiform();
			updateDazuoBall();
		}
		
		//收益变化
		public function processIncomeChangePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stIncomeChangePropertyUserCmd = new stIncomeChangePropertyUserCmd();
			rev.deserialize(msg);
			
			m_income = rev.income;
			//更新浮游经验收益数据显示
			updateDatasUiform();
		}
		
		//购买次数变化
		public function processBuyTimesChangePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stBuyTimesChangePropertyUserCmd = new stBuyTimesChangePropertyUserCmd();
			rev.deserialize(msg);
			
			m_buyCounts = rev.buytimes;
		}
		
		//其他玩家相关信息:userid、浮游时间
		public function processRetOtherFuyouTimeProperytUserCmd(msg:ByteArray):void
		{
			var rev:stRetOtherFuYouTimePropertyUserCmd = new stRetOtherFuYouTimePropertyUserCmd();
			rev.deserialize(msg);
			
			var list:Array = rev.infolist;
			var item:stUserDZInfo;
			if (list)
			{
				if (1 == list.length)
				{
					item = list[0] as stUserDZInfo;
					m_uiBuyFuyouExp.showBuyFuyouExpPromp(item.userid, item.fuyoutime);
				}
				else
				{
					m_uiBuyFuyouExp.showOtherPlayerList(list);
				}
			}
		}
		
		//更新打坐状态
		public function updateStateOfDaZuo():void
		{
			setStateOfDaZuo((m_state + 1) % 2);
		}
		
		//设置打坐状态 Meditation practice
		public function setStateOfDaZuo(bdazuo:uint):void
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_DAZUO) == false)
			{
				//m_gkContext.m_systemPrompt.prompt("打坐修练 功能暂未开启");
				return;
			}
			
			var cmd:stSetDaZuoStatePropertyUserCmd = new stSetDaZuoStatePropertyUserCmd();
			if (STATE_DAZUO == bdazuo)
			{
				cmd.isset = STATE_DAZUO;
			}
			else
			{
				cmd.isset = STATE_NODAZUO;
				stopDaZuo();
			}
			m_gkContext.sendMsg(cmd);
			m_state = cmd.isset;
		}
		
		//开始打坐修炼...
		public function beginDaZuo():void
		{
			//添加开始打坐特效相关
			var playerMain:PlayerMain = m_gkContext.m_playerManager.hero;
			if (playerMain)
			{
				playerMain.setUserState(UserState.USERSTATE_DAZUO);
				updateDazuoBall();
			}
			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIDaZuo) as IForm;
			if (form)
			{
				if (!m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIDaZuo))
				{
					form.show();
				}
				form.updateData();
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIDaZuo);
			}
		}
		
		//结束打坐
		public function stopDaZuo():void
		{
			var playerMain:PlayerMain = m_gkContext.m_playerManager.hero;
			if (playerMain)
			{
				playerMain.clearUserState(UserState.USERSTATE_DAZUO);
				updateDazuoBall();
			}
			
			//添加结束打坐特效相关
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIDaZuo) as IForm;
			if (form && m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIDaZuo))
			{
				form.hide();
			}
			
			if (STATE_DAZUO == m_state)
			{
				m_state = STATE_NODAZUO;
			}
			
			setBeginTimer();
		}
		
		public function updateDazuoBall():void
		{
			var playerMain:PlayerMain = m_gkContext.m_playerManager.hero;
			if (playerMain)
			{
				if ((playerMain.state == EntityCValue.TDaZuo) && (Math.floor(m_fuyouTime / 60)))
				{
					playerMain.setUserState(UserState.USERSTATE_FUYOUEXP);
				}
				else
				{
					playerMain.clearUserState(UserState.USERSTATE_FUYOUEXP);
				}
			}
		}
		
		//领取奖励(结束打坐)
		public function getRewardAddStopDazuo():void
		{
			var cmd:stEndDaZuoPropertyUserCmd = new stEndDaZuoPropertyUserCmd();
			m_gkContext.sendMsg(cmd);
			
			stopDaZuo();
			
			if ((m_xiulianExp + m_corpsExp) > 0)
			{
				var param:Object = new Object();
				param["funtype"] = "jingyan";
				param["num"] = m_xiulianExp + m_corpsExp;
				m_gkContext.m_hintMgr.addToUIZhanliAddAni(param);
			}
			
			if (m_income > 0)
			{
				showRewardExpAndMoneyAni(BeingProp.YUAN_BAO, m_income);
			}
		}
		
		//购买浮游经验 thisid:被购玩家thisid  hour:浮游时间(小时)
		public function buyFuyouExp(thisid:uint, hour:uint):void
		{
			var cmd:stBuyFuYouExpPropertyUserCmd = new stBuyFuYouExpPropertyUserCmd();
			cmd.otheruser = thisid;
			cmd.hour = hour;
			m_gkContext.sendMsg(cmd);
		}
		
		//出售浮游经验给系统 min:浮游时间(小时)
		public function saleFuyouExp(hour:uint):void
		{
			var cmd:stSaleFuYouExpToSysPropertyUserCmd = new stSaleFuYouExpToSysPropertyUserCmd();
			cmd.hour = hour;
			m_gkContext.sendMsg(cmd);
		}
		
		//请求玩家浮游时间
		public function reqOtherFuyouTimes(list:Array):void
		{
			var cmd:stReqOtherFuYouTimePropertyUserCmd = new stReqOtherFuYouTimePropertyUserCmd();
			cmd.num = list.length;
			cmd.userlist = list;
			m_gkContext.sendMsg(cmd);
		}
		
		public function updateDatasUiform():void
		{
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIDaZuo) as IForm;
			if (form && m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIDaZuo))
			{
				form.updateData();
			}
		}
		
		//计时结束，设置打坐状态
		protected function onTimer(e:TimerEvent):void
		{
			if (false == isCanDaZuo)
			{
				setBeginTimer();
			}
			else
			{
				if (STATE_NODAZUO == m_state)
				{
					setStateOfDaZuo(STATE_DAZUO);
				}
			}
		}
		
		//重置自动打坐倒计时
		public function setBeginTimer():void
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_DAZUO) == false)
			{
				return;
			}
			
			if (null == m_timer)
			{
				m_timer = new Timer(60000); //1min
				m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer.repeatCount = 1;
			}
			
			m_timer.reset();
			m_timer.start();
		}
		public function clearTimer():void
		{
			if (m_timer)
			{
				m_timer.stop();
			}
			
		}
		//今日购买他人浮游经验剩余次数(即小时)
		public function get leftBuyTimeCounts():uint
		{
			var ret:uint = m_gkContext.m_vipPrivilegeMgr.getPrivilegeValue(VipPrivilegeMgr.Vip_DazuoBuyExp);
			
			if (ret >= m_buyCounts)
			{
				ret -= m_buyCounts;
			}
			else
			{
				ret = 0;
			}
			
			return ret;
		}
		
		public function onPlayerMainStateChage(oldState:uint, newState:uint):void
		{
			if (EntityCValue.TStand == newState)
			{
				setBeginTimer();
			}
			else
			{
				clearTimer();
			}
			
			//打坐中，结束打坐
			if (EntityCValue.TDaZuo == oldState)
			{
				if (STATE_DAZUO == m_state)
				{
					setStateOfDaZuo(STATE_NODAZUO);
				}
			}
		}
		
		private function showRewardExpAndMoneyAni(moneytype:uint, moneynum:uint):void
		{
			var paramAni:Object = new Object();
			paramAni["type"] = moneytype;
			paramAni["num"] = moneynum;
			
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIFallObjectPicupAni);
			if (form)
			{
				form.updateData(paramAni);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("uiFallObjectPicupAni_data", paramAni);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIFallObjectPicupAni);
			}
		}
		
		//是否打坐
		public function get isDaZuoing():Boolean
		{
			return (STATE_DAZUO == m_state);
		}
		
		//现在是否可以打坐
		public function get isCanDaZuo():Boolean
		{
			var ret:Boolean = false;
			
			//只能在主城中打坐修炼(且不在竞技场、战斗场景、三国群英会)
			if ((MapInfo.MTMain == m_gkContext.m_mapInfo.mapType()) && !m_gkContext.m_mapInfo.m_bInArean && !m_gkContext.m_mapInfo.m_bInSGQYH && !m_gkContext.m_mapInfo.m_bInBattleIScene)
			{
				ret = true;
			}
			
			return ret;
		}
	}

}