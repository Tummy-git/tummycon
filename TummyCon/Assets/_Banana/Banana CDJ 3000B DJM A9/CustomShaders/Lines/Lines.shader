// Upgrade NOTE: upgraded instancing buffer 'BananaLinesCDJ3000' to new syntax.

// Made with Amplify Shader Editor v1.9.9.9
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/LinesCDJ3000"
{
	Properties
	{
		_LineBot( "LineBot", Float ) = 0.6
		_ThirdColor( "ThirdColor ", Color ) = ( 0, 1, 0.04350829, 0 )
		_SecondColor( "SecondColor", Color ) = ( 0.9539189, 1, 0, 0 )
		_FIrstColor( "FIrstColor", Color ) = ( 1, 0, 0, 0 )
		_LineTop( "LineTop", Float ) = 0.79
		_PIxalateLines( "PIxalate - Lines", Vector ) = ( 4, 50, 0, 0 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.5
		#pragma multi_compile_instancing
		#define ASE_VERSION 19909
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _FIrstColor;
		uniform float4 _SecondColor;
		uniform float4 _ThirdColor;

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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float _LineTop_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineTop_arr, _LineTop);
			float temp_output_56_0 = step( i.uv_texcoord.y , _LineTop_Instance );
			float _LineBot_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineBot_arr, _LineBot);
			float temp_output_55_0 = step( i.uv_texcoord.y , _LineBot_Instance );
			float4 temp_output_47_0 = ( ( ( 1.0 - temp_output_56_0 ) * _FIrstColor ) + ( ( temp_output_56_0 * ( 1.0 - temp_output_55_0 ) ) * _SecondColor ) + ( temp_output_55_0 * _ThirdColor ) );
			float2 _PIxalateLines_Instance = UNITY_ACCESS_INSTANCED_PROP(_PIxalateLines_arr, _PIxalateLines);
			half2 pixelateduv33 = floor( i.uv_texcoord * float2( _PIxalateLines_Instance.x, _PIxalateLines_Instance.y ) + float2( 0,0 ) ) / float2( _PIxalateLines_Instance.x, _PIxalateLines_Instance.y );
			float2 break35 = pixelateduv33;
			float Sample2_g14 = saturate( break35.x );
			float localAudioLinkLerp2_g14 = AudioLinkLerp2_g14( Sample2_g14 );
			float temp_output_40_0 = ( localAudioLinkLerp2_g14 * 0.5 );
			o.Emission = ( ( temp_output_47_0 * 0.005 ) + ( ( temp_output_47_0 * step( break35.y , ( max( temp_output_40_0, 0 ) + max( -temp_output_40_0, 0.0 ) ) ) ) * 4 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19909
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-2779.754,156.2222;Inherit;False;InstancedProperty;_LineBot;LineBot;0;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-2347.754,460.2222;Inherit;False;AutoCorrelatorUncorrelated;-1;;14;7fdb22cc62063814cb854a23c9992c11;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-2235.754,732.2224;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-2973.928,18.85065;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-2598.316,108.4467;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-2362.86,216.3132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;-2779.754,-99.77776;Inherit;False;InstancedProperty;_LineTop;LineTop;4;0;Create;True;0;0;0;False;0;False;0.79;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-2043.754,604.2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-1707.755,716.2224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-1915.754,716.2224;Inherit;False;Constant;_Int1;Int 1;0;0;Create;True;0;0;0;False;0;False;0;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-3100.755,604.2224;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-3057.151,908.549;Inherit;False;InstancedProperty;_PIxalateLines;PIxalate - Lines;5;0;Create;True;0;0;0;False;0;False;4,50;6,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCPixelate, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-2680.714,607.9019;Inherit;False;4;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;50;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-2178.092,232.7766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-2363.754,-3.777781;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-2600.7,-123.9928;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.79;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-1707.755,588.2224;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1547.755,716.2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-2499.946,465.1131;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1919.092,146.9351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1958.972,-590.8417;Inherit;False;Property;_FIrstColor;FIrstColor;3;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-2148.7,-52.9928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1957.882,-415.7058;Inherit;False;Property;_SecondColor;SecondColor;2;0;Create;True;0;0;0;False;0;False;0.9539189,1,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-2361.352,-223.6628;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-1956.996,-241.5406;Inherit;False;Property;_ThirdColor;ThirdColor ;1;0;Create;True;0;0;0;False;0;False;0,1,0.04350829,0;1,0.6766883,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1435.754,604.2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1700.597,-159.5506;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-1698.597,-578.5507;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-1700.597,-375.5508;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-1275.754,524.2224;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-1312.653,-327.1091;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1252.801,-100.0765;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-915.4578,711.8854;Inherit;False;Constant;_Int0;Int 0;6;0;Create;True;0;0;0;False;0;False;4;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-1019.754,412.2221;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-808.458,476.8852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-1013.838,-354.1978;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-614.7722,396.3477;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;68;-1399.245,508.1402;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;74;-146.9476,454.0466;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Banana/LinesCDJ3000;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;1;35;0
WireConnection;55;0;62;2
WireConnection;55;1;64;0
WireConnection;26;0;55;0
WireConnection;40;0;36;0
WireConnection;40;1;42;0
WireConnection;38;0;40;0
WireConnection;33;0;34;0
WireConnection;33;1;30;1
WireConnection;33;2;30;2
WireConnection;27;0;26;0
WireConnection;54;0;55;0
WireConnection;56;0;62;2
WireConnection;56;1;63;0
WireConnection;43;0;40;0
WireConnection;43;1;37;0
WireConnection;39;0;38;0
WireConnection;35;0;33;0
WireConnection;50;0;27;0
WireConnection;57;0;56;0
WireConnection;57;1;54;0
WireConnection;53;0;56;0
WireConnection;41;0;43;0
WireConnection;41;1;39;0
WireConnection;49;0;50;0
WireConnection;49;1;59;0
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
WireConnection;74;2;28;0
ASEEND*/
//CHKSM=F6290EB092D64AF8EF22CE456F2F53BB5F437DA0