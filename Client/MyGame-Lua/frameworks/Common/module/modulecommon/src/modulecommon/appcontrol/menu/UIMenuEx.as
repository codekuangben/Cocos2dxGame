package modulecommon.appcontrol.menu 
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.Component;
	//import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.res.ResGrid9;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIMenuEx extends Form 
	{	
		public static var WIDTH:int = 140;
		public static var WIDTH_Control:int = WIDTH - 14;
		public static const HEIGHT_Control:int = 25;
		
		private var m_bLoadImage:Boolean;
		private var m_curSelectCom:Component;
		private var m_xPos:Number;
		private var m_yPos:Number;
		private var m_ignoreMouseDownOnce:Boolean=false;
		
		private var m_curTop:Number;
		private var m_list:Array;
		private var m_marginLeft:Number = 7;
		private var m_funOnclick:Function; //public function onMenuClick(tag:int):void
		private var m_mouseOverPanel:PanelDisposeEx;
		private var m_MenuItemIconAndTextlist:Vector.<MenuItemIconAndText>;
		public var m_tempData:Object;
		
		public function UIMenuEx() 
		{
			m_list = new Array();
			exitMode = EXITMODE_HIDE;			
			this.id = UIFormID.UIMenuEx;
			this.draggable = false;
			m_bLoadImage = false;
			m_curSelectCom = null;
			m_xPos = 0;
			m_yPos = 0;	
			
			m_MenuItemIconAndTextlist = new Vector.<MenuItemIconAndText>();
		}
		
		public function begin(w:int=140):void
		{
			WIDTH = w;
			WIDTH_Control = WIDTH - 14;
			release();
		}
		
		public function end(ignoreMouseDownOnce:Boolean=false):void
		{
			m_ignoreMouseDownOnce = ignoreMouseDownOnce;
			this.width = WIDTH;
			this.height = m_curTop + 5;
			show();
		}
		
		public function addSegmentLine():void
		{
			var com:MenuItemSegmentLine = new MenuItemSegmentLine(this, m_marginLeft, m_curTop);
			m_list.push(com);
			m_curTop += 10;
			
		}
		
		public function addStaticText(str:String):void
		{
			var com:MenuItemTextArea = new MenuItemTextArea(this, m_marginLeft, m_curTop);
			com.htmlText = str;
			m_list.push(com);
			m_curTop += com.height;
		}
		
		public function addIconAndText(iconName:String, text:String, tag:int, enable:Boolean = true):void
		{
			var name:String = "commoncontrol/menuicon/" + iconName + ".png";
			var com:MenuItemIconAndText = getMenuItemIconAndText(name);
			if (com.parent == null)
			{
				this.addChild(com);
			}
			com.y = m_curTop;
			com.m_text.text = text;
			com.tag = tag;
			com.m_mousePanel = mousePanel;
			com.enabled = enable;
			com.buttonMode = enable;
			com.setSize(UIMenuEx.WIDTH_Control,UIMenuEx.HEIGHT_Control);
			
			
			m_list.push(com);
			m_curTop += com.height;
		}
		private function getMenuItemIconAndText(name:String):MenuItemIconAndText
		{
			if (m_MenuItemIconAndTextlist.length > 0)
			{
				var i:int;
				var item:MenuItemIconAndText;
				for (i = 0; i < m_MenuItemIconAndTextlist.length; i++)
				{
					item = m_MenuItemIconAndTextlist[i];
					if (item.m_icon.imageName == name)
					{
						m_MenuItemIconAndTextlist.splice(i, 1);
						return item;
					}
				}				
			}
			item = new MenuItemIconAndText(this, m_marginLeft, m_curTop);
			item.m_icon.setPanelImageSkin(name);
			return item;			
		}
		
		private function collectMenuItemIconAndText(item:MenuItemIconAndText):void
		{
			m_MenuItemIconAndTextlist.push(item);
		}
		
		// 这个是添加一个没有图标的菜单项
		public function addText(text:String, tag:int, enable:Boolean = true):void
		{
			var com:MenuItemText = new MenuItemText(this, m_marginLeft, m_curTop);
			com.m_text.text = text;
			com.tag = tag;
			com.m_mousePanel = mousePanel;
			com.enabled = enable;
			com.buttonMode = enable;			
			com.setSize(UIMenuEx.WIDTH_Control,UIMenuEx.HEIGHT_Control);
			m_list.push(com);
			m_curTop += com.height;
		}
		
		protected function onClick(e:MouseEvent):void
		{
			if (e.target is MenuItemIconAndText)
			{
				if (m_funOnclick != null)
				{
					m_funOnclick((e.target as MenuItemIconAndText).tag)
				}
				this.exit();
			}
			else if(e.target is MenuItemText)
			{
				if (m_funOnclick != null)
				{
					m_funOnclick((e.target as MenuItemText).tag)
				}
				this.exit();
			}
		}
		override public function onReady():void
		{
			this.m_gkcontext.m_uiMenuEx = this;			
			this.addEventListener(MouseEvent.CLICK, onClick);
			super.onReady();
		}
		override public function show () : void
		{
			if (m_bLoadImage == false)
			{
				m_bLoadImage = true;
				this.setSkinGrid9Image9(ResGrid9.StypeThree);
			}
			super.show();
			this.m_gkcontext.m_context.m_mainStage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			resetPos();
		}
		
		override public function onStageReSize():void
		{
			resetPos();
		}
		
		public function resetPos():void
		{
			if (m_curSelectCom)
			{
				var pos:Point = m_curSelectCom.localToScreen(new Point(m_xPos, m_yPos));
				this.x = pos.x;
				this.y = pos.y;
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
			if (m_ignoreMouseDownOnce)
			{
				m_ignoreMouseDownOnce = false;
				return;
			}
			var dc:DisplayObjectContainer = e.target as DisplayObjectContainer;
			if (dc != null)
			{
				if (dc == this || this.contains(dc))
				{
					return;
				}
			}
			this.exit();
		}
		private function release():void
		{
			m_curTop = 5;		
			var item:MenuItemBase;
			for each(item in m_list)
			{				
				if (item.parent != null)
				{
					item.parent.removeChild(item);
					
					if (item is MenuItemIconAndText)
					{
						collectMenuItemIconAndText(item as MenuItemIconAndText);
					}
					else
					{
						item.dispose();
					}
				}
			}
			m_list.length = 0;
			m_funOnclick = null;
			m_ignoreMouseDownOnce = false;
		}
		override public function onHide () : void
		{
			this.m_gkcontext.m_context.m_mainStage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			release();
			m_curSelectCom = null;
			m_tempData = null;
		}		
		
		//xPos、yPos是相对于focusCom的位置
		public function setShowPos(xPos:Number, yPos:Number, focusCom:Component):void
		{
			m_xPos = xPos;
			m_yPos = yPos;
			m_curSelectCom = focusCom;
		}
		public function set funOnclick(fun:Function):void
		{
			m_funOnclick = fun;
		}
		
		public function get mousePanel():PanelDisposeEx
		{
			if (m_mouseOverPanel == null)
			{
				m_mouseOverPanel = new PanelDisposeEx();				
				m_mouseOverPanel.mouseEnabled = false;
				m_mouseOverPanel.autoSizeByImage = false;
				m_mouseOverPanel.setPanelImageSkin("commoncontrol/panel/mouseover.png");
			}
			m_mouseOverPanel.setSize(WIDTH_Control, HEIGHT_Control);
			return m_mouseOverPanel;
		}
	}

}