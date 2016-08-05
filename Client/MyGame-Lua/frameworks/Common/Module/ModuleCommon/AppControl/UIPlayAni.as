package modulecommon.appcontrol 
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author ...
	 * 动画播放:在屏幕中播放一个动画
	 * 在界面的最上层播放
	 */
	public class UIPlayAni extends Form 
	{
		private var m_aniList:Vector.<Ani>;
		public function UIPlayAni() 
		{
			this.id = UIFormID.UIPlayAni;
			exitMode = EXITMODE_HIDE;
			alignHorizontal = Component.LEFT;
			alignVertial = Component.TOP;
			m_aniList = new Vector.<Ani>();
		}
		override public function onReady():void
		{			
			super.onReady();
		}
		
		//
		public function playAni(aniName:String, duration:Number, xPos:Number, yPos:Number):void
		{
			var ani:Ani = new Ani(m_gkcontext.m_context);
			ani.setImageAni(aniName);
			ani.duration = duration;
			ani.centerPlay = true;
			ani.x = xPos;
			ani.y = yPos;
			ani.onCompleteFun = onAniEnd;
			this.addChild(ani);
			m_aniList.push(ani);
			ani.begin();
			show();
		}
		
		private function onAniEnd(ani:Ani):void
		{
			var i:int = m_aniList.indexOf(ani);
			if (i !== -1)
			{
				m_aniList.splice(i, 1);
			}
			ani.dispose();
			if (ani.parent)
			{
				this.removeChild(ani);
			}
			if (m_aniList.length == 0)
			{
				this.exit();
			}
		}
		
		
	}

}