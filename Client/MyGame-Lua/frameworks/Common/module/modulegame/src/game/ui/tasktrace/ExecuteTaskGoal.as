package game.ui.tasktrace
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.CmdParse;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.task.TaskItem;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import modulecommon.commonfuntion.SysNewFeatures;
	import net.ContentBuffer;
	
	import modulecommon.scene.beings.PlayerMain;
	
	/**
	 * ...
	 * @author
	 */
	public class ExecuteTaskGoal
	{
		private var m_gkContext:GkContext;
		
		public function ExecuteTaskGoal(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		public function exec(taskItem:TaskItem):void
		{
			m_gkContext.addLog("ExecuteTaskGoal::exec "+taskItem.m_strGoalItem);
			var xml:XML = new XML(taskItem.m_strGoalItem);
			
			if (xml.@param == undefined)
			{
				return;
			}
			var param:String = xml.@param;
			var parse:CmdParse = new CmdParse();
			parse.parse(param);
			m_gkContext.addInfoInUIChat("goal:" + param);
			var pt:Point;
			if (parse.cmd == "goto")
			{
				var main:PlayerMain = m_gkContext.m_playerManager.hero;
				if (main == null)
				{
					return;
				}
				var destX:int = parse.getIntValue("x");
				var destY:int = parse.getIntValue("y");
				var npcID:int = parse.getIntValue("npcid");
				var mapID:int = parse.getIntValue("mapid");
				var cityIDInWordmap:int = parse.getIntValue("worldmapid");
				gotoFunc(destX,destY,mapID,npcID);				
			}
			else if (parse.cmd == "gotofuben")
			{
				gotofuben(parse);
			}
			else if (parse.cmd == "gotobarrier")
			{
				m_gkContext.m_elitebarrierMgr.reqEnterJBoss();
			}
			else if (parse.cmd == "openformfunc")
			{
				openformfunc(parse);
			}
			else if (parse.cmd == "openheroinfo")
			{
				openHeroInfo(parse);
			}
		}
		
		private function gotofuben(parse:CmdParse):void
		{
			m_gkContext.addInfoInUIChat("执行副本寻路");
			var mapID:int = parse.getIntValue("mapid");
			var pt:Point;
			var main:PlayerMain = m_gkContext.m_playerManager.hero;
			main.clearAutoState();
			if (mapID == m_gkContext.m_mapInfo.m_servermapconfigID)
			{
				m_gkContext.addInfoInUIChat("目标地图就是当前地图");
				var destX:int = parse.getIntValue("x");
				var destY:int = parse.getIntValue("y");
				var npcID:int = parse.getIntValue("npcid");
				
				pt = m_gkContext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(destX, destY));
				if (npcID)
				{
					main.moveToNpcVisitByNpcID(pt.x, pt.y, npcID);
					
				}
				else
				{
					main.moveToPos(new Point(pt.x, pt.y));
				}
				main.setAutoWalk(true);
				return;
			}
			m_gkContext.addInfoInUIChat("目标地图不是当前地图");
			if (m_gkContext.m_mapInfo._xWorldmap == 0)
			{
				var str:String;
				str = "当前地图ID: " + m_gkContext.m_mapInfo.m_servermapconfigID;
				str += "\n目标地图ID: " + mapID;
				m_gkContext.m_uiChat.debugMsg(str);
				m_gkContext.m_systemPrompt.prompt("此地图没有打开世界地图的跳转点");
				return;
			}
			
			m_gkContext.m_contentBuffer.addContent("uiWorldMap_moveToCity", parse.getIntValue("worldmapid"));
			m_gkContext.m_contentBuffer.addContent("uiFuben_runTofuben", parse.getIntValue("copyid"));
			pt = m_gkContext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(m_gkContext.m_mapInfo._xWorldmap, m_gkContext.m_mapInfo._yWorldmap));
			m_gkContext.addInfoInUIChat("世界地图跳转点位置(" + m_gkContext.m_mapInfo._xWorldmap.toString() + "," + m_gkContext.m_mapInfo._yWorldmap + ")");
			main.moveToNpcVisitByNpcID(pt.x, pt.y, m_gkContext.m_mapInfo._npcIDSkip);
			if (main.state == EntityCValue.TRun)
			{
				main.setAutoWalk(true);
			}
			
			m_gkContext.addInfoInUIChat("副本地图寻路完毕");
		}
		
		private function openformfunc(parse:CmdParse):void
		{
			var funcID:int = parse.getIntValue("funcid");
			
			m_gkContext.m_sysnewfeatures.openOneFuncForm(funcID);
		}
		
		public function gotoFunc(destX:int, destY:int, mapID:int, npcID:int):void
		{
			
			var main:PlayerMain = m_gkContext.m_playerManager.hero;
			if (main == null)
			{
				return;
			}
			main.clearAutoState();
			if (mapID == m_gkContext.m_mapInfo.m_servermapconfigID)
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
				if (m_gkContext.m_cangbaokuMgr.inCangbaoku)
				{
					main.moveToNpcVisitByNpcID_ServerPos(52, 40, 1050);
					main.setAutoWalk(true);
					return;
				}
				if (m_gkContext.m_mapInfo._xWorldmap == 0)
				{
					m_gkContext.m_systemPrompt.prompt("在此地图无法自动寻路!");
					return;
				}
				var obj:Object = new Object();
				obj["x"] = destX;
				obj["y"] = destY;
				obj["npcid"] = npcID;
				m_gkContext.m_contentBuffer.addContent(ContentBuffer.KEY_GOTO, obj);
				m_gkContext.m_contentBuffer.addContent("uiWorldMap_runToCity", m_gkContext.m_mapInfo.getCityIDByMapID(mapID));				
				main.moveToNpcVisitByNpcID_ServerPos(m_gkContext.m_mapInfo._xWorldmap, m_gkContext.m_mapInfo._yWorldmap, m_gkContext.m_mapInfo._npcIDSkip);
			}
			main.setAutoWalk(true);
		}
		
		private function openHeroInfo(parse:CmdParse):void
		{
			var heroid:uint = parse.getIntValue("heroid");
			
			var formPack:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIBackPack);
			if (formPack)
			{
				if (false == formPack.isVisible())
				{
					formPack.show();
				}
			}
			else
			{
				m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIBackPack);
			}
			
			if (m_gkContext.m_UIs.backPack && m_gkContext.m_UIs.backPack.isVisible())
			{
				m_gkContext.m_UIs.backPack.switchToHero(heroid);
			}
		}
	}

}