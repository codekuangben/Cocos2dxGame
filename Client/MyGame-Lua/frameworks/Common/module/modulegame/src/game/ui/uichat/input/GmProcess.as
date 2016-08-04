package game.ui.uichat.input
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.bit101.components.List;

	import com.pblabs.engine.entity.EntityCValue;
	import com.util.CmdParse;
	import flash.system.System;
	import flash.text.Font;
	import modulecommon.net.msg.sceneUserCmd.stReqOtherClientDebugInfoCmd;
	import modulecommon.scene.beings.NpcVisit;
	import game.ui.uichat.UIChat;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	//import modulecommon.fun.SceneWordSprite;
	import modulecommon.net.msg.copyUserCmd.stReqAvailableCopyUserCmd;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.saodang.SaodangMgr;
	import modulecommon.scene.task.TaskItem;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIHero;
	import modulecommon.uiinterface.IUINpcDisappearAni;
	import modulecommon.uiinterface.IUIPropmtOne;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.uiinterface.IUIUprightPrompt;
	import com.bit101.components.Component;
	
	import org.ffilmation.engine.core.fScene;
	import common.Context;
	import com.pblabs.engine.debug.Stats;
	import com.pblabs.engine.debug.Logger;
	
	public class GmProcess
	{
		/*[Embed(source="task.xml",mimeType="application/octet-stream")]
		protected var m_asset:Class;*/
		
		private var m_gkContext:GkContext;
		private var m_uiChat:UIChat;
		private var m_dicFun:Dictionary;
		private var m_vec:Vector.<List>;
		
		public function GmProcess(gk:GkContext, ui:UIChat)
		{
			m_uiChat = ui;
			m_vec = new Vector.<List>();
			m_gkContext = gk;
			m_dicFun = new Dictionary();
			m_dicFun["gm"] = openGMTool;
			m_dicFun["changemodel"] = changemodel;
			m_dicFun["addtask"] = addtask;
			m_dicFun["showhp"] = showhp;
			m_dicFun["hidehp"] = hidehp;
			m_dicFun["showfightgrid"] = showfightgrid;
			m_dicFun["showstpt"] = showstpt;
			m_dicFun["newhand"] = newhand;
			m_dicFun["showPrompt"] = showPrompt;
			m_dicFun["showBottomPrompt"] = showBottomPrompt;
			m_dicFun["npcdisppear"] = npcdisppear;
			m_dicFun["showBubble"] = showBubble;
			m_dicFun["sceneword"] = sceneword;
			m_dicFun["unlive"] = unlive;
			m_dicFun["live"] = live;
			m_dicFun["showEffect"] = showEffect;
			m_dicFun["openfuben"] = openfuben;
			m_dicFun["battlelight"] = battlelight;
			m_dicFun["clienttime"] = clienttime;
			m_dicFun["uiedit"] = uiedit;
			m_dicFun["loadform"] = loadform;
			m_dicFun["unloadform"] = unloadform;
			m_dicFun["herovel"] = changeHeroVel;
			m_dicFun["testSome"] = testSome;
			m_dicFun["saodang"] = testSaoDao;
			m_dicFun["printlog"] = printlog;
			m_dicFun["execcode"] = execcode;
			m_dicFun["checkformimage"] = checkformimage;
			m_dicFun["showpf"] = showpf;
			m_dicFun["log"] = blog;	// 开启日至功能
			m_dicFun["gc"] = gc;
			m_dicFun["enumerateFonts"] = enumerateFonts;
		}
		
		public function execute(param:String):Boolean
		{
			if (param.substr(0, 2) != "//")
			{
				return false;
			}
			
			var content:String = param.substr(2);
			var parseCmd:CmdParse = new CmdParse();
			parseCmd.parse(content);
			
			if (m_dicFun[parseCmd.cmd] != undefined)
			{
				m_dicFun[parseCmd.cmd](parseCmd);
				return true;
			}
			return false;
		}
		
		protected function openGMTool(parse:CmdParse):void
		{
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIGmPlayerAttributes);
		}
		
		protected function changemodel(parse:CmdParse):void
		{
			var modelid:String = parse.getValue("id");
			if (modelid)
			{
				if (this.m_gkContext.m_playerManager.hero)
				{
					this.m_gkContext.m_playerManager.hero.changeShow(modelid);
				}
			}
		}
		
		protected function addtask(parse:CmdParse):void
		{
			/*var byteDataXml:ByteArray = new m_asset();
			var info:String = byteDataXml.readUTFBytes(byteDataXml.bytesAvailable);
			
			var task:TaskItem = new TaskItem();
			task.m_ID = parse.getIntValue("id");
			task.m_strName = parse.getValue("name");
			task.parseInfo(info);
			m_gkContext.m_taskMgr.test(task);*/
		}
		
		protected function showhp(parse:CmdParse):void
		{
			this.m_gkContext.m_context.m_config.m_bShowShiQiHp = true;
		}
		
		protected function hidehp(parse:CmdParse):void
		{
			this.m_gkContext.m_context.m_config.m_bShowShiQiHp = false;
		}
		
		protected function showfightgrid(parse:CmdParse):void
		{
			var value:String = parse.getValue("value");
			if (value)
			{
				// 隐藏
				if (value == "0")
				{
					//if(this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT))
					//{
					//this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).clearFightGrid();
					//}
					
					this.m_gkContext.m_context.m_config.m_bShowFightGrid = false;
				}
				else // 显示
				{
//					if(this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT))
//					{
//						var m_centerXGrid:uint = this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).widthpx()/2;
//						var m_centerYGrid:uint = 385;
//						var m_gridWidth:uint = 140;
//						var m_gridHeight:uint = 140;
//						var m_offXGrid:uint = m_gridWidth/2;
//						var m_offYGrid:uint = m_gridHeight + m_gridHeight/2;
//						
//						var startPt:Point = new Point();
//						var gridsize:Point = new Point();
//						startPt.x = m_centerXGrid - m_offXGrid - 3 * m_gridWidth;
//						startPt.y = m_centerYGrid;
//						
//						gridsize.x = m_gridWidth;
//						gridsize.y = m_gridHeight;
//						
//						this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).drawFightGrid(startPt, gridsize);
//					}
					
					this.m_gkContext.m_context.m_config.m_bShowFightGrid = true;
				}
			}
		}
		
		protected function showstpt(parse:CmdParse):void
		{
			var value:String = parse.getValue("value");
			if (value == "1")
			{
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCGAME).m_sceneConfig.isDebugStopPoint = true;
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCGAME).drawStopPt();
			}
			else
			{
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCGAME).m_sceneConfig.isDebugStopPoint = false;
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCGAME).clearStopPt();
			}
		}
		
		protected function newhand(parse:CmdParse):void
		{
			if (parse.getIntValue("fly") == 1)
			{
				this.m_gkContext.m_newhandFun.flyTo(new Point(parse.getIntValue("x"), parse.getIntValue("y")), parse.getIntValue("rotation"));
			}
			else
			{
				this.m_gkContext.m_newhandFun.moveTo(new Point(parse.getIntValue("x"), parse.getIntValue("y")), parse.getIntValue("rotation"));
			}
		}
		
		protected function showPrompt(parse:CmdParse):void
		{
		
		/*var str:String = parse.getValue("content");
		
		   var iui:IUIUprightPrompt = m_gkContext.m_UIMgr.getForm(UIFormID.UIUprightPrompt) as IUIUprightPrompt;
		   if (iui)
		   {
		   iui.showPrompt(str);
		   }
		   else
		   {
		   m_gkContext.m_contentBuffer.addContent("UIUprightPrompt_prompt", str);
		   m_gkContext.m_UIMgr.loadForm(UIFormID.UIUprightPrompt);
		 }*/
		
			//m_gkContext.m_newHandMgr.prompt(parse.getIntValue("right") == 1?true:false, parse.getIntValue("xPos"),parse.getIntValue("yPos"),parse.getValue("text"));
		}
		
		protected function showBottomPrompt(parse:CmdParse):void
		{
			var time:Number = 1500;
			var content:String = "问题在于两人忘情激吻时，$忘记了拉上窗帘。";
			var iui:IUIPropmtOne = m_gkContext.m_UIMgr.getForm(UIFormID.UIPropmtOne) as IUIPropmtOne;
			if (iui)
			{
				iui.showPrompt(content, time);
			}
			else
			{
				var obj:Object = new Object();
				obj["content"] = content;
				obj["delay"] = time;
				
				m_gkContext.m_contentBuffer.addContent("UIPropmtOne_prompt", obj);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIPropmtOne);
			}
		}
		
		protected function npcdisppear(parse:CmdParse):void
		{
			var tempID:uint = parse.getIntValue("id");
			var iui:IUINpcDisappearAni = m_gkContext.m_UIMgr.getForm(UIFormID.UINpcDisappearAni) as IUINpcDisappearAni;
			if (iui)
			{
				iui.BeginAni(tempID);
			}
			else
			{
				
				m_gkContext.m_contentBuffer.addContent("uiNpcDisappearAni_tempid", tempID);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UINpcDisappearAni);
			}
		}
		
		protected function showBubble(parse:CmdParse):void
		{
			
			var content:String = parse.getValue("content");
			
			(m_gkContext.m_playerManager.hero as Player).setBubble(content);
		
		}
		
		protected function sceneword(parse:CmdParse):void
		{
			
			/*var content:String = parse.getValue("content");
			
			   var sw:SceneWordSprite = new SceneWordSprite();
			   var hero:Player = (m_gkContext.m_playerManager.hero as Player);
			
			   var str:String = "<b>";
			   str += UtilHtml.formatFontWithName("金币", 0xEDE90C, 26, "STLITI");
			   str += UtilHtml.formatFontWithName(" +10 0 ", 0xBA4069, 26, "STLITI");
			   str += "</b>";
			
			   m_gkContext.m_context.m_sceneView.scene().sceneLayer(fScene.SLEffect).addChild(sw);
			   sw.setHtml(str);
			   //sw.setText();
			   sw.setPos(hero.x, hero.y - hero.getTagHeight() - 30);
			 sw.begin();	*/
			
			this.m_gkContext.m_systemPrompt.prompt(parse.getValue("v"));
		
		}
		
		protected function unlive(parse:CmdParse):void
		{
			m_gkContext.m_UIMgr.destroyForm(UIFormID.UIHero);
		}
		
		protected function live(parse:CmdParse):void
		{
			//m_gkContext.m_UIMgr.loadForm(UIFormID.UIHero);
			var formHero:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIHero);
			formHero.show();
		}
		
		protected function loadform(parse:CmdParse):void
		{
			var name:String = parse.getValue("name");
			m_gkContext.m_UIMgr.loadForm(UIFormID[name]);		
			
		}
		
		protected function unloadform(parse:CmdParse):void
		{
			var name:String = parse.getValue("name");
			m_gkContext.m_UIMgr.destroyForm(UIFormID[name]);
		}
		
		protected function showEffect(parse:CmdParse):void
		{
			var hero:Player = (m_gkContext.m_playerManager.hero as Player);
			hero.addLinkEffect("e3_e4010", 5, false);
			hero.addLinkEffect("e3_e401", 5, false);
		}
		
		protected function openfuben(parse:CmdParse):void
		{
			//m_gkContext.m_UIMgr.loadForm(UIFormID.UICangbaoku);			
		}
		
		protected function battlelight(parse:CmdParse):void
		{
			this.m_gkContext.m_battleLight = parse.getIntValue("r") / 100;
		}
		
		protected function clienttime(parse:CmdParse):void
		{
			var str:String = "系统时间(client): ";
			str += m_gkContext.m_context.m_timeMgr.dataString;
			m_uiChat.appendMsg(str);
		}
		
		protected function uiedit(parse:CmdParse):void
		{
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIEdit);
		}
		
		protected function changeHeroVel(parse:CmdParse):void
		{
			var str:String = parse.getValue("value");
			var value:int = int(str);
			if (value >= 0)
			{
				if (this.m_gkContext.m_playerManager.hero)
				{
					this.m_gkContext.m_playerManager.hero.vel = value;
				}
			}
		}
		
		protected function testSome(parse:CmdParse):void
		{
			var param:Object = new Object();
					param["funtype"] = "jianghun";						
					param["num"] = 151;
					m_gkContext.m_hintMgr.addToUIZhanliAddAni(param);
		
		}
		
		protected function testSaoDao(parse:CmdParse):void
		{
			m_gkContext.m_saodangMgr.setData(SaodangMgr.DAN_REN_FU_BEN, "常山小道", 4, 200);
			var ui:IUIScreenBtn = m_gkContext.m_UIs.screenBtn;
			if (ui == null)
			{
				return;
			}
			ui.addBtnByID(ScreenBtnMgr.Btn_SaoDang);
		
		}
		
		/* //printlog type=0 name=ewe charid=
		 */
		protected function printlog(parse:CmdParse):void
		{
			var type:int = parse.getIntValue("type");
			var name:String = parse.getValue("name");
			var charid:int = parse.getIntValue("charid");
			
			if (type == 0)
			{
				if (name == null && charid == 0)
				{
					var iFormGM:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIGmPlayerAttributes);
					if (iFormGM)
					{
						var param:Object = new Object();
						param["type"] = 1;
						param["log"] = m_gkContext.m_context.m_logContent;
						iFormGM.updateData(param);
					}
				}
				else
				{
					var reqlog:stReqOtherClientDebugInfoCmd = new stReqOtherClientDebugInfoCmd();
					reqlog.dstcharid = charid;
					if (name && name != "英雄")
					{
						reqlog.dstusername = name;
					}
					
					reqlog.srccharid = m_gkContext.playerMain.charID;
					reqlog.type = 0;
					m_gkContext.sendMsg(reqlog);
				}
			}
		
		}
		
		//显示性能界面
		protected function showpf(parse:CmdParse):void
		{
			if (parse.getIntValue("open") == 0)
			{
				if(m_gkContext.m_context.m_stats)
				{
					m_gkContext.m_context.getLay(Context.TLayDebug).removeChild(m_gkContext.m_context.m_stats);
					m_gkContext.m_context.m_stats = null;
				}
				m_gkContext.m_uiChat.appendMsg("关闭性能界面");
			}
			else
			{
				if(!m_gkContext.m_context.m_stats)
				{
					m_gkContext.m_context.m_stats = new Stats();
				}
				// 设置版本显示 
				m_gkContext.m_context.m_stats.key2value("client", m_gkContext.m_context.m_config.m_version);
				m_gkContext.m_context.getLay(Context.TLayDebug).addChild(m_gkContext.m_context.m_stats);
				m_gkContext.m_uiChat.appendMsg("打开性能界面");
			}
			
		}
		/*
		//execcode swf=debug2 charid=30036574
		*/
		protected function execcode(parse:CmdParse):void
		{
			var swf:String = parse.getValue("swf");
			var name:String = parse.getValue("name");
			var charid:int = parse.getIntValue("charid");
			
			if (name == null && charid == 0)
			{
				m_gkContext.m_UIMgr.destroyForm(UIFormID.UIDebug);
				m_gkContext.m_UIPath.setPath(UIFormID.UIDebug, swf);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIDebug);
			}
			else
			{
				var reqlog:stReqOtherClientDebugInfoCmd = new stReqOtherClientDebugInfoCmd();
				reqlog.dstcharid = charid;
				if (name && name != "英雄")
				{
					reqlog.dstusername = name;
				}
				
				reqlog.srccharid = m_gkContext.playerMain.charID;
				reqlog.type = stReqOtherClientDebugInfoCmd.TYPE_execCode;
				reqlog.text = swf;
				m_gkContext.sendMsg(reqlog);
			}
		}
		protected function checkformimage(parse:CmdParse):void
		{
			var str:String;
			var name:String = parse.getValue("name");
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID[name]);
			if (form == null)
			{
				str = "没有这个form";
			}
			else
			{
				var com:Component = form.getFirstImagesNameNotLoaded();
				if (com)
				{
					str += com.toString() +"--" + com.imageName;
				}
				else
				{
					str += "没有发现未加载的资源"
				}
			}
			
			m_gkContext.m_uiChat.appendMsg(str);
			
			
		}
		
		protected function blog(parse:CmdParse):void
		{
			var blog:int = parse.getIntValue("value");
			if(blog == 1)
			{
				//Logger.m_bLog = true;
			}
			else
			{
				//Logger.m_bLog = false;
			}
		}
		protected function gc(parse:CmdParse):void
		{			
			System.gc();
			m_gkContext.m_uiChat.appendMsg("执行垃圾回收");
		}
		protected function enumerateFonts(parse:CmdParse):void
		{
			var list:Array = Font.enumerateFonts(true);
			var font:Font;
			var str:String="";
			for each(font in list)
			{
				str += font.fontName + "   类型" + font.fontStyle + "\n";
			}
			
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIGmPlayerAttributes);
			if (form)
			{
				form.updateData(str);
			}
		}
	}
}