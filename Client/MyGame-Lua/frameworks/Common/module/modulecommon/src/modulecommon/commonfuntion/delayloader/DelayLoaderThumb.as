package modulecommon.commonfuntion.delayloader
{
	import com.pblabs.engine.resource.SWFResource;
	import modulecommon.GkContext;
	//import org.ffilmation.engine.helpers.fUtil;
	import flash.display.BitmapData;
	
	/**
	 * @ 地图缩略图延迟加载
	 * */
	public class DelayLoaderThumb extends DelayLoaderBase
	{
		public var m_gkcontext:GkContext;
		
		// 需要判断资源是否已经加载
		override public function loadRes():Boolean
		{
			var splash:int = m_path.lastIndexOf('/');
			var dot:int = m_path.lastIndexOf('.');
			var sceneid:int = int(m_path.substring(splash + 2, dot));
			
			// 如果已经加载了资源
			if(this.m_gkcontext.m_context.m_sceneResMgr.m_thumbnailsDict[sceneid])
			{
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
			var bytes:BitmapData;
			var splash:int = m_path.lastIndexOf('/');
			var dot:int = m_path.lastIndexOf('.');
			var sceneid:int = int(m_path.substring(splash + 4, dot));
			bytes = res.getExportedAsset("art.ttb.t" + sceneid) as BitmapData;
			// 保存到场景资源管理器中去
			this.m_gkcontext.m_context.m_sceneResMgr.m_thumbnailsDict[sceneid] = bytes;
			
			// bug: 卸载掉加载的资源，否则再次加载的时候上层收不到加载完成的消息，修改结构，bug解决  
			//m_gkcontext.m_context.m_resMgrNoProg.unload(res.filename, SWFResource);
			m_gkcontext.m_context.m_resMgr.unload(res.filename, SWFResource);
		}
		
		override public function dispose():void
		{
			m_gkcontext = null;
			super.dispose();
		}
	}
}