package game.ui.zhanliAdvance 
{
	import modulecommon.ui.Form;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIZhanliAdvance_ValueAni extends Form 
	{
		private var m_ctrl:ZhanliCtrl;
		public function UIZhanliAdvance_ValueAni() 
		{
			super();
			exitMode = EXITMODE_HIDE;
			
		}
		override public function onReady():void 
		{
			super.onReady();
			m_ctrl = new ZhanliCtrl(m_gkcontext.m_context, this);
		}
		
		override public function updateData(param:Object = null):void 
		{
			if (m_ctrl.step == ZhanliCtrl.SETP_Idle)
			{
				m_ctrl.begin(param as int);
				show();
			}
		}	
		override public function adjustPosWithAlign():void 
		{
			
		}
	}

}