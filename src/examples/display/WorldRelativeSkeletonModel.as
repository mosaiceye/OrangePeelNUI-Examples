package examples.display
{
	import com.as3nui.nativeExtensions.air.kinect.data.*;
	import orangepeel.display.BaseSprite;
	import orangepeel.kinect.KinectWrapper;
	import orangepeel.kinect.objects.Join;
	import orangepeel.kinect.objects.KinectSkeleton;
	import orangepeel.kinect.utils.TransformSmoothing;
	
	import examples.skins.InfoBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class WorldRelativeSkeletonModel extends BaseSprite
	{
		private var _smoother:Dictionary;
		private var _worldRelSkeleton:KinectSkeleton;
		private var _points:Sprite;
		private var _lines:Sprite;
		private var _body:Sprite;
		
		public function WorldRelativeSkeletonModel(pWorldRelativeSkeleton:KinectSkeleton)
		{
			this._worldRelSkeleton = pWorldRelativeSkeleton;
			this._smoother = new Dictionary();
			super();
		}
		
		override protected function init(event:Event):void
		{
			super.init(event);
			
			// Body container.
			this._body = new Sprite();
			this.addChild(this._body);
			
			// Lines container.
			this._lines = new Sprite();
			this.addChild(this._lines);
			
			// Points container.
			this._points = new Sprite();
			this.addChild(this._points);
			
			// Create Points.
			this.createPoints();
		}
		
		protected function updateModel():void
		{
			this.updatePoints();
			this.updateBody();
		}
		
		protected function updatePositons(ib:InfoBox, p:Join):void
		{
			if(ib && p)
			{
				if(this._smoother[p.name] == null)
				{
					this._smoother[p.name] = new TransformSmoothing(5);
				}
				else
				{
					var history:TransformSmoothing = this._smoother[p.name];
					var sv:Vector3D = history.smoothVector3D(p.vector3D);
					ib.x = (((sv.x + 1) * .5)  * this.parent.width);
					ib.y = (((sv.y - 1) / -2) * this.parent.height);
					ib.z = (sv.z * KinectWrapper.KinectMaxDepthInFlash);
					ib.alpha = p.confidence;
				}
			}
		}
		
		protected function createPoints():void
		{
			// Create all Joint Points.
			if(this._worldRelSkeleton.joints.length > 0)
			{
				for each(var p:Join in this._worldRelSkeleton.joints)
				{
					var jointPointBox:InfoBox = new InfoBox(p.name);
					this.updatePositons(jointPointBox, p);
					this._points.addChild(jointPointBox);
				}
			}
			
			// Create all Bone Points.
			if(this._worldRelSkeleton.bones.length > 0)
			{
				for each(var b:Join in this._worldRelSkeleton.bones)
				{
					var bonePointBox:InfoBox = new InfoBox(b.name, 5, 5, 0xE3E3E3);
					this.updatePositons(bonePointBox, p);
					this._points.addChild(bonePointBox);
					
					var line:Sprite = new Sprite();
					line.name = b.name;
					this._lines.addChild(line);
				}
			}
		}
		
		protected function updatePoints():void
		{
			// Update all Joint Points.
			if(this._worldRelSkeleton.joints.length > 0)
			{
				for each(var p:Join in this._worldRelSkeleton.joints)
				{
					var jointPointBox:InfoBox = this._points.getChildByName(p.name) as InfoBox;
					this.updatePositons(jointPointBox, p);
				}
			}
			
			// Update all Bone Points.
			if(this._worldRelSkeleton.bones.length > 0)
			{
				for each(var b:Join in this._worldRelSkeleton.bones)
				{
					var bonePointBox:InfoBox = this._points.getChildByName(b.name) as InfoBox;
					var originIB:InfoBox = this._points.getChildByName(b.startJointName) as InfoBox;
					var targetIB:InfoBox = this._points.getChildByName(b.endJointName) as InfoBox;
					var line:Sprite = this._lines.getChildByName(b.name) as Sprite;
					
					this.updatePositons(bonePointBox, b);
					this.drawLineBone(line, originIB, targetIB);
				}
			}
		}
		
		protected function updateBody():void
		{
			var leftShoulder:InfoBox = this._points.getChildByName(SkeletonJoint.LEFT_SHOULDER) as InfoBox;
			var rightShoulder:InfoBox = this._points.getChildByName(SkeletonJoint.RIGHT_SHOULDER) as InfoBox;
			var leftHip:InfoBox = this._points.getChildByName(SkeletonJoint.LEFT_HIP) as InfoBox;
			var rightHip:InfoBox = this._points.getChildByName(SkeletonJoint.RIGHT_HIP) as InfoBox;
			this.drawBody(this._body, leftShoulder, rightShoulder, leftHip, rightHip);
		}
		
		protected function drawLineBone(s:Sprite, originPart:InfoBox, targetPart:InfoBox):void
		{
			if(!s) return;
			if(!originPart) return;
			if(!targetPart) return;
			
			// Draw.
			if(s && originPart && targetPart)
			{
				s.graphics.clear();
				s.alpha = originPart.alpha || targetPart.alpha;
				s.graphics.lineStyle(1, 0x00ff00);
				s.graphics.moveTo(originPart.x, originPart.y);
				s.graphics.lineTo(targetPart.x, targetPart.y);	
			}
		}
		
		protected function drawBody(s:Sprite, topLeft:InfoBox, topRight:InfoBox, bottomLeft:InfoBox, bottomRight:InfoBox):void
		{
			s.graphics.clear();
			s.graphics.lineStyle(5, 0x0000ff);
			s.graphics.beginFill(0x0000ff, .8);
			s.graphics.moveTo(topLeft.x, topLeft.y);
			s.graphics.lineTo(topRight.x, topRight.y);
			s.graphics.lineTo(bottomRight.x, bottomRight.y);
			s.graphics.lineTo(bottomLeft.x, bottomRight.y);
			s.graphics.lineTo(topLeft.x, topLeft.y);
			s.graphics.endFill();
			s.alpha = topLeft.alpha || topRight.alpha || bottomLeft.alpha || bottomRight.alpha;
		}
		
		public function get trackingID():Number
		{
			return this._worldRelSkeleton.id;
		}
		
		public function get worldRelativeSkeleton():KinectSkeleton
		{
			return this._worldRelSkeleton;
		}
		
		public function set worldRelativeSkeleton(s:KinectSkeleton):void
		{
			this._worldRelSkeleton = s;
			this.updateModel();
		}
	}
}