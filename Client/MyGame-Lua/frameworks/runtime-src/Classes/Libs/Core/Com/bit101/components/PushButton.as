/**
 * PushButton.as
 * Keith Peters
 * version 0.9.10
 *
 * A basic button component with a label.
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
 */

package com.bit101.components
{
	//import adobe.utils.CustomActions;
	
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.image.Image;
	import com.dgrigg.skins.ISkinButtonPanelDrawCreator;
	import com.dgrigg.skins.SkinButtonPanelDraw;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	//import com.dgrigg.minimalcomps.skins.Skin;
	//import com.dgrigg.minimalcomps.skins.VScrollSliderSkin;
	import com.dgrigg.skins.ButtonImageSkin;
	import com.dgrigg.skins.SkinButton1Image;
	import com.dgrigg.skins.SkinButton1ImagePanelDraw;
	import com.dgrigg.skins.SkinButton2Image;
	import com.dgrigg.skins.SkinButton2ImageAndImageCaptionForTab;
	import com.dgrigg.skins.SkinButton2ImageForTab;
	import com.dgrigg.skins.SkinButtonHorizontalImage;
	import com.dgrigg.skins.SkinButtonImageGrid9;
	import com.dgrigg.skins.SkinButtonVertical;
	//import com.dgrigg.utils.SkinManager;
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.UtilFilter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	//import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PushButton extends Component
	{
		public static const BNMCom:uint = 0; // 普通点击需要有声音
		public static const BNMOpen:uint = 1; // 打开界面不需要有声音
		public static const BNMPage:uint = 2; // 翻页需要有声音
		public static const BNMClose:uint = 3; // 关闭界面不需要有声音
		
		public static const LabelWidthComputetype_Hand:int = 0; //通过labelStrW计算宽度
		public static const LabelWidthComputetype_auto:int = 1; //Label自己算出的宽度
		
		protected static var s_vecFilters:Vector.<Array>;
		
		protected var _backgroundContainer:Sprite;
		protected var _state:int; //UIConst.EtBtnSelected等值
		protected var _over:Boolean = false; //true - 鼠标在按钮上
		protected var _down:Boolean = false; //true - 鼠标在按钮上按下后，还没有弹起状态中				
		protected var _onSetSkinFun:Function;
		public var m_musicType:uint; // 不同功能的音效播放不同的功能
		public var m_clkCB:Function; // 点击函数回调 
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The string to use for the initial label of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function PushButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				m_clkCB = defaultHandler;
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
			this.mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_backgroundContainer = new Sprite();
			_backgroundContainer.mouseEnabled = false;
			this.addChild(_backgroundContainer);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		override public function draw():void
		{
			super.draw();
			this.drawRectBG();
		}
		
		override public function dispose():void
		{
			m_con.m_mainStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			if (m_clkCB != null)
			{
				removeEventListener(MouseEvent.CLICK, m_clkCB);
				m_clkCB = null;
			}
			super.dispose();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			updateSkin(UIConst.EtBtnOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if (_down == false)
			{
				updateSkin(UIConst.EtBtnNormal);
			}
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			updateSkin(UIConst.EtBtnDown);
			
			m_con.m_mainStage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			// 音效
			if (m_con.m_gkcontext)
			{
				if (m_musicType == BNMCom) // 普通按钮
				{
					m_con.m_gkcontext.playMsc(3);
				}
				else if (m_musicType == BNMPage) // 翻页按钮
				{
					m_con.m_gkcontext.playMsc(5);
				}
			}
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_down = false;
			if (_over == true)
			{
				updateSkin(UIConst.EtBtnOver);
			}
			else
			{
				updateSkin(UIConst.EtBtnNormal);
			}
			m_con.m_mainStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function updateSkin(state:uint):void
		{
			if (skin == null)
			{
				return;
			}
			_state = state;
			skin.btnStateChange(state);
		}
		
		public function onSetSkin():void
		{
			if (_onSetSkinFun != null)
			{
				_onSetSkinFun();
				_onSetSkinFun = null;
			}
		}
		
		override public function setVerticalImageSkin(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:SkinButtonVertical = new SkinButtonVertical();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		public function setGrid9ImageSkin(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:SkinButtonImageGrid9 = new SkinButtonImageGrid9();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		override public function setHorizontalImageSkin(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:SkinButtonHorizontalImage = new SkinButtonHorizontalImage();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		override public function setPanelImageSkin(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:ButtonImageSkin = new ButtonImageSkin();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		override public function setPanelImageSkinByImage(image:Image):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:ButtonImageSkin = new ButtonImageSkin();
			this.skin = localSkin;
			localSkin.setImage(image);
		}
		
		override public function setPanelImageSkinMirror(resName:String, mode:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName + mode))
			{
				return;
			}
			var localSkin:ButtonImageSkin = new ButtonImageSkin();
			this.skin = localSkin;
			localSkin.setImageMirror(resName, mode);
		}
		
		override public function setPanelImageSkinBySWF(swf:SWFResource, name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:ButtonImageSkin = new ButtonImageSkin();
			this.skin = localSkin;
			localSkin.setImageBySWF(swf, name);
		}
		
		public function setSkinButton1Image(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(name))
			{
				return;
			}
			var localSkin:SkinButton1Image = new SkinButton1Image();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		public function setSkinButton1ImageBySWF(swf:SWFResource, imageName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton1Image = new SkinButton1Image();
			this.skin = localSkin;
			localSkin.setImageBySWF(swf, imageName);
		}
		
		public function setSkinButton1ImageMirror(resName:String, mode:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(resName + mode))
			{
				return;
			}
			var localSkin:SkinButton1Image = new SkinButton1Image();
			this.skin = localSkin;
			localSkin.setImageMirror(resName, mode);
		}
		
		public function setSkinButton1ImagePanelDraw(creator:PanelDrawCreator):void
		{
			var localSkin:SkinButton1ImagePanelDraw = new SkinButton1ImagePanelDraw();
			this.skin = localSkin;
			localSkin.setPanelDrawCreator(creator);
		}
		
		public function setSkinButtonPanelDraw(panelDrawCreator:ISkinButtonPanelDrawCreator):void
		{
			var localSkin:SkinButtonPanelDraw = new SkinButtonPanelDraw();
			this.skin = localSkin;
			localSkin.setPanelDrawCreator(panelDrawCreator);
		}
		
		public function refreshSkinButtonPanelDraw():void
		{
			var localSkin:SkinButtonPanelDraw = this.skin as SkinButtonPanelDraw;
			if (localSkin)
			{
				localSkin.refresh();
			}
		}
		
		public function setSkinButton2Image(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton2Image = new SkinButton2Image();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		public function setSkinButton2ImageBySWF(swf:SWFResource, imageName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton2Image = new SkinButton2Image();
			this.skin = localSkin;
			localSkin.setImageBySWF(swf, imageName);
		}
		
		public function setSkinButton2ImageForTab(name:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton2ImageForTab = new SkinButton2ImageForTab();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
		}
		
		public function setSkinButton2ImageForTabBySWF(swf:SWFResource, imageName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton2ImageForTab = new SkinButton2ImageForTab();
			this.skin = localSkin;
			localSkin.setImageBySWF(swf, imageName);
		}
		
		public function setSkinButton2ImageAndImageCaptionForTab(name:String, captionImageName:String):void
		{
			if (m_bRecycleSkins && useRecycleSkined(imageName))
			{
				return;
			}
			var localSkin:SkinButton2ImageAndImageCaptionForTab = new SkinButton2ImageAndImageCaptionForTab();
			this.skin = localSkin;
			localSkin.setCommonImageByName(name);
			localSkin.captionImageName = captionImageName;
		}
		
		public override function addBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.addChild(child);
			return child;
		}
		
		public override function removeBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.removeChild(child);
			return child;
		}
		
		public function set onSetSkinFun(fun:Function):void
		{
			_onSetSkinFun = fun;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		//实现按钮在不同状态下的亮暗状态。这里没有考虑UIConst.EtBtnSelected状态
		public static function s_funGetFilters(state:int):Array
		{
			if (s_vecFilters == null)
			{
				s_vecFilters = new Vector.<Array>(3);
				var arr:Array = [1, 0.76, 1.35];
				var i:int;
				for (i = 0; i < 3; i++)
				{
					s_vecFilters[i] = [UtilFilter.createLuminanceFilter(arr[i])];
				}
			}
			return s_vecFilters[state];
		}
		
		override public function beginLiuguang():void
		{
			if (m_liuguang == null)
			{
				setLiuguangParam(2, 6, -2, 1.5, -100, this.width + 200);
			}
			
			super.beginLiuguang();
		}
		
		public function getNormalBitmap():BitmapData
		{
			if (this.skin == null)
			{
				return null;
			}
			var bitmapData:BitmapData;
			if (skin is SkinButtonPanelDraw)
			{
				return (skin as SkinButtonPanelDraw).getNormalBitmapData();
			}
			return null;
		}
		
		public function get isDown():Boolean
		{
			return _down;
		}
	
	/*public function setEnabled(bFlag:Boolean):void
	   {
	   if (_enabled == bFlag)
	   {
	   return;
	   }
	
	   _enabled = bFlag;
	   this.mouseEnabled = bFlag;
	   if (_enabled == false)
	   {
	   this.becomeGray();
	   }
	   else
	   {
	   this.becomeUnGray();
	   }
	 }	*/
	}
}