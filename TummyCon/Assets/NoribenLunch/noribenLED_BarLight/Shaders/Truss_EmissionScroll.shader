// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Truss_EmissionScroll"
{
	Properties
	{
		_MainColor("MainColor", Color) = (0.4584906,0.4901597,0.509434,0)
		_WaveFrequency("WaveFrequency", Float) = 1
		_WaveFrequency1("WaveFrequency", Float) = 1
		[HDR]_EmissionScroll01("EmissionScroll01", Color) = (0.8773585,0.8773585,0.8773585,0)
		[HDR]_EmissionScroll02("EmissionScroll02", Color) = (0.8773585,0.8773585,0.8773585,0)
		_ScrollSpeed1("ScrollSpeed1", Float) = 0
		_ScrollSpeed2("ScrollSpeed2", Float) = 0
		_WaveContrast("WaveContrast", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_NormalTex("NormalTex", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 0
		_MetallicSmoothness("MetallicSmoothness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainColor;
		uniform float4 _EmissionScroll01;
		uniform float _WaveFrequency;
		uniform float _ScrollSpeed1;
		uniform float _WaveContrast;
		uniform float4 _EmissionScroll02;
		uniform float _WaveFrequency1;
		uniform float _ScrollSpeed2;
		uniform sampler2D _MetallicSmoothness;
		uniform float4 _MetallicSmoothness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), _NormalScale );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = ( tex2D( _MainTex, uv_MainTex ) * _MainColor ).rgb;
			float mulTime8 = _Time.y * _ScrollSpeed1;
			float mulTime14 = _Time.y * _ScrollSpeed2;
			o.Emission = ( ( _EmissionScroll01 * pow( ( ( sin( ( ( i.vertexColor.r * _WaveFrequency ) + mulTime8 ) ) + 1.0 ) * 0.5 ) , _WaveContrast ) ) + ( _EmissionScroll02 * pow( ( ( sin( ( ( i.vertexColor.r * _WaveFrequency1 ) + mulTime14 ) ) + 1.0 ) * 0.5 ) , _WaveContrast ) ) ).rgb;
			float2 uv_MetallicSmoothness = i.uv_texcoord * _MetallicSmoothness_ST.xy + _MetallicSmoothness_ST.zw;
			float4 tex2DNode34 = tex2D( _MetallicSmoothness, uv_MetallicSmoothness );
			float4 appendResult35 = (float4(tex2DNode34.r , tex2DNode34.g , tex2DNode34.b , 0.0));
			o.Metallic = appendResult35.x;
			o.Smoothness = tex2DNode34.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-125.5855,149.9245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-100.0164,685.2508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;169.8943,375.023;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;23;-306.0187,260.6229;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;122;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;-279.8123,769.3329;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;122;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-645.834,501.8544;Inherit;False;Property;_WaveContrast;WaveContrast;7;0;Create;True;0;0;0;False;0;False;0;55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;4;-1798.438,68.98869;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1303.322,323.0133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-1552.923,378.9133;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-1177.222,180.0133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1528.223,151.4132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;23;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1788.223,272.3134;Inherit;False;Property;_WaveFrequency;WaveFrequency;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1902.001,415.844;Inherit;False;Property;_ScrollSpeed1;ScrollSpeed1;5;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-965.4576,297.5027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-785.4576,304.5027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;-1698.614,661.033;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1203.5,915.0576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1453.1,970.9576;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1428.4,743.4575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;23;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1688.399,864.3577;Inherit;False;Property;_WaveFrequency1;WaveFrequency;2;0;Create;True;0;0;0;False;0;False;1;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1756.746,1008.562;Inherit;False;Property;_ScrollSpeed2;ScrollSpeed2;6;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;15;-1020.917,856.782;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-827.0931,902.8821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-647.0931,909.8821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-4.497872,-573.4077;Inherit;True;Property;_MainTex;MainTex;8;0;Create;True;0;0;0;False;0;False;-1;None;8fa654ad93c58c0469a93a086abcb29f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;420.7851,-448.89;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;43.72791,-7.224365;Inherit;False;Property;_NormalScale;NormalScale;10;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;287.4878,-69.97023;Inherit;True;Property;_NormalTex;NormalTex;9;0;Create;True;0;0;0;False;0;False;-1;None;52e9ee7449f878a4e873a00da14e7fe6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;498.1467,372.0699;Inherit;True;Property;_MetallicSmoothness;MetallicSmoothness;11;0;Create;True;0;0;0;False;0;False;-1;None;0a405cb5830f22d4c9467dfd3772569b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;35;854.3457,240.7698;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1150.827,47.23917;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Truss_EmissionScroll;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;10;-475.2855,12.12453;Inherit;False;Property;_EmissionScroll01;EmissionScroll01;3;1;[HDR];Create;True;0;0;0;False;0;False;0.8773585,0.8773585,0.8773585,0;0.02579018,0.01707012,0.06603771,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-449.7163,549.0508;Inherit;False;Property;_EmissionScroll02;EmissionScroll02;4;1;[HDR];Create;True;0;0;0;False;0;False;0.8773585,0.8773585,0.8773585,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;74.21595,-350.9836;Inherit;False;Property;_MainColor;MainColor;0;0;Create;True;0;0;0;False;0;False;0.4584906,0.4901597,0.509434,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;11;0;10;0
WireConnection;11;1;23;0
WireConnection;18;0;19;0
WireConnection;18;1;24;0
WireConnection;20;0;11;0
WireConnection;20;1;18;0
WireConnection;23;0;26;0
WireConnection;23;1;25;0
WireConnection;24;0;29;0
WireConnection;24;1;25;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;8;0;21;0
WireConnection;5;0;7;0
WireConnection;6;0;4;1
WireConnection;6;1;9;0
WireConnection;27;0;5;0
WireConnection;26;0;27;0
WireConnection;13;0;16;0
WireConnection;13;1;14;0
WireConnection;14;0;22;0
WireConnection;16;0;12;1
WireConnection;16;1;17;0
WireConnection;15;0;13;0
WireConnection;28;0;15;0
WireConnection;29;0;28;0
WireConnection;31;0;30;0
WireConnection;31;1;3;0
WireConnection;32;5;33;0
WireConnection;35;0;34;1
WireConnection;35;1;34;2
WireConnection;35;2;34;3
WireConnection;0;0;31;0
WireConnection;0;1;32;0
WireConnection;0;2;20;0
WireConnection;0;3;35;0
WireConnection;0;4;34;4
ASEEND*/
//CHKSM=5B563891B24AA251D54EEA510E9C483B696DAA25