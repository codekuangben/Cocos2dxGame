package modulefight.digitani 
{
	import com.ani.DigitAniBase;
	import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	//import com.bit101.components.PanelShowAndHide;
	
	import common.Context;
	import common.event.UIEvent;
	
	import flash.display.DisplayObject;
	
	import modulecommon.appcontrol.DigitComponentWidthSign;
	
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DigitSprite extends Panel 
	{
		private var m_type:int;
		protected var m_context : Context;
		private var m_display:DisplayObject;
		private var m_ani:DigitAniBase;
		private var m_mgr:HPDigitMgr;
		public function DigitSprite(con:Context, type:uint, mgr:HPDigitMgr) 
		{			
			m_context = con;
			m_mgr = mgr;
			//super(p);			
			m_type = type;

			//m_type=FightEn.DAM_TYPE_FANJI;
			if (m_type==FightEn.DAM_TYPE_BAOJI)				// 暴击 
			{
				m_display = new DigitBaojiDisplay(con, this);
				m_ani = new DigitBaojiAni();				
			}
			else if (m_type==FightEn.DAM_TYPE_GEDANG)		// 格挡
			{
				m_display = new DigitGedangDisplay(con, this);
				m_ani = new DigitBaojiAni();
				//(m_display as DigitGedangDisplay).m_digit.setParam("commoncontrol/digit/gedangdigit", 22, 35, "commoncontrol/digit/gedangdigit/subtract.png", 10,22);
			}
			else if (m_type==FightEn.DAM_TYPE_FANJI)		// 反击
			{
				m_display = new DigitFanJiDisplay(con, this);
				m_ani = new DigitBaojiAni();
				//(m_display as DigitFanJiDisplay).m_digit.setParam("commoncontrol/digit/normaldigit", 22, 35, "commoncontrol/digit/normaldigit/subtract.png", 10,22);
			}
			else if (m_type == FightEn.DAM || m_type == FightEn.DAMTYPE_VEREDUCEHP)
			{
				m_display = new DigitNormalDisplay(con, this);
				m_ani = new DigitNormalAni();
			}
			else if (m_type == FightEn.DAM_TYPE_Buffer_Methysis)
			{
				m_display = new DigitNormalDisplay(con, this);
				m_ani = new DigitNormalAni();
			}
			else
			{
				var dc:DigitComponentWidthSign=new DigitComponentWidthSign(con, this);
				m_display = dc;
				m_ani = new DigitNormalAni();
				//if (m_type == FightEn.DAM || m_type == FightEn.DAM_TYPE_FANJI)	// 反击单独显示
				if (m_type == FightEn.DAM)
				{
					dc.setParam("commoncontrol/digit/normaldigit", 22, 35, "commoncontrol/digit/normaldigit/subtract.png", 10,22);
				}
				//else if (m_type == FightEn.DAM_TYPE_GEDANG)	// 格挡单独显示 
				//{
				//	dc.setParam("commoncontrol/digit/gedangdigit", 22, 35, "commoncontrol/digit/gedangdigit/subtract.png", 10,22);
				//}
				else if (m_type == FightEn.DAMTYPE_VEADDHP)
				{
					dc.setParam("commoncontrol/digit/addhpdigit", 22, 35, "commoncontrol/digit/addhpdigit/add.png", 3,24);
				}
			}
			m_display.addEventListener(UIEvent.IMAGELOADED, onDigitCreatorDraw);
			m_ani.sprite = this;
			m_ani.onEnd = onEndAni;
		}
		//damType2：见FightEn.DAM_Physical,FightEn.DAM_Strategy
		public function setDigit(value:uint, damType2:int):void
		{
			
			var res:String;
			var aniClass:Class;
			var displayClass:Class;
			m_display.visible = false;
			if (m_type==FightEn.DAM_TYPE_BAOJI)
			{				
				(m_display as DigitBaojiDisplay).setDigit(value,damType2);					
			}
			else if (m_type==FightEn.DAM_TYPE_GEDANG)
			{				
				(m_display as DigitGedangDisplay).setDigit(value,damType2);						
			}
			else if (m_type==FightEn.DAM_TYPE_FANJI)
			{				
				(m_display as DigitFanJiDisplay).setDigit(value,damType2);					
			}
			else if (m_type == FightEn.DAM || m_type == FightEn.DAMTYPE_VEREDUCEHP)
			{				
				(m_display as DigitNormalDisplay).setDigit(value,damType2);				
			}
			else if (m_type == FightEn.DAM_TYPE_Buffer_Methysis)
			{
				(m_display as DigitNormalDisplay).setDigit(value, FightEn.DAM_None);				
			}
			else
			{
				(m_display as DigitComponentWidthSign).digit = value;
				
			}		
			
		}		
	
		private function onDigitCreatorDraw(e:UIEvent):void
		{
			if (e.target != m_display)
			{
				return;
			}
			
			m_display.visible = true;			
			m_display.x = -((m_display.width) / 2);		
			m_ani.begin();			
		
		}
		
		public function onEndAni():void
		{
			m_mgr.collectDigit(this);
		}		
		
		override public function dispose():void
		{
			m_ani.dispose();
			super.dispose();
		}	
		
		public function get type():int
		{
			return m_type;
		}
	}

}