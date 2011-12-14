package src
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import net.vis4.map.proj.*;
	import net.vis4.map.proj.Projection;
	
	/**
	 * ...
	 * @author Sebastian Specht
	 */
	public class Main extends Sprite 
	{
		private var proj:Projection;
		private var p:Point =  new Point();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			//proj = new LambertEqualAreaConicProjection();
			proj = new EqualAreaAzimuthalProjection();
			proj.initialize();
			
			proj.project( 0.0, 0.0, p );
			trace( p );
			
			var date:Number = new Date().getTime();
			var count:int = 0;
			while (count <= 1000) {
				drawGrid();
				count++;
			}
			trace( new Date().getTime() - date );
		}
		
		private function drawGrid():void 
		{
			var lamIncrement:Number = (Math.PI-0.1) * 0.1;
			var phiIncrement:Number = (Math.PI-0.1) * 0.5 * 0.1;
			var scale:Number = 100;
			graphics.clear();
			graphics.beginFill(0xff0000);
			for ( var lam:int = -10; lam <= 10; lam++) {
				for ( var phi:int = -10; phi <= 10; phi++) {
					proj.project( lam*lamIncrement, phi*phiIncrement, p );
					graphics.drawCircle( p.x*scale, p.y*scale, 1);
				}
			}
			graphics.endFill();
			
			graphics.lineStyle( 2, 0, 0.1 );
			
			proj.project( 0, -10*phiIncrement, p );
			graphics.moveTo( p.x*scale, p.y*scale );
			for ( phi = -9; phi <= 10; phi++) {
				proj.project( 0, phi*phiIncrement, p );
				graphics.lineTo( p.x*scale, p.y*scale);
			}
			
			proj.project( -10*lamIncrement, 0, p );
			graphics.moveTo( p.x*scale, p.y*scale );
			for ( lam = -9; lam <= 10; lam++) {
				proj.project( lam*lamIncrement, 0, p );
				graphics.lineTo( p.x*scale, p.y*scale);
			}
			
			this.x = stage.stageWidth * 0.5;
			this.y = stage.stageHeight * 0.5;
			this.scaleY = -1;
		}
		
	}
	
}