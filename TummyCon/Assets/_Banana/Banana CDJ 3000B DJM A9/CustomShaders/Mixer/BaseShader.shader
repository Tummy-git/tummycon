// Made with Amplify Shader Editor v1.9.9.9
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/LightShaderL"
{
	Properties
	{
		_BaseColor( "BaseColor", 2D ) = "white" {}
		_AmbientOcclusion( "AmbientOcclusion", 2D ) = "white" {}
		_Roughness( "Roughness", 2D ) = "white" {}
		_RoughnessA( "RoughnessA", Range( 0, 1 ) ) = 0
		_Metallic( "Metallic", 2D ) = "white" {}
		_Emission( "Emission", 2D ) = "white" {}
		_Normal( "Normal", 2D ) = "bump" {}
		_TextureEmission( "TextureEmission", Float ) = 1
		_LightMap( "LightMap", 2D ) = "white" {}
		[ToggleUI] _ToggleLightmap( "Toggle Lightmap", Float ) = 0
		_LightMapEmission( "LightMapEmission", Float ) = 1
		_LightLightmap( "LightLightmap", 2D ) = "white" {}
		_LightEmission( "LightEmission", Float ) = 0
		_Blue( "Blue", Float ) = 1
		_White( "White", Float ) = 1
		_Red( "Red", Float ) = 1
		_Green( "Green", Float ) = 1
		_BandRed1( "BandRed", Float ) = 0
		_BandGreen1( "BandGreen", Float ) = 1
		_BandBlue1( "BandBlue", Float ) = 2
		_BandWhite1( "BandWhite", Float ) = 3
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.5
		#define ASE_VERSION 19909
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform float _LightEmission;
		uniform float _BandRed1;
		uniform sampler2D _LightLightmap;
		uniform float _BandGreen1;
		uniform float _BandBlue1;
		uniform float _Red;
		uniform float _Green;
		uniform float _Blue;
		uniform float _BandWhite1;
		uniform float _White;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _TextureEmission;
		uniform float _ToggleLightmap;
		uniform sampler2D _LightMap;
		uniform float _LightMapEmission;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _RoughnessA;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _AmbientOcclusion_ST;


		inline float AudioLinkLerp3_g190( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g182( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g180( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g188( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 _FinalNormal277 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = _FinalNormal277;
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			float4 _FinalAlbedo274 = tex2D( _BaseColor, uv_BaseColor );
			o.Albedo = _FinalAlbedo274.rgb;
			int Band3_g190 = (int)_BandRed1;
			float Delay3_g190 = 0.0;
			float localAudioLinkLerp3_g190 = AudioLinkLerp3_g190( Band3_g190 , Delay3_g190 );
			float _VarAudioLink3_g189 = ( 1.0 - localAudioLinkLerp3_g190 );
			float2 _Vector0 = float2(4,4);
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles52_g189 = _Vector0.x * _Vector0.y;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset52_g189 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g189 = 1.0f / _Vector0.y;
			// Speed of animation
			float fbspeed52_g189 = _Time[ 1 ] * 0.0;
			// UV Tiling (col and row offset)
			float2 fbtiling52_g189 = float2(fbcolsoffset52_g189, fbrowsoffset52_g189);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex52_g189 = floor( fmod( fbspeed52_g189 + 14.0, fbtotaltiles52_g189) );
			fbcurrenttileindex52_g189 += ( fbcurrenttileindex52_g189 < 0) ? fbtotaltiles52_g189 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox52_g189 = round ( fmod ( fbcurrenttileindex52_g189, _Vector0.x ) );
			// Multiply Offset X by coloffset
			float fboffsetx52_g189 = fblinearindextox52_g189 * fbcolsoffset52_g189;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy52_g189 = round( fmod( ( fbcurrenttileindex52_g189 - fblinearindextox52_g189 ) / _Vector0.x, _Vector0.y ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy52_g189 = (int)(_Vector0.y-1) - fblinearindextoy52_g189;
			// Multiply Offset Y by rowoffset
			float fboffsety52_g189 = fblinearindextoy52_g189 * fbrowsoffset52_g189;
			// UV Offset
			float2 fboffset52_g189 = float2(fboffsetx52_g189, fboffsety52_g189);
			// Flipbook UV
			float2 fbuv52_g189 = i.uv2_texcoord2 * fbtiling52_g189 + fboffset52_g189;
			// *** END Flipbook UV Animation vars ***
			int flipbookFrame52_g189 = ( ( int )fbcurrenttileindex52_g189);
			float4 color243 = IsGammaSpace() ? float4( 1, 0, 0, 0 ) : float4( 1, 0, 0, 0 );
			float4 _VarColor146_g189 = color243;
			float3 desaturateInitialColor276_g189 = ( float4( tex2D( _LightLightmap, fbuv52_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot276_g189 = dot( desaturateInitialColor276_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g189 = lerp( desaturateInitialColor276_g189, desaturateDot276_g189.xxx, 1.0 );
			float4 color288_g189 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g189 = ( float4( desaturateVar276_g189 , 0.0 ) * color288_g189 );
			float2 _Vector1 = float2(4,4);
			float fbtotaltiles66_g189 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g189 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g189 = 1.0f / _Vector1.y;
			float fbspeed66_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g189 = float2(fbcolsoffset66_g189, fbrowsoffset66_g189);
			float fbcurrenttileindex66_g189 = floor( fmod( fbspeed66_g189 + 13.0, fbtotaltiles66_g189) );
			fbcurrenttileindex66_g189 += ( fbcurrenttileindex66_g189 < 0) ? fbtotaltiles66_g189 : 0;
			float fblinearindextox66_g189 = round ( fmod ( fbcurrenttileindex66_g189, _Vector1.x ) );
			float fboffsetx66_g189 = fblinearindextox66_g189 * fbcolsoffset66_g189;
			float fblinearindextoy66_g189 = round( fmod( ( fbcurrenttileindex66_g189 - fblinearindextox66_g189 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g189 = (int)(_Vector1.y-1) - fblinearindextoy66_g189;
			float fboffsety66_g189 = fblinearindextoy66_g189 * fbrowsoffset66_g189;
			float2 fboffset66_g189 = float2(fboffsetx66_g189, fboffsety66_g189);
			float2 fbuv66_g189 = i.uv2_texcoord2 * fbtiling66_g189 + fboffset66_g189;
			int flipbookFrame66_g189 = ( ( int )fbcurrenttileindex66_g189);
			float3 desaturateInitialColor277_g189 = ( float4( tex2D( _LightLightmap, fbuv66_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot277_g189 = dot( desaturateInitialColor277_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g189 = lerp( desaturateInitialColor277_g189, desaturateDot277_g189.xxx, 1.0 );
			float4 color289_g189 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g189 = ( float4( desaturateVar277_g189 , 0.0 ) * color289_g189 );
			float4 color290_g189 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float2 _Vector2 = float2(4,4);
			float fbtotaltiles76_g189 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g189 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g189 = 1.0f / _Vector2.y;
			float fbspeed76_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g189 = float2(fbcolsoffset76_g189, fbrowsoffset76_g189);
			float fbcurrenttileindex76_g189 = floor( fmod( fbspeed76_g189 + 12.0, fbtotaltiles76_g189) );
			fbcurrenttileindex76_g189 += ( fbcurrenttileindex76_g189 < 0) ? fbtotaltiles76_g189 : 0;
			float fblinearindextox76_g189 = round ( fmod ( fbcurrenttileindex76_g189, _Vector2.x ) );
			float fboffsetx76_g189 = fblinearindextox76_g189 * fbcolsoffset76_g189;
			float fblinearindextoy76_g189 = round( fmod( ( fbcurrenttileindex76_g189 - fblinearindextox76_g189 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g189 = (int)(_Vector2.y-1) - fblinearindextoy76_g189;
			float fboffsety76_g189 = fblinearindextoy76_g189 * fbrowsoffset76_g189;
			float2 fboffset76_g189 = float2(fboffsetx76_g189, fboffsety76_g189);
			float2 fbuv76_g189 = i.uv2_texcoord2 * fbtiling76_g189 + fboffset76_g189;
			int flipbookFrame76_g189 = ( ( int )fbcurrenttileindex76_g189);
			float3 desaturateInitialColor303_g189 = ( float4( tex2D( _LightLightmap, fbuv76_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot303_g189 = dot( desaturateInitialColor303_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g189 = lerp( desaturateInitialColor303_g189, desaturateDot303_g189.xxx, 1.0 );
			float4 _VarLight384_g189 = ( color290_g189 * float4( desaturateVar303_g189 , 0.0 ) );
			float4 _FinalLight1_3223_g189 = ( ( step( _VarAudioLink3_g189 , 0.0667 ) * _VarLight157_g189 ) + ( step( _VarAudioLink3_g189 , 0.1334 ) * _VarLight270_g189 ) + ( step( _VarAudioLink3_g189 , 0.2001 ) * _VarLight384_g189 ) );
			float2 _Vector3 = float2(4,4);
			float fbtotaltiles86_g189 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g189 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g189 = 1.0f / _Vector3.y;
			float fbspeed86_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g189 = float2(fbcolsoffset86_g189, fbrowsoffset86_g189);
			float fbcurrenttileindex86_g189 = floor( fmod( fbspeed86_g189 + 11.0, fbtotaltiles86_g189) );
			fbcurrenttileindex86_g189 += ( fbcurrenttileindex86_g189 < 0) ? fbtotaltiles86_g189 : 0;
			float fblinearindextox86_g189 = round ( fmod ( fbcurrenttileindex86_g189, _Vector3.x ) );
			float fboffsetx86_g189 = fblinearindextox86_g189 * fbcolsoffset86_g189;
			float fblinearindextoy86_g189 = round( fmod( ( fbcurrenttileindex86_g189 - fblinearindextox86_g189 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g189 = (int)(_Vector3.y-1) - fblinearindextoy86_g189;
			float fboffsety86_g189 = fblinearindextoy86_g189 * fbrowsoffset86_g189;
			float2 fboffset86_g189 = float2(fboffsetx86_g189, fboffsety86_g189);
			float2 fbuv86_g189 = i.uv2_texcoord2 * fbtiling86_g189 + fboffset86_g189;
			int flipbookFrame86_g189 = ( ( int )fbcurrenttileindex86_g189);
			float3 desaturateInitialColor278_g189 = ( float4( tex2D( _LightLightmap, fbuv86_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot278_g189 = dot( desaturateInitialColor278_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g189 = lerp( desaturateInitialColor278_g189, desaturateDot278_g189.xxx, 1.0 );
			float4 color293_g189 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g189 = ( float4( desaturateVar278_g189 , 0.0 ) * color293_g189 );
			float2 _Vector4 = float2(4,4);
			float fbtotaltiles96_g189 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g189 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g189 = 1.0f / _Vector4.y;
			float fbspeed96_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g189 = float2(fbcolsoffset96_g189, fbrowsoffset96_g189);
			float fbcurrenttileindex96_g189 = floor( fmod( fbspeed96_g189 + 10.0, fbtotaltiles96_g189) );
			fbcurrenttileindex96_g189 += ( fbcurrenttileindex96_g189 < 0) ? fbtotaltiles96_g189 : 0;
			float fblinearindextox96_g189 = round ( fmod ( fbcurrenttileindex96_g189, _Vector4.x ) );
			float fboffsetx96_g189 = fblinearindextox96_g189 * fbcolsoffset96_g189;
			float fblinearindextoy96_g189 = round( fmod( ( fbcurrenttileindex96_g189 - fblinearindextox96_g189 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g189 = (int)(_Vector4.y-1) - fblinearindextoy96_g189;
			float fboffsety96_g189 = fblinearindextoy96_g189 * fbrowsoffset96_g189;
			float2 fboffset96_g189 = float2(fboffsetx96_g189, fboffsety96_g189);
			float2 fbuv96_g189 = i.uv2_texcoord2 * fbtiling96_g189 + fboffset96_g189;
			int flipbookFrame96_g189 = ( ( int )fbcurrenttileindex96_g189);
			float3 desaturateInitialColor279_g189 = ( float4( tex2D( _LightLightmap, fbuv96_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot279_g189 = dot( desaturateInitialColor279_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g189 = lerp( desaturateInitialColor279_g189, desaturateDot279_g189.xxx, 1.0 );
			float4 color292_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g189 = ( float4( desaturateVar279_g189 , 0.0 ) * color292_g189 );
			float2 _Vector5 = float2(4,4);
			float fbtotaltiles106_g189 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g189 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g189 = 1.0f / _Vector5.y;
			float fbspeed106_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g189 = float2(fbcolsoffset106_g189, fbrowsoffset106_g189);
			float fbcurrenttileindex106_g189 = floor( fmod( fbspeed106_g189 + 9.0, fbtotaltiles106_g189) );
			fbcurrenttileindex106_g189 += ( fbcurrenttileindex106_g189 < 0) ? fbtotaltiles106_g189 : 0;
			float fblinearindextox106_g189 = round ( fmod ( fbcurrenttileindex106_g189, _Vector5.x ) );
			float fboffsetx106_g189 = fblinearindextox106_g189 * fbcolsoffset106_g189;
			float fblinearindextoy106_g189 = round( fmod( ( fbcurrenttileindex106_g189 - fblinearindextox106_g189 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g189 = (int)(_Vector5.y-1) - fblinearindextoy106_g189;
			float fboffsety106_g189 = fblinearindextoy106_g189 * fbrowsoffset106_g189;
			float2 fboffset106_g189 = float2(fboffsetx106_g189, fboffsety106_g189);
			float2 fbuv106_g189 = i.uv2_texcoord2 * fbtiling106_g189 + fboffset106_g189;
			int flipbookFrame106_g189 = ( ( int )fbcurrenttileindex106_g189);
			float3 desaturateInitialColor316_g189 = ( float4( tex2D( _LightLightmap, fbuv106_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot316_g189 = dot( desaturateInitialColor316_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g189 = lerp( desaturateInitialColor316_g189, desaturateDot316_g189.xxx, 1.0 );
			float4 color291_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g189 = ( float4( desaturateVar316_g189 , 0.0 ) * color291_g189 );
			float4 _FinalLight4_6231_g189 = ( ( step( _VarAudioLink3_g189 , 0.2668 ) * _VarLight490_g189 ) + ( step( _VarAudioLink3_g189 , 0.3335 ) * _VarLight5104_g189 ) + ( step( _VarAudioLink3_g189 , 0.4002 ) * _VarLight6114_g189 ) );
			float2 _Vector6 = float2(4,4);
			float fbtotaltiles118_g189 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g189 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g189 = 1.0f / _Vector6.y;
			float fbspeed118_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g189 = float2(fbcolsoffset118_g189, fbrowsoffset118_g189);
			float fbcurrenttileindex118_g189 = floor( fmod( fbspeed118_g189 + 8.0, fbtotaltiles118_g189) );
			fbcurrenttileindex118_g189 += ( fbcurrenttileindex118_g189 < 0) ? fbtotaltiles118_g189 : 0;
			float fblinearindextox118_g189 = round ( fmod ( fbcurrenttileindex118_g189, _Vector6.x ) );
			float fboffsetx118_g189 = fblinearindextox118_g189 * fbcolsoffset118_g189;
			float fblinearindextoy118_g189 = round( fmod( ( fbcurrenttileindex118_g189 - fblinearindextox118_g189 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g189 = (int)(_Vector6.y-1) - fblinearindextoy118_g189;
			float fboffsety118_g189 = fblinearindextoy118_g189 * fbrowsoffset118_g189;
			float2 fboffset118_g189 = float2(fboffsetx118_g189, fboffsety118_g189);
			float2 fbuv118_g189 = i.uv2_texcoord2 * fbtiling118_g189 + fboffset118_g189;
			int flipbookFrame118_g189 = ( ( int )fbcurrenttileindex118_g189);
			float3 desaturateInitialColor315_g189 = ( float4( tex2D( _LightLightmap, fbuv118_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot315_g189 = dot( desaturateInitialColor315_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g189 = lerp( desaturateInitialColor315_g189, desaturateDot315_g189.xxx, 1.0 );
			float4 color294_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g189 = ( float4( desaturateVar315_g189 , 0.0 ) * color294_g189 );
			float2 _Vector7 = float2(4,4);
			float fbtotaltiles125_g189 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g189 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g189 = 1.0f / _Vector7.y;
			float fbspeed125_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g189 = float2(fbcolsoffset125_g189, fbrowsoffset125_g189);
			float fbcurrenttileindex125_g189 = floor( fmod( fbspeed125_g189 + 7.0, fbtotaltiles125_g189) );
			fbcurrenttileindex125_g189 += ( fbcurrenttileindex125_g189 < 0) ? fbtotaltiles125_g189 : 0;
			float fblinearindextox125_g189 = round ( fmod ( fbcurrenttileindex125_g189, _Vector7.x ) );
			float fboffsetx125_g189 = fblinearindextox125_g189 * fbcolsoffset125_g189;
			float fblinearindextoy125_g189 = round( fmod( ( fbcurrenttileindex125_g189 - fblinearindextox125_g189 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g189 = (int)(_Vector7.y-1) - fblinearindextoy125_g189;
			float fboffsety125_g189 = fblinearindextoy125_g189 * fbrowsoffset125_g189;
			float2 fboffset125_g189 = float2(fboffsetx125_g189, fboffsety125_g189);
			float2 fbuv125_g189 = i.uv2_texcoord2 * fbtiling125_g189 + fboffset125_g189;
			int flipbookFrame125_g189 = ( ( int )fbcurrenttileindex125_g189);
			float3 desaturateInitialColor280_g189 = ( float4( tex2D( _LightLightmap, fbuv125_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot280_g189 = dot( desaturateInitialColor280_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g189 = lerp( desaturateInitialColor280_g189, desaturateDot280_g189.xxx, 1.0 );
			float4 color295_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g189 = ( float4( desaturateVar280_g189 , 0.0 ) * color295_g189 );
			float2 _Vector8 = float2(4,4);
			float fbtotaltiles134_g189 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g189 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g189 = 1.0f / _Vector8.y;
			float fbspeed134_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g189 = float2(fbcolsoffset134_g189, fbrowsoffset134_g189);
			float fbcurrenttileindex134_g189 = floor( fmod( fbspeed134_g189 + 6.0, fbtotaltiles134_g189) );
			fbcurrenttileindex134_g189 += ( fbcurrenttileindex134_g189 < 0) ? fbtotaltiles134_g189 : 0;
			float fblinearindextox134_g189 = round ( fmod ( fbcurrenttileindex134_g189, _Vector8.x ) );
			float fboffsetx134_g189 = fblinearindextox134_g189 * fbcolsoffset134_g189;
			float fblinearindextoy134_g189 = round( fmod( ( fbcurrenttileindex134_g189 - fblinearindextox134_g189 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g189 = (int)(_Vector8.y-1) - fblinearindextoy134_g189;
			float fboffsety134_g189 = fblinearindextoy134_g189 * fbrowsoffset134_g189;
			float2 fboffset134_g189 = float2(fboffsetx134_g189, fboffsety134_g189);
			float2 fbuv134_g189 = i.uv2_texcoord2 * fbtiling134_g189 + fboffset134_g189;
			int flipbookFrame134_g189 = ( ( int )fbcurrenttileindex134_g189);
			float3 desaturateInitialColor281_g189 = ( float4( tex2D( _LightLightmap, fbuv134_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot281_g189 = dot( desaturateInitialColor281_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g189 = lerp( desaturateInitialColor281_g189, desaturateDot281_g189.xxx, 1.0 );
			float4 color296_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g189 = ( float4( desaturateVar281_g189 , 0.0 ) * color296_g189 );
			float4 _FinalLight7_9239_g189 = ( ( step( _VarAudioLink3_g189 , 0.4669 ) * _VarLight7121_g189 ) + ( step( _VarAudioLink3_g189 , 0.5336 ) * _VarLight8133_g189 ) + ( step( _VarAudioLink3_g189 , 0.6003 ) * _VarLight9142_g189 ) );
			float2 _Vector9 = float2(4,4);
			float fbtotaltiles159_g189 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g189 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g189 = 1.0f / _Vector9.y;
			float fbspeed159_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g189 = float2(fbcolsoffset159_g189, fbrowsoffset159_g189);
			float fbcurrenttileindex159_g189 = floor( fmod( fbspeed159_g189 + 5.0, fbtotaltiles159_g189) );
			fbcurrenttileindex159_g189 += ( fbcurrenttileindex159_g189 < 0) ? fbtotaltiles159_g189 : 0;
			float fblinearindextox159_g189 = round ( fmod ( fbcurrenttileindex159_g189, _Vector9.x ) );
			float fboffsetx159_g189 = fblinearindextox159_g189 * fbcolsoffset159_g189;
			float fblinearindextoy159_g189 = round( fmod( ( fbcurrenttileindex159_g189 - fblinearindextox159_g189 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g189 = (int)(_Vector9.y-1) - fblinearindextoy159_g189;
			float fboffsety159_g189 = fblinearindextoy159_g189 * fbrowsoffset159_g189;
			float2 fboffset159_g189 = float2(fboffsetx159_g189, fboffsety159_g189);
			float2 fbuv159_g189 = i.uv2_texcoord2 * fbtiling159_g189 + fboffset159_g189;
			int flipbookFrame159_g189 = ( ( int )fbcurrenttileindex159_g189);
			float3 desaturateInitialColor284_g189 = ( float4( tex2D( _LightLightmap, fbuv159_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot284_g189 = dot( desaturateInitialColor284_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g189 = lerp( desaturateInitialColor284_g189, desaturateDot284_g189.xxx, 1.0 );
			float4 color299_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g189 = ( float4( desaturateVar284_g189 , 0.0 ) * color299_g189 );
			float2 _Vector10 = float2(4,4);
			float fbtotaltiles165_g189 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g189 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g189 = 1.0f / _Vector10.y;
			float fbspeed165_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g189 = float2(fbcolsoffset165_g189, fbrowsoffset165_g189);
			float fbcurrenttileindex165_g189 = floor( fmod( fbspeed165_g189 + 4.0, fbtotaltiles165_g189) );
			fbcurrenttileindex165_g189 += ( fbcurrenttileindex165_g189 < 0) ? fbtotaltiles165_g189 : 0;
			float fblinearindextox165_g189 = round ( fmod ( fbcurrenttileindex165_g189, _Vector10.x ) );
			float fboffsetx165_g189 = fblinearindextox165_g189 * fbcolsoffset165_g189;
			float fblinearindextoy165_g189 = round( fmod( ( fbcurrenttileindex165_g189 - fblinearindextox165_g189 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g189 = (int)(_Vector10.y-1) - fblinearindextoy165_g189;
			float fboffsety165_g189 = fblinearindextoy165_g189 * fbrowsoffset165_g189;
			float2 fboffset165_g189 = float2(fboffsetx165_g189, fboffsety165_g189);
			float2 fbuv165_g189 = i.uv2_texcoord2 * fbtiling165_g189 + fboffset165_g189;
			int flipbookFrame165_g189 = ( ( int )fbcurrenttileindex165_g189);
			float3 desaturateInitialColor283_g189 = ( float4( tex2D( _LightLightmap, fbuv165_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot283_g189 = dot( desaturateInitialColor283_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g189 = lerp( desaturateInitialColor283_g189, desaturateDot283_g189.xxx, 1.0 );
			float4 color298_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g189 = ( float4( desaturateVar283_g189 , 0.0 ) * color298_g189 );
			float2 _Vector11 = float2(4,4);
			float fbtotaltiles173_g189 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g189 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g189 = 1.0f / _Vector11.y;
			float fbspeed173_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g189 = float2(fbcolsoffset173_g189, fbrowsoffset173_g189);
			float fbcurrenttileindex173_g189 = floor( fmod( fbspeed173_g189 + 3.0, fbtotaltiles173_g189) );
			fbcurrenttileindex173_g189 += ( fbcurrenttileindex173_g189 < 0) ? fbtotaltiles173_g189 : 0;
			float fblinearindextox173_g189 = round ( fmod ( fbcurrenttileindex173_g189, _Vector11.x ) );
			float fboffsetx173_g189 = fblinearindextox173_g189 * fbcolsoffset173_g189;
			float fblinearindextoy173_g189 = round( fmod( ( fbcurrenttileindex173_g189 - fblinearindextox173_g189 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g189 = (int)(_Vector11.y-1) - fblinearindextoy173_g189;
			float fboffsety173_g189 = fblinearindextoy173_g189 * fbrowsoffset173_g189;
			float2 fboffset173_g189 = float2(fboffsetx173_g189, fboffsety173_g189);
			float2 fbuv173_g189 = i.uv2_texcoord2 * fbtiling173_g189 + fboffset173_g189;
			int flipbookFrame173_g189 = ( ( int )fbcurrenttileindex173_g189);
			float3 desaturateInitialColor282_g189 = ( float4( tex2D( _LightLightmap, fbuv173_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot282_g189 = dot( desaturateInitialColor282_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g189 = lerp( desaturateInitialColor282_g189, desaturateDot282_g189.xxx, 1.0 );
			float4 color297_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g189 = ( float4( desaturateVar282_g189 , 0.0 ) * color297_g189 );
			float4 _FinalLight10_12247_g189 = ( ( step( _VarAudioLink3_g189 , 0.667 ) * _VarLight10161_g189 ) + ( step( _VarAudioLink3_g189 , 0.7337 ) * _VarLight11172_g189 ) + ( step( _VarAudioLink3_g189 , 0.8004 ) * _VarLight12180_g189 ) );
			float2 _Vector12 = float2(4,4);
			float fbtotaltiles189_g189 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g189 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g189 = 1.0f / _Vector12.y;
			float fbspeed189_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g189 = float2(fbcolsoffset189_g189, fbrowsoffset189_g189);
			float fbcurrenttileindex189_g189 = floor( fmod( fbspeed189_g189 + 2.0, fbtotaltiles189_g189) );
			fbcurrenttileindex189_g189 += ( fbcurrenttileindex189_g189 < 0) ? fbtotaltiles189_g189 : 0;
			float fblinearindextox189_g189 = round ( fmod ( fbcurrenttileindex189_g189, _Vector12.x ) );
			float fboffsetx189_g189 = fblinearindextox189_g189 * fbcolsoffset189_g189;
			float fblinearindextoy189_g189 = round( fmod( ( fbcurrenttileindex189_g189 - fblinearindextox189_g189 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g189 = (int)(_Vector12.y-1) - fblinearindextoy189_g189;
			float fboffsety189_g189 = fblinearindextoy189_g189 * fbrowsoffset189_g189;
			float2 fboffset189_g189 = float2(fboffsetx189_g189, fboffsety189_g189);
			float2 fbuv189_g189 = i.uv2_texcoord2 * fbtiling189_g189 + fboffset189_g189;
			int flipbookFrame189_g189 = ( ( int )fbcurrenttileindex189_g189);
			float3 desaturateInitialColor285_g189 = ( float4( tex2D( _LightLightmap, fbuv189_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot285_g189 = dot( desaturateInitialColor285_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g189 = lerp( desaturateInitialColor285_g189, desaturateDot285_g189.xxx, 1.0 );
			float4 color300_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g189 = ( float4( desaturateVar285_g189 , 0.0 ) * color300_g189 );
			float2 _Vector13 = float2(4,4);
			float fbtotaltiles195_g189 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g189 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g189 = 1.0f / _Vector13.y;
			float fbspeed195_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g189 = float2(fbcolsoffset195_g189, fbrowsoffset195_g189);
			float fbcurrenttileindex195_g189 = floor( fmod( fbspeed195_g189 + 1.0, fbtotaltiles195_g189) );
			fbcurrenttileindex195_g189 += ( fbcurrenttileindex195_g189 < 0) ? fbtotaltiles195_g189 : 0;
			float fblinearindextox195_g189 = round ( fmod ( fbcurrenttileindex195_g189, _Vector13.x ) );
			float fboffsetx195_g189 = fblinearindextox195_g189 * fbcolsoffset195_g189;
			float fblinearindextoy195_g189 = round( fmod( ( fbcurrenttileindex195_g189 - fblinearindextox195_g189 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g189 = (int)(_Vector13.y-1) - fblinearindextoy195_g189;
			float fboffsety195_g189 = fblinearindextoy195_g189 * fbrowsoffset195_g189;
			float2 fboffset195_g189 = float2(fboffsetx195_g189, fboffsety195_g189);
			float2 fbuv195_g189 = i.uv2_texcoord2 * fbtiling195_g189 + fboffset195_g189;
			int flipbookFrame195_g189 = ( ( int )fbcurrenttileindex195_g189);
			float3 desaturateInitialColor286_g189 = ( float4( tex2D( _LightLightmap, fbuv195_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot286_g189 = dot( desaturateInitialColor286_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g189 = lerp( desaturateInitialColor286_g189, desaturateDot286_g189.xxx, 1.0 );
			float4 color301_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g189 = ( float4( desaturateVar286_g189 , 0.0 ) * color301_g189 );
			float2 _Vector14 = float2(4,4);
			float fbtotaltiles203_g189 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g189 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g189 = 1.0f / _Vector14.y;
			float fbspeed203_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g189 = float2(fbcolsoffset203_g189, fbrowsoffset203_g189);
			float fbcurrenttileindex203_g189 = floor( fmod( fbspeed203_g189 + 0.0, fbtotaltiles203_g189) );
			fbcurrenttileindex203_g189 += ( fbcurrenttileindex203_g189 < 0) ? fbtotaltiles203_g189 : 0;
			float fblinearindextox203_g189 = round ( fmod ( fbcurrenttileindex203_g189, _Vector14.x ) );
			float fboffsetx203_g189 = fblinearindextox203_g189 * fbcolsoffset203_g189;
			float fblinearindextoy203_g189 = round( fmod( ( fbcurrenttileindex203_g189 - fblinearindextox203_g189 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g189 = (int)(_Vector14.y-1) - fblinearindextoy203_g189;
			float fboffsety203_g189 = fblinearindextoy203_g189 * fbrowsoffset203_g189;
			float2 fboffset203_g189 = float2(fboffsetx203_g189, fboffsety203_g189);
			float2 fbuv203_g189 = i.uv2_texcoord2 * fbtiling203_g189 + fboffset203_g189;
			int flipbookFrame203_g189 = ( ( int )fbcurrenttileindex203_g189);
			float3 desaturateInitialColor287_g189 = ( float4( tex2D( _LightLightmap, fbuv203_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot287_g189 = dot( desaturateInitialColor287_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g189 = lerp( desaturateInitialColor287_g189, desaturateDot287_g189.xxx, 1.0 );
			float4 color302_g189 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g189 = ( float4( desaturateVar287_g189 , 0.0 ) * color302_g189 );
			float4 _FinalLight13_15255_g189 = ( ( step( _VarAudioLink3_g189 , 0.8671 ) * _VarLight13191_g189 ) + ( step( _VarAudioLink3_g189 , 0.9338 ) * _VarLight14202_g189 ) + ( step( _VarAudioLink3_g189 , 1.0 ) * _VarLight15210_g189 ) );
			float2 _Vector15 = float2(4,4);
			float fbtotaltiles339_g189 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g189 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g189 = 1.0f / _Vector15.y;
			float fbspeed339_g189 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g189 = float2(fbcolsoffset339_g189, fbrowsoffset339_g189);
			float fbcurrenttileindex339_g189 = floor( fmod( fbspeed339_g189 + 15.0, fbtotaltiles339_g189) );
			fbcurrenttileindex339_g189 += ( fbcurrenttileindex339_g189 < 0) ? fbtotaltiles339_g189 : 0;
			float fblinearindextox339_g189 = round ( fmod ( fbcurrenttileindex339_g189, _Vector15.x ) );
			float fboffsetx339_g189 = fblinearindextox339_g189 * fbcolsoffset339_g189;
			float fblinearindextoy339_g189 = round( fmod( ( fbcurrenttileindex339_g189 - fblinearindextox339_g189 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g189 = (int)(_Vector15.y-1) - fblinearindextoy339_g189;
			float fboffsety339_g189 = fblinearindextoy339_g189 * fbrowsoffset339_g189;
			float2 fboffset339_g189 = float2(fboffsetx339_g189, fboffsety339_g189);
			float2 fbuv339_g189 = i.uv2_texcoord2 * fbtiling339_g189 + fboffset339_g189;
			int flipbookFrame339_g189 = ( ( int )fbcurrenttileindex339_g189);
			float3 desaturateInitialColor347_g189 = ( float4( tex2D( _LightLightmap, fbuv339_g189 ).rgb , 0.0 ) * _VarColor146_g189 ).xyz;
			float desaturateDot347_g189 = dot( desaturateInitialColor347_g189, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g189 = lerp( desaturateInitialColor347_g189, desaturateDot347_g189.xxx, 1.0 );
			float4 color345_g189 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g189 = ( float4( desaturateVar347_g189 , 0.0 ) * color345_g189 );
			float4 _FinalLight16356_g189 = ( step( _VarAudioLink3_g189 , 0.0667 ) * _VarLight16350_g189 );
			float4 _FinalLights262_g189 = ( _FinalLight1_3223_g189 + _FinalLight4_6231_g189 + _FinalLight7_9239_g189 + _FinalLight10_12247_g189 + _FinalLight13_15255_g189 + _FinalLight16356_g189 );
			float4 temp_output_244_0 = _FinalLights262_g189;
			int Band3_g182 = (int)_BandGreen1;
			float Delay3_g182 = 0.0;
			float localAudioLinkLerp3_g182 = AudioLinkLerp3_g182( Band3_g182 , Delay3_g182 );
			float _VarAudioLink3_g181 = ( 1.0 - localAudioLinkLerp3_g182 );
			float fbtotaltiles52_g181 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g181 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g181 = 1.0f / _Vector0.y;
			float fbspeed52_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g181 = float2(fbcolsoffset52_g181, fbrowsoffset52_g181);
			float fbcurrenttileindex52_g181 = floor( fmod( fbspeed52_g181 + 14.0, fbtotaltiles52_g181) );
			fbcurrenttileindex52_g181 += ( fbcurrenttileindex52_g181 < 0) ? fbtotaltiles52_g181 : 0;
			float fblinearindextox52_g181 = round ( fmod ( fbcurrenttileindex52_g181, _Vector0.x ) );
			float fboffsetx52_g181 = fblinearindextox52_g181 * fbcolsoffset52_g181;
			float fblinearindextoy52_g181 = round( fmod( ( fbcurrenttileindex52_g181 - fblinearindextox52_g181 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g181 = (int)(_Vector0.y-1) - fblinearindextoy52_g181;
			float fboffsety52_g181 = fblinearindextoy52_g181 * fbrowsoffset52_g181;
			float2 fboffset52_g181 = float2(fboffsetx52_g181, fboffsety52_g181);
			float2 fbuv52_g181 = i.uv2_texcoord2 * fbtiling52_g181 + fboffset52_g181;
			int flipbookFrame52_g181 = ( ( int )fbcurrenttileindex52_g181);
			float4 color236 = IsGammaSpace() ? float4( 0, 1, 0, 0 ) : float4( 0, 1, 0, 0 );
			float4 _VarColor146_g181 = color236;
			float3 desaturateInitialColor276_g181 = ( float4( tex2D( _LightLightmap, fbuv52_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot276_g181 = dot( desaturateInitialColor276_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g181 = lerp( desaturateInitialColor276_g181, desaturateDot276_g181.xxx, 1.0 );
			float4 color288_g181 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g181 = ( float4( desaturateVar276_g181 , 0.0 ) * color288_g181 );
			float fbtotaltiles66_g181 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g181 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g181 = 1.0f / _Vector1.y;
			float fbspeed66_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g181 = float2(fbcolsoffset66_g181, fbrowsoffset66_g181);
			float fbcurrenttileindex66_g181 = floor( fmod( fbspeed66_g181 + 13.0, fbtotaltiles66_g181) );
			fbcurrenttileindex66_g181 += ( fbcurrenttileindex66_g181 < 0) ? fbtotaltiles66_g181 : 0;
			float fblinearindextox66_g181 = round ( fmod ( fbcurrenttileindex66_g181, _Vector1.x ) );
			float fboffsetx66_g181 = fblinearindextox66_g181 * fbcolsoffset66_g181;
			float fblinearindextoy66_g181 = round( fmod( ( fbcurrenttileindex66_g181 - fblinearindextox66_g181 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g181 = (int)(_Vector1.y-1) - fblinearindextoy66_g181;
			float fboffsety66_g181 = fblinearindextoy66_g181 * fbrowsoffset66_g181;
			float2 fboffset66_g181 = float2(fboffsetx66_g181, fboffsety66_g181);
			float2 fbuv66_g181 = i.uv2_texcoord2 * fbtiling66_g181 + fboffset66_g181;
			int flipbookFrame66_g181 = ( ( int )fbcurrenttileindex66_g181);
			float3 desaturateInitialColor277_g181 = ( float4( tex2D( _LightLightmap, fbuv66_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot277_g181 = dot( desaturateInitialColor277_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g181 = lerp( desaturateInitialColor277_g181, desaturateDot277_g181.xxx, 1.0 );
			float4 color289_g181 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g181 = ( float4( desaturateVar277_g181 , 0.0 ) * color289_g181 );
			float4 color290_g181 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g181 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g181 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g181 = 1.0f / _Vector2.y;
			float fbspeed76_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g181 = float2(fbcolsoffset76_g181, fbrowsoffset76_g181);
			float fbcurrenttileindex76_g181 = floor( fmod( fbspeed76_g181 + 12.0, fbtotaltiles76_g181) );
			fbcurrenttileindex76_g181 += ( fbcurrenttileindex76_g181 < 0) ? fbtotaltiles76_g181 : 0;
			float fblinearindextox76_g181 = round ( fmod ( fbcurrenttileindex76_g181, _Vector2.x ) );
			float fboffsetx76_g181 = fblinearindextox76_g181 * fbcolsoffset76_g181;
			float fblinearindextoy76_g181 = round( fmod( ( fbcurrenttileindex76_g181 - fblinearindextox76_g181 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g181 = (int)(_Vector2.y-1) - fblinearindextoy76_g181;
			float fboffsety76_g181 = fblinearindextoy76_g181 * fbrowsoffset76_g181;
			float2 fboffset76_g181 = float2(fboffsetx76_g181, fboffsety76_g181);
			float2 fbuv76_g181 = i.uv2_texcoord2 * fbtiling76_g181 + fboffset76_g181;
			int flipbookFrame76_g181 = ( ( int )fbcurrenttileindex76_g181);
			float3 desaturateInitialColor303_g181 = ( float4( tex2D( _LightLightmap, fbuv76_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot303_g181 = dot( desaturateInitialColor303_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g181 = lerp( desaturateInitialColor303_g181, desaturateDot303_g181.xxx, 1.0 );
			float4 _VarLight384_g181 = ( color290_g181 * float4( desaturateVar303_g181 , 0.0 ) );
			float4 _FinalLight1_3223_g181 = ( ( step( _VarAudioLink3_g181 , 0.0667 ) * _VarLight157_g181 ) + ( step( _VarAudioLink3_g181 , 0.1334 ) * _VarLight270_g181 ) + ( step( _VarAudioLink3_g181 , 0.2001 ) * _VarLight384_g181 ) );
			float fbtotaltiles86_g181 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g181 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g181 = 1.0f / _Vector3.y;
			float fbspeed86_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g181 = float2(fbcolsoffset86_g181, fbrowsoffset86_g181);
			float fbcurrenttileindex86_g181 = floor( fmod( fbspeed86_g181 + 11.0, fbtotaltiles86_g181) );
			fbcurrenttileindex86_g181 += ( fbcurrenttileindex86_g181 < 0) ? fbtotaltiles86_g181 : 0;
			float fblinearindextox86_g181 = round ( fmod ( fbcurrenttileindex86_g181, _Vector3.x ) );
			float fboffsetx86_g181 = fblinearindextox86_g181 * fbcolsoffset86_g181;
			float fblinearindextoy86_g181 = round( fmod( ( fbcurrenttileindex86_g181 - fblinearindextox86_g181 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g181 = (int)(_Vector3.y-1) - fblinearindextoy86_g181;
			float fboffsety86_g181 = fblinearindextoy86_g181 * fbrowsoffset86_g181;
			float2 fboffset86_g181 = float2(fboffsetx86_g181, fboffsety86_g181);
			float2 fbuv86_g181 = i.uv2_texcoord2 * fbtiling86_g181 + fboffset86_g181;
			int flipbookFrame86_g181 = ( ( int )fbcurrenttileindex86_g181);
			float3 desaturateInitialColor278_g181 = ( float4( tex2D( _LightLightmap, fbuv86_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot278_g181 = dot( desaturateInitialColor278_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g181 = lerp( desaturateInitialColor278_g181, desaturateDot278_g181.xxx, 1.0 );
			float4 color293_g181 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g181 = ( float4( desaturateVar278_g181 , 0.0 ) * color293_g181 );
			float fbtotaltiles96_g181 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g181 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g181 = 1.0f / _Vector4.y;
			float fbspeed96_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g181 = float2(fbcolsoffset96_g181, fbrowsoffset96_g181);
			float fbcurrenttileindex96_g181 = floor( fmod( fbspeed96_g181 + 10.0, fbtotaltiles96_g181) );
			fbcurrenttileindex96_g181 += ( fbcurrenttileindex96_g181 < 0) ? fbtotaltiles96_g181 : 0;
			float fblinearindextox96_g181 = round ( fmod ( fbcurrenttileindex96_g181, _Vector4.x ) );
			float fboffsetx96_g181 = fblinearindextox96_g181 * fbcolsoffset96_g181;
			float fblinearindextoy96_g181 = round( fmod( ( fbcurrenttileindex96_g181 - fblinearindextox96_g181 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g181 = (int)(_Vector4.y-1) - fblinearindextoy96_g181;
			float fboffsety96_g181 = fblinearindextoy96_g181 * fbrowsoffset96_g181;
			float2 fboffset96_g181 = float2(fboffsetx96_g181, fboffsety96_g181);
			float2 fbuv96_g181 = i.uv2_texcoord2 * fbtiling96_g181 + fboffset96_g181;
			int flipbookFrame96_g181 = ( ( int )fbcurrenttileindex96_g181);
			float3 desaturateInitialColor279_g181 = ( float4( tex2D( _LightLightmap, fbuv96_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot279_g181 = dot( desaturateInitialColor279_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g181 = lerp( desaturateInitialColor279_g181, desaturateDot279_g181.xxx, 1.0 );
			float4 color292_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g181 = ( float4( desaturateVar279_g181 , 0.0 ) * color292_g181 );
			float fbtotaltiles106_g181 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g181 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g181 = 1.0f / _Vector5.y;
			float fbspeed106_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g181 = float2(fbcolsoffset106_g181, fbrowsoffset106_g181);
			float fbcurrenttileindex106_g181 = floor( fmod( fbspeed106_g181 + 9.0, fbtotaltiles106_g181) );
			fbcurrenttileindex106_g181 += ( fbcurrenttileindex106_g181 < 0) ? fbtotaltiles106_g181 : 0;
			float fblinearindextox106_g181 = round ( fmod ( fbcurrenttileindex106_g181, _Vector5.x ) );
			float fboffsetx106_g181 = fblinearindextox106_g181 * fbcolsoffset106_g181;
			float fblinearindextoy106_g181 = round( fmod( ( fbcurrenttileindex106_g181 - fblinearindextox106_g181 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g181 = (int)(_Vector5.y-1) - fblinearindextoy106_g181;
			float fboffsety106_g181 = fblinearindextoy106_g181 * fbrowsoffset106_g181;
			float2 fboffset106_g181 = float2(fboffsetx106_g181, fboffsety106_g181);
			float2 fbuv106_g181 = i.uv2_texcoord2 * fbtiling106_g181 + fboffset106_g181;
			int flipbookFrame106_g181 = ( ( int )fbcurrenttileindex106_g181);
			float3 desaturateInitialColor316_g181 = ( float4( tex2D( _LightLightmap, fbuv106_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot316_g181 = dot( desaturateInitialColor316_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g181 = lerp( desaturateInitialColor316_g181, desaturateDot316_g181.xxx, 1.0 );
			float4 color291_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g181 = ( float4( desaturateVar316_g181 , 0.0 ) * color291_g181 );
			float4 _FinalLight4_6231_g181 = ( ( step( _VarAudioLink3_g181 , 0.2668 ) * _VarLight490_g181 ) + ( step( _VarAudioLink3_g181 , 0.3335 ) * _VarLight5104_g181 ) + ( step( _VarAudioLink3_g181 , 0.4002 ) * _VarLight6114_g181 ) );
			float fbtotaltiles118_g181 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g181 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g181 = 1.0f / _Vector6.y;
			float fbspeed118_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g181 = float2(fbcolsoffset118_g181, fbrowsoffset118_g181);
			float fbcurrenttileindex118_g181 = floor( fmod( fbspeed118_g181 + 8.0, fbtotaltiles118_g181) );
			fbcurrenttileindex118_g181 += ( fbcurrenttileindex118_g181 < 0) ? fbtotaltiles118_g181 : 0;
			float fblinearindextox118_g181 = round ( fmod ( fbcurrenttileindex118_g181, _Vector6.x ) );
			float fboffsetx118_g181 = fblinearindextox118_g181 * fbcolsoffset118_g181;
			float fblinearindextoy118_g181 = round( fmod( ( fbcurrenttileindex118_g181 - fblinearindextox118_g181 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g181 = (int)(_Vector6.y-1) - fblinearindextoy118_g181;
			float fboffsety118_g181 = fblinearindextoy118_g181 * fbrowsoffset118_g181;
			float2 fboffset118_g181 = float2(fboffsetx118_g181, fboffsety118_g181);
			float2 fbuv118_g181 = i.uv2_texcoord2 * fbtiling118_g181 + fboffset118_g181;
			int flipbookFrame118_g181 = ( ( int )fbcurrenttileindex118_g181);
			float3 desaturateInitialColor315_g181 = ( float4( tex2D( _LightLightmap, fbuv118_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot315_g181 = dot( desaturateInitialColor315_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g181 = lerp( desaturateInitialColor315_g181, desaturateDot315_g181.xxx, 1.0 );
			float4 color294_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g181 = ( float4( desaturateVar315_g181 , 0.0 ) * color294_g181 );
			float fbtotaltiles125_g181 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g181 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g181 = 1.0f / _Vector7.y;
			float fbspeed125_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g181 = float2(fbcolsoffset125_g181, fbrowsoffset125_g181);
			float fbcurrenttileindex125_g181 = floor( fmod( fbspeed125_g181 + 7.0, fbtotaltiles125_g181) );
			fbcurrenttileindex125_g181 += ( fbcurrenttileindex125_g181 < 0) ? fbtotaltiles125_g181 : 0;
			float fblinearindextox125_g181 = round ( fmod ( fbcurrenttileindex125_g181, _Vector7.x ) );
			float fboffsetx125_g181 = fblinearindextox125_g181 * fbcolsoffset125_g181;
			float fblinearindextoy125_g181 = round( fmod( ( fbcurrenttileindex125_g181 - fblinearindextox125_g181 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g181 = (int)(_Vector7.y-1) - fblinearindextoy125_g181;
			float fboffsety125_g181 = fblinearindextoy125_g181 * fbrowsoffset125_g181;
			float2 fboffset125_g181 = float2(fboffsetx125_g181, fboffsety125_g181);
			float2 fbuv125_g181 = i.uv2_texcoord2 * fbtiling125_g181 + fboffset125_g181;
			int flipbookFrame125_g181 = ( ( int )fbcurrenttileindex125_g181);
			float3 desaturateInitialColor280_g181 = ( float4( tex2D( _LightLightmap, fbuv125_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot280_g181 = dot( desaturateInitialColor280_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g181 = lerp( desaturateInitialColor280_g181, desaturateDot280_g181.xxx, 1.0 );
			float4 color295_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g181 = ( float4( desaturateVar280_g181 , 0.0 ) * color295_g181 );
			float fbtotaltiles134_g181 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g181 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g181 = 1.0f / _Vector8.y;
			float fbspeed134_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g181 = float2(fbcolsoffset134_g181, fbrowsoffset134_g181);
			float fbcurrenttileindex134_g181 = floor( fmod( fbspeed134_g181 + 6.0, fbtotaltiles134_g181) );
			fbcurrenttileindex134_g181 += ( fbcurrenttileindex134_g181 < 0) ? fbtotaltiles134_g181 : 0;
			float fblinearindextox134_g181 = round ( fmod ( fbcurrenttileindex134_g181, _Vector8.x ) );
			float fboffsetx134_g181 = fblinearindextox134_g181 * fbcolsoffset134_g181;
			float fblinearindextoy134_g181 = round( fmod( ( fbcurrenttileindex134_g181 - fblinearindextox134_g181 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g181 = (int)(_Vector8.y-1) - fblinearindextoy134_g181;
			float fboffsety134_g181 = fblinearindextoy134_g181 * fbrowsoffset134_g181;
			float2 fboffset134_g181 = float2(fboffsetx134_g181, fboffsety134_g181);
			float2 fbuv134_g181 = i.uv2_texcoord2 * fbtiling134_g181 + fboffset134_g181;
			int flipbookFrame134_g181 = ( ( int )fbcurrenttileindex134_g181);
			float3 desaturateInitialColor281_g181 = ( float4( tex2D( _LightLightmap, fbuv134_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot281_g181 = dot( desaturateInitialColor281_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g181 = lerp( desaturateInitialColor281_g181, desaturateDot281_g181.xxx, 1.0 );
			float4 color296_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g181 = ( float4( desaturateVar281_g181 , 0.0 ) * color296_g181 );
			float4 _FinalLight7_9239_g181 = ( ( step( _VarAudioLink3_g181 , 0.4669 ) * _VarLight7121_g181 ) + ( step( _VarAudioLink3_g181 , 0.5336 ) * _VarLight8133_g181 ) + ( step( _VarAudioLink3_g181 , 0.6003 ) * _VarLight9142_g181 ) );
			float fbtotaltiles159_g181 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g181 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g181 = 1.0f / _Vector9.y;
			float fbspeed159_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g181 = float2(fbcolsoffset159_g181, fbrowsoffset159_g181);
			float fbcurrenttileindex159_g181 = floor( fmod( fbspeed159_g181 + 5.0, fbtotaltiles159_g181) );
			fbcurrenttileindex159_g181 += ( fbcurrenttileindex159_g181 < 0) ? fbtotaltiles159_g181 : 0;
			float fblinearindextox159_g181 = round ( fmod ( fbcurrenttileindex159_g181, _Vector9.x ) );
			float fboffsetx159_g181 = fblinearindextox159_g181 * fbcolsoffset159_g181;
			float fblinearindextoy159_g181 = round( fmod( ( fbcurrenttileindex159_g181 - fblinearindextox159_g181 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g181 = (int)(_Vector9.y-1) - fblinearindextoy159_g181;
			float fboffsety159_g181 = fblinearindextoy159_g181 * fbrowsoffset159_g181;
			float2 fboffset159_g181 = float2(fboffsetx159_g181, fboffsety159_g181);
			float2 fbuv159_g181 = i.uv2_texcoord2 * fbtiling159_g181 + fboffset159_g181;
			int flipbookFrame159_g181 = ( ( int )fbcurrenttileindex159_g181);
			float3 desaturateInitialColor284_g181 = ( float4( tex2D( _LightLightmap, fbuv159_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot284_g181 = dot( desaturateInitialColor284_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g181 = lerp( desaturateInitialColor284_g181, desaturateDot284_g181.xxx, 1.0 );
			float4 color299_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g181 = ( float4( desaturateVar284_g181 , 0.0 ) * color299_g181 );
			float fbtotaltiles165_g181 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g181 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g181 = 1.0f / _Vector10.y;
			float fbspeed165_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g181 = float2(fbcolsoffset165_g181, fbrowsoffset165_g181);
			float fbcurrenttileindex165_g181 = floor( fmod( fbspeed165_g181 + 4.0, fbtotaltiles165_g181) );
			fbcurrenttileindex165_g181 += ( fbcurrenttileindex165_g181 < 0) ? fbtotaltiles165_g181 : 0;
			float fblinearindextox165_g181 = round ( fmod ( fbcurrenttileindex165_g181, _Vector10.x ) );
			float fboffsetx165_g181 = fblinearindextox165_g181 * fbcolsoffset165_g181;
			float fblinearindextoy165_g181 = round( fmod( ( fbcurrenttileindex165_g181 - fblinearindextox165_g181 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g181 = (int)(_Vector10.y-1) - fblinearindextoy165_g181;
			float fboffsety165_g181 = fblinearindextoy165_g181 * fbrowsoffset165_g181;
			float2 fboffset165_g181 = float2(fboffsetx165_g181, fboffsety165_g181);
			float2 fbuv165_g181 = i.uv2_texcoord2 * fbtiling165_g181 + fboffset165_g181;
			int flipbookFrame165_g181 = ( ( int )fbcurrenttileindex165_g181);
			float3 desaturateInitialColor283_g181 = ( float4( tex2D( _LightLightmap, fbuv165_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot283_g181 = dot( desaturateInitialColor283_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g181 = lerp( desaturateInitialColor283_g181, desaturateDot283_g181.xxx, 1.0 );
			float4 color298_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g181 = ( float4( desaturateVar283_g181 , 0.0 ) * color298_g181 );
			float fbtotaltiles173_g181 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g181 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g181 = 1.0f / _Vector11.y;
			float fbspeed173_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g181 = float2(fbcolsoffset173_g181, fbrowsoffset173_g181);
			float fbcurrenttileindex173_g181 = floor( fmod( fbspeed173_g181 + 3.0, fbtotaltiles173_g181) );
			fbcurrenttileindex173_g181 += ( fbcurrenttileindex173_g181 < 0) ? fbtotaltiles173_g181 : 0;
			float fblinearindextox173_g181 = round ( fmod ( fbcurrenttileindex173_g181, _Vector11.x ) );
			float fboffsetx173_g181 = fblinearindextox173_g181 * fbcolsoffset173_g181;
			float fblinearindextoy173_g181 = round( fmod( ( fbcurrenttileindex173_g181 - fblinearindextox173_g181 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g181 = (int)(_Vector11.y-1) - fblinearindextoy173_g181;
			float fboffsety173_g181 = fblinearindextoy173_g181 * fbrowsoffset173_g181;
			float2 fboffset173_g181 = float2(fboffsetx173_g181, fboffsety173_g181);
			float2 fbuv173_g181 = i.uv2_texcoord2 * fbtiling173_g181 + fboffset173_g181;
			int flipbookFrame173_g181 = ( ( int )fbcurrenttileindex173_g181);
			float3 desaturateInitialColor282_g181 = ( float4( tex2D( _LightLightmap, fbuv173_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot282_g181 = dot( desaturateInitialColor282_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g181 = lerp( desaturateInitialColor282_g181, desaturateDot282_g181.xxx, 1.0 );
			float4 color297_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g181 = ( float4( desaturateVar282_g181 , 0.0 ) * color297_g181 );
			float4 _FinalLight10_12247_g181 = ( ( step( _VarAudioLink3_g181 , 0.667 ) * _VarLight10161_g181 ) + ( step( _VarAudioLink3_g181 , 0.7337 ) * _VarLight11172_g181 ) + ( step( _VarAudioLink3_g181 , 0.8004 ) * _VarLight12180_g181 ) );
			float fbtotaltiles189_g181 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g181 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g181 = 1.0f / _Vector12.y;
			float fbspeed189_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g181 = float2(fbcolsoffset189_g181, fbrowsoffset189_g181);
			float fbcurrenttileindex189_g181 = floor( fmod( fbspeed189_g181 + 2.0, fbtotaltiles189_g181) );
			fbcurrenttileindex189_g181 += ( fbcurrenttileindex189_g181 < 0) ? fbtotaltiles189_g181 : 0;
			float fblinearindextox189_g181 = round ( fmod ( fbcurrenttileindex189_g181, _Vector12.x ) );
			float fboffsetx189_g181 = fblinearindextox189_g181 * fbcolsoffset189_g181;
			float fblinearindextoy189_g181 = round( fmod( ( fbcurrenttileindex189_g181 - fblinearindextox189_g181 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g181 = (int)(_Vector12.y-1) - fblinearindextoy189_g181;
			float fboffsety189_g181 = fblinearindextoy189_g181 * fbrowsoffset189_g181;
			float2 fboffset189_g181 = float2(fboffsetx189_g181, fboffsety189_g181);
			float2 fbuv189_g181 = i.uv2_texcoord2 * fbtiling189_g181 + fboffset189_g181;
			int flipbookFrame189_g181 = ( ( int )fbcurrenttileindex189_g181);
			float3 desaturateInitialColor285_g181 = ( float4( tex2D( _LightLightmap, fbuv189_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot285_g181 = dot( desaturateInitialColor285_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g181 = lerp( desaturateInitialColor285_g181, desaturateDot285_g181.xxx, 1.0 );
			float4 color300_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g181 = ( float4( desaturateVar285_g181 , 0.0 ) * color300_g181 );
			float fbtotaltiles195_g181 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g181 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g181 = 1.0f / _Vector13.y;
			float fbspeed195_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g181 = float2(fbcolsoffset195_g181, fbrowsoffset195_g181);
			float fbcurrenttileindex195_g181 = floor( fmod( fbspeed195_g181 + 1.0, fbtotaltiles195_g181) );
			fbcurrenttileindex195_g181 += ( fbcurrenttileindex195_g181 < 0) ? fbtotaltiles195_g181 : 0;
			float fblinearindextox195_g181 = round ( fmod ( fbcurrenttileindex195_g181, _Vector13.x ) );
			float fboffsetx195_g181 = fblinearindextox195_g181 * fbcolsoffset195_g181;
			float fblinearindextoy195_g181 = round( fmod( ( fbcurrenttileindex195_g181 - fblinearindextox195_g181 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g181 = (int)(_Vector13.y-1) - fblinearindextoy195_g181;
			float fboffsety195_g181 = fblinearindextoy195_g181 * fbrowsoffset195_g181;
			float2 fboffset195_g181 = float2(fboffsetx195_g181, fboffsety195_g181);
			float2 fbuv195_g181 = i.uv2_texcoord2 * fbtiling195_g181 + fboffset195_g181;
			int flipbookFrame195_g181 = ( ( int )fbcurrenttileindex195_g181);
			float3 desaturateInitialColor286_g181 = ( float4( tex2D( _LightLightmap, fbuv195_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot286_g181 = dot( desaturateInitialColor286_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g181 = lerp( desaturateInitialColor286_g181, desaturateDot286_g181.xxx, 1.0 );
			float4 color301_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g181 = ( float4( desaturateVar286_g181 , 0.0 ) * color301_g181 );
			float fbtotaltiles203_g181 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g181 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g181 = 1.0f / _Vector14.y;
			float fbspeed203_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g181 = float2(fbcolsoffset203_g181, fbrowsoffset203_g181);
			float fbcurrenttileindex203_g181 = floor( fmod( fbspeed203_g181 + 0.0, fbtotaltiles203_g181) );
			fbcurrenttileindex203_g181 += ( fbcurrenttileindex203_g181 < 0) ? fbtotaltiles203_g181 : 0;
			float fblinearindextox203_g181 = round ( fmod ( fbcurrenttileindex203_g181, _Vector14.x ) );
			float fboffsetx203_g181 = fblinearindextox203_g181 * fbcolsoffset203_g181;
			float fblinearindextoy203_g181 = round( fmod( ( fbcurrenttileindex203_g181 - fblinearindextox203_g181 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g181 = (int)(_Vector14.y-1) - fblinearindextoy203_g181;
			float fboffsety203_g181 = fblinearindextoy203_g181 * fbrowsoffset203_g181;
			float2 fboffset203_g181 = float2(fboffsetx203_g181, fboffsety203_g181);
			float2 fbuv203_g181 = i.uv2_texcoord2 * fbtiling203_g181 + fboffset203_g181;
			int flipbookFrame203_g181 = ( ( int )fbcurrenttileindex203_g181);
			float3 desaturateInitialColor287_g181 = ( float4( tex2D( _LightLightmap, fbuv203_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot287_g181 = dot( desaturateInitialColor287_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g181 = lerp( desaturateInitialColor287_g181, desaturateDot287_g181.xxx, 1.0 );
			float4 color302_g181 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g181 = ( float4( desaturateVar287_g181 , 0.0 ) * color302_g181 );
			float4 _FinalLight13_15255_g181 = ( ( step( _VarAudioLink3_g181 , 0.8671 ) * _VarLight13191_g181 ) + ( step( _VarAudioLink3_g181 , 0.9338 ) * _VarLight14202_g181 ) + ( step( _VarAudioLink3_g181 , 1.0 ) * _VarLight15210_g181 ) );
			float fbtotaltiles339_g181 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g181 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g181 = 1.0f / _Vector15.y;
			float fbspeed339_g181 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g181 = float2(fbcolsoffset339_g181, fbrowsoffset339_g181);
			float fbcurrenttileindex339_g181 = floor( fmod( fbspeed339_g181 + 15.0, fbtotaltiles339_g181) );
			fbcurrenttileindex339_g181 += ( fbcurrenttileindex339_g181 < 0) ? fbtotaltiles339_g181 : 0;
			float fblinearindextox339_g181 = round ( fmod ( fbcurrenttileindex339_g181, _Vector15.x ) );
			float fboffsetx339_g181 = fblinearindextox339_g181 * fbcolsoffset339_g181;
			float fblinearindextoy339_g181 = round( fmod( ( fbcurrenttileindex339_g181 - fblinearindextox339_g181 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g181 = (int)(_Vector15.y-1) - fblinearindextoy339_g181;
			float fboffsety339_g181 = fblinearindextoy339_g181 * fbrowsoffset339_g181;
			float2 fboffset339_g181 = float2(fboffsetx339_g181, fboffsety339_g181);
			float2 fbuv339_g181 = i.uv2_texcoord2 * fbtiling339_g181 + fboffset339_g181;
			int flipbookFrame339_g181 = ( ( int )fbcurrenttileindex339_g181);
			float3 desaturateInitialColor347_g181 = ( float4( tex2D( _LightLightmap, fbuv339_g181 ).rgb , 0.0 ) * _VarColor146_g181 ).xyz;
			float desaturateDot347_g181 = dot( desaturateInitialColor347_g181, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g181 = lerp( desaturateInitialColor347_g181, desaturateDot347_g181.xxx, 1.0 );
			float4 color345_g181 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g181 = ( float4( desaturateVar347_g181 , 0.0 ) * color345_g181 );
			float4 _FinalLight16356_g181 = ( step( _VarAudioLink3_g181 , 0.0667 ) * _VarLight16350_g181 );
			float4 _FinalLights262_g181 = ( _FinalLight1_3223_g181 + _FinalLight4_6231_g181 + _FinalLight7_9239_g181 + _FinalLight10_12247_g181 + _FinalLight13_15255_g181 + _FinalLight16356_g181 );
			float4 temp_output_238_0 = _FinalLights262_g181;
			int Band3_g180 = (int)_BandBlue1;
			float Delay3_g180 = 0.0;
			float localAudioLinkLerp3_g180 = AudioLinkLerp3_g180( Band3_g180 , Delay3_g180 );
			float _VarAudioLink3_g179 = ( 1.0 - localAudioLinkLerp3_g180 );
			float fbtotaltiles52_g179 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g179 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g179 = 1.0f / _Vector0.y;
			float fbspeed52_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g179 = float2(fbcolsoffset52_g179, fbrowsoffset52_g179);
			float fbcurrenttileindex52_g179 = floor( fmod( fbspeed52_g179 + 14.0, fbtotaltiles52_g179) );
			fbcurrenttileindex52_g179 += ( fbcurrenttileindex52_g179 < 0) ? fbtotaltiles52_g179 : 0;
			float fblinearindextox52_g179 = round ( fmod ( fbcurrenttileindex52_g179, _Vector0.x ) );
			float fboffsetx52_g179 = fblinearindextox52_g179 * fbcolsoffset52_g179;
			float fblinearindextoy52_g179 = round( fmod( ( fbcurrenttileindex52_g179 - fblinearindextox52_g179 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g179 = (int)(_Vector0.y-1) - fblinearindextoy52_g179;
			float fboffsety52_g179 = fblinearindextoy52_g179 * fbrowsoffset52_g179;
			float2 fboffset52_g179 = float2(fboffsetx52_g179, fboffsety52_g179);
			float2 fbuv52_g179 = i.uv2_texcoord2 * fbtiling52_g179 + fboffset52_g179;
			int flipbookFrame52_g179 = ( ( int )fbcurrenttileindex52_g179);
			float4 color234 = IsGammaSpace() ? float4( 0, 0, 1, 0 ) : float4( 0, 0, 1, 0 );
			float4 _VarColor146_g179 = color234;
			float3 desaturateInitialColor276_g179 = ( float4( tex2D( _LightLightmap, fbuv52_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot276_g179 = dot( desaturateInitialColor276_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g179 = lerp( desaturateInitialColor276_g179, desaturateDot276_g179.xxx, 1.0 );
			float4 color288_g179 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g179 = ( float4( desaturateVar276_g179 , 0.0 ) * color288_g179 );
			float fbtotaltiles66_g179 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g179 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g179 = 1.0f / _Vector1.y;
			float fbspeed66_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g179 = float2(fbcolsoffset66_g179, fbrowsoffset66_g179);
			float fbcurrenttileindex66_g179 = floor( fmod( fbspeed66_g179 + 13.0, fbtotaltiles66_g179) );
			fbcurrenttileindex66_g179 += ( fbcurrenttileindex66_g179 < 0) ? fbtotaltiles66_g179 : 0;
			float fblinearindextox66_g179 = round ( fmod ( fbcurrenttileindex66_g179, _Vector1.x ) );
			float fboffsetx66_g179 = fblinearindextox66_g179 * fbcolsoffset66_g179;
			float fblinearindextoy66_g179 = round( fmod( ( fbcurrenttileindex66_g179 - fblinearindextox66_g179 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g179 = (int)(_Vector1.y-1) - fblinearindextoy66_g179;
			float fboffsety66_g179 = fblinearindextoy66_g179 * fbrowsoffset66_g179;
			float2 fboffset66_g179 = float2(fboffsetx66_g179, fboffsety66_g179);
			float2 fbuv66_g179 = i.uv2_texcoord2 * fbtiling66_g179 + fboffset66_g179;
			int flipbookFrame66_g179 = ( ( int )fbcurrenttileindex66_g179);
			float3 desaturateInitialColor277_g179 = ( float4( tex2D( _LightLightmap, fbuv66_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot277_g179 = dot( desaturateInitialColor277_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g179 = lerp( desaturateInitialColor277_g179, desaturateDot277_g179.xxx, 1.0 );
			float4 color289_g179 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g179 = ( float4( desaturateVar277_g179 , 0.0 ) * color289_g179 );
			float4 color290_g179 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g179 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g179 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g179 = 1.0f / _Vector2.y;
			float fbspeed76_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g179 = float2(fbcolsoffset76_g179, fbrowsoffset76_g179);
			float fbcurrenttileindex76_g179 = floor( fmod( fbspeed76_g179 + 12.0, fbtotaltiles76_g179) );
			fbcurrenttileindex76_g179 += ( fbcurrenttileindex76_g179 < 0) ? fbtotaltiles76_g179 : 0;
			float fblinearindextox76_g179 = round ( fmod ( fbcurrenttileindex76_g179, _Vector2.x ) );
			float fboffsetx76_g179 = fblinearindextox76_g179 * fbcolsoffset76_g179;
			float fblinearindextoy76_g179 = round( fmod( ( fbcurrenttileindex76_g179 - fblinearindextox76_g179 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g179 = (int)(_Vector2.y-1) - fblinearindextoy76_g179;
			float fboffsety76_g179 = fblinearindextoy76_g179 * fbrowsoffset76_g179;
			float2 fboffset76_g179 = float2(fboffsetx76_g179, fboffsety76_g179);
			float2 fbuv76_g179 = i.uv2_texcoord2 * fbtiling76_g179 + fboffset76_g179;
			int flipbookFrame76_g179 = ( ( int )fbcurrenttileindex76_g179);
			float3 desaturateInitialColor303_g179 = ( float4( tex2D( _LightLightmap, fbuv76_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot303_g179 = dot( desaturateInitialColor303_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g179 = lerp( desaturateInitialColor303_g179, desaturateDot303_g179.xxx, 1.0 );
			float4 _VarLight384_g179 = ( color290_g179 * float4( desaturateVar303_g179 , 0.0 ) );
			float4 _FinalLight1_3223_g179 = ( ( step( _VarAudioLink3_g179 , 0.0667 ) * _VarLight157_g179 ) + ( step( _VarAudioLink3_g179 , 0.1334 ) * _VarLight270_g179 ) + ( step( _VarAudioLink3_g179 , 0.2001 ) * _VarLight384_g179 ) );
			float fbtotaltiles86_g179 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g179 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g179 = 1.0f / _Vector3.y;
			float fbspeed86_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g179 = float2(fbcolsoffset86_g179, fbrowsoffset86_g179);
			float fbcurrenttileindex86_g179 = floor( fmod( fbspeed86_g179 + 11.0, fbtotaltiles86_g179) );
			fbcurrenttileindex86_g179 += ( fbcurrenttileindex86_g179 < 0) ? fbtotaltiles86_g179 : 0;
			float fblinearindextox86_g179 = round ( fmod ( fbcurrenttileindex86_g179, _Vector3.x ) );
			float fboffsetx86_g179 = fblinearindextox86_g179 * fbcolsoffset86_g179;
			float fblinearindextoy86_g179 = round( fmod( ( fbcurrenttileindex86_g179 - fblinearindextox86_g179 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g179 = (int)(_Vector3.y-1) - fblinearindextoy86_g179;
			float fboffsety86_g179 = fblinearindextoy86_g179 * fbrowsoffset86_g179;
			float2 fboffset86_g179 = float2(fboffsetx86_g179, fboffsety86_g179);
			float2 fbuv86_g179 = i.uv2_texcoord2 * fbtiling86_g179 + fboffset86_g179;
			int flipbookFrame86_g179 = ( ( int )fbcurrenttileindex86_g179);
			float3 desaturateInitialColor278_g179 = ( float4( tex2D( _LightLightmap, fbuv86_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot278_g179 = dot( desaturateInitialColor278_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g179 = lerp( desaturateInitialColor278_g179, desaturateDot278_g179.xxx, 1.0 );
			float4 color293_g179 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g179 = ( float4( desaturateVar278_g179 , 0.0 ) * color293_g179 );
			float fbtotaltiles96_g179 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g179 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g179 = 1.0f / _Vector4.y;
			float fbspeed96_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g179 = float2(fbcolsoffset96_g179, fbrowsoffset96_g179);
			float fbcurrenttileindex96_g179 = floor( fmod( fbspeed96_g179 + 10.0, fbtotaltiles96_g179) );
			fbcurrenttileindex96_g179 += ( fbcurrenttileindex96_g179 < 0) ? fbtotaltiles96_g179 : 0;
			float fblinearindextox96_g179 = round ( fmod ( fbcurrenttileindex96_g179, _Vector4.x ) );
			float fboffsetx96_g179 = fblinearindextox96_g179 * fbcolsoffset96_g179;
			float fblinearindextoy96_g179 = round( fmod( ( fbcurrenttileindex96_g179 - fblinearindextox96_g179 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g179 = (int)(_Vector4.y-1) - fblinearindextoy96_g179;
			float fboffsety96_g179 = fblinearindextoy96_g179 * fbrowsoffset96_g179;
			float2 fboffset96_g179 = float2(fboffsetx96_g179, fboffsety96_g179);
			float2 fbuv96_g179 = i.uv2_texcoord2 * fbtiling96_g179 + fboffset96_g179;
			int flipbookFrame96_g179 = ( ( int )fbcurrenttileindex96_g179);
			float3 desaturateInitialColor279_g179 = ( float4( tex2D( _LightLightmap, fbuv96_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot279_g179 = dot( desaturateInitialColor279_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g179 = lerp( desaturateInitialColor279_g179, desaturateDot279_g179.xxx, 1.0 );
			float4 color292_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g179 = ( float4( desaturateVar279_g179 , 0.0 ) * color292_g179 );
			float fbtotaltiles106_g179 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g179 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g179 = 1.0f / _Vector5.y;
			float fbspeed106_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g179 = float2(fbcolsoffset106_g179, fbrowsoffset106_g179);
			float fbcurrenttileindex106_g179 = floor( fmod( fbspeed106_g179 + 9.0, fbtotaltiles106_g179) );
			fbcurrenttileindex106_g179 += ( fbcurrenttileindex106_g179 < 0) ? fbtotaltiles106_g179 : 0;
			float fblinearindextox106_g179 = round ( fmod ( fbcurrenttileindex106_g179, _Vector5.x ) );
			float fboffsetx106_g179 = fblinearindextox106_g179 * fbcolsoffset106_g179;
			float fblinearindextoy106_g179 = round( fmod( ( fbcurrenttileindex106_g179 - fblinearindextox106_g179 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g179 = (int)(_Vector5.y-1) - fblinearindextoy106_g179;
			float fboffsety106_g179 = fblinearindextoy106_g179 * fbrowsoffset106_g179;
			float2 fboffset106_g179 = float2(fboffsetx106_g179, fboffsety106_g179);
			float2 fbuv106_g179 = i.uv2_texcoord2 * fbtiling106_g179 + fboffset106_g179;
			int flipbookFrame106_g179 = ( ( int )fbcurrenttileindex106_g179);
			float3 desaturateInitialColor316_g179 = ( float4( tex2D( _LightLightmap, fbuv106_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot316_g179 = dot( desaturateInitialColor316_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g179 = lerp( desaturateInitialColor316_g179, desaturateDot316_g179.xxx, 1.0 );
			float4 color291_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g179 = ( float4( desaturateVar316_g179 , 0.0 ) * color291_g179 );
			float4 _FinalLight4_6231_g179 = ( ( step( _VarAudioLink3_g179 , 0.2668 ) * _VarLight490_g179 ) + ( step( _VarAudioLink3_g179 , 0.3335 ) * _VarLight5104_g179 ) + ( step( _VarAudioLink3_g179 , 0.4002 ) * _VarLight6114_g179 ) );
			float fbtotaltiles118_g179 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g179 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g179 = 1.0f / _Vector6.y;
			float fbspeed118_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g179 = float2(fbcolsoffset118_g179, fbrowsoffset118_g179);
			float fbcurrenttileindex118_g179 = floor( fmod( fbspeed118_g179 + 8.0, fbtotaltiles118_g179) );
			fbcurrenttileindex118_g179 += ( fbcurrenttileindex118_g179 < 0) ? fbtotaltiles118_g179 : 0;
			float fblinearindextox118_g179 = round ( fmod ( fbcurrenttileindex118_g179, _Vector6.x ) );
			float fboffsetx118_g179 = fblinearindextox118_g179 * fbcolsoffset118_g179;
			float fblinearindextoy118_g179 = round( fmod( ( fbcurrenttileindex118_g179 - fblinearindextox118_g179 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g179 = (int)(_Vector6.y-1) - fblinearindextoy118_g179;
			float fboffsety118_g179 = fblinearindextoy118_g179 * fbrowsoffset118_g179;
			float2 fboffset118_g179 = float2(fboffsetx118_g179, fboffsety118_g179);
			float2 fbuv118_g179 = i.uv2_texcoord2 * fbtiling118_g179 + fboffset118_g179;
			int flipbookFrame118_g179 = ( ( int )fbcurrenttileindex118_g179);
			float3 desaturateInitialColor315_g179 = ( float4( tex2D( _LightLightmap, fbuv118_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot315_g179 = dot( desaturateInitialColor315_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g179 = lerp( desaturateInitialColor315_g179, desaturateDot315_g179.xxx, 1.0 );
			float4 color294_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g179 = ( float4( desaturateVar315_g179 , 0.0 ) * color294_g179 );
			float fbtotaltiles125_g179 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g179 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g179 = 1.0f / _Vector7.y;
			float fbspeed125_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g179 = float2(fbcolsoffset125_g179, fbrowsoffset125_g179);
			float fbcurrenttileindex125_g179 = floor( fmod( fbspeed125_g179 + 7.0, fbtotaltiles125_g179) );
			fbcurrenttileindex125_g179 += ( fbcurrenttileindex125_g179 < 0) ? fbtotaltiles125_g179 : 0;
			float fblinearindextox125_g179 = round ( fmod ( fbcurrenttileindex125_g179, _Vector7.x ) );
			float fboffsetx125_g179 = fblinearindextox125_g179 * fbcolsoffset125_g179;
			float fblinearindextoy125_g179 = round( fmod( ( fbcurrenttileindex125_g179 - fblinearindextox125_g179 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g179 = (int)(_Vector7.y-1) - fblinearindextoy125_g179;
			float fboffsety125_g179 = fblinearindextoy125_g179 * fbrowsoffset125_g179;
			float2 fboffset125_g179 = float2(fboffsetx125_g179, fboffsety125_g179);
			float2 fbuv125_g179 = i.uv2_texcoord2 * fbtiling125_g179 + fboffset125_g179;
			int flipbookFrame125_g179 = ( ( int )fbcurrenttileindex125_g179);
			float3 desaturateInitialColor280_g179 = ( float4( tex2D( _LightLightmap, fbuv125_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot280_g179 = dot( desaturateInitialColor280_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g179 = lerp( desaturateInitialColor280_g179, desaturateDot280_g179.xxx, 1.0 );
			float4 color295_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g179 = ( float4( desaturateVar280_g179 , 0.0 ) * color295_g179 );
			float fbtotaltiles134_g179 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g179 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g179 = 1.0f / _Vector8.y;
			float fbspeed134_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g179 = float2(fbcolsoffset134_g179, fbrowsoffset134_g179);
			float fbcurrenttileindex134_g179 = floor( fmod( fbspeed134_g179 + 6.0, fbtotaltiles134_g179) );
			fbcurrenttileindex134_g179 += ( fbcurrenttileindex134_g179 < 0) ? fbtotaltiles134_g179 : 0;
			float fblinearindextox134_g179 = round ( fmod ( fbcurrenttileindex134_g179, _Vector8.x ) );
			float fboffsetx134_g179 = fblinearindextox134_g179 * fbcolsoffset134_g179;
			float fblinearindextoy134_g179 = round( fmod( ( fbcurrenttileindex134_g179 - fblinearindextox134_g179 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g179 = (int)(_Vector8.y-1) - fblinearindextoy134_g179;
			float fboffsety134_g179 = fblinearindextoy134_g179 * fbrowsoffset134_g179;
			float2 fboffset134_g179 = float2(fboffsetx134_g179, fboffsety134_g179);
			float2 fbuv134_g179 = i.uv2_texcoord2 * fbtiling134_g179 + fboffset134_g179;
			int flipbookFrame134_g179 = ( ( int )fbcurrenttileindex134_g179);
			float3 desaturateInitialColor281_g179 = ( float4( tex2D( _LightLightmap, fbuv134_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot281_g179 = dot( desaturateInitialColor281_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g179 = lerp( desaturateInitialColor281_g179, desaturateDot281_g179.xxx, 1.0 );
			float4 color296_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g179 = ( float4( desaturateVar281_g179 , 0.0 ) * color296_g179 );
			float4 _FinalLight7_9239_g179 = ( ( step( _VarAudioLink3_g179 , 0.4669 ) * _VarLight7121_g179 ) + ( step( _VarAudioLink3_g179 , 0.5336 ) * _VarLight8133_g179 ) + ( step( _VarAudioLink3_g179 , 0.6003 ) * _VarLight9142_g179 ) );
			float fbtotaltiles159_g179 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g179 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g179 = 1.0f / _Vector9.y;
			float fbspeed159_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g179 = float2(fbcolsoffset159_g179, fbrowsoffset159_g179);
			float fbcurrenttileindex159_g179 = floor( fmod( fbspeed159_g179 + 5.0, fbtotaltiles159_g179) );
			fbcurrenttileindex159_g179 += ( fbcurrenttileindex159_g179 < 0) ? fbtotaltiles159_g179 : 0;
			float fblinearindextox159_g179 = round ( fmod ( fbcurrenttileindex159_g179, _Vector9.x ) );
			float fboffsetx159_g179 = fblinearindextox159_g179 * fbcolsoffset159_g179;
			float fblinearindextoy159_g179 = round( fmod( ( fbcurrenttileindex159_g179 - fblinearindextox159_g179 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g179 = (int)(_Vector9.y-1) - fblinearindextoy159_g179;
			float fboffsety159_g179 = fblinearindextoy159_g179 * fbrowsoffset159_g179;
			float2 fboffset159_g179 = float2(fboffsetx159_g179, fboffsety159_g179);
			float2 fbuv159_g179 = i.uv2_texcoord2 * fbtiling159_g179 + fboffset159_g179;
			int flipbookFrame159_g179 = ( ( int )fbcurrenttileindex159_g179);
			float3 desaturateInitialColor284_g179 = ( float4( tex2D( _LightLightmap, fbuv159_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot284_g179 = dot( desaturateInitialColor284_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g179 = lerp( desaturateInitialColor284_g179, desaturateDot284_g179.xxx, 1.0 );
			float4 color299_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g179 = ( float4( desaturateVar284_g179 , 0.0 ) * color299_g179 );
			float fbtotaltiles165_g179 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g179 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g179 = 1.0f / _Vector10.y;
			float fbspeed165_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g179 = float2(fbcolsoffset165_g179, fbrowsoffset165_g179);
			float fbcurrenttileindex165_g179 = floor( fmod( fbspeed165_g179 + 4.0, fbtotaltiles165_g179) );
			fbcurrenttileindex165_g179 += ( fbcurrenttileindex165_g179 < 0) ? fbtotaltiles165_g179 : 0;
			float fblinearindextox165_g179 = round ( fmod ( fbcurrenttileindex165_g179, _Vector10.x ) );
			float fboffsetx165_g179 = fblinearindextox165_g179 * fbcolsoffset165_g179;
			float fblinearindextoy165_g179 = round( fmod( ( fbcurrenttileindex165_g179 - fblinearindextox165_g179 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g179 = (int)(_Vector10.y-1) - fblinearindextoy165_g179;
			float fboffsety165_g179 = fblinearindextoy165_g179 * fbrowsoffset165_g179;
			float2 fboffset165_g179 = float2(fboffsetx165_g179, fboffsety165_g179);
			float2 fbuv165_g179 = i.uv2_texcoord2 * fbtiling165_g179 + fboffset165_g179;
			int flipbookFrame165_g179 = ( ( int )fbcurrenttileindex165_g179);
			float3 desaturateInitialColor283_g179 = ( float4( tex2D( _LightLightmap, fbuv165_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot283_g179 = dot( desaturateInitialColor283_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g179 = lerp( desaturateInitialColor283_g179, desaturateDot283_g179.xxx, 1.0 );
			float4 color298_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g179 = ( float4( desaturateVar283_g179 , 0.0 ) * color298_g179 );
			float fbtotaltiles173_g179 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g179 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g179 = 1.0f / _Vector11.y;
			float fbspeed173_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g179 = float2(fbcolsoffset173_g179, fbrowsoffset173_g179);
			float fbcurrenttileindex173_g179 = floor( fmod( fbspeed173_g179 + 3.0, fbtotaltiles173_g179) );
			fbcurrenttileindex173_g179 += ( fbcurrenttileindex173_g179 < 0) ? fbtotaltiles173_g179 : 0;
			float fblinearindextox173_g179 = round ( fmod ( fbcurrenttileindex173_g179, _Vector11.x ) );
			float fboffsetx173_g179 = fblinearindextox173_g179 * fbcolsoffset173_g179;
			float fblinearindextoy173_g179 = round( fmod( ( fbcurrenttileindex173_g179 - fblinearindextox173_g179 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g179 = (int)(_Vector11.y-1) - fblinearindextoy173_g179;
			float fboffsety173_g179 = fblinearindextoy173_g179 * fbrowsoffset173_g179;
			float2 fboffset173_g179 = float2(fboffsetx173_g179, fboffsety173_g179);
			float2 fbuv173_g179 = i.uv2_texcoord2 * fbtiling173_g179 + fboffset173_g179;
			int flipbookFrame173_g179 = ( ( int )fbcurrenttileindex173_g179);
			float3 desaturateInitialColor282_g179 = ( float4( tex2D( _LightLightmap, fbuv173_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot282_g179 = dot( desaturateInitialColor282_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g179 = lerp( desaturateInitialColor282_g179, desaturateDot282_g179.xxx, 1.0 );
			float4 color297_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g179 = ( float4( desaturateVar282_g179 , 0.0 ) * color297_g179 );
			float4 _FinalLight10_12247_g179 = ( ( step( _VarAudioLink3_g179 , 0.667 ) * _VarLight10161_g179 ) + ( step( _VarAudioLink3_g179 , 0.7337 ) * _VarLight11172_g179 ) + ( step( _VarAudioLink3_g179 , 0.8004 ) * _VarLight12180_g179 ) );
			float fbtotaltiles189_g179 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g179 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g179 = 1.0f / _Vector12.y;
			float fbspeed189_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g179 = float2(fbcolsoffset189_g179, fbrowsoffset189_g179);
			float fbcurrenttileindex189_g179 = floor( fmod( fbspeed189_g179 + 2.0, fbtotaltiles189_g179) );
			fbcurrenttileindex189_g179 += ( fbcurrenttileindex189_g179 < 0) ? fbtotaltiles189_g179 : 0;
			float fblinearindextox189_g179 = round ( fmod ( fbcurrenttileindex189_g179, _Vector12.x ) );
			float fboffsetx189_g179 = fblinearindextox189_g179 * fbcolsoffset189_g179;
			float fblinearindextoy189_g179 = round( fmod( ( fbcurrenttileindex189_g179 - fblinearindextox189_g179 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g179 = (int)(_Vector12.y-1) - fblinearindextoy189_g179;
			float fboffsety189_g179 = fblinearindextoy189_g179 * fbrowsoffset189_g179;
			float2 fboffset189_g179 = float2(fboffsetx189_g179, fboffsety189_g179);
			float2 fbuv189_g179 = i.uv2_texcoord2 * fbtiling189_g179 + fboffset189_g179;
			int flipbookFrame189_g179 = ( ( int )fbcurrenttileindex189_g179);
			float3 desaturateInitialColor285_g179 = ( float4( tex2D( _LightLightmap, fbuv189_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot285_g179 = dot( desaturateInitialColor285_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g179 = lerp( desaturateInitialColor285_g179, desaturateDot285_g179.xxx, 1.0 );
			float4 color300_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g179 = ( float4( desaturateVar285_g179 , 0.0 ) * color300_g179 );
			float fbtotaltiles195_g179 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g179 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g179 = 1.0f / _Vector13.y;
			float fbspeed195_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g179 = float2(fbcolsoffset195_g179, fbrowsoffset195_g179);
			float fbcurrenttileindex195_g179 = floor( fmod( fbspeed195_g179 + 1.0, fbtotaltiles195_g179) );
			fbcurrenttileindex195_g179 += ( fbcurrenttileindex195_g179 < 0) ? fbtotaltiles195_g179 : 0;
			float fblinearindextox195_g179 = round ( fmod ( fbcurrenttileindex195_g179, _Vector13.x ) );
			float fboffsetx195_g179 = fblinearindextox195_g179 * fbcolsoffset195_g179;
			float fblinearindextoy195_g179 = round( fmod( ( fbcurrenttileindex195_g179 - fblinearindextox195_g179 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g179 = (int)(_Vector13.y-1) - fblinearindextoy195_g179;
			float fboffsety195_g179 = fblinearindextoy195_g179 * fbrowsoffset195_g179;
			float2 fboffset195_g179 = float2(fboffsetx195_g179, fboffsety195_g179);
			float2 fbuv195_g179 = i.uv2_texcoord2 * fbtiling195_g179 + fboffset195_g179;
			int flipbookFrame195_g179 = ( ( int )fbcurrenttileindex195_g179);
			float3 desaturateInitialColor286_g179 = ( float4( tex2D( _LightLightmap, fbuv195_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot286_g179 = dot( desaturateInitialColor286_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g179 = lerp( desaturateInitialColor286_g179, desaturateDot286_g179.xxx, 1.0 );
			float4 color301_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g179 = ( float4( desaturateVar286_g179 , 0.0 ) * color301_g179 );
			float fbtotaltiles203_g179 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g179 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g179 = 1.0f / _Vector14.y;
			float fbspeed203_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g179 = float2(fbcolsoffset203_g179, fbrowsoffset203_g179);
			float fbcurrenttileindex203_g179 = floor( fmod( fbspeed203_g179 + 0.0, fbtotaltiles203_g179) );
			fbcurrenttileindex203_g179 += ( fbcurrenttileindex203_g179 < 0) ? fbtotaltiles203_g179 : 0;
			float fblinearindextox203_g179 = round ( fmod ( fbcurrenttileindex203_g179, _Vector14.x ) );
			float fboffsetx203_g179 = fblinearindextox203_g179 * fbcolsoffset203_g179;
			float fblinearindextoy203_g179 = round( fmod( ( fbcurrenttileindex203_g179 - fblinearindextox203_g179 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g179 = (int)(_Vector14.y-1) - fblinearindextoy203_g179;
			float fboffsety203_g179 = fblinearindextoy203_g179 * fbrowsoffset203_g179;
			float2 fboffset203_g179 = float2(fboffsetx203_g179, fboffsety203_g179);
			float2 fbuv203_g179 = i.uv2_texcoord2 * fbtiling203_g179 + fboffset203_g179;
			int flipbookFrame203_g179 = ( ( int )fbcurrenttileindex203_g179);
			float3 desaturateInitialColor287_g179 = ( float4( tex2D( _LightLightmap, fbuv203_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot287_g179 = dot( desaturateInitialColor287_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g179 = lerp( desaturateInitialColor287_g179, desaturateDot287_g179.xxx, 1.0 );
			float4 color302_g179 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g179 = ( float4( desaturateVar287_g179 , 0.0 ) * color302_g179 );
			float4 _FinalLight13_15255_g179 = ( ( step( _VarAudioLink3_g179 , 0.8671 ) * _VarLight13191_g179 ) + ( step( _VarAudioLink3_g179 , 0.9338 ) * _VarLight14202_g179 ) + ( step( _VarAudioLink3_g179 , 1.0 ) * _VarLight15210_g179 ) );
			float fbtotaltiles339_g179 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g179 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g179 = 1.0f / _Vector15.y;
			float fbspeed339_g179 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g179 = float2(fbcolsoffset339_g179, fbrowsoffset339_g179);
			float fbcurrenttileindex339_g179 = floor( fmod( fbspeed339_g179 + 15.0, fbtotaltiles339_g179) );
			fbcurrenttileindex339_g179 += ( fbcurrenttileindex339_g179 < 0) ? fbtotaltiles339_g179 : 0;
			float fblinearindextox339_g179 = round ( fmod ( fbcurrenttileindex339_g179, _Vector15.x ) );
			float fboffsetx339_g179 = fblinearindextox339_g179 * fbcolsoffset339_g179;
			float fblinearindextoy339_g179 = round( fmod( ( fbcurrenttileindex339_g179 - fblinearindextox339_g179 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g179 = (int)(_Vector15.y-1) - fblinearindextoy339_g179;
			float fboffsety339_g179 = fblinearindextoy339_g179 * fbrowsoffset339_g179;
			float2 fboffset339_g179 = float2(fboffsetx339_g179, fboffsety339_g179);
			float2 fbuv339_g179 = i.uv2_texcoord2 * fbtiling339_g179 + fboffset339_g179;
			int flipbookFrame339_g179 = ( ( int )fbcurrenttileindex339_g179);
			float3 desaturateInitialColor347_g179 = ( float4( tex2D( _LightLightmap, fbuv339_g179 ).rgb , 0.0 ) * _VarColor146_g179 ).xyz;
			float desaturateDot347_g179 = dot( desaturateInitialColor347_g179, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g179 = lerp( desaturateInitialColor347_g179, desaturateDot347_g179.xxx, 1.0 );
			float4 color345_g179 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g179 = ( float4( desaturateVar347_g179 , 0.0 ) * color345_g179 );
			float4 _FinalLight16356_g179 = ( step( _VarAudioLink3_g179 , 0.0667 ) * _VarLight16350_g179 );
			float4 _FinalLights262_g179 = ( _FinalLight1_3223_g179 + _FinalLight4_6231_g179 + _FinalLight7_9239_g179 + _FinalLight10_12247_g179 + _FinalLight13_15255_g179 + _FinalLight16356_g179 );
			float4 temp_output_237_0 = _FinalLights262_g179;
			float4 temp_output_252_0 = ( saturate( min( min( temp_output_244_0, temp_output_238_0 ), temp_output_237_0 ) ) * 1.0 );
			int Band3_g188 = (int)_BandWhite1;
			float Delay3_g188 = 0.0;
			float localAudioLinkLerp3_g188 = AudioLinkLerp3_g188( Band3_g188 , Delay3_g188 );
			float _VarAudioLink3_g187 = ( 1.0 - localAudioLinkLerp3_g188 );
			float fbtotaltiles52_g187 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g187 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g187 = 1.0f / _Vector0.y;
			float fbspeed52_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g187 = float2(fbcolsoffset52_g187, fbrowsoffset52_g187);
			float fbcurrenttileindex52_g187 = floor( fmod( fbspeed52_g187 + 14.0, fbtotaltiles52_g187) );
			fbcurrenttileindex52_g187 += ( fbcurrenttileindex52_g187 < 0) ? fbtotaltiles52_g187 : 0;
			float fblinearindextox52_g187 = round ( fmod ( fbcurrenttileindex52_g187, _Vector0.x ) );
			float fboffsetx52_g187 = fblinearindextox52_g187 * fbcolsoffset52_g187;
			float fblinearindextoy52_g187 = round( fmod( ( fbcurrenttileindex52_g187 - fblinearindextox52_g187 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g187 = (int)(_Vector0.y-1) - fblinearindextoy52_g187;
			float fboffsety52_g187 = fblinearindextoy52_g187 * fbrowsoffset52_g187;
			float2 fboffset52_g187 = float2(fboffsetx52_g187, fboffsety52_g187);
			float2 fbuv52_g187 = i.uv2_texcoord2 * fbtiling52_g187 + fboffset52_g187;
			int flipbookFrame52_g187 = ( ( int )fbcurrenttileindex52_g187);
			float4 color240 = IsGammaSpace() ? float4( 0, 1, 0, 0 ) : float4( 0, 1, 0, 0 );
			float4 _VarColor146_g187 = color240;
			float3 desaturateInitialColor276_g187 = ( float4( tex2D( _LightLightmap, fbuv52_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot276_g187 = dot( desaturateInitialColor276_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g187 = lerp( desaturateInitialColor276_g187, desaturateDot276_g187.xxx, 1.0 );
			float4 color288_g187 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g187 = ( float4( desaturateVar276_g187 , 0.0 ) * color288_g187 );
			float fbtotaltiles66_g187 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g187 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g187 = 1.0f / _Vector1.y;
			float fbspeed66_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g187 = float2(fbcolsoffset66_g187, fbrowsoffset66_g187);
			float fbcurrenttileindex66_g187 = floor( fmod( fbspeed66_g187 + 13.0, fbtotaltiles66_g187) );
			fbcurrenttileindex66_g187 += ( fbcurrenttileindex66_g187 < 0) ? fbtotaltiles66_g187 : 0;
			float fblinearindextox66_g187 = round ( fmod ( fbcurrenttileindex66_g187, _Vector1.x ) );
			float fboffsetx66_g187 = fblinearindextox66_g187 * fbcolsoffset66_g187;
			float fblinearindextoy66_g187 = round( fmod( ( fbcurrenttileindex66_g187 - fblinearindextox66_g187 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g187 = (int)(_Vector1.y-1) - fblinearindextoy66_g187;
			float fboffsety66_g187 = fblinearindextoy66_g187 * fbrowsoffset66_g187;
			float2 fboffset66_g187 = float2(fboffsetx66_g187, fboffsety66_g187);
			float2 fbuv66_g187 = i.uv2_texcoord2 * fbtiling66_g187 + fboffset66_g187;
			int flipbookFrame66_g187 = ( ( int )fbcurrenttileindex66_g187);
			float3 desaturateInitialColor277_g187 = ( float4( tex2D( _LightLightmap, fbuv66_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot277_g187 = dot( desaturateInitialColor277_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g187 = lerp( desaturateInitialColor277_g187, desaturateDot277_g187.xxx, 1.0 );
			float4 color289_g187 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g187 = ( float4( desaturateVar277_g187 , 0.0 ) * color289_g187 );
			float4 color290_g187 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g187 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g187 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g187 = 1.0f / _Vector2.y;
			float fbspeed76_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g187 = float2(fbcolsoffset76_g187, fbrowsoffset76_g187);
			float fbcurrenttileindex76_g187 = floor( fmod( fbspeed76_g187 + 12.0, fbtotaltiles76_g187) );
			fbcurrenttileindex76_g187 += ( fbcurrenttileindex76_g187 < 0) ? fbtotaltiles76_g187 : 0;
			float fblinearindextox76_g187 = round ( fmod ( fbcurrenttileindex76_g187, _Vector2.x ) );
			float fboffsetx76_g187 = fblinearindextox76_g187 * fbcolsoffset76_g187;
			float fblinearindextoy76_g187 = round( fmod( ( fbcurrenttileindex76_g187 - fblinearindextox76_g187 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g187 = (int)(_Vector2.y-1) - fblinearindextoy76_g187;
			float fboffsety76_g187 = fblinearindextoy76_g187 * fbrowsoffset76_g187;
			float2 fboffset76_g187 = float2(fboffsetx76_g187, fboffsety76_g187);
			float2 fbuv76_g187 = i.uv2_texcoord2 * fbtiling76_g187 + fboffset76_g187;
			int flipbookFrame76_g187 = ( ( int )fbcurrenttileindex76_g187);
			float3 desaturateInitialColor303_g187 = ( float4( tex2D( _LightLightmap, fbuv76_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot303_g187 = dot( desaturateInitialColor303_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g187 = lerp( desaturateInitialColor303_g187, desaturateDot303_g187.xxx, 1.0 );
			float4 _VarLight384_g187 = ( color290_g187 * float4( desaturateVar303_g187 , 0.0 ) );
			float4 _FinalLight1_3223_g187 = ( ( step( _VarAudioLink3_g187 , 0.0667 ) * _VarLight157_g187 ) + ( step( _VarAudioLink3_g187 , 0.1334 ) * _VarLight270_g187 ) + ( step( _VarAudioLink3_g187 , 0.2001 ) * _VarLight384_g187 ) );
			float fbtotaltiles86_g187 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g187 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g187 = 1.0f / _Vector3.y;
			float fbspeed86_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g187 = float2(fbcolsoffset86_g187, fbrowsoffset86_g187);
			float fbcurrenttileindex86_g187 = floor( fmod( fbspeed86_g187 + 11.0, fbtotaltiles86_g187) );
			fbcurrenttileindex86_g187 += ( fbcurrenttileindex86_g187 < 0) ? fbtotaltiles86_g187 : 0;
			float fblinearindextox86_g187 = round ( fmod ( fbcurrenttileindex86_g187, _Vector3.x ) );
			float fboffsetx86_g187 = fblinearindextox86_g187 * fbcolsoffset86_g187;
			float fblinearindextoy86_g187 = round( fmod( ( fbcurrenttileindex86_g187 - fblinearindextox86_g187 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g187 = (int)(_Vector3.y-1) - fblinearindextoy86_g187;
			float fboffsety86_g187 = fblinearindextoy86_g187 * fbrowsoffset86_g187;
			float2 fboffset86_g187 = float2(fboffsetx86_g187, fboffsety86_g187);
			float2 fbuv86_g187 = i.uv2_texcoord2 * fbtiling86_g187 + fboffset86_g187;
			int flipbookFrame86_g187 = ( ( int )fbcurrenttileindex86_g187);
			float3 desaturateInitialColor278_g187 = ( float4( tex2D( _LightLightmap, fbuv86_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot278_g187 = dot( desaturateInitialColor278_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g187 = lerp( desaturateInitialColor278_g187, desaturateDot278_g187.xxx, 1.0 );
			float4 color293_g187 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g187 = ( float4( desaturateVar278_g187 , 0.0 ) * color293_g187 );
			float fbtotaltiles96_g187 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g187 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g187 = 1.0f / _Vector4.y;
			float fbspeed96_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g187 = float2(fbcolsoffset96_g187, fbrowsoffset96_g187);
			float fbcurrenttileindex96_g187 = floor( fmod( fbspeed96_g187 + 10.0, fbtotaltiles96_g187) );
			fbcurrenttileindex96_g187 += ( fbcurrenttileindex96_g187 < 0) ? fbtotaltiles96_g187 : 0;
			float fblinearindextox96_g187 = round ( fmod ( fbcurrenttileindex96_g187, _Vector4.x ) );
			float fboffsetx96_g187 = fblinearindextox96_g187 * fbcolsoffset96_g187;
			float fblinearindextoy96_g187 = round( fmod( ( fbcurrenttileindex96_g187 - fblinearindextox96_g187 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g187 = (int)(_Vector4.y-1) - fblinearindextoy96_g187;
			float fboffsety96_g187 = fblinearindextoy96_g187 * fbrowsoffset96_g187;
			float2 fboffset96_g187 = float2(fboffsetx96_g187, fboffsety96_g187);
			float2 fbuv96_g187 = i.uv2_texcoord2 * fbtiling96_g187 + fboffset96_g187;
			int flipbookFrame96_g187 = ( ( int )fbcurrenttileindex96_g187);
			float3 desaturateInitialColor279_g187 = ( float4( tex2D( _LightLightmap, fbuv96_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot279_g187 = dot( desaturateInitialColor279_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g187 = lerp( desaturateInitialColor279_g187, desaturateDot279_g187.xxx, 1.0 );
			float4 color292_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g187 = ( float4( desaturateVar279_g187 , 0.0 ) * color292_g187 );
			float fbtotaltiles106_g187 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g187 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g187 = 1.0f / _Vector5.y;
			float fbspeed106_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g187 = float2(fbcolsoffset106_g187, fbrowsoffset106_g187);
			float fbcurrenttileindex106_g187 = floor( fmod( fbspeed106_g187 + 9.0, fbtotaltiles106_g187) );
			fbcurrenttileindex106_g187 += ( fbcurrenttileindex106_g187 < 0) ? fbtotaltiles106_g187 : 0;
			float fblinearindextox106_g187 = round ( fmod ( fbcurrenttileindex106_g187, _Vector5.x ) );
			float fboffsetx106_g187 = fblinearindextox106_g187 * fbcolsoffset106_g187;
			float fblinearindextoy106_g187 = round( fmod( ( fbcurrenttileindex106_g187 - fblinearindextox106_g187 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g187 = (int)(_Vector5.y-1) - fblinearindextoy106_g187;
			float fboffsety106_g187 = fblinearindextoy106_g187 * fbrowsoffset106_g187;
			float2 fboffset106_g187 = float2(fboffsetx106_g187, fboffsety106_g187);
			float2 fbuv106_g187 = i.uv2_texcoord2 * fbtiling106_g187 + fboffset106_g187;
			int flipbookFrame106_g187 = ( ( int )fbcurrenttileindex106_g187);
			float3 desaturateInitialColor316_g187 = ( float4( tex2D( _LightLightmap, fbuv106_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot316_g187 = dot( desaturateInitialColor316_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g187 = lerp( desaturateInitialColor316_g187, desaturateDot316_g187.xxx, 1.0 );
			float4 color291_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g187 = ( float4( desaturateVar316_g187 , 0.0 ) * color291_g187 );
			float4 _FinalLight4_6231_g187 = ( ( step( _VarAudioLink3_g187 , 0.2668 ) * _VarLight490_g187 ) + ( step( _VarAudioLink3_g187 , 0.3335 ) * _VarLight5104_g187 ) + ( step( _VarAudioLink3_g187 , 0.4002 ) * _VarLight6114_g187 ) );
			float fbtotaltiles118_g187 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g187 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g187 = 1.0f / _Vector6.y;
			float fbspeed118_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g187 = float2(fbcolsoffset118_g187, fbrowsoffset118_g187);
			float fbcurrenttileindex118_g187 = floor( fmod( fbspeed118_g187 + 8.0, fbtotaltiles118_g187) );
			fbcurrenttileindex118_g187 += ( fbcurrenttileindex118_g187 < 0) ? fbtotaltiles118_g187 : 0;
			float fblinearindextox118_g187 = round ( fmod ( fbcurrenttileindex118_g187, _Vector6.x ) );
			float fboffsetx118_g187 = fblinearindextox118_g187 * fbcolsoffset118_g187;
			float fblinearindextoy118_g187 = round( fmod( ( fbcurrenttileindex118_g187 - fblinearindextox118_g187 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g187 = (int)(_Vector6.y-1) - fblinearindextoy118_g187;
			float fboffsety118_g187 = fblinearindextoy118_g187 * fbrowsoffset118_g187;
			float2 fboffset118_g187 = float2(fboffsetx118_g187, fboffsety118_g187);
			float2 fbuv118_g187 = i.uv2_texcoord2 * fbtiling118_g187 + fboffset118_g187;
			int flipbookFrame118_g187 = ( ( int )fbcurrenttileindex118_g187);
			float3 desaturateInitialColor315_g187 = ( float4( tex2D( _LightLightmap, fbuv118_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot315_g187 = dot( desaturateInitialColor315_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g187 = lerp( desaturateInitialColor315_g187, desaturateDot315_g187.xxx, 1.0 );
			float4 color294_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g187 = ( float4( desaturateVar315_g187 , 0.0 ) * color294_g187 );
			float fbtotaltiles125_g187 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g187 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g187 = 1.0f / _Vector7.y;
			float fbspeed125_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g187 = float2(fbcolsoffset125_g187, fbrowsoffset125_g187);
			float fbcurrenttileindex125_g187 = floor( fmod( fbspeed125_g187 + 7.0, fbtotaltiles125_g187) );
			fbcurrenttileindex125_g187 += ( fbcurrenttileindex125_g187 < 0) ? fbtotaltiles125_g187 : 0;
			float fblinearindextox125_g187 = round ( fmod ( fbcurrenttileindex125_g187, _Vector7.x ) );
			float fboffsetx125_g187 = fblinearindextox125_g187 * fbcolsoffset125_g187;
			float fblinearindextoy125_g187 = round( fmod( ( fbcurrenttileindex125_g187 - fblinearindextox125_g187 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g187 = (int)(_Vector7.y-1) - fblinearindextoy125_g187;
			float fboffsety125_g187 = fblinearindextoy125_g187 * fbrowsoffset125_g187;
			float2 fboffset125_g187 = float2(fboffsetx125_g187, fboffsety125_g187);
			float2 fbuv125_g187 = i.uv2_texcoord2 * fbtiling125_g187 + fboffset125_g187;
			int flipbookFrame125_g187 = ( ( int )fbcurrenttileindex125_g187);
			float3 desaturateInitialColor280_g187 = ( float4( tex2D( _LightLightmap, fbuv125_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot280_g187 = dot( desaturateInitialColor280_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g187 = lerp( desaturateInitialColor280_g187, desaturateDot280_g187.xxx, 1.0 );
			float4 color295_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g187 = ( float4( desaturateVar280_g187 , 0.0 ) * color295_g187 );
			float fbtotaltiles134_g187 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g187 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g187 = 1.0f / _Vector8.y;
			float fbspeed134_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g187 = float2(fbcolsoffset134_g187, fbrowsoffset134_g187);
			float fbcurrenttileindex134_g187 = floor( fmod( fbspeed134_g187 + 6.0, fbtotaltiles134_g187) );
			fbcurrenttileindex134_g187 += ( fbcurrenttileindex134_g187 < 0) ? fbtotaltiles134_g187 : 0;
			float fblinearindextox134_g187 = round ( fmod ( fbcurrenttileindex134_g187, _Vector8.x ) );
			float fboffsetx134_g187 = fblinearindextox134_g187 * fbcolsoffset134_g187;
			float fblinearindextoy134_g187 = round( fmod( ( fbcurrenttileindex134_g187 - fblinearindextox134_g187 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g187 = (int)(_Vector8.y-1) - fblinearindextoy134_g187;
			float fboffsety134_g187 = fblinearindextoy134_g187 * fbrowsoffset134_g187;
			float2 fboffset134_g187 = float2(fboffsetx134_g187, fboffsety134_g187);
			float2 fbuv134_g187 = i.uv2_texcoord2 * fbtiling134_g187 + fboffset134_g187;
			int flipbookFrame134_g187 = ( ( int )fbcurrenttileindex134_g187);
			float3 desaturateInitialColor281_g187 = ( float4( tex2D( _LightLightmap, fbuv134_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot281_g187 = dot( desaturateInitialColor281_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g187 = lerp( desaturateInitialColor281_g187, desaturateDot281_g187.xxx, 1.0 );
			float4 color296_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g187 = ( float4( desaturateVar281_g187 , 0.0 ) * color296_g187 );
			float4 _FinalLight7_9239_g187 = ( ( step( _VarAudioLink3_g187 , 0.4669 ) * _VarLight7121_g187 ) + ( step( _VarAudioLink3_g187 , 0.5336 ) * _VarLight8133_g187 ) + ( step( _VarAudioLink3_g187 , 0.6003 ) * _VarLight9142_g187 ) );
			float fbtotaltiles159_g187 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g187 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g187 = 1.0f / _Vector9.y;
			float fbspeed159_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g187 = float2(fbcolsoffset159_g187, fbrowsoffset159_g187);
			float fbcurrenttileindex159_g187 = floor( fmod( fbspeed159_g187 + 5.0, fbtotaltiles159_g187) );
			fbcurrenttileindex159_g187 += ( fbcurrenttileindex159_g187 < 0) ? fbtotaltiles159_g187 : 0;
			float fblinearindextox159_g187 = round ( fmod ( fbcurrenttileindex159_g187, _Vector9.x ) );
			float fboffsetx159_g187 = fblinearindextox159_g187 * fbcolsoffset159_g187;
			float fblinearindextoy159_g187 = round( fmod( ( fbcurrenttileindex159_g187 - fblinearindextox159_g187 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g187 = (int)(_Vector9.y-1) - fblinearindextoy159_g187;
			float fboffsety159_g187 = fblinearindextoy159_g187 * fbrowsoffset159_g187;
			float2 fboffset159_g187 = float2(fboffsetx159_g187, fboffsety159_g187);
			float2 fbuv159_g187 = i.uv2_texcoord2 * fbtiling159_g187 + fboffset159_g187;
			int flipbookFrame159_g187 = ( ( int )fbcurrenttileindex159_g187);
			float3 desaturateInitialColor284_g187 = ( float4( tex2D( _LightLightmap, fbuv159_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot284_g187 = dot( desaturateInitialColor284_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g187 = lerp( desaturateInitialColor284_g187, desaturateDot284_g187.xxx, 1.0 );
			float4 color299_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g187 = ( float4( desaturateVar284_g187 , 0.0 ) * color299_g187 );
			float fbtotaltiles165_g187 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g187 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g187 = 1.0f / _Vector10.y;
			float fbspeed165_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g187 = float2(fbcolsoffset165_g187, fbrowsoffset165_g187);
			float fbcurrenttileindex165_g187 = floor( fmod( fbspeed165_g187 + 4.0, fbtotaltiles165_g187) );
			fbcurrenttileindex165_g187 += ( fbcurrenttileindex165_g187 < 0) ? fbtotaltiles165_g187 : 0;
			float fblinearindextox165_g187 = round ( fmod ( fbcurrenttileindex165_g187, _Vector10.x ) );
			float fboffsetx165_g187 = fblinearindextox165_g187 * fbcolsoffset165_g187;
			float fblinearindextoy165_g187 = round( fmod( ( fbcurrenttileindex165_g187 - fblinearindextox165_g187 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g187 = (int)(_Vector10.y-1) - fblinearindextoy165_g187;
			float fboffsety165_g187 = fblinearindextoy165_g187 * fbrowsoffset165_g187;
			float2 fboffset165_g187 = float2(fboffsetx165_g187, fboffsety165_g187);
			float2 fbuv165_g187 = i.uv2_texcoord2 * fbtiling165_g187 + fboffset165_g187;
			int flipbookFrame165_g187 = ( ( int )fbcurrenttileindex165_g187);
			float3 desaturateInitialColor283_g187 = ( float4( tex2D( _LightLightmap, fbuv165_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot283_g187 = dot( desaturateInitialColor283_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g187 = lerp( desaturateInitialColor283_g187, desaturateDot283_g187.xxx, 1.0 );
			float4 color298_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g187 = ( float4( desaturateVar283_g187 , 0.0 ) * color298_g187 );
			float fbtotaltiles173_g187 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g187 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g187 = 1.0f / _Vector11.y;
			float fbspeed173_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g187 = float2(fbcolsoffset173_g187, fbrowsoffset173_g187);
			float fbcurrenttileindex173_g187 = floor( fmod( fbspeed173_g187 + 3.0, fbtotaltiles173_g187) );
			fbcurrenttileindex173_g187 += ( fbcurrenttileindex173_g187 < 0) ? fbtotaltiles173_g187 : 0;
			float fblinearindextox173_g187 = round ( fmod ( fbcurrenttileindex173_g187, _Vector11.x ) );
			float fboffsetx173_g187 = fblinearindextox173_g187 * fbcolsoffset173_g187;
			float fblinearindextoy173_g187 = round( fmod( ( fbcurrenttileindex173_g187 - fblinearindextox173_g187 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g187 = (int)(_Vector11.y-1) - fblinearindextoy173_g187;
			float fboffsety173_g187 = fblinearindextoy173_g187 * fbrowsoffset173_g187;
			float2 fboffset173_g187 = float2(fboffsetx173_g187, fboffsety173_g187);
			float2 fbuv173_g187 = i.uv2_texcoord2 * fbtiling173_g187 + fboffset173_g187;
			int flipbookFrame173_g187 = ( ( int )fbcurrenttileindex173_g187);
			float3 desaturateInitialColor282_g187 = ( float4( tex2D( _LightLightmap, fbuv173_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot282_g187 = dot( desaturateInitialColor282_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g187 = lerp( desaturateInitialColor282_g187, desaturateDot282_g187.xxx, 1.0 );
			float4 color297_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g187 = ( float4( desaturateVar282_g187 , 0.0 ) * color297_g187 );
			float4 _FinalLight10_12247_g187 = ( ( step( _VarAudioLink3_g187 , 0.667 ) * _VarLight10161_g187 ) + ( step( _VarAudioLink3_g187 , 0.7337 ) * _VarLight11172_g187 ) + ( step( _VarAudioLink3_g187 , 0.8004 ) * _VarLight12180_g187 ) );
			float fbtotaltiles189_g187 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g187 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g187 = 1.0f / _Vector12.y;
			float fbspeed189_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g187 = float2(fbcolsoffset189_g187, fbrowsoffset189_g187);
			float fbcurrenttileindex189_g187 = floor( fmod( fbspeed189_g187 + 2.0, fbtotaltiles189_g187) );
			fbcurrenttileindex189_g187 += ( fbcurrenttileindex189_g187 < 0) ? fbtotaltiles189_g187 : 0;
			float fblinearindextox189_g187 = round ( fmod ( fbcurrenttileindex189_g187, _Vector12.x ) );
			float fboffsetx189_g187 = fblinearindextox189_g187 * fbcolsoffset189_g187;
			float fblinearindextoy189_g187 = round( fmod( ( fbcurrenttileindex189_g187 - fblinearindextox189_g187 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g187 = (int)(_Vector12.y-1) - fblinearindextoy189_g187;
			float fboffsety189_g187 = fblinearindextoy189_g187 * fbrowsoffset189_g187;
			float2 fboffset189_g187 = float2(fboffsetx189_g187, fboffsety189_g187);
			float2 fbuv189_g187 = i.uv2_texcoord2 * fbtiling189_g187 + fboffset189_g187;
			int flipbookFrame189_g187 = ( ( int )fbcurrenttileindex189_g187);
			float3 desaturateInitialColor285_g187 = ( float4( tex2D( _LightLightmap, fbuv189_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot285_g187 = dot( desaturateInitialColor285_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g187 = lerp( desaturateInitialColor285_g187, desaturateDot285_g187.xxx, 1.0 );
			float4 color300_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g187 = ( float4( desaturateVar285_g187 , 0.0 ) * color300_g187 );
			float fbtotaltiles195_g187 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g187 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g187 = 1.0f / _Vector13.y;
			float fbspeed195_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g187 = float2(fbcolsoffset195_g187, fbrowsoffset195_g187);
			float fbcurrenttileindex195_g187 = floor( fmod( fbspeed195_g187 + 1.0, fbtotaltiles195_g187) );
			fbcurrenttileindex195_g187 += ( fbcurrenttileindex195_g187 < 0) ? fbtotaltiles195_g187 : 0;
			float fblinearindextox195_g187 = round ( fmod ( fbcurrenttileindex195_g187, _Vector13.x ) );
			float fboffsetx195_g187 = fblinearindextox195_g187 * fbcolsoffset195_g187;
			float fblinearindextoy195_g187 = round( fmod( ( fbcurrenttileindex195_g187 - fblinearindextox195_g187 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g187 = (int)(_Vector13.y-1) - fblinearindextoy195_g187;
			float fboffsety195_g187 = fblinearindextoy195_g187 * fbrowsoffset195_g187;
			float2 fboffset195_g187 = float2(fboffsetx195_g187, fboffsety195_g187);
			float2 fbuv195_g187 = i.uv2_texcoord2 * fbtiling195_g187 + fboffset195_g187;
			int flipbookFrame195_g187 = ( ( int )fbcurrenttileindex195_g187);
			float3 desaturateInitialColor286_g187 = ( float4( tex2D( _LightLightmap, fbuv195_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot286_g187 = dot( desaturateInitialColor286_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g187 = lerp( desaturateInitialColor286_g187, desaturateDot286_g187.xxx, 1.0 );
			float4 color301_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g187 = ( float4( desaturateVar286_g187 , 0.0 ) * color301_g187 );
			float fbtotaltiles203_g187 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g187 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g187 = 1.0f / _Vector14.y;
			float fbspeed203_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g187 = float2(fbcolsoffset203_g187, fbrowsoffset203_g187);
			float fbcurrenttileindex203_g187 = floor( fmod( fbspeed203_g187 + 0.0, fbtotaltiles203_g187) );
			fbcurrenttileindex203_g187 += ( fbcurrenttileindex203_g187 < 0) ? fbtotaltiles203_g187 : 0;
			float fblinearindextox203_g187 = round ( fmod ( fbcurrenttileindex203_g187, _Vector14.x ) );
			float fboffsetx203_g187 = fblinearindextox203_g187 * fbcolsoffset203_g187;
			float fblinearindextoy203_g187 = round( fmod( ( fbcurrenttileindex203_g187 - fblinearindextox203_g187 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g187 = (int)(_Vector14.y-1) - fblinearindextoy203_g187;
			float fboffsety203_g187 = fblinearindextoy203_g187 * fbrowsoffset203_g187;
			float2 fboffset203_g187 = float2(fboffsetx203_g187, fboffsety203_g187);
			float2 fbuv203_g187 = i.uv2_texcoord2 * fbtiling203_g187 + fboffset203_g187;
			int flipbookFrame203_g187 = ( ( int )fbcurrenttileindex203_g187);
			float3 desaturateInitialColor287_g187 = ( float4( tex2D( _LightLightmap, fbuv203_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot287_g187 = dot( desaturateInitialColor287_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g187 = lerp( desaturateInitialColor287_g187, desaturateDot287_g187.xxx, 1.0 );
			float4 color302_g187 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g187 = ( float4( desaturateVar287_g187 , 0.0 ) * color302_g187 );
			float4 _FinalLight13_15255_g187 = ( ( step( _VarAudioLink3_g187 , 0.8671 ) * _VarLight13191_g187 ) + ( step( _VarAudioLink3_g187 , 0.9338 ) * _VarLight14202_g187 ) + ( step( _VarAudioLink3_g187 , 1.0 ) * _VarLight15210_g187 ) );
			float fbtotaltiles339_g187 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g187 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g187 = 1.0f / _Vector15.y;
			float fbspeed339_g187 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g187 = float2(fbcolsoffset339_g187, fbrowsoffset339_g187);
			float fbcurrenttileindex339_g187 = floor( fmod( fbspeed339_g187 + 15.0, fbtotaltiles339_g187) );
			fbcurrenttileindex339_g187 += ( fbcurrenttileindex339_g187 < 0) ? fbtotaltiles339_g187 : 0;
			float fblinearindextox339_g187 = round ( fmod ( fbcurrenttileindex339_g187, _Vector15.x ) );
			float fboffsetx339_g187 = fblinearindextox339_g187 * fbcolsoffset339_g187;
			float fblinearindextoy339_g187 = round( fmod( ( fbcurrenttileindex339_g187 - fblinearindextox339_g187 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g187 = (int)(_Vector15.y-1) - fblinearindextoy339_g187;
			float fboffsety339_g187 = fblinearindextoy339_g187 * fbrowsoffset339_g187;
			float2 fboffset339_g187 = float2(fboffsetx339_g187, fboffsety339_g187);
			float2 fbuv339_g187 = i.uv2_texcoord2 * fbtiling339_g187 + fboffset339_g187;
			int flipbookFrame339_g187 = ( ( int )fbcurrenttileindex339_g187);
			float3 desaturateInitialColor347_g187 = ( float4( tex2D( _LightLightmap, fbuv339_g187 ).rgb , 0.0 ) * _VarColor146_g187 ).xyz;
			float desaturateDot347_g187 = dot( desaturateInitialColor347_g187, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g187 = lerp( desaturateInitialColor347_g187, desaturateDot347_g187.xxx, 1.0 );
			float4 color345_g187 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g187 = ( float4( desaturateVar347_g187 , 0.0 ) * color345_g187 );
			float4 _FinalLight16356_g187 = ( step( _VarAudioLink3_g187 , 0.0667 ) * _VarLight16350_g187 );
			float4 _FinalLights262_g187 = ( _FinalLight1_3223_g187 + _FinalLight4_6231_g187 + _FinalLight7_9239_g187 + _FinalLight10_12247_g187 + _FinalLight13_15255_g187 + _FinalLight16356_g187 );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 _FinalTEmission292 = ( tex2D( _Emission, uv_Emission ) * _TextureEmission );
			float4 _FinalLightmap311 = tex2D( _LightMap, i.uv2_texcoord2 );
			float4 _FinalEmission270 = ( ( _LightEmission * saturate( ( saturate( ( ( temp_output_244_0 - temp_output_252_0 ) * _Red ) ) + saturate( ( ( temp_output_238_0 - temp_output_252_0 ) * _Green ) ) + saturate( ( ( ( temp_output_237_0 * 1.0 ) - temp_output_252_0 ) * _Blue ) ) + saturate( ( _FinalLights262_g187 * _White ) ) ) ) ) + _FinalTEmission292 + ( _ToggleLightmap * ( _FinalLightmap311 * _LightMapEmission ) ) );
			o.Emission = _FinalEmission270.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 _FinalMetal283 = tex2D( _Metallic, uv_Metallic );
			o.Metallic = _FinalMetal283.r;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float4 _FinalRoghness281 = ( ( 1.0 - tex2D( _Roughness, uv_Roughness ) ) * _RoughnessA );
			o.Smoothness = _FinalRoghness281.r;
			float2 uv_AmbientOcclusion = i.uv_texcoord * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
			float4 _FinalAO279 = tex2D( _AmbientOcclusion, uv_AmbientOcclusion );
			o.Occlusion = _FinalAO279.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19909
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;272;-2896,2320;Inherit;False;2983.538;1223.989;;46;270;294;293;297;299;298;259;269;258;257;254;268;266;265;264;267;22;20;255;256;263;250;155;241;252;244;261;17;240;239;251;243;242;262;245;238;237;236;235;234;233;312;313;314;308;309;Lights;1,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;233;-2816,3152;Inherit;False;Property;_BandBlue1;BandBlue;20;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;234;-2848,2960;Inherit;False;Constant;_CBlue1;CBlue;8;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;235;-2816,2864;Inherit;False;Property;_BandGreen1;BandGreen;19;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;236;-2848,2672;Inherit;False;Constant;_CGreen1;CGreen;7;0;Create;True;0;0;0;False;0;False;0,1,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;237;-2576,3072;Inherit;False;Lights;11;;179;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;-2576,2784;Inherit;False;Lights;11;;181;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;245;-2208,3008;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;262;-2128,3248;Inherit;False;Constant;_Float32;Float 32;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;242;-2800,2560;Inherit;False;Property;_BandRed1;BandRed;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-2848,2368;Inherit;False;Constant;_CRed1;CRed;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;251;-2096,3008;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;239;-2784,3440;Inherit;False;Property;_BandWhite1;BandWhite;21;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;240;-2848,3248;Inherit;False;Constant;_CWhite1;CWhite;9;0;Create;True;0;0;0;False;0;False;0,1,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-2144,3120;Inherit;False;Constant;_asdf;asdf;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;261;-1920,3184;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;252;-1936,3008;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;241;-2576,3360;Inherit;False;Lights;11;;187;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;-1904,3392;Inherit;False;Property;_White;White;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;244;-2576,2480;Inherit;False;Lights;11;;189;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;250;-1696,3120;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;263;-1680,3216;Inherit;False;Property;_Blue;Blue;14;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;256;-1712,2544;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;255;-1712,2800;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;20;-1712,2912;Inherit;False;Property;_Green;Green;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-1712,2640;Inherit;False;Property;_Red;Red;16;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-1744,3328;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;310;-2480,1920;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;264;-1552,3120;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;265;-1584,2544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;-1584,2800;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;268;-1600,3328;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;307;-2272,1936;Inherit;True;Property;_LightMap;LightMap;8;0;Create;True;0;0;0;False;0;False;-1;8516088864e5f144997a4a7e5a211205;cd4b51a6d0e20ef40b76b25ff4ca962c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;254;-1408,3120;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;257;-1440,2800;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;258;-1440,2544;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;269;-1232,3200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;291;-2256,1632;Inherit;True;Property;_Emission;Emission;5;0;Create;True;0;0;0;False;0;False;-1;f7622bbea65c48e42a45296e0e3fb351;f7622bbea65c48e42a45296e0e3fb351;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;296;-2176,1824;Inherit;False;Property;_TextureEmission;TextureEmission;7;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;311;-1872,1936;Inherit;False;_FinalLightmap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;259;-1216,2832;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;295;-1904,1632;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;312;-1040,2560;Inherit;False;311;_FinalLightmap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;314;-1040,2624;Inherit;False;Property;_LightMapEmission;LightMapEmission;10;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;298;-1104,2736;Inherit;False;Property;_LightEmission;LightEmission;13;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;299;-1088,2832;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;292;-1728,1632;Inherit;False;_FinalTEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;313;-816,2560;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;309;-896,2480;Inherit;False;Property;_ToggleLightmap;Toggle Lightmap;9;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;280;-2576,1200;Inherit;True;Property;_Roughness;Roughness;2;0;Create;True;0;0;0;False;0;False;-1;04fb3fe8de6b99e4982dafe6f4f4ef4c;1436c153cfa1ee94db0839b236cf7ab5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;316;-2256,1328;Inherit;False;Property;_RoughnessA;RoughnessA;3;0;Create;True;0;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;297;-928,2832;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;293;-688,2976;Inherit;False;292;_FinalTEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;308;-656,2560;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;284;-2224,1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;315;-1936,1200;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;294;-432,2832;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;273;-2256,528;Inherit;True;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;-1;3a3dc11a7e5bc5746b1953e3d11bd8b2;3a3dc11a7e5bc5746b1953e3d11bd8b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;278;-2256,976;Inherit;True;Property;_AmbientOcclusion;AmbientOcclusion;1;0;Create;True;0;0;0;False;0;False;-1;04fb3fe8de6b99e4982dafe6f4f4ef4c;04fb3fe8de6b99e4982dafe6f4f4ef4c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;282;-2256,1408;Inherit;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;-1;078bd9452763b7b45aedb60ea4a8b8dc;078bd9452763b7b45aedb60ea4a8b8dc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;276;-2256,752;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;-1;e73152d79209bf04bba4b083fb8de789;e73152d79209bf04bba4b083fb8de789;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;270;-336,2832;Inherit;False;_FinalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;274;-1904,528;Inherit;False;_FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;277;-1904,752;Inherit;False;_FinalNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;279;-1904,976;Inherit;False;_FinalAO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;283;-1552,1408;Inherit;False;_FinalMetal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;281;-1584,1200;Inherit;False;_FinalRoghness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;288;144,2192;Inherit;False;279;_FinalAO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;287;112,2128;Inherit;False;281;_FinalRoghness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;286;144,2064;Inherit;False;283;_FinalMetal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;271;112,2000;Inherit;False;270;_FinalEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;285;144,1936;Inherit;False;277;_FinalNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;275;144,1872;Inherit;False;274;_FinalAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;496,1888;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Banana/LightShaderL;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;237;145;234;0
WireConnection;237;263;233;0
WireConnection;238;145;236;0
WireConnection;238;263;235;0
WireConnection;245;0;244;0
WireConnection;245;1;238;0
WireConnection;245;2;237;0
WireConnection;251;0;245;0
WireConnection;261;0;237;0
WireConnection;261;1;262;0
WireConnection;252;0;251;0
WireConnection;252;1;17;0
WireConnection;241;145;240;0
WireConnection;241;263;239;0
WireConnection;244;145;243;0
WireConnection;244;263;242;0
WireConnection;250;0;261;0
WireConnection;250;1;252;0
WireConnection;256;0;244;0
WireConnection;256;1;252;0
WireConnection;255;0;238;0
WireConnection;255;1;252;0
WireConnection;267;0;241;0
WireConnection;267;1;155;0
WireConnection;264;0;250;0
WireConnection;264;1;263;0
WireConnection;265;0;256;0
WireConnection;265;1;22;0
WireConnection;266;0;255;0
WireConnection;266;1;20;0
WireConnection;268;0;267;0
WireConnection;307;1;310;0
WireConnection;254;0;264;0
WireConnection;257;0;266;0
WireConnection;258;0;265;0
WireConnection;269;0;268;0
WireConnection;311;0;307;0
WireConnection;259;0;258;0
WireConnection;259;1;257;0
WireConnection;259;2;254;0
WireConnection;259;3;269;0
WireConnection;295;0;291;0
WireConnection;295;1;296;0
WireConnection;299;0;259;0
WireConnection;292;0;295;0
WireConnection;313;0;312;0
WireConnection;313;1;314;0
WireConnection;297;0;298;0
WireConnection;297;1;299;0
WireConnection;308;0;309;0
WireConnection;308;1;313;0
WireConnection;284;0;280;0
WireConnection;315;0;284;0
WireConnection;315;1;316;0
WireConnection;294;0;297;0
WireConnection;294;1;293;0
WireConnection;294;2;308;0
WireConnection;270;0;294;0
WireConnection;274;0;273;0
WireConnection;277;0;276;0
WireConnection;279;0;278;0
WireConnection;283;0;282;0
WireConnection;281;0;315;0
WireConnection;0;0;275;0
WireConnection;0;1;285;0
WireConnection;0;2;271;0
WireConnection;0;3;286;0
WireConnection;0;4;287;0
WireConnection;0;5;288;0
ASEEND*/
//CHKSM=E09942A136E1CF9FFFEFF9EBE06954C00FB315A3