package game.ui.herorally.myrecord 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight_queue;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.herorally.FieldData;
	import modulecommon.scene.herorally.HeroRallyMgr;
	import com.util.UtilColor;
	
	/**
	 * 我的战绩（左边部分）
	 * @author 
	 */
	public class RecordComponent extends Component 
	{
		private var m_list:ControlListVHeight_queue;
		private var m_gkcontext:GkContext;
		private var m_buttomText:Label;
		public function RecordComponent(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			setPanelImageSkin("commoncontrol/panel/herorally/recordbg.png");
			setSize(257, 337);
			m_gkcontext = gk;
			m_list = new ControlListVHeight_queue(this,9,39);
			m_list.queueSize = HeroRallyMgr.MAXLISTNUM;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = FieldItem;
			param.m_intervalV = 86;
			param.m_width = 200;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_heightList = 258;
			param.m_dataParam = dataParam;
			m_list.setParam(param);
			m_buttomText = new Label(this, 39, 307, "单局胜利可获取宝箱，点击获得", UtilColor.GRAY);
			m_buttomText.setLetterSpacing(1);
		}
		public function setDatas(arr:Array):void//初始化
		{
			var arrList:Array = new Array();
			/*for (var i:uint = 0; i < (arr.length / 3); i++ )
			{
				arrList.push(arr.slice(i * 3, i * 3+3));
			}*/
			m_list.setDatas(arr);
		}
		public function upData(ispush:Boolean,arr:FieldData):void//更新一局
		{
			if (ispush)
			{
				m_list.push(arr);
			}
			else
			{
				m_list.controlList[m_list.controlList.length-1].setData(arr);
			}
		}
		public function upDataBox(fieldnum:uint,bracketnum:uint):void
		{
			var item:FieldItem = m_list.controlList[fieldnum] as FieldItem;
			item.upDataBox(bracketnum);
		}
	}

}