package com.pblabs.engine
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.display.BitmapData;
	
	import common.Context;

	/**
	 * @brief 默认占位资源
	 * */
	public class ReplaceResSys implements IReplaceResSys
	{
		public var m_context:Context;
		protected var m_replaceRes:SWFResource;
		
		protected var m_shadowPlace:BitmapData;	// 阴影占位资源
		protected var m_playerPlace:BitmapData;	// 这个是玩家的占位资源
		protected var m_thingPlace:BitmapData;	// 这个是地上物的占位资源

		public function ReplaceResSys(context:Context)
		{
			m_context = context;
		}
		
		public function load():void
		{
			m_replaceRes = m_context.m_resMgr.load("asset/scene/replace/replace.swf", SWFResource, onloadedSWF, onFailedSWF) as SWFResource;
		}
		
		private function onloadedSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			m_shadowPlace = m_replaceRes.getExportedAsset("art.replace.shadow", true) as BitmapData;
			m_playerPlace = m_replaceRes.getExportedAsset("art.replace.black", true) as BitmapData;
			m_thingPlace = m_replaceRes.getExportedAsset("art.replace.mark", true) as BitmapData;
			
			//m_context.m_gkcontext.startprogResLoaded(event.resourceObject.filename);
			m_context.setLoad(EntityCValue.PreloadRES_ReplaceResSys);
		}
		
		private function onFailedSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, event.resourceObject.filename + " failed");
			m_context.m_gkcontext.startprogResFailed(event.resourceObject.filename);
		}
		
		public function get shadowPlace():BitmapData
		{
			return m_shadowPlace;
		}
		
		public function get playerPlace():BitmapData
		{
			return m_playerPlace;
		}
		
		public function get thingPlace():BitmapData
		{
			return m_thingPlace;
		}
	}
}