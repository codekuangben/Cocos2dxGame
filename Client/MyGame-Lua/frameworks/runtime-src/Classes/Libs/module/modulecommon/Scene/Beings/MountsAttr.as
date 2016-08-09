package modulecommon.scene.beings
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.mountscmd.TypeValue;
	import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.net.msg.mountscmd.stMountSysInfoCmd;
	import modulecommon.net.msg.mountscmd.stNotifyTrainPropsCmd;
	import modulecommon.net.msg.mountscmd.stTrainProp;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TMouseItem;
	
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * @brief 坐骑属性
	 */
	public class MountsAttr 
	{
		// 坐骑系统培养属性，动态生成
		public static const MOUNTSYS_ARMYFORCE:uint = 1; //全军武力
		public static const MOUNTSYS_ARMYIQ:uint = 2; //全军智力
		public static const MOUNTSYS_ARMYCHIEF:uint = 3; //全军统率
		public static const MOUNTSYS_ARMYHP:uint = 4; //全军兵力
		
		public static var m_trainAttrId2Name:Dictionary;		// 培养属性 id 到名字映射
		public static var m_trainAttrId2NameSimple:Dictionary;		// 培养属性 id 到名字映射,去掉全局
		
		// 图鉴属性，读取表格的属性，所有坐骑属性加成
		public static const MOUNTMAP_ARMYFORCE:uint = 1; //全军武力
		public static const MOUNTMAP_ARMYIQ:uint = 2; //全军智力
		public static const MOUNTMAP_ARMYCHIEF:uint = 3; //全军统率
		public static const MOUNTMAP_ARMYHP:uint = 4; //全军兵力
		public static const MOUNTMAP_ARMYATTACK:uint = 5; //全军攻击(双攻)
		public static const MOUNTMAP_ARMYDEF:uint = 6; //全军防御(双防御)
		public static const MOUNTMAP_ARMYSPEED:uint = 7; //全军速度
		public static const MOUNTMAP_FRONTFORCE:uint = 8; //前军武力
		public static const MOUNTMAP_FRONTIQ:uint = 9; //前军智力
		public static const MOUNTMAP_FRONTCHIEF:uint = 10; //前军统率
		public static const MOUNTMAP_FRONTHP:uint = 11; //前军兵力
		public static const MOUNTMAP_FRONTATTACK:uint = 12; //前军攻击(双攻)
		public static const MOUNTMAP_FRONTDEF:uint = 13; //前军防御(双防)
		public static const MOUNTMAP_FRONTSPEED:uint = 14; //前军速度
		public static const MOUNTMAP_CENTERFORCE:uint = 15; //中军武力
		public static const MOUNTMAP_CENTERIQ:uint = 16; //中军智力
		public static const MOUNTMAP_CENTERCHIEF:uint = 17; //中军统率
		public static const MOUNTMAP_CENTERHP:uint = 18; //中军兵力
		public static const MOUNTMAP_CENTERATTACK:uint = 19; //中军攻击(双攻)
		public static const MOUNTMAP_CENTERDEF:uint = 20; //中军防御(双防)
		public static const MOUNTMAP_CENTERSPEED:uint = 21; //中军速度
		public static const MOUNTMAP_BACKFORCE:uint = 22; //后军武力
		public static const MOUNTMAP_BACKIQ:uint = 23; //后军智力
		public static const MOUNTMAP_BACKCHIEF:uint = 24; //后军统率
		public static const MOUNTMAP_BACKHP:uint = 25; //后军兵力
		public static const MOUNTMAP_BACKATTACK:uint = 26; //后军攻击(双攻)
		public static const MOUNTMAP_BACKDEF:uint = 27; //后军防御(双防)
		public static const MOUNTMAP_BACKSPEED:uint = 28; //后军速度
		
		// 图鉴 id 到名字映射
		public static var m_tblAttrId2Name:Dictionary;		// 图鉴表属性 id 到名字映射
		// 培养属性每升一级增加的属性值 
		public static var m_trainAddedPerLvl:Vector.<uint>;
		
		// 页签
		public static const ePageAll:uint = 0;
		public static const ePageJunMa:uint = 1;		// 坐骑表中最高位是 1
		public static const ePageYiShou:uint = 2;		// 坐骑表中最高位是 2
		public static const ePageXiangRui:uint = 3;		// 坐骑表中最高位是 3
		
		public static const ePageCnt:uint = 4;
		
		// 又加了一个技能等级属性
		//enum eMountTrainExtraProp
		//{
		//	MTEP_NONE = 0, 
		//	MTEP_CENTERATTACK = 1,  //中军攻击
		//	MTEP_BACKATTACK = 2,    //后军攻击
		//	MTEP_FRONTPHYDEF = 3,   //前军物理防御
		//	MTEP_FRONTSTRATEGYDEF = 4,  //前军策略防御
		//	MTEP_MAX,
		//};
		// 技能增加的属性的类型
		public static const MTEP_NONE:uint = 0;
		public static const MTEP_CENTERATTACK:uint = 1;
		public static const MTEP_BACKATTACK:uint = 2;
		public static const MTEP_FRONTPHYDEF:uint = 3;
		public static const MTEP_FRONTSTRATEGYDEF:uint = 4;
		public static const MTEP_MAX:uint = 5;
		// 技能增加的属性的名字
		public static var m_skillAddPropNameDic:Dictionary;


		protected var m_gkcontext:GkContext;
		protected var m_baseAttr:stMountSysInfoCmd;			// 基本属性
		protected var m_trainAttr:stNotifyTrainPropsCmd;	// 培养属性
		protected var m_tujianAttrLst:Vector.<MountsTJAttrItem>;	// 自己读取表格生成的图鉴属性
		
		protected var m_mountsLst:Vector.<Vector.<stMountData>>;	// 自己由于界面系那是需要分开的列表
		protected var m_times:uint = 3;     //已使用免费次数，默认是没有免费次数的，如果还有免费次数，服务器会发送消息通知的，一旦使用了 3 次，就不会再次发送
		
		public function MountsAttr(gk:GkContext)
		{
			if(!m_trainAttrId2Name)
			{
				m_trainAttrId2Name = new Dictionary();
				m_trainAttrId2Name[MOUNTSYS_ARMYFORCE] = "全军武力";
				m_trainAttrId2Name[MOUNTSYS_ARMYIQ] = "全军智力";
				m_trainAttrId2Name[MOUNTSYS_ARMYCHIEF] = "全军统率";
				m_trainAttrId2Name[MOUNTSYS_ARMYHP] = "全军兵力";
				
				m_trainAttrId2NameSimple = new Dictionary();
				m_trainAttrId2NameSimple[MOUNTSYS_ARMYFORCE] = "武力";
				m_trainAttrId2NameSimple[MOUNTSYS_ARMYIQ] = "智力";
				m_trainAttrId2NameSimple[MOUNTSYS_ARMYCHIEF] = "统率";
				m_trainAttrId2NameSimple[MOUNTSYS_ARMYHP] = "兵力";
				
				m_tblAttrId2Name = new Dictionary();
				
				m_tblAttrId2Name[MOUNTMAP_ARMYFORCE] = "全军武力";
				m_tblAttrId2Name[MOUNTMAP_ARMYIQ] = "全军智力";
				m_tblAttrId2Name[MOUNTMAP_ARMYCHIEF] = "全军统率";
				m_tblAttrId2Name[MOUNTMAP_ARMYHP] = "全军兵力";
				m_tblAttrId2Name[MOUNTMAP_ARMYATTACK] = "全军攻击";
				m_tblAttrId2Name[MOUNTMAP_ARMYDEF] = "全军防御";
				m_tblAttrId2Name[MOUNTMAP_ARMYSPEED] = "全军速度";
				m_tblAttrId2Name[MOUNTMAP_FRONTFORCE] = "前军武力";
				m_tblAttrId2Name[MOUNTMAP_FRONTIQ] = "前军智力";
				m_tblAttrId2Name[MOUNTMAP_FRONTCHIEF] = "前军统率";
				m_tblAttrId2Name[MOUNTMAP_FRONTHP] = "前军兵力";
				m_tblAttrId2Name[MOUNTMAP_FRONTATTACK] = "前军攻击";
				m_tblAttrId2Name[MOUNTMAP_FRONTDEF] = "全军武力";
				m_tblAttrId2Name[MOUNTMAP_FRONTDEF] = "前军防御";
				m_tblAttrId2Name[MOUNTMAP_FRONTSPEED] = "前军速度";
				m_tblAttrId2Name[MOUNTMAP_CENTERFORCE] = "中军武力";
				m_tblAttrId2Name[MOUNTMAP_CENTERIQ] = "中军智力";
				m_tblAttrId2Name[MOUNTMAP_CENTERCHIEF] = "中军统率";
				m_tblAttrId2Name[MOUNTMAP_CENTERHP] = "中军兵力";
				m_tblAttrId2Name[MOUNTMAP_CENTERATTACK] = "中军攻击";
				m_tblAttrId2Name[MOUNTMAP_CENTERDEF] = "中军防御";
				m_tblAttrId2Name[MOUNTMAP_CENTERSPEED] = "中军速度";
				m_tblAttrId2Name[MOUNTMAP_BACKFORCE] = "后军武力";
				m_tblAttrId2Name[MOUNTMAP_BACKIQ] = "后军智力";
				m_tblAttrId2Name[MOUNTMAP_BACKCHIEF] = "后军统率";
				m_tblAttrId2Name[MOUNTMAP_BACKHP] = "后军兵力";
				m_tblAttrId2Name[MOUNTMAP_BACKATTACK] = "后军攻击";
				m_tblAttrId2Name[MOUNTMAP_BACKDEF] = "后军防御";
				m_tblAttrId2Name[MOUNTMAP_BACKSPEED] = "后军速度";
				
				m_trainAddedPerLvl = new Vector.<uint>();
				m_trainAddedPerLvl.push(0);			// 由于索引是从 1 开始的，因此索引 0 填写一个 0 占位
				m_trainAddedPerLvl.push(10);		// 
				m_trainAddedPerLvl.push(10);		// 
				m_trainAddedPerLvl.push(8);			// 
				m_trainAddedPerLvl.push(50);		// 
				
				m_skillAddPropNameDic = new Dictionary();
				m_skillAddPropNameDic[MTEP_CENTERATTACK] = "中军攻击";
				m_skillAddPropNameDic[MTEP_BACKATTACK] = "后军攻击";
				m_skillAddPropNameDic[MTEP_FRONTPHYDEF] = "前军物理防御";
				m_skillAddPropNameDic[MTEP_FRONTSTRATEGYDEF] = "前军策略防御";
			}

			m_gkcontext = gk;
			
			m_mountsLst = new Vector.<Vector.<stMountData>>(ePageCnt, true);
			var idx:uint = 0;
			while (idx < ePageCnt)
			{
				m_mountsLst[idx] = new Vector.<stMountData>();
				++idx;
			}
			
			m_tujianAttrLst = new Vector.<MountsTJAttrItem>();
			m_baseAttr = new stMountSysInfoCmd(m_gkcontext);			// 只有有坐骑的时候上线才会发送 stMountSysInfoCmd ，如果没有坐骑上线是不会发送这个消息的
			m_trainAttr = new stNotifyTrainPropsCmd();
		}
		
		// 增加或者刷新坐骑
		public function addorRefreshMounts(action:uint, mount:stMountData):void
		{
			if (action == 0)	// 如果添加直接放入
			{
				m_baseAttr.mountlist.push(mount);
				var mounttype:uint = 0;
				mounttype = mount.mountid / 1000;
				if(!existInArray(m_mountsLst[0], mount))
				{
					m_mountsLst[0].push(mount);
				}
				if(!existInArray(m_mountsLst[mounttype], mount))
				{
					m_mountsLst[mounttype].push(mount);
				}
				
				m_mountsLst[0].sort(compareFunction);
				m_mountsLst[mounttype].sort(compareFunction);
			}
			else	// 刷新
			{
				// 查找到坐骑
				var retmount:stMountData = findMounts(mount);
				if (retmount)
				{
					retmount.copyFrom(mount);
				}
			}
			
			buildTJAttr();
		}
		
		// 查找坐骑
		public function findMounts(mount:stMountData):stMountData
		{
			for each(var item:stMountData in m_baseAttr.mountlist)
			{
				if (mount.mountid == item.mountid)	// server 相同就是相同，不要判断 level
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function get baseAttr():stMountSysInfoCmd
		{
			return m_baseAttr;
		}
		
		public function set baseAttr(value:stMountSysInfoCmd):void
		{
			m_baseAttr = value;
			buildSubLst();
			buildTJAttr();
		}
		
		public function get trainAttr():stNotifyTrainPropsCmd
		{
			return m_trainAttr;
		}
		
		public function set trainAttr(value:stNotifyTrainPropsCmd):void
		{
			m_trainAttr = value;
		}
		
		public function get mountsLst():Vector.<Vector.<stMountData>>
		{
			return m_mountsLst;
		}
		
		public function set mountsLst(value:Vector.<Vector.<stMountData>>):void
		{
			m_mountsLst = value;
		}
		
		// 清除数据
		public function clearSubLst():void
		{
			for each(var lst:Vector.<stMountData> in m_mountsLst)
			{
				lst.length = 0;
			}
		}
		
		// 生成客户端自己的列表数据
		public function buildSubLst():void
		{
			var mounttype:uint = 0;
			
			for each(var mountitem:stMountData in m_baseAttr.mountlist)
			{
				mounttype = mountitem.mountid / 1000;
				if(!existInArray(m_mountsLst[0], mountitem))
				{
					m_mountsLst[0].push(mountitem);
				}
				if(!existInArray(m_mountsLst[mounttype], mountitem))
				{
					m_mountsLst[mounttype].push(mountitem);
				}
			}
			
			var idx:uint = 0;
			while(idx < ePageCnt)
			{
				m_mountsLst[idx].sort(compareFunction);
				++idx;
			}
		}
		
		public function compareFunction(a:stMountData, b:stMountData):int
		{
			if (a.mountid <= b.mountid)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function tjCompareFunction(a:MountsTJAttrItem, b:MountsTJAttrItem):int
		{
			if (a.m_type <= b.m_type)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		// 生成图鉴属性列表数值
		public function buildTJAttr():void
		{
			m_tujianAttrLst.length = 0;
			
			var mountstableid:uint;
			var mountsItem:TMouseItem;
			var idx:int;
			var type:uint;
			var tjitem:MountsTJAttrItem;
			for each(var mountsdata:stMountData in m_baseAttr.mountlist)
			{
				mountstableid = fUtil.mountsTblID(mountsdata.mountid, mountsdata.level);
				mountsItem = m_gkcontext.m_dataTable.getItem(DataTable.TABLE_MOUNTS, mountstableid) as TMouseItem;
				
				if(mountsItem)
				{
					for(type in mountsItem.m_attrDic)
					{
						idx = findTJAttrIdx(type);
						if(idx != -1)
						{
							m_tujianAttrLst[idx].m_value += mountsItem.m_attrDic[type];
						}
						else
						{
							tjitem = new MountsTJAttrItem();
							tjitem.m_type = type;
							tjitem.m_value = mountsItem.m_attrDic[type];
							m_tujianAttrLst.push(tjitem);
						}
					}
				}
			}
			
			m_tujianAttrLst.sort(tjCompareFunction);
		}
		
		public function findTJAttrIdx(type:uint):int
		{
			var idx:int = 0;
			for each(var item:MountsTJAttrItem in m_tujianAttrLst)
			{
				if(item.m_type == type)
				{
					return idx;
				}
				
				++idx;
			}
			
			return -1;
		}
		
		public function get tujianAttrLst():Vector.<MountsTJAttrItem>
		{
			return m_tujianAttrLst;
		}
		
		public function findMountsAttrValueItem(type:uint):TypeValue
		{
			for each(var item:TypeValue in m_trainAttr.trainprops)
			{
				if(item.type == type)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function findMountsAttrExpItem(type:uint):stTrainProp
		{
			for each(var item:stTrainProp in m_baseAttr.proplist)
			{
				if(item.proptype == type)
				{
					return item;
				}
			}
			
			return null;
		}
		
		protected function existInArray(lst:Vector.<stMountData>, mount:stMountData):Boolean
		{
			for each(var item:stMountData in lst)
			{
				if(item.mountid == mount.mountid && item.level == mount.level)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function get times():uint
		{
			return m_times;
		}
		
		public function set times(value:uint):void
		{
			m_times = value;
		}
		
		public function findMountsDataByIndexAndId(index:int, servermountid:uint):stMountData
		{
			var item:stMountData;
			for each(item in m_mountsLst[index])
			{
				if(item.mountid == servermountid)
				{
					return item;
				}
			}
			
			return null;
		}
	}
}