package game.ui.treasurehunt 
{
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.treasurehunt.treasureInfo;
	
	/**
	 * ...
	 * @author ...
	 */
	public class midPartItemIcon extends CtrolComponentBase 
	{
		private var m_icon:Panel;
		private var m_treasureInfo:treasureInfo;
		private var m_gkcontext:GkContext;
		public function midPartItemIcon(param:Object=null) 
		{
			super(param);
			m_gkcontext = param.gk;
			m_icon = new Panel(this, 0, 0);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
			addEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
		}
		override public function setData(data:Object):void 
		{
			super.setData(data);
			m_treasureInfo = data as treasureInfo;
			m_icon.setPanelImageSkin("treasurehunting/"+m_treasureInfo.m_icon+".png")
		}
		private function onMouseEnter(e:MouseEvent):void
		{
			var str:String = m_treasureInfo.m_desc;
			var pt:Point = localToScreen();
			pt.x += 67;
			m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str);
		}
		override public function dispose():void 
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
			removeEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
			super.dispose();
		}
	}

}