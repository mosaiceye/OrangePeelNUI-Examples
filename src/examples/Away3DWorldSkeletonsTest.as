package examples
{
	import orangepeel.kinect.objects.KinectSkeleton;
	import orangepeel.kinect.objects.TrackedUser;
	import orangepeel.kinect.utils.KinectHelper;
	import orangepeel.kinect.views.KinectView;
	
	import examples.display3D.away3D.Skeleton3D;
	import examples.display3D.away3D.Skeletons3DWorld;
	
	import flash.events.Event;
	
	public class Away3DWorldSkeletonsTest extends KinectView
	{
		private var _skeletons3DWorld:Skeletons3DWorld;
		private var _skeletons3D:Vector.<Skeleton3D>;
		
		public function Away3DWorldSkeletonsTest()
		{
			this._skeletons3D = new Vector.<Skeleton3D>;
			super();
		}
		
		override protected function init(event:Event):void
		{
			super.init(event);
			this._skeletons3DWorld = new Skeletons3DWorld();
			this.addChild(this._skeletons3DWorld);
		}
		
		override protected function layout():void
		{
			super.layout();
			if(this.stage) this.setSize(stage.stageWidth, stage.stageHeight);
		}
		
		override protected function _addSkeleton(trackedUser:TrackedUser):void
		{
			var ws:KinectSkeleton = trackedUser.worldSkeleton;
			var s:Skeleton3D = new Skeleton3D(ws);
			this._skeletons3DWorld.addSkeleton(s);
			this._skeletons3D.push(s);
		}
		
		override protected function _remove(trackedUser:TrackedUser):void
		{
			if(this._skeletons3D.length > 0)
			{
				for each(var s:Skeleton3D in this._skeletons3D)
				{
					if(s.trackingID == trackedUser.trackingID)
					{
						this._skeletons3D.splice(this._skeletons3D.indexOf(s), 1);
						this._skeletons3DWorld.removeSkeleton(s);
					}
				}
			}
		}
		
		override protected function _render(trackedUsers:Vector.<TrackedUser>):void
		{
			if(this._skeletons3D.length > 0)
			{
				for each(var s:Skeleton3D in this._skeletons3D)
				{
					if(s)
					{
						var tu:TrackedUser = KinectHelper.getTrackedUserByTrackingID(s.worldSkeleton.id, trackedUsers);
						if(tu && tu.hasSkeleton)
						{
							s.worldSkeleton = tu.worldSkeleton;
							s.visible = (tu.offScreen) ? false : true;
						}
					}
				}
			}
		}
	}
}