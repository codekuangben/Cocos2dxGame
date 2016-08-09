package org.ffilmation.engine.helpers
{
	//import com.bit101.components.Panel;
	
	//import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.ffilmation.engine.datatypes.fPoint3d;
	
	/**
	 * @brief 每一个动作的图片序列定义包括 8 个方向的定义
	 */
	public class fActDefinition
	{
		// KBEN: 决定这个字段用数字实现，为了简单方便，每一个动作的帧数不能超过 45 帧   
		//protected var _directArr:Vector.<fActDirectDefinition>;
		protected var m_directDic:Dictionary;		// 还是用字典吧，八个方向不一定都有，有的方向是没有的 
		// 当前动作帧数量    
		protected var _xCount:uint = 1;
		protected var _yCount:uint = 8; // KBEN: 人物默认是 8 个方向，特效默认是  1 个方向      
		// KBEN: 动画帧率 
		protected var _framerate:uint = 24;
		// KBEN: 帧率的倒数    
		protected var _framerateInv:Number = 0.04166;
		// KBEN: 是否重复   
		protected var _repeat:Boolean = true;
		// KBEN: 每一个动作可以定义不同的资源，资源路径，包括文件名字，暂时没用  
		//protected var _mediaPath:String;
		// KBEN: 图片总的数量，特效使用，因为特效的总的数量是不一定的，可能最后一排不是完整的 
		protected var _total:uint = 10;
		// KBEN:与 fObjectDefinition 中的同名变量其实是同一个变量 
		protected var _objType:int = fEngineCValue.MdMovieClip; // 对象类型，如果是 0 模型就是 MovieClip， 1 是图片序列 2 是全部在整张图上 
		protected var _bInit:Boolean = false;		// 这个动作是否初始化  
		protected var _actID:uint = 0;	// 就是动作的编号，这个还没有处理   
		//protected var _resPack:Boolean = false;	// false: 每一个动作的每一个方向都在单独的打包文件中    true:每一个动作在一个包里     
		
		/**
		 * The width of each frame.
		 */
		private var _width:int = 32;
		
		/**
		 * The height of each frame.
		 */
		private var _height:int = 32;
		/**
		 * The horizonal spacing between frames
		 */
		private var _horizontalSpacing:int = 0;
		
		/**
		 * The vertical spacing between frames
		 */
		private var _verticalSpacing:int = 0;
		
		public function fActDefinition()
		{
			//_directDic = new Dictionary();
			//_directArr = new Vector.<fActDirectDefinition>();
			m_directDic = new Dictionary();
		}
		
		//public function get directDic():Dictionary
		//{
		//return _directDic;
		//}
		//
		//public function set directDic(value:Dictionary):void
		//{
		//_directDic = value;
		//}
		
		public function get xCount():uint
		{
			return _xCount;
		}
		
		public function set xCount(value:uint):void
		{
			_xCount = value;
		}
		
		public function get yCount():uint
		{
			return _yCount;
		}
		
		public function set yCount(value:uint):void
		{
			_yCount = value;
		}
		
		public function get frameCount():int
		{
			return _xCount * _yCount;
		}
		
		//public function get directArr():Vector.<fActDirectDefinition>
		//{
		//	return _directArr;
		//}
		
		public function get directDic():Dictionary
		{
			return m_directDic;
		}
		
		public function get framerate():uint
		{
			return _framerate;
		}
		
		public function set framerate(value:uint):void
		{
			_framerate = value;
			_framerateInv = 1.0 / _framerate;
		}
		
		public function get repeat():Boolean
		{
			return _repeat;
		}
		
		public function set repeat(value:Boolean):void
		{
			_repeat = value;
		}
		
		//public function get mediaPath():String
		//{
		//	return _mediaPath;
		//}
		
		//public function set mediaPath(value:String):void
		//{
		//	_mediaPath = value;
		//}
		
		public function get total():uint
		{
			return _total;
		}
		
		public function set total(value:uint):void
		{
			_total = value;
		}
		
		public function get objType():int
		{
			return _objType;
		}
		
		public function set objType(value:int):void
		{
			_objType = value;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
		}
		
		public function get horizontalSpacing():int 
		{
			return _horizontalSpacing;
		}
		
		public function set horizontalSpacing(value:int):void 
		{
			_horizontalSpacing = value;
		}
		
		public function get verticalSpacing():int 
		{
			return _verticalSpacing;
		}
		
		public function set verticalSpacing(value:int):void 
		{
			_verticalSpacing = value;
		}
		
		public function get bInit():Boolean 
		{
			return _bInit;
		}
		
		public function set bInit(value:Boolean):void 
		{
			_bInit = value;
		}
		
		public function get framerateInv():Number 
		{
			return _framerateInv;
		}
		
		//public function get resPack():Boolean 
		//{
		//	return _resPack;
		//}
		
		//public function set resPack(value:Boolean):void 
		//{
		//	_resPack = value;
		//}
		
		public function get actID():uint 
		{
			return _actID;
		}
		
		public function set actID(value:uint):void 
		{
			_actID = value;
		}
		
		public function getFrameArea(index:int):Rectangle
		{
			if (_objType == fEngineCValue.MdPicOne || _objType == fEngineCValue.MdEffPicOne) // 在一张图上的矩形区域     
			{
				var x:int = index % _xCount;
				var y:int = Math.floor(index / _yCount);
				
				return new Rectangle(x * (_width + _horizontalSpacing), y * (_height + _verticalSpacing), _width, _height);
			}
			else // 在不同图上的区域      
			{
				return new Rectangle(0, 0, _width, _height);
			}
		}
		
		// 从一个对象拷贝另外一个对象    
		public function copyFrom(rh:fActDefinition):void
		{
			//var srcActDirDef:fActDirectDefinition;
			//var destActDirDef:fActDirectDefinition;
			//for (var k:int = 0; k < rh._directArr.length; ++k)
			//{
			//	srcActDirDef = rh._directArr[k];
			//	destActDirDef = new fActDirectDefinition();
			//	destActDirDef.copyFrom(srcActDirDef);
			//	this._directArr.push(destActDirDef);
			//}
			
			//this._xCount = rh.xCount;
			//this._yCount = rh.yCount;
			//this._framerate = rh.framerate;
			//this._framerateInv = rh.framerateInv;
			//this._repeat = rh.repeat;
			
			//this._mediaPath = rh.mediaPath;
			//this._total = rh.total;
			//this._objType = rh.objType;
			//this._bInit = rh.bInit;
			//this._width = rh.width;
			//this._height = rh.height;
			//this._horizontalSpacing = rh.horizontalSpacing;
			//this._verticalSpacing = rh.verticalSpacing;
			
			//this._resPack = rh.resPack;
			
			var srcActDirDef:fActDirectDefinition;
			var destActDirDef:fActDirectDefinition;
			for (var k:String in rh.m_directDic)
			{
				srcActDirDef = rh.m_directDic[k];
				destActDirDef = new fActDirectDefinition();
				destActDirDef.copyFrom(srcActDirDef);
				this.m_directDic[k] = destActDirDef;
			}
			
			this._xCount = rh.xCount;
			this._yCount = rh.yCount;
			this._framerate = rh.framerate;
			this._framerateInv = rh.framerateInv;
			this._repeat = rh.repeat;
			
			//this._mediaPath = rh.mediaPath;
			this._total = rh.total;
			this._objType = rh.objType;
			this._bInit = rh.bInit;
			this._width = rh.width;
			this._height = rh.height;
			this._horizontalSpacing = rh.horizontalSpacing;
			this._verticalSpacing = rh.verticalSpacing;
			
			//this._resPack = rh.resPack;
		}
		
		public function overwriteAtt(rh:fActDefinition, ins:String):void
		{
//			// 新的导出文件动作方向只有五个，其它 3 个不再导出，因此这里补齐
//			var curangle:uint = 0;
//			var curIdx:uint = 0;
//			var frameidx:uint = 0;
//			var sprite:fSpriteDefinition;
//			var actDirect:fActDirectDefinition;
//			var dirIdx:uint = 0;
//			
//			var firch:String = ins.substr(0, 1);
//			
//			var postList:Vector.<Point> = new Vector.<Point>();
//			// 只有人物需要调整
//			if(firch == "c" && rh.directArr.length < 8)
//			{
//				while(curIdx < 8)
//				{
//					// 如果有 sprite 就说明是正确
//					if(curIdx < rh.directArr.length && curangle == rh.directArr[curIdx].angle)
//					{
//						if(rh.directArr[curIdx].spriteVec.length == 0)	// 这个说明缺少图片的定义，这个方向应该是没有图片的，随便拷贝一个就行了
//						{
//							frameidx = 0;
//							while(frameidx< rh.xCount)
//							{
//								sprite = new fSpriteDefinition(rh.directArr[curIdx].angle, null, null);
//								rh.directArr[curIdx].spriteVec.push(sprite);
//								++frameidx;
//							}
//						}
//					}
//					else	// 说明缺少这个方向的定义
//					{
//						// 这几个方向应该存在的，如果不存在，就随便找一个放进去
//						if(0 == curIdx || 1 == curIdx || 2 == curIdx || 3 == curIdx || 7 == curIdx)
//						{
//							rh.directArr.splice(curIdx, 0, rh.directArr[0]);
//						}
//						else
//						{
//							dirIdx = parseInt(this._directArr[curIdx].spriteVec[0].startName.substr(11, 1));
//							actDirect = new fActDirectDefinition();
//							rh.directArr.splice(curIdx, 0, actDirect);
//							if(dirIdx < curIdx)	// 如果这个内容已经有了
//							{
//								actDirect.copyFrom(rh.directArr[dirIdx]);
//								
//								// 修正角度
//								actDirect.angle = curIdx * 45;
//								frameidx = 0;
//								while(frameidx< rh.xCount)
//								{
//									rh.directArr[curIdx].spriteVec[frameidx].angle = actDirect.angle;
//									++frameidx;
//								}
//							}
//							else
//							{
//								postList.push(new Point(curIdx, dirIdx));
//							}
//						}
//					}
//					
//					curangle += 45;
//					++curIdx;
//				}
//				
//				curIdx = 0;
//				while(curIdx < postList.length)
//				{
//					rh.directArr[postList[curIdx].x].copyFrom(rh.directArr[postList[curIdx].y]);
//					
//					frameidx = 0;
//					while(frameidx< rh.xCount)
//					{
//						rh.directArr[curIdx].spriteVec[frameidx].angle = actDirect.angle;
//						++frameidx;
//					}
//					
//					++curIdx;
//				}
//			}
//			
//			// 根据帧的数量重新写 fActDirectDefinition中m_spriteVec 中帧的数量     
//			// 如果新的实例的帧多的话，就要填充
//			var srcActDirDef:fActDirectDefinition;
//			var k:int = 0
//			for (k = 0; k < this._directArr.length; ++k)
//			{
//				srcActDirDef = this._directArr[k];
//				srcActDirDef.changeFrameCnt(rh._xCount, ins, actID, version);
//				srcActDirDef.overwriteAtt(rh.directArr[k]);
//				
//				if (this._resPack)
//				{
//					if (rh.mediaPath.length)
//					{
//						this._mediaPath = rh.mediaPath;
//					}
//					else
//					{
//						this._mediaPath = ins + "_" + actID + ".swf";
//					}
//				}
//				else
//				{
//					srcActDirDef.adjustAtt(ins, actID, rh.resPack);
//				}
//			}
//			
//			this._xCount = rh.xCount;
//			this._yCount = rh.yCount;
//			this._framerate = rh.framerate;
//			this._framerateInv = rh.framerateInv;
//			// _repeat 人物只在模板中定义，特效需要拷贝过去       
//			//this._repeat = rh.repeat;
//			
//			//this._mediaPath = rh.mediaPath;
//			this._total = rh.total;
//			this._objType = rh.objType;
//			this._bInit = rh.bInit;
//			this._width = rh.width;
//			this._height = rh.height;
//			this._horizontalSpacing = rh.horizontalSpacing;
//			this._verticalSpacing = rh.verticalSpacing;
//			
//			this._resPack = rh._resPack;
//			
//			// X 翻转    
//			for (k = 0; k < this._directArr.length; ++k)
//			{
//				srcActDirDef = this._directArr[k];
//				if (srcActDirDef.flipMode)
//				{
//					//var refsrc:String = srcActDirDef.spriteVec[0].startName.substr(11, 1);
//					var refsrc:String = fUtil.getDirBySymbol(srcActDirDef.spriteVec[0].startName, ins);
//					
//					var refidx:int = parseInt(refsrc);
//					
//					//srcActDirDef.origin.x = rh.width - rh.directArr[k].origin.x;
//					// 兼容以前的内容
//					srcActDirDef.origin.x = -(rh.width + rh.directArr[refidx].origin.x);
//					srcActDirDef.origin.y = rh.directArr[refidx].origin.y;
//					
//					// 设置里面的
//					var cnt:uint = 0;
//					while (cnt < rh.xCount)
//					{
//						//srcActDirDef.spriteVec[cnt].origin.x = srcActDirDef.origin.x;
//						//srcActDirDef.spriteVec[cnt].origin.y = srcActDirDef.origin.y;
//						
//						srcActDirDef.spriteVec[cnt].origin.x = -(rh.directArr[refidx].spriteVec[cnt].picWidth + rh.directArr[refidx].spriteVec[cnt].origin.x);
//						srcActDirDef.spriteVec[cnt].origin.y = rh.directArr[refidx].spriteVec[cnt].origin.y;
//						
//						++cnt;
//					}
//					
//					// 现在都是负值
//					//if (srcActDirDef.origin.x < 0 || srcActDirDef.origin.y < 0)
//					if (srcActDirDef.origin.x > 0 || srcActDirDef.origin.y > 0)
//					{
//						throw new Error("overwriteAtt error");
//					}
//				}
//			}
			
			// 新的导出文件动作方向只有五个，其它 3 个不再导出，因此这里补齐
			var curangle:uint = 0;
			var curIdx:uint = 0;
			var frameidx:uint = 0;
			var sprite:fSpriteDefinition;
			var actDirect:fActDirectDefinition;
			var dirIdx:uint = 0;
			
			//var firch:String = ins.substr(0, 1);
			
			//var postList:Vector.<Point> = new Vector.<Point>();

			// 根据帧的数量重新写 fActDirectDefinition中m_spriteVec 中帧的数量     
			// 如果新的实例的帧多的话，就要填充
			var srcActDirDef:fActDirectDefinition;
			var k:String = "";
			for (k in this.m_directDic)
			{
				if(rh.directDic[k] && rh.directDic[k].spriteVec.length)		// 只有存在并且图片数量有的情况下才拷贝
				{
					srcActDirDef = this.m_directDic[k];
					srcActDirDef.changeFrameCnt(rh._xCount, ins, actID);	// 填充帧数
					// 这个地方要根据是否映射进行写
					srcActDirDef.overwriteAtt(rh.directDic[k]);				// 将内容原封不动拷贝过来
					
					//if (this._resPack)
					//{
					//	if (rh.mediaPath.length)
					//	{
					//		this._mediaPath = rh.mediaPath;
					//	}
					//	else
					//	{
					//		this._mediaPath = ins + "_" + actID + ".swf";
					//	}
					//}
					//else
					//{
						srcActDirDef.adjustAtt(ins, actID);			// 设置要加载的资源的名字，例如 c111_2_1.swf 
					//}
				}
			}
			
			this._xCount = rh.xCount;
			this._yCount = rh.yCount;
			this._framerate = rh.framerate;
			this._framerateInv = rh.framerateInv;
			// _repeat 人物只在模板中定义，特效需要拷贝过去       
			//this._repeat = rh.repeat;
			
			//this._mediaPath = rh.mediaPath;
			this._total = rh.total;
			this._objType = rh.objType;
			this._bInit = rh.bInit;
			this._width = rh.width;
			this._height = rh.height;
			this._horizontalSpacing = rh.horizontalSpacing;
			this._verticalSpacing = rh.verticalSpacing;
			
			//this._resPack = rh._resPack;
			
			// X 翻转    
			for (k in this.m_directDic)
			{
				srcActDirDef = this.m_directDic[k];
				if (srcActDirDef.flipMode)
				{
					//var refsrc:String = srcActDirDef.spriteVec[0].startName.substr(11, 1);
					var refsrc:String = fUtil.getDirBySymbol(srcActDirDef.spriteVec[0].startName);
					
					var refidx:int = parseInt(refsrc);
					if(rh.directDic[refidx] && rh.directDic[refidx].spriteVec.length)	// 只有有这个方向,并且方向里有数据
					{
						//srcActDirDef.origin.x = rh.width - rh.directArr[k].origin.x;
						// 兼容以前的内容
						srcActDirDef.origin.x = -(rh.width + rh.directDic[refidx].origin.x);
						srcActDirDef.origin.y = rh.directDic[refidx].origin.y;
						
						// 设置里面的
						srcActDirDef.changeFrameCnt(rh._xCount, ins, actID);
						// 这个地方要根据是否映射进行写
						srcActDirDef.overwriteAtt(rh.directDic[refidx]);
						
						//if (this._resPack)
						//{
						//	if (rh.mediaPath.length)
						//	{
						//		this._mediaPath = rh.mediaPath;
						//	}
						//	else
						//	{
						//		this._mediaPath = ins + "_" + actID + ".swf";
						//	}
						//}
						//else
						//{
							srcActDirDef.adjustAtt(ins, actID);
						//}

						// 修正坐标偏移
						var cnt:uint = 0;
						while (cnt < rh.xCount)
						{
							//srcActDirDef.spriteVec[cnt].origin.x = srcActDirDef.origin.x;
							//srcActDirDef.spriteVec[cnt].origin.y = srcActDirDef.origin.y;
							
							srcActDirDef.spriteVec[cnt].origin.x = -(rh.directDic[refidx].spriteVec[cnt].picWidth + rh.directDic[refidx].spriteVec[cnt].origin.x);
							srcActDirDef.spriteVec[cnt].origin.y = rh.directDic[refidx].spriteVec[cnt].origin.y;
							
							++cnt;
						}
						
						// 现在都是负值
						//if (srcActDirDef.origin.x < 0 || srcActDirDef.origin.y < 0)
						if (srcActDirDef.origin.x > 0 || srcActDirDef.origin.y > 0)
						{
							throw new Error("overwriteAtt error");
						}
					}
				}
			}
		}
		
		public function adjustAtt(insID:String):void
		{
			//var actDirDef:fActDirectDefinition;
			//// 如果动作放在一个包里面    
			//if (_resPack)
			//{
			//	this._mediaPath = insID + "_" + _actID + ".swf";
			//}
			//for each(actDirDef in this._directArr)
			//{
			//	actDirDef.adjustAtt(insID, _actID, _resPack);
			//}

			var actDirDef:fActDirectDefinition;
			// 如果动作放在一个包里面    
			//if (_resPack)
			//{
			//	this._mediaPath = insID + "_" + _actID + ".swf";
			//}
			for each(actDirDef in this.m_directDic)
			{
				actDirDef.adjustAtt(insID, _actID);
			}
		}
		
		public function getOrigin(dir:int):fPoint3d
		{
			//if (_directArr == null)
			//{
			//	return null;
			//}
			//if (dir >= _directArr.length)
			//{
			//	return null;
			//}
			//return _directArr[dir].origin;
			
			if (m_directDic == null)
			{
				return null;
			}
			if (!m_directDic[dir])
			{
				return null;
			}
			return m_directDic[dir].origin;
		}
	}
}