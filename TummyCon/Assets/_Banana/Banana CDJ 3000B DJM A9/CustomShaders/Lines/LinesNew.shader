// Upgrade NOTE: upgraded instancing buffer 'BananaLinesCDJ3000New' to new syntax.

// Made with Amplify Shader Editor v1.9.9.12
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/LinesCDJ3000New"
{
	Properties
	{
		_LineBot( "LineBot", Float ) = 0.6
		_ThirdColor( "ThirdColor ", Color ) = ( 0, 1, 0.04350829, 0 )
		_SecondColor( "SecondColor", Color ) = ( 0.9539189, 1, 0, 0 )
		_FIrstColor( "FIrstColor", Color ) = ( 1, 0, 0, 0 )
		_LineTop( "LineTop", Float ) = 0.79
		_PIxalateLines( "PIxalate - Lines", Vector ) = ( 4, 50, 0, 0 )
		_TextureSample0( "Texture Sample 0", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
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
		#define ASE_VERSION 19912
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv3_texcoord3;
			float2 uv_texcoord;
		};

		uniform float4 _FIrstColor;
		uniform float4 _SecondColor;
		uniform float4 _ThirdColor;
		uniform sampler2D _TextureSample0;

		UNITY_INSTANCING_BUFFER_START(BananaLinesCDJ3000New)
			UNITY_DEFINE_INSTANCED_PROP(float2, _PIxalateLines)
#define _PIxalateLines_arr BananaLinesCDJ3000New
			UNITY_DEFINE_INSTANCED_PROP(float, _LineBot)
#define _LineBot_arr BananaLinesCDJ3000New
			UNITY_DEFINE_INSTANCED_PROP(float, _LineTop)
#define _LineTop_arr BananaLinesCDJ3000New
		UNITY_INSTANCING_BUFFER_END(BananaLinesCDJ3000New)


		inline float AudioLinkLerp2_g14( float Sample )
		{
			return AudioLinkLerp( ALPASS_AUTOCORRELATOR + float2( Sample * 128., 0 ) ).g;;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float _LineTop_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineTop_arr, _LineTop);
			float temp_output_56_0 = step( i.uv3_texcoord3.y , _LineTop_Instance );
			float _LineBot_Instance = UNITY_ACCESS_INSTANCED_PROP(_LineBot_arr, _LineBot);
			float temp_output_55_0 = step( i.uv3_texcoord3.y , _LineBot_Instance );
			float4 temp_output_47_0 = ( ( ( 1.0 - temp_output_56_0 ) * _FIrstColor ) + ( ( temp_output_56_0 * ( 1.0 - temp_output_55_0 ) ) * _SecondColor ) + ( temp_output_55_0 * _ThirdColor ) );
			float2 _PIxalateLines_Instance = UNITY_ACCESS_INSTANCED_PROP(_PIxalateLines_arr, _PIxalateLines);
			half2 pixelateduv33 = floor( i.uv3_texcoord3 * float2( _PIxalateLines_Instance.x, _PIxalateLines_Instance.y ) + float2( 0,0 ) ) / float2( _PIxalateLines_Instance.x, _PIxalateLines_Instance.y );
			float2 break35 = pixelateduv33;
			float Sample2_g14 = saturate( break35.x );
			float localAudioLinkLerp2_g14 = AudioLinkLerp2_g14( Sample2_g14 );
			float temp_output_40_0 = ( localAudioLinkLerp2_g14 * 0.5 );
			o.Emission = ( ( ( temp_output_47_0 * 0.005 ) + ( ( temp_output_47_0 * step( break35.y , ( max( temp_output_40_0, 0 ) + max( -temp_output_40_0, 0.0 ) ) ) ) * 4 ) ) * tex2D( _TextureSample0, i.uv_texcoord ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19912
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":64,"pos":[-2779.754,156.2222],"params":["Inherit","False","InstancedProperty","_LineBot","LineBot","0","0","Create","True","0","0","0","False","0","False","Object","-1","","0.6","0.6","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":62,"pos":[-2973.928,18.85065],"params":["Inherit","False","2","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":36,"pos":[-2347.754,460.2222],"params":["Inherit","False","AutoCorrelatorUncorrelated","-1","","14","7fdb22cc62063814cb854a23c9992c11","0","1","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":42,"pos":[-2235.754,732.2224],"params":["Inherit","False","Constant","_Float0","Float 0","0","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":30,"pos":[-3057.151,908.549],"params":["Inherit","False","InstancedProperty","_PIxalateLines","PIxalate - Lines","5","0","Create","True","0","0","0","False","0","False","Object","-1","","4,50","6,50","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":34,"pos":[-3100.755,604.2224],"params":["Inherit","False","2","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":55,"pos":[-2598.316,108.4467],"params":["Inherit","True","2","0","FLOAT","0","False","1","FLOAT","0.6","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.WireNode, AmplifyShaderEditor","id":26,"pos":[-2362.86,216.3132],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":63,"pos":[-2779.754,-99.77776],"params":["Inherit","False","InstancedProperty","_LineTop","LineTop","4","0","Create","True","0","0","0","False","0","False","Object","-1","","0.79","0.79","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":40,"pos":[-2043.754,604.2224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.NegateNode, AmplifyShaderEditor","id":38,"pos":[-1707.755,716.2224],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.IntNode, AmplifyShaderEditor","id":37,"pos":[-1915.754,716.2224],"params":["Inherit","False","Constant","_Int1","Int 1","0","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","False","0","0","0","1","INT","0"]}
{"type":"AmplifyShaderEditor.TFHCPixelate, AmplifyShaderEditor","id":33,"pos":[-2680.714,607.9019],"params":["Inherit","False","4","0","FLOAT2","0,0","False","1","FLOAT","4","False","2","FLOAT","50","False","3","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.WireNode, AmplifyShaderEditor","id":27,"pos":[-2178.092,232.7766],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":54,"pos":[-2363.754,-3.777781],"params":["Inherit","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":56,"pos":[-2600.7,-123.9928],"params":["Inherit","True","2","0","FLOAT","0","False","1","FLOAT","0.79","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":43,"pos":[-1707.755,588.2224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","INT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":39,"pos":[-1547.755,716.2224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":35,"pos":[-2499.946,465.1131],"params":["Inherit","False","FLOAT2","1","0","FLOAT2","0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.WireNode, AmplifyShaderEditor","id":50,"pos":[-1919.092,146.9351],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":60,"pos":[-1958.972,-590.8417],"params":["Inherit","False","Property","_FIrstColor","FIrstColor","3","0","Create","True","0","0","0","False","0","False","Object","-1","","1,0,0,0","1,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":57,"pos":[-2148.7,-52.9928],"params":["Inherit","True","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":61,"pos":[-1957.882,-415.7058],"params":["Inherit","False","Property","_SecondColor","SecondColor","2","0","Create","True","0","0","0","False","0","False","Object","-1","","0.9539189,1,0,0","1,1,1,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":53,"pos":[-2361.352,-223.6628],"params":["Inherit","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":59,"pos":[-1956.996,-241.5406],"params":["Inherit","False","Property","_ThirdColor","ThirdColor ","1","0","Create","True","0","0","0","False","0","False","Object","-1","","0,1,0.04350829,0","1,0.6766883,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":41,"pos":[-1435.754,604.2224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":49,"pos":[-1700.597,-159.5506],"params":["Inherit","True","2","2","0","FLOAT","0","False","1","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":58,"pos":[-1698.597,-578.5507],"params":["Inherit","True","2","2","0","FLOAT","0","False","1","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":52,"pos":[-1700.597,-375.5508],"params":["Inherit","True","2","2","0","FLOAT","0","False","1","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":45,"pos":[-1275.754,524.2224],"params":["Inherit","True","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":47,"pos":[-1312.653,-327.1091],"params":["Inherit","True","3","3","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","2","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":51,"pos":[-1252.801,-100.0765],"params":["Inherit","False","Constant","_Float1","Float 1","0","0","Create","True","0","0","0","False","0","False","Object","-1","","0.005","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.IntNode, AmplifyShaderEditor","id":32,"pos":[-915.4578,711.8854],"params":["Inherit","False","Constant","_Int0","Int 0","6","0","Create","True","0","0","0","False","0","False","Object","-1","","4","0","False","0","0","0","1","INT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":46,"pos":[-1019.754,412.2221],"params":["Inherit","True","2","2","0","COLOR","0,0,0,0","False","1","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":44,"pos":[-808.458,476.8852],"params":["Inherit","False","2","2","0","COLOR","0,0,0,0","False","1","INT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":73,"pos":[-1130.561,894.5673],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":48,"pos":[-1013.838,-354.1978],"params":["Inherit","True","2","2","0","COLOR","0,0,0,0","False","1","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":28,"pos":[-614.7722,396.3477],"params":["Inherit","False","2","2","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":72,"pos":[-883.5609,799.5673],"params":["Inherit","True","Property","_TextureSample0","Texture Sample 0","6","0","Create","True","0","0","0","False","0","False","","-1","27702ca4504c28344b0bc7f55f30bdcd","27702ca4504c28344b0bc7f55f30bdcd","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":71,"pos":[-329.5609,483.5673],"params":["Inherit","False","2","2","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":68,"pos":[-1399.245,508.1402],"params":["Inherit","False","FLOAT","1","0","FLOAT","0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":31,"pos":[-2645.448,917.4455],"params":["Inherit","True","Grid","-1","","15","a9240ca2be7e49e4f9fa3de380c0dbe9","0","3","5","FLOAT2","1,1","False","6","FLOAT2","0,0","False","2","FLOAT","0.9","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor","id":74,"pos":[-146.9476,454.0466],"params":["Float","False","True","-1","3","AmplifyShaderEditor.MaterialInspector","0","0","Standard","Banana/LinesCDJ3000New","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","Back","0","False","","0","False","","False","0","False","","0","False","","False","0","0","False","","0","Opaque","0.5","True","True","0","False","Opaque","","Geometry","All","12","all","True","True","True","True","0","False","","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","2","15","10","25","False","0.5","True","0","0","False","","0","False","","0","0","False","","0","False","","0","False","","0","False","","0","False","0","0,0,0,0","VertexOffset","True","False","Cylindrical","False","True","Relative","0","","-1","-1","-1","-1","0","False","0","0","False","","-1","0","False","","0","0","0","False","0.1","False","","0","False","","False","17","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT","0","False","9","FLOAT","0","False","10","FLOAT","0","False","13","FLOAT3","0,0,0","False","11","FLOAT3","0,0,0","False","12","FLOAT3","0,0,0","False","16","FLOAT4","0,0,0,0","False","14","FLOAT4","0,0,0,0","False","15","FLOAT3","0,0,0","False","0"]}
{"wire":[36,1,35,0]}
{"wire":[55,0,62,2]}
{"wire":[55,1,64,0]}
{"wire":[26,0,55,0]}
{"wire":[40,0,36,0]}
{"wire":[40,1,42,0]}
{"wire":[38,0,40,0]}
{"wire":[33,0,34,0]}
{"wire":[33,1,30,1]}
{"wire":[33,2,30,2]}
{"wire":[27,0,26,0]}
{"wire":[54,0,55,0]}
{"wire":[56,0,62,2]}
{"wire":[56,1,63,0]}
{"wire":[43,0,40,0]}
{"wire":[43,1,37,0]}
{"wire":[39,0,38,0]}
{"wire":[35,0,33,0]}
{"wire":[50,0,27,0]}
{"wire":[57,0,56,0]}
{"wire":[57,1,54,0]}
{"wire":[53,0,56,0]}
{"wire":[41,0,43,0]}
{"wire":[41,1,39,0]}
{"wire":[49,0,50,0]}
{"wire":[49,1,59,0]}
{"wire":[58,0,53,0]}
{"wire":[58,1,60,0]}
{"wire":[52,0,57,0]}
{"wire":[52,1,61,0]}
{"wire":[45,0,35,1]}
{"wire":[45,1,41,0]}
{"wire":[47,0,58,0]}
{"wire":[47,1,52,0]}
{"wire":[47,2,49,0]}
{"wire":[46,0,47,0]}
{"wire":[46,1,45,0]}
{"wire":[44,0,46,0]}
{"wire":[44,1,32,0]}
{"wire":[48,0,47,0]}
{"wire":[48,1,51,0]}
{"wire":[28,0,48,0]}
{"wire":[28,1,44,0]}
{"wire":[72,1,73,0]}
{"wire":[71,0,28,0]}
{"wire":[71,1,72,0]}
{"wire":[31,5,30,0]}
{"wire":[74,2,71,0]}
ASEEND*/
//CHKSM=DD1CA2301DC53AA592AE89018988781153ECAAFE