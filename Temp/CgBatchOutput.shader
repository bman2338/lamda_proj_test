Shader "FX/Water (simple)" {
Properties {
	_horizonColor ("Horizon color", COLOR)  = ( .172 , .463 , .435 , 0)
	_WaveScale ("Wave scale", Range (0.02,0.15)) = .07
	_ColorControl ("Reflective color (RGB) fresnel (A) ", 2D) = "" { }
	_ColorControlCube ("Reflective color cube (RGB) fresnel (A) ", Cube) = "" { TexGen CubeReflect }
	_BumpMap ("Waves Normalmap ", 2D) = "" { }
	WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
	_MainTex ("Fallback texture", 2D) = "" { }
}

#LINE 54

	
// -----------------------------------------------------------
// Fragment program

Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {

Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 18 to 18
//   d3d9 - ALU: 18 to 18
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Float 11 [_WaveScale]
Vector 12 [_WaveOffset]
"!!ARBvp1.0
# 18 ALU
PARAM c[13] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].z;
MOV R1.xyz, c[10];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R1.xyz, R0, c[9].w, -vertex.position;
DP3 R0.x, R1, R1;
RSQ R1.w, R0.x;
RCP R0.z, c[9].w;
MUL R0.xy, vertex.position.xzzw, c[11].x;
MAD R0, R0.xyxy, R0.z, c[12];
MUL result.texcoord[2].xyz, R1.w, R1.xzyw;
MUL result.texcoord[0].xy, R0, c[0];
MOV result.texcoord[1].xy, R0.wzzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Float 10 [_WaveScale]
Vector 11 [_WaveOffset]
"vs_2_0
; 18 ALU
def c12, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
mov r1.w, c12.z
mov r1.xyz, c9
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r1.xyz, r0, c8.w, -v0
dp3 r0.x, r1, r1
rsq r1.w, r0.x
rcp r0.z, c8.w
mul r0.xy, v0.xzzw, c10.x
mad r0, r0.xyxy, r0.z, c11
mul oT2.xyz, r1.w, r1.xzyw
mul oT0.xy, r0, c12
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 temp;
  vec2 tmpvar_1[2];
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  tmpvar_1[0] = (temp.xy * vec2(0.4, 0.45));
  tmpvar_1[1] = temp.wz;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1[0];
  xlv_TEXCOORD0_1 = tmpvar_1[1];
  xlv_TEXCOORD2 = normalize ((((_World2Object * tmpvar_2).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _horizonColor;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  vec2 tmpvar_1[2];
  tmpvar_1[0] = xlv_TEXCOORD0;
  tmpvar_1[1] = xlv_TEXCOORD0_1;
  mediump vec4 col;
  mediump vec4 water;
  mediump float fresnel;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((texture2D (_BumpMap, tmpvar_1[0]).xyz * 2.0) - 1.0);
  bump1 = tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, tmpvar_1[1]).xyz * 2.0) - 1.0);
  bump2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((bump1 + bump2) * 0.5);
  highp float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD2, tmpvar_4);
  fresnel = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6.x = fresnel;
  tmpvar_6.y = fresnel;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ColorControl, tmpvar_6);
  water = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = water.www;
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (water.xyz, _horizonColor.xyz, tmpvar_8);
  col.xyz = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = _horizonColor.w;
  col.w = tmpvar_10;
  gl_FragData[0] = col;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 21 to 21, TEX: 3 to 3
//   d3d9 - ALU: 22 to 22, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Vector 0 [_horizonColor]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.yw, fragment.texcoord[1], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0], texture[0], 2D;
MAD R0.xy, R0.wyzw, c[1].x, -c[1].y;
MAD R1.xy, R1.wyzw, c[1].x, -c[1].y;
MUL R0.w, R0.y, R0.y;
MUL R0.z, R1.y, R1.y;
MAD R0.w, -R0.x, R0.x, -R0;
MAD R0.z, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[1].y;
RSQ R1.z, R0.w;
ADD R0.z, R0, c[1].y;
RSQ R0.w, R0.z;
RCP R0.z, R1.z;
RCP R1.z, R0.w;
ADD R0.xyz, R1, R0;
MUL R0.xyz, R0, c[1].z;
DP3 R0.x, fragment.texcoord[2], R0;
MOV result.color.w, c[0];
TEX R0, R0.x, texture[1], 2D;
ADD R1.xyz, -R0, c[0];
MAD result.color.xyz, R0.w, R1, R0;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_horizonColor]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
"ps_2_0
; 22 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c1, 2.00000000, -1.00000000, 1.00000000, 0.50000000
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r1, t1, s0
texld r0, t0, s0
mov r0.x, r0.w
mad_pp r3.xy, r0, c1.x, c1.y
mov r1.x, r1.w
mad_pp r2.xy, r1, c1.x, c1.y
mul_pp r1.x, r2.y, r2.y
mul_pp r0.x, r3.y, r3.y
mad_pp r1.x, -r2, r2, -r1
mad_pp r0.x, -r3, r3, -r0
add_pp r1.x, r1, c1.z
rsq_pp r1.x, r1.x
add_pp r0.x, r0, c1.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r1.x
rcp_pp r3.z, r0.x
add_pp r0.xyz, r3, r2
mul_pp r0.xyz, r0, c1.w
dp3 r0.x, t2, r0
mov r0.xy, r0.x
texld r0, r0, s1
add_pp r1.xyz, -r0, c0
mad_pp r0.xyz, r0.w, r1, r0
mov_pp r0.w, c0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 85

	}
}

// -----------------------------------------------------------
//  Old cards

// three texture, cubemaps
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture * primary
		}
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix2]
			combine texture * primary + previous
		}
		SetTexture [_ColorControlCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// dual texture, cubemaps
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture
		}
		SetTexture [_ColorControlCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// single texture
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture, primary
		}
	}
}

}
