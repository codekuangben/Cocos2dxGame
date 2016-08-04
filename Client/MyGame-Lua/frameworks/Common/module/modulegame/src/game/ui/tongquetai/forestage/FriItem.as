package game.ui.tongquetai.forestage 
{
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.tongquetai.msg.FriendWuNvState;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.relation.stUBaseInfo;
	import game.ui.tongquetai.msg.stReqFriendWuNvDancingUserCmd;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author ...
	 */
	public class FriItem extends CtrolComponent 
	{
		private var m_gkContext:GkContext;
		private var m_friendData:FriendWuNvState;		
		private var m_name:Label;
		private var m_sign:Panel;
		private var m_selectbg:PanelDisposeEx;
		private var m_overbg:PanelDisposeEx;
		private var m_parent:FriList;
		public function FriItem(param:Object=null) 
		{
			buttonMode = true;
			m_selectbg = param.selectbg as PanelDisposeEx;
			m_overbg=param.overbg as PanelDisposeEx
			m_parent = param.parent as FriList;
			m_gkContext = param.gk as GkContext;
			m_name = new Label(this,15,6);
			m_sign = new Panel(this, 127,6);
			setSize(170, 30);
			drawRectBG();
		}
		override public function init():void 
		{
			super.init();
			m_name.text = m_gkContext.m_beingProp.m_rela.m_relFnd.getFriendNameByCharID((data as FriendWuNvState).id);
			updataState(data);
		}
		override public function setData(data:Object):void 
		{
			super.setData(data);
		}
		private function setState():void		
		{
			var state:int = m_friendData.state;
			if ( state == 0)
			{
				m_sign.visible=false;
			}
			else if (state == 1)
			{
				m_sign.visible = true;
				m_sign.setPanelImageSkin("commoncontrol/panel/tongquetai/state.png");
			}
			else
			{
				m_sign.visible = true;
				m_sign.setPanelImageSkin("commoncontrol/panel/tongquetai/haoganbtn.png");
			}
		}
		public static function s_compare(data:Object, param:Object):Boolean
		{
			if ((data as FriendWuNvState).id == param)
			{
				return true;
			}
			return false;
		}
		override public function onSelected():void 
		{
			super.onSelected();
			/*if (m_parent.m_curhaoyou == m_friendData.id)
			{
				return;
			}*/
			m_selectbg.show(this);
			m_parent.m_curhaoyou = m_friendData.id
			var send:stReqFriendWuNvDancingUserCmd = new stReqFriendWuNvDancingUserCmd();
			send.m_id = m_friendData.id;
			m_gkContext.sendMsg(send);		
		}
		override public function onOver():void 
		{
			super.onOver();
			if (select)
			{
				return;
			}
			m_overbg.show(this);
		}
		override public function onOut():void 
		{
			super.onOut();
			if (select)
			{
				return;
			}
			m_overbg.hide(this);
		}
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			m_selectbg.hide(this);
		}
		public function updataState(data:Object):void
		{
			m_friendData = data as FriendWuNvState;	
			setState();
		}
	}

}