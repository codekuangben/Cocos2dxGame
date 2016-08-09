package start
{
	

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import base.IVersionAllInfo;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * @brief 所有的版本信息
	 * */
	public class VersionAllInfo implements IVersionAllInfo
	{
		public static const VerFlags:String = '?v=';
		//public static const VerParaFlags:String = 'v=';
		public var m_path2md:Dictionary;
		private var m_bLoaded:Boolean;		// 加载标志
		private var m_versionStr:String = "";			// 这个是版本字符串
		private var m_loader:Loader;
		private var m_start:Start;
		public function VersionAllInfo(start:Start, version:String)
		{
			m_versionStr = version;
			m_start = start;
			m_path2md = new Dictionary();
		}
		
		public function load():void
		{
			var strURL:String;
			if(!m_versionStr.length)
			{
				// 版本文件必然加载
				//m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + int(Math.random()  * 100 * getTimer()), SWFResource, onloadedSWF, onFailedSWF);
				var data:String = new Date() + Math.random();
				//data = data.split(" ").join("");
				data = data.split(":").join("");
				//data = data.split(".").join("");
				//m_context.m_resMgr.load("asset/versionall.swf" + VerFlags + new Date() + Math.random(), SWFResource, onloadedSWF, onFailedSWF);
				strURL = "asset/versionall.swf" + VerFlags + data;
				
			}
			else
			{
				strURL = "asset/versionall.swf" + VerFlags + m_versionStr;				
			}
			
			
			m_loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			//m_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			//m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			
			var url:URLRequest = new URLRequest(strURL);
			m_loader.load(url);			
		}
		public function onCompleteHandler(evt:Event) : void 
		{
			m_start.addLog("VersionAllInfo::onCompleteHandler");
			var name:String = "art.ver.all";
			var appDomain:ApplicationDomain = m_loader.contentLoaderInfo.applicationDomain;
        	var assetClass:Class = appDomain.getDefinition(name) as Class;;
			var bytes:ByteArray = new assetClass() as ByteArray;
			
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
			m_bLoaded = true;
			m_loader = null;
			m_start.onVersionAllLoaded();
		}
		
		public function getVersionByFileName(fileName:String):String
		{
			return m_path2md[fileName];
		}
		
		public function get version():String
		{
			return m_versionStr;
		}
		
		public function get loaded():Boolean
		{
			return m_bLoaded;
		}
	
	}
}