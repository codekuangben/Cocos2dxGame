package modulecommon.scene.prop.object 
{
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ObjectPanel extends PanelContainer 
	{
		protected var m_gkContext:GkContext;
		protected var m_ObjectIcon:ObjectIcon;
		protected var m_location:stObjLocation;		//取值为stObjLocation.OBJECTCELLTYPE_COMMON1		
		protected var m_colorBack:ObjectColorBack;
		public var data:Object;
		private var m_showFrame:Boolean = true;
		private var m_showObjectTip:Boolean = false;
		private var m_showColorBack:Boolean = true;		//道具颜色框背景是否显示
		private var m_showColorAniType:int;				//道具品质特效是否显示 0-无特效 1-环绕 2-内光 3-小光
		private var m_frameMouseOverOffsetX:Number = -4;
		private var m_frameMouseOverOffsetY:Number = -4;
		
		public function ObjectPanel(gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			m_ObjectIcon = new ObjectIcon(gk);
			m_ObjectIcon.x = 3;
			m_ObjectIcon.y = 3;
			m_ObjectIcon.mouseEnabled = false;
			
			m_location = new stObjLocation();
			this.setDropTrigger(true);
			this.addChild(m_ObjectIcon);
			
			m_colorBack = new ObjectColorBack(m_gkContext, this, m_frameMouseOverOffsetX + 5, m_frameMouseOverOffsetY + 5);
			m_colorBack.mouseEnabled = false;
			
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		override public function draw():void
		{
			super.draw();
			this.graphics.beginFill(0x90301, 0.0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}	
		protected function onMouseOut(event:MouseEvent):void
		{
			if (m_showFrame)
			{
				m_gkContext.m_objMgr.hideObjectMouseOverPanel(this);
			}
			if (m_showObjectTip)
			{
				m_gkContext.m_uiTip.hideTip();
			}
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_showFrame)
			{
				m_gkContext.m_objMgr.showObjectMouseOverPanel(this,m_frameMouseOverOffsetX,m_frameMouseOverOffsetY);
			}
			if (m_showObjectTip)
			{				
				var pt:Point = this.localToScreen();
				
				var obj:ZObject = objectIcon.zObject;
				if (obj != null)
				{					
					m_gkContext.m_uiTip.hintObjectInfo(pt, obj, 0);
				}
			}
			
		}
		
		public function freshIcon():void
		{
			m_ObjectIcon.freshIcon();
			
			if (m_ObjectIcon.zObject)
			{
				showIconColorBack(m_ObjectIcon.zObject.iconColor);
			}
		}
		
		public function set gridX(_x:int):void
		{
			m_location.x = _x;
		}
		public function set gridY(_y:int):void
		{
			m_location.y = _y;
		}
		
		public function get gridX():int
		{
			return m_location.x;
		}
		public function get gridY():int
		{
			return m_location.y;
		}
		
		public function get objLocation():stObjLocation
		{
			return m_location;
		}
		
		public function get objectIcon():ObjectIcon
		{
			return m_ObjectIcon;
		}
		public function get thisID():uint
		{
			if (m_ObjectIcon.zObject != null)
			{
				return m_ObjectIcon.zObject.thisID;
			}
			return 0;
		}
		
		public function setFrameMouseOverOffset(posX:Number, posY:Number):void
		{
			m_frameMouseOverOffsetX = posX;
			m_frameMouseOverOffsetY = posY;
			m_colorBack.setPos(m_frameMouseOverOffsetX + 5, m_frameMouseOverOffsetY + 5);
		}
		public function set showFrame(b:Boolean):void
		{
			m_showFrame = b;
		}
		public function set showObjectTip(b:Boolean):void
		{
			m_showObjectTip = b;
		}
		public function set showColorBack(b:Boolean):void
		{
			m_showColorBack = b;
		}
		public function set showColorAniType(type:int):void
		{
			m_showColorAniType = type;
		}
		
		public function showIconColorBack(iconcolor:int):void
		{
			if (m_showColorBack)
			{
				m_colorBack.setIconBack(iconcolor);
			}
			if (m_showColorAniType)
			{
				m_colorBack.setColorAni(iconcolor, m_showColorAniType);
			}
		}
		public function hideIconColorBack():void
		{
			if (m_showColorBack)
			{
				m_colorBack.hide();
			}
		}
		
	}

}