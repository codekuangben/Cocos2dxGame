package org.ffilmation.engine.model
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	import com.pblabs.engine.core.ITickedObject;
	import common.Context;
	//import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	//import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	
	import org.ffilmation.engine.elements.fObject;
	import org.ffilmation.engine.helpers.fActDefinition;
	import org.ffilmation.engine.helpers.fActDirectDefinition;
	//import org.ffilmation.engine.helpers.fObjectDefinition;
	//import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	
	public class fUIObject extends fObject implements ITickedObject
	{
		public var m_objID:String;	//唯一代表fUIObject，其值由应用的地方进行定义，要保证唯一性。
		protected var m_nameDisc:String;	//用于在人物头上显示文字		
		public function fUIObject(defObj:XML, con:Context)
		{
			super(defObj, con);
			// 设置这个可见，否则，显示不会更新
			this.isVisibleNow = true;
		}
		
		public override function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);			
		}
		
		public function changeContainerParent(pnt:Sprite):void
		{
			var render:fFlash9ObjectSeqRenderer = (customData.flash9Renderer as fFlash9ObjectSeqRenderer);
			render.changeContainerParent(pnt);
			render.show();
		}
		
		public function offawayContainerParent():void
		{
			var render:fFlash9ObjectSeqRenderer = (customData.flash9Renderer as fFlash9ObjectSeqRenderer);
			render.changeContainerParent(null);
		}		
		
		public override function moveTo(x:Number, y:Number, z:Number):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
			var render:fFlash9ObjectSeqRenderer = (customData.flash9Renderer as fFlash9ObjectSeqRenderer);
			render.place();
		}
		public function get uiLayObj():Sprite
		{
			var render:fFlash9ObjectSeqRenderer = customData.flash9Renderer as fFlash9ObjectSeqRenderer;
			if (render != null)
			{
				return render.getUILayObj();
			}
			return null;
		}
		public function getFrame(xindex:int, yindex:int, act:uint, refOut:Point):BitmapData
		{
			if (customData.flash9Renderer == undefined)
			{
				return null;
			}
			var render:fFlash9ObjectSeqRenderer = (customData.flash9Renderer as fFlash9ObjectSeqRenderer);
			
			if (refOut != null)
			{
				var action:fActDefinition;
				var actdir:fActDirectDefinition;
				action = this.definition.dicAction[act];
				refOut.x = 0;
				refOut.y = 0;
				if (m_LinkOff != null)
				{
					refOut.x = m_LinkOff.x;
					refOut.y = m_LinkOff.y;
				}
				
				if (action)
				{
					actdir = action.directDic[yindex];
					// 初始化一下方向信息    
					if (actdir)
					{
						refOut.x += actdir.spriteVec[render.currentFrame].origin.x;
						refOut.y += actdir.spriteVec[render.currentFrame].origin.y;
					}
				}
			}
			return render.getFrame(xindex, yindex, act);
		}		
		public function get nameDisc():String
		{
			return m_nameDisc;
		}
	}
}