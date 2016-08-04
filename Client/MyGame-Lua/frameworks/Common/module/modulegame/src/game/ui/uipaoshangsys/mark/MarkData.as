package game.ui.uipaoshangsys.mark
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.ui.uipaoshangsys.DataPaoShang;
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import game.ui.uipaoshangsys.xml.XmlSegm;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiObject.UIMBeing;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.utils.mathUtils;
	/**
	 * @brief 标示玩家跑商位置的标记
	 */
	public class MarkData implements IMarkData
	{
		protected var m_DataPaoShang:DataPaoShang;
		public var m_dic:Dictionary;
		
		public function MarkData(data:DataPaoShang)
		{
			m_DataPaoShang = data;
			m_dic = new Dictionary();
		}
		
		public function dispose():void
		{
			for(var key:String in m_dic)
			{
				m_DataPaoShang.m_gkcontext.m_context.m_uiObjMgr.releaseUIObject(m_dic[key]);
				m_dic[key] = null;
			}
		}
		
		public function clearHero(stateinfo:BusinessUser):void
		{			
			if (m_dic[stateinfo.id])
			{
				m_DataPaoShang.m_gkcontext.m_context.m_uiObjMgr.releaseUIObject(m_dic[stateinfo.id]);
				m_dic[stateinfo.id] = null;
				delete m_dic[stateinfo.id];
			}
		}
		
		public function createHero(stateinfo:BusinessUser):void
		{
			var isnew:Boolean = false;
			var modelName:String = "";
			modelName = m_DataPaoShang.m_gkcontext.m_context.m_playerResMgr.modelName(stateinfo.job, stateinfo.sex);

			//if (m_dic[stateinfo.id] != null)
			//{
			//	m_DataPaoShang.m_gkcontext.m_context.m_uiObjMgr.releaseUIObject(m_dic[stateinfo.id]);
			//}
			if (m_dic[stateinfo.id] == null)
			{
				m_dic[stateinfo.id] = m_DataPaoShang.m_gkcontext.m_context.m_uiObjMgr.createUIObject(fUtil.elementID(m_DataPaoShang.m_gkcontext.m_context, EntityCValue.TUIObject), modelName, UIMBeing) as UIMBeing;
				//m_dic[stateinfo.id].setScale(0.6);
				isnew = true;
			}
			var form:Form = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIBg);
			m_dic[stateinfo.id].changeContainerParent(form);
			if (stateinfo.bTime || stateinfo.brun)	// 只有这个值存在说明才在跑商中，否则只能站在起始点
			{
				var pt:Point = new Point();
				var leftpath:Array = calcPath(stateinfo);
				var dest3D:fPoint3d;
				dest3D = leftpath.shift();
				m_dic[stateinfo.id].moveTo(dest3D.x, dest3D.y, 0);
				if (leftpath.length)	// 说明还有路径
				{
					// 把路径继续传递进入
					dest3D = leftpath.shift();
					m_dic[stateinfo.id].vel = stateinfo.vel;
					m_dic[stateinfo.id].moveToPos(dest3D.x, dest3D.y, 0);
					m_dic[stateinfo.id].currentPath = leftpath;
					m_dic[stateinfo.id].state = EntityCValue.TRun;		// 运动动作
				}
				else	// 已经到达终点了
				{
					m_dic[stateinfo.id].state = EntityCValue.TStand;		// 待机动作
				}
			}
			else
			{
				m_dic[stateinfo.id].moveTo(m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[0].m_startPt.x, m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[0].m_startPt.y, 0);
				m_dic[stateinfo.id].state = EntityCValue.TStand;		// 待机动作
			}
			m_dic[stateinfo.id].name = stateinfo.name;
			
			if (isnew)		// 设置名字后再更新
			{
				m_dic[stateinfo.id].setScale(0.6);
			}
		}
		
		// 计算当前所在的位置，返回剩余路径
		protected function calcPath(stateinfo:BusinessUser):Array
		{
			var pt:Point = new Point();
			var useLen:uint = stateinfo.bTime * stateinfo.vel;
			var segtime:Number;		// 某一个线段的时间
			var idx:int = 0;
			var seg:XmlSegm;
			var leftpath:Array = [];
			var inseg:Boolean = false;		// 正好在区间内部

			while(idx < m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length)
			{
				seg = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[idx];
				if (useLen > seg.m_len)
				{
					useLen -= seg.m_len;
				}
				else if (useLen == seg.m_len)			// 正好在 endpt
				{	
					pt = seg.m_endPt;
					++idx;		// 返回下一个区间索引，可能区间已经超出范围
					break;
				}
				else			// 在线段的内部
				{
					// 需要计算具体的位置
					segtime = useLen / stateinfo.vel;
					var angle:Number = mathUtils.getAngle(seg.m_startPt.x, seg.m_startPt.y, seg.m_endPt.x, seg.m_endPt.y);
					var angleRad:Number = angle * Math.PI / 180;
					var vx:Number = stateinfo.vel * Math.cos(angleRad);
					var vy:Number = stateinfo.vel * Math.sin(angleRad);
					
					var disx:Number = vx * segtime;
					var disy:Number = vy * segtime;
					
					pt.x = seg.m_startPt.x + disx;
					pt.y = seg.m_startPt.y + disy;
					inseg = true;
					break;
				}
				
				++idx;
			}
			
			if (idx < m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length)	// 说明没有到达终点
			{
				// 路径上的第一个点
				var dest3D:fPoint3d;
				if (idx < m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length)
				{
					dest3D = new fPoint3d(0, 0, 0);
					if (inseg)
					{
						dest3D.x = pt.x;
						dest3D.y = pt.y;
					}
					else
					{
						dest3D.x = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[idx].m_startPt.x;
						dest3D.y = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[idx].m_startPt.y;					
					}

					leftpath[leftpath.length] = dest3D;
				}
				
				// 返回路径
				while (idx < m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length)
				{
					dest3D = new fPoint3d(0, 0, 0);
					dest3D.x = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[idx].m_endPt.x;
					dest3D.y = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[idx].m_endPt.y;
					leftpath[leftpath.length] = dest3D;
					++idx;
				}
			}
			else		// 到达终点
			{
				dest3D = new fPoint3d(0, 0, 0);
				dest3D.x = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length - 1].m_endPt.x;
				dest3D.y = m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst[m_DataPaoShang.m_xmlData.m_xmlPath.m_pathLst.length - 1].m_endPt.y;
				leftpath[leftpath.length] = dest3D;
			}
			
			return leftpath;
		}
		
		// 根据 being 反向查找对应的 id
		public function getIDByBeing(being:UIMBeing):uint
		{
			var key:uint;
			for (key in m_dic)
			{
				if (m_dic[key] == being)
				{
					return key;
				}
			}
			
			return 0;
		}
		
		public function isSelf(being:UIMBeing):Boolean
		{
			if (getIDByBeing(being) == 0)
			{
				return true;
			}
			
			return false;
		}
	}
}