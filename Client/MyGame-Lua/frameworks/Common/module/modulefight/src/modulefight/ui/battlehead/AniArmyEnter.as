package modulefight.ui.battlehead 
{
	import com.ani.AniComposeSequence;
	import com.ani.AniPropertys;
	import com.ani.AniPause;
	//import com.bit101.components.Panel;
	import com.bit101.components.PanelShowAndHide;
	import common.event.UIEvent;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 * 后续部队抵达文字进入动画
	 */
	public class AniArmyEnter extends PanelShowAndHide 
	{
		private var m_ani:AniComposeSequence;
		public function AniArmyEnter(parent:DisplayObjectContainer) 
		{
			super(parent);
			this.setSize(209,38);
			this.setPanelImageSkin("commoncontrol/panel/word_ArmyEnter.png");
			this.addEventListener(UIEvent.ANI_END, onScrollRectAniEnd);
			
			m_ani = new AniComposeSequence();
			var aniTime:AniPause = new AniPause();
			aniTime.delay = 1.2;
			
			var aniAlpha:AniPropertys = new AniPropertys();
			aniAlpha.resetValues( { alpha:0 } );
			aniAlpha.duration = 0.4;
			m_ani.setAniList([aniTime, aniAlpha]);
			m_ani.sprite = this;
			m_ani.onEnd = onEnd;
		}
		
		public function beginAni():void
		{
			show();
			this.alpha = 1;
			setScrollRectAniParam(0, 38, 120);
			this.beginScrollRectAni();			
		}
		
		override public function dispose():void 
		{
			this.removeEventListener(UIEvent.ANI_END, onScrollRectAniEnd);
			m_ani.dispose();
			m_ani = null;
			super.dispose();
		}
		
		private function onScrollRectAniEnd(e:UIEvent):void
		{
			m_ani.begin();
		}	
		
		private function onEnd():void
		{
			hide();
		}
	}

}