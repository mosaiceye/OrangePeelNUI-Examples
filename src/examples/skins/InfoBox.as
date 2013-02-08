package examples.skins
{
	import orangepeel.display.BaseSprite;
	import orangepeel.kinect.KinectWrapper;
	
	import sweatless.graphics.SmartRectangle;
	
	public class InfoBox extends BaseSprite
	{
		private var _z:int;
		private var _innerRect:SmartRectangle;
		private var _outerRect:SmartRectangle;
		
		public function InfoBox(name:String = "", pWidth:int = 10, pHeight:int = 10, color:uint = 0xFFFFFF)
		{
			super();
			this.name = name;
			this.setSize(pWidth, pHeight);
			
			this._innerRect = new SmartRectangle(pWidth, pHeight);
			this._innerRect.x = -this._innerRect.width/2;
			this._innerRect.y = -this._innerRect.height/2;
			this._innerRect.colors =[color];
			this.addChild(this._innerRect);
			
			this._outerRect = new SmartRectangle(pWidth * 2, pHeight * 2);
			this._outerRect.x = -this._outerRect.width/2;
			this._outerRect.y = -this._outerRect.height/2;
			this._outerRect.colors = [color];
			this._outerRect.alphas = [.1];
			this._outerRect.strokeColors = [color];
			this._outerRect.stroke = true;
			this.addChild(this._outerRect);
			
			this.buttonMode = false;
			this.mouseChildren = false;
		}
		
		override public function set z(value:Number):void
		{
			this._z = value;
			this._innerRect.width = this._explicitWidth - (this._z / (KinectWrapper.KinectMaxDepthInFlash/2));
			this._innerRect.height = this._explicitHeight - (this._z / (KinectWrapper.KinectMaxDepthInFlash/2));
			this._innerRect.x = -this._innerRect.width/2;
			this._innerRect.y = -this._innerRect.height/2;
		}
		
		override public function get z():Number
		{
			return this._z;
		}
	}
}