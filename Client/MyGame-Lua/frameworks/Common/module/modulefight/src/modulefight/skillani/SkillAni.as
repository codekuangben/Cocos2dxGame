package modulefight.skillani
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.ani.AniPropertys;
	
	/**
	 * ...
	 * @author
	 * //技能动画:部队释放技能时,在部队的头上,出现此动画
	 */
	public class SkillAni extends SkillAniBase
	{		
		public function SkillAni(con:Context)
		{
			super(con);

			m_aniRight.setImageAni("efazhao.swf");
			m_aniRight.duration = 0.4;
			m_aniRight.repeatCount = 1;						
			
			m_aniLeft.setImageAniMirror("efazhao.swf", Image.MirrorMode_HOR);
			m_aniLeft.duration = 0.4;
			m_aniLeft.repeatCount = 1;		
		}
		
	
		public function begin(side:int, nameWord:String):void
		{					
			var ani:Ani;
			if (side == EntityCValue.RKLeft)
			{				
				m_wordPanel.x = -40;
				m_wordPanel.y = -30;
				ani = m_aniLeft;
				m_aniRight.visible = false;
			}
			else
			{
				m_wordPanel.x = -40;
				m_wordPanel.y = -30;
				m_aniLeft.visible = false;
				ani = m_aniRight;
			}
			ani.visible = true;
			ani.begin();
			this.alpha = 1;
			m_wordPanel.setPanelImageSkin("jinengming/" + nameWord);
		}		
	
	}

}