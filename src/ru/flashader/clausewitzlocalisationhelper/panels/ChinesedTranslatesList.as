package ru.flashader.clausewitzlocalisationhelper.panels {
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.geom.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;
	import org.aswing.event.AWEvent;
	import org.aswing.event.SelectionEvent;
	import org.aswing.event.TableModelEvent;
	import org.aswing.event.TableModelListener;
	import org.aswing.table.DefaultTableModel;
	import org.aswing.table.sorter.TableSorter;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslateEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/

	public class ChinesedTranslatesList extends JPanel implements TableModelListener {
		private var GappingContainer:JPanel;
		private var TableContainer:JScrollPane;
		private var EntriesTable:JTable;
		private var FooterContainer:JPanel;
		private var TextsBlock:JPanel;
		private var SourceContainer:JPanel;
		private var SourceScroll:JScrollPane;
		private var SourceTextField:JTextArea;
		private var TargetContainer:JPanel;
		private var TargetScroll:JScrollPane;
		private var TargetTextField:JTextArea;
		private var ButtonsBlock:JPanel;
		private var JustAFirstSpacerForButtons:JSpacer;
		private var MoveTranslationButton:JButton;
		private var JustASecondSpacerForButtons:JSpacer;
		private var TranslateTranslationButton:JButton;
		private var JustAThirdSpacerForButtons:JSpacer;
		private var WestSpacer:JSpacer;
		private var NorthSpacer:JSpacer;
		private var EastSpacer:JSpacer;
		private var SouthSpacer:JSpacer;
		
		
		private var _sourceEntries:TranslationFileContent;
		private var _fullTableData:Array;
		private var _filteredTableData:Array;
		private var _lastSelectedIndex:int = -1;
		private var _selectedEntry:Array;
		private var _translateRequestCallback:Function;
		
		public function ChinesedTranslatesList() {
			InitLayout();
			
			MoveTranslationButton.addActionListener(JustCopyContent);
			TranslateTranslationButton.addActionListener(processTranslateRequest);
			
			var columnsArray:Array = ["Ключ строки", "Оригинал", "Перевод"];
			
			var model:DefaultTableModel = (new DefaultTableModel()).initWithDataNames(null, columnsArray);
			model.setColumnClass(0, "String");
			model.setColumnClass(1, "String");
			model.setColumnClass(2, "String");
			EntriesTable.setModel(model);
			model.addTableModelListener(this);
			EntriesTable.addSelectionListener(selectionChangedHandler);
			RefreshTextAreas();
		}
		
		public function InitLayout():void {
			setSize(new IntDimension(729, 703));
			var layout0:BorderLayout = new BorderLayout();
			layout0.setHgap(10);
			layout0.setVgap(10);
			setLayout(layout0);
			
			GappingContainer = new JPanel();
			GappingContainer.setSize(new IntDimension(729, 703));
			GappingContainer.setConstraints("Center");
			var layout1:BorderLayout = new BorderLayout();
			GappingContainer.setLayout(layout1);
			
			TableContainer = new JScrollPane();
			TableContainer.setSize(new IntDimension(729, 651));
			
			EntriesTable = new JTable();
			EntriesTable.setSize(new IntDimension(729, 651));
			EntriesTable.setSelectionMode(0);
			EntriesTable.setAutoResizeMode(4);
			EntriesTable.setRowHeight(24);
			EntriesTable.setShowHorizontalLines(true);
			EntriesTable.setShowVerticalLines(true);
			EntriesTable.setShowGrid(true);
			
			FooterContainer = new JPanel();
			FooterContainer.setLocation(new IntPoint(0, 703));
			FooterContainer.setSize(new IntDimension(729, 52));
			FooterContainer.setConstraints("South");
			var layout2:BorderLayout = new BorderLayout();
			layout2.setHgap(10);
			layout2.setVgap(10);
			FooterContainer.setLayout(layout2);
			
			TextsBlock = new JPanel();
			TextsBlock.setSize(new IntDimension(692, 78));
			var layout3:BoxLayout = new BoxLayout();
			layout3.setAxis(AsWingConstants.VERTICAL);
			TextsBlock.setLayout(layout3);
			
			SourceContainer = new JPanel();
			SourceContainer.setLocation(new IntPoint(5, 5));
			SourceContainer.setSize(new IntDimension(10, 10));
			var layout4:BoxLayout = new BoxLayout();
			layout4.setAxis(AsWingConstants.HORIZONTAL);
			SourceContainer.setLayout(layout4);
			
			SourceScroll = new JScrollPane();
			SourceScroll.setLocation(new IntPoint(5, 5));
			
			SourceTextField = new JTextArea();
			SourceTextField.setWordWrap(true);
			
			TargetContainer = new JPanel();
			TargetContainer.setLocation(new IntPoint(20, 5));
			TargetContainer.setSize(new IntDimension(692, 39));
			var layout5:BoxLayout = new BoxLayout();
			layout5.setAxis(AsWingConstants.HORIZONTAL);
			TargetContainer.setLayout(layout5);
			
			TargetScroll = new JScrollPane();
			TargetScroll.setLocation(new IntPoint(5, 5));
			
			TargetTextField = new JTextArea();
			TargetTextField.setWordWrap(true);
			
			ButtonsBlock = new JPanel();
			ButtonsBlock.setLocation(new IntPoint(692, 0));
			ButtonsBlock.setSize(new IntDimension(37, 52));
			ButtonsBlock.setConstraints("East");
			var layout6:BoxLayout = new BoxLayout();
			layout6.setAxis(AsWingConstants.VERTICAL);
			ButtonsBlock.setLayout(layout6);
			
			JustAFirstSpacerForButtons = new JSpacer();
			JustAFirstSpacerForButtons.setLocation(new IntPoint(0, 0));
			JustAFirstSpacerForButtons.setSize(new IntDimension(37, 26));
			
			MoveTranslationButton = new JButton();
			MoveTranslationButton.setLocation(new IntPoint(5, 5));
			MoveTranslationButton.setSize(new IntDimension(85, 26));
			MoveTranslationButton.setText("Скопировать");
			
			JustASecondSpacerForButtons = new JSpacer();
			JustASecondSpacerForButtons.setLocation(new IntPoint(0, 52));
			JustASecondSpacerForButtons.setSize(new IntDimension(37, 26));
			
			TranslateTranslationButton = new JButton();
			TranslateTranslationButton.setLocation(new IntPoint(47, 5));
			TranslateTranslationButton.setSize(new IntDimension(71, 26));
			TranslateTranslationButton.setText("Перевести");
			
			JustAThirdSpacerForButtons = new JSpacer();
			JustAThirdSpacerForButtons.setLocation(new IntPoint(0, 78));
			JustAThirdSpacerForButtons.setSize(new IntDimension(37, 26));
			
			WestSpacer = new JSpacer();
			WestSpacer.setSize(new IntDimension(0, 703));
			WestSpacer.setConstraints("West");
			
			NorthSpacer = new JSpacer();
			NorthSpacer.setSize(new IntDimension(729, 0));
			NorthSpacer.setConstraints("North");
			
			EastSpacer = new JSpacer();
			EastSpacer.setLocation(new IntPoint(729, 10));
			EastSpacer.setSize(new IntDimension(0, 693));
			EastSpacer.setConstraints("East");
			
			SouthSpacer = new JSpacer();
			SouthSpacer.setLocation(new IntPoint(0, 703));
			SouthSpacer.setSize(new IntDimension(729, 0));
			SouthSpacer.setConstraints("South");
			
			//component layoution
			append(GappingContainer);
			append(WestSpacer);
			append(NorthSpacer);
			append(EastSpacer);
			append(SouthSpacer);
			
			GappingContainer.append(TableContainer);
			GappingContainer.append(FooterContainer);
			
			TableContainer.append(EntriesTable);
			
			FooterContainer.append(TextsBlock);
			FooterContainer.append(ButtonsBlock);
			
			TextsBlock.append(SourceContainer);
			TextsBlock.append(TargetContainer);
			
			SourceContainer.append(SourceScroll);
			
			SourceScroll.append(SourceTextField);
			
			TargetContainer.append(TargetScroll);
			
			TargetScroll.append(TargetTextField);
			
			ButtonsBlock.append(JustAFirstSpacerForButtons);
			ButtonsBlock.append(MoveTranslationButton);
			ButtonsBlock.append(JustASecondSpacerForButtons);
			ButtonsBlock.append(TranslateTranslationButton);
			ButtonsBlock.append(JustAThirdSpacerForButtons);
			
		}
		
		public function getSourceTextField():JTextArea{
			return SourceTextField;
		}
		
		public function getTargetTextField():JTextArea{
			return TargetTextField;
		}
		
		public function getMoveTranslationButton():JButton{
			return MoveTranslationButton;
		}
		
		public function getTranslateTranslationButton():JButton{
			return TranslateTranslationButton;
		}
		
		public function FillWithSource(sourceEntries:TranslationFileContent, filter:String):void {
			_sourceEntries = sourceEntries;
			
			_fullTableData = new Array();
			_filteredTableData = new Array();
			
			for each (var entry:TranslateEntry in _sourceEntries.TranslateEntriesList) {
				var entryContent:Array = new Array();
				entryContent.push(entry.Key);
				entryContent.push(entry.Value);
				entryContent.push("");
				_fullTableData.push(entryContent);
				_filteredTableData.push(entryContent);
			};
			
			FilterData(filter);
		}
		
		public function FilterData(filter:String):void {
			_filteredTableData = new Array();
			for each (var row:Array in _fullTableData) {
				if (filter.length == 0 || row[0].toLowerCase().indexOf(filter) > -1) {
					_filteredTableData.push(row);
				}
			}
			(EntriesTable.getModel() as DefaultTableModel).setData(_filteredTableData);
			_lastSelectedIndex = -1;
			_selectedEntry = null;
			RefreshTextAreas();
		}
		
		private function selectionChangedHandler(e:SelectionEvent):void {
			_lastSelectedIndex = e.getFirstIndex();
			if (_lastSelectedIndex > -1) {
				_selectedEntry = _filteredTableData[_lastSelectedIndex];
			} else {
				_selectedEntry = null;
			}
			RefreshTextAreas();
		}
		
		private function RefreshTextAreas():void {
			if (_selectedEntry != null) {
				SourceTextField.setText(_selectedEntry[1]);
				TargetTextField.setText(_selectedEntry[2]);
				TargetTextField.setEnabled(true);
				SourceTextField.setEnabled(true);
				MoveTranslationButton.setEnabled(true);
				TranslateTranslationButton.setEnabled(true);
			} else {
				TargetTextField.setEnabled(false);
				SourceTextField.setEnabled(false);
				MoveTranslationButton.setEnabled(false);
				TranslateTranslationButton.setEnabled(false);
			}
		}
		
		private function SetTranslateFromAPI(translate:String):void {
			EntriesTable.getModel().setValueAt(translate, _lastSelectedIndex, 2);
		}
		
		private function JustCopyContent(e:AWEvent):void {
			TargetTextField.setText(SourceTextField.getText());
			EntriesTable.getModel().setValueAt(TargetTextField.getText(), _lastSelectedIndex, 2);
		}
		
		public function addTranslateRequestListener(callback:Function):void {
			_translateRequestCallback = callback;
		}
		
		private function processTranslateRequest(e:AWEvent):void {
			_translateRequestCallback != null && _translateRequestCallback(SetTranslateFromAPI, SourceTextField.getText());
		}
		
		public function tableChanged(e:TableModelEvent):void {
			RefreshTextAreas();
		}
		
		public function CollectData():Vector.<TranslateEntry> {
			var toReturn:Vector.<TranslateEntry> = new Vector.<TranslateEntry>();
			for each (var row:Array in _fullTableData) {
				var entry:TranslateEntry = new TranslateEntry();
				entry.Key = row[0];
				entry.Value = row[2];
				toReturn.push(entry);
			}
			return toReturn;
		}
	}
}