package modulecommon.commonfuntion 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	/**
	 * 用于空闲进程PreLoadInIdleTimeProcess类的xml管理，这里主要要记住那些xml已经被加载过
	 * @author 
	 */
	public class PreLoadXmlMgr 
	{
		/**
		 * 已经预加载的等级
		 */
		private var m_preloadLevel:int;
		/**
		 * swf路径字典 [level,array(string)]
		 */
		private var m_dicSwfPath:Dictionary;
		/**
		 * picture路径字典 [level,array(string)]
		 */
		private var m_dicPicPath:Dictionary;
		/**
		 * 公共字段
		 */
		private var m_gkcontext:GkContext;
		public function PreLoadXmlMgr(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_preloadLevel = 0;
		}
		/**
		 * 加载xml配置文件
		 */
		public function loadConfig():void
		{
			var curlevel:int = m_gkcontext.playerMain.level;
			if (curlevel > m_preloadLevel)
			{
				if(m_preloadLevel == 0)
				{
					var xml:XML = m_gkcontext.m_dataXml.getXML(DataXml.XML_Preload);
					m_dicSwfPath = new Dictionary();
					m_dicPicPath = new Dictionary();
					for each(var item:XML in xml.child("res"))
					{
						var xmlitem:PreloadResPath = new PreloadResPath();
						xmlitem.parse(item);
						m_dicSwfPath[xmlitem.m_level] = xmlitem.m_swfpath;
						m_dicPicPath[xmlitem.m_level] = xmlitem.m_picturepath;
					}
					var i:int = 1;
				}
				else
				{
					i = m_preloadLevel + 1;
				}
				
				for (; i <= curlevel; i++ )
				{
					if (m_dicSwfPath[i])
					{
						for each(var str:String in m_dicSwfPath[i])
						{
							m_gkcontext.m_preLoadInIdleTimeProcess.m_swfNamesForPreLoad.push(str);
						}
					}
					if (m_dicPicPath[i])
					{
						for each(str in m_dicPicPath[i])
						{
							m_gkcontext.m_preLoadInIdleTimeProcess.m_pictureNamesForPreLoad.push(str);
						}
					}
				}
				m_preloadLevel = curlevel;
			}
		}
	}

}