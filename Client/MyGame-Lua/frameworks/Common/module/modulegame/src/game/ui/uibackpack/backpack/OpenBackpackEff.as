package game.ui.uibackpack.backpack 
{
	import com.bit101.components.Ani;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ObjectPanel;
	/**
	 * 开启包裹格子，并播放特效
	 * @author ...
	 */
	public class OpenBackpackEff extends ObjectPanel
	{		
		private var m_ani:Ani;
		private var m_lockpanel:OPInCommonPack;
		private var m_funNextPlay:Function;
		private var m_funAniEnd:Function;
		public function OpenBackpackEff(gk:GkContext, parent:DisplayObjectContainer=null, lockpanl:OPInCommonPack=null, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, parent, xpos, ypos);
			m_gkContext = gk;
			m_lockpanel = lockpanl;
			
			m_ani = new Ani(m_gkContext.m_context);
			m_ani.duration = 0.8;
			m_ani.repeatCount = 1;
			
			m_ani.setImageAni("ejkaibaoxiang.swf");
			m_ani.centerPlay = true;
			m_ani.mouseEnabled = false;
			m_ani.onCompleteFun = onOpenEffEnd;
			m_ani.setProgressCallBack(0.6, onBeginNext);
			this.addChild(m_ani);
			this.mouseEnabled = false;
		}
		
		public function onOpenEffEnd(ani:Ani):void
		{
			if (m_ani && this.contains(m_ani))
			{
				this.removeChild(m_ani);
			}
			if (m_lockpanel)
			{
				m_lockpanel.lock = false;
			}
			if (m_funAniEnd != null)
			{
				m_funAniEnd();
			}
		}
		
		public function beginPlay():void
		{
			m_ani.begin();
		}
		
		public function setNextPlayCallBack(funCallBack:Function):void
		{
			m_funNextPlay = funCallBack;			
		}
		public function setAniEnd(funCallBack:Function):void
		{
			m_funAniEnd = funCallBack;
		}
		private function onBeginNext():void
		{
			if (m_funNextPlay != null)
			{
				m_funNextPlay();
			}
		}
		override public function dispose():void
		{
			if(m_ani && !this.contains(m_ani))
			{
				m_ani.dispose();
				m_ani = null;
			}
			m_funAniEnd = null;
			m_funNextPlay = null;
			super.dispose();
			
		}
	}

}