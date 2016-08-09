package common.config
{
	
	/*import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import common.Context;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;*/
	//import flash.utils.getTimer;
	
	/**
	 * @brief 所有的版本信息
	 * */
	public class VersionInfo
	{
		/*public static const VerFlags:String = '?v=';
		public static const VerParaFlags:String = 'v=';
		public var m_path2md:Dictionary;
		public var m_context:Context;
		public var m_loadflags:uint = 0;		// 加载标志
		public var m_versionStr:String = "";			// 这个是版本字符串
		
		public function VersionInfo()
		{
			m_path2md = new Dictionary();
		}
		
		public function load():void
		{
			if(!m_versionStr.length)
			{
				// 版本文件必然加载
				//m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + int(Math.random()  * 100 * getTimer()), SWFResource, onloadedSWF, onFailedSWF);
				var data:String = new Date() + Math.random();
				//data = data.split(" ").join("");
				data = data.split(":").join("");
				//data = data.split(".").join("");
				//m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + new Date() + Math.random(), SWFResource, onloadedSWF, onFailedSWF);
				m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + data, SWFResource, onloadedSWF, onFailedSWF);
				//m_context.m_resMgr.load("asset/versionall.swf?v=111", SWFResource, onloadedSWF, onFailedSWF);
			}
			else
			{
				m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + m_versionStr, SWFResource, onloadedSWF, onFailedSWF);
			}
		}
		
		private function onloadedSWF(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			var swfRes:SWFResource = resource as SWFResource;
			
			var bytes:ByteArray;
			var clase:String = "art.ver.all";
			// 取出资源
			bytes = swfRes.getExportedAsset(clase) as ByteArray;
			
			// 解压缩
			var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
			var alllist:Array;
			var substrlist:Array;
			var alllen:uint = 0;
			var allidx:uint = 0;
			alllist = str.split("\n");
			alllen = alllist.length;
			while(allidx < alllen)
			{
				if(alllist[allidx].length)
				{
					substrlist = alllist[allidx].split("=");
					if(substrlist[1].length)
					{
						substrlist[1] = substrlist[1].substr(0, substrlist[1].length - 1);	// 删除最后的 "\r"
					}
					m_path2md[substrlist[0]] = substrlist[1];
					++allidx;
				}
			}
			
			m_loadflags = 1;
			// 加载场景占位资源
			m_context.m_replaceResSys.load();
			m_context.m_commonImageMgr.load();
			
			// 加载进度条
			m_context.m_gkcontext.progResLoaded(resource.filename);
			m_context.m_gkcontext.startprogResLoaded(resource.filename);
			m_context.m_resMgr.unload("asset/versionall.swf", SWFResource);
		}
		
		private function onFailedSWF(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			Logger.error(this, "VersionInfo::onFailedSWF", resource.filename + " failed");
			
			// 加载进度条
			m_context.m_gkcontext.progResFailed(resource.filename);
			m_context.m_gkcontext.startprogResFailed(resource.filename);
			m_context.m_resMgr.unload("asset/versionall.swf", SWFResource);
		}*/
	}
}