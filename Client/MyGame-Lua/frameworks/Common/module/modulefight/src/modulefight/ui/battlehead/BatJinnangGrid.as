package modulefight.ui.battlehead
{
	import com.bit101.components.Component;
	//import com.bit101.components.Panel;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.JinnangItem;
	import modulecommon.scene.prop.skill.JinnangIcon;
	import modulecommon.scene.prop.skill.SkillMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BatJinnangGrid extends Component
	{		
		private var m_gkContext:GkContext;
		private var m_iconPanel:JinnangIcon;
		private var m_jinnangItem:JinnangItem;
		
		public function BatJinnangGrid(gk:GkContext)
		{
			m_gkContext = gk;
			m_iconPanel = new JinnangIcon(gk);
			this.addChild(m_iconPanel)
			m_iconPanel.x = 3;
			m_iconPanel.y = 3;
			m_iconPanel.setSize(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		public function setJinnang(id:uint, num:uint):void
		{
			m_jinnangItem = new JinnangItem();
			m_jinnangItem.idInit = id;
			m_jinnangItem.num = num;			

			m_iconPanel.setSkillID(m_jinnangItem);
		
		}
		
		public function clear():void
		{
			m_iconPanel.remove();
			this.becomeUnGray();
		}
		
		public function setGray():void
		{
			this.becomeGray();
		}
		
				
		protected function onMouseOut(event:MouseEvent):void
		{
			if (m_jinnangItem == null)
			{
				return;
			}
			m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_jinnangItem == null)
			{
				return;
			}
			var pt:Point = this.localToScreen(new Point(43, 0));
			m_gkContext.m_uiTip.hintSkillInfo(pt, m_jinnangItem.idLevel, 43);
		}
		
		public function get jinnangItem():JinnangItem
		{
			return m_jinnangItem;
		}
	}

}