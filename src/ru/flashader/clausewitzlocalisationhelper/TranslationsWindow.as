package ru.flashader.clausewitzlocalisationhelper {
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.geom.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationsWindow extends JPanel {
		
		private var TopBlock:JPanel;
		private var LeftButtonCenterer:JPanel;
		private var LoadButton:JButton;
		private var FilterBlock:JPanel;
		private var FileNameLabel:JLabel;
		private var FilterString:JTextField;
		private var RightButtonCenterer:JPanel;
		private var SaveButton:JButton;
		private var ScrollBarPlaceholder:JPanel;
		
		public function TranslationsWindow() {
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
			
			FilterBlock = new JPanel();
			FilterBlock.setLocation(new IntPoint(370, 0));
			FilterBlock.setSize(new IntDimension(426, 41));
			var layout3:BorderLayout = new BorderLayout();
			FilterBlock.setLayout(layout3);
			
			FileNameLabel = new JLabel();
			FileNameLabel.setLocation(new IntPoint(627, 8));
			FileNameLabel.setSize(new IntDimension(426, 19));
			FileNameLabel.setText("Flashader");
			
			FilterString = new JTextField();
			FilterString.setLocation(new IntPoint(0, 19));
			FilterString.setSize(new IntDimension(426, 22));
			FilterString.setPreferredSize(new IntDimension(400, 22));
			FilterString.setConstraints("South");
			
			RightButtonCenterer = new JPanel();
			RightButtonCenterer.setLocation(new IntPoint(852, 0));
			RightButtonCenterer.setSize(new IntDimension(426, 45));
			var layout4:CenterLayout = new CenterLayout();
			RightButtonCenterer.setLayout(layout4);
			
			SaveButton = new JButton();
			SaveButton.setName("SaveButton");
			SaveButton.setLocation(new IntPoint(138, 7));
			SaveButton.setSize(new IntDimension(150, 26));
			SaveButton.setPreferredSize(new IntDimension(150, 26));
			SaveButton.setText("Save...");
			
			ScrollBarPlaceholder = new JPanel();
			ScrollBarPlaceholder.setLocation(new IntPoint(0, 54));
			ScrollBarPlaceholder.setSize(new IntDimension(1280, 679));
			var layout5:EmptyLayout = new EmptyLayout();
			ScrollBarPlaceholder.setLayout(layout5);
			
			//component layoution
			append(TopBlock);
			append(ScrollBarPlaceholder);
			
			TopBlock.append(LeftButtonCenterer);
			TopBlock.append(FilterBlock);
			TopBlock.append(RightButtonCenterer);
			
			LeftButtonCenterer.append(LoadButton);
			
			FilterBlock.append(FileNameLabel);
			FilterBlock.append(FilterString);
			
			RightButtonCenterer.append(SaveButton);
			
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
		
		public function FillWithSource(sourceValues:Object, path:String):void {
			
		}
	}
}