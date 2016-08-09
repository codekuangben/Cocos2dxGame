package common.event 
{
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIEvent extends Event 
	{
		public static const IMAGELOADED:String = "ui_ImageLoaded";	
		public static const IMAGEFAILED:String = "ui_ImageFailed";	
		public static const AllIMAGELOADED:String = "ui_AllImageLoaded";
		public static const ANI_END:String = "ui_AniEnd";
		public var m_skin:Skin;
		public function UIEvent(type:String, bubbles:Boolean=false, skin:Skin=null)
		{
			super(type, bubbles);
			m_skin = skin;
		}
		
	}

}