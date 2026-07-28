// Upgrade NOTE: upgraded instancing buffer 'BananaLinesCDJ3000' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/LinesCDJ3000"
{
	Properties
	{
		_LineBot("LineBot", Float) = 0.6
		_ThirdColor("ThirdColor ", Color) = (0,1,0.04350829,0)
		_SecondColor("SecondColor", Color) = (0.9539189,1,0,0)
		_FIrstColor("FIrstColor", Color) = (1,0,0,0)
		_LineTop("LineTop", Float) = 0.79
		_PIxalateLines("PIxalate - Lines", Vector) = (4,50,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"

			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _FIrstColor;
			uniform float4 _SecondColor;
			uniform float4 _ThirdColor;
			uniform sampler2D _TextureSample0;
			UNITY_INSTANCING_BUFFER_START(BananaLinesCDJ3000)
				UNITY_DEFINE_INSTANCED_PROP(float2, _PIxalateLines)
#define _PIxalateLines_arr BananaLinesCDJ3000
				UNITY_DEFINE_INSTANCED_PROP(float, _LineBot)
#define _LineBot_arr BananaLinesCDJ3000
				UNITY_DEFINE_INSTANCED_PROP(float, _LineTop)
#define _LineTop_arr BananaLinesCDJ3000
			UNITY_INSTANCING_BUFFER_END(BananaLinesCDJ3000)
			inline float AudioLinkLerp2_g14( float Sample )
			{
				return AudioLinkLerp( ALPASS_AUTOCORRELATOR + float2( Sample * 128., 0 ) ).g;;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord2.xy;
				o.ase_texcoord1.zw = v.ase_texcoord.xy;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord62 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float _LineTop_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineTop_arr, _LineTop);
				float temp_output_56_0 = step( texCoord62.y , _LineTop_Instance );
				float _LineBot_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineBot_arr, _LineBot);
				float temp_output_55_0 = step( texCoord62.y , _LineBot_Instance );
				float4 temp_output_47_0 = ( ( ( 1.0 - temp_output_56_0 ) * _FIrstColor ) + ( ( temp_output_56_0 * ( 1.0 - temp_output_55_0 ) ) * _SecondColor ) + ( temp_output_55_0 * _ThirdColor ) );
				float2 texCoord34 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _PIxalateLines_Instance = UNITY_ACCESS_INSTANCED_PROP(_PIxalateLines_arr, _PIxalateLines);
				float pixelWidth33 =  1.0f / _PIxalateLines_Instance.x;
				float pixelHeight33 = 1.0f / _PIxalateLines_Instance.y;
				half2 pixelateduv33 = half2((int)(texCoord34.x / pixelWidth33) * pixelWidth33, (int)(texCoord34.y / pixelHeight33) * pixelHeight33);
				float2 break35 = pixelateduv33;
				float Sample2_g14 = saturate( break35.x );
				float localAudioLinkLerp2_g14 = AudioLinkLerp2_g14( Sample2_g14 );
				float temp_output_40_0 = ( localAudioLinkLerp2_g14 * 0.5 );
				float2 texCoord73 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0 );
				
				
				finalColor = ( ( ( temp_output_47_0 * 0.005 ) + ( ( temp_output_47_0 * step( break35.y , ( max( temp_output_40_0 , (float)0 ) + max( -temp_output_40_0 , 0.0 ) ) ) ) * 4 ) ) * tex2D( _TextureSample0, texCoord73 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
0;0;1920;1019;3899.658;821.4344;2.360242;True;False
Node;AmplifyShaderEditor.Vector2Node;30;-3057.151,908.549;Inherit;False;InstancedProperty;_PIxalateLines;PIxalate - Lines;5;0;Create;True;0;0;0;False;0;False;4,50;6,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-3100.755,604.2224;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCPixelate;33;-2680.714,607.9019;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;50;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2779.754,156.2222;Inherit;False;InstancedProperty;_LineBot;LineBot;0;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-2973.928,18.85065;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;35;-2499.946,465.1131;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StepOpNode;55;-2598.316,108.4467;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-2347.754,460.2222;Inherit;False;AutoCorrelatorUncorrelated;-1;;14;7fdb22cc62063814cb854a23c9992c11;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2235.754,732.2224;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;-2362.86,216.3132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2779.754,-99.77776;Inherit;False;InstancedProperty;_LineTop;LineTop;4;0;Create;True;0;0;0;False;0;False;0.79;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2043.754,604.2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;27;-2178.092,232.7766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-2363.754,-3.777781;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;56;-2600.7,-123.9928;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.79;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;38;-1707.755,716.2224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;37;-1915.754,716.2224;Inherit;False;Constant;_Int1;Int 1;0;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.WireNode;50;-1919.092,146.9351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;-1707.755,588.2224;Inherit;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;39;-1547.755,716.2224;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;-1958.972,-590.8417;Inherit;False;Property;_FIrstColor;FIrstColor;3;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2148.7,-52.9928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;61;-1957.882,-415.7058;Inherit;False;Property;_SecondColor;SecondColor;2;0;Create;True;0;0;0;False;0;False;0.9539189,1,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;53;-2361.352,-223.6628;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;59;-1956.996,-241.5406;Inherit;False;Property;_ThirdColor;ThirdColor ;1;0;Create;True;0;0;0;False;0;False;0,1,0.04350829,0;1,0.6766883,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1700.597,-159.5506;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1435.754,604.2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1698.597,-578.5507;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1700.597,-375.5508;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;45;-1275.754,524.2224;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1312.653,-327.1091;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1252.801,-100.0765;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;32;-915.4578,711.8854;Inherit;False;Constant;_Int0;Int 0;6;0;Create;True;0;0;0;False;0;False;4;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1019.754,412.2221;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-808.458,476.8852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-1130.561,894.5673;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1013.838,-354.1978;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-614.7722,396.3477;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;72;-883.5609,799.5673;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;27702ca4504c28344b0bc7f55f30bdcd;27702ca4504c28344b0bc7f55f30bdcd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-329.5609,483.5673;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;68;-1399.245,508.1402;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;31;-2645.448,917.4455;Inherit;True;Grid;-1;;15;a9240ca2be7e49e4f9fa3de380c0dbe9;0;3;5;FLOAT2;1,1;False;6;FLOAT2;0,0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;-146.9476,454.0466;Float;False;True;-1;2;ASEMaterialInspector;100;12;Banana/LinesCDJ3000;98260b9dbbbb4b244bc27a597305f10e;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;33;0;34;0
WireConnection;33;1;30;1
WireConnection;33;2;30;2
WireConnection;35;0;33;0
WireConnection;55;0;62;2
WireConnection;55;1;64;0
WireConnection;36;1;35;0
WireConnection;26;0;55;0
WireConnection;40;0;36;0
WireConnection;40;1;42;0
WireConnection;27;0;26;0
WireConnection;54;0;55;0
WireConnection;56;0;62;2
WireConnection;56;1;63;0
WireConnection;38;0;40;0
WireConnection;50;0;27;0
WireConnection;43;0;40;0
WireConnection;43;1;37;0
WireConnection;39;0;38;0
WireConnection;57;0;56;0
WireConnection;57;1;54;0
WireConnection;53;0;56;0
WireConnection;49;0;50;0
WireConnection;49;1;59;0
WireConnection;41;0;43;0
WireConnection;41;1;39;0
WireConnection;58;0;53;0
WireConnection;58;1;60;0
WireConnection;52;0;57;0
WireConnection;52;1;61;0
WireConnection;45;0;35;1
WireConnection;45;1;41;0
WireConnection;47;0;58;0
WireConnection;47;1;52;0
WireConnection;47;2;49;0
WireConnection;46;0;47;0
WireConnection;46;1;45;0
WireConnection;44;0;46;0
WireConnection;44;1;32;0
WireConnection;48;0;47;0
WireConnection;48;1;51;0
WireConnection;28;0;48;0
WireConnection;28;1;44;0
WireConnection;72;1;73;0
WireConnection;71;0;28;0
WireConnection;71;1;72;0
WireConnection;31;5;30;0
WireConnection;6;0;71;0
ASEEND*/
//CHKSM=11089259BD5CD273E7B7BCE045BF0233BE2F2ECF
