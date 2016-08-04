package game.ui.tasktrace.yugaogongneng 
{
	import com.ani.AniPosition;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelShowAndHide;
	import com.bit101.components.PushButton;
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
	 * 新功能预告
	 */
	public class YugaoPanel extends PanelShowAndHide 
	{
		private var m_gkContext:GkContext;
		private var m_yugaoItem:YugaoItem;
		private var m_yubaoBtn:PushButton;
		private var m_ani:AniPosition;
		private var m_bShow:Boolean;	//展开、收起
		
		public function YugaoPanel(gk:GkContext, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			m_gkContext = gk;
			super(parent, xpos, ypos);
			
			m_yugaoItem = new YugaoItem(m_gkContext, this, 0, 28);
			
			m_yubaoBtn = new PushButton(this, 0, 0, onYuGaoBtnClick);
			m_yubaoBtn.setSize(34, 134);
			m_yubaoBtn.recycleSkins = true;
			m_yubaoBtn.setSkinButton1Image("commoncontrol/panel/task/yugaoBtn_show.png");
			m_yubaoBtn.beginLiuguang();
			
			m_ani = new AniPosition();
			m_ani.sprite = m_yugaoItem;
			m_ani.duration = 0.5;
		}
		
		public function setYugao(id:int, bOpen:Boolean, bShow:Boolean):void
		{
			if (m_bShow != bShow)
			{
				setBtnState(bShow);
				updateYuGaoItemPos();
			}
			
			m_bShow = bShow;
			m_yugaoItem.setYugao(id, bOpen);
			
			if (bOpen && false == this.isVisible())
			{
				this.show();
			}
			else if(!bOpen && this.isVisible())
			{
				this.hide();
			}
		}
		
		private function onYuGaoBtnClick(event:MouseEvent):void
		{
			if (m_ani.bRun)
			{
				return;
			}
			
			updateYuGaoItemPos();
			setBtnState(m_bShow);
		}
		
		private function updateYuGaoItemPos():void
		{
			m_ani.setBeginPos(m_yugaoItem.x, m_yugaoItem.y);
			if (m_bShow)
			{
				m_ani.setEndPos(m_yugaoItem.x + 233, m_yugaoItem.y);
			}
			else
			{
				m_ani.setEndPos(m_yugaoItem.x - 233, m_yugaoItem.y);
			}
			m_ani.begin();
			
			m_bShow = !m_bShow;
		}
		
		private function setBtnState(bool:Boolean):void
		{
			if (bool)
			{
				m_yubaoBtn.setSkinButton1Image("commoncontrol/panel/task/yugaoBtn_hide.png");
			}
			else
			{
				m_yubaoBtn.setSkinButton1Image("commoncontrol/panel/task/yugaoBtn_show.png");
			}
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
			
			super.dispose();
		}
	}

}