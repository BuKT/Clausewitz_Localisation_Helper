package ru.flashader.clausewitzlocalisationhelper.panels {
	import flash.events.Event;
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;
	import org.aswing.geom.*;
	import ru.flashader.clausewitzlocalisationhelper.data.BaseSeparateTranslationEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.RichSeparateTranslationEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationsPanel extends JPanel {
		private var TopBlock:JPanel;
		private var LeftButtonCenterer:JPanel;
		private var LeftButtonsContainer:JPanel;
		private var LeftButtonsLabel:JLabel;
		private var SourceLoadButton:JButton;
		private var SourceSaveButton:JButton;
		private var TitleFilterBorderLayout:JPanel;
		private var LabelNorthSpacer:JSpacer;
		private var FileNameLabel:JLabel;
		private var FilterBorderLayout:JPanel;
		private var FilterString:JTextField;
		private var FilterLabel:JLabel;
		private var RightButtonCenterer:JPanel;
		private var RightButtonsContainer:JPanel;
		private var RightButtonsLabel:JLabel;
		private var TargetSaveButton:JButton;
		private var TargetLoadButton:JButton;
		private var TabbingContainer:JTabbedPane;
		private var ScrollPane:JScrollPane;
		private var ChinesedListPlaceholder:JPanel;
		private var ItemsPlaceholder:JPanel;
		
		private var _entriesPanelList:Vector.<TranslateEntryPanel> = new Vector.<TranslateEntryPanel>();
		private var _chinesedList:ChinesedTranslatesList;
		private var _translationFileContent:TranslationFileContent;
		
		public function TranslationsPanel() {
			setSize(new IntDimension(1280, 720));
			setPreferredSize(new IntDimension(1280, 720));
			var layout0:BorderLayout = new BorderLayout();
			setLayout(layout0);
			
			TopBlock = new JPanel();
			TopBlock.setName("TopBlock");
			TopBlock.setLocation(new IntPoint(0, 0));
			TopBlock.setSize(new IntDimension(1280, 45));
			TopBlock.setConstraints("North");
			var layout1:BoxLayout = new BoxLayout();
			layout1.setAxis(AsWingConstants.HORIZONTAL);
			TopBlock.setLayout(layout1);
			
			LeftButtonCenterer = new JPanel();
			LeftButtonCenterer.setLocation(new IntPoint(435, 0));
			LeftButtonCenterer.setSize(new IntDimension(426, 45));
			var layout2:CenterLayout = new CenterLayout();
			LeftButtonCenterer.setLayout(layout2);
			
			LeftButtonsContainer = new JPanel();
			LeftButtonsContainer.setLocation(new IntPoint(138, 8));
			LeftButtonsContainer.setSize(new IntDimension(150, 82));
			var layout3:BoxLayout = new BoxLayout();
			layout3.setAxis(AsWingConstants.VERTICAL);
			layout3.setGap(2);
			LeftButtonsContainer.setLayout(layout3);
			
			LeftButtonsLabel = new JLabel();
			LeftButtonsLabel.setLocation(new IntPoint(0, 0));
			LeftButtonsLabel.setSize(new IntDimension(150, 26));
			LeftButtonsLabel.setText("Source:");
			
			SourceLoadButton = new JButton();
			SourceLoadButton.setName("SourceLoadButton");
			SourceLoadButton.setLocation(new IntPoint(138, 9));
			SourceLoadButton.setSize(new IntDimension(150, 26));
			SourceLoadButton.setPreferredSize(new IntDimension(150, 26));
			SourceLoadButton.setText("Load...");
			SourceLoadButton.setHorizontalAlignment(AsWingConstants.CENTER);
			SourceLoadButton.setVerticalTextPosition(AsWingConstants.CENTER);
			
			SourceSaveButton = new JButton();
			SourceSaveButton.setName("SourceSaveButton");
			SourceSaveButton.setBackground(new ASColor(0x479acd, 0.7));
			SourceSaveButton.setLocation(new IntPoint(0, 36));
			SourceSaveButton.setSize(new IntDimension(150, 26));
			SourceSaveButton.setText("Save...");
			
			TitleFilterBorderLayout = new JPanel();
			TitleFilterBorderLayout.setLocation(new IntPoint(370, 0));
			TitleFilterBorderLayout.setSize(new IntDimension(426, 74));
			var layout4:BorderLayout = new BorderLayout();
			layout4.setHgap(5);
			layout4.setVgap(10);
			TitleFilterBorderLayout.setLayout(layout4);
			
			LabelNorthSpacer = new JSpacer();
			LabelNorthSpacer.setSize(new IntDimension(426, 0));
			LabelNorthSpacer.setConstraints("North");
			
			FileNameLabel = new JLabel();
			FileNameLabel.setFont(new ASFont("Tahoma", 16, true, false, false, false));
			FileNameLabel.setForeground(new ASColor(0x0, 1));
			FileNameLabel.setBackground(new ASColor(0xffffff, 1));
			FileNameLabel.setLocation(new IntPoint(627, 8));
			FileNameLabel.setSize(new IntDimension(426, 32));
			FileNameLabel.setPreferredSize(new IntDimension(500, 32));
			FileNameLabel.setConstraints("Center");
			var border5:BevelBorder = new BevelBorder();
			border5.setBevelType(0);
			border5.setThickness(3);
			FileNameLabel.setBorder(border5);
			FileNameLabel.setText("Flashader");
			FileNameLabel.setSelectable(true);
			
			FilterBorderLayout = new JPanel();
			FilterBorderLayout.setLocation(new IntPoint(0, 19));
			FilterBorderLayout.setSize(new IntDimension(426, 22));
			FilterBorderLayout.setConstraints("South");
			var layout6:BorderLayout = new BorderLayout();
			layout6.setHgap(10);
			layout6.setVgap(3);
			FilterBorderLayout.setLayout(layout6);
			
			FilterString = new JTextField();
			FilterString.setLocation(new IntPoint(41, 0));
			FilterString.setSize(new IntDimension(385, 26));
			FilterString.setPreferredSize(new IntDimension(400, 22));
			FilterString.setConstraints("Center");
			
			FilterLabel = new JLabel();
			FilterLabel.setFont(new ASFont("Tahoma", 12, false, false, false, false));
			FilterLabel.setSize(new IntDimension(51, 22));
			FilterLabel.setConstraints("West");
			FilterLabel.setText("Фильтр:");
			
			RightButtonCenterer = new JPanel();
			RightButtonCenterer.setLocation(new IntPoint(852, 0));
			RightButtonCenterer.setSize(new IntDimension(426, 45));
			var layout7:CenterLayout = new CenterLayout();
			RightButtonCenterer.setLayout(layout7);
			
			RightButtonsContainer = new JPanel();
			RightButtonsContainer.setLocation(new IntPoint(138, 8));
			RightButtonsContainer.setSize(new IntDimension(150, 57));
			var layout8:BoxLayout = new BoxLayout();
			layout8.setAxis(AsWingConstants.VERTICAL);
			layout8.setGap(5);
			RightButtonsContainer.setLayout(layout8);
			
			RightButtonsLabel = new JLabel();
			RightButtonsLabel.setLocation(new IntPoint(0, 0));
			RightButtonsLabel.setSize(new IntDimension(150, 26));
			RightButtonsLabel.setText("Target:");
			
			TargetSaveButton = new JButton();
			TargetSaveButton.setName("TargetSaveButton");
			TargetSaveButton.setLocation(new IntPoint(138, 7));
			TargetSaveButton.setSize(new IntDimension(150, 26));
			TargetSaveButton.setPreferredSize(new IntDimension(150, 26));
			TargetSaveButton.setText("Save...");
			
			TargetLoadButton = new JButton();
			TargetLoadButton.setName("TargetLoadButton");
			TargetLoadButton.setBackground(new ASColor(0x479acd, 0.7));
			TargetLoadButton.setLocation(new IntPoint(160, 5));
			TargetLoadButton.setSize(new IntDimension(37, 26));
			TargetLoadButton.setText("Load...");
			
			TabbingContainer = new JTabbedPane();
			TabbingContainer.setLocation(new IntPoint(0, 74));
			TabbingContainer.setSize(new IntDimension(1280, 646));
			
			ScrollPane = new JScrollPane();
			ScrollPane.setName("Длинный список");
			ScrollPane.setLocation(new IntPoint(0, 41));
			ScrollPane.setSize(new IntDimension(1280, 0));
			
			ItemsPlaceholder = new JPanel();
			ItemsPlaceholder.setLocation(new IntPoint(640, 339));
			ItemsPlaceholder.setSize(new IntDimension(0, 0));
			var layout9:SoftBoxLayout = new SoftBoxLayout();
			layout9.setAxis(AsWingConstants.VERTICAL);
			ItemsPlaceholder.setLayout(layout9);
			
			ChinesedListPlaceholder = new JPanel();
			ChinesedListPlaceholder.setName("Табличка");
			ChinesedListPlaceholder.setLocation(new IntPoint(0, 74));
			ChinesedListPlaceholder.setSize(new IntDimension(1280, 646));
			var layout10:BoxLayout = new BoxLayout();
			layout10.setAxis(AsWingConstants.VERTICAL);
			ChinesedListPlaceholder.setLayout(layout10);
			
			append(TopBlock);
			append(TabbingContainer);
			
			TopBlock.append(LeftButtonCenterer);
			TopBlock.append(TitleFilterBorderLayout);
			TopBlock.append(RightButtonCenterer);
			
			LeftButtonCenterer.append(LeftButtonsContainer);
			
			LeftButtonsContainer.append(LeftButtonsLabel);
			LeftButtonsContainer.append(SourceLoadButton);
			LeftButtonsContainer.append(SourceSaveButton);
			
			TitleFilterBorderLayout.append(LabelNorthSpacer);
			TitleFilterBorderLayout.append(FileNameLabel);
			TitleFilterBorderLayout.append(FilterBorderLayout);
			
			FilterBorderLayout.append(FilterString);
			FilterBorderLayout.append(FilterLabel);
			
			RightButtonCenterer.append(RightButtonsContainer);
			
			RightButtonsContainer.append(RightButtonsLabel);
			RightButtonsContainer.append(TargetSaveButton);
			RightButtonsContainer.append(TargetLoadButton);
			
			TabbingContainer.append(ChinesedListPlaceholder);
			TabbingContainer.append(ScrollPane);
			
			ScrollPane.append(ItemsPlaceholder);
			
			_chinesedList = new ChinesedTranslatesList();
			ChinesedListPlaceholder.append(_chinesedList);
			
			FilterString.getTextField().addEventListener(Event.CHANGE, FilterEntries);
		}
		
		private function FilterEntries(e:Event):void {
			var filter:String = getFilterString();
			RecreateEntryPanels(filter);
			_chinesedList.FilterData(filter);
		}
		
		public function getSourceLoadButton():JButton{
			return SourceLoadButton;
		}
		
		public function getSourceSaveButton():JButton{
			return SourceSaveButton;
		}
		
		public function getFileNameLabel():JLabel{
			return FileNameLabel;
		}
		
		public function getTargetSaveButton():JButton{
			return TargetSaveButton;
		}
		
		public function getTargetLoadButton():JButton{
			return TargetLoadButton;
		}
		
		public function getFilterString():String {
			return FilterString.getText().toLowerCase();
		}
		
		public function FillWithTranslations(translationFileContent:TranslationFileContent, path:String):void {
			_translationFileContent = translationFileContent;
			FileNameLabel.setText(path);
			var filter:String = FilterString.getText().toLowerCase();
			_chinesedList.FillWithTranslations(translationFileContent, filter);
			RecreateEntryPanels(filter);
		}
		
		private function RecreateEntryPanels(filter:String):void {
			var entryPanel:TranslateEntryPanel;
			for each (entryPanel in _entriesPanelList) {
				entryPanel.Dispose();
				ItemsPlaceholder.remove(entryPanel);
			}
			_entriesPanelList.length = 0;
			for each (var entry:BaseSeparateTranslationEntry in _translationFileContent.GetEntriesList()) {
				if (entry is RichSeparateTranslationEntry) {
					if ((entry as RichSeparateTranslationEntry).isEmpty) { continue; }
				}
				if (
					filter.length == 0 ||
					entry.GetKey().toLowerCase().indexOf(filter) > -1 ||
					entry.GetTextFieldReadyValue(true).toLowerCase().indexOf(filter) > -1 ||
					entry.GetTextFieldReadyValue(false).toLowerCase().indexOf(filter) > -1
				) {
					entryPanel = TranslateEntryPanel.Obtain(entry);
					_entriesPanelList.push(entryPanel);
					entryPanel.setVisible(true);
					ItemsPlaceholder.append(entryPanel);
				}
				if (_entriesPanelList.length > 50) { break; }
			}
		}
	}
}