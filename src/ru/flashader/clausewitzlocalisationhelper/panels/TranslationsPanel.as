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
		private var LoadButton:JButton;
		private var TitleFilterBorderLayout:JPanel;
		private var LabelNorthSpacer:JSpacer;
		private var FileNameLabel:JLabel;
		private var FilterBorderLayout:JPanel;
		private var FilterString:JTextField;
		private var FilterLabel:JLabel;
		private var RightButtonCenterer:JPanel;
		private var SaveButton:JButton;
		private var TabbingContainer:JTabbedPane;
		private var ScrollPane:JScrollPane;
		private var ChinesedListPlaceholder:JPanel;
		private var ItemsPlaceholder:JPanel;
		
		private var _entriesPanelList:Vector.<TranslateEntryPanel> = new Vector.<TranslateEntryPanel>();
		private var _translateRequestCallback:Function;
		private var _chinesedList:ChinesedTranslatesList;
		
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
			
			LoadButton = new JButton();
			LoadButton.setLocation(new IntPoint(138, 9));
			LoadButton.setSize(new IntDimension(150, 26));
			LoadButton.setPreferredSize(new IntDimension(150, 26));
			LoadButton.setText("Load...");
			LoadButton.setHorizontalAlignment(AsWingConstants.CENTER);
			LoadButton.setVerticalTextPosition(AsWingConstants.CENTER);
			
			TitleFilterBorderLayout = new JPanel();
			TitleFilterBorderLayout.setLocation(new IntPoint(370, 0));
			TitleFilterBorderLayout.setSize(new IntDimension(426, 74));
			var layout3:BorderLayout = new BorderLayout();
			layout3.setHgap(5);
			layout3.setVgap(10);
			TitleFilterBorderLayout.setLayout(layout3);
			
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
			var border4:BevelBorder = new BevelBorder();
			border4.setBevelType(0);
			border4.setThickness(3);
			FileNameLabel.setBorder(border4);
			FileNameLabel.setText("Flashader");
			FileNameLabel.setSelectable(true);
			
			FilterBorderLayout = new JPanel();
			FilterBorderLayout.setLocation(new IntPoint(0, 19));
			FilterBorderLayout.setSize(new IntDimension(426, 22));
			FilterBorderLayout.setConstraints("South");
			var layout5:BorderLayout = new BorderLayout();
			layout5.setHgap(10);
			layout5.setVgap(3);
			FilterBorderLayout.setLayout(layout5);
			
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
			var layout6:CenterLayout = new CenterLayout();
			RightButtonCenterer.setLayout(layout6);
			
			SaveButton = new JButton();
			SaveButton.setName("SaveButton");
			SaveButton.setLocation(new IntPoint(138, 7));
			SaveButton.setSize(new IntDimension(150, 26));
			SaveButton.setPreferredSize(new IntDimension(150, 26));
			SaveButton.setText("Save...");
			
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
			var layout7:SoftBoxLayout = new SoftBoxLayout();
			layout7.setAxis(AsWingConstants.VERTICAL);
			ItemsPlaceholder.setLayout(layout7);
			
			
			
			ChinesedListPlaceholder = new JPanel();
			with (ChinesedListPlaceholder) {
				setName("Табличка");
				setLocation(new IntPoint(0, 74));
				setSize(new IntDimension(1280, 646));
				var layout8:BoxLayout = new BoxLayout();
				layout8.setAxis(AsWingConstants.VERTICAL);
				setLayout(layout8);
			}
			
			//component layoution
			append(TopBlock);
			append(TabbingContainer);
			
			TopBlock.append(LeftButtonCenterer);
			TopBlock.append(TitleFilterBorderLayout);
			TopBlock.append(RightButtonCenterer);
			
			LeftButtonCenterer.append(LoadButton);
			
			TitleFilterBorderLayout.append(LabelNorthSpacer);
			TitleFilterBorderLayout.append(FileNameLabel);
			TitleFilterBorderLayout.append(FilterBorderLayout);
			
			FilterBorderLayout.append(FilterString);
			FilterBorderLayout.append(FilterLabel);
			
			RightButtonCenterer.append(SaveButton);
			
			TabbingContainer.append(ChinesedListPlaceholder);
			TabbingContainer.append(ScrollPane);
			
			ScrollPane.append(ItemsPlaceholder);
			
			
			_chinesedList = new ChinesedTranslatesList();
			ChinesedListPlaceholder.append(_chinesedList);
			
			FilterString.getTextField().addEventListener(Event.CHANGE, FilterEntries);
		}
		
		private function FilterEntries(e:Event):void {
			var filter:String = FilterString.getText().toLowerCase();
			for each (var entryPanel:TranslateEntryPanel in _entriesPanelList) {
				entryPanel.setVisible(filter.length == 0 || entryPanel.getKey().toLowerCase().indexOf(filter) > -1);
			}
			_chinesedList.FilterData(filter);
		}
		
		public function getLoadButton():JButton {
			return LoadButton;
		}
		
		
		public function getFileNameLabel():JLabel {
			return FileNameLabel;
		}
		
		public function getFilterString():JTextField {
			return FilterString;
		}
		
		
		public function getSaveButton():JButton {
			return SaveButton;
		}
		
		public function addTranslateRequestListener(callback:Function):void {
			_translateRequestCallback = callback;
		}
		
		private function RecastTranslateRequest(callback:Function, textToTranslate:String, translatesLeft:int = 0):void {
			_translateRequestCallback != null && _translateRequestCallback(callback, textToTranslate, translatesLeft);
		}
		
		public function FillWithSource(sourceValues:TranslationFileContent, path:String):void {
			FileNameLabel.setText(path);
			var filter:String = FilterString.getText().toLowerCase();
			
			var entryPanel:TranslateEntryPanel;
			
			for each (entryPanel in _entriesPanelList) {
				//entryPanel.dispose(); //TODO: flashader Да сделай ты уже нормальный пул!
				ItemsPlaceholder.remove(entryPanel);
			}
			
			_entriesPanelList.length = 0;
			
			for each (var entry:BaseSeparateTranslationEntry in sourceValues.TranslateEntriesList) {
				if (entry is RichSeparateTranslationEntry) {
					if ((entry as RichSeparateTranslationEntry).isEmpty) { continue; }
				}
				entryPanel = new TranslateEntryPanel(entry);
				_entriesPanelList.push(entryPanel);
				entryPanel.setVisible(filter.length == 0 || entryPanel.getKey().toLowerCase().indexOf(filter) > -1);
				entryPanel.addTranslateRequestListener(RecastTranslateRequest);
				ItemsPlaceholder.append(entryPanel);
			}
			
			_chinesedList.FillWithSource(sourceValues, filter);
			_chinesedList.addTranslateRequestListener(RecastTranslateRequest);
		}
		
		public function CollectTranslations():TranslationFileContent {
			var toReturn:TranslationFileContent = new TranslationFileContent();
			toReturn.LanguagePostfix = "l_russian";
			switch (TabbingContainer.getSelectedIndex()) {
				case 1:
					for each (var entryPanel:TranslateEntryPanel in _entriesPanelList) {
						var entry:BaseSeparateTranslationEntry = new BaseSeparateTranslationEntry();
						entry.Key = entryPanel.getKey();
						entry.TargetValue = entryPanel.GetValue();
						toReturn.TranslateEntriesList.push(entry);
					};
					break;
				case 0:
					toReturn.TranslateEntriesList = _chinesedList.CollectData();
					break;
			}
			return toReturn;
			
		}
	}
}