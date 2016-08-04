package modulefight.render
{
	//import com.adobe.images.JPGEncoder;
	//import com.bit101.components.VBox;
	import com.pblabs.engine.entity.BeingEntity;
	import com.util.DebugBox;
	import org.ffilmation.engine.helpers.fUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BitmapFilter;
	//import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//import flash.net.FileReference;
	//import flash.utils.ByteArray;
	
	import modulefight.scene.beings.BeingTail;
	import modulefight.scene.beings.NpcBattle;
	
	import org.ffilmation.engine.core.fElementContainer;
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	//import flash.display.Sprite;

	/**
	 * @brief 这个是渲染运动拖尾的，直接放在上面就行了，不再走规则流程
	 * */
	public class BitmapRenderer extends fElementContainer
	{
		protected var m_beingList:Vector.<BeingEntity>;
		protected var m_clearBeing:Vector.<BeingEntity>;	// 这里面的内容是需要清理的 
		protected static var ZERO_POINT:Point = new Point( 0, 0 );
		
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _preFilters:Array;
		protected var _postFilters:Array;

		protected var _smoothing:Boolean;
		protected var _canvas:Rectangle;
		protected var _clearBetweenFrames:Boolean;
		
		protected var m_clear:Boolean;		// 当前是否清除
		
		/**
		 * The constructor creates a BitmapRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 * 
		 * @param canvas The area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 * @param smoothing Whether to use smoothing when scaling the Bitmap and, if the
		 * particles are represented by bitmaps, when drawing the particles.
		 * Smoothing removes pixelation when images are scaled and rotated, but it
		 * takes longer so it may slow down your particle system.
		 * 
		 * @see org.flintparticles.twoD.emitters.Emitter#renderer
		 */
		public function BitmapRenderer( canvas:Rectangle, smoothing:Boolean = false )
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			_smoothing = smoothing;
			_preFilters = new Array();
			_postFilters = new Array();
			_canvas = canvas;
			createBitmap();
			_clearBetweenFrames = true;
			
			// 不过滤了，每一遍自己控制
			//addFilter( new BlurFilter( 2, 2, flash.filters.BitmapFilterQuality.LOW ) );
			m_beingList = new Vector.<BeingEntity>();
			m_clearBeing = new Vector.<BeingEntity>();
			m_clear = true;
		}
		
		/**
		 * The addFilter method adds a BitmapFilter to the renderer. These filters
		 * are applied each frame, before or after the new particle positions are 
		 * drawn, instead of wiping the display clear. Use of a blur filter, for 
		 * example, will produce a trail behind each particle as the previous images
		 * blur and fade more each frame.
		 * 
		 * @param filter The filter to apply
		 * @param postRender If false, the filter is applied before drawing the particles
		 * in their new positions. If true the filter is applied after drawing the particles.
		 */
		public function addFilter( filter:BitmapFilter, postRender:Boolean = false ):void
		{
			if( postRender )
			{
				_postFilters.push( filter );
			}
			else
			{
				_preFilters.push( filter );
			}
		}
		
		/**
		 * Removes a BitmapFilter object from the Renderer.
		 * 
		 * @param filter The BitmapFilter to remove
		 * 
		 * @see addFilter()
		 */
		public function removeFilter( filter:BitmapFilter ):void
		{
			for( var i:int = 0; i < _preFilters.length; ++i )
			{
				if( _preFilters[i] == filter )
				{
					_preFilters.splice( i, 1 );
					return;
				}
			}
			for( i = 0; i < _postFilters.length; ++i )
			{
				if( _postFilters[i] == filter )
				{
					_postFilters.splice( i, 1 );
					return;
				}
			}
		}
		
		/**
		 * The array of all filters being applied before rendering.
		 */
		public function get preFilters():Array
		{
			return _preFilters.slice();
		}
		
		public function set preFilters( value:Array ):void
		{
			var filter:BitmapFilter;
			for each( filter in _preFilters )
			{
				removeFilter( filter );
			}
			for each( filter in value )
			{
				addFilter( filter, false );
			}
		}
		
		/**
		 * The array of all filters being applied before rendering.
		 */
		public function get postFilters():Array
		{
			return _postFilters.slice();
		}
		
		public function set postFilters( value:Array ):void
		{
			var filter:BitmapFilter;
			for each( filter in _postFilters )
			{
				removeFilter( filter );
			}
			for each( filter in value )
			{
				addFilter( filter, true );
			}
		}
		
		/**
		 * Create the Bitmap and BitmapData objects
		 */
		protected function createBitmap():void
		{
			if( !_canvas )
			{
				return;
			}
			if( _bitmap && _bitmapData )
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			if( _bitmap )
			{
				removeChild( _bitmap );
				_bitmap = null;BitmapData
			}
			_bitmap = new Bitmap( null, "auto", _smoothing);
			//_bitmapData = new BitmapData( Math.ceil( _canvas.width ), Math.ceil( _canvas.height ), false, 0xFFFF0000 );
			try
			{
				_bitmapData = new BitmapData( Math.ceil( _canvas.width ), Math.ceil( _canvas.height ), true, 0 );
			}
			catch (e:Error)
			{
				var strLog:String = "BitmapRenderer::createBitmap() " + fUtil.keyValueToString("w",  _canvas.width, "h", _canvas.height);
				DebugBox.sendToDataBase(strLog);
				_bitmapData = null;
			}
			_bitmap.bitmapData = _bitmapData;
			addChild( _bitmap );
			_bitmap.x = _canvas.x;
			_bitmap.y = _canvas.y;
			
			//_bitmapData.fillRect(_canvas, 0xFF0000);
		}
		
		/**
		 * The canvas is the area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 */
		public function get canvas():Rectangle
		{
			return _canvas;
		}
		
		public function set canvas( value:Rectangle ):void
		{
			_canvas = value;
			createBitmap();
		}
		
		/**
		 * Controls whether the display is cleared between each render frame.
		 * If you use pre-render filters, this value is ignored and the display is
		 * not cleared. If you use no filters or only post-render filters, this value 
		 * governs whether the screen is cleared.
		 * 
		 * <p>For BitmapRenderer and PixelRenderer, this value defaults to true.
		 * For BitmapLineRenderer it defaults to false.</p>
		 */
		public function get clearBetweenFrames():Boolean
		{
			return _clearBetweenFrames;
		}
		
		public function set clearBetweenFrames( value:Boolean ):void
		{
			_clearBetweenFrames = value;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		public function set smoothing( value:Boolean ):void
		{
			_smoothing = value;
			if( _bitmap )
			{
				_bitmap.smoothing = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function renderBeing():void
		{
			if( !_bitmap )
			{
				return;
			}
			if( !_bitmapData )
			{
				return;
			}
			// 如果没有要绘制的
			if(!m_beingList.length)
			{
				if(!m_clear)
				{
					m_clear = true;
					_bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
				}
				return;
			}
			
			// 每一次必然清除，自己重新绘制
			if( _clearBetweenFrames )
			{
				_bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
			}
			
			m_clear = false;
			var i:int;
			var len:int;
			_bitmapData.lock();
			//len = _preFilters.length;
			//for( i = 0; i < len; ++i )
			//{
				//_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _preFilters[i] );
			//}

			len = m_beingList.length;
			if ( len )
			{
				for( i = len; i--; ) // draw new particles first so they are behind old particles
				{
					if ((m_beingList[i] as NpcBattle).m_beingTail && (m_beingList[i] as NpcBattle).m_beingTail.length)
					{
						drawBeing(m_beingList[i]);
					}
					else
					{
						m_clearBeing.push(m_beingList[i]);
					}
				}
			}
			
			// 清理没有轨迹的
			var being:BeingEntity;
			var idx:int;
			for each(being in m_clearBeing)
			{
				idx = m_beingList.indexOf(being);
				m_beingList.splice(idx, 1);
			}
			
			m_clearBeing.length = 0;
			
			//len = _postFilters.length;
			//for( i = 0; i < len; ++i )
			//{
				//_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _postFilters[i] );
			//}
			_bitmapData.unlock();
		}
		
		/**
		 * Used internally here and in derived classes to alter the manner of 
		 * the particle rendering.
		 * 
		 * @param particle The particle to draw on the bitmap.
		 */
		protected function drawBeing(being:BeingEntity):void
		{
			var tail:BeingTail;
			var matrix:Matrix
			var colorMatrix:ColorTransform;
			for each(tail in (being as NpcBattle).m_beingTail)
			{
				matrix = new Matrix(1, 0, 0, 1, tail.m_posX + tail.m_offX, tail.m_posY + tail.m_offY);
				colorMatrix = new ColorTransform(1, 1, 1, tail.m_alpha, 0, 0, 0, 0)
				_bitmapData.draw(tail.m_image, matrix, colorMatrix, BlendMode.NORMAL, null, _smoothing);
			}
		}
		
		/**
		 * The bitmap data of the renderer.
		 */
		/*public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}*/
		
		public function addBeing(being:BeingEntity):void
		{
			// 如果没有的话才加入
			if(m_beingList.indexOf(being) < 0)
			{
				m_beingList.push(being);
			}
		}
		
		public function clearBeing(being:BeingEntity):void
		{
			var idx:int = m_beingList.indexOf(being);
			if(idx >= 0)
			{
				m_beingList.splice(idx, 1);
			}
		}
		
		// test: 测试保存图片 
		public function savePic():void
		{
			// KBEN: 打印测试     
			//var encode:JPGEncoder = new JPGEncoder(90);
			//var ba:ByteArray = encode.encode(_bitmapData);
			//var file:FileReference = new FileReference();
			//file.save(ba, "aaa.jpg");
		}
		
		// 释放所有的资源
		public function dispose():void
		{
			_bitmap.bitmapData = null;
			if (_bitmapData)
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			m_beingList.length = 0;
			m_clearBeing.length = 0;
		}
	}
}