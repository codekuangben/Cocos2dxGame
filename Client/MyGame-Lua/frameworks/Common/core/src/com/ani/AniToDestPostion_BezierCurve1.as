package com.ani 
{
	import com.ani.equation.EquationBezierCurve1;
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class AniToDestPostion_BezierCurve1 extends AniPositionParamEquation 
	{
		private var m_bRelativePos:Boolean;	//true-表示setDestPos的参数表示相对（当前的）位置的偏移量
		private var m_xOffset:Number;
		private var m_yOffset:Number;
		public function AniToDestPostion_BezierCurve1() 
		{
			m_equation = new EquationBezierCurve1();
		}
		public function setDestPos(x:Number, y:Number):void
		{
			m_xOffset = x;
			m_yOffset = y;
			//(m_equation as EquationBezierCurve1).setPD(x, y);
		}
		override public function begin():void
		{
			var equation:EquationBezierCurve1 = m_equation as EquationBezierCurve1;	
			
			if (m_bRelativePos)
			{
				equation.setPD(m_xOffset+m_sp.x, m_yOffset+m_sp.y);
			}
			else
			{
				equation.setPD(m_xOffset, m_yOffset);
			}
			equation.setPS(m_sp.x, m_sp.y);
			
			if (m_speed != 0)
			{
				m_duration = equation.distance() / m_speed;
			}
			super.begin();
		}
		public function set relativePos(b:Boolean):void
		{
			m_bRelativePos = b;
		}
		
		/*通过xml进行参数设置
		 * <AniToDestPostion_BezierCurve1 relativePos="1" destX="" destY="" speed="" duration="" useFrames="" />
		 * 如果speed与duraton都设置，则duration无效
		 */
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			relativePos = UtilXML.attributeAsBoolean(xml, "relativePos");
			setDestPos(UtilXML.attributeIntValue(xml, "destX"), UtilXML.attributeIntValue(xml, "destY"));
			speed = UtilXML.attributeIntValue(xml, "speed");
			duration = UtilXML.attributeIntValue(xml, "duration");
			useFrames = UtilXML.attributeAsBoolean(xml, "useFrames");
			str = UtilXML.attributeValue(xml, "ease");
			var str:String;
			if (str)
			{
				ease = AniDef.s_getEaseFunByName(str);
			}
		}
	}

}