package game.ui.uiHintMgr.subform 
{
	import flash.events.MouseEvent;
	import net.ContentBuffer;
	import modulecommon.net.msg.sceneUserCmd.stNotifyAnswerQuestionQuestNpcInfoCmd;
	import modulecommon.scene.beings.PlayerMain;
	import com.util.UtilHtml;
	import game.ui.uiHintMgr.UIHintMgr;
	import com.bit101.components.Panel;
	/**
	 * ...
	 * @author 
	 */
	public class UIGotoQanpc extends UIHint 
	{
		private var m_iconPanel:Panel;
		public function UIGotoQanpc(mgr:UIHintMgr) 
		{
			super(mgr);
			
		}
		override public function onReady():void 
		{
			super.onReady();
			
			m_timer.reset();
			m_timer.delay = 600000;	//10分钟
			m_timer.start();
			
			m_tf.width = 135;
			m_tf.x = 100;
			
			m_iconPanel = new Panel(this, 20, 28);
		}
		
		public function addDesc():void
		{
			m_iconPanel.setPanelImageSkin("commoncontrol/panel/qasys/qaicon.png");
			var desc:String = m_gkcontext.m_hintMgr.getActFuncDesc(5);
			if (null == desc)
			{
				desc = "活动开始啦 ！！！";
			}
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat(desc);
			this.setText(UtilHtml.getComposedContent());
			m_funBtn.label = "立刻加入";
		}
		
		override protected function onFunBtnClick(event:MouseEvent):void 
		{
			var info:stNotifyAnswerQuestionQuestNpcInfoCmd = m_gkcontext.m_qasysMgr.m_npcInfo;
			gotoFunc(info.m_posx, info.m_posy, info.m_mapid, info.m_npcid);
			exit();
		}
		private function gotoFunc(destX:int, destY:int, mapID:int, npcID:int):void
		{
			var main:PlayerMain = m_gkcontext.m_playerManager.hero;
			if (main == null)
			{
				return;
			}
			
			if (mapID == m_gkcontext.m_mapInfo.m_servermapconfigID)
			{				
				if (npcID)
				{
					main.moveToNpcVisitByNpcID_ServerPos(destX, destY, npcID);
				}
				else
				{
					main.moveToPos_ServerPos(destX, destY);
				}
			}
			else
			{
				if (m_gkcontext.m_cangbaokuMgr.inCangbaoku)
				{
					main.moveToNpcVisitByNpcID_ServerPos(52, 40, 1050);
					main.setAutoWalk(true);
					return;
				}
				if (m_gkcontext.m_mapInfo._xWorldmap == 0)
				{
					m_gkcontext.m_systemPrompt.prompt("在此地图无法自动寻路!");
					return;
				}
				var obj:Object = new Object();
				obj["x"] = destX;
				obj["y"] = destY;
				obj["npcid"] = npcID;
				m_gkcontext.m_contentBuffer.addContent(ContentBuffer.KEY_GOTO, obj);
				m_gkcontext.m_contentBuffer.addContent("uiWorldMap_runToCity", m_gkcontext.m_mapInfo.getCityIDByMapID(mapID));				
				main.moveToNpcVisitByNpcID_ServerPos(m_gkcontext.m_mapInfo._xWorldmap, m_gkcontext.m_mapInfo._yWorldmap, m_gkcontext.m_mapInfo._npcIDSkip);
			}
			main.setAutoWalk(true);
		}
	}

}