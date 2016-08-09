package com.gamecursor 
{
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import common.Context;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class CursorDataDef 
	{
		public var m_name:String;	//鼠标图标名称
		public var m_resName:String;	//鼠标图标资源文件名称
		public var m_bRegistered:Boolean;	//表示是否已经注册
		protected var onLoadedOfGameCursor:Function;	//记录GameCursor::onloaded
		public function CursorDataDef(name:String, resName:String, bRegistered:Boolean) 
		{
			m_name = name;
			m_resName = resName;
			m_bRegistered = bRegistered;
		}
		
		public function loadCursor(con:Context, data:CursorDataDef, fun:Function):void
		{
			if (onLoadedOfGameCursor != null)
			{
				//表示已经调用过一次m_commonImageMgr.loadImage
				return;
			}
			onLoadedOfGameCursor = fun;
			con.m_commonImageMgr.loadImage("cursor/"+data.m_name+ ".png", PanelImage, onLoaded, onFailed);
		}
		
		public function onLoaded(resImage:Image):void
		{
			var cursorData:MouseCursorData = new MouseCursorData();			
			var vec:Vector.<BitmapData> = new Vector.<BitmapData>(1);
			vec[0] = (resImage as PanelImage).data;
			cursorData.data = vec;
			cursorData.frameRate = 1;
			Mouse.registerCursor(m_name, cursorData);
			m_bRegistered = true;
			
			onLoadedOfGameCursor(this);
			onLoadedOfGameCursor = null;
		}
		
		
		protected function onFailed (filename:String) : void
		{
			onLoadedOfGameCursor = null;
		}
		
	}

}