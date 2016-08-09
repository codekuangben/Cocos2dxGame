package modulecommon.ui 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 
	 */
	import flash.display.Sprite;
	public class FormDarkOther extends Form 
	{
		private var m_darkBG:Sprite;
		public function FormDarkOther() 
		{
			m_darkBG = new Sprite();
			this.addChild(m_darkBG);
			this.setChildIndex(m_darkBG, 0);
			m_darkBG.graphics.beginFill(0, 0.5);
			m_darkBG.graphics.drawRect( -5000, -5000, 20000, 20000);
			m_darkBG.graphics.endFill();		
		}
		
	}

}