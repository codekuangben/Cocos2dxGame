package game.ui.tasktrace.yugaogongneng 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.CmdParse;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 预告内容显示
	 */
	public class YugaoItem extends Component
	{
		private var m_gkContext:GkContext;
		private var m_datas:YugaoData;
		private var m_curID:int;
		private var m_curYugao:GongnengItem;
		private var m_iconPanel:Panel;
		private var m_typePanel:Panel;
		private var m_briefLabel:Label;
		private var m_digit:DigitComponent;
		private var m_tip:YugaoTip;
		
		public function YugaoItem(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			this.setSize(224,79);
			this.setPanelImageSkin("commoncontrol/panel/task/yugaobg.png");
			
			m_datas = new YugaoData(m_gkContext, this);
			
			m_iconPanel = new Panel(this, 4,-3);
			m_iconPanel.addEventListener(MouseEvent.MOUSE_OVER, onIconPanelMouseEnter);
			m_iconPanel.addEventListener(MouseEvent.MOUSE_OUT, onIconPanelMouseLeave);
			
			m_typePanel = new Panel(this, 80, 11);
			
			m_briefLabel = new Label(this, 50, 50);
			m_briefLabel.setFontColor(UtilColor.WHITE_Yellow);
			
			m_digit = new DigitComponent(m_gkContext.m_context, this, m_typePanel.x+50, m_typePanel.y-3);
			m_digit.setParam("commoncontrol/digit/digit02", 16, 25);
		}
		
		private function onIconPanelMouseEnter(e:MouseEvent):void
		{			
			if (m_tip == null)
			{
				m_tip = new YugaoTip();				
			}
			if (m_curYugao == null)
			{
				return;
			}
			m_tip.showTip(m_curYugao);
			var pt:Point = this.localToScreen();
			pt.x -= m_tip.width;
			m_gkContext.m_uiTip.hintComponent(pt, m_tip);
			
			var dic:Dictionary = new Dictionary();
			dic[EntityCValue.colorsb] = 0xFF0000;
			m_iconPanel.filtersAttr(true, dic);
		}
		
		private function onIconPanelMouseLeave(e:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_iconPanel.filtersAttr(false);
		}
		
		public function setYugao(id:int, bOpen:Boolean):void
		{
			if (bOpen)
			{
				setID(id);
			}
			else
			{
				closeID(id);
			}
		}
		
		private function setID(id:int):void
		{
			if (m_curID == id)
			{
				return;
			}
			if (m_curID != -1)
			{
				closeID(m_curID);
			}
			m_curID = id;
			if (m_datas.isLoaded)
			{
				updateDisplay();
			}
			else
			{
				m_datas.loadXML();
			}
		}
		
		private function closeID(id:int):void
		{
			if (m_curID != id)
			{
				return;
			}
			m_curID = -1;
			updateDisplay();
		}
		
		public function updateDisplay():void
		{
			if (m_curID == -1)
			{
				this.visible = false;
				return;
			}
			m_curYugao = m_datas.getGongnengItem(m_curID);
			if (m_curYugao == null)
			{
				this.visible = false;
				return;
			}
			
			m_iconPanel.setPanelImageSkin(m_curYugao.m_iconpath);
			
			var cmd:CmdParse = new CmdParse();
			cmd.parse(m_curYugao.m_condition);
			
			var str:String;
			var digthPos:Number;
			if (cmd.getIntValue("type") == 1)
			{
				str = "commoncontrol/panel/task/condition_task.png"
				digthPos = 144;
			}
			else
			{
				str = "commoncontrol/panel/task/conditon_level.png"
				digthPos = 182;
			}
			m_typePanel.setPanelImageSkin(str);
			m_digit.digit = cmd.getIntValue("value");
			m_digit.x = digthPos - m_digit.width/2;
			m_briefLabel.htmlText = m_curYugao.m_briefdesc;
			m_briefLabel.flush();
			m_briefLabel.x = this.width - m_briefLabel.width - 15;
			
			this.visible = true;
		}
		
		override public function dispose():void 
		{
			m_datas.dispose();
			if (m_tip)
			{
				m_tip.disposeEx();
				m_tip = null;
			}
			
			super.dispose();
		}
	}

}