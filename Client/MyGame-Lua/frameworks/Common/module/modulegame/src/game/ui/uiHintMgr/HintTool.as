package game.ui.uiHintMgr 
{
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	/**
	 * ...
	 * @author 
	 */
	public class HintTool 
	{
		/*判断所有武将，如果指定武将是该武将的关系武将之一，且该武将已被激活，则将该武将加入容器中
		 * 指定武将为: param["hero"]
		 * 容器: param["collector"]
		 * 
		 * 参数:wuJudged - 被判断的武将
		 */ 
		public static function collectActivedHerosByhero(wuJudged:WuHeroProperty, param:Object):void 
		{
			if (wuJudged.isActive == false)
			{
				return;
			}
			
			var hero:WuHeroProperty = param["hero"];
			var i:int;
			for (i = 0; i < wuJudged.m_vecActiveHeros.length; i++)
			{
				if (wuJudged.m_vecActiveHeros[i].id == hero.tableID)
				{
					var collector:Vector.<WuHeroProperty> = param["collector"] as Vector.<WuHeroProperty>;
					collector.push(wuJudged);
					return;
				}
			}		
		}
		
		/*
		*获取可转生的武将
		*/
		public static function collectRebirthHeros(wu:WuHeroProperty,param:Object):void
		{
			var collector:Vector.<WuHeroProperty> = param["collector"] as Vector.<WuHeroProperty>;
			if(wu.canZhuansheng())
			{
				collector.push(wu);
			}
		}
		
		/*
		 * 返回武将ID，该武将ID的同等部位没有该装备或，装备比obj劣质。
		 */ 
		public static function getHeroIDWithInferiorEquip(gk:GkContext, obj:ZObject):uint
		{			
			if (obj.isEquiped)
			{
				return 0;
			}
			var pack:Package;
			var list:Array = gk.m_wuMgr.getFightWuList(true, true);
			var i:int;
			var equipObj:ZObject;
			var retHeroID:uint = 0;
			for (i = 0; i < list.length; i++)
			{
				pack = gk.m_objMgr.getEquipPakage(list[i].m_uHeroID);
				if (pack)
				{
					equipObj = pack.getEquipInEquipPakage(obj.type);
					if (equipObj == null || equipObj.m_object.m_equipData.equipmark < obj.m_object.m_equipData.equipmark)
					{
						retHeroID = list[i].m_uHeroID;
						break;
					}					
				}
			}
			
			return retHeroID;
		}
		
		//判断是否需要变换阵型
		public static function judgeChangeMatrix(gk:GkContext,wu:WuHeroProperty):Boolean
		{
			//阵法功能未开启时，不显示该提示
			if (!gk.m_sysnewfeatures.isSet(SysNewFeatures.NFT_ZHENFA))
			{
				return false;
			}
			
			var list:Array = gk.m_wuMgr.getFightWuList(true, false);
			var i:int;
			for (i = 0; i < list.length; i++)
			{
				var tempwu:WuHeroProperty = (list[i] as WuHeroProperty);
				if((wu.m_npcBase.m_iZhenwei == tempwu.m_npcBase.m_iZhenwei)
					&& wu.m_uZhanli > tempwu.m_uZhanli)
				{
					return true;
				}
			}
			
			return false;
		}
		
	}

}