package game.ui.uiQAsys
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.PanelDisposeEx;
	
	/**
	 * ...
	 * @author 
	 */
	public class AnswersList extends Component 
	{
		private var m_answersItemList:Vector.<AnswersItem>;
		private var m_randomParam:uint;//0-23 24个数
		private var m_parent:UIQAsys;
		private var m_itembg:PanelDisposeEx;
		public function AnswersList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_parent = parent as UIQAsys;
			m_itembg = new PanelDisposeEx();
			m_itembg.setPanelImageSkin("commoncontrol/panel/moveover.png");
			m_itembg.x = -27;
			m_itembg.y = -6;
			m_answersItemList = new Vector.<AnswersItem>();
			var hightpos:int = 0;
			for (var i:uint = 0; i < 4; i++ )
			{
				var answer:AnswersItem = new AnswersItem(m_itembg,this, 0, hightpos);
				hightpos += 30;
				m_answersItemList.push(answer);
			}
		}
		public function setdata(answersArray:Array):void
		{
			m_randomParam = Math.floor(Math.random() * 24);
			var parray:Array = luanxu(m_randomParam);
			var letterList:Array = ["A、", "B、", "C、", "D、"];
			for (var i:uint = 0; i < m_answersItemList.length; i++ )
			{
				var num:uint = parray[i];
				var str:String = letterList[i] + answersArray[num];
				if (answersArray[4] == num)
				{
					m_answersItemList[i].setdata(str,true);
				}
				else
				{
					m_answersItemList[i].setdata(str,false);
				}
			}
		}
		private function luanxu(rannum:uint):Array
		{
			var arr:Array = new Array;
			var i:uint;
			var numList:Array = [0, 1, 2, 3];
			i = rannum / 6;
			arr[0] = numList[i];
			numList.splice(i, 1);
			i = (rannum % 6) / 2;
			arr[1] = numList[i];
			numList.splice(i, 1);
			i = rannum % 2;
			arr[2] = numList[i];
			numList.splice(i,1);
			arr[3] = numList[0];
			return arr;
		}
		public function result(isright:Boolean):void
		{
			for each(var item:AnswersItem in m_answersItemList)
			{
				item.removeListener();
			}
			m_parent.result(isright);
		}
		
	}

}