package com.ani
{
	import com.ani.AniPositionParamEquation;
	import com.ani.equation.EquationBezierCurve2;
	import com.util.UtilXML;
	
	/**
	 * ...
	 * @author 
	 * 从对象的当前位置飞到目标位置
	 */
	public class AniToDestPostion_BezierCurve2 extends AniPositionParamEquation 
	{
		
		public function AniToDestPostion_BezierCurve2() 
		{
			m_equation = new EquationBezierCurve2();
		}
		public function setDestPos(x:Number, y:Number):void
		{
			(m_equation as EquationBezierCurve2).setPD(x, y);
		}
		override public function begin():void
		{
			var equation:EquationBezierCurve2 = m_equation as EquationBezierCurve2;
			var xMid:Number = m_sp.x + (equation.m_xPD - m_sp.x) * Math.random();
			var yMid:Number = m_sp.y + (equation.m_yPD - m_sp.y) * Math.random();
			
			equation.setPS(m_sp.x, m_sp.y);
			equation.setP(xMid, yMid);
			super.begin();
		}
		
		/*通过xml进行参数设置
		 * <AniToDestPostion_BezierCurve2 destX="" destY="" speed="" duration="" useFrames="" />
		 * 如果speed与duraton都设置，则duration无效
		 */
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
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