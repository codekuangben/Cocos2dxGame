package br.com.stimuli.loading.loadingtypes
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import br.com.stimuli.loading.BulkLoader;
	import flash.events.HTTPStatusEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * @ brief 新的加载 swf 的资源 item
	 * */
	public class SWFItem extends LoadingItem
	{	
		public var loader : Loader;
		public var m_bunload:Boolean = false;		// 这个字段主要是防止资源加载进来立即卸载，并且还在引用这个资源，会偶尔发生这个情况
		
		public function SWFItem(url : URLRequest, type : String, uid : String){
			specificAvailableProps = [BulkLoader.CONTEXT];
			super(url, type, uid);
		}
		
		override public function _parseOptions(props : Object)  : Array{
			_context = props[BulkLoader.CONTEXT] || null;
			
			return super._parseOptions(props);
		}
		
		override public function load() : void{
			super.load();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.INIT, onInitHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);  
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			try{
				// TODO: test for security error thown.
				loader.load(url, _context);
			}catch( e : SecurityError){
				onSecurityErrorHandler(_createErrorEvent(e));
			}
			
		};
		
		public function _onHttpStatusHandler(evt : HTTPStatusEvent) : void{
			_httpStatus = evt.status;
			dispatchEvent(evt);
		}
		
		override public function onErrorHandler(evt : ErrorEvent) : void{
			if(!m_bunload)
			{
				super.onErrorHandler(evt);
			}
			else
			{
				// 如果运行到这里，说明加载完成立即卸载资源，并且资源在使用中，偶尔在调用 unloadAndStop 过程中会抛出 IOErrorEvent.IO_ERROR
				// trace("unloadAndStop IOErrorEvent.IO_ERROR " + _id)
			}
		}
		
		public function onInitHandler(evt : Event) :void{
			dispatchEvent(evt);
		}
		
		override public function onCompleteHandler(evt : Event) : void {
			// TODO: test for the different behaviour when loading items with 
			// the a specific crossdomain and without one
			try{
				// of no crossdomain has allowed this operation, this might
				// raise a security error
				_content = loader.content;
				super.onCompleteHandler(evt);
			}catch(e : SecurityError){
				// we can still use the Loader object (no dice for accessing it as data
				// though. Oh boy:
				_content = loader;
				super.onCompleteHandler(evt);
				// I am really unsure whether I should throw this event
				// it would be nice, but simply delegating the error handling to user's code 
				// seems cleaner (and it also mimics the Standar API behaviour on this respect)
				//onSecurityErrorHandler(e);
			}
			
		};
		
		override public function stop() : void{
			try{
				if(loader){
					loader.close();
				}
			}catch(e : Error){
				
			}
			super.stop();
		};
		
		/** Gets a  definition from a fully qualified path (can be a Class, function or namespace). 
		 @param className The fully qualified class name as a string.
		 @return The definition object with that name or null of not found.
		 */
		public function getDefinitionByName(className : String) : Object{
			if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)){
				return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
			}
			return null;
		}
		
		override public function cleanListeners() : void {
			if (loader){
				var removalTarget : Object = loader.contentLoaderInfo;
				removalTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
				removalTarget.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
				removalTarget.removeEventListener(Event.INIT, onInitHandler, false);
				removalTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
				removalTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false);
				removalTarget.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
				removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
			}
		}
		
		override public function isImage(): Boolean{
			return (type == BulkLoader.TYPE_IMAGE);
		}
		
		override public function isSWF(): Boolean{
			return true;
		}
		
		
		override public function isStreamable() : Boolean{
			return isSWF();
		}
		
		override public function destroy() : void{
			stop();
			//cleanListeners();
			_content = null;
			m_bunload = true;
			// this is an player 10 only feature. as such we must check it's existence
			// with the array acessor, or else the compiler will barf on player 9
			if (loader && loader.hasOwnProperty("unloadAndStop") && loader["unloadAndStop"] is Function) {
				loader["unloadAndStop"](true);
			}else if (loader && loader.hasOwnProperty("unload") && loader["unload"] is Function) {
				// this is an air only feature. as such we must check it's existence
				// with the array acessor, or else the compiler will barf on non air projects
				loader["unload"]();
			}
			
			// 资源卸载完成调用，防止资源加载完成立即就卸载，会抛出 IO_ERROR 事件
			cleanListeners();
			loader = null;
		}
	}
}