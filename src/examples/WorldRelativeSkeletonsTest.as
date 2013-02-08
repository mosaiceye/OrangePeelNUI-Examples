package examples
{
	import orangepeel.kinect.objects.KinectSkeleton;
	import orangepeel.kinect.objects.TrackedUser;
	import orangepeel.kinect.utils.KinectHelper;
	import orangepeel.kinect.views.KinectView;
	
	import examples.display.WorldRelativeSkeletonModel;
	
	public class WorldRelativeSkeletonsTest extends KinectView
	{
		private var _worldRelativeSkeletonModels:Vector.<WorldRelativeSkeletonModel>;
		
		public function WorldRelativeSkeletonsTest()
		{
			this._worldRelativeSkeletonModels = new Vector.<WorldRelativeSkeletonModel>;
			super();
		}
		
		override protected function layout():void
		{
			super.layout();
			if(this.stage) this.setSize(stage.stageWidth, stage.stageHeight);
			
			this.graphics.clear();
			this.graphics.beginFill(0x333333);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
		}
		
		override protected function _addSkeleton(trackedUser:TrackedUser):void
		{
			var rs:KinectSkeleton = trackedUser.worldRelativeSkeleton;
			var rsm:WorldRelativeSkeletonModel = new WorldRelativeSkeletonModel(rs);
			this.addChild(rsm);
			this._worldRelativeSkeletonModels.push(rsm);
		}
		
		override protected function _remove(trackedUser:TrackedUser):void
		{
			if(this._worldRelativeSkeletonModels.length > 0)
			{
				for each(var dm:WorldRelativeSkeletonModel in this._worldRelativeSkeletonModels)
				{
					if(dm.trackingID == trackedUser.trackingID)
					{
						this._worldRelativeSkeletonModels.splice(this._worldRelativeSkeletonModels.indexOf(dm), 1);
						this.removeChild(dm);
					}
				}
			}
		}
		
		override protected function _render(trackedUsers:Vector.<TrackedUser>):void
		{
			if(this._worldRelativeSkeletonModels.length > 0)
			{
				for each(var rsm:WorldRelativeSkeletonModel in this._worldRelativeSkeletonModels)
				{
					if(rsm)
					{
						var tu:TrackedUser = KinectHelper.getTrackedUserByTrackingID(rsm.worldRelativeSkeleton.id, trackedUsers);
						if(tu && tu.hasSkeleton) 
						{
							rsm.worldRelativeSkeleton = tu.worldRelativeSkeleton;
							rsm.visible = (tu.offScreen) ? false : true;
						}
					}
				}
			}
		}
	}
}