package ru.flashader.clausewitzlocalisationhelper.panels {
	import flash.events.Event;
	import flash.utils.Dictionary;
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
	import ru.flashader.clausewitzlocalisationhelper.utils.EntryToTextfieldsBinderMediator;
	import ru.flashader.clausewitzlocalisationhelper.utils.Utilities;
	import ru.flashader.clausewitzlocalisationhelper.data.BaseSeparateTranslationEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.RichSeparateTranslationEntry;
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
		private var TranslateAllButton:JButton;
		private var JustAFourthSpacerForButtons:JSpacer;
		private var WestSpacer:JSpacer;
		private var NorthSpacer:JSpacer;
		private var EastSpacer:JSpacer;
		private var SouthSpacer:JSpacer;
		
		
		private var _fullTableData:Array;
		private var _filteredTableData:Array;
		private var _lastSelectedIndex:int = -1;
		private var _selectedRow:Array;
		private var _massTranslateIDXes:Array = [];
		private var _massTranslateEntries:Vector.<BaseSeparateTranslationEntry> = new Vector.<BaseSeparateTranslationEntry>();
		private var _filterString:String;
		private var _massTranslationsCachedFilterString:String;
		private var _rowsToEntryTranslator:Dictionary = new Dictionary(true);
		
		public function ChinesedTranslatesList() {
			InitLayout();
			
			MoveTranslationButton.addActionListener(JustCopyContent);
			TranslateTranslationButton.addActionListener(processTranslateRequestFromRow);
			TranslateAllButton.addActionListener(processTranslateAllrequest);
			
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
			
			TranslateAllButton = new JButton();
			TranslateAllButton.setName("TranslateAllButton");
			TranslateAllButton.setLocation(new IntPoint(0, 130));
			TranslateAllButton.setSize(new IntDimension(93, 26));
			TranslateAllButton.setText("Перевести всё");
			
			JustAFourthSpacerForButtons = new JSpacer();
			JustAFourthSpacerForButtons.setLocation(new IntPoint(0, 156));
			JustAFourthSpacerForButtons.setSize(new IntDimension(93, 26));
			
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
			ButtonsBlock.append(TranslateAllButton);
			ButtonsBlock.append(JustAFourthSpacerForButtons);
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
		
		public function FillWithTranslations(translationFileContent:TranslationFileContent, filter:String):void {
			var row:Array;
			for each (row in _fullTableData) {
				EntryToTextfieldsBinderMediator.UnbindTableRowArray(row, EntriesTable.doLayout);
			}
			_fullTableData = new Array();
			_filteredTableData = new Array();
			_rowsToEntryTranslator = new Dictionary(true);
			for each (var entry:BaseSeparateTranslationEntry in translationFileContent.GetEntriesList()) {
				if (entry is RichSeparateTranslationEntry) {
					if ((entry as RichSeparateTranslationEntry).isEmpty) { continue; }
				}
				row = entry.ToTableArray();
				_fullTableData.push(row);
				_rowsToEntryTranslator[row] = entry;
				EntryToTextfieldsBinderMediator.BindTableRowArray(entry, row, EntriesTable.doLayout);
			};
			
			FilterData(filter);
		}
		
		public function FilterData(filter:String):void {
			_filterString = filter;
			_filteredTableData = new Array();
			for each (var row:Array in _fullTableData) {
				if (filter.length == 0 || row[0].toLowerCase().indexOf(filter) > -1) {
					_filteredTableData.push(row);
				}
				else if (row[1].toLowerCase().indexOf(filter) > -1 || row[2].toLowerCase().indexOf(filter) > -1) { _filteredTableData.push(row); } //TODO: flashader Ладно, ушло в релиз, но потом сделать чекбокс, который и будет проверять - хочет юзер искать по ключам, или нет.
			}
			_lastSelectedIndex = -1;
			_selectedRow = null;
			(EntriesTable.getModel() as DefaultTableModel).setData(_filteredTableData);
			EntriesTable.changeSelection(-1, -1, false, false);
		}
		
		private function selectionChangedHandler(e:SelectionEvent):void {
			_lastSelectedIndex = e.getFirstIndex();
			if (_lastSelectedIndex > -1) {
				_selectedRow = _filteredTableData[_lastSelectedIndex];
			} else {
				_selectedRow = null;
			}
			
			RefreshTextAreas();
		}
		
		private function RefreshTextAreas():void { 
			EntryToTextfieldsBinderMediator.UnbindFields(SourceTextField, TargetTextField);
			TargetTextField.setEnabled(false);
			SourceTextField.setEnabled(false);
			MoveTranslationButton.setEnabled(false);
			TranslateTranslationButton.setEnabled(false);
			if (_selectedRow != null) { //TODO: flashader Вот тут ещё может случиться изменение эррэя
				var entry:BaseSeparateTranslationEntry = _rowsToEntryTranslator[_selectedRow];
				SourceTextField.setText(entry.GetTextFieldReadyValue(true));
				TargetTextField.setText(entry.GetTextFieldReadyValue(false));
				TargetTextField.setEnabled(true);
				SourceTextField.setEnabled(true);
				MoveTranslationButton.setEnabled(true);
				TranslateTranslationButton.setEnabled(true);
				EntryToTextfieldsBinderMediator.BindFields(entry, SourceTextField, TargetTextField);
			}
			TranslateAllButton.setEnabled(_fullTableData != null && _fullTableData.length > 0);
		}
		
		private function JustCopyContent(e:AWEvent):void {
			(_rowsToEntryTranslator[_selectedRow] as BaseSeparateTranslationEntry).JustCopy();
		}
		
		private function processTranslateRequestFromRow(e:AWEvent):void {
			(_rowsToEntryTranslator[_selectedRow] as BaseSeparateTranslationEntry).SomeoneRequestToTranslateYou();
		}
		
		private function processTranslateAllrequest(e:AWEvent):void {
			_massTranslationsCachedFilterString = _filterString;
			FilterData("");
			_massTranslateIDXes.length = 0;
			for (var idx:int = 0; idx < _fullTableData.length; idx++) {
				if (_fullTableData[idx][2].length == 0) {
					_massTranslateIDXes.push(idx);
				}
			}
			if (_massTranslateIDXes.length < 100) {
				_massTranslateIDXes.reverse();
				ContinueFancyMassTranslate();
				return;
			} else {
				var entry:BaseSeparateTranslationEntry;
				if (_massTranslateIDXes.length < 1000) { //Fuck this fancy showings, we left no much time to live
					for each (entry in _rowsToEntryTranslator) {
						if (entry.GetTextFieldReadyValue(false).length > 0) { continue; }
						entry.SomeoneRequestToTranslateYou();
					}
				} else  { //Ohhhh, shit, something big gonna happen
					_massTranslateEntries.length = 0;
					for each (entry in _rowsToEntryTranslator) {
						if (entry.GetTextFieldReadyValue(false).length > 0) { continue; }
						_massTranslateEntries.push(entry);
					}
					ContinueAsyncMassTranslate(null);
				}
			}
			FilterData(_massTranslationsCachedFilterString);
		}
		
		private function ContinueAsyncMassTranslate(e:Event = null):void {
			if (e == null) {
				addEventListener(Event.EXIT_FRAME, ContinueAsyncMassTranslate);
			}
			var translateRequestsSended:int = 0;
			while (_massTranslateEntries.length > 0 && translateRequestsSended < 300) {
				_massTranslateEntries.pop().SomeoneRequestToTranslateYou();
				translateRequestsSended++;
			}
			if (_massTranslateEntries.length == 0) {
				if (e != null) {
					e.currentTarget.removeEventListener(e.type, arguments.callee);
				}
			}
		}
		
		private function ContinueFancyMassTranslate():void {
			if (_massTranslateIDXes.length == 0) {
				FilterData(_massTranslationsCachedFilterString);
				return;
			}
			var nextIDXToTranslate:int = _massTranslateIDXes.pop();
			EntriesTable.changeSelection(nextIDXToTranslate, nextIDXToTranslate, false, false);
			processTranslateRequestFromRow(null);
			ContinueFancyMassTranslate();
		}
		
		public function tableChanged(e:TableModelEvent):void {
			RefreshTextAreas();
		}
	}
}