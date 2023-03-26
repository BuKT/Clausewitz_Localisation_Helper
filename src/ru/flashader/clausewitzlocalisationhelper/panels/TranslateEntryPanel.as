package ru.flashader.clausewitzlocalisationhelper.panels {
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.colorchooser.*;
	import org.aswing.event.AWEvent;
	import org.aswing.ext.*;
	import org.aswing.geom.*;
	import ru.flashader.clausewitzlocalisationhelper.utils.EntryToTextfieldsBinderMediator;
	import ru.flashader.clausewitzlocalisationhelper.utils.Utilities;
	import ru.flashader.clausewitzlocalisationhelper.data.BaseSeparateTranslationEntry;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslateEntryPanel extends JPanel {
		private static const ALLOWING_TO_CALL_CONSTRUCTOR:String = "ยง";
		//members define
		private static const _pool:Vector.<TranslateEntryPanel> = new Vector.<TranslateEntryPanel>();
		
		private var OuterWestBordering:JPanel;
		private var SourceTranslation:JTextArea;
		private var WestSpacer:JSpacer;
		private var NorthSpacer:JSpacer;
		private var EastSpacer:JSpacer;
		private var SouthSpacer:JSpacer;
		private var OuterCentererToFixedSizePanel:JPanel;
		private var OuterCenterBordering:JPanel;
		private var FieldName:JTextField;
		private var SouthSpacerCenterer:JPanel;
		private var InnerCentererToFixedSizePanel:JPanel;
		private var InnerVerticalLayoutPanel:JPanel;
		private var MoveTranslationButton:JButton;
		private var TranslateTranslationButton:JButton;
		private var OuterEastBordering:JPanel;
		private var TargetTranslation:JTextArea;
	
		private var _entry:BaseSeparateTranslationEntry;
		
		public static function Obtain(entry:BaseSeparateTranslationEntry):TranslateEntryPanel {
			var toReturn:TranslateEntryPanel;
			if (_pool.length == 0) {
				toReturn = new TranslateEntryPanel(ALLOWING_TO_CALL_CONSTRUCTOR);
			} else {
				toReturn = _pool.pop();
			}
			toReturn.InitWithEntry(entry);
			return toReturn;
		}
		
		public function TranslateEntryPanel(securityKey:String) {
			if (securityKey != ALLOWING_TO_CALL_CONSTRUCTOR) {
				throw new Error("Not allowed");
			}
			InitLayout();
			MoveTranslationButton.addActionListener(JustCopyContentFromSourceToTarget);
			TranslateTranslationButton.addActionListener(processTranslateRequestFromSourceToTarget);
		}
		
		public function InitWithEntry(entry:BaseSeparateTranslationEntry):void {
			_entry = entry;
			FieldName.setText(_entry.GetKey());
			SourceTranslation.setText(_entry.GetTextFieldReadyValue(true));
			TargetTranslation.setText(_entry.GetTextFieldReadyValue(false));
			EntryToTextfieldsBinderMediator.UnbindFields(SourceTranslation, TargetTranslation);
			EntryToTextfieldsBinderMediator.BindFields(_entry, SourceTranslation, TargetTranslation);
		}
		
		private function InitLayout():void {
			setSize(new IntDimension(1280, 250));
			
			var border0:BevelBorder = new BevelBorder();
			var border1:CaveBorder = new CaveBorder();
			border1.setBeveled(true);
			border1.setRound(5);
			border0.setInterior(border1);
			border0.setBevelType(1);
			border0.setThickness(5);
			setBorder(border0);
			var layout2:BoxLayout = new BoxLayout();
			layout2.setAxis(AsWingConstants.HORIZONTAL);
			setLayout(layout2);
			
			OuterWestBordering = new JPanel();
			OuterWestBordering.setLocation(new IntPoint(4, 4));
			OuterWestBordering.setSize(new IntDimension(307, 405));
			var layout3:BorderLayout = new BorderLayout();
			layout3.setHgap(15);
			layout3.setVgap(10);
			OuterWestBordering.setLayout(layout3);
			
			SourceTranslation = new JTextArea();
			SourceTranslation.setName("SourceTranslation");
			SourceTranslation.setLocation(new IntPoint(30, 55));
			SourceTranslation.setSize(new IntDimension(300, 150));
			SourceTranslation.setPreferredSize(new IntDimension(300, 150));
			SourceTranslation.setConstraints("Center");
			SourceTranslation.setFont(new ASFont("Tahoma", 14));
			var border4:BevelBorder = new BevelBorder();
			border4.setBevelType(1);
			border4.setThickness(3);
			SourceTranslation.setBorder(border4);
			SourceTranslation.setWordWrap(true);
			
			WestSpacer = new JSpacer();
			WestSpacer.setLocation(new IntPoint(0, 10));
			WestSpacer.setSize(new IntDimension(0, 385));
			WestSpacer.setConstraints("West");
			
			NorthSpacer = new JSpacer();
			NorthSpacer.setSize(new IntDimension(307, 0));
			NorthSpacer.setConstraints("North");
			
			SouthSpacer = new JSpacer();
			SouthSpacer.setLocation(new IntPoint(0, 405));
			SouthSpacer.setSize(new IntDimension(307, 0));
			SouthSpacer.setConstraints("South");
			
			OuterWestBordering.append(WestSpacer);
			OuterWestBordering.append(NorthSpacer);
			OuterWestBordering.append(SouthSpacer);
			
			OuterCentererToFixedSizePanel = new JPanel();
			OuterCentererToFixedSizePanel.setLocation(new IntPoint(428, 4));
			OuterCentererToFixedSizePanel.setSize(new IntDimension(424, 212));
			var layout5:BoxLayout = new BoxLayout();
			OuterCentererToFixedSizePanel.setLayout(layout5);
			
			OuterCenterBordering = new JPanel();
			OuterCenterBordering.setLocation(new IntPoint(560, 74));
			OuterCenterBordering.setSize(new IntDimension(424, 192));
			OuterCenterBordering.setConstraints("Center");
			var layout6:BorderLayout = new BorderLayout();
			layout6.setHgap(10);
			layout6.setVgap(20);
			OuterCenterBordering.setLayout(layout6);
			
			WestSpacer = new JSpacer();
			WestSpacer.setSize(new IntDimension(0, 102));
			WestSpacer.setConstraints("West");
			
			NorthSpacer = new JSpacer();
			NorthSpacer.setLocation(new IntPoint(0, 0));
			NorthSpacer.setSize(new IntDimension(424, 0));
			NorthSpacer.setConstraints("North");
			
			EastSpacer = new JSpacer();
			EastSpacer.setLocation(new IntPoint(212, 0));
			EastSpacer.setSize(new IntDimension(212, 192));
			EastSpacer.setConstraints("East");
			
			OuterCenterBordering.append(WestSpacer);
			OuterCenterBordering.append(NorthSpacer);
			OuterCenterBordering.append(EastSpacer);
			
			FieldName = new JTextField();
			FieldName.setLocation(new IntPoint(0, 0));
			FieldName.setSize(new IntDimension(424, 666));
			FieldName.setPreferredSize(new IntDimension(250, 100));
			FieldName.setFont(new ASFont("Tahoma", 16));
			FieldName.setConstraints("Center");
			var border7:BevelBorder = new BevelBorder();
			border7.setBevelType(0);
			border7.setThickness(2);
			FieldName.setBorder(border7);
			FieldName.setEditable(false);
			FieldName.setWordWrap(true);
			
			SouthSpacerCenterer = new JPanel();
			SouthSpacerCenterer.setLocation(new IntPoint(0, 143));
			SouthSpacerCenterer.setSize(new IntDimension(448, 80));
			SouthSpacerCenterer.setConstraints("South");
			var layout8:BorderLayout = new BorderLayout();
			layout8.setVgap(10);
			SouthSpacerCenterer.setLayout(layout8);
			
			InnerCentererToFixedSizePanel = new JPanel();
			InnerCentererToFixedSizePanel.setLocation(new IntPoint(0, 0));
			InnerCentererToFixedSizePanel.setSize(new IntDimension(448, 70));
			InnerCentererToFixedSizePanel.setConstraints("Center");
			var layout9:CenterLayout = new CenterLayout();
			InnerCentererToFixedSizePanel.setLayout(layout9);
			
			InnerVerticalLayoutPanel = new JPanel();
			InnerVerticalLayoutPanel.setLocation(new IntPoint(0, 100));
			InnerVerticalLayoutPanel.setSize(new IntDimension(105, 70));
			var layout10:BoxLayout = new BoxLayout();
			layout10.setAxis(AsWingConstants.VERTICAL);
			layout10.setGap(10);
			InnerVerticalLayoutPanel.setLayout(layout10);
			
			MoveTranslationButton = new JButton();
			MoveTranslationButton.setFont(new ASFont("Tahoma", 16, false, false, false, false));
			MoveTranslationButton.setLocation(new IntPoint(5, 5));
			MoveTranslationButton.setSize(new IntDimension(105, 30));
			MoveTranslationButton.setText("Скопировать");
			MoveTranslationButton.setHorizontalAlignment(AsWingConstants.CENTER);
			MoveTranslationButton.setVerticalAlignment(AsWingConstants.CENTER);
			MoveTranslationButton.setHorizontalTextPosition(AsWingConstants.CENTER);
			MoveTranslationButton.setVerticalTextPosition(AsWingConstants.CENTER);
			
			TranslateTranslationButton = new JButton();
			TranslateTranslationButton.setFont(new ASFont("Tahoma", 16, false, false, false, false));
			TranslateTranslationButton.setLocation(new IntPoint(47, 5));
			TranslateTranslationButton.setSize(new IntDimension(105, 30));
			TranslateTranslationButton.setText("Перевести");
			TranslateTranslationButton.setHorizontalAlignment(AsWingConstants.CENTER);
			TranslateTranslationButton.setVerticalAlignment(AsWingConstants.CENTER);
			TranslateTranslationButton.setHorizontalTextPosition(AsWingConstants.CENTER);
			TranslateTranslationButton.setVerticalTextPosition(AsWingConstants.CENTER);
			
			SouthSpacer = new JSpacer();
			SouthSpacer.setLocation(new IntPoint(224, 0));
			SouthSpacer.setSize(new IntDimension(224, 70));
			SouthSpacer.setConstraints("South");
			
			SouthSpacerCenterer.append(SouthSpacer);
			
			OuterEastBordering = new JPanel();
			OuterEastBordering.setLocation(new IntPoint(618, 4));
			OuterEastBordering.setSize(new IntDimension(307, 405));
			var layout11:BorderLayout = new BorderLayout();
			layout11.setHgap(15);
			layout11.setVgap(10);
			OuterEastBordering.setLayout(layout11);
			
			TargetTranslation = new JTextArea();
			TargetTranslation.setName("TargetTranslation");
			TargetTranslation.setFont(new ASFont("Tahoma", 14));
			TargetTranslation.setLocation(new IntPoint(710, 20));
			TargetTranslation.setSize(new IntDimension(300, 150));
			TargetTranslation.setPreferredSize(new IntDimension(300, 150));
			TargetTranslation.setConstraints("Center");
			var border12:BevelBorder = new BevelBorder();
			border12.setBevelType(1);
			border12.setThickness(3);
			TargetTranslation.setBorder(border12);
			TargetTranslation.setWordWrap(true);
			
			NorthSpacer = new JSpacer();
			NorthSpacer.setSize(new IntDimension(307, 0));
			NorthSpacer.setConstraints("North");
			
			EastSpacer = new JSpacer();
			EastSpacer.setLocation(new IntPoint(307, 10));
			EastSpacer.setSize(new IntDimension(0, 395));
			EastSpacer.setConstraints("East");
			
			SouthSpacer = new JSpacer();
			SouthSpacer.setLocation(new IntPoint(0, 405));
			SouthSpacer.setSize(new IntDimension(307, 0));
			SouthSpacer.setConstraints("South");
			
			//component layoution
			append(OuterWestBordering);
			append(OuterCentererToFixedSizePanel);
			append(OuterEastBordering);
			
			OuterWestBordering.append(SourceTranslation);
			
			OuterCentererToFixedSizePanel.append(OuterCenterBordering);
			
			OuterCenterBordering.append(FieldName);
			OuterCenterBordering.append(SouthSpacerCenterer);
			
			SouthSpacerCenterer.append(InnerCentererToFixedSizePanel);
			
			InnerCentererToFixedSizePanel.append(InnerVerticalLayoutPanel);
			
			InnerVerticalLayoutPanel.append(MoveTranslationButton);
			InnerVerticalLayoutPanel.append(TranslateTranslationButton);
			
			OuterEastBordering.append(TargetTranslation);
			OuterEastBordering.append(NorthSpacer);
			OuterEastBordering.append(EastSpacer);
			OuterEastBordering.append(SouthSpacer);
		}
		
		private function JustCopyContentFromSourceToTarget(e:AWEvent):void {
			_entry.JustCopyTo(false);
		}
		
		public function getKey():String {
			return _entry.GetKey();
		}
		
		private function processTranslateRequestFromSourceToTarget(e:AWEvent):void {
			_entry.SomeoneRequestToTranslateYou(false);
		}
		
		public function Dispose():void {
			EntryToTextfieldsBinderMediator.UnbindFields(SourceTranslation, TargetTranslation);
			setVisible(false);
			_pool.push(this);
		}
	}
}