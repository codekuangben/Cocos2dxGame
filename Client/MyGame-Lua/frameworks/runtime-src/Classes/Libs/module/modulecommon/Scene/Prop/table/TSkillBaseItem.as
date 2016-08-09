package modulecommon.scene.prop.table
{
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.utils.ByteArray;	
	/**
	 * ...
	 * @author 
	 * @brief 技能基本表    
	 */
	public class TSkillBaseItem extends TDataItem
	{
		public static const TYPE_TIANFU:uint = 1; 	// 天赋
		public static const TYPE_ZHANSHU:uint = 2; 	// 技能  
		public static const TYPE_JINNANG:uint = 3; 	// 锦囊
		
		public static const EffPre:uint = 0; 	// 准备特效  
		public static const EffAtt:uint = 1; 	// 攻击特效    
		public static const EffFly:uint = 2; 	// 飞行特效    
		public static const EffHit:uint = 3; 	// 命中特效   
		
		public static const FmAtt:uint = 0; 	// 攻击帧
		public static const FmFly:uint = 0; 	// 飞行帧
		public static const FmHit:uint = 0; 	// 命中帧
		
		public var m_name:String = "";
		public var m_levelMax:uint;	//技能最大等级
		public var m_type:uint;
		public var m_iconName:String = "";
		public var m_effStr:String = "";	// 技能释放过程，如果是锦囊就对应锦囊对应技能需要的信息
		public var m_desc:String = "";
		public var m_fazhaoPic:String;
		//public var m_jinnangInfo:String = "";	// 锦囊对应技能需要的信息
		
		// 现在有两层，第二层都在原来第一层基础上添加一个 1，数据使用:冒号
		// 解析后的数据  
		public var m_EffNumList:Vector.<String>;	// 特效列表    
		public var m_FmNumList:Vector.<uint>;		// 特效释放时间列表     
		//public var m_actList:Vector.<uint>;			// 准备动作和攻击动作    
		public var m_effFrameRateList:Vector.<uint>;		// 特效帧率
		public var m_offY:int = 0;		// 锦囊对应技能中的特效距离释放地点高度
		public var m_jinnangEff:String = "";// 锦囊对应技能中的特效id
		public var m_jinnangPostEff:String = "";		// 锦囊特效持续特效
		
		// 第二层
		public var m_EffNumList1:Vector.<String>;	// 特效列表    
		public var m_FmNumList1:Vector.<uint>;		// 特效释放时间列表     
		//public var m_actList:Vector.<uint>;			// 准备动作和攻击动作    
		public var m_effFrameRateList1:Vector.<uint>;		// 特效帧率
		public var m_offY1:int = 0;		// 锦囊对应技能中的特效距离释放地点高度
		public var m_jinnangEff1:String = "";// 锦囊对应技能中的特效id	
		
		// 字符串以 "-" 分割 
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_name = TDataItem.readString(bytes);
			m_levelMax = bytes.readByte();
			m_type = bytes.readByte();
			m_iconName = TDataItem.readString(bytes);
			m_effStr = TDataItem.readString(bytes);
			m_desc = TDataItem.readString(bytes);
			m_fazhaoPic = TDataItem.readString(bytes);
			//m_jinnangInfo = TDataItem.readString(bytes);
			
			// 解析    
			var strlist:Array;
			var efflist:Array;
			var fmlist:Array;
			var efffratelist:Array;
			
			// 两层，冒号分割的列表
			var colonlist:Array;
			
			m_EffNumList = new Vector.<String>(4, true);
			m_FmNumList = new Vector.<uint>(4, true);
			m_effFrameRateList = new Vector.<uint>(4, true);
			
			m_EffNumList[0] = "";
			m_EffNumList[1] = "";
			m_EffNumList[2] = "";
			m_EffNumList[3] = "";
			
			// 第二层
			m_EffNumList1 = new Vector.<String>(4, true);
			m_FmNumList1 = new Vector.<uint>(4, true);
			m_effFrameRateList1 = new Vector.<uint>(4, true);

			m_EffNumList1[0] = "";
			m_EffNumList1[1] = "";
			m_EffNumList1[2] = "";
			m_EffNumList1[3] = "";
			
			var idx:uint;
			// 3001 - 3999 这个区域是锦囊
			if (3000 < m_uID && m_uID < 4000)
			{
				// 锦囊信息
				if (m_effStr != "" && m_effStr != "0")
				{
					// 新版本这样格式
					// buffeff1:buffeff2-攻击特效1:攻击特效2-飞行特效1:飞行特效2-被击特效1:被击特效2;1:1-1:1-1:1;12:1-12:1-24:1-12:1;锦囊特效1:锦囊特效2;锦囊特效1高度:锦囊特效2高度;锦囊特效释放后持续的特效 ID
					strlist = m_effStr.split(";");
					if(strlist.length >= 5)
					{
						strlist = m_effStr.split(";");
						efflist = strlist[0].split("-");
						fmlist = strlist[1].split("-");
						
						idx = 0;
						while (idx < efflist.length && idx < 4)
						{
							//m_EffNumList[idx] = efflist[idx];
							colonlist = efflist[idx].split(":");
							m_EffNumList[idx] = colonlist[0];
							if(colonlist.length > 1)
							{
								m_EffNumList1[idx] = colonlist[1];
							}
							++idx;
						}
						
						idx = 0;
						if(fmlist.length == 3)
						{
							idx = 1;
						}
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
							while (idx < efffratelist.length && idx < 3)
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
						
						// 防止填写错误
						if (strlist.length >= 4)
						{
							if (strlist.length >= 3)
							{
								// m_jinnangEff = strlist[0];
								colonlist = strlist[3].split(":");
								m_jinnangEff = colonlist[0];
								if(colonlist.length > 1)
								{
									m_jinnangEff1 = colonlist[1];
								}
							}
							if (strlist.length >= 4)
							{
								//m_offY = parseInt(strlist[1]);
								colonlist = strlist[4].split(":");
								m_offY = parseInt(colonlist[0]);
								if(colonlist.length > 1)
								{
									m_offY1 = parseInt(colonlist[1]);
								}
							}
						}
						
						// 锦囊持续特效
						if(strlist.length >= 5)
						{
							m_jinnangPostEff = strlist[5];
						}
					}
					else	// 老版本	锦囊特效1;锦囊特效1高度
					{
						if (strlist.length >= 2)
						{
							if (strlist.length >= 1)
							{
								// m_jinnangEff = strlist[0];
								colonlist = strlist[0].split(":");
								m_jinnangEff = colonlist[0];
								if(colonlist.length > 1)
								{
									m_jinnangEff1 = colonlist[1];
								}
							}
							if (strlist.length >= 2)
							{
								//m_offY = parseInt(strlist[1]);
								colonlist = strlist[1].split(":");
								m_offY = parseInt(colonlist[0]);
								if(colonlist.length > 1)
								{
									m_offY1 = parseInt(colonlist[1]);
								}
							}
						}
					}
				}
			}
			else
			{
				if (m_effStr != "" && m_effStr != "0")
				{
					strlist = m_effStr.split(";");
					efflist = strlist[0].split("-");
					fmlist = strlist[1].split("-");
					
					idx = 0;
					while (idx < efflist.length && idx < 4)
					{
						//m_EffNumList[idx] = efflist[idx];
						colonlist = efflist[idx].split(":");
						m_EffNumList[idx] = colonlist[0];
						if(colonlist.length > 1)
						{
							m_EffNumList1[idx] = colonlist[1];
						}
						++idx;
					}
					
					idx = 0;
					if(fmlist.length == 3)
					{
						idx = 1;
					}
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
						while (idx < efffratelist.length && idx < 3)
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
		
		// 技能是否有前奏动作，如果是 0 就说明没有前奏动作，现在 m_EffNumList[0] 是 buffer 特效，没有攻击准备特效了，也没有攻击准备动作了
		public function hasPreAct():Boolean
		{
			//return (m_EffNumList[0] != null && m_EffNumList[0] != "0");
			return false;
		}
		
		// 是否有 buffer 特效
		public function hasBufferEff():Boolean
		{
			return (m_EffNumList[0] != null && m_EffNumList[0] != "0");
		}
		
		// 返回技能前奏动作编号    
		public function preAct():uint
		{
			//return m_actList[0];
			return EntityCValue.TActSkillPre;
		}
		
		public function attAct():uint
		{
			//return m_actList[1];
			return EntityCValue.TActSkill;
		}
		
		// 准备特效，现在这个改成技能释放的时候给本方添加 buf 时候，人物显示的特效，非重复，播放一次就完了
		public function preActEff():String
		{
			return m_EffNumList[0];
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
		
		// 攻击准备起始帧，现在改成 buf 特效播放起始帧
		public function attPreFrame():uint
		{
			return m_FmNumList[0];
		}
		
		// 攻击特效播放帧 
		public function attActEffFrame():uint
		{
			return m_FmNumList[1];
		}
		
		// 飞行特特效播放帧 
		public function attFlyEffFrame():uint
		{
			return m_FmNumList[2];
		}
		
		// 命中特效播放帧    
		public function hitEffFrame():uint
		{
			return m_FmNumList[3];	
		}
		
		// 是否有攻击前奏特效  
		public function hasAttPreEff():Boolean
		{
			return (m_EffNumList[0] != null && m_EffNumList[0] != "0" && m_EffNumList[0] != "");
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
		
		// 攻击准备特效播放帧率，这个改成 buf 特效
		public function attPreEffFrameRate():uint
		{
			return m_effFrameRateList[0];
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
		
		// 第二层次
		// 技能是否有前奏动作，如果是 0 就说明没有前奏动作     
		public function hasPreAct1():Boolean
		{
			//return (m_EffNumList1[0] != null && m_EffNumList1[0] != "0");
			return false;
		}

		// 是否有 buffer 特效
		public function hasBufferEff1():Boolean
		{
			return (m_EffNumList1[0] != null && m_EffNumList1[0] != "0");
		}
		
		// 返回技能前奏动作编号    
		public function preAct1():uint
		{
			//return m_actList[0];
			return EntityCValue.TActSkillPre;
		}
		
		public function attAct1():uint
		{
			//return m_actList[1];
			return EntityCValue.TActSkill;
		}
		
		// 准备特效，现在这个改成技能释放的时候给本方添加 buf 时候，人物显示的特效，非重复，播放一次就完了
		public function preActEff1():String
		{
			return m_EffNumList1[0];
		}
		
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
		
		// 攻击准备起始帧，现在改成 buf 特效播放起始帧
		public function attPreFrame1():uint
		{
			return m_FmNumList1[0];
		}
		
		// 攻击特效播放帧 
		public function attActEffFrame1():uint
		{
			return m_FmNumList1[1];
		}
		
		// 飞行特特效播放帧 
		public function attFlyEffFrame1():uint
		{
			return m_FmNumList1[2];
		}
		
		// 命中特效播放帧    
		public function hitEffFrame1():uint
		{
			return m_FmNumList1[3];	
		}
		
		// 是否有攻击前奏特效  
		public function hasAttPreEff1():Boolean
		{
			return (m_EffNumList1[0] != null && m_EffNumList1[0] != "0" && m_EffNumList1[0] != "");
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
		
		// 攻击准备特效播放帧率，这个改成 buf 特效
		public function attPreEffFrameRate1():uint
		{
			return m_effFrameRateList1[0];
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
		
		public function get typeName():String
		{
			var ret:String;
			switch(this.m_type)
			{
				case TYPE_TIANFU: ret = "天赋";	break;
				case TYPE_ZHANSHU: ret = "技能";	break;
				case TYPE_JINNANG: ret = "锦囊";	break;
			}
			return ret;
		}

		// 判断是否存在锦囊持续特效
		public function bjinnangPostEff():Boolean
		{
			return m_jinnangPostEff != "" && m_jinnangPostEff != "0";
		}
	}
}