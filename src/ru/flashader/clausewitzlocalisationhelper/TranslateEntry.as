package ru.flashader.clausewitzlocalisationhelper {
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.colorchooser.*;
	import org.aswing.event.AWEvent;
	import org.aswing.ext.*;
	import org.aswing.geom.*;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslateEntry extends JPanel {
		//members define
		private var SourceTranslation:JTextArea;
		private var OuterVerticalLayoutPanel:JPanel;
		private var FieldName:JTextField;
		private var InnerVerticalLayoutPanel:JPanel;
		private var MoveTranslationButton:JButton;
		private var TranslateTranslationButton:JButton;
		private var TargetTranslation:JTextArea;
		private var _translateRequestCallback:Function;
		
		public function TranslateEntry() {
			setSize(new IntDimension(926, 186));
			var border0:CaveBorder = new CaveBorder();
			border0.setBeveled(true);
			border0.setRound(3);
			setBorder(border0);
			var layout1:FlowLayout = new FlowLayout();
			layout1.setAlignment(AsWingConstants.CENTER);
			layout1.setHgap(30);
			layout1.setVgap(10);
			layout1.setMargin(true);
			setLayout(layout1);
			
			SourceTranslation = new JTextArea();
			SourceTranslation.setName("SourceTranslation");
			SourceTranslation.setLocation(new IntPoint(30, 55));
			SourceTranslation.setSize(new IntDimension(300, 150));
			SourceTranslation.setPreferredSize(new IntDimension(300, 150));
			var border2:BevelBorder = new BevelBorder();
			border2.setBevelType(1);
			border2.setThickness(3);
			SourceTranslation.setBorder(border2);
			
			OuterVerticalLayoutPanel = new JPanel();
			OuterVerticalLayoutPanel.setLocation(new IntPoint(560, 74));
			OuterVerticalLayoutPanel.setSize(new IntDimension(320, 160));
			OuterVerticalLayoutPanel.setConstraints("Center");
			var layout3:BoxLayout = new BoxLayout();
			layout3.setAxis(AsWingConstants.VERTICAL);
			layout3.setGap(20);
			OuterVerticalLayoutPanel.setLayout(layout3);
			
			FieldName = new JTextField();
			FieldName.setLocation(new IntPoint(0, 0));
			FieldName.setSize(new IntDimension(320, 70));
			FieldName.setText("фывпфвыаеп ывап ывап ячап явап явап куывп ячап");
			FieldName.setEditable(false);
			FieldName.setWordWrap(true);
			
			InnerVerticalLayoutPanel = new JPanel();
			InnerVerticalLayoutPanel.setLocation(new IntPoint(0, 100));
			InnerVerticalLayoutPanel.setSize(new IntDimension(320, 70));
			var layout4:BoxLayout = new BoxLayout();
			layout4.setAxis(AsWingConstants.VERTICAL);
			layout4.setGap(10);
			InnerVerticalLayoutPanel.setLayout(layout4);
			
			MoveTranslationButton = new JButton();
			MoveTranslationButton.setFont(new ASFont("Tahoma", 16, false, false, false, false));
			MoveTranslationButton.setLocation(new IntPoint(5, 5));
			MoveTranslationButton.setSize(new IntDimension(200, 145));
			MoveTranslationButton.setText("Скопировать");
			MoveTranslationButton.setHorizontalAlignment(AsWingConstants.CENTER);
			MoveTranslationButton.setHorizontalTextPosition(AsWingConstants.CENTER);
			
			TranslateTranslationButton = new JButton();
			TranslateTranslationButton.setFont(new ASFont("Tahoma", 16, false, false, false, false));
			TranslateTranslationButton.setLocation(new IntPoint(47, 5));
			TranslateTranslationButton.setSize(new IntDimension(200, 145));
			TranslateTranslationButton.setPreferredSize(new IntDimension(200, 30));
			TranslateTranslationButton.setText("Перевести");
			
			TargetTranslation = new JTextArea();
			TargetTranslation.setLocation(new IntPoint(710, 20));
			TargetTranslation.setSize(new IntDimension(300, 150));
			TargetTranslation.setPreferredSize(new IntDimension(300, 150));
			TargetTranslation.setConstraints("Center");
			TargetTranslation.setColumns(-3);
			TargetTranslation.setText("dfgsdfgsdfgsdg");
			TargetTranslation.setWordWrap(true);
			
			append(SourceTranslation);
			append(OuterVerticalLayoutPanel);
			append(TargetTranslation);
			
			OuterVerticalLayoutPanel.append(FieldName);
			OuterVerticalLayoutPanel.append(InnerVerticalLayoutPanel);
			
			InnerVerticalLayoutPanel.append(MoveTranslationButton);
			InnerVerticalLayoutPanel.append(TranslateTranslationButton);
			
			
			MoveTranslationButton.addActionListener(JustCopyContent);
			TranslateTranslationButton.addActionListener(processTranslateRequest);
		}
		
		private function JustCopyContent(e:AWEvent):void {
			TargetTranslation.setText(SourceTranslation.getText());
		}
		
		//_________getters_________
		
		public function getSourceTranslation():JTextArea {
			return SourceTranslation;
		}
		
		
		public function getFieldName():JTextField {
			return FieldName;
		}
		
		
		public function getMoveTranslationButton():JButton {
			return MoveTranslationButton;
		}
		
		public function getTranslateTranslationButton():JButton {
			return TranslateTranslationButton;
		}
		
		public function getTargetTranslation():JTextArea {
			return TargetTranslation;
		}
		
		public function addTranslateRequestListener(callback:Function):void {
			_translateRequestCallback = callback;
		}
		
		private function processTranslateRequest(e:AWEvent):void {
			_translateRequestCallback != null && _translateRequestCallback(this);
		}
	}
}