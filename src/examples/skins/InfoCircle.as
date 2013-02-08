package examples.skins
{
	import orangepeel.display.BaseSprite;
	import orangepeel.kinect.KinectWrapper;
	import orangepeel.kinect.geom.Point3D;
	
	import flash.display.Shape;
	
	public class InfoCircle extends BaseSprite
	{
		protected var _id:uint;
		protected var _position:Point3D;
		protected var _crossHair:Shape;
		
		/**
		 * Class setup.
		 */
		public function InfoCircle(id:uint = 0, radius:Number = 25)
		{
			super();
			this._id = id;
			
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
			
			this._crossHair = new Shape();
			this._crossHair.graphics.beginFill(0x333333);
			this._crossHair.graphics.drawRect(-(radius*2), 0, (radius*4), 1);
			this._crossHair.graphics.drawRect(0, -(radius*2), 1, (radius*4));
			this._crossHair.graphics.endFill();
			this.addChild(this._crossHair);
			
			this.setSize(this._crossHair.width, this._crossHair.height);
		}
		
		override protected function layout():void
		{
			if(this._position && this.parent)
			{
				var xPos:Number = ((this._position.x + 1) * .5) * this.parent.width;
				var yPos:Number = ((this._position.y - 1) / -2) * this.parent.height;
				var zPos:Number = (this._position.z * KinectWrapper.KinectMaxDepthInFlash);
				this.x = xPos;
				this.y = yPos;
				this.z = zPos;
			}
		}
		
		/**
		 * Getters/Setters.
		 */
		public function get id():uint
		{
			return this._id;
		}
		
		public function get position():Point3D
		{
			return this._position;
		}
		
		public function set position(pValue:Point3D):void
		{
			this._position = pValue;
			this.layout();
		}
	}
}