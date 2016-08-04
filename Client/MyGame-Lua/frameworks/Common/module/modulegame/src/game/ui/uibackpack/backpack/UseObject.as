package game.ui.uibackpack.backpack 
{
	import com.bit101.components.Component;
	import com.dnd.DragManager;
	
	import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.propertyUserCmd.stUseObjectPropertyUserCmd;
	import modulecommon.scene.prop.object.ObjectIcon;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UseObject 
	{
		private static const SHIYONG:String = "使用";
		private static const QUANBUSHIYONG:String = "全部使用";
		private static const YIDONG:String = "移动";
		
		private var m_gkContext:GkContext;
		private var m_backPack:BackPack;
		public var m_pos:Point;		// 保存显示的数字
		
		public function UseObject(gk:GkContext, bp:BackPack) 
		{
			m_gkContext = gk;
			m_backPack = bp;
			m_pos = new Point();
		}
		
		public function objMenu(objIcon:ObjectIcon):Boolean
		{
			
			var obj:ZObject = objIcon.zObject;
			var type:uint = obj.m_ObjectBase.m_iType;
			var objID:uint = obj.m_ObjectBase.m_uID;
			var param:Object = new Object();
			param.obj = obj;
			param.num = 1;
			var paramall:Object = new Object();
			paramall.obj = obj;
			paramall.num = obj.m_object.num;
			if (type == ZObjectDef.ItemType_Yinbi
			|| type == ZObjectDef.ItemType_Jinbi
			|| type == ZObjectDef.ItemType_Yuanbao
			|| type == ZObjectDef.ItemType_Jianghun
			|| type == ZObjectDef.ItemType_Binghun
			|| type == ZObjectDef.ItemType_Junling
			|| type == ZObjectDef.ItemType_BlueShenHun
			|| type == ZObjectDef.ItemType_GreenShenHun
			|| type == ZObjectDef.ItemType_LiBao
			|| type == ZObjectDef.ItemType_SuiJiLiBao
			|| type == ZObjectDef.ItemType_JunLiang
			|| type == ZObjectDef.ItemType_YaoShui
			|| type == ZObjectDef.ItemType_WuNv)
			{
				m_gkContext.m_uiMenu.begin();
				m_gkContext.m_uiMenu.addButton(SHIYONG, senduseCmd, param);
				m_gkContext.m_uiMenu.addButton(QUANBUSHIYONG, senduseCmd, paramall);
				m_gkContext.m_uiMenu.addButton(YIDONG, moveObj, objIcon);
				m_gkContext.m_uiMenu.setShowPos(32, 35, objIcon);
				m_gkContext.m_uiMenu.show();
				return true;
			}
			
			return false;
		}
		private function senduseCmd(param:Object):void
		{
			var send:stUseObjectPropertyUserCmd = new stUseObjectPropertyUserCmd();
			send.thisID = (param.obj as ZObject).m_object.thisID;
			send.num = param.num;
			m_gkContext.sendMsg(send);
			
			// 使用的时候提示
			mouseTip(param.obj, send.num);
			
			// 播放音效
			m_gkContext.m_commonProc.playMsc(56);
		}
		
		private function moveObj(objIcon:ObjectIcon):void
		{
			DragManager.startDrag(objIcon.parent as Component, null, objIcon, m_backPack, true, false);	
			objIcon.onDrag();	
		}
		
		public function directUseObj(obj:ZObject):Boolean
		{
			var type:uint = obj.m_ObjectBase.m_iType;
			var objID:uint = obj.m_ObjectBase.m_uID;
			if (type == ZObjectDef.ItemType_Yinbi
			|| type == ZObjectDef.ItemType_Jinbi
			|| type == ZObjectDef.ItemType_Jianghun
			|| type == ZObjectDef.ItemType_Binghun
			|| type == ZObjectDef.ItemType_Junling
			|| type == ZObjectDef.ItemType_BlueShenHun
			|| type == ZObjectDef.ItemType_GreenShenHun
			|| type == ZObjectDef.ItemType_LiBao
			|| type == ZObjectDef.ItemType_SuiJiLiBao
			|| type == ZObjectDef.ItemType_JunLiang
			|| type == ZObjectDef.ItemType_YaoShui
			|| type == ZObjectDef.ItemType_WuNv)
			{
				var send:stUseObjectPropertyUserCmd = new stUseObjectPropertyUserCmd();
				send.thisID = obj.m_object.thisID;
				send.num = 1;
				m_gkContext.sendMsg(send);
				mouseTip(obj, send.num);
				return true;
			}
			return false;
		}
		
		 // 使用物品的时候给出提示
		public function mouseTip(obj:ZObject, num:uint):void
		{
			var count:uint;
			var bshow:Boolean = false;
			var desc:String;
			var type:uint = obj.m_ObjectBase.m_iType;
			if(ZObjectDef.ItemType_Yinbi == type)
			{
				desc = "银币+ ";
				count = obj.m_ObjectBase.m_iShareData1 * num;
				bshow = true;
			}
			else if(ZObjectDef.ItemType_Jinbi == type)
			{
				desc = "金币+ ";
				count = obj.m_ObjectBase.m_iShareData1 * num;
				bshow = true;
			}
			else if(ZObjectDef.ItemType_Yuanbao == type)
			{
				desc = "元宝+ ";
				count = obj.m_ObjectBase.m_iShareData1 * num;
				bshow = true;
			}
			else if(ZObjectDef.ItemType_GreenShenHun == type)
			{
				desc = "绿色神魂+ ";
				count = num;
				bshow = true;
			}
			else if(ZObjectDef.ItemType_BlueShenHun == type)
			{
				desc = "蓝色神魂+ ";
				count = num;
				bshow = true;
			}
			
			if(bshow)
			{
				desc += count; 	
				m_gkContext.m_systemPrompt.prompt(desc, m_pos);
			}
		}
	}
}