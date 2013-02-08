package examples.display3D.away3D
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import away3d.utils.*;
	
	import com.as3nui.nativeExtensions.air.kinect.data.*;
	import orangepeel.kinect.objects.Join;
	import orangepeel.kinect.objects.KinectSkeleton;
	import orangepeel.kinect.utils.KinectHelper;
	import orangepeel.kinect.utils.TransformSmoothing;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class Skeleton3D extends ObjectContainer3D
	{	
		[Embed(source="../../../../proj-assets/img/materials/mat2.jpg")]
		public static var SphereMat:Class;
		
		[Embed(source="../../../../proj-assets/img/materials/mat1.jpg")]
		public static var BoxMat:Class;
		
		private var _positionSmoother:Dictionary;
		private var _depthSmoother:Dictionary;
		
		private var _joints3D:Vector.<ObjectContainer3D>;
		private var _bones3D:Vector.<ObjectContainer3D>;
		
		private var _worldSkeleton:KinectSkeleton;
		private var _sphMat:TextureMaterial;
		private var _boxMat:TextureMaterial;
		
		private var _jointsContainer3D:ObjectContainer3D;
		private var _bonesContainer3D:ObjectContainer3D;
		
		public function Skeleton3D(pWorldSkeleton:KinectSkeleton)
		{
			this._positionSmoother = new Dictionary();
			this._depthSmoother = new Dictionary();
			
			this._joints3D = new Vector.<ObjectContainer3D>;
			this._bones3D = new Vector.<ObjectContainer3D>;
			this._worldSkeleton = pWorldSkeleton;
			super();
			
			this._sphMat = new TextureMaterial(Cast.bitmapTexture(SphereMat), true, true);
			this._boxMat = new TextureMaterial(Cast.bitmapTexture(BoxMat), true, true);
			
			this._jointsContainer3D = new ObjectContainer3D();
			this.addChild(this._jointsContainer3D);
			
			this._bonesContainer3D = new ObjectContainer3D();
			this.addChild(this._bonesContainer3D);
			
			this.build();
		}
		
		protected function build():void
		{
			if(this._worldSkeleton)
			{
				// Build joints.
				for each(var j:Join in this._worldSkeleton.joints)
				{
					var joint3D:ObjectContainer3D = this.createObj(j.name, ((j.name == SkeletonJoint.HEAD) ? 150 : 30), ((j.name == SkeletonJoint.HEAD) ? true : false))
					this._jointsContainer3D.addChild(joint3D);
					this._joints3D.push(joint3D);
				}
				
				// Build bones.
				for each(var b:Join in this._worldSkeleton.bones)
				{
					var bone3D:ObjectContainer3D = this.createObj(b.name, 30, true);
					this._bonesContainer3D.addChild(bone3D);
					this._bones3D.push(bone3D);
					//this.setRotationConstraints(b);
				}
			}
		}
		
		/*protected function setRotationConstraints(bone:Join):void
		{
			switch(bone.name)
			{
				case SkeletonBone.LEFT_UPPER_LEG:
					bone.maxRotation = new Vector3D(0, 0, 0);
					break;
			}
		}*/
		
		protected function updateModel():void
		{
			if(this._worldSkeleton)
			{
				// Update joints.
				if(this._joints3D && this._joints3D.length > 0)
				{
					for each(var j:Join in this._worldSkeleton.joints)
					{
						var joint3D:ObjectContainer3D = this.getJoint3DByName(j.name);
						this.updatePosition(joint3D, j);
						if(j.name == SkeletonJoint.HEAD) 
						{
							joint3D.rotationY = KinectHelper.constraintProcessor(-j.rotationY, 45);
							joint3D.rotationZ = j.rotationZ;
						}
					}
				}
				
				// Update bones.
				if(this._bones3D && this._bones3D.length > 0)
				{
					for each(var b:Join in this._worldSkeleton.bones)
					{
						var bone3D:ObjectContainer3D = this.getBone3DByName(b.name);
						this.updatePosition(bone3D, b);
						this.updateDepth(bone3D, b.depth, b.name);
						this.updateRotation(bone3D, b);
					}
				}
			}
		}
		
		protected function updateDepth(obj:ObjectContainer3D, depth:Number, name:String):void
		{
			if(!obj) return;
			if(this._depthSmoother[name] == null)
			{
				this._depthSmoother[name] = new TransformSmoothing(5);
			}
			else
			{
				var history:TransformSmoothing = this._depthSmoother[name];
				var sd:Number = history.smoothValue(depth);
				obj.scaleZ = (sd / (obj.maxZ * 2));
			}
		}
		
		protected function getJoint3DByName(name:String):ObjectContainer3D
		{
			var joint3D:ObjectContainer3D = null;
			for each(var j3D:ObjectContainer3D in this._joints3D) if(j3D.name == name) joint3D = j3D;
			return joint3D;
		}
		
		protected function getBone3DByName(name:String):ObjectContainer3D
		{
			var bone3D:ObjectContainer3D = null;
			for each(var b3D:ObjectContainer3D in this._bones3D) if(b3D.name == name) bone3D = b3D;
			return bone3D;
		}
		
		protected function updatePosition(obj:ObjectContainer3D, source:Join):void
		{
			if(!obj) return;
			if(!source)
			{
				obj.visible = false;
				return;
			}
			
			if(this._positionSmoother[source.name] == null)
			{
				this._positionSmoother[source.name] = new TransformSmoothing(5);
			}
			else
			{
				var history:TransformSmoothing = this._positionSmoother[source.name];
				var sv:Vector3D = history.smoothVector3D(source.vector3D);
				obj.x = sv.x;
				obj.y = sv.y;
				obj.z = sv.z;
			}
		}
		
		protected function updateRotation(obj:ObjectContainer3D, source:Join):void
		{
			if(!obj) return;
			if(!source)
			{
				obj.visible = false;
				return;
			}
			obj.rotationX = source.rotationX;
			obj.rotationY = source.rotationY;
			obj.rotationZ = source.rotationZ;
		}
		
		protected function createObj(name:String, size:Number = 50, isCube:Boolean = false):ObjectContainer3D
		{
			var j:Mesh = ((isCube) ? new Mesh(new CubeGeometry(size, size, size), this._boxMat) : new Mesh(new SphereGeometry(size), this._sphMat));
			j.name = name;
			return j;
		}
		
		protected function createCone(name:String):ObjectContainer3D
		{
			var c:Mesh = new Mesh(new ConeGeometry(20, 80));
			c.name = name;
			c.rotationX = 90;
			return c;
		}
		
		public function get trackingID():Number
		{
			return this._worldSkeleton.id;
		}
		
		public function get worldSkeleton():KinectSkeleton
		{
			return this._worldSkeleton;
		}
		
		public function set worldSkeleton(pWorldSkeleton:KinectSkeleton):void
		{
			this._worldSkeleton = pWorldSkeleton;
			this.updateModel();
		}
	}
}