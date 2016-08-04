package game.ui.uipaoshangsys.bg
{
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uipaoshangsys.DataPaoShang;
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import game.ui.uipaoshangsys.msg.reqRobBusinessUserCmd;
	import modulecommon.appcontrol.menu.UIMenuEx;
	import modulecommon.logicinterface.ISceneUIHandle;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiObject.UIMBeing;
	//import flash.utils.clearInterval;
	//import flash.utils.setInterval;
	
	/**
	 * @author ...
	 */
	public class UIBg extends Form implements ISceneUIHandle
	{
		public var m_DataPaoShang:DataPaoShang;
		public var m_pnlBg:Panel;
		protected var m_lst:Array;		// 列表
		protected var m_curIdx:uint;	// 操作列表中的索引
		//protected var m_time:uint;		// 定时器
		
		public function UIBg()
		{
			this.id = UIFormID.UIBg;
			this.setSize(1920, 1080);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			m_pnlBg = new Panel(this);
			m_pnlBg.setPanelImageSkin("module/paoshang/mapbg.jpg");
		}
		
		override public function dispose():void
		{
			//clearInterval(m_time);
			//m_time = 0;
			m_DataPaoShang.m_gkcontext.m_sceneUILogic.removeHandle();
			super.dispose();
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
		}
		
		override protected function onFormMouseGoDown(event:MouseEvent):void
		{
			
		}
		
		public function onClick(evt:MouseEvent, ret:Array):void
		{
			evt.stopImmediatePropagation();		// 事件不要再传递
			
			m_lst = ret;
			m_curIdx = 0;

			if (ret.length == 1)		// 如果只有一个人，直接弹出操作的菜单
			{
				//popUpOpeMenu();
				if (!m_DataPaoShang.m_markData.isSelf(ret[0]))
				{
					popUpAck();
				}
			}
			else				// 弹出操作的玩家的名单，然后点击后再弹出具体的操作菜单
			{
				popUpMingDanMenu();
			}
		}
		
		public function onMouseEnter(evt:MouseEvent, ret:Array):void
		{
			if (m_DataPaoShang.m_markData.isSelf(ret[0]))		// 自己就不出提示了
			{
				return;
			}
			UtilHtml.beginCompose();
			UtilHtml.add(ret[0].name + " 商队", UtilColor.COLOR2, 14);
			
			var item:BusinessUser = m_DataPaoShang.getBusinessUser(m_DataPaoShang.m_markData.getIDByBeing(ret[0]));
			if (item)
			{
				UtilHtml.breakline();
				UtilHtml.add("货物价值: " + item.sum, UtilColor.COLOR2, 12);
				UtilHtml.breakline();
				UtilHtml.add("抢夺可得: " + item.robValue, UtilColor.COLOR2, 12);
			}
			m_DataPaoShang.m_gkcontext.m_uiTip.hintHtiml(this.stage.mouseX, this.stage.mouseY, UtilHtml.getComposedContent(), 180, true, 8);
		}
		
		public function onMouseLeave(evt:MouseEvent):void
		{
			m_DataPaoShang.m_gkcontext.m_uiTip.hideTip();
		}
		
		// 弹出名单菜单
		protected function popUpMingDanMenu():void
		{
			var menu:UIMenuEx = m_DataPaoShang.m_gkcontext.m_uiMenuEx;
			menu.begin();
			menu.funOnclick = onMenuClkLst;
			
			var idx:uint = 0;
			var uibeing:UIMBeing;
			for each(uibeing in m_lst)
			{
				if (!m_DataPaoShang.m_markData.isSelf(uibeing))		// 自己的 id 是 0 ，这个就不要再加入进去了
				{
					menu.addText(uibeing.name, idx);
				}
				++idx;
			}
			
			var pt:Point = this.globalToLocal(new Point(this.stage.mouseX, this.stage.mouseY));

			menu.setShowPos(pt.x, pt.y, this);
			menu.end();
		}
		
		// 点击菜单的 uibeing 列表
		protected function onMenuClkLst(tag:int):void
		{
			m_curIdx = tag;
			//popUpOpeMenu();
			//m_time = setInterval(onTimer, 20);
			popUpAck();
		}
		
		// 弹出操作菜单
		protected function popUpOpeMenu():void
		{
			var menu:UIMenuEx = m_DataPaoShang.m_gkcontext.m_uiMenuEx;
			menu.begin();
			menu.funOnclick = onMenuClick;

			var enable:Boolean;
			
			var total:uint = 0;
			var caplst:Vector.<String> = new Vector.<String>();
			var typeLst:Vector.<uint> = new Vector.<uint>();
			var enablelst:Vector.<Boolean> = new Vector.<Boolean>();
			var iconlst:Vector.<String> = new Vector.<String>();
			
			caplst.push("抢劫");
			typeLst.push(0);
			enablelst.push(true);
			iconlst.push("talk");
			++total;

			var idx:uint = 0;
			while(idx < total)
			{
				//menu.addIconAndText(iconlst[idx], caplst[idx], typeLst[idx], enablelst[idx]);
				menu.addText(caplst[idx], typeLst[idx]);
				++idx;
			}
			
			var pt:Point = this.globalToLocal(new Point(this.stage.mouseX, this.stage.mouseY));

			menu.setShowPos(pt.x, pt.y, this);
			menu.end();
		}
		
		public function onMenuClick(tag:int):void
		{

		}
		
		protected function onTimer():void
		{
			//clearInterval(m_time);
			//m_time = 0;
			
			popUpOpeMenu();
		}
		
		protected function popUpAck():void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("请问您是要抢劫[" + m_lst[m_curIdx].name + "]的货车吗？", 0xfbdda2, 14);
			var desc:String = UtilHtml.getComposedContent();
			m_DataPaoShang.m_gkcontext.m_confirmDlgMgr.showMode1(this.id, desc, resreshFirFn, null, "确认", "取消");
		}
		
		// 刷新按钮点击确认
		public function resreshFirFn():Boolean
		{
			var cmd:reqRobBusinessUserCmd = new reqRobBusinessUserCmd();
			cmd.id = m_DataPaoShang.m_markData.getIDByBeing(m_lst[m_curIdx]);
			m_DataPaoShang.m_gkcontext.sendMsg(cmd);
			return true;
		}
	}
}