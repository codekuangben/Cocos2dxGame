package modulecommon.commonfuntion.delayloader
{
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.utils.ByteArray;
	
	import modulecommon.GkContext;
	
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * @ 地图文件延迟加载
	 * */
	public class DelayLoaderMap extends DelayLoaderBase
	{
		public var m_gkcontext:GkContext;
		public var m_fcbLoaded:Function;
		
		// 需要判断资源是否已经加载
		override public function loadRes():Boolean
		{
			var splash:int = m_path.lastIndexOf('/');
			var dot:int = m_path.lastIndexOf('.');
			var sceneid:int = int(m_path.substring(splash + 2, dot));
			
			// 如果已经加载了资源
			if(this.m_gkcontext.m_context.m_sceneResMgr.m_sceneFileDict[sceneid])
			{
				m_fcbLoaded();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		// 解析地图文件
		override public function onResLoaded(res:SWFResource):void
		{
			// 主要是加载地图缩略图
			var bytes:ByteArray;
			var splash:int = m_path.lastIndexOf('/');
			var dot:int = m_path.lastIndexOf('.');
			var sceneid:int = int(m_path.substring(splash + 2, dot));
			bytes = res.getExportedAsset("art.cfg.t" + sceneid) as ByteArray;
			
			var xml:XML;
			xml = new XML(bytes.readUTFBytes(bytes.length));
			// 保存到场景资源管理器中去
			this.m_gkcontext.m_context.m_sceneResMgr.m_sceneFileDict[sceneid] = xml;
			
			// 第一个就是缩略图的定义
			var filename:String = xml.child('head')[0].child('definitions')[0].attribute('src')[0].toString();
			var type:int = fUtil.xmlResType(filename);
			filename = this.m_gkcontext.m_context.m_path.getPathByName(filename + ".swf", type);
			
			var item:DelayLoaderThumb = new DelayLoaderThumb();
			item.m_gkcontext = m_gkcontext;
			item.m_path = filename;
			item.m_loadInterval = 1;
			m_gkcontext.m_delayLoader.addDelayLoadItem(item);
			
			// bug: 卸载掉加载的资源，否则再次加载的时候上层收不到加载完成的消息，修改结构，bug解决  
			//m_gkcontext.m_context.m_resMgrNoProg.unload(res.filename, SWFResource);
			m_gkcontext.m_context.m_resMgr.unload(res.filename, SWFResource);
		}
		
		override public function dispose():void
		{
			m_gkcontext = null;
			m_fcbLoaded = null;
			super.dispose();
		}
		
		override public function set fcbLoaded(fn:Function):void
		{
			m_fcbLoaded = fn;
		}
	}
}