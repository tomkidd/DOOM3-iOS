/*
===========================================================================

Doom 3 GPL Source Code
Copyright (C) 1999-2011 id Software LLC, a ZeniMax Media company.

This file is part of the Doom 3 GPL Source Code ("Doom 3 Source Code").

Doom 3 Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Doom 3 Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Doom 3 Source Code.  If not, see <http://www.gnu.org/licenses/>.

In addition, the Doom 3 Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU General Public License which accompanied the Doom 3 Source Code.  If not, please request a copy in writing from id Software at the address below.

If you have questions concerning this license or the applicable additional terms, you may contact in writing id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

===========================================================================
*/

#include "sys/platform.h"
#include "renderer/VertexCache.h"

#include "renderer/tr_local.h"

/*
=====================
RB_BakeTextureMatrixIntoTexgen
=====================
*/
void RB_BakeTextureMatrixIntoTexgen( idMat4 & lightProject, const float *textureMatrix ) {
	float	genMatrix[16];
	float	final[16];

	genMatrix[0] = lightProject[0][0];
	genMatrix[4] = lightProject[0][1];
	genMatrix[8] = lightProject[0][2];
	genMatrix[12] = lightProject[0][3];

	genMatrix[1] = lightProject[1][0];
	genMatrix[5] = lightProject[1][1];
	genMatrix[9] = lightProject[1][2];
	genMatrix[13] = lightProject[1][3];

	genMatrix[2] = 0;
	genMatrix[6] = 0;
	genMatrix[10] = 0;
	genMatrix[14] = 0;

	genMatrix[3] = lightProject[3][0];
	genMatrix[7] = lightProject[3][1];
	genMatrix[11] = lightProject[3][2];
	genMatrix[15] = lightProject[3][3];

	myGlMultMatrix( genMatrix, textureMatrix, final );

	lightProject[0][0] = final[0];
	lightProject[0][1] = final[4];
	lightProject[0][2] = final[8];
	lightProject[0][3] = final[12];

	lightProject[1][0] = final[1];
	lightProject[1][1] = final[5];
	lightProject[1][2] = final[9];
	lightProject[1][3] = final[13];
}

/*
=============
RB_RenderView
=============
*/
void RB_RenderView(void) {
  drawSurf_t **drawSurfs = (drawSurf_t * *) & backEnd.viewDef->drawSurfs[0];
  const int numDrawSurfs = backEnd.viewDef->numDrawSurfs;

  // clear the z buffer, set the projection matrix, etc
  RB_BeginDrawingView();

  // Setup GLSL shader state
  RB_GLSL_PrepareShaders();

  // fill the depth buffer and clear color buffer to black except on subviews
	RB_GLSL_FillDepthBuffer( drawSurfs, numDrawSurfs );

  // main light renderer
  RB_GLSL_DrawInteractions();

  // disable stencil shadow test
  qglStencilFunc(GL_ALWAYS, 128, 255);

  // now draw any non-light dependent shading passes
  const int processed = RB_GLSL_DrawShaderPasses(drawSurfs, numDrawSurfs);

  // fog and blend lights
  RB_GLSL_FogAllLights();

  // now draw any post-processing effects using _currentRender
  if (processed < numDrawSurfs) {
    RB_GLSL_DrawShaderPasses(drawSurfs + processed, numDrawSurfs - processed);
  }
}
