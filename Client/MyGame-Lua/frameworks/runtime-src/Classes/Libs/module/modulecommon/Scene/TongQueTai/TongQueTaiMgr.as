package modulecommon.scene.tongquetai
{
	import adobe.utils.CustomActions;
	import flash.net.drm.VoucherAccessInfo;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.notifyBestCopyPkReviewCopyUserCmd;
	import modulecommon.net.msg.wunvCmd.DancingWuNvMsg;
	import modulecommon.net.msg.wunvCmd.notifyWuNvReapDataUserCmd;
	import modulecommon.net.msg.wunvCmd.stAddNewMySteryWuNvUserCmd;
	import modulecommon.net.msg.wunvCmd.stAddNewWuNvUserCmd;
	import modulecommon.net.msg.wunvCmd.stDelWuNvUserCmd;
	import modulecommon.net.msg.wunvCmd.updateWuNvStealUserCmd;
	import modulecommon.net.msg.wunvCmd.WuNvReap;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.net.msg.wunvCmd.stNotifyWuNvDataUserCmd;
	import modulecommon.net.msg.wunvCmd.stRetBeginWuNvDancingUserCmd;
	import modulecommon.net.msg.wunvCmd.SpecialWuNv;
	import modulecommon.uiinterface.IUITongQueTai;
	import modulecommon.uiinterface.IUITongQueWuHui;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.net.msg.wunvCmd.stRetGetWuNvOutPutUserCmd;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TongQueTaiMgr
	{
		private var m_gkContext:GkContext;
		private var m_list:Array;
		public var m_dicIdToDancer:Dictionary; //[id,dancer]
		public var m_chatList:Dictionary; //[累加概率,GrilChat.text]
		private var m_totper:int;
		
		public var m_dancingList:Dictionary; //[pos,DancingWuNv]正在跳舞舞女
		public var m_dicSpecialDancer:Dictionary; //[id,SpecialWuNv] 拥有的神秘舞女
		
		public var m_curdancer:int;
		
		public var m_wuHuiName:String;
		public var m_curFriId:int;
		public var m_isInHome:Boolean;
		public var m_openDoublePage:Boolean;
		public var m_dicHasNum:Dictionary; //选择舞女界面左边普通舞女收获次数
		
		public var m_uiTongquetai:IUITongQueTai;
		public var m_uiWuhui:IUITongQueWuHui;
		public var m_totalTimeUp:int;
		
		public function TongQueTaiMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_dancingList = new Dictionary();
			m_totalTimeUp = 0;
		}
		
		public function loadConfig():void
		{
			if (m_list)
			{
				return;
			}
			m_list = new Array();
			m_dicIdToDancer = new Dictionary();
			m_dicSpecialDancer = new Dictionary();
			m_chatList = new Dictionary();
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_TongQueTai);
			var tabXml:XML;
			var dancer:DancerBase;
			var chat:GirlChat;
			for each (tabXml in xml.elements("commongirls").elements("*"))
			{
				dancer = new NormalDancer();
				dancer.parse(tabXml);
				m_list.push(dancer);
				m_dicIdToDancer[dancer.m_id] = dancer;
			}
			for each (tabXml in xml.elements("mysterygirls").elements("*"))
			{
				dancer = new MysteryDancer();
				dancer.parse(tabXml);
				m_dicIdToDancer[dancer.m_id] = dancer;
			}
			m_totper = 0;
			for each (tabXml in xml.elements("girl_chat").elements("*"))
			{
				chat = new GirlChat();
				chat.parse(tabXml);
				m_totper += chat.m_pertime;
				chat.m_tottime = m_totper;
				m_chatList[m_totper] = chat;
			}
		}
		public function chatByRandom():Object
		{
			var ran:int = Math.floor(Math.random() * m_totper);//按照per比例决定出现那一句话
			var chat:GirlChat;
			var str:String = "";
			for each(chat in m_chatList)
			{
				if (ran < chat.m_tottime)
				{
					str = chat.m_text;
					break;
				}
			}
			var time:int = Math.floor(Math.random() * 340 + 10);//每10-350s 出现话语
			var timeAndStr:Object = new Object();
			timeAndStr.time = time;
			timeAndStr.str = str;
			return timeAndStr;
		}
		
		public function curDancer():DancerBase
		{
			return m_dicIdToDancer[m_curdancer] as DancerBase;
		}
		
		public function getMysteryList():Dictionary
		{
			return m_dicSpecialDancer;
		}
		
		public function getNormalList():Array
		{
			if (m_list == null)
			{
				loadConfig();
			}
			return m_list;
		}
		
		public function get m_curSelectID():int
		{
			return m_curdancer;
		}
		
		//好感上限值
		public function get haoganUpperLimit():int
		{
			return 500;
		}
		/**
		 * 原本上线消息 由于服务器需要这里可能会再次收到此消息只改变tempid其他的不需要考虑
		 */
		public function process_stNotifyWunvDataUsercmd(byte:ByteArray, param:uint):void
		{
			loadConfig();
			m_curdancer = (m_list[0] as NormalDancer).m_id;
			var rev:stNotifyWuNvDataUserCmd = new stNotifyWuNvDataUserCmd();
			rev.deserialize(byte);
			var id:int;
			for each (id in rev.m_id)
			{
				(m_dicIdToDancer[id] as NormalDancer).m_bOwn = true;
			}
			
			var dancing:DancingWuNv;
			for (var i:int = 0; i < rev.m_did.length; i++)
			{
				dancing = new DancingWuNv(m_gkContext.m_context, this);
				dancing.init(rev.m_did[i]);
				var ldancing:DancingWuNv = m_dancingList[dancing.m_dancingMsg.pos];//如果同样位置上有舞女则删除此舞女
				if (ldancing)
				{
					if (m_uiWuhui)
					{
						m_uiWuhui.removeDancing(ldancing);
					}
					delete m_dancingList[ldancing.m_dancingMsg.pos];
					ldancing.dispose();
					m_dancingList[dancing.m_dancingMsg.pos] = dancing;
					if (m_uiWuhui)
					{
						m_uiWuhui.addDancing(dancing);
					}
				}
				else
				{
					m_dancingList[dancing.m_dancingMsg.pos] = dancing;
				}
				
			}
			
			m_dicSpecialDancer = rev.m_sid;
			var mystery:SpecialWuNv;
			for each (mystery in m_dicSpecialDancer)
			{
				mystery.m_dancer = this.getDancerByID(mystery.id) as MysteryDancer;
			}
		
		}
		
		public function process_stRetBeginWuNvDancingUserCmd(byte:ByteArray, param:uint):void
		{
			var rev:stRetBeginWuNvDancingUserCmd = new stRetBeginWuNvDancingUserCmd();
			rev.deserialize(byte);
			if (rev.m_pos == stRetBeginWuNvDancingUserCmd.POS_NONE)
			{
				return;
			}
			var dancing:DancingWuNv = new DancingWuNv(m_gkContext.m_context, this);
			dancing.init2(rev.m_id, rev.m_tempid, rev.m_pos);
			m_dancingList[dancing.m_dancingMsg.pos] = dancing;
			
			if (m_uiWuhui)
			{
				m_uiWuhui.addDancing(dancing);
				m_uiWuhui.swichToMyPanel();
			}
			
			if (m_uiTongquetai)
			{
				m_uiTongquetai.exit();
			}
		}
		public function process_stRetGetWuNvOutPutUserCmd(byte:ByteArray, param:uint):void
		{
			var rev:stRetGetWuNvOutPutUserCmd = new stRetGetWuNvOutPutUserCmd();
			rev.deserialize(byte);
			
			if (rev.m_ret == 0)
			{
				var dancing:DancingWuNv = getDancingByTempID(rev.m_tempid);
				if (dancing)
				{
					for each(var i:NormalDancer in m_list)
					{
						
						if (m_dicHasNum[i.m_id])
						{
							if (i.m_reqid == 0 || i.m_reqid == dancing.m_dancerBase.m_id)
							{
								m_dicHasNum[i.m_id]++;
							}
						}
						else
						{
							if (i.m_reqid == 0 || i.m_reqid == dancing.m_dancerBase.m_id)
							{
								m_dicHasNum[i.m_id] = 1;
							}
						}
					}
					if (m_uiWuhui)
					{
						m_uiWuhui.removeDancing(dancing);
					}
					delete m_dancingList[dancing.m_dancingMsg.pos];
					dancing.dispose();
					sectimeUp();
				}
				if (m_uiTongquetai)
				{
					m_uiTongquetai.updataIconName();
				}
			}
		}
		
		public function process_stAddNewWuNvUserCmd(byte:ByteArray, param:uint):void
		{
			var rev:stAddNewWuNvUserCmd = new stAddNewWuNvUserCmd();
			rev.deserialize(byte);
			
			var dancer:NormalDancer = this.getDancerByID(rev.m_id) as NormalDancer;
			if (dancer)
			{
				dancer.m_bOwn = true;
			}
			if (m_uiTongquetai)
			{
				m_uiTongquetai.addNormalDancer(rev.m_id);
			}
		}
		
		public function process_notifyWuNvReapDataUserCmd(byte:ByteArray, param:uint):void
		{
			m_dicHasNum = new Dictionary();
			var rev:notifyWuNvReapDataUserCmd = new notifyWuNvReapDataUserCmd();
			rev.deserialize(byte);
			var item:WuNvReap = new WuNvReap();
			for each (item in rev.m_wuNvReap)
			{
				m_dicHasNum[item.m_id] = item.m_count;
			}
		
		}
		
		//得到神秘舞女,更新神秘舞女数量
		public function process_stAddNewMySteryWuNvUserCmd(byte:ByteArray, param:uint):void
		{
			var rev:stAddNewMySteryWuNvUserCmd = new stAddNewMySteryWuNvUserCmd();
			rev.deserialize(byte);
			
			var bAdd:Boolean;
			var mysterygirl:SpecialWuNv = getSpecialDancerOwned(rev.id);
			if (mysterygirl)
			{
				mysterygirl.num = rev.num;
				if (mysterygirl.num == 0)
				{										
					if (m_uiTongquetai)
					{
						m_uiTongquetai.deleteSpecialDancer(rev.id);
					}
					delete m_dicSpecialDancer[rev.id];
				}
				else
				{
					if (m_uiTongquetai)
					{
						m_uiTongquetai.updateNumOfSpecialDancer(rev.id);
					}
				}
			}
			else
			{
				mysterygirl = new SpecialWuNv();
				mysterygirl.m_dancer = this.getDancerByID(rev.id) as MysteryDancer;
				mysterygirl.id = rev.id;
				mysterygirl.num = rev.num;
				m_dicSpecialDancer[mysterygirl.id] = mysterygirl;
				if (m_uiTongquetai)
				{
					m_uiTongquetai.addSpecialDancer(rev.id);
				}
			}
		
		}
		
		//删除神秘舞女
		public function process_stDelWuNvUserCmd(byte:ByteArray, param:uint):void
		{
			/*var rev:stDelWuNvUserCmd = new stDelWuNvUserCmd();
			rev.deserialize(byte);
			
			var dancer:SpecialWuNv = getSpecialDancerOwned(rev.id)
			if (dancer == null)
			{
				return;
			}
			delete m_dicSpecialDancer[rev.id];
			
			if (m_uiTongquetai)
			{
				m_uiTongquetai.deleteSpecialDancer(rev.id);
			}*/
		
		}
		public function process_updateWuNvStealUserCmd(byte:ByteArray, param:uint):void
		{
			var rev:updateWuNvStealUserCmd = new updateWuNvStealUserCmd();
			rev.deserialize(byte)
			var pos:uint=4;
			for each(var wunv:DancingWuNv in m_dancingList)
			{
				if (wunv.m_dancingMsg.tempid == rev.m_tempid)
				{
					var obj:Object = new Object();
					obj.m_name = rev.m_name;
					if (wunv.m_dancingMsg.stolenList.length == 0)
					{
						obj.m_value = wunv.m_dancerBase.m_outputvalue / 10;
					}
					else
					{
						obj.m_value = wunv.m_dancerBase.m_outputvalue / 20;
					}
					wunv.m_dancingMsg.stolenList.push(obj);
					pos = wunv.m_dancingMsg.pos;
				}
			}
			if (pos != 4)
			{
				if (m_uiWuhui)
				{
					m_uiWuhui.updataTime(pos);
				}
			}
		}
		
		public function getNumOfMysteryDancer(id:uint):int
		{
			var item:SpecialWuNv = getSpecialDancerOwned(id);
			if (item)
			{
				return item.num;
			}
			return 0;
		}
		
		public function getDancerByID(id:uint):DancerBase
		{
			return m_dicIdToDancer[id];
		}
		
		public function getSpecialDancerOwned(id:uint):SpecialWuNv
		{
			return m_dicSpecialDancer[id];
		}
		
		//返回正在跳舞的舞女
		public function getDancingByTempID(tempid:uint):DancingWuNv
		{
			var ret:DancingWuNv;
			for each (ret in m_dancingList)
			{
				if (ret.m_dancingMsg.tempid == tempid)
				{
					return ret;
				}
			}
			return null;
		}
		
		//返回正在跳舞的舞女
		public function getDancingByPos(pos:int):DancingWuNv
		{
			return m_dancingList[pos];
		}
		
		public function getNumOfDancing():int
		{
			var ret:int;
			var dancing:DancingWuNv;
			for each (dancing in m_dancingList)
			{
				ret++;
			}
			return ret;
		}
		
		public function addTimeUp():void
		{
			m_totalTimeUp++;
			if (m_totalTimeUp == 1)
			{
				if (m_gkContext.m_UIs.sysBtn)
				{
					m_gkContext.m_UIs.sysBtn.showEffectAni(SysbtnMgr.SYSBTN_TongqueTai);
				}
			}
		}
		
		public function sectimeUp():void
		{
			m_totalTimeUp--;
			if (m_totalTimeUp == 0)
			{
				if (m_gkContext.m_UIs.sysBtn)
				{
					m_gkContext.m_UIs.sysBtn.hideEffectAni(SysbtnMgr.SYSBTN_TongqueTai);
				}
			}
		}
		public function getTimeup():Boolean
		{
			return m_totalTimeUp != 0;
		}
		
	}

}