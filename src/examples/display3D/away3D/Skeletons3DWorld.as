package examples.display3D.away3D
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.*;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.*;
	import away3d.utils.Cast;
	
	import orangepeel.display3D.away3D.Basic3DView;
	
	public class Skeletons3DWorld extends Basic3DView
	{
		[Embed(source="../../../../proj-assets/img/materials/horizon1.jpg")]
		public static var HorizonMat:Class;
		
		private var _plane:Mesh;
		private var _skeletonsContainer:ObjectContainer3D;
		private var _horzMat:TextureMaterial;
		
		public function Skeletons3DWorld(mouseControl:Boolean = true)
		{
			super(mouseControl);
		}
		
		public function addSkeleton(s:Skeleton3D):void
		{
			this._skeletonsContainer.addChild(s);
		}
		
		public function removeSkeleton(s:Skeleton3D):void
		{
			this._skeletonsContainer.removeChild(s);
		}
		
		override protected function initMaterials():void
		{
			super.initMaterials();
			this._horzMat = new TextureMaterial(Cast.bitmapTexture(HorizonMat), true, true);
		}
		
		override protected function initObjects():void
		{
			super.initObjects();
			this._plane = new Mesh(new PlaneGeometry(3000, 2000), this._horzMat);
			this._plane.z = 2800;
			this._plane.rotationX = -90;
			this._scene.addChild(this._plane);
			
			this._skeletonsContainer = new ObjectContainer3D();
			this._scene.addChild(this._skeletonsContainer);
		}
	}
}