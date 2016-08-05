/**
 * Component.as
 * Keith Peters
 * version 0.9.10
 *
 * Base class for all components
 *
 * Copyright (c) 2011 Keith Peters
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 *
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */

package com.bit101.components
{
	import com.ani.AniToDestPostion_BezierCurve1;
	import com.ani.liuguang.AniLiuguang;
	import com.ani.uiAni.AniScrollRect;
	import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;	
	import com.dgrigg.skins.HorizontalImageSkin;
	import com.dgrigg.skins.PanelImageSkin;
	import com.dgrigg.skins.SkinGrid9Image9;
	import com.dgrigg.skins.SkinGrid9ImageOne;
	import com.dgrigg.skins.SkinGrid9ImageStretching;
	import com.dgrigg.skins.SkinHorizontalImageRepeat;
	import com.dgrigg.skins.SkinImagePinjie;
	import com.dgrigg.skins.VerticalImageSkin;
	import com.dnd.SourceData;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.PBUtil;
	import com.util.UtilFilter;
	import common.event.UIEvent;
	
	import common.Context;
	import common.event.DragAndDropEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import com.dgrigg.skins.SkinForm;
	
	import org.ffilmation.engine.datatypes.IntPoint;
	
	[Event(name="resize",type="flash.events.Event")]
	[Event(name="draw",type="flash.events.Event")]
	
	public class Component extends Sprite
	{
		// NOTE: Flex 4 introduces DefineFont4, which is used by default and does not work in native text fields.
		// Use the embedAsCFF="false" param to switch back to DefineFont4. In earlier Flex 4 SDKs this was cff="false".
		// So if you are using the Flex 3.x sdk compiler, switch the embed statment below to expose the correct version.
		
		// Flex 4.7 (labs/beta) sdk:
		// SWF generated with fontswf utility bundled with the AIR SDK released on labs.adobe.com with Flash Builder 4.7 (including ASC 2.0) 
		//[Embed(source="../../../../assets/pf_ronda_seven.swf", symbol="PF Ronda Seven")]
		
		// Flex 4.x sdk:
		//[Embed(source="/assets/pf_ronda_seven.ttf",embedAsCFF="false",fontName="PF Ronda Seven",mimeType="application/x-font")]
		// Flex 3.x sdk:
//		[Embed(source="/assets/pf_ronda_seven.ttf", fontName="PF Ronda Seven", mimeType="application/x-font")]
		
		//protected var Ronda:Class;
		protected static var m_con:Context;
		public static const LEFT:int = 0; //居左
		public static const CENTER:int = 1; //居中(横向和纵向都用此值)
		public static const RIGHT:int = 2; //居右
		
		public static const TOP:int = 0; //居上
		public static const BOTTOM:int = 2; //居下
		public var _width:Number = 0;
		public var _height:Number = 0;
		protected var _tag:int = 0;
		protected var m_disposed:Boolean;	//标志该对象是否已经执行过dispose()函数了
		protected var _enabled:Boolean = true;
		protected var _autoSizeByImage:Boolean = true;
		protected var _bNeedCheckImageLoaded:Boolean = true; //false -表明此Component对象不需要检测是是否已加载Image对象，例如，道具Icon对象
		//protected var _bInCheckIngForImageLoaded:Boolean; //当需要检测的时候，设置此变量为true.		
		protected var _bBeginCheckImageLoaded:Boolean; //是开始检测的那个对象
		private var _dropTrigger:Boolean;
		protected var m_bRecycleSkins:Boolean; //true-当设置其它skin对象时，将原Skin对象加入m_dicSkins
		protected var m_dicSkins:Dictionary; //
		public static const DRAW:String = "draw";
		
		protected var _skin:Skin;
		protected var m_picFilter:GradientGlowFilter; // 显示的图片的滤镜
		protected var m_liuguang:AniLiuguang;
		protected var m_scrollRectAni:AniScrollRect;
		protected var m_posAni:AniToDestPostion_BezierCurve1;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Component(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			setPos(xpos, ypos);
			
			if (parent != null)
			{
				parent.addChild(this);
			}
			addChildren();
			invalidate();
			this.tabEnabled = false;
		}
		
		/*
		 * 判断是否可见
		 */
		
		public function isVisible():Boolean
		{
			return this.visible;
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
		
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0, 1, dist, dist, .3, 1, knockout);
		}
		
		public function setLiuguangParam(lightWidth:Number, strength:Number, slope:Number, duration:Number, rangeBegin:Number, rangeEnd:Number):void
		{
			if (m_liuguang == null)
			{
				m_liuguang = new AniLiuguang(m_con);
				m_liuguang.host = this;				
			}
			m_liuguang.setParam(lightWidth, slope, strength, duration, rangeBegin, rangeEnd);			
		}
		public function beginLiuguang():void
		{
			m_liuguang.begin();
		}
		public function stopLiuguang():void
		{
			if(m_liuguang)
			{
				m_liuguang.stop();
			}
		}
		public function setScrollRectAniParam(initWidth:Number, initHeight:Number, speed:Number):void
		{
			if (m_scrollRectAni == null)
			{
				m_scrollRectAni = new AniScrollRect();
				m_scrollRectAni.host = this;				
			}
			m_scrollRectAni.setParam(initWidth, initHeight, speed);			
		}
		public function beginScrollRectAni():void
		{
			m_scrollRectAni.begin();
		}
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		public function invalidate():void
		{
//			draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		public function isInvalidate():Boolean
		{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number, funOnEnd:Function=null):void
		{
			if (m_posAni == null)
			{
				m_posAni = new AniToDestPostion_BezierCurve1();
				m_posAni.sprite = this;
				m_posAni.speed = 500;
			}
			m_posAni.onEnd = funOnEnd;
			m_posAni.setDestPos(xpos, ypos);
			m_posAni.begin();
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}
		
		public function setPos(xPos:Number, yPos:Number):void
		{
			x = Math.round(xPos);
			y = Math.round(yPos);
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			//dispatchEvent(new Event(Component.DRAW));
			if (isDropTrigger() == true)
			{
				drawRectBG();
			}
			if (_skin)
			{
				_skin.draw();
			}
		}
		
		public function drawRectBG():void
		{
			this.graphics.beginFill(0x90301, 0.0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		public function debugdrawRect():void
		{
			this.graphics.beginFill(0x90301, 1);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		//让自己成为p的child
		public function addSelfToDisplayList(p:DisplayObjectContainer):void
		{
			if (this.parent != p)
			{
				p.addChild(this);
			}
		}
		
		//将自己从显示列表中移除，或者说，让自己失去parent
		public function removeSelfFromDisplayList():void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function addBackgroundChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		public function removeBackgroundChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			return child;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		public function getGlobalLocation(rv:IntPoint = null):IntPoint
		{
			var gp:Point = localToGlobal(new Point(0, 0));
			if (rv != null)
			{
				rv.setLocationXY(gp.x, gp.y);
				return rv;
			}
			else
			{
				return new IntPoint(gp.x, gp.y);
			}
		}
		
		/**
		 * Sets whether this component can trigger dragging component to fire drag events
		 * when dragging over to this component.
		 * @param b true to make this component to be a trigger that trigger drag and drop
		 * action to fire events, false not to do that things.
		 * @see #ON_DRAG_ENTER
		 * @see #ON_DRAG_OVER
		 * @see #ON_DRAG_EXIT
		 * @see #ON_DRAG_DROP
		 * @see #isDropTrigger()
		 */
		public function setDropTrigger(b:Boolean):void
		{
			_dropTrigger = b;
		}
		
		/**
		 * Returns whether this component can trigger dragging component to fire drag events
		 * when dragging over to this component.(Default value is false)
		 * @return true if this component is a trigger that can trigger drag and drop action to
		 * fire events, false it is not.
		 * @see #ON_DRAG_ENTER
		 * @see #ON_DRAG_OVER
		 * @see #ON_DRAG_EXIT
		 * @see #ON_DRAG_DROP
		 * @see #setDropTrigger()
		 */
		public function isDropTrigger():Boolean
		{
			return _dropTrigger;
		}
		
		public function isDragAcceptableInitiator(com:Component):Boolean
		{
			return false;
		}
		
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragEnterEvent(dragInitiator:Component, sourceData:SourceData, mousePos:IntPoint, relatedTarget:Component):void
		{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
		
		/**
		 * @private
		 * Fires DRAG_OVERRING event.(Note, this method is only for DragManager use)
		 */
		public function fireDragOverringEvent(dragInitiator:Component, sourceData:SourceData, mousePos:IntPoint):void
		{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING, dragInitiator, sourceData, mousePos, this));
		}
		
		/**
		 * @private
		 * Fires DRAG_EXIT event.(Note, this method is only for DragManager use)
		 */
		public function fireDragExitEvent(dragInitiator:Component, sourceData:SourceData, mousePos:IntPoint, relatedTarget:Component):void
		{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
		
		/**
		 * @private
		 * Fires DRAG_DROP event.(Note, this method is only for DragManager use)
		 */
		public function fireDragDropEvent(dragInitiator:Component, sourceData:SourceData, mousePos:IntPoint):void
		{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_DROP, dragInitiator, sourceData, mousePos, this));
		}
		
		protected function useRecycleSkined(fullResName:String):Boolean
		{			
			if (_skin && _skin.imageName == fullResName)
			{
				return true;
			}
			if (m_dicSkins[fullResName] != undefined)
			{
				skin = m_dicSkins[fullResName];
				return true;
			}
			return false;
		}
		
		/*
		 * 设置PanelImage类型的图片
		 * resName是包含路径的图片名称
		 * mode - 图片的处理方式，见Image.MirrorMode_HOR等定义
		 */
		public function setPanelImageSkinMirror(resName:String, mode:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName+mode))
			{			
				return;
			}

			var panelSkin:PanelImageSkin = new PanelImageSkin();
			this.skin = panelSkin;
			panelSkin.setImageMirror(resName, mode);
		
		}
		
		/*
		 * 是setPanelImageSkinMirror函数的SWF版本，即图片在swf对象中，className是类名
		 * mode - 图片的处理方式，见Image.MirrorMode_HOR等定义
		 */
		public function setPanelImageSkinMirrorBySWF(swf:SWFResource, className:String, mode:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className+mode))
			{			
				return;
			}
			var panelSkin:PanelImageSkin = new PanelImageSkin();
			this.skin = panelSkin;
			panelSkin.setImageModeBySWF(swf, className, mode);
		}
		
		/*
		 * 设置PanelImage类型的图片
		 * resName是包含路径的图片名称
		 */
		public function setPanelImageSkin(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			var panelSkin:PanelImageSkin = new PanelImageSkin();
			this.skin = panelSkin;
			panelSkin.setCommonImageByName(resName);
		}
		
		/*
		 * 是setPanelImageSkin函数的SWF版本，即图片在swf对象中，resName是类名
		 */
		public function setPanelImageSkinBySWF(swf:SWFResource, className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			var panelSkin:PanelImageSkin = new PanelImageSkin();
			this.skin = panelSkin;
			panelSkin.setImageBySWF(swf, className);
		}
		
		/*直接设置image对象，该对象可以不在CommonImageManager中.
		 */
		public function setPanelImageSkinByImage(image:Image):void
		{			
			var panelSkin:PanelImageSkin = new PanelImageSkin();
			this.skin = panelSkin;
			panelSkin.setImage(image);
		}
		
		/*
		 * 设置VerticalImage类型的图片
		 * resName是包含路径的图片名称
		 */
		public function setVerticalImageSkin(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			var panelSkin:VerticalImageSkin = new VerticalImageSkin();
			this.skin = panelSkin;
			panelSkin.setCommonImageByName(resName);
		}
		
		/*
		 * 是setVerticalImageSkin函数的SWF版本，即图片在swf对象中，className是类名
		 */
		public function setVerticalImageSkinBySWF(swf:SWFResource, className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			
			var panelSkin:VerticalImageSkin = new VerticalImageSkin();
			this.skin = panelSkin;
			panelSkin.setImageBySWF(swf, className);
		}
		
		/*
		 * 可以横向拉伸图片
		 * 设置ImageHorizontalRepeat类型的图片.该类型图片的中段以重复的(或叠加)的方式拉长.
		 * resName是包含路径的图片名称
		 */
		public function setHorizontalImageRepeatSkin(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			
			var panelSkin:SkinHorizontalImageRepeat = new SkinHorizontalImageRepeat();
			this.skin = panelSkin;
			panelSkin.setCommonImageByName(resName);
		}
		
		/*
		 * 可以横向拉伸图片
		 * 设置HorizontalImage类型的图片.该类型图片的中段以直接拉伸的方式拉长.
		 * resName是包含路径的图片名称
		 */
		public function setHorizontalImageSkin(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			
			var panelSkin:HorizontalImageSkin = new HorizontalImageSkin();
			this.skin = panelSkin;
			panelSkin.setCommonImageByName(resName);
		}
		
		/*
		 * 可以横向拉伸图片
		 * 直接设置image对象
		 * resName是包含路径的图片名称
		 */
		public function setHorizontalImageSkinByImage(image:Image):void
		{			
			var panelSkin:HorizontalImageSkin = new HorizontalImageSkin();
			this.skin = panelSkin;
			panelSkin.setImage(image);
		}
		
		/*
		 * 是setHorizontalImageSkin函数的SWF版本，即图片在swf对象中，className是类名
		 */
		public function setHorizontalImageSkinBySWF(swf:SWFResource, className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			
			var panelSkin:HorizontalImageSkin = new HorizontalImageSkin();
			this.skin = panelSkin;
			panelSkin.setImageBySWF(swf, className);
		}
		
		public function setSkinForm(resName:String):void
		{
			resName = "commoncontrol/form/" + resName;
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			var localSkin:SkinForm = new SkinForm();
			this.skin = localSkin;
			localSkin.setCommonImageByName(resName);
		}
		
		/*
		 * 是setSkinGrid9Image9函数的SWF版本，即图片在swf对象中，className是类名
		 */
		public function setSkinGrid9Image9BySWF(swf:SWFResource, className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			
			var lSkin:SkinGrid9Image9 = new SkinGrid9Image9();
			this.skin = lSkin;
			lSkin.setImageBySWF(swf, className);
		}
		
		/*
		 * 设置ImageGrid9类型的图片.(九宫格图片)
		 * resName是包含路径的图片名称
		 */
		public function setSkinGrid9Image9(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{			
				return;
			}
			
			var lSkin:SkinGrid9Image9 = new SkinGrid9Image9();
			this.skin = lSkin;
			lSkin.setImageByName(resName);
		}
		
		/*
		 * 设置ImageGrid9类型的图片.(九宫格图片)
		 * resName是包含路径的图片名称
		 */
		public function setSkinGrid9ImageStretching(resName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName))
			{
				return;
			}
			
			var lSkin:SkinGrid9ImageStretching = new SkinGrid9ImageStretching();
			this.skin = lSkin;
			lSkin.setCommonImageByName(resName);
		}
		/*
		 * 直接设置ImageGrid9类型的图片.(九宫格图片)
		 *
		 */
		public function setSkinGrid9Image9ByImage(image:Image):void
		{
			var panelSkin:SkinGrid9Image9 = new SkinGrid9Image9();
			this.skin = panelSkin;
			panelSkin.setImage(image);
		}
		
		/*
		 * 设置ImageGrid9类型的图片.(九宫格图片),与setSkinGrid9Image9不同的一点在于:
		 * resName是包含路径的图片名称
		 */
		public function setSkinGrid9ImageOneBySWF(swf:SWFResource, className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			var lSkin:SkinGrid9ImageOne = new SkinGrid9ImageOne();
			this.skin = lSkin;
			lSkin.setImageBySWF(swf, className);
		}
		
		/*
		 * 设置ImageGrid9类型的图片.(九宫格图片),与setSkinGrid9Image9不同的一点在于: 此函数会把九宫格的各个部分画到一张图片上
		 * resName是包含路径的图片名称
		 */
		public function setSkinGrid9ImageOne(className:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(className))
			{			
				return;
			}
			
			var lSkin:SkinGrid9ImageOne = new SkinGrid9ImageOne();
			this.skin = lSkin;
			lSkin.setCommonImageByName(className);
		}
		//设置拼接图片
		public function setSkinImagePinjie(resName:String):void
		{
			var lSkin:SkinImagePinjie = new SkinImagePinjie();
			this.skin = lSkin;
			lSkin.setCommonImageByName(resName);
		}
		public function dispose():void
		{
			var i:int;
			var component:DisplayObject;
			for (i = 0; i < this.numChildren; i++)
			{
				component = this.getChildAt(i);
				if (component.hasOwnProperty("dispose"))
				{
					component["dispose"].apply(null, null);
					
				}
			}
			
			if (m_bRecycleSkins)
			{
				var sn:Skin;
				m_bRecycleSkins = false;
				if (_skin != null)
				{
					if (m_dicSkins[_skin.imageName] != undefined)
					{
						delete m_dicSkins[_skin.imageName];
					}
					_skin.unInstall();
					_skin = null;
				}
				
				for each (sn in m_dicSkins)
				{
					sn.dispose();
				}
			}
			else
			{
				unSetSkin();
			}
			
			if (m_liuguang)
			{
				m_liuguang.dispose();
			}
			if (m_posAni)
			{
				m_posAni.dispose();
			}
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			m_disposed = true;
		}
		
		public function unSetSkin():void
		{
			if (_skin != null)
			{
				_skin.unInstall();
				_skin = null;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		
		public function get tag():int
		{
			return _tag;
		}
		public function get isDisposed():Boolean
		{
			return m_disposed;
		}
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		public function get imageName():String
		{
			if (skin)
			{
				return skin.imageName;
			}
			return null;
		}
		
		public function set recycleSkins(flag:Boolean):void
		{
			m_bRecycleSkins = flag;
			m_dicSkins = new Dictionary();
		}
		
		public function get recycleSkins():Boolean
		{
			return m_bRecycleSkins;
		}
		
		public function set needCheckImageLoaded(flag:Boolean):void
		{
			_bNeedCheckImageLoaded = flag;
		}
		
		//public function get isCheckImageLoaded():Boolean
		//{
		//	return _bInCheckIngForImageLoaded;
	//	}
		
		public function get isBeginCheckImageLoaded():Boolean
		{
			return _bBeginCheckImageLoaded;
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			
			//alpha = _enabled ? 1.0 : 0.5;
			if (_enabled == false)
			{
				this.becomeGray();
			}
			else
			{
				this.becomeUnGray();
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set autoSizeByImage(value:Boolean):void
		{
			_autoSizeByImage = value;
		}
		
		public function get autoSizeByImage():Boolean
		{
			return _autoSizeByImage;
		}
		
		public function get skin():Skin
		{
			return _skin;
		}
		
		public function set skin(value:Skin):void
		{
			if (_skin)
			{
				_skin.unInstall();
				if (m_bRecycleSkins)
				{
					m_dicSkins[_skin.imageName] = _skin;
				}
			}
			
			_skin = value;
			_skin.hostComponent = this; // as IHostComponent;
			_skin.init();
			invalidate();
		}
		
		public function get imageLoaded():Boolean
		{
			return skin.loaded;
		}
		
		public function getFirstImagesNameNotLoaded():Component
		{
			if (_bNeedCheckImageLoaded == false)
			{
				return null;
			}
			
			
			if (skin != null)
			{
				if (skin.hasLoadResult==false)
				{
					return this;
				}
			}
			
			var i:int;
			var component:DisplayObject;
			var num:int = this.numChildren;
			var ret:Component;
			for (i = 0; i < num; i++)
			{
				component = this.getChildAt(i);
				ret = component as Component;
				if (ret)
				{			
					ret = ret.getFirstImagesNameNotLoaded();
					if (ret)
					{
						return ret ;
					}
				}
			}
			
			return null;
		}
		
		//判断自己及其自己的孩子们的Image对象是否已加载完毕
		public function isAllImagesLoaded():Boolean
		{
			if (_bNeedCheckImageLoaded == false)
			{
				return true;
			}
			
			//if (ingoreChecking == false)
			//{
			//	if (_bInCheckIngForImageLoaded == false)
			//	{
			//		return true;
			//	}
			//}
			
			if (skin != null)
			{
				if (skin.hasLoadResult==false)
				{
					return false;
				}
			}
			
			var i:int;
			var component:DisplayObject;
			var num:int = this.numChildren;
			for (i = 0; i < num; i++)
			{
				component = this.getChildAt(i);
				if (component is Component)
				{
					if (false == (component as Component).isAllImagesLoaded())
					{
						return false;
					}
				}
			}
			
			return true;
		
		}
		
		public function checkImageLoaded():void
		{
			if (isAllImagesLoaded())
			{
				return;
			}
			
			//_bInCheckIngForImageLoaded = true;
			this.addEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);
			this.addEventListener(UIEvent.IMAGEFAILED, onCheckImageLoaded);
			
			var i:int;
			var component:DisplayObject;
			var num:int = this.numChildren;
			for (i = 0; i < num; i++)
			{
				component = this.getChildAt(i);
				if (component is Component)
				{
					(component as Component).checkImageLoaded();
				}
			}
		}
		
		public function beginCheckImageLoaded():void
		{
			if (isAllImagesLoaded())
			{
				this.dispatchEvent(new UIEvent(UIEvent.AllIMAGELOADED));
			}
			else
			{
				_bBeginCheckImageLoaded = true;
				checkImageLoaded();
			}
		}
		
		//当自己Image对象加载完，或者，某个孩子的Image及其全部子孩子的Image全部加载完毕.这2种情况下，onImageLoaded会收到事件
		public function onCheckImageLoaded(e:UIEvent):void
		{
			//if (_bInCheckIngForImageLoaded == false)
			//{
			//	return;
			//}			
			if (isAllImagesLoaded())
			{
				this.removeEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);
				this.removeEventListener(UIEvent.IMAGEFAILED, onCheckImageLoaded);
				/*var bStopEvent:Boolean = true;
				if (this.parent is Component)
				{
					if ((this.parent as Component).isCheckImageLoaded)
					{
						bStopEvent = false;
					}
				}
				
				if (bStopEvent)
				{
					e.stopPropagation();
				}*/
				
				if (_bBeginCheckImageLoaded == true)
				{
					this.dispatchEvent(new UIEvent(UIEvent.AllIMAGELOADED));
				}
			}
			else
			{
				e.stopPropagation();
			}
		}
		
		
		
		public function localToScreen(pt:Point = null):Point
		{
			if (pt == null)
			{
				pt = new Point(0, 0);
			}
			return m_con.golbalToScreen(this.localToGlobal(pt));
		}
		
		//计算自己相对于父亲relativeParent的位置。relativeParent可以不是自己的直接父亲。
		public function posInRelativeParent(relativeParent:DisplayObjectContainer):Point
		{
			var ret:Point = new Point(this.x, this.y);
			var p:DisplayObjectContainer = this.parent;
			while (p)
			{
				if (p == relativeParent)
				{
					break;
				}
				ret.x += p.x;
				ret.y += p.y;
				p = p.parent;
			}
			return ret;
		}
		
		/*
		 * com到this的偏移量
		 * shareParent是this与com的共同父亲（可以不是直接fuqin)
		 */ 
		public function offsetOf(com:Component, shareParent:Component):Point
		{
			var thisPT:Point = posInRelativeParent(shareParent);
			var comPT:Point = com.posInRelativeParent(shareParent);
			var retPT:Point = new Point(comPT.x - thisPT.x, comPT.y - thisPT.y);
			return retPT;
		}
		
		public function becomeGray():void
		{
			this.filters = [UtilFilter.createGrayFilter()];
		}
		
		public function becomeUnGray():void
		{
			this.filters = null;
		}
		
		//public function is
		public static function setContext(con:Context):void
		{
			m_con = con;
		}
		
		public function listenAddedToStageEvent():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		protected function onAddedToStage(e:Event):void
		{
			
		}
		public function filtersAttr(badd:Boolean, dic:Dictionary = null):void
		{
			if (badd)
			{
				//if(!this.filters)
				{
					if (!m_picFilter)
					{
						m_picFilter = PBUtil.buildGradientGlowFilter(dic);
					}
					
					this.filters = [m_picFilter];
				}
			}
			else
			{
				this.filters = null;
			}
		}
		public function findDisplay(funJudge:Function):DisplayObject
		{
			if (funJudge(this) == true)
			{
				return this;
			}
			var n:int = this.numChildren;
			var dis:DisplayObject;
			var ret:DisplayObject;
			for (var i:int=0; i < n; i++)
			{
				dis = this.getChildAt(i);
				if (funJudge(dis))
				{
					return dis;
				}
				else
				{
					if (dis is Component)
					{
						ret = (dis as Component).findDisplay(funJudge);
						if (ret)
						{
							return ret;
						}
					}
				}
			}
			return null;
		}
		override public function get stage():Stage 
		{
			return m_con.m_mainStage;
		}
	}
}