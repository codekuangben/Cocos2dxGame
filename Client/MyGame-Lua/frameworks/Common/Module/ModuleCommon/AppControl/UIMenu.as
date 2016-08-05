package  modulecommon.appcontrol
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.res.ResGrid9;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIMenu extends Form 
	{
		private var m_list:Array;
		private var m_btnPool:Array;
		private var m_numBtnUsed:uint;
		private var m_bLoadImage:Boolean;
		private var m_curSelectCom:Component;
		private var m_xPos:Number;
		private var m_yPos:Number;
		public function UIMenu() 
		{
			m_list = new Array();
			exitMode = EXITMODE_HIDE;			
			this.id = UIFormID.UIMenu;
			this.draggable = false;
			m_bLoadImage = false;
			m_curSelectCom = null;
			m_xPos = 0;
			m_yPos = 0;
		}
		
		public function begin():void
		{
			release();
		}
		public function addButton(title:String, processFun:Function, param:Object = null):void
		{
			var item:MenuItem = new MenuItem(title, processFun, param);
			m_list.push(item);
		}
		override public function onReady():void
		{
			this.m_gkcontext.m_uiMenu = this;
			this.width = 64;
			super.onReady();
		}
		override public function show () : void
		{			
			var i:int = 0;
			var top:int = 6;			
			var btn:ButtonText;
			var text:String;
			for (i = 0; i < m_list.length; i++)
			{
				btn = getBtn();
				btn.y = top;
				btn.tag = i;
				text = (m_list[i] as MenuItem).title;
				
				btn.label = text;
				if (text.length == 4)
				{
					btn.letterSpacing = 0;
				}
				addChild(btn);
				top += btn.height;
			}
			
			this.height = top + 6;			
			
			if (m_bLoadImage == false)
			{
				m_bLoadImage = true;
				this.setSkinGrid9Image9(ResGrid9.StypeThree);
			}
			super.show();
			this.m_gkcontext.m_context.m_mainStage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			onStageReSize();
		}
		
		override public function onStageReSize():void
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
			m_list.length = 0;
			var i:int = 0;
			if (m_btnPool == null)
			{
				return;
			}
			for (i = 0; i < m_btnPool.length && i < m_numBtnUsed; i++)
			{
				this.removeChild(m_btnPool[i] as ButtonText);
			}
			m_numBtnUsed = 0;
		}
		override public function onHide () : void
		{
			this.m_gkcontext.m_context.m_mainStage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			release();
			m_curSelectCom = null;
		}
		protected function getBtn():ButtonText
		{
			if (m_btnPool == null)
			{
				m_btnPool = new Array();
			}
			var btn:ButtonText;
			if (m_numBtnUsed >= m_btnPool.length)
			{
				btn = new ButtonText();
				btn.setSize(52, 23);
				btn.setPanelImageSkin("commoncontrol/button/pagebtn1.swf");
				btn.x = 6;
				btn.addEventListener(MouseEvent.CLICK, onClick);
				m_btnPool.push(btn);
			}
			var old:int = m_numBtnUsed;
			m_numBtnUsed++;
			return m_btnPool[old] as ButtonText;
		}
		protected function onClick(e:MouseEvent):void
		{
			if (e.target is ButtonText)
			{
				var tag:int = (e.target as ButtonText).tag;
				if (tag < m_list.length)
				{
					var item:MenuItem = m_list[tag] as MenuItem;
					if (item && item.processFun != null)
					{
						item.processFun(item.param);
					}
				}
			}
			this.exit();
		}
		
		//xPos、yPos是相对于focusCom的位置
		public function setShowPos(xPos:Number, yPos:Number, focusCom:Component):void
		{
			m_xPos = xPos;
			m_yPos = yPos;
			m_curSelectCom = focusCom;
		}
	}

}