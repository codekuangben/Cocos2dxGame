package modulefight.skillani 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import common.Context;
	/**
	 * ...
	 * @author ...
	 * 释放技能时，在部队上播放的特效
	 */
	public class JuqiSkillAni extends Component 
	{		
		private var m_ani:Ani;
		public function JuqiSkillAni(con:Context) 
		{			
			m_ani = new Ani(m_con);
			m_ani.centerPlay = true;
			m_ani.setImageAni("ejfazhaojiqi.swf");
			m_ani.duration = 0.5;
			m_ani.stop();
			this.addChild(m_ani);
			m_ani.onCompleteFun = onAniComplete;
		}
		
		public function begin():void
		{
			m_ani.begin();
		}
		protected function onAniComplete(ani:Ani):void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}

}