package org.ffilmation.engine.helpers
{
	import org.ffilmation.engine.datatypes.fPoint3d;
	/**
	 * ...
	 * @author 
	 * @brief 动作的一个方向定义    
	 */
	public class fActDirectDefinition 
	{
		// 存放一个动作方向中的序列 
		protected var m_spriteVec:Vector.<fSpriteDefinition>;
		protected var m_angle:int = 0;
		protected var m_flipMode:uint = 0;	// 翻转方式，0: 不翻转 1: X 翻转 2: Y 翻转  
		// KBEN: 每一个动作方向可以定义不同的资源，资源路径，包括文件名字    
		protected var _mediaPath:String;
		// KBEN: 坐标原点距离左上角的偏移，如果是 0 ，坐标原点就放在图片 X 轴中间， Y 轴最底下    
		protected var m_origin:fPoint3d;
		
		public function fActDirectDefinition() 
		{
			m_spriteVec = new Vector.<fSpriteDefinition>();
			m_origin = new fPoint3d(0, 0, 0);
		}
		
		public function get spriteVec():Vector.<fSpriteDefinition> 
		{
			return m_spriteVec;
		}
		
		public function get angle():int 
		{
			return m_angle;
		}
		
		public function set angle(value:int):void 
		{
			m_angle = value;
		}
		
		public function get flipMode():uint 
		{
			return m_flipMode;
		}
		
		public function set flipMode(value:uint):void 
		{
			m_flipMode = value;
		}
		
		public function get mediaPath():String 
		{
			//if (_mediaPath == "")
			//{
				//throw new Error("mediaPath is null");
			//}
			return _mediaPath;
		}
		
		public function set mediaPath(value:String):void 
		{
			_mediaPath = value;
		}
		
		public function get origin():fPoint3d 
		{
			return m_origin;
		}
		
		public function set origin(value:fPoint3d):void 
		{
			m_origin = value;
		}
		
		// 从一个对象拷贝另外一个对象    
		public function copyFrom(rh:fActDirectDefinition):void
		{			
			var srcSptDef:fSpriteDefinition;
			var destSptDef:fSpriteDefinition;
			for (var k:uint = 0; k < rh.m_spriteVec.length; ++k)
			{
				srcSptDef = rh.m_spriteVec[k];
				destSptDef = new fSpriteDefinition(srcSptDef.angle, srcSptDef.sprite, srcSptDef.shadow);
				destSptDef.copyFrom(srcSptDef);
				this.m_spriteVec.push(destSptDef);
			}
			this.m_angle = rh.m_angle;
			this.m_flipMode = rh.m_flipMode;
			this._mediaPath = rh._mediaPath;
		}
		
		// 根据帧的数量重新写 m_spriteVec 中帧的数量     
		public function overwriteAtt(rh:fActDirectDefinition):void
		{
			this.m_origin.x = rh.origin.x;
			this.m_origin.y = rh.origin.y;
			
			var srcSptDef:fSpriteDefinition;
			var destSptDef:fSpriteDefinition;
			// 现在有些方向没有图片，但是配置文件也把这个方向配置进去了，例如 <sprite angle="135"/> ，这个时候由于在 changeFrameCnt 这个函数中统一添加了帧数，
			for (var k:uint = 0; k < rh.m_spriteVec.length; ++k)
			{
				// bug: 有些动画一个动作不同方向的帧数是不一样的，这样取最小的播放
				if(k >= this.m_spriteVec.length)
				{
					break;
				}
				srcSptDef = rh.m_spriteVec[k];
				destSptDef = this.m_spriteVec[k];
				destSptDef.overwriteAtt(srcSptDef);
			}
		}
		
		// 改变动作中帧的数量，新写 m_spriteVec 中帧的信息 
		public function changeFrameCnt(cnt:uint, ins:String, actID:uint):void
		{
			var curidx:int = m_spriteVec.length;
			var angle:Number = m_spriteVec[0].angle;
			var spdef:fSpriteDefinition;
			//var startName:String = m_spriteVec[0].startName.substr(0, 12);
			var startName:String;

			// 全名字
			//if(fUtil.isSymbolAddPackage(ins))
			//{
			//	m_spriteVec[0].startName = fUtil.mergeFileNameModelActDir(m_spriteVec[0].startName, ins, actID + "");
			//	var ridx:int = m_spriteVec[0].startName.lastIndexOf("_");
			//	if(ridx != -1)
			//	{
			//		startName = m_spriteVec[0].startName.substr(0, ridx + 2);
			//	}
			//}
			//else
			//{
			//	startName = m_spriteVec[0].startName.substr(0, 12);
			//}
			
			startName = fUtil.mergeFileNameModelActDir(m_spriteVec[0].startName, ins, actID + "");

			// 如果版本是 2 ，需要更改模板内的文件名字
			curidx = 0;
			//if(version == 2)
			//{
				while(curidx < m_spriteVec.length)
				{
					m_spriteVec[curidx].startName = fUtil.mergeFileNameNew(startName, curidx);
					++curidx;
				}
			//}
			
			curidx = m_spriteVec.length;
			// 如果实例的图片数多于模板的 
			if (m_spriteVec.length < cnt)
			{
				while (curidx < cnt)
				{
					spdef = new fSpriteDefinition(angle, null, null);
					//if(version == 1)
					//{
					//	spdef.startName = fUtil.mergeFileName(startName, curidx);
					//}
					//else
					//{
						spdef.startName = fUtil.mergeFileNameNew(startName, curidx);
					//}
					m_spriteVec.push(spdef);
					++curidx;
				}
			}
			else if(m_spriteVec.length > cnt)	// 如果实例的图片数小于模板的 
			{
				m_spriteVec.splice(cnt, m_spriteVec.length - cnt);
			}
		}
		
		public function adjustAtt(insID:String, act:uint):void
		{
			// 只调整路径，在上一级中实现，如果动作没有放在一个包里面    
			//if (!respack)
			//{
				//if (m_flipMode)	// 映射   
				//{
					//if (this.angle < 135)	// 从左边映射到右边 
					//{
						//
					//}
					//else	// 从右边映射到左边 
					//{
						//
					//}
				//}
				//else
				//{
					//this._mediaPath = insID + "-" + act + "-" + fUtil.angle2idx(this.m_angle) + ".swf";
				//}
				//this._mediaPath = insID + "_" + act + "_" + m_spriteVec[0].startName.substr(11, 1) + ".swf";
				
				this._mediaPath = insID + "_" + act + "_" + fUtil.getDirBySymbol(m_spriteVec[0].startName) + ".swf";
				
				//var diridx:int = m_spriteVec[0].startName.lastIndexOf("_");
				//if(diridx != -1)
				//{
				//	var dir:String = m_spriteVec[0].startName.substr(diridx + 1, 1);
				//	this._mediaPath = insID + "_" + act + "_" + dir + ".swf";
				//}
			//}
		}
		
		// 扩充数量如果不够，全部拷贝最后一个的数据
		public function extendSprite(cnt:uint):void
		{
			var curidx:int = m_spriteVec.length;
			var angle:Number = m_spriteVec[0].angle;
			var spdef:fSpriteDefinition;
			var startName:String = m_spriteVec[0].startName.substr(0, 12);
			var lastsprite:fSpriteDefinition;
			
			curidx = m_spriteVec.length;
			// 如果实例的图片数多于模板的 
			if (m_spriteVec.length < cnt)
			{
				lastsprite = m_spriteVec[curidx - 1];
				while (curidx < cnt)
				{
					spdef = new fSpriteDefinition(angle, null, null);
					spdef.copyFrom(lastsprite);
					m_spriteVec.push(spdef);
					++curidx;
				}
			}
		}
	}
}