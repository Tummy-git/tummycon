/*
Original: https://github.com/phi16/VRC_storage#rounded_trail
LICENSE : CC0
*/

Shader "Rasta/UnyStylus/rounded_trail_for_uni_stylus_selected"
{
	Properties
	{
		_Color ("Solid Color", Color) = (1,1,1,1)
		_Width ("Width", Float) = 0.03
		_OutlineWidth ("Outline Width", Float) = 0.003
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2g
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct g2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float d : TEXCOORD1;
				UNITY_FOG_COORDS(2)
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _Color;
			float _Width;
			float _OutlineWidth;
			
			v2g vert (appdata v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}

			float2 SafeNormalize(float2 v) {
				float magSq = dot(v, v);
				return v * rsqrt(max(magSq, 1e-10));
			}

			float3 SafeNormalize(float3 v) {
				float magSq = dot(v, v);
				return v * rsqrt(max(magSq, 1e-10));
			}

			[maxvertexcount(10)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> stream) {
				g2f o;
				if(IN[0].uv.x + IN[2].uv.x > IN[1].uv.x * 2) return;
				float3 p = IN[0].vertex.xyz, v = IN[1].vertex.xyz;
				v -= p;

				o.color = IN[0].color;
				
				float4 vp1 = mul(UNITY_MATRIX_MV, float4(p, 1));
				float4 vp2 = mul(UNITY_MATRIX_MV, float4(p + v, 1));
				vp1.xyz += SafeNormalize(vp1.xyz) * 0.02;
				vp2.xyz += SafeNormalize(vp2.xyz) * 0.02;
				vp1 = mul(UNITY_MATRIX_P, vp1);
				vp2 = mul(UNITY_MATRIX_P, vp2);
				float2 vd = vp1.xy / max(vp1.w, 1e-10) - vp2.xy / max(vp2.w, 1e-10);
				float aspectRatio = - UNITY_MATRIX_P[0][0] / UNITY_MATRIX_P[1][1];
				vd.x /= aspectRatio;
				o.d = length(vd);
				vd = SafeNormalize(vd);
				float2 vn = vd.yx * float2(-1,1);

				//if(abs(UNITY_MATRIX_P[0][2]) < 0.01) size *= 2; 
				float sz = _Width + _OutlineWidth;
				sz *= unity_CameraProjection._m11 / 1.732;
				vn *= sz;
				vn.x *= aspectRatio;

				o.d = 0;
				o.uv = float2(-1,-1);
				o.vertex = vp1+float4(+vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(-1,1);
				o.vertex = vp1+float4(-vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(1,-1);
				o.vertex = vp2+float4(+vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(1,1);
				o.vertex = vp2+float4(-vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				stream.RestartStrip();
				
				o.d = 1;
				sz *= 2.0;
				if(IN[1].uv.x >= 0.999999) {
					o.uv = float2(0,1);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					o.uv = float2(-0.9,-0.5);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					o.uv = float2(0.9,-0.5);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					stream.RestartStrip();
				}

				o.uv = float2(0,1);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(-0.9,-0.5);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(0.9,-0.5);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				stream.RestartStrip();
			}
			
			fixed4 frag (g2f i) : SV_Target
			{
				float l = length(i.uv);
				clip(- min(i.d - 0.5, l - 0.5));

				float3 col = sin(_Time.y*5)*0.25 + 0.5;
				fixed4 outCol = float4(col,1);
				UNITY_APPLY_FOG(i.fogCoord, outCol);
				return outCol;
			}
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2g
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct g2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float d : TEXCOORD1;
				UNITY_FOG_COORDS(2)
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _Color;
			float _Width;
			
			v2g vert (appdata v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}

			[maxvertexcount(10)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> stream) {
				g2f o;
				if(IN[0].uv.x + IN[2].uv.x > IN[1].uv.x * 2) return;
				float3 p = IN[0].vertex.xyz, v = IN[1].vertex.xyz;
				v -= p;

				o.color = IN[0].color;
				
				float4 vp1 = UnityObjectToClipPos(float4(p, 1));
				float4 vp2 = UnityObjectToClipPos(float4(p + v, 1));
				float2 vd = vp1.xy / vp1.w - vp2.xy / vp2.w;
				float aspectRatio = - UNITY_MATRIX_P[0][0] / UNITY_MATRIX_P[1][1];
				vd.x /= aspectRatio;
				o.d = length(vd);
				if(length(vd) < 0.0001) vd = float2(1,0);
				else vd = normalize(vd);
				float2 vn = vd.yx * float2(-1,1);

				//if(abs(UNITY_MATRIX_P[0][2]) < 0.01) size *= 2; 
				float sz = _Width;
				sz *= unity_CameraProjection._m11 / 1.732;
				vn *= sz;
				vn.x *= aspectRatio;

				o.d = 0;
				o.uv = float2(-1,-1);
				o.vertex = vp1+float4(+vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(-1,1);
				o.vertex = vp1+float4(-vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(1,-1);
				o.vertex = vp2+float4(+vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(1,1);
				o.vertex = vp2+float4(-vn,0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				stream.RestartStrip();
				
				o.d = 1;
				sz *= 2.0;
				if(IN[1].uv.x >= 0.999999) {
					o.uv = float2(0,1);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					o.uv = float2(-0.9,-0.5);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					o.uv = float2(0.9,-0.5);
					o.vertex = vp2+float4(o.uv*sz*float2(aspectRatio,1),0,0);
					UNITY_TRANSFER_FOG(o, o.vertex);
					stream.Append(o);
					stream.RestartStrip();
				}

				o.uv = float2(0,1);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(-0.9,-0.5);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				o.uv = float2(0.9,-0.5);
				o.vertex = vp1+float4(o.uv*sz*float2(aspectRatio,1),0,0);
				UNITY_TRANSFER_FOG(o, o.vertex);
				stream.Append(o);
				stream.RestartStrip();
			}
			
			fixed4 frag (g2f i) : SV_Target
			{
				float l = length(i.uv);
				clip(- min(i.d - 0.5, l - 0.5));
				fixed4 outCol = float4(i.color.rgb * _Color.rgb,1);
				UNITY_APPLY_FOG(i.fogCoord, outCol);
				return outCol;
			}
			ENDCG
		}
	}
}
