package modulecommon.commonfuntion 
{
	import com.util.UtilXML;
	/**
	 * 要预加载的资源路径 根据等级预加载
	 * @author 
	 */
	public class PreloadResPath 
	{
		public var m_level:uint;
		public var m_swfpath:Array;
		public var m_picturepath:Array;
		public function PreloadResPath() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_swfpath = new Array();
			m_picturepath = new Array();
			m_level = parseInt(xml.@level);
			for each(var item:* in xml.child("swf"))
			{
				var str:String = item.@path;
				m_swfpath.push(str);
			}
			for each(item in xml.child("picture"))
			{
				str = item.@path;
				m_picturepath.push(str);
			}
		}
	}

}