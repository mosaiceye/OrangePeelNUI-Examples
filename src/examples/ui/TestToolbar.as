package examples.ui
{
	import com.bit101.components.ComboBox;
	import orangepeel.display.BaseSprite;
	import examples.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestToolbar extends BaseSprite
	{
		public var currentExample:Class;
		private var _examplesList:Array = 
		[
			{label: "Center Position Test", data: CenterPositionTest},
			{label: "World Relative Skeletons Test", data: WorldRelativeSkeletonsTest},
			{label: "Away3D: World Skeletons Test", data: Away3DWorldSkeletonsTest},
			{label: "User Masked Test", data: UserMaskedTest}
		];
		
		private var _selectBox:ComboBox;
		private var _toolBar:Sprite;
		
		public function TestToolbar()
		{
			super();
		}
		
		override protected function layout():void
		{
			super.layout();
			
			if(this._toolBar)
			{
				this._toolBar.graphics.clear();
				this._toolBar.graphics.beginFill(0xffffff, 1);
				this._toolBar.graphics.drawRect(0, 0, stage.stageWidth, 28);
				this._toolBar.graphics.endFill();
			}
		}
		
		override protected function init(event:Event):void
		{
			super.init(event);
			
			this._toolBar = new Sprite();
			this._toolBar.graphics.beginFill(0xffffff, 1);
			this._toolBar.graphics.drawRect(0, 0, stage.stageWidth, 28);
			this._toolBar.graphics.endFill();
			this.addChild(this._toolBar);
			
			// Select box.
			this._selectBox = new ComboBox(null, 10, 5, '', this._examplesList);
			this._selectBox.setSize(300, 18);
			this._toolBar.addChild(this._selectBox);
			//this._selectBox.selectedItem = this._examplesList[0];
			this._selectBox.addEventListener(Event.SELECT, selection, false, 0, true);
		}
		
		private function selection(event:Event):void
		{
			this.currentExample = this._selectBox.selectedItem.data as Class;
			this.dispatchEvent(new Event(Event.SELECT));
		}
	}
}