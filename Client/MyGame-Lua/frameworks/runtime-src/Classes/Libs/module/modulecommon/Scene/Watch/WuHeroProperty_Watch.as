package modulecommon.scene.watch 
{
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	
	/**
	 * ...
	 * @author 
	 */
	public class WuHeroProperty_Watch extends WuHeroProperty 
	{
		
		public function WuHeroProperty_Watch(gk:GkContext) 
		{
			super(gk);
		}
		
		override public function set color(value:uint):void
		{
			m_uColor = value;			
		}
	}

}