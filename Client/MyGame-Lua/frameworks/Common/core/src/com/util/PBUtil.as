package com.util
{
    import com.pblabs.engine.debug.Logger;
    import com.pblabs.engine.entity.EntityCValue;
    
    import flash.display.BitmapData;
   // import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilterType;
    import flash.filters.GradientGlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
     * Contains math related utility methods.
     */
    public class PBUtil
    {
		public static const FLIP_HORIZONTAL:String = "flipHorizontal";
		public static const FLIP_VERTICAL:String = "flipVertical";
		public static const TRACESTACK:Boolean = false;	// 是否打印堆栈，release 下关闭，debug 下开启  
		public static var LOGGEROPEN:Boolean = true;	// 是否输出日志 
		public static var SocketReceiveLog:Boolean = false;	// Socket是否收到消息
        /**
         * Two times PI. 
         */
        public static const TWO_PI:Number = 2.0 * Math.PI;
        
        /**
         * Converts an angle in radians to an angle in degrees.
         * 
         * @param radians The angle to convert.
         * 
         * @return The converted value.
         */
        public static function getDegreesFromRadians(radians:Number):Number
        {
            return radians * 180 / Math.PI;
        }
        
        /**
         * Converts an angle in degrees to an angle in radians.
         * 
         * @param degrees The angle to convert.
         * 
         * @return The converted value.
         */
        public static function getRadiansFromDegrees(degrees:Number):Number
        {
            return degrees * Math.PI / 180;
        }
		
        /**
         * Keep a number between a min and a max.
         */
        public static function clamp(v:Number, min:Number = 0, max:Number = 1):Number
        {
            if(v < min) return min;
            if(v > max) return max;
            return v;
        }
		
		/**
		 * Clones an array.
		 * @param array Array to clone.
		 * @return a cloned array.
		 */
		public static function cloneArray(array:Array):Array
		{
			var newArray:Array = [];

			for each (var item:* in array)
				newArray.push(item);
			
			return newArray;
		}
		
		/**
		 * Take a radian measure and make sure it is between -pi..pi. 
		 */
		public static function unwrapRadian(r:Number):Number 
		{ 
			r = r % TWO_PI;
			if (r > Math.PI) 
				r -= TWO_PI; 
			if (r < -Math.PI) 
				r += TWO_PI; 
			return r; 
		} 
        
        /**
         * Take a degree measure and make sure it is between -180..180.
         */
        public static function unwrapDegrees(r:Number):Number
        {
            r = r % 360;
            if (r > 180)
                r -= 360;
            if (r < -180)
                r += 360;
            return r;
        }

        /**
         * Return the shortest distance to get from from to to, in radians.
         */
        public static function getRadianShortDelta(from:Number, to:Number):Number
        {
            // Unwrap both from and to.
            from = unwrapRadian(from);
            to = unwrapRadian(to);
            
            // Calc delta.
            var delta:Number = to - from;
            
            // Make sure delta is shortest path around circle.
            if(delta > Math.PI)
                delta -= TWO_PI;            
            if(delta < -Math.PI)
                delta += TWO_PI;            
            
            // Done
            return delta;
        }
        
        /**
         * Return the shortest distance to get from from to to, in degrees.
         */
        public static function getDegreesShortDelta(from:Number, to:Number):Number
        {
            // Unwrap both from and to.
            from = unwrapDegrees(from);
            to = unwrapDegrees(to);
            
            // Calc delta.
            var delta:Number = to - from;
            
            // Make sure delta is shortest path around circle.
            if(delta > 180)
                delta -= 360;            
            if(delta < -180)
                delta += 360;            
            
            // Done
            return delta;
        }

        /**
         * Get number of bits required to encode values from 0..max.
         *
         * @param max The maximum value to be able to be encoded.
         * @return Bitcount required to encode max value.
         */
        public static function getBitCountForRange(max:int):int
        {
			var count:int = 0;

			// Unfortunately this is a bug with this method... and requires this special
			// case (same issue with the old method log calculation)
			if (max == 1) return 1;

			max--;
			while (max >> count > 0) count++;
			return count;
        }
        
        /**
         * Pick an integer in a range, with a bias factor (from -1 to 1) to skew towards
         * low or high end of range.
         *  
         * @param min Minimum value to choose from, inclusive.
         * @param max Maximum value to choose from, inclusive.
         * @param bias -1 skews totally towards min, 1 totally towards max.
         * @return A random integer between min/max with appropriate bias.
         * 
         */
        public static function pickWithBias(min:int, max:int, bias:Number = 0):int
        {
            return clamp((((Math.random() + bias) * (max - min)) + min), min, max);
        }
        
        /**
         * Assigns parameters from source to destination by name.
         * 
         * <p>This allows duck typing - you can accept a generic object
         * (giving you nice {foo:bar} syntax) and cast to a typed object for
         * easier internal processing and validation.</p>
         * 
         * @param source Object to read fields from.
         * @param destination Object to assign fields to.
         * @param abortOnMismatch If true, throw an error if a field in source is absent in destination.
         * 
         */
        public static function duckAssign(source:Object, destination:Object, abortOnMismatch:Boolean = false):void
        {
            for(var field:String in source)
            {
                try
                {
                    // Try to assign.
                    destination[field] = source[field];
                }
                catch(e:Error)
                {
                    // Abort or continue, depending on user settings.
                    if(!abortOnMismatch)
                        continue;
                    throw new Error("Field '" + field + "' in source was not present in destination.");
                }
            }
        }
		
        /**
         * Calculate length of a vector. 
         */
        public static function xyLength(x:Number, y:Number):Number
        {
            return Math.sqrt((x*x)+(y*y));
        }
        
		/**
		 * Replaces instances of less then, greater then, ampersand, single and double quotes.
		 * @param str String to escape.
		 * @return A string that can be used in an htmlText property.
		 */		
		public static function escapeHTMLText(str:String):String
		{
			var chars:Array = 
			[
				{char:"&", repl:"|amp|"},
				{char:"<", repl:"&lt;"},
				{char:">", repl:"&gt;"},
				{char:"\'", repl:"&apos;"},
				{char:"\"", repl:"&quot;"},
				{char:"|amp|", repl:"&amp;"}
			];
			
			for(var i:int=0; i < chars.length; i++)
			{
				while(str.indexOf(chars[i].char) != -1)
				{
					str = str.replace(chars[i].char, chars[i].repl);
				}
			}
			
			return str;
		}
		
		/**
		 * Converts a String to a Boolean. This method is case insensitive, and will convert 
		 * "true", "t" and "1" to true. It converts "false", "f" and "0" to false.
		 * @param str String to covert into a boolean. 
		 * @return true or false
		 */		
		public static function stringToBoolean(str:String):Boolean
		{
			switch(str.substring(1, 0).toUpperCase())
			{
				case "F":
				case "0":
					return false;
					break;
				case "T":
				case "1":
					return true;
					break;
			}
			
			return false;
		}
        
		/**
		 * Capitalize the first letter of a string 
		 * @param str String to capitalize the first leter of
		 * @return String with the first letter capitalized.
		 */		
		public static function capitalize(str:String):String
		{
			return str.substring(1, 0).toUpperCase() + str.substring(1);
		}
		
		/**
		 * Removes all instances of the specified character from 
		 * the beginning and end of the specified string.
		 */
		public static function trim(str:String, char:String):String {
			return trimBack(trimFront(str, char), char);
		}
		
		/**
		 * Recursively removes all characters that match the char parameter, 
		 * starting from the front of the string and working toward the end, 
		 * until the first character in the string does not match char and returns 
		 * the updated string.
		 */		
		public static function trimFront(str:String, char:String):String
		{
			char = stringToCharacter(char);
			if (str.charAt(0) == char) {
				str = trimFront(str.substring(1), char);
			}
			return str;
		}
		
		/**
		 * Recursively removes all characters that match the char parameter, 
		 * starting from the end of the string and working backward, 
		 * until the last character in the string does not match char and returns 
		 * the updated string.
		 */		
		public static function trimBack(str:String, char:String):String
		{
			char = stringToCharacter(char);
			if (str.charAt(str.length - 1) == char) {
				str = trimBack(str.substring(0, str.length - 1), char);
			}
			return str;
		}
		
		/**
		 * Returns the first character of the string passed to it. 
		 */		
		public static function stringToCharacter(str:String):String 
		{
			if (str.length == 1) {
				return str;
			}
			return str.slice(0, 1);
		}
		
        /**
         * Determine the file extension of a file. 
         * @param file A path to a file.
         * @return The file extension.
         * 
         */
        public static function getFileExtension(file:String):String
        {
            var extensionIndex:Number = file.lastIndexOf(".");
           if (extensionIndex == -1) {
                //No extension
                return "";
            } else {
                return file.substr(extensionIndex + 1,file.length);
            }
        }
        
		/**
		 * Method for flipping a DisplayObject 
		 * @param obj DisplayObject to flip
		 * @param orientation Which orientation to use: PBUtil.FLIP_HORIZONTAL or PBUtil.FLIP_VERTICAL
		 * 
		 */		
		public static function flipDisplayObject(obj:DisplayObject, orientation:String):void
		{
			var m:Matrix = obj.transform.matrix;
			
			switch (orientation) 
			{
				case FLIP_HORIZONTAL:
					m.a = -1 * m.a;
					m.tx = obj.width + obj.x;
					break;
				case FLIP_VERTICAL:
					m.d = -1 * m.d;
					m.ty = obj.height + obj.y;
					break;
			}
			
			obj.transform.matrix = m;
		}
		
		//横向镜像
		public static function flipBitmapDataHori(data:BitmapData):BitmapData
		{
			var buffer:BitmapData = new BitmapData(data.width, data.height, data.transparent, 0);
			var rect:Rectangle = new Rectangle(0, 0, 1, data.height);
			var destP:Point = new Point(data.width - 1, 0);
			
			for (var i:int = 0; i < data.width; i++)
			{
				buffer.copyPixels(data, rect, destP);
				rect.x ++;
				destP.x--;
			}
			return buffer;
		}
		
		//纵向镜像
		public static function flipBitmapDataVer(data:BitmapData):BitmapData
		{
			var buffer:BitmapData = new BitmapData(data.width, data.height, data.transparent, 0);
			var rect:Rectangle = new Rectangle(0, 0, data.width, 1);
			var destP:Point = new Point(0, data.height - 1);
			
			for (var i:int = 0; i < data.height; i++)
			{
				buffer.copyPixels(data, rect, destP);
				rect.y ++;
				destP.y--;
			}
			return buffer;
		}
		
		//顺时针旋转90度
		public static function flipBitmapDataClockwiseRotation90(data:BitmapData):BitmapData
		{
			var w:int = data.width;
			var h:int = data.height;
			var x:int;
			var y:int;
			var h1:int = h - 1;
			var xSor:int;
			var buffer:BitmapData = new BitmapData(data.height,data.width, data.transparent, 0);
			buffer.lock();				
			
			for (x = 0; x < h; x++)
			{
				xSor = h1 - x;
				for (y = 0; y < w; y++)
				{
					buffer.setPixel32(x, y, data.getPixel32(y, xSor));
				}
			}
			buffer.unlock();			
			
			return buffer;
		}
		
		//逆时针旋转90度
		public static function flipBitmapDataAnticlockwiseRotation90(data:BitmapData):BitmapData
		{
			var w:int = data.width;
			var h:int = data.height;
			var x:int;
			var y:int;
			var w1:int = w - 1;
			var ySor:int;
			var buffer:BitmapData = new BitmapData(data.height,data.width, data.transparent, 0);
			buffer.lock();
						
			for (y = 0; y < w; y++)
			{
				ySor = w1 - y;
				for (x = 0; x < h; x++)
				{
					buffer.setPixel32(x, y, data.getPixel32(ySor, x));
				}
			}
			buffer.unlock();			
			
			return buffer;
		}
		
		/*
		 * 将输入的几个BitmapData排成一横排，组合在一起。中间没有空隙。
		 * 前提：每个BitmapData的高度相等
		 */
		public static function composeBitmapDataHor(list:Vector.<BitmapData>):BitmapData
		{
			var i:uint;
			var width:uint;
			var height:uint;

			for (i = 0; i < list.length; i++)
			{
				width += list[i].width;
				if (height < list[i].height)
				{
					height = list[i].height;
				}
			}
			
			var ret:BitmapData = new BitmapData(width, height, true, 0);
			var rect:Rectangle = new Rectangle(0, 0, 0, height);
			var destP:Point = new Point();
			
			for (i = 0; i < list.length; i++)
			{				
				rect.width = list[i].width;
				rect.height = list[i].height;
				destP.y = (height - rect.height) / 2;
				ret.copyPixels(list[i], rect, destP);
				destP.x += rect.width;
			}
			return ret;			
		}
		
		
        /**
         * Log an object to the console. Based on http://dev.base86.com/solo/47/actionscript_3_equivalent_of_phps_printr.html 
         * @param thisObject Object to display for logging.
         * @param obj Object to dump.
         */
        public static function dumpObjectToLogger(thisObject:*, obj:*, level:int = 0, output:String = ""):String
        {
            var tabs:String = "";
            for(var i:int = 0; i < level; i++) tabs += "\t";
            
            for(var child:* in obj) {
                output += tabs +"["+ child +"] => "+ obj[child];
                
                var childOutput:String = dumpObjectToLogger(thisObject, obj[child], level+1);
                if(childOutput != '') output += ' {\n'+ childOutput + tabs +'}';
                
                output += "\n";
            }
            
            if(level == 0)
            {
                Logger.print(thisObject, output);
                return "";
            }
            
            return output;
        }
		
		// KBEN: 打印当前行号    
		public static function debug_printStackTrace():String
		{
			var st:String;
			var start:int;
			var end:int;
			var con:String;
			var conbake:String;
			
			try
			{
				throw new Error("stack trace");
			}
			catch (e:Error)
			{
				st = e.getStackTrace();
				start = st.indexOf("[", 0);
				start = st.indexOf("[", start + 1);
				start = st.indexOf("[", start + 1);
				
				end = st.indexOf("]", 0);
				end = st.indexOf("]", end + 1);
				end = st.indexOf("]", end + 1);

				con = st.substring(start + 1, end);
				con = con.replace(".as:", ".as(");
				con += "):";
			
				conbake = con.replace(/\\/, "/");
				while(conbake != con)
				{
					con = conbake;
					conbake = con.replace(/\\/, "/");
				}
				
				return conbake;
			}
			
			return "error";
		}
		
		// KBEN: 绘制不规则多边形     
		public static function drawNoRegPolygon(list:Vector.<Point>, graphics:Graphics, lineColor:uint = 0xFFFFFF, fillColor:uint = 0xFFFFFF):void
		{
			// 是否设置填充颜色    
			if (fillColor != 0)
			{
				graphics.beginFill(fillColor);
			}
			for(var i:int = 0; i <= list.length; ++i)
			{
				switch(i) 
				{
					case 0:
						graphics.lineStyle(1, lineColor);
						graphics.moveTo(list[i].x, list[i].y);
						break;
					default:
						graphics.lineTo(list[i].x, list[i].y);
				}
			}
			
			// 连接起始点，形成封闭多边形     
			graphics.lineTo(list[i].x, list[i].y);
			
			if (fillColor != 0)
			{
				graphics.endFill();
			}
		}
		
		// KBEN: 绘制规则多边形     
		public static function drawRegPolygon(graphics:Graphics, radius:int, segments:int, centerX:Number, centerY:Number, rotating:Number = 0, lineThickness:int = 1, lineColor:uint = 0xFFFFFF, fillColor:uint=0xFFFFFF):void
		{
			var points:Dictionary;
			var ratio:Number;
			var top:Number;
		
			points = new Dictionary();
			ratio = 360 / segments;
			top = centerY - radius;
			if (fillColor != 0)
			{
				graphics.beginFill(fillColor);
			}
			for(var i:int = rotating;i <= 360 + rotating; i += ratio)
			{
				var xx:Number = centerX + Math.sin(radians(i)) * radius;
				var yy:Number = top + (radius - Math.cos(radians(i)) * radius);
				points[i] = new Point(xx, yy);
				switch(i) 
				{
					case rotating:
						graphics.lineStyle(lineThickness, lineColor);
						graphics.moveTo(points[i].x, points[i].y);
						break;
					default:
						graphics.lineTo(points[i].x, points[i].y);
				}
			}
			if (fillColor != 0)
			{
				graphics.endFill();
			}
		}
		
		public static function drawRegPolygonX(graphics:Graphics, radius:int, segments:int, centerX:Number, centerY:Number, rotating:Number = 0, lineThickness:int = 1, lineColor:uint = 0xFFFFFF, fillColor:uint=0xFFFFFF):void
		{
			var points:Dictionary;
			var ratio:Number;
			
			points = new Dictionary();
			ratio = 360 / segments;
			if (fillColor != 0)
			{
				graphics.beginFill(fillColor);
			}
			for(var i:int = rotating;i <= 360 + rotating; i += ratio)
			{
				var xx:Number = centerX + Math.cos(radians(i)) * radius;
				var yy:Number = centerY + Math.sin(radians(i)) * radius;
				points[i] = new Point(xx, yy);
				switch(i) 
				{
					case rotating:
						graphics.lineStyle(lineThickness, lineColor);
						graphics.moveTo(points[i].x, points[i].y);
						break;
					default:
						graphics.lineTo(points[i].x, points[i].y);
				}
			}
			if (fillColor != 0)
			{
				graphics.endFill();
			}
		}
		
		private static function radians(n:Number):Number 
		{
			return(Math.PI/180*n);
		}
		
		// 生成过滤器
		public static function buildGradientGlowFilter(param:Dictionary = null):GradientGlowFilter
		{
			var picFilter:GradientGlowFilter = new GradientGlowFilter();
			//picFilter.distance = 0;
			//picFilter.angle = 45;
			//picFilter.colors = [0x000000, 0xFF0000];
			//picFilter.alphas = [0, 1];
			//picFilter.ratios = [0, 255];
			//picFilter.blurX = 10;
			//picFilter.blurY = 10;
			//picFilter.strength = 2;
			//picFilter.quality = BitmapFilterQuality.HIGH;
			//picFilter.type = BitmapFilterType.OUTER;
			
			var distance:uint = 0;
			var angle:uint = 45;
			var colorsa:uint = 0x000000;
			var colorsb:uint = 0x00FF00;
			var alphasa:uint = 0;
			var alphasb:uint = 1;
			var ratiosa:uint = 0;
			var ratiosb:uint = 255;
			var blurX:uint = 10;
			var blurY:uint = 10;
			
			var strength:uint = 2;
			var quality:uint = BitmapFilterQuality.HIGH;
			var type:String = BitmapFilterType.OUTER;
			
			if(param)
			{
				if(param[EntityCValue.distance])
				{
					distance = param[EntityCValue.distance];
				}
				if(param[EntityCValue.angle])
				{
					angle = param[EntityCValue.angle];
				}
				if(param[EntityCValue.colorsa])
				{
					colorsa = param[EntityCValue.colorsa];
				}
				if(param[EntityCValue.colorsb])
				{
					colorsb = param[EntityCValue.colorsb];
				}
				if(param[EntityCValue.alphasa])
				{
					alphasa = param[EntityCValue.alphasa];
				}
				if(param[EntityCValue.alphasb])
				{
					alphasb = param[EntityCValue.alphasb];
				}
				if(param[EntityCValue.ratiosa])
				{
					ratiosa = param[EntityCValue.ratiosa];
				}
				if(param[EntityCValue.ratiosb])
				{
					ratiosb = param[EntityCValue.ratiosb];
				}
				if(param[EntityCValue.blurX])
				{
					blurX = param[EntityCValue.blurX];
				}
				if(param[EntityCValue.blurY])
				{
					blurY = param[EntityCValue.blurY];
				}
				if(param[EntityCValue.strength])
				{
					strength = param[EntityCValue.strength];
				}
				if(param[EntityCValue.quality])
				{
					quality = param[EntityCValue.quality];
				}
				if(param[EntityCValue.type])
				{
					type = param[EntityCValue.type];
				}
			}
			
			picFilter.distance = distance;
			picFilter.angle = angle;
			picFilter.colors = [colorsa, colorsb];
			picFilter.alphas = [alphasa, alphasb];
			picFilter.ratios = [ratiosa, ratiosb];
			picFilter.blurX = blurX;
			picFilter.blurY = blurY;
			picFilter.strength = strength;
			picFilter.quality = quality;
			picFilter.type = type;
			
			return picFilter;
		}
    }
}