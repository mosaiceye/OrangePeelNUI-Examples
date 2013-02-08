package examples
{
	import orangepeel.kinect.objects.TrackedUser;
	import orangepeel.kinect.utils.KinectHelper;
	import orangepeel.kinect.views.KinectView;
	
	import flash.display.Bitmap;
	
	public class UserMaskedTest extends KinectView
	{
		private var _userMasks:Vector.<Bitmap>;
		
		/**
		 * Class method.
		 */
		public function UserMaskedTest()
		{
			super();
			this._userMasks = new Vector.<Bitmap>;
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
			var um:Bitmap = new Bitmap();
			um.name = String(trackedUser.trackingID);
			this._userMasks.push(um);
			this.addChild(um);
		}
		
		override protected function _remove(trackedUser:TrackedUser):void
		{
			var um:Bitmap = this.getUserMaskByID(String(trackedUser.trackingID));
			if(um)
			{
				this._userMasks.splice(this._userMasks.indexOf(um), 1);
				this.removeChild(um);
			}
		}
		
		override protected function _render(trackedUsers:Vector.<TrackedUser>):void
		{
			if(this._userMasks.length > 0)
			{
				for each(var um:Bitmap in this._userMasks)
				{
					var tu:TrackedUser = KinectHelper.getTrackedUserByTrackingID(Number(um.name), trackedUsers);
					if(tu && tu.userMask) 
					{
						um.bitmapData = tu.userMask.bitmapData;
						um.visible = (tu.offScreen) ? false : true;
						um.width = this.width;
						um.height = this.height;
					}
				}
			}
		}
		
		/**
		 * Private methods.
		 */
		private function getUserMaskByID(id:String):Bitmap
		{
			var umb:Bitmap = null;
			for each(var um:Bitmap in this._userMasks) if(um.name == id) umb = um;
			return umb;
		}
	}
}