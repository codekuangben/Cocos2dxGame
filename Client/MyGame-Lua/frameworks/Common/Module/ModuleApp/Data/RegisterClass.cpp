package app.data
{
	//import adobe.utils.CustomActions;
	import com.adobe.images.JPGEncoder;
	import com.ani.AniComposeParallel;
	import com.ani.AniComposeSequence;
	import com.ani.AniDef;
	import com.ani.AniEmitAround;
	import com.ani.AniIntChange;
	import com.ani.AniMiaobian;
	import com.ani.AniPause;
	import com.ani.AniPosition;
	import com.ani.AniPositionParamEquation;
	import com.ani.AniPropertys;
	import com.ani.AniShake;
	import com.ani.AniToDestPostion_BezierCurve2;
	import com.ani.AniXml;
	import com.ani.DigitAniBase;
	import com.ani.equation.EquationBezierCurve1;
	import com.ani.equation.EquationBezierCurve2;
	import com.ani.equation.EquationInverse;
	import com.ani.InOutAni;
	import com.ani.liuguang.AniLiuguang;
	import com.ani.uiAni.AniMoving;
	import com.bit101.components.Ani;
	import com.bit101.components.AniScroll_CenterToTwoSide;
	import com.bit101.components.AniShowAndHideAfterMove;
	import com.bit101.components.AniZoom;
	import com.bit101.components.ButtonAni;
	import com.bit101.components.ButtonCheck;
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.ComButtonCheckAndLabel;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.Marquee;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.PanelPage;
	import com.bit101.components.PanelPageParent;
	import com.bit101.components.PanelShowAndHide;
	import com.bit101.components.TextAppearanceAni;
	import com.bit101.components.TextArea;
	import com.bit101.components.TextNoScroll;
	import com.bit101.components.VScrollBar;
	import com.bit101.components.comboBox.ComboBox;
	import com.bit101.components.comboBox.ComboBoxParam;
	import com.bit101.components.comboBox.ComoBoxItem;
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.controlList.ControlListH;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlListVHeight_queue;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign_Component;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign_Param;
	import com.bit101.components.numberchange.NumberChangeCtrl;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.pageturn.PageTurn2;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.bit101.components.progressBar.BarInProgressDefault;
	import com.bit101.components.progressBar.IBarInProgress;
	import com.bit101.components.progressBar.ProgressBar;
	import com.bit101.drag.DragComponentBase;
	import com.bit101.progressbar.progressAni.ProgressAni;
	import com.bit101.progressbar.progressbarClass1.ProgressBarClass1;
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.display.DisplayCombinationBase;
	import com.dgrigg.display.DisplayImageListBase;
	import com.dgrigg.utils.ImageTempStorage;
	import com.dncompute.canvas.BrowserCanvas;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.easing.Quartic;
	import com.gskinner.motion.easing.Sine;
	import com.riaidea.text.GraphicBase;
	import com.riaidea.text.RichTextField;
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.util.Car1D;
	import com.util.CmdParse;
	import com.util.IDAllocator;
	import com.util.KeyValueParse;
	import com.util.UtilFont;
	import com.util.UtilGraphics;
	import com.util.UtilXML;
	import datast.ListPart;
	import datast.reuse.ObjectForReuse_Component;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9HorseSeqRender;
	import time.UtilTime;
	
	
	import datast.MapBijection;
	import datast.QueueVec;
	import datast.reuse.IObjectForReuse;
	import datast.reuse.MgrForReuse;
	
	
	import game.IMGame;

	
	
	import org.as3commons.collections.framework.IDataProvider;
	import org.as3commons.collections.fx.ArrayListFx;
	import org.ffilmation.engine.datatypes.PosOfLine;;
	
	import com.bit101.components.List;
	
	
	/**
	 * @author ...
	 * @brief 
	 */
	public class RegisterClass 
	{
		fFlash9HorseSeqRender
		IMGame;
		UtilTime;
		ObjectForReuse_Component
		InputText;
		ListPart
		DisplayImageListBase
		QueueVec;
		BrowserCanvas
		VScrollBar;
		CmdParse;
		Panel;
		ImageTempStorage;
		CtrolVHeightComponent;
		Car1D;
		ControlListVHeight;
		InOutAni;
		
		TextArea;
		IBarInProgress;
		ProgressBar;
		BarInProgress2;
		
		ButtonTabText;
		BarInProgressDefault;
		ButtonAni;
		
		
		CtrolComponent;
		ControlList;
		
		Ani;
		Exponential;
		Linear;
		
		GTween;
		
		DisplayCombinationBase;
		Sine;
		
		RichTextField;
		
		
		Back;
		Quadratic;
		Quartic;
		
	
		DigitAniBase;	
		Quadratic;
		
		ControlListH;
		ControlHAlignmentParam;
		
		KeyValueParse;
		
		TextNoScroll;
		
		AniPosition;
		Marquee;
		Bounce;
		
		AniMoving;
		AniPropertys;
		AniPositionParamEquation;
		EquationInverse;
		PanelDraw;
		
		ButtonCheck;
		ButtonRadio;
		
		//UIProgLoading;
		
		ButtonImageText;
		
				
		List;
		

		EquationBezierCurve2;
		EquationBezierCurve1;
		
		IDataSourceAdapter;
		TreeView;
		IDataProvider;
		

		PanelShowAndHide;
		UtilXML;
		ArrayListFx;
		
		TextAppearanceAni;
		
		AniShake;
		
		AniToDestPostion_BezierCurve2;
		AniComposeSequence;
		AniEmitAround;
		AniComposeParallel;
		
		ComboBox;
		ComoBoxItem;
		ComboBoxParam;
		AniLiuguang;
		
		IDAllocator;
		
		AniPause
		
		PosOfLine;
		
		
		PageTurn;
		
		AniIntChange;
		
		ComButtonCheckAndLabel;
		
		MapBijection;
		
		CtrolComponentBase;
		PanelDrawCreator;
		
		PageTurn2;
		
		UtilGraphics;
		
		GraphicBase;
		UtilFont;
		
		ControlAlignmentParam_ForPageMode;
		
		NumberChangeCtrl;
		
		ControlVHeightAlignmentParam;
		ControlVHeightAlignmentParam_ForPageMode;
		
		MgrForReuse;
		IObjectForReuse;
		
		PanelPage;
		
		AniZoom;
		AniScroll_CenterToTwoSide;
		
		AniMiaobian;
		
		ProgressAni;
		ProgressBarClass1;
		
		DragComponentBase;
		
		AniShowAndHideAfterMove;
		JPGEncoder;
		
		AniDef;
		AniXml;
		
		PanelPageParent;
		
		ControlList_VerticalAlign;
		ControlList_VerticalAlign_Param;
		ControlList_VerticalAlign_Component;
		ControlListVHeight_queue;
	}
}