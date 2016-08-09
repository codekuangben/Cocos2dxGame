package app.util
{
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import common.logicinterface.IPath;
	/**
	 * ...
	 * @author ...
	 */
	public class Path implements IPath
	{
		public var m_context:Context;
		protected var m_sceneRPath:Vector.<String>;		// 场景资源目录
		
		public function Path(context:Context)
		{
			m_context = context;
			m_sceneRPath = new Vector.<String>(16, true);
		}
		
		public function init():void
		{
			// 注册所有的路径
			m_sceneRPath[EntityCValue.PHBEINGTEX] = m_context.m_config.m_rootPath + m_context.m_config.m_beingTexPath;
			m_sceneRPath[EntityCValue.PHTERTEX] = m_context.m_config.m_rootPath + m_context.m_config.m_terTexPath;
			m_sceneRPath[EntityCValue.PHEFFTEX] = m_context.m_config.m_rootPath + m_context.m_config.m_effTexPath;
			m_sceneRPath[EntityCValue.PHFOBJTEX] = m_context.m_config.m_rootPath + m_context.m_config.m_fobjTexPath;
			m_sceneRPath[EntityCValue.PHXMLCINS] = m_context.m_config.m_rootPath + m_context.m_config.m_xmlcins;
			m_sceneRPath[EntityCValue.PHXMLCTPL] = m_context.m_config.m_rootPath + m_context.m_config.m_xmlctpl;
			m_sceneRPath[EntityCValue.PHXMLEINS] = m_context.m_config.m_rootPath + m_context.m_config.m_xmleins;
			m_sceneRPath[EntityCValue.PHXMLETPL] = m_context.m_config.m_rootPath + m_context.m_config.m_xmletpl;
			m_sceneRPath[EntityCValue.PHXMLTINS] = m_context.m_config.m_rootPath + m_context.m_config.m_xmltins;
			m_sceneRPath[EntityCValue.PHXMLTTPL] = m_context.m_config.m_rootPath + m_context.m_config.m_xmlttpl;
			m_sceneRPath[EntityCValue.PHBUFFICON] = m_context.m_config.m_rootPath + m_context.m_config.m_bufficon;
			m_sceneRPath[EntityCValue.PHSTOPPT] = m_context.m_config.m_rootPath + m_context.m_config.m_stoppt;
			m_sceneRPath[EntityCValue.PHTTB] = m_context.m_config.m_rootPath + m_context.m_config.m_ttb;
		}
		
		public function dispose():void
		{
			m_sceneRPath = null;
		}
		
		// 通过 ID 获取完全路径 
		public function getPathByID(id:uint, type:uint = 0):String
		{
			var str:String;
			if (type == EntityCValue.RESPMODULE)
			{
				switch (id)
				{					
					case EntityCValue.ModuleGame: 
						str = "asset/module/ModuleGame.swf";
						break;
					//case ConstValue.ModuleFight: 
					//	str = "asset/module/ModuleFight.swf";
					//	break;
					default:
						break;
				}
			}
			else if(type == EntityCValue.RESPXML)
			{
				switch(id)
				{
					case EntityCValue.TBLNpcBase:
						str = "asset/table/npcbase.xml";
						break;
					default:
						break;
				}
			}
			else if (type == EntityCValue.RESTBL)
			{
				str = "asset/config/table.swf";
			}
			else if (type == EntityCValue.RESHDIGIT)
			{
				str = "asset/scene/hurtdigit/hurtdigit.swf";
			}
			
			return str;
		}
		
		// 通过名字获取完整路径 
		public function getPathByName(name:String, type:uint = 0):String
		{
			var str:String;
			/*
			if (type == EntityCValue.PHBEINGTEX)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_beingTexPath + name;
			}
			else if(type == EntityCValue.PHTERTEX)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_terTexPath + name;
			}
			else if (type == EntityCValue.PHEFFTEX)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_effTexPath + name;
			}
			else if (type == EntityCValue.PHFOBJTEX)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_fobjTexPath + name;
			}
			//else if (type == EntityCValue.PHSCENE)
			//{
				//str = m_context.m_config.m_rootPath + m_context.m_config.m_scenePath + name;
			//}
			//else if (type == EntityCValue.PHDEFINE)
			//{
				//str = m_context.m_config.m_rootPath + m_context.m_config.m_sceneDefPath + name;
			//}
			else if (type == EntityCValue.PHXMLCINS)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmlcins + name;
			}
			else if (type == EntityCValue.PHXMLCTPL)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmlctpl + name;
			}
			else if (type == EntityCValue.PHXMLEINS)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmleins + name;
			}
			else if (type == EntityCValue.PHXMLETPL)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmletpl + name;
			}
			else if (type == EntityCValue.PHXMLTINS)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmltins + name;
			}
			else if (type == EntityCValue.PHXMLTTPL)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_xmlttpl + name;
			}
			else if (type == EntityCValue.PHBUFFICON)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_bufficon + name;
			}
			else if (type == EntityCValue.PHSTOPPT)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_stoppt + name;
			}
			else if (type == EntityCValue.PHTTB)
			{
				str = m_context.m_config.m_rootPath + m_context.m_config.m_ttb + name;
			}
			else
			{
				throw new Error("getPathByName type error");
			}
			*/
			str = m_sceneRPath[type] + name;
			return str;
		}
		
		public function convPath2ID(path:String):uint
		{
			var moduleid:uint;
			if ("asset/module/ModuleGame.swf" == path)
			{
				moduleid = EntityCValue.ModuleGame;
			}
			/*else if ("asset/module/ModuleFight.swf" == path)
			{
				moduleid = ConstValue.ModuleFight;
			}*/
			
			return moduleid;
		}
	}
}