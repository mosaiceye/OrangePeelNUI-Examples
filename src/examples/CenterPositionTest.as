package examples
{
	import orangepeel.kinect.objects.TrackedUser;
	import orangepeel.kinect.views.KinectView;
	import orangepeel.kinect.utils.KinectHelper;
	
	import examples.skins.InfoCircle;
	
	public class CenterPositionTest extends KinectView
	{
		private var _trackedInfoCircles:Vector.<InfoCircle>;
		
		/**
		 * Class method.
		 */
		public function CenterPositionTest()
		{
			super();
			this._trackedInfoCircles = new Vector.<InfoCircle>;
		}
		
		/**
		 * Override methods.
		 */
		override protected function layout():void
		{
			super.layout();
			if(this.stage) this.setSize(stage.stageWidth, stage.stageHeight);
			
			this.graphics.clear();
			this.graphics.beginFill(0xEEEEEE);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
		}
		
		override protected function _add(trackedUser:TrackedUser):void
		{
			var ic:InfoCircle = new InfoCircle(trackedUser.trackingID, 25);
			this.addChild(ic);
			this._trackedInfoCircles.push(ic);
		}
		
		override protected function _remove(trackedUser:TrackedUser):void
		{
			var ic:InfoCircle = this.getInfoCircleByID(trackedUser.trackingID);
			if(ic)
			{
				this._trackedInfoCircles.splice(this._trackedInfoCircles.indexOf(ic), 1);
				this.removeChild(ic);
			}
		}
		
		override protected function _render(trackedUsers:Vector.<TrackedUser>):void
		{
			if(this._trackedInfoCircles.length > 0)
			{
				for each(var ic:InfoCircle in this._trackedInfoCircles)
				{
					var tu:TrackedUser = KinectHelper.getTrackedUserByTrackingID(ic.id, trackedUsers);
					if(tu && tu.position)
					{
						ic.position = tu.position;
						ic.visible = (tu.offScreen) ? false : true;
					}
				}
			}
		}
		
		/**
		 * Private methods.
		 */
		private function getInfoCircleByID(id:uint):InfoCircle
		{
			var rc:InfoCircle = null;
			for each(var ic:InfoCircle in this._trackedInfoCircles) if(ic.id == id) rc = ic;
			return rc;
		}
	}
}