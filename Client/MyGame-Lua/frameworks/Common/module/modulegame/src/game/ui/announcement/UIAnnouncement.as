package game.ui.announcement 
{
	import com.bit101.components.Component;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIAnnouncement;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UIAnnouncement extends Form implements IUIAnnouncement
	{
		private var m_list:Vector.<String>;
		private var m_ann:AnnCtrl;
		public function UIAnnouncement() 
		{
			super();
			this.exitMode = EXITMODE_HIDE;
			this.alignVertial = Component.TOP;
			this.marginTop = 160;
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		override public function onReady():void 
		{
			super.onReady();
			m_list = new Vector.<String>;
			m_ann = new AnnCtrl(this, m_gkcontext, this);
		}
		
		public function onAnnEnd():void
		{
			if (m_list.length == 0)
			{
				this.exit();
				return;
			}
			play();
		}
		private function play():void
		{
			var str:String = m_list[0];
			m_list.splice(0, 1);
			m_ann.begin(str);
		}
		public function add(str:String):void
		{
			m_list.push(str);
			if (m_ann.step == AnnCtrl.SETP_Idle)
			{
				play();
			}
			this.show();
		}
		
	}

}