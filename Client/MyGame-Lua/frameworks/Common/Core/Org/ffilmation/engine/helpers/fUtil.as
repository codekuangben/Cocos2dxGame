package org.ffilmation.engine.helpers
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;

	import flash.utils.Dictionary;
	import common.Context;	
	import org.ffilmation.engine.core.fRenderableElement;
	//import org.ffilmation.utils.mathUtils;
	
	/**
	 * @brief 工具类  
	 */
	public class fUtil 
	{
		protected static var m_dicA2CDigit:Dictionary;
		
		// 合并一个文件的名字，最多就两位    
		//public static function mergeFileName(base:String, suffix:uint):String
		//{
		//	if (suffix < 10)
		//	{
		//		return base + "0" + suffix;
		//	}
		//	else if (suffix < 100)
		//	{
		//		return base + suffix;
		//	}
		//	else
		//	{
		//		throw new Error("mergeFileName error");
		//	}
			
		//	return base + suffix;
		//}
		
		// 合并一个文件的名字，最多就两位    
		public static function mergeFileNameNew(base:String, suffix:uint):String
		{
			return base + suffix;
		}
		
		// base:格式 "art.scene.c0"
		public static function mergeFileNameModelActDir(base:String, model:String, act:String):String
		{
			var ridx:uint = base.lastIndexOf(".");
			var dir:String;
			dir = base.substring(ridx + 2, ridx + 3);
			base = base.substring(0, ridx);
			return (base + "." + model + "_" + act + "_" + dir);
		}
		
		// 获取 fElement 中 id 属性值的函数，名字解释 首先是 "d" + "类型" + "序号" 
		public static function elementID(context:Context, type:uint):String
		{
			var id:String = "def";
			switch(type)
			{
				case EntityCValue.TEfffect:
				{
					id = "de" + context.m_count;	// dynamic effect
				}
					break;
				case EntityCValue.TPlayer:
				case EntityCValue.TPlayerMain:
				case EntityCValue.TNpcPlayerFake:
				case EntityCValue.TPlayerArena:
				{
					id = "dc" + context.m_count;	// dynamic character
				}
					break;
				case EntityCValue.TBattleNpc:
				{
					id = "dnb" + context.m_count;	// dynamic npc battle
				}
					break;
				case EntityCValue.TVistNpc:
				{
					id = "dnv" + context.m_count;	// dynamic npc visit
				}
					break;
				case EntityCValue.TFallObject:
				{
					id = "dfo" + context.m_count;	// dynamic fall object
				}
					break;
				case EntityCValue.TThing:
				{
					id = "dt" + context.m_count;	// dynamic thing
				}
					break;
				case EntityCValue.TUIObject:
				{
					id = "dui" + context.m_count;	// dynamic thing
				}
					break;
				case EntityCValue.TEmptySprite:
				{
					id = "es" + context.m_count;	// empty sprite
				}
					break;
				case EntityCValue.TRideHorse:
				{
					id = "rh" + context.m_count;	// ride horse
				}
					break;
				case 1000:	// 这个是模型查看器工具使用的
				{
					id = "mvc" + context.m_count;	// empty sprite
				}
					break;
				default:
				{
					throw new Error("elementID error");
				}
					break;
			}
			
			context.m_count++;
			
			return id; 
		}
		
		public static function flipName(name:String, flipmode:uint):String
		{
			if (flipmode == EntityCValue.FLPX)
			{
				return name + "-x";
			}
			else if (flipmode == EntityCValue.FLPY)
			{
				return name = "-y";
			}
			
			return name;
		}
		/*
		* 去掉路径，去掉扩展名extName
		*/
		public static function getNameOnly(fullname:String, extName:String = null):String
		{
			var ar:Array = fullname.split("/");
			if (ar.length == 0)
			{
				return null;
			}
			else if (ar.length == 1)
			{
				return ar[0] as String;
			}
			else
			{
				var name:String = (ar.pop() as String);				
				if (extName == null)
				{
					return name;					
				}
				extName = "." + extName;
				name = name.replace(extName, "");
				return name;				
			}
		}
		
		public static function angle2idx(angle:uint):uint
		{
			if (0 == angle)
			{
				return 0;
			}
			else if (45 == angle)
			{
				return 1;
			}
			else if (90 == angle)
			{
				return 2;
			}
			else if (135 == angle)
			{
				return 3;
			}
			else if (180 == angle)
			{
				return 4;
			}
			else if (225 == angle)
			{
				return 5;
			}
			else if (270 == angle)
			{
				return 6;
			}
			else if (315 == angle)
			{
				return 7;
			}
			
			return 0;
		}
		
		// 获取 xml 配置的资源的类型    
		public static function xmlResType(path:String):int
		{
			// 字符串路径分隔符都是 "/"    
			var lastidx:int;
			lastidx = path.lastIndexOf("/");
			if (lastidx == -1)
			{
				lastidx = path.lastIndexOf("\\");
			}
			
			var filename:String;
			if (lastidx != -1)
			{
				filename = path.substring(lastidx, path.length);
			}
			else
			{
				filename = path;
			}
			lastidx = filename.lastIndexOf(".");
			if (lastidx != -1)
			{
				filename = filename.substring(0, lastidx);
			}
			
			var type:int = -1;
			// 人物实例 xc 开头
			// 人物模板 xct 开头
			// 特效实例 xe 开头
			// 特效模板 xet 开头
			// 地形实例 x 开头
			// 地形模板 xt 开头
			// 地形阻挡点 s 开头
			// 地形缩略图 ttb 开头 tthumbnails
			if (filename.substring(0, 3) == "xct")
			{
				type = EntityCValue.PHXMLCTPL;
			}
			else if (filename.substring(0, 3) == "xet")
			{
				type = EntityCValue.PHXMLETPL;
			}
			else if (filename.substring(0, 2) == "xc")
			{
				type = EntityCValue.PHXMLCINS;
			}
			else if (filename.substring(0, 2) == "xe")
			{
				type = EntityCValue.PHXMLEINS;
			}
			else if (filename.substring(0, 2) == "xt")
			{
				type = EntityCValue.PHXMLTTPL;
			}
			else if (filename.substring(0, 1) == "x")
			{
				type = EntityCValue.PHXMLTINS;
			}
			else if (filename.substring(0, 1) == "s")
			{
				type = EntityCValue.PHSTOPPT;
			}
			else if (filename.substring(0, 3) == "ttb")
			{
				type = EntityCValue.PHTTB;
			}
			else
			{
				throw new Error("xmlResType no type");
			}
			
			return type;
		}
		
		// 获取 xml 类的名字    
		public static function xmlResClase(path:String):String
		{
			// 字符串路径分隔符都是 "/"    
			var lastidx:int;
			lastidx = path.lastIndexOf("/");
			if (lastidx == -1)
			{
				lastidx = path.lastIndexOf("\\");
			}
			if (lastidx == -1)
			{
				return "";
			}
			
			var filename:String;
			filename = path.substring(lastidx + 1, path.length);
			lastidx = filename.lastIndexOf(".");
			if (lastidx != -1)
			{
				filename = filename.substring(0, lastidx);
			}
			
			var clasename:String = "";
			// 人物实例 xc 开头
			// 人物模板 xct 开头
			// 特效实例 xe 开头
			// 特效模板 xet 开头
			// 地形实例 x 开头
			// 地形模板 xt 开头
			// 地缩略图 thumbnails 开头
			if (filename.substring(0, 3) == "xct")
			{
				clasename = "art.cfg." + "c" + filename.substring(3, filename.length);
			}
			else if (filename.substring(0, 3) == "xet")
			{
				clasename = "art.cfg." + "e" + filename.substring(3, filename.length);
			}
			else if (filename.substring(0, 2) == "xc")
			{
				clasename = "art.cfg." + "c" + filename.substring(2, filename.length);
			}
			else if (filename.substring(0, 2) == "xe")
			{
				clasename = "art.cfg." + "e" + filename.substring(2, filename.length);
			}
			else if (filename.substring(0, 2) == "xt")
			{
				clasename = "art.cfg." + "t" + filename.substring(2, filename.length);
			}
			else if (filename.substring(0, 1) == "x")
			{
				clasename = "art.cfg." + "t" + filename.substring(1, filename.length);
			}
			else if (filename.substring(0, 1) == "s")
			{
				clasename = "art.cfg." + filename;
			}
			else if (filename.substring(0, 3) == "ttb")
			{
				clasename = "art.ttb.t" + filename.substring(3, filename.length);;
			}
			else
			{
				throw new Error("xmlResType no type");
			}
			
			return clasename;
		}
		
		// 获取资源文件的类型
		public static function picResType(path:String):uint
		{
			// 字符串路径分隔符都是 "/"    
			var lastidx:int;
			lastidx = path.lastIndexOf("/");
			if (lastidx == -1)
			{
				lastidx = path.lastIndexOf("\\");
			}
			
			var filename:String;
			if (lastidx != -1)
			{
				filename = path.substring(lastidx, path.length);
			}
			else
			{
				filename = path;
			}
			lastidx = filename.lastIndexOf(".");
			if (lastidx != -1)
			{
				filename = filename.substring(0, lastidx);
			}
			
			var type:int = -1;
			// 人物资源 c 开头
			// 特效资源 e 开头
			// 地形资源 t 开头
			if (filename.substring(0, 1) == "c")
			{
				type = EntityCValue.PHBEINGTEX;
			}
			else if (filename.substring(0, 1) == "e")
			{
				type = EntityCValue.PHEFFTEX;
			}
			else if (filename.substring(0, 1) == "t")
			{
				type = EntityCValue.PHTERTEX;
			}
			else
			{
				throw new Error("xmlResType no type");
			}
			
			return type;
		}
		
		// 从 "e2_e3" 中将 "e3" 提取出来    
		public static function insStrFromModelStr(modelstr:String):String
		{
			var delimit:int = modelstr.indexOf("_");
			if (delimit != -1)
			{
				return modelstr.substring(delimit + 1, modelstr.length);
			}
			
			return "";
		}
		
		// 判断一个特效是绑定在格子的上层还是下层
		public static function effLinkLayer(modelstr:String, context:Context):uint
		{
			var delimit:int = modelstr.indexOf("_");
			var insID:String;
			var insdef:fObjectDefinition;
			if (delimit != -1)
			{
				insID = modelstr.substring(0, delimit);
				insdef = context.m_sceneResMgr.getObjectDefinition(insID);
				if(insdef)
				{
					return insdef.layer;
				}
			}
			
			return 0;
		}
		
		// 分裂模型
		public static function modelInsNum(modelstr:String):uint
		{
			var delimit:int = modelstr.indexOf("_");
			var insID:String;
			if (delimit != -1)
			{
				insID = modelstr.substring(delimit + 1, modelstr.length);
				return parseInt(insID.substring(1, insID.length));
			}
			else
			{
				return parseInt(modelstr.substring(1, modelstr.length));
			}
			
			return 0;
		}
		
		// 战斗特效绑定位置是格子上还是每一个人身上
		public static function modelBindType(modelstr:String, context:Context):uint
		{
			var delimit:int = modelstr.indexOf("_");
			var insID:String;
			var insdef:fObjectDefinition;
			if (delimit != -1)
			{
				insID = modelstr.substring(0, delimit);
				insdef = context.m_sceneResMgr.getObjectDefinition(insID);
				if(insdef)
				{
					return insdef.bindType;
				}
			}
			
			return 0;
		}
		
		// 根据模型获取这个资源的名字
		public static function resName(insID:String, act:uint, dir:uint):String
		{
			return insID + "_" + act + "_" + dir + ".swf";
		}
		
		public static function getNpcLayer(npcid:uint):uint
		{
			if(1024 == npcid || 1025 == npcid)
			{
				return EntityCValue.SLBuild;
			}
			
			return EntityCValue.SLObject; 
		}
		
		// 插入排序，进行深度排序，因为很多时候基本是有序的，因此使用插入排序
		public static function insortSort(sortarr:Array):void
		{
			var i:int = 0;
			var k:int = 0;
			var val:fRenderableElement = null;
			
			for(i = 1; i < sortarr.length ; i++)
			{
				k = i - 1;
				val = sortarr[i];
				while(k >= 0 && sortarr[k].y > val.y)
				{
					sortarr[k+1] = sortarr[k];
					k--;
				}
				
				sortarr[k + 1] = val;
				
				
				// 如果 _depth 相等，就比较距离
				if (k >= 0 && sortarr[k].y == val.y)
				{
					// 如果正好前面这个距离比后面这个距离大
					if (val.x < sortarr[k].x)
					{
						// 交换最后这两个
						sortarr[k + 1] = sortarr[k];
						sortarr[k] = val;
					}
				}
			}
		}
		
		// 通过资源加载的路径获取实例 id ，例如 asset/scene/xml/being/xc50.swf 实例 id 是 c50
		public static function getInsIDByPath(path:String):String
		{
			var delimit:int = path.lastIndexOf("/");
			var dot:int = path.lastIndexOf(".");
			var insID:String;
			if (delimit != -1)
			{
				insID = path.substring(delimit + 2, dot);
				return insID;
			}
			
			return null;
		}
		
		// 根据图片的资源的名字获取动作编号 E:\work\client-06\trunk\client\bin\asset\scene\being\c13_8_2.swf  获取 8
		public static function getActByPath(path:String):String
		{
			var firline:int = path.indexOf("_");
			var sndline:int = path.indexOf("_", firline + 1);
			
			return(path.substring(firline + 1, sndline));
		}
		
		// 根据图片的资源的名字获取方向编号 E:\work\client-06\trunk\client\bin\asset\scene\being\c13_8_2.swf  获取 2
		public static function getDirByPath(path:String):String
		{
			var firline:int = path.indexOf("_");
			var sndline:int = path.indexOf("_", firline + 1);
			var dot:uint = path.indexOf(".");
			
			return(path.substring(sndline + 1, dot));
		}
		
		// 从打包的符号中获取方向编号
		// 老版本的符号如下 "art.scene.c10" c10 是指第 1 个方向的第 0 个编号，返回值是 1 
		// 新版本的符号如下 "art.scene.c315_0_10" 是指 c315 模型的第 0 个动作的第 1 个方向的第 0 编号，获取的是 1，返回值是1
		public static function getDirBySymbol(symbol:String):String
		{
			//if (fUtil.isSymbolAddPackage(ins))
			//{
				var ridx:int = symbol.lastIndexOf("_");
				if(ridx != -1)
				{
					return symbol.substr(ridx + 1, 1);
				}
				//return "0";
				return symbol.substr(11, 1);
			//}
			//else
			//{
			//	return symbol.substr(11, 1);
			//}
		}
		
		// 暂时添加，是否符号需要添加包的名字
		//public static function isSymbolAddPackage(ins:String):Boolean
		//{
		//	if(ins == "c315" ||
		//	   ins == "c511" ||
		//	   ins == "c512" ||
		//	   ins == "c521" ||
		//	   ins == "c522" ||
		//	   ins == "c531" ||
		//	   ins == "c532" ||
		//	   ins == "c541" ||
		//	   ins == "c542"
		//	   )
		//	{
		//		return true;
		//	}
		//	
		//	return false;
		//}
		
		// 获取当前动作方向的映射关系， 0 - 6  1 - 5  2 - 4  3 - 3 7 - 7
		public static function getMirror(src:uint):uint
		{
			var dest:uint = 0;
			if(0 == src)
			{
				dest = 6;
			}
			else if(1 == src)
			{
				dest = 5;
			}
			else if(2 == src)
			{
				dest = 4;
			}
			else if(3 == src)
			{
				dest = 3;
			}
			else if(7 == src)
			{
				dest = 7;
			}
			else if (4 == src)
			{
				dest = 2;
			}
			else if (5 == src)
			{
				dest = 1;
			}
			else if (6 == src)
			{
				dest = 0;
			}
			
			return dest;
		}
		
		// 转换对应的动作到对应的状态
		public static function act2state(act:uint):uint
		{
			if(EntityCValue.TActStand == act)
			{
				return EntityCValue.TStand;
			}
			else if(EntityCValue.TActRun == act)
			{
				return EntityCValue.TRun;
			}
			else if(EntityCValue.TActJump == act)
			{
				return EntityCValue.TJump;
			}
			else if(EntityCValue.TActAttack == act)
			{
				return EntityCValue.TAttack;
			}
			else if(EntityCValue.TActHurt == act)
			{
				return EntityCValue.THurt;
			}
			else if(EntityCValue.TActDie == act)
			{
				return EntityCValue.TDie;
			}
			else if(EntityCValue.TActDaZuo == act)
			{
				return EntityCValue.TDaZuo;
			}
			
			return EntityCValue.TStand;
		}
		public static function assert(e:Boolean, mess:String = null):void
		{			
			if (!e)
			{
				var str:String = (new Error()).getStackTrace();
				if (mess)
				{
					str += mess;
				}
				DebugBox.info(str);	
				if (DebugBox.m_context.m_config.m_versionForOutNet==false)
				{				
					var a:String = null;
					a.charAt(1);
				}
				
			}
		}
		public static function IsNullOrEmpty(str:String):Boolean
		{
			if(!str || !str.length)
			{
				return true;
			}
			
			return false;
		}
		
		// 从 1 开始到 50;
		public static function Arabic2CapitalDigit(digit:int):String
		{
			// 如果没有初始化,就初始化
			if(!m_dicA2CDigit)
			{
				m_dicA2CDigit = new Dictionary();
				m_dicA2CDigit[1] = "一";
				m_dicA2CDigit[2] = "二";
				m_dicA2CDigit[3] = "三";
				m_dicA2CDigit[4] = "四";
				m_dicA2CDigit[5] = "五";
				m_dicA2CDigit[6] = "六";
				m_dicA2CDigit[7] = "七";
				m_dicA2CDigit[8] = "八";
				m_dicA2CDigit[9] = "九";
				m_dicA2CDigit[10] = "十";
				
				m_dicA2CDigit[11] = "十一";
				m_dicA2CDigit[12] = "十二";
				m_dicA2CDigit[13] = "十三";
				m_dicA2CDigit[14] = "十四";
				m_dicA2CDigit[15] = "十五";
				m_dicA2CDigit[16] = "十六";
				m_dicA2CDigit[17] = "十七";
				m_dicA2CDigit[18] = "十八";
				m_dicA2CDigit[19] = "十九";
				m_dicA2CDigit[20] = "二十";
				
				m_dicA2CDigit[21] = "二十一";
				m_dicA2CDigit[22] = "二十二";
				m_dicA2CDigit[23] = "二十三";
				m_dicA2CDigit[24] = "二十四";
				m_dicA2CDigit[25] = "二十五";
				m_dicA2CDigit[26] = "二十六";
				m_dicA2CDigit[27] = "二十七";
				m_dicA2CDigit[28] = "二十八";
				m_dicA2CDigit[29] = "二十九";
				m_dicA2CDigit[30] = "三十";
				
				m_dicA2CDigit[31] = "三十一";
				m_dicA2CDigit[32] = "三十二";
				m_dicA2CDigit[33] = "三十三";
				m_dicA2CDigit[34] = "三十四";
				m_dicA2CDigit[35] = "三十五";
				m_dicA2CDigit[36] = "三十六";
				m_dicA2CDigit[37] = "三十七";
				m_dicA2CDigit[38] = "三十八";
				m_dicA2CDigit[39] = "三十九";
				m_dicA2CDigit[40] = "四十";
				
				m_dicA2CDigit[41] = "四十一";
				m_dicA2CDigit[42] = "四十二";
				m_dicA2CDigit[43] = "四十三";
				m_dicA2CDigit[44] = "四十四";
				m_dicA2CDigit[45] = "四十五";
				m_dicA2CDigit[46] = "四十六";
				m_dicA2CDigit[47] = "四十七";
				m_dicA2CDigit[48] = "四十八";
				m_dicA2CDigit[49] = "四十九";
				m_dicA2CDigit[50] = "五十";
			}
			
			return m_dicA2CDigit[digit];
		}
		
		// 判断是不是同一个军团的人
		public static function isSameCorps(a:String, b:String):Boolean
		{
			if(a && b && a == b)
			{
				return true;
			}
			
			return false
		}
		
		public static function getStackInfo(msg:String):String
		{
			try
			{
				throw new Error(msg);
			}
			catch (e:Error)
			{
				return msg+"\n堆栈" + e.getStackTrace();
			}
		}
		
		// 转换 player 动作到坐骑动作，例如 player 13 -- 坐骑 0 ，player 14 -- 坐骑 2
		public static function getMountActByPlayerAct(playeract:int):int
		{
			if (13 == playeract)
			{
				return 0;
			}
			else if (14 == playeract)
			{
				return 2;
			}
			
			return 0;
		}
		
		// 通过玩家的坐骑的动作获取 Player 的动作
		public static function getPlayerActByMountAct(mountact:int):int
		{
			if (0 == mountact)
			{
				return 13;
			}
			else if (2 == mountact)
			{
				return 14;
			}
			
			return 13;
		}
		
		// 根据服务器 mountid 获取坐骑表中的 id
		public static function mountsTblID(servermountid:uint, servermountlvl:uint):uint
		{
			return servermountid * 100 + servermountlvl;
		}

		// 获取服务器坐骑 id
		public static function serverMountsID(mountstableid:uint):uint
		{
			return mountstableid / 100;
		}
		
		// 获取服务器坐骑 level
		public static function serverMountsLvl(mountstableid:uint):uint
		{
			return mountstableid % 100;
		}
		
		// 通过 mounttblid 获取坐骑显示的种类，例如 210010 究竟是返回 2
		public static function mountsTblID2Type(mountstableid:uint):uint
		{
			if(mountstableid/100000 < 4)
			{
				return mountstableid/100000;
			}
			else
			{
				return 1;
			}
		}
		
		// 通过 mounttblid 获取坐骑显示的种类和id，例如 110010 就是返回 1100 
		public static function mountsTblID2TypeAndID(mountstableid:uint):uint
		{
			return mountstableid/100;
			//return mountstableid/10000 + 1 * 10;
		}
		
		// 坐骑两个模型，一个是场景中的模型，一个是界面的模型,在场景模型前面添加 1
		public static function convSceneModel2UIModel(scenemodel:String):String
		{
			var lineidx:int = scenemodel.indexOf("_");
			if(lineidx != -1)
			{
				return scenemodel.substring(0, lineidx + 2) + "1" + scenemodel.substring(lineidx + 2, scenemodel.length);
			}
			
			return scenemodel;
		}
		
		public static function isEmptyRes(path:String):Boolean
		{
			switch(path)
			{
				case "c21_2_1.swf":
				case "c131_9_7.swf":
			    case "c131_9_3.swf":
				case "c131_9_2.swf":
				case "c131_9_1.swf":
			    case "c131_9_0.swf":
				case "c112_9_7.swf":
				case "c112_9_3.swf":
				case "c112_9_2.swf":
				case "c112_9_1.swf":
				case "c112_9_0.swf":
				case "c111_7_0.swf":
				case "c111_7_2.swf":
				case "c111_7_3.swf":
				case "c111_7_7.swf":
					return true;
			}
			
			return false;
		}
		
		public static function keyValueToString(...arg):String
		{
			var ret:String = "(";
			var i:int;
			for (i = 0; i+1 < arg.length; i += 2)
			{
				if (i > 0)
				{
					ret += ", ";
				}
				ret += arg[i] + "=" + arg[i + 1];
			}
			ret += ")";
			return ret;
		}
	}
}