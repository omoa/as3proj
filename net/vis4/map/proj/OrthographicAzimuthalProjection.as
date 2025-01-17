﻿/*
Copyright 2006 Jerry Huxtable

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
 * This file was semi-automatically converted from the public-domain USGS PROJ source.
 */

/*
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */

package net.vis4.map.proj 
{
	import flash.geom.Point;
	import net.vis4.map.MapMath;
	import net.vis4.map.proj.AzimuthalProjection;

	/**
	 * The Orthographic Azimuthal or Globe map projection.
	 */
	public class OrthographicAzimuthalProjection extends AzimuthalProjection
	{
		
		public function OrthographicAzimuthalProjection() 
		{
			initialize();
		}
		
		override public function project(lam:Number, phi:Number, xy:Point):Point 
		{
			var sinphi:Number;
			var cosphi:Number = Math.cos(phi);
			var coslam:Number = Math.cos(lam);

			// Theoretically we should throw the ProjectionExceptions below, but for practical purposes
			// it's better not to as they tend to crop up a lot up due to rounding errors.
			switch (mode) {
			case EQUATOR:
	//			if (cosphi * coslam < - EPS10)
	//				throw new ProjectionError();
				xy.y = Math.sin(phi);
				break;
			case OBLIQUE:
				sinphi = Math.sin(phi);
	//			if (sinphi0 * (sinphi) + cosphi0 * cosphi * coslam < - EPS10)
	//				;
	//			   throw new ProjectionError();
				xy.y = cosphi0 * sinphi - sinphi0 * cosphi * coslam;
				break;
			case NORTH_POLE:
				coslam = - coslam;
			case SOUTH_POLE:
	//			if (Math.abs(phi - projectionLatitude) - EPS10 > MapMath.HALFPI)
	//				throw new ProjectionError();
				xy.y = cosphi * coslam;
				break;
			}
			xy.x = cosphi * Math.sin(lam);
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			var rh:Number, cosc:Number, sinc:Number;

			if ((sinc = (rh = MapMath.distance(x, y))) > 1.) {
				if ((sinc - 1.) > EPS10) throw new ProjectionError();
					sinc = 1.;
			}
			cosc = Math.sqrt(1. - sinc * sinc); //in this range OK
			if (Math.abs(rh) <= EPS10)
				lp.y = projectionLatitude;
			else switch (mode) {
			case NORTH_POLE:
				y = -y;
				lp.y = Math.acos(sinc);
				break;
			case SOUTH_POLE:
				lp.y = - Math.acos(sinc);
				break;
			case EQUATOR:
				lp.y = y * sinc / rh;
				x *= sinc;
				y = cosc * rh;
				if (Math.abs(lp.y) >= 1.)
					lp.y = lp.y < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
				else
					lp.y = Math.asin(lp.y);
				break;
			case OBLIQUE:
				lp.y = cosc * sinphi0 + y * sinc * cosphi0 / rh;
				y = (cosc - sinphi0 * lp.y) * rh;
				x *= sinc * cosphi0;
				if (Math.abs(lp.y) >= 1.)
					lp.y = lp.y < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
				else
					lp.y = Math.asin(lp.y);
				break;
			}
			lp.x = (y == 0. && (mode == OBLIQUE || mode == EQUATOR)) ?
				 (x == 0. ? 0. : x < 0. ? -MapMath.HALFPI : MapMath.HALFPI) : Math.atan2(x, y);
			return lp;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Orthographic Azimuthal";
		}
		
		override public function get shortName():String { return "Orthographic"; }
		
	}

}