package modulefight.digitani
{
	import com.ani.DigitAniBase;
	import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	//import com.bit101.components.PanelShowAndHide;
	
	import common.event.UIEvent;
	//import modulecommon.appcontrol.DigitComponentWidthSign;
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TRoleStateItem;
	import modulecommon.scene.prop.table.DataTable;
	
	/**
	 * @brief 一项名字
	 * */
	public class BBNameItem extends Panel
	{
		private var m_type:int;
		protected var m_gkcontext:GkContext;
		private var m_ani:DigitAniBase;
		private var m_mgr:BBNameMgr;
		private var m_display:Panel;		// 显示图像		

		// 这个默认显示就是在正中央
		public function BBNameItem(con:GkContext, type:uint, mgr:BBNameMgr) 
		{			
			m_gkcontext = con;
			m_mgr = mgr;
			//super(p);
			m_type = type;
			if (m_type == FightEn.NTUp ||
			　　m_type == FightEn.NTDn)
			{this.scaleX
				m_display = new Panel(this);
				m_ani = new BBNameNormalAni(type);
			}
			m_display.addEventListener(UIEvent.IMAGELOADED, onDigitCreatorDraw);
			m_ani.sprite = this;
			m_ani.onEnd = onEndAni;
		}

		private function onDigitCreatorDraw(e:UIEvent):void
		{
			// 只要把图片就行了
			m_display.visible = true;
			m_display.x = -((m_display.width) / 2);
			m_ani.begin();
		}
		
		// 设置显示的内容
		public function setStateEn(picName:String):void
		{			
			m_display.setPanelImageSkin("stateword/" + picName + ".png");
		}
		
		public function onEndAni():void
		{
			m_mgr.collectDigit(this);
		}		
		
		override public function dispose():void
		{
			// 移出事件
			m_display.removeEventListener(UIEvent.IMAGELOADED, onDigitCreatorDraw);
			// 隐藏这个显示,否则可能显示上一次显示的内容
			m_display.visible = false;
			m_ani.dispose();
			super.dispose();
		}	
		
		public function get type():int
		{
			return m_type;
		}
	}
}