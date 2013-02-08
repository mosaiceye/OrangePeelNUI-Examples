package
{
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.bit101.components.Label;
	import orangepeel.kinect.KinectWrapper;
	import orangepeel.kinect.events.KinectTrackedUserEvent;
	import orangepeel.kinect.events.KinectWrapperEvent;
	import orangepeel.kinect.views.KinectView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import examples.ui.TestToolbar;
	
	[SWF(frameRate = "60", width = "800", height = "600", backgroundColor = "0x000000", quality="LOW")]
	
	public class OrangePeelNUIExamples extends Sprite
	{
		public static const NO_KINECT:Boolean = false;
		
		private var _kinect:KinectWrapper;
		private var _currentTest:KinectView;
		private var _testToolbar:TestToolbar;
		private var _testWrapper:Sprite;
		private var _msgLbl:Label;
		
		public function OrangePeelNUIExamples()
		{
			// Stage configuration.
			stage.nativeWindow.visible = true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			init();
		}
		
		private function init():void
		{
			// Setup message label.
			this._msgLbl = new Label(null, 330, 294);
			this._msgLbl.autoSize = true;
			this.addChild(this._msgLbl);
			this._msgLbl.visible = (NO_KINECT) ? false : true;
			
			// Setup test wrapper.
			this._testWrapper = new Sprite();
			this.addChild(this._testWrapper);
			this._testWrapper.visible = NO_KINECT;
			
			// Setup test toolbar.
			this._testToolbar = new TestToolbar();
			this.addChild(this._testToolbar);
			this._testToolbar.addEventListener(Event.SELECT, this.addTest);
			this._testToolbar.visible = NO_KINECT;
			
			// Setup Kinect support.
			if(!NO_KINECT) 
			{
				this._kinect = new KinectWrapper(true);
				this.addChild(this._kinect);
				this._kinect.userMaskResolution = CameraResolution.RESOLUTION_640_480;
				this._kinect.rgbResolution = CameraResolution.RESOLUTION_640_480;
				this._kinect.depthResolution = CameraResolution.RESOLUTION_640_480;
				this._kinect.start();
				
				this._kinect.addEventListener(KinectWrapperEvent.STARTED, this.started);
				this._kinect.addEventListener(KinectWrapperEvent.STOPPED, this.stopped);
				this._kinect.addEventListener(KinectWrapperEvent.RENDERING, this.rendering);
				this._kinect.addEventListener(KinectTrackedUserEvent.TRACKED_USER_ADDED, this.trackedUserAdded);
				this._kinect.addEventListener(KinectTrackedUserEvent.TRACKED_USER_SKELETON_ADDED, this.trackedUserSkeletonAdded);
				this._kinect.addEventListener(KinectTrackedUserEvent.TRACKED_USER_REMOVED, this.trackedUserRemoved);
				if(this._kinect.device) this._kinect.device.addEventListener(DeviceInfoEvent.INFO, this.onDeviceInfo, false, 0, true);
				else trace('NO DEVICE');
				this._kinect.visible = NO_KINECT;
			}
			
			// Add resize listener.
			this.stage.nativeWindow.addEventListener(Event.RESIZE, this.layout, false, 0, true);
		}
		
		protected function onDeviceInfo(event:DeviceInfoEvent):void 
		{
			this._msgLbl.text = event.message;
		}
		
		private function layout(event:Event = null):void
		{
			this._msgLbl.x = ((stage.stageWidth/2) - (this._msgLbl.width/2));
			this._msgLbl.y = ((stage.stageHeight/2) - (this._msgLbl.height/2));
		}
		
		private function started(event:KinectWrapperEvent):void
		{
			this._msgLbl.visible = false;
			this._testToolbar.visible = true;
			this._testWrapper.visible = true;
			this._kinect.visible = true;
		}
		
		private function stopped(event:KinectWrapperEvent):void
		{
			this._testToolbar.visible = false;
			this._testWrapper.visible = false;
			this._kinect.visible = false;
			this._msgLbl.text = "ERROR: Kinect Stopped Working";
			this._msgLbl.visible = true;
		}
		
		private function rendering(event:KinectWrapperEvent):void
		{
			if(this._currentTest) this._currentTest.render(event.trackedUsers);
		}
		
		private function trackedUserAdded(event:KinectTrackedUserEvent):void
		{
			if(this._currentTest) this._currentTest.add(event.trackedUser);
		}
		
		private function trackedUserSkeletonAdded(event:KinectTrackedUserEvent):void
		{
			if(this._currentTest) this._currentTest.addSkeleton(event.trackedUser);
		}
		
		private function trackedUserRemoved(event:KinectTrackedUserEvent):void
		{
			if(this._currentTest) this._currentTest.remove(event.trackedUser);
		}
		
		private function addTest(event:Event):void
		{
			if(this._currentTest) 
			{
				this._testWrapper.removeChild(this._currentTest);
				this._currentTest = null;
			}
			
			this._currentTest = new this._testToolbar.currentExample() as KinectView;
			this._testWrapper.addChild(this._currentTest);
		}
	}
}