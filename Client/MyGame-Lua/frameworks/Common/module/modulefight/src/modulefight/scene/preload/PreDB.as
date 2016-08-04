package modulefight.scene.preload
{
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import modulefight.scene.fight.FightDB;
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.scene.preload.PreXMLItem;
	
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * ...
	 * @author ...
	 * @brief 加载的数据管理
	 */
	public class PreDB 
	{
		public var m_gkContext:GkContext;
		private var m_fightDB:FightDB;
		public var m_ItemList:Vector.<PrePicItem>;	// 所有预加载的列表
		public var m_xmlItem:PreXMLItem;			// 这个是加载 XML 的文件内容
		public var m_curItemIdx:int = -1;			// 当前加载的索引
		
		public var m_initReady:Boolean = false;			// 是否初始资源加载完成
		
		public function PreDB(value:GkContext,fightDB:FightDB)
		{
			m_gkContext = value;
			m_fightDB = fightDB;
			m_ItemList = new Vector.<PrePicItem>();
			m_xmlItem = new PreXMLItem(m_gkContext);
			m_xmlItem.m_onLF = onXMLLoaded;
		}
		
		public function dispose():void
		{
			for each(var item:PreItem in m_ItemList)
			{
				item.dispose();
			}
			// 释放 xml 配置信息
			m_xmlItem.dispose();
			
			m_ItemList.length = 0;
			m_ItemList = null;
		}
		
		// 准备需要加载的资源,把配置文件以及资源文件全部加载
		public function prepInitRes():void
		{
			var battle:BattleArray;
			var prebattle:BattleArray;
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			var filename:String;
			
			var mat:stMatrixInfo;
			var matList:Vector.<stMatrixInfo>;
			var prePicItem:PrePicItem = new PrePicItem(m_gkContext);
			var batCnt:uint = 0;	// 战斗回合数量
			var batTotal:uint = 5;  // 总共收集的回合数
			var hasPicEff:Boolean = false;	// 是否有图片特效资源
			
			/*
			// test:测试加载的数据
			filename = getXMLResPath("e3_e1112");
			if (filename)
			{
				m_xmlItem.m_nameList.push(filename);
				m_xmlItem.loadOne(filename);
			}
			
			hasPicEff = true;
			prePicItem.m_modelStrList.push("e3_e1112");
			
			filename = getXMLResPath("e5_e1412");
			if (filename)
			{
				m_xmlItem.m_nameList.push(filename);
				m_xmlItem.loadOne(filename);
			}
			
			hasPicEff = true;
			prePicItem.m_modelStrList.push("e5_e1412");
			
			filename = getXMLResPath("e3_e1914");
			if (filename)
			{
				m_xmlItem.m_nameList.push(filename);
				m_xmlItem.loadOne(filename);
			}
			
			hasPicEff = true;
			prePicItem.m_modelStrList.push("e3_e1914");
			
			filename = getXMLResPath("e8_e1721");
			if (filename)
			{
				m_xmlItem.m_nameList.push(filename);
				m_xmlItem.loadOne(filename);
			}
			
			hasPicEff = true;
			prePicItem.m_modelStrList.push("e8_e1721");
			*/
			
			// 这个遍历所有的 xml 和资源
			var allBattleArray:Vector.<BattleArray> = this.m_fightDB.m_fightProcess.getAllBattleArray();
			for each (battle in allBattleArray)
			{
				hasPicEff = false;
				// 加载技能表中的特效配置文件和技能特效图片文件
				if (battle.type != 0)
				{
					if (battle.skillid)
					{
						skillitem = battle.skillBaseitem;
						if (skillitem)
						{
							// 技能 XML 资源
							if (skillitem.hasAttPreEff()) // 攻击准备特效    
							{
								filename = getXMLResPath(skillitem.preActEff());
								if (filename)
								{
									m_xmlItem.m_nameList.push(filename);
									m_xmlItem.loadOne(filename);
								}
								
								hasPicEff = true;
								prePicItem.m_modelStrList.push(skillitem.preActEff());
							}
							if (skillitem.hasAttActEff()) // 攻击特效    
							{
								filename = getXMLResPath(skillitem.attActEff());
								if (filename)
								{
									m_xmlItem.m_nameList.push(filename);
									m_xmlItem.loadOne(filename);
								}
								
								hasPicEff = true;
								prePicItem.m_modelStrList.push(skillitem.attActEff());
							}
							if (skillitem.hasAttFlyEff()) // 飞行特效  
							{
								filename = getXMLResPath(skillitem.attFlyEff());
								if (filename)
								{
									m_xmlItem.m_nameList.push(filename);
									m_xmlItem.loadOne(filename);
								}
								
								hasPicEff = true;
								prePicItem.m_modelStrList.push(skillitem.attFlyEff());
							}
							if (skillitem.hasAttHitEff()) // 命中特效 
							{
								filename = getXMLResPath(skillitem.hitEff());
								if (filename)
								{
									m_xmlItem.m_nameList.push(filename);
									m_xmlItem.loadOne(filename);
								}
								
								hasPicEff = true;
								prePicItem.m_modelStrList.push(skillitem.hitEff());
							}
						}
					}
				}
				else	// 普通攻击
				{
					// 这个紧紧是收集图片资源
					mat = this.m_fightDB.m_fightProcess.getOneMatrix(battle.aIdx, battle.aTeamid, battle.aGridNO);

					if(mat)
					{
						battlenpcitem = mat.m_npcBase;
						if (battlenpcitem.npcBattleModel.hasAttActEff()) // 攻击特效    
						{
							filename = getXMLResPath(battlenpcitem.npcBattleModel.attActEff());
							if (filename)
							{
								m_xmlItem.m_nameList.push(filename);
								m_xmlItem.loadOne(filename);
							}
							
							hasPicEff = true;
							prePicItem.m_modelStrList.push(battlenpcitem.npcBattleModel.attActEff());
						}
						if (battlenpcitem.npcBattleModel.hasAttFlyEff()) // 飞行特效  
						{
							filename = getXMLResPath(battlenpcitem.npcBattleModel.attFlyEff());
							if (filename)
							{
								m_xmlItem.m_nameList.push(filename);
								m_xmlItem.loadOne(filename);
							}
							
							hasPicEff = true;
							prePicItem.m_modelStrList.push(battlenpcitem.npcBattleModel.attFlyEff());
						}
						if (battlenpcitem.npcBattleModel.hasAttHitEff()) // 命中特效 
						{
							filename = getXMLResPath(battlenpcitem.npcBattleModel.hitEff());
							if (filename)
							{
								m_xmlItem.m_nameList.push(filename);
								m_xmlItem.loadOne(filename);
							}
							
							hasPicEff = true;
							prePicItem.m_modelStrList.push(battlenpcitem.npcBattleModel.hitEff());
						}
					}
				}
				
				if(hasPicEff)
				{
					++batCnt;		// 增加战斗回合计数
					// 技能图片资源
					if(batCnt >= batTotal)	// 下一个回个
					{
						m_ItemList.push(prePicItem);
						prePicItem = new PrePicItem(m_gkContext);
						batCnt = 0;
					}
				}
				
				// 保存之前的战斗
				prebattle = battle;
			}
			
			// 这个紧紧是遍历 xml 资源
			matList = this.m_fightDB.m_fightProcess.getMaxtrixList();
			for each (mat in matList)
			{
				battlenpcitem = mat.m_npcBase;
				if (battlenpcitem.npcBattleModel.hasAttActEff()) // 攻击特效    
				{
					filename = getXMLResPath(battlenpcitem.npcBattleModel.attActEff());
					if (filename)
					{
						m_xmlItem.m_nameList.push(filename);
						m_xmlItem.loadOne(filename);
					}
				}
				if (battlenpcitem.npcBattleModel.hasAttFlyEff()) // 飞行特效  
				{
					filename = getXMLResPath(battlenpcitem.npcBattleModel.attFlyEff());
					if (filename)
					{
						m_xmlItem.m_nameList.push(filename);
						m_xmlItem.loadOne(filename);
					}
				}
				if (battlenpcitem.npcBattleModel.hasAttHitEff()) // 命中特效 
				{
					filename = getXMLResPath(battlenpcitem.npcBattleModel.hitEff());
					if (filename)
					{
						m_xmlItem.m_nameList.push(filename);
						m_xmlItem.loadOne(filename);
					}
				}
			}
			
			// bug 如果所有的 xml 都已经加载，那么就会有问题
			if(m_xmlItem.m_nameList.length == 0)
			{
				onXMLLoaded();
			}
		}
		
		// 根据资源id获取资源目录，主要是针对 xml 资源的，资源 id 为 e3_e200 如果这个资源没有加载，就返回路径，如果已经加载就直接返回 null ，主要是判断和返回都卸载一起，不用判断一个函数，再次获取又一个函数
		public function getXMLResPath(modelstr:String):String
		{
			var filename:String = "";
			var insID:String = "";
			var type:int = 0;
			var insdef:fObjectDefinition;
			
			insID = fUtil.insStrFromModelStr(modelstr);
			if (insID.length == 0)
			{
				DebugBox.info("loadInitRes()模型名称不正确:" + modelstr);
				return null;
			}
			insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
			if (!insdef)	// 不存在就加载，如果已经有了就不加载了
			{
				filename = "x" + insID;
				type = fUtil.xmlResType(filename);
				filename = this.m_gkContext.m_context.m_path.getPathByName(filename + ".swf", type);
				
				if(m_xmlItem.m_nameList.indexOf(filename) == -1)	// 如果之前没有加入
				{
					return filename;
				}
			}
			
			return null;
		}
		
		public function onXMLLoaded():void
		{
			// 图片资源在脚本中触发加载,这里面就不加载了
			//loadNext();
			// 直接进入战斗
			onPicLoaded();
		}
		
		public function onPicLoaded():void
		{
			m_initReady = true;
			this.m_fightDB.m_fightControl.attemptBegin();
		}
		
		public function loadNext():void
		{
			++m_curItemIdx;
			if(m_curItemIdx < m_ItemList.length)	// 如果有资源需要加载
			{
				if(m_curItemIdx == 0)
				{
					m_ItemList[m_curItemIdx].m_onLF = onPicLoaded;	// 只有第一个有这个会回调，其余都没有
				}
				m_ItemList[m_curItemIdx].loadRes();
			}
			else if(m_ItemList.length == 0)		// bug 如果图片资源全部加载了
			{
				if(m_curItemIdx == 0)
				{
					onPicLoaded();
				}
			}
		}
	}
}