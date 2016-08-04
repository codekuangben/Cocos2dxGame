package game.ui.uibenefithall.subcom.regdaily 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ShowRegRewards extends Component
	{
		private var m_gkContext:GkContext;
		private var m_vecProps:Vector.<ObjectPanel>;
		
		public function ShowRegRewards(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			m_vecProps = new Vector.<ObjectPanel>();
		}
		
		public function setDatas(objlist:Vector.<ZObject>, value:uint):void
		{
			var objpanel:ObjectPanel;
			var interval:int = 50;
			var i:int;
			for (i = 0; i < objlist.length; i++)
			{
				objpanel = new ObjectPanel(m_gkContext, this, i * interval, 0);
				objpanel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
				objpanel.autoSizeByImage = false;
				objpanel.setPanelImageSkin(ZObject.IconBg);
				objpanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
				objpanel.addEventListener(MouseEvent.ROLL_OVER, onObjMouseOver);
				objpanel.objectIcon.setZObject(objlist[i]);
				
				m_vecProps[i] = objpanel;
			}
			
			setObjectsBecomeGray(value);
			this.tag = value;
		}
		
		private function onObjMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				pt = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					m_gkContext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
		
		public function setObjectsBecomeGray(v:uint):void
		{
			if (v <= m_gkContext.m_dailyActMgr.m_regCounts)
			{
				this.becomeGray();
			}
		}
	}

}