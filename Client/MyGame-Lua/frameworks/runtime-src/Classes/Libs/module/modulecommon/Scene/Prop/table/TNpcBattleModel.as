package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class TNpcBattleModel extends TDataItem 
	{
		public var m_strModel:String;
		public var m_frameRate:String;		// 帧率    
		public var m_effStr:String = "";
		
		public var m_attStr:String = "";		// 攻击配置，有些攻击动作太大，攻击的时候需要调整位置
		// 现在数据两套，第二套加上 1
		// 解析后的数据  
		public var m_EffNumList:Vector.<String>;	// 特效列表    
		public var m_FmNumList:Vector.<uint>;		// 特效释放时间列表     
		public var m_effFrameRateList:Vector.<uint>;		// 特效帧率    
		
		// 第二套数据
		public var m_EffNumList1:Vector.<String>;	// 特效列表    
		public var m_FmNumList1:Vector.<uint>;		// 特效释放时间列表     
		public var m_effFrameRateList1:Vector.<uint>;		// 特效帧率
		
		public var m_act2FrameRate:Dictionary;		// 动作到帧率的映射
		
		public var m_attFrame:int;	// 攻击中帧数 -1 表示默认值
		public var m_attDist:int;	// 移动距离， 整数是向前移动，负数是向后移动
		public function TNpcBattleModel() 
		{
			
		}
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);
			m_strModel = TDataItem.readString(bytes);
			m_frameRate = TDataItem.readString(bytes);
			m_effStr = TDataItem.readString(bytes);
			
			// 解析  
			var strlist:Array;
			var efflist:Array;
			var fmlist:Array;
			var efffratelist:Array;
			
			// 两层，冒号分割的列表
			var colonlist:Array;
			
			// 准备动作特效号—攻击特效号—飞行特效号—命中特效号；攻击特效起始真（攻击动作第几真）—飞行特效起始真（攻击动作第几真）—命特效起始真（0默认为攻击飞行特效都结束后播，数为攻击动作第几真播放）;攻击前奏特效帧率-攻击特效帧率-飞行特效帧率-命中特效帧率
			// 和技能都统一起来，但是准备特效普通攻击是没有的
			m_EffNumList = new Vector.<String>(4, true);
			m_FmNumList = new Vector.<uint>(4, true);
			
			m_EffNumList[0] = "";
			m_EffNumList[1] = "";
			m_EffNumList[2] = "";
			m_EffNumList[3] = "";
			
			// 为了和技能表统一,都写成 4 个 
			m_effFrameRateList = new Vector.<uint>(4, true);
			m_act2FrameRate = new Dictionary();
			
			// 第二层
			m_EffNumList1 = new Vector.<String>(4, true);
			m_FmNumList1 = new Vector.<uint>(4, true);
			m_effFrameRateList1 = new Vector.<uint>(4, true);
			
			m_EffNumList1[0] = "";
			m_EffNumList1[1] = "";
			m_EffNumList1[2] = "";
			m_EffNumList1[3] = "";
			
			var idx:uint;
			
			if (m_effStr != "" && m_effStr != "0")
			{
				strlist = m_effStr.split(";");
				efflist = strlist[0].split("-");
				fmlist = strlist[1].split("-");
				
				idx = 0;
				while (idx < efflist.length && idx < 4)
				{
					// m_EffNumList[idx] = efflist[idx];
					colonlist = efflist[idx].split(":");
					m_EffNumList[idx] = colonlist[0];
					if(colonlist.length > 1)
					{
						m_EffNumList1[idx] = colonlist[1];
					}
					++idx;
				}
				
				idx = 0;
				while (idx < fmlist.length && idx < 4)
				{
					//m_FmNumList[idx] = parseInt(fmlist[idx]);
					colonlist = fmlist[idx].split(":");
					m_FmNumList[idx] = parseInt(colonlist[0]);
					if(colonlist.length > 1)
					{
						m_FmNumList1[idx] = parseInt(colonlist[1]);
					}
					++idx;
				}
				
				if (strlist.length > 2)
				{
					efffratelist = strlist[2].split("-");
					
					idx = 0;
					while (idx < efffratelist.length && idx < 4)
					{
						//m_effFrameRateList[idx] = parseInt(efffratelist[idx]);
						colonlist = efffratelist[idx].split(":");
						m_effFrameRateList[idx] = parseInt(colonlist[0]);
						if(colonlist.length > 1)
						{
							m_effFrameRateList1[idx] = parseInt(colonlist[1]);
						}
						++idx;
					}
				}
			}
			
			// 解析帧率    
			if (m_frameRate != "")
			{
				strlist = m_frameRate.split(";");
				
				idx = 0;
				while (idx < strlist.length)
				{
					efflist = strlist[idx].split("-");
					m_act2FrameRate[efflist[0]] = parseInt(efflist[1]);
					++idx;
				}
			}
			
			if(m_attStr != "")
			{
				strlist = m_attStr.split(":");
				
				m_attFrame = parseInt(strlist[0]);
				m_attDist = parseInt(strlist[1]);
			}
			else
			{
				m_attFrame = -1;
				m_attDist = 0;
			}
			
			/*
			m_EffNumList[0] = "e3_e1112";
			m_EffNumList[1] = "0";
			m_EffNumList[2] = "0";
			m_EffNumList[3] = "e5_e1412";
			
			m_effFrameRateList[0] = 5;
			m_effFrameRateList[1] = 5;
			m_effFrameRateList[2] = 5;
			m_effFrameRateList[3] = 5;
			
			m_EffNumList1[0] = "e3_e1914";
			m_EffNumList1[1] = "0";
			m_EffNumList1[2] = "0";
			m_EffNumList1[3] = "e8_e1721";
			
			m_effFrameRateList1[0] = 5;
			m_effFrameRateList1[1] = 5;
			m_effFrameRateList1[2] = 5;
			m_effFrameRateList1[3] = 5;
			*/
		}
		
		// 攻击特效  
		public function attActEff():String
		{
			return m_EffNumList[1];
		}
		
		// 飞行特特效 
		public function attFlyEff():String
		{
			return m_EffNumList[2];
		}
		
		// 命中特效    
		public function hitEff():String
		{
			return m_EffNumList[3];	
		}
		
		// 攻击特效播放帧  
		public function attActEffFrame():uint
		{
			return m_FmNumList[1];
		}
		
		// 飞行特效播放帧 
		public function attFlyEffFrame():uint
		{
			return m_FmNumList[2];
		}
		
		// 命中特效播放帧  
		public function hitEffFrame():uint
		{
			return m_FmNumList[3];
		}
		
		// 是否有攻击特效  
		public function hasAttActEff():Boolean
		{
			return (m_EffNumList[1] != null && m_EffNumList[1] != "0" && m_EffNumList[1] != "");
		}
		
		// 是否有飞行特效  
		public function hasAttFlyEff():Boolean
		{
			return (m_EffNumList[2] != null && m_EffNumList[2] != "0" && m_EffNumList[2] != "");
		}
		
		// 是否有命中特效  
		public function hasAttHitEff():Boolean
		{
			return (m_EffNumList[3] != null && m_EffNumList[3] != "0" && m_EffNumList[3] != "");
		}
		
		// 攻击特效播放帧率  
		public function attActEffFrameRate():uint
		{
			return m_effFrameRateList[1];
		}
		
		// 飞行特特效播放帧率 
		public function attFlyEffFrameRate():uint
		{
			return m_effFrameRateList[2];
		}
		
		// 命中特效播放帧率    
		public function hitEffFrameRate():uint
		{
			return m_effFrameRateList[3];	
		}
		
		// 第二层
		// 攻击特效  
		public function attActEff1():String
		{
			return m_EffNumList1[1];
		}
		
		// 飞行特特效 
		public function attFlyEff1():String
		{
			return m_EffNumList1[2];
		}
		
		// 命中特效    
		public function hitEff1():String
		{
			return m_EffNumList1[3];	
		}
		
		// 攻击特效播放帧  
		public function attActEffFrame1():uint
		{
			return m_FmNumList1[1];
		}
		
		// 飞行特效播放帧 
		public function attFlyEffFrame1():uint
		{
			return m_FmNumList1[2];
		}
		
		// 命中特效播放帧  
		public function hitEffFrame1():uint
		{
			return m_FmNumList1[3];
		}
		
		// 是否有攻击特效  
		public function hasAttActEff1():Boolean
		{
			return (m_EffNumList1[1] != null && m_EffNumList1[1] != "0" && m_EffNumList1[1] != "");
		}
		
		// 是否有飞行特效  
		public function hasAttFlyEff1():Boolean
		{
			return (m_EffNumList1[2] != null && m_EffNumList1[2] != "0" && m_EffNumList1[2] != "");
		}
		
		// 是否有命中特效  
		public function hasAttHitEff1():Boolean
		{
			return (m_EffNumList1[3] != null && m_EffNumList1[3] != "0" && m_EffNumList1[3] != "");
		}
		
		// 攻击特效播放帧率  
		public function attActEffFrameRate1():uint
		{
			return m_effFrameRateList1[1];
		}
		
		// 飞行特特效播放帧率 
		public function attFlyEffFrameRate1():uint
		{
			return m_effFrameRateList1[2];
		}
		
		// 命中特效播放帧率    
		public function hitEffFrameRate1():uint
		{
			return m_effFrameRateList1[3];	
		}
	}

}