// Made with Amplify Shader Editor v1.9.9.9
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/BaseLightsN"
{
	Properties
	{
		_LightLightmap( "LightLightmap", 2D ) = "white" {}
		_LightEmission( "LightEmission", Float ) = 1
		_Blue( "Blue", Float ) = 1
		_White( "White", Float ) = 1
		_Red( "Red", Float ) = 1
		_Green( "Green", Float ) = 1
		_BandRed1( "BandRed", Float ) = 0
		_BandGreen1( "BandGreen", Float ) = 1
		_BandBlue1( "BandBlue", Float ) = 2
		_BandWhite1( "BandWhite", Float ) = 3
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
		};

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


		inline float AudioLinkLerp3_g224( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g220( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g216( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g222( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			int Band3_g224 = (int)_BandRed1;
			float Delay3_g224 = 0.0;
			float localAudioLinkLerp3_g224 = AudioLinkLerp3_g224( Band3_g224 , Delay3_g224 );
			float _VarAudioLink3_g223 = ( 1.0 - localAudioLinkLerp3_g224 );
			float2 _Vector0 = float2(4,4);
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles52_g223 = _Vector0.x * _Vector0.y;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset52_g223 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g223 = 1.0f / _Vector0.y;
			// Speed of animation
			float fbspeed52_g223 = _Time[ 1 ] * 0.0;
			// UV Tiling (col and row offset)
			float2 fbtiling52_g223 = float2(fbcolsoffset52_g223, fbrowsoffset52_g223);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex52_g223 = floor( fmod( fbspeed52_g223 + 14.0, fbtotaltiles52_g223) );
			fbcurrenttileindex52_g223 += ( fbcurrenttileindex52_g223 < 0) ? fbtotaltiles52_g223 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox52_g223 = round ( fmod ( fbcurrenttileindex52_g223, _Vector0.x ) );
			// Multiply Offset X by coloffset
			float fboffsetx52_g223 = fblinearindextox52_g223 * fbcolsoffset52_g223;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy52_g223 = round( fmod( ( fbcurrenttileindex52_g223 - fblinearindextox52_g223 ) / _Vector0.x, _Vector0.y ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy52_g223 = (int)(_Vector0.y-1) - fblinearindextoy52_g223;
			// Multiply Offset Y by rowoffset
			float fboffsety52_g223 = fblinearindextoy52_g223 * fbrowsoffset52_g223;
			// UV Offset
			float2 fboffset52_g223 = float2(fboffsetx52_g223, fboffsety52_g223);
			// Flipbook UV
			float2 fbuv52_g223 = i.uv2_texcoord2 * fbtiling52_g223 + fboffset52_g223;
			// *** END Flipbook UV Animation vars ***
			int flipbookFrame52_g223 = ( ( int )fbcurrenttileindex52_g223);
			float4 color184 = IsGammaSpace() ? float4( 1, 0, 0, 0 ) : float4( 1, 0, 0, 0 );
			float4 _VarColor146_g223 = color184;
			float3 desaturateInitialColor276_g223 = ( float4( tex2D( _LightLightmap, fbuv52_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot276_g223 = dot( desaturateInitialColor276_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g223 = lerp( desaturateInitialColor276_g223, desaturateDot276_g223.xxx, 1.0 );
			float4 color288_g223 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g223 = ( float4( desaturateVar276_g223 , 0.0 ) * color288_g223 );
			float2 _Vector1 = float2(4,4);
			float fbtotaltiles66_g223 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g223 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g223 = 1.0f / _Vector1.y;
			float fbspeed66_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g223 = float2(fbcolsoffset66_g223, fbrowsoffset66_g223);
			float fbcurrenttileindex66_g223 = floor( fmod( fbspeed66_g223 + 13.0, fbtotaltiles66_g223) );
			fbcurrenttileindex66_g223 += ( fbcurrenttileindex66_g223 < 0) ? fbtotaltiles66_g223 : 0;
			float fblinearindextox66_g223 = round ( fmod ( fbcurrenttileindex66_g223, _Vector1.x ) );
			float fboffsetx66_g223 = fblinearindextox66_g223 * fbcolsoffset66_g223;
			float fblinearindextoy66_g223 = round( fmod( ( fbcurrenttileindex66_g223 - fblinearindextox66_g223 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g223 = (int)(_Vector1.y-1) - fblinearindextoy66_g223;
			float fboffsety66_g223 = fblinearindextoy66_g223 * fbrowsoffset66_g223;
			float2 fboffset66_g223 = float2(fboffsetx66_g223, fboffsety66_g223);
			float2 fbuv66_g223 = i.uv2_texcoord2 * fbtiling66_g223 + fboffset66_g223;
			int flipbookFrame66_g223 = ( ( int )fbcurrenttileindex66_g223);
			float3 desaturateInitialColor277_g223 = ( float4( tex2D( _LightLightmap, fbuv66_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot277_g223 = dot( desaturateInitialColor277_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g223 = lerp( desaturateInitialColor277_g223, desaturateDot277_g223.xxx, 1.0 );
			float4 color289_g223 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g223 = ( float4( desaturateVar277_g223 , 0.0 ) * color289_g223 );
			float4 color290_g223 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float2 _Vector2 = float2(4,4);
			float fbtotaltiles76_g223 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g223 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g223 = 1.0f / _Vector2.y;
			float fbspeed76_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g223 = float2(fbcolsoffset76_g223, fbrowsoffset76_g223);
			float fbcurrenttileindex76_g223 = floor( fmod( fbspeed76_g223 + 12.0, fbtotaltiles76_g223) );
			fbcurrenttileindex76_g223 += ( fbcurrenttileindex76_g223 < 0) ? fbtotaltiles76_g223 : 0;
			float fblinearindextox76_g223 = round ( fmod ( fbcurrenttileindex76_g223, _Vector2.x ) );
			float fboffsetx76_g223 = fblinearindextox76_g223 * fbcolsoffset76_g223;
			float fblinearindextoy76_g223 = round( fmod( ( fbcurrenttileindex76_g223 - fblinearindextox76_g223 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g223 = (int)(_Vector2.y-1) - fblinearindextoy76_g223;
			float fboffsety76_g223 = fblinearindextoy76_g223 * fbrowsoffset76_g223;
			float2 fboffset76_g223 = float2(fboffsetx76_g223, fboffsety76_g223);
			float2 fbuv76_g223 = i.uv2_texcoord2 * fbtiling76_g223 + fboffset76_g223;
			int flipbookFrame76_g223 = ( ( int )fbcurrenttileindex76_g223);
			float3 desaturateInitialColor303_g223 = ( float4( tex2D( _LightLightmap, fbuv76_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot303_g223 = dot( desaturateInitialColor303_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g223 = lerp( desaturateInitialColor303_g223, desaturateDot303_g223.xxx, 1.0 );
			float4 _VarLight384_g223 = ( color290_g223 * float4( desaturateVar303_g223 , 0.0 ) );
			float4 _FinalLight1_3223_g223 = ( ( step( _VarAudioLink3_g223 , 0.0667 ) * _VarLight157_g223 ) + ( step( _VarAudioLink3_g223 , 0.1334 ) * _VarLight270_g223 ) + ( step( _VarAudioLink3_g223 , 0.2001 ) * _VarLight384_g223 ) );
			float2 _Vector3 = float2(4,4);
			float fbtotaltiles86_g223 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g223 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g223 = 1.0f / _Vector3.y;
			float fbspeed86_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g223 = float2(fbcolsoffset86_g223, fbrowsoffset86_g223);
			float fbcurrenttileindex86_g223 = floor( fmod( fbspeed86_g223 + 11.0, fbtotaltiles86_g223) );
			fbcurrenttileindex86_g223 += ( fbcurrenttileindex86_g223 < 0) ? fbtotaltiles86_g223 : 0;
			float fblinearindextox86_g223 = round ( fmod ( fbcurrenttileindex86_g223, _Vector3.x ) );
			float fboffsetx86_g223 = fblinearindextox86_g223 * fbcolsoffset86_g223;
			float fblinearindextoy86_g223 = round( fmod( ( fbcurrenttileindex86_g223 - fblinearindextox86_g223 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g223 = (int)(_Vector3.y-1) - fblinearindextoy86_g223;
			float fboffsety86_g223 = fblinearindextoy86_g223 * fbrowsoffset86_g223;
			float2 fboffset86_g223 = float2(fboffsetx86_g223, fboffsety86_g223);
			float2 fbuv86_g223 = i.uv2_texcoord2 * fbtiling86_g223 + fboffset86_g223;
			int flipbookFrame86_g223 = ( ( int )fbcurrenttileindex86_g223);
			float3 desaturateInitialColor278_g223 = ( float4( tex2D( _LightLightmap, fbuv86_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot278_g223 = dot( desaturateInitialColor278_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g223 = lerp( desaturateInitialColor278_g223, desaturateDot278_g223.xxx, 1.0 );
			float4 color293_g223 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g223 = ( float4( desaturateVar278_g223 , 0.0 ) * color293_g223 );
			float2 _Vector4 = float2(4,4);
			float fbtotaltiles96_g223 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g223 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g223 = 1.0f / _Vector4.y;
			float fbspeed96_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g223 = float2(fbcolsoffset96_g223, fbrowsoffset96_g223);
			float fbcurrenttileindex96_g223 = floor( fmod( fbspeed96_g223 + 10.0, fbtotaltiles96_g223) );
			fbcurrenttileindex96_g223 += ( fbcurrenttileindex96_g223 < 0) ? fbtotaltiles96_g223 : 0;
			float fblinearindextox96_g223 = round ( fmod ( fbcurrenttileindex96_g223, _Vector4.x ) );
			float fboffsetx96_g223 = fblinearindextox96_g223 * fbcolsoffset96_g223;
			float fblinearindextoy96_g223 = round( fmod( ( fbcurrenttileindex96_g223 - fblinearindextox96_g223 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g223 = (int)(_Vector4.y-1) - fblinearindextoy96_g223;
			float fboffsety96_g223 = fblinearindextoy96_g223 * fbrowsoffset96_g223;
			float2 fboffset96_g223 = float2(fboffsetx96_g223, fboffsety96_g223);
			float2 fbuv96_g223 = i.uv2_texcoord2 * fbtiling96_g223 + fboffset96_g223;
			int flipbookFrame96_g223 = ( ( int )fbcurrenttileindex96_g223);
			float3 desaturateInitialColor279_g223 = ( float4( tex2D( _LightLightmap, fbuv96_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot279_g223 = dot( desaturateInitialColor279_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g223 = lerp( desaturateInitialColor279_g223, desaturateDot279_g223.xxx, 1.0 );
			float4 color292_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g223 = ( float4( desaturateVar279_g223 , 0.0 ) * color292_g223 );
			float2 _Vector5 = float2(4,4);
			float fbtotaltiles106_g223 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g223 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g223 = 1.0f / _Vector5.y;
			float fbspeed106_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g223 = float2(fbcolsoffset106_g223, fbrowsoffset106_g223);
			float fbcurrenttileindex106_g223 = floor( fmod( fbspeed106_g223 + 9.0, fbtotaltiles106_g223) );
			fbcurrenttileindex106_g223 += ( fbcurrenttileindex106_g223 < 0) ? fbtotaltiles106_g223 : 0;
			float fblinearindextox106_g223 = round ( fmod ( fbcurrenttileindex106_g223, _Vector5.x ) );
			float fboffsetx106_g223 = fblinearindextox106_g223 * fbcolsoffset106_g223;
			float fblinearindextoy106_g223 = round( fmod( ( fbcurrenttileindex106_g223 - fblinearindextox106_g223 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g223 = (int)(_Vector5.y-1) - fblinearindextoy106_g223;
			float fboffsety106_g223 = fblinearindextoy106_g223 * fbrowsoffset106_g223;
			float2 fboffset106_g223 = float2(fboffsetx106_g223, fboffsety106_g223);
			float2 fbuv106_g223 = i.uv2_texcoord2 * fbtiling106_g223 + fboffset106_g223;
			int flipbookFrame106_g223 = ( ( int )fbcurrenttileindex106_g223);
			float3 desaturateInitialColor316_g223 = ( float4( tex2D( _LightLightmap, fbuv106_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot316_g223 = dot( desaturateInitialColor316_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g223 = lerp( desaturateInitialColor316_g223, desaturateDot316_g223.xxx, 1.0 );
			float4 color291_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g223 = ( float4( desaturateVar316_g223 , 0.0 ) * color291_g223 );
			float4 _FinalLight4_6231_g223 = ( ( step( _VarAudioLink3_g223 , 0.2668 ) * _VarLight490_g223 ) + ( step( _VarAudioLink3_g223 , 0.3335 ) * _VarLight5104_g223 ) + ( step( _VarAudioLink3_g223 , 0.4002 ) * _VarLight6114_g223 ) );
			float2 _Vector6 = float2(4,4);
			float fbtotaltiles118_g223 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g223 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g223 = 1.0f / _Vector6.y;
			float fbspeed118_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g223 = float2(fbcolsoffset118_g223, fbrowsoffset118_g223);
			float fbcurrenttileindex118_g223 = floor( fmod( fbspeed118_g223 + 8.0, fbtotaltiles118_g223) );
			fbcurrenttileindex118_g223 += ( fbcurrenttileindex118_g223 < 0) ? fbtotaltiles118_g223 : 0;
			float fblinearindextox118_g223 = round ( fmod ( fbcurrenttileindex118_g223, _Vector6.x ) );
			float fboffsetx118_g223 = fblinearindextox118_g223 * fbcolsoffset118_g223;
			float fblinearindextoy118_g223 = round( fmod( ( fbcurrenttileindex118_g223 - fblinearindextox118_g223 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g223 = (int)(_Vector6.y-1) - fblinearindextoy118_g223;
			float fboffsety118_g223 = fblinearindextoy118_g223 * fbrowsoffset118_g223;
			float2 fboffset118_g223 = float2(fboffsetx118_g223, fboffsety118_g223);
			float2 fbuv118_g223 = i.uv2_texcoord2 * fbtiling118_g223 + fboffset118_g223;
			int flipbookFrame118_g223 = ( ( int )fbcurrenttileindex118_g223);
			float3 desaturateInitialColor315_g223 = ( float4( tex2D( _LightLightmap, fbuv118_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot315_g223 = dot( desaturateInitialColor315_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g223 = lerp( desaturateInitialColor315_g223, desaturateDot315_g223.xxx, 1.0 );
			float4 color294_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g223 = ( float4( desaturateVar315_g223 , 0.0 ) * color294_g223 );
			float2 _Vector7 = float2(4,4);
			float fbtotaltiles125_g223 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g223 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g223 = 1.0f / _Vector7.y;
			float fbspeed125_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g223 = float2(fbcolsoffset125_g223, fbrowsoffset125_g223);
			float fbcurrenttileindex125_g223 = floor( fmod( fbspeed125_g223 + 7.0, fbtotaltiles125_g223) );
			fbcurrenttileindex125_g223 += ( fbcurrenttileindex125_g223 < 0) ? fbtotaltiles125_g223 : 0;
			float fblinearindextox125_g223 = round ( fmod ( fbcurrenttileindex125_g223, _Vector7.x ) );
			float fboffsetx125_g223 = fblinearindextox125_g223 * fbcolsoffset125_g223;
			float fblinearindextoy125_g223 = round( fmod( ( fbcurrenttileindex125_g223 - fblinearindextox125_g223 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g223 = (int)(_Vector7.y-1) - fblinearindextoy125_g223;
			float fboffsety125_g223 = fblinearindextoy125_g223 * fbrowsoffset125_g223;
			float2 fboffset125_g223 = float2(fboffsetx125_g223, fboffsety125_g223);
			float2 fbuv125_g223 = i.uv2_texcoord2 * fbtiling125_g223 + fboffset125_g223;
			int flipbookFrame125_g223 = ( ( int )fbcurrenttileindex125_g223);
			float3 desaturateInitialColor280_g223 = ( float4( tex2D( _LightLightmap, fbuv125_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot280_g223 = dot( desaturateInitialColor280_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g223 = lerp( desaturateInitialColor280_g223, desaturateDot280_g223.xxx, 1.0 );
			float4 color295_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g223 = ( float4( desaturateVar280_g223 , 0.0 ) * color295_g223 );
			float2 _Vector8 = float2(4,4);
			float fbtotaltiles134_g223 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g223 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g223 = 1.0f / _Vector8.y;
			float fbspeed134_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g223 = float2(fbcolsoffset134_g223, fbrowsoffset134_g223);
			float fbcurrenttileindex134_g223 = floor( fmod( fbspeed134_g223 + 6.0, fbtotaltiles134_g223) );
			fbcurrenttileindex134_g223 += ( fbcurrenttileindex134_g223 < 0) ? fbtotaltiles134_g223 : 0;
			float fblinearindextox134_g223 = round ( fmod ( fbcurrenttileindex134_g223, _Vector8.x ) );
			float fboffsetx134_g223 = fblinearindextox134_g223 * fbcolsoffset134_g223;
			float fblinearindextoy134_g223 = round( fmod( ( fbcurrenttileindex134_g223 - fblinearindextox134_g223 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g223 = (int)(_Vector8.y-1) - fblinearindextoy134_g223;
			float fboffsety134_g223 = fblinearindextoy134_g223 * fbrowsoffset134_g223;
			float2 fboffset134_g223 = float2(fboffsetx134_g223, fboffsety134_g223);
			float2 fbuv134_g223 = i.uv2_texcoord2 * fbtiling134_g223 + fboffset134_g223;
			int flipbookFrame134_g223 = ( ( int )fbcurrenttileindex134_g223);
			float3 desaturateInitialColor281_g223 = ( float4( tex2D( _LightLightmap, fbuv134_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot281_g223 = dot( desaturateInitialColor281_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g223 = lerp( desaturateInitialColor281_g223, desaturateDot281_g223.xxx, 1.0 );
			float4 color296_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g223 = ( float4( desaturateVar281_g223 , 0.0 ) * color296_g223 );
			float4 _FinalLight7_9239_g223 = ( ( step( _VarAudioLink3_g223 , 0.4669 ) * _VarLight7121_g223 ) + ( step( _VarAudioLink3_g223 , 0.5336 ) * _VarLight8133_g223 ) + ( step( _VarAudioLink3_g223 , 0.6003 ) * _VarLight9142_g223 ) );
			float2 _Vector9 = float2(4,4);
			float fbtotaltiles159_g223 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g223 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g223 = 1.0f / _Vector9.y;
			float fbspeed159_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g223 = float2(fbcolsoffset159_g223, fbrowsoffset159_g223);
			float fbcurrenttileindex159_g223 = floor( fmod( fbspeed159_g223 + 5.0, fbtotaltiles159_g223) );
			fbcurrenttileindex159_g223 += ( fbcurrenttileindex159_g223 < 0) ? fbtotaltiles159_g223 : 0;
			float fblinearindextox159_g223 = round ( fmod ( fbcurrenttileindex159_g223, _Vector9.x ) );
			float fboffsetx159_g223 = fblinearindextox159_g223 * fbcolsoffset159_g223;
			float fblinearindextoy159_g223 = round( fmod( ( fbcurrenttileindex159_g223 - fblinearindextox159_g223 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g223 = (int)(_Vector9.y-1) - fblinearindextoy159_g223;
			float fboffsety159_g223 = fblinearindextoy159_g223 * fbrowsoffset159_g223;
			float2 fboffset159_g223 = float2(fboffsetx159_g223, fboffsety159_g223);
			float2 fbuv159_g223 = i.uv2_texcoord2 * fbtiling159_g223 + fboffset159_g223;
			int flipbookFrame159_g223 = ( ( int )fbcurrenttileindex159_g223);
			float3 desaturateInitialColor284_g223 = ( float4( tex2D( _LightLightmap, fbuv159_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot284_g223 = dot( desaturateInitialColor284_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g223 = lerp( desaturateInitialColor284_g223, desaturateDot284_g223.xxx, 1.0 );
			float4 color299_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g223 = ( float4( desaturateVar284_g223 , 0.0 ) * color299_g223 );
			float2 _Vector10 = float2(4,4);
			float fbtotaltiles165_g223 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g223 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g223 = 1.0f / _Vector10.y;
			float fbspeed165_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g223 = float2(fbcolsoffset165_g223, fbrowsoffset165_g223);
			float fbcurrenttileindex165_g223 = floor( fmod( fbspeed165_g223 + 4.0, fbtotaltiles165_g223) );
			fbcurrenttileindex165_g223 += ( fbcurrenttileindex165_g223 < 0) ? fbtotaltiles165_g223 : 0;
			float fblinearindextox165_g223 = round ( fmod ( fbcurrenttileindex165_g223, _Vector10.x ) );
			float fboffsetx165_g223 = fblinearindextox165_g223 * fbcolsoffset165_g223;
			float fblinearindextoy165_g223 = round( fmod( ( fbcurrenttileindex165_g223 - fblinearindextox165_g223 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g223 = (int)(_Vector10.y-1) - fblinearindextoy165_g223;
			float fboffsety165_g223 = fblinearindextoy165_g223 * fbrowsoffset165_g223;
			float2 fboffset165_g223 = float2(fboffsetx165_g223, fboffsety165_g223);
			float2 fbuv165_g223 = i.uv2_texcoord2 * fbtiling165_g223 + fboffset165_g223;
			int flipbookFrame165_g223 = ( ( int )fbcurrenttileindex165_g223);
			float3 desaturateInitialColor283_g223 = ( float4( tex2D( _LightLightmap, fbuv165_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot283_g223 = dot( desaturateInitialColor283_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g223 = lerp( desaturateInitialColor283_g223, desaturateDot283_g223.xxx, 1.0 );
			float4 color298_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g223 = ( float4( desaturateVar283_g223 , 0.0 ) * color298_g223 );
			float2 _Vector11 = float2(4,4);
			float fbtotaltiles173_g223 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g223 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g223 = 1.0f / _Vector11.y;
			float fbspeed173_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g223 = float2(fbcolsoffset173_g223, fbrowsoffset173_g223);
			float fbcurrenttileindex173_g223 = floor( fmod( fbspeed173_g223 + 3.0, fbtotaltiles173_g223) );
			fbcurrenttileindex173_g223 += ( fbcurrenttileindex173_g223 < 0) ? fbtotaltiles173_g223 : 0;
			float fblinearindextox173_g223 = round ( fmod ( fbcurrenttileindex173_g223, _Vector11.x ) );
			float fboffsetx173_g223 = fblinearindextox173_g223 * fbcolsoffset173_g223;
			float fblinearindextoy173_g223 = round( fmod( ( fbcurrenttileindex173_g223 - fblinearindextox173_g223 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g223 = (int)(_Vector11.y-1) - fblinearindextoy173_g223;
			float fboffsety173_g223 = fblinearindextoy173_g223 * fbrowsoffset173_g223;
			float2 fboffset173_g223 = float2(fboffsetx173_g223, fboffsety173_g223);
			float2 fbuv173_g223 = i.uv2_texcoord2 * fbtiling173_g223 + fboffset173_g223;
			int flipbookFrame173_g223 = ( ( int )fbcurrenttileindex173_g223);
			float3 desaturateInitialColor282_g223 = ( float4( tex2D( _LightLightmap, fbuv173_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot282_g223 = dot( desaturateInitialColor282_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g223 = lerp( desaturateInitialColor282_g223, desaturateDot282_g223.xxx, 1.0 );
			float4 color297_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g223 = ( float4( desaturateVar282_g223 , 0.0 ) * color297_g223 );
			float4 _FinalLight10_12247_g223 = ( ( step( _VarAudioLink3_g223 , 0.667 ) * _VarLight10161_g223 ) + ( step( _VarAudioLink3_g223 , 0.7337 ) * _VarLight11172_g223 ) + ( step( _VarAudioLink3_g223 , 0.8004 ) * _VarLight12180_g223 ) );
			float2 _Vector12 = float2(4,4);
			float fbtotaltiles189_g223 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g223 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g223 = 1.0f / _Vector12.y;
			float fbspeed189_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g223 = float2(fbcolsoffset189_g223, fbrowsoffset189_g223);
			float fbcurrenttileindex189_g223 = floor( fmod( fbspeed189_g223 + 2.0, fbtotaltiles189_g223) );
			fbcurrenttileindex189_g223 += ( fbcurrenttileindex189_g223 < 0) ? fbtotaltiles189_g223 : 0;
			float fblinearindextox189_g223 = round ( fmod ( fbcurrenttileindex189_g223, _Vector12.x ) );
			float fboffsetx189_g223 = fblinearindextox189_g223 * fbcolsoffset189_g223;
			float fblinearindextoy189_g223 = round( fmod( ( fbcurrenttileindex189_g223 - fblinearindextox189_g223 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g223 = (int)(_Vector12.y-1) - fblinearindextoy189_g223;
			float fboffsety189_g223 = fblinearindextoy189_g223 * fbrowsoffset189_g223;
			float2 fboffset189_g223 = float2(fboffsetx189_g223, fboffsety189_g223);
			float2 fbuv189_g223 = i.uv2_texcoord2 * fbtiling189_g223 + fboffset189_g223;
			int flipbookFrame189_g223 = ( ( int )fbcurrenttileindex189_g223);
			float3 desaturateInitialColor285_g223 = ( float4( tex2D( _LightLightmap, fbuv189_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot285_g223 = dot( desaturateInitialColor285_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g223 = lerp( desaturateInitialColor285_g223, desaturateDot285_g223.xxx, 1.0 );
			float4 color300_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g223 = ( float4( desaturateVar285_g223 , 0.0 ) * color300_g223 );
			float2 _Vector13 = float2(4,4);
			float fbtotaltiles195_g223 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g223 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g223 = 1.0f / _Vector13.y;
			float fbspeed195_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g223 = float2(fbcolsoffset195_g223, fbrowsoffset195_g223);
			float fbcurrenttileindex195_g223 = floor( fmod( fbspeed195_g223 + 1.0, fbtotaltiles195_g223) );
			fbcurrenttileindex195_g223 += ( fbcurrenttileindex195_g223 < 0) ? fbtotaltiles195_g223 : 0;
			float fblinearindextox195_g223 = round ( fmod ( fbcurrenttileindex195_g223, _Vector13.x ) );
			float fboffsetx195_g223 = fblinearindextox195_g223 * fbcolsoffset195_g223;
			float fblinearindextoy195_g223 = round( fmod( ( fbcurrenttileindex195_g223 - fblinearindextox195_g223 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g223 = (int)(_Vector13.y-1) - fblinearindextoy195_g223;
			float fboffsety195_g223 = fblinearindextoy195_g223 * fbrowsoffset195_g223;
			float2 fboffset195_g223 = float2(fboffsetx195_g223, fboffsety195_g223);
			float2 fbuv195_g223 = i.uv2_texcoord2 * fbtiling195_g223 + fboffset195_g223;
			int flipbookFrame195_g223 = ( ( int )fbcurrenttileindex195_g223);
			float3 desaturateInitialColor286_g223 = ( float4( tex2D( _LightLightmap, fbuv195_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot286_g223 = dot( desaturateInitialColor286_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g223 = lerp( desaturateInitialColor286_g223, desaturateDot286_g223.xxx, 1.0 );
			float4 color301_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g223 = ( float4( desaturateVar286_g223 , 0.0 ) * color301_g223 );
			float2 _Vector14 = float2(4,4);
			float fbtotaltiles203_g223 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g223 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g223 = 1.0f / _Vector14.y;
			float fbspeed203_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g223 = float2(fbcolsoffset203_g223, fbrowsoffset203_g223);
			float fbcurrenttileindex203_g223 = floor( fmod( fbspeed203_g223 + 0.0, fbtotaltiles203_g223) );
			fbcurrenttileindex203_g223 += ( fbcurrenttileindex203_g223 < 0) ? fbtotaltiles203_g223 : 0;
			float fblinearindextox203_g223 = round ( fmod ( fbcurrenttileindex203_g223, _Vector14.x ) );
			float fboffsetx203_g223 = fblinearindextox203_g223 * fbcolsoffset203_g223;
			float fblinearindextoy203_g223 = round( fmod( ( fbcurrenttileindex203_g223 - fblinearindextox203_g223 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g223 = (int)(_Vector14.y-1) - fblinearindextoy203_g223;
			float fboffsety203_g223 = fblinearindextoy203_g223 * fbrowsoffset203_g223;
			float2 fboffset203_g223 = float2(fboffsetx203_g223, fboffsety203_g223);
			float2 fbuv203_g223 = i.uv2_texcoord2 * fbtiling203_g223 + fboffset203_g223;
			int flipbookFrame203_g223 = ( ( int )fbcurrenttileindex203_g223);
			float3 desaturateInitialColor287_g223 = ( float4( tex2D( _LightLightmap, fbuv203_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot287_g223 = dot( desaturateInitialColor287_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g223 = lerp( desaturateInitialColor287_g223, desaturateDot287_g223.xxx, 1.0 );
			float4 color302_g223 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g223 = ( float4( desaturateVar287_g223 , 0.0 ) * color302_g223 );
			float4 _FinalLight13_15255_g223 = ( ( step( _VarAudioLink3_g223 , 0.8671 ) * _VarLight13191_g223 ) + ( step( _VarAudioLink3_g223 , 0.9338 ) * _VarLight14202_g223 ) + ( step( _VarAudioLink3_g223 , 1.0 ) * _VarLight15210_g223 ) );
			float2 _Vector15 = float2(4,4);
			float fbtotaltiles339_g223 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g223 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g223 = 1.0f / _Vector15.y;
			float fbspeed339_g223 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g223 = float2(fbcolsoffset339_g223, fbrowsoffset339_g223);
			float fbcurrenttileindex339_g223 = floor( fmod( fbspeed339_g223 + 15.0, fbtotaltiles339_g223) );
			fbcurrenttileindex339_g223 += ( fbcurrenttileindex339_g223 < 0) ? fbtotaltiles339_g223 : 0;
			float fblinearindextox339_g223 = round ( fmod ( fbcurrenttileindex339_g223, _Vector15.x ) );
			float fboffsetx339_g223 = fblinearindextox339_g223 * fbcolsoffset339_g223;
			float fblinearindextoy339_g223 = round( fmod( ( fbcurrenttileindex339_g223 - fblinearindextox339_g223 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g223 = (int)(_Vector15.y-1) - fblinearindextoy339_g223;
			float fboffsety339_g223 = fblinearindextoy339_g223 * fbrowsoffset339_g223;
			float2 fboffset339_g223 = float2(fboffsetx339_g223, fboffsety339_g223);
			float2 fbuv339_g223 = i.uv2_texcoord2 * fbtiling339_g223 + fboffset339_g223;
			int flipbookFrame339_g223 = ( ( int )fbcurrenttileindex339_g223);
			float3 desaturateInitialColor347_g223 = ( float4( tex2D( _LightLightmap, fbuv339_g223 ).rgb , 0.0 ) * _VarColor146_g223 ).xyz;
			float desaturateDot347_g223 = dot( desaturateInitialColor347_g223, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g223 = lerp( desaturateInitialColor347_g223, desaturateDot347_g223.xxx, 1.0 );
			float4 color345_g223 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g223 = ( float4( desaturateVar347_g223 , 0.0 ) * color345_g223 );
			float4 _FinalLight16356_g223 = ( step( _VarAudioLink3_g223 , 0.0667 ) * _VarLight16350_g223 );
			float4 _FinalLights262_g223 = ( _FinalLight1_3223_g223 + _FinalLight4_6231_g223 + _FinalLight7_9239_g223 + _FinalLight10_12247_g223 + _FinalLight13_15255_g223 + _FinalLight16356_g223 );
			float4 temp_output_221_0 = _FinalLights262_g223;
			int Band3_g220 = (int)_BandGreen1;
			float Delay3_g220 = 0.0;
			float localAudioLinkLerp3_g220 = AudioLinkLerp3_g220( Band3_g220 , Delay3_g220 );
			float _VarAudioLink3_g219 = ( 1.0 - localAudioLinkLerp3_g220 );
			float fbtotaltiles52_g219 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g219 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g219 = 1.0f / _Vector0.y;
			float fbspeed52_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g219 = float2(fbcolsoffset52_g219, fbrowsoffset52_g219);
			float fbcurrenttileindex52_g219 = floor( fmod( fbspeed52_g219 + 14.0, fbtotaltiles52_g219) );
			fbcurrenttileindex52_g219 += ( fbcurrenttileindex52_g219 < 0) ? fbtotaltiles52_g219 : 0;
			float fblinearindextox52_g219 = round ( fmod ( fbcurrenttileindex52_g219, _Vector0.x ) );
			float fboffsetx52_g219 = fblinearindextox52_g219 * fbcolsoffset52_g219;
			float fblinearindextoy52_g219 = round( fmod( ( fbcurrenttileindex52_g219 - fblinearindextox52_g219 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g219 = (int)(_Vector0.y-1) - fblinearindextoy52_g219;
			float fboffsety52_g219 = fblinearindextoy52_g219 * fbrowsoffset52_g219;
			float2 fboffset52_g219 = float2(fboffsetx52_g219, fboffsety52_g219);
			float2 fbuv52_g219 = i.uv2_texcoord2 * fbtiling52_g219 + fboffset52_g219;
			int flipbookFrame52_g219 = ( ( int )fbcurrenttileindex52_g219);
			float4 color178 = IsGammaSpace() ? float4( 0, 1, 0, 0 ) : float4( 0, 1, 0, 0 );
			float4 _VarColor146_g219 = color178;
			float3 desaturateInitialColor276_g219 = ( float4( tex2D( _LightLightmap, fbuv52_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot276_g219 = dot( desaturateInitialColor276_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g219 = lerp( desaturateInitialColor276_g219, desaturateDot276_g219.xxx, 1.0 );
			float4 color288_g219 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g219 = ( float4( desaturateVar276_g219 , 0.0 ) * color288_g219 );
			float fbtotaltiles66_g219 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g219 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g219 = 1.0f / _Vector1.y;
			float fbspeed66_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g219 = float2(fbcolsoffset66_g219, fbrowsoffset66_g219);
			float fbcurrenttileindex66_g219 = floor( fmod( fbspeed66_g219 + 13.0, fbtotaltiles66_g219) );
			fbcurrenttileindex66_g219 += ( fbcurrenttileindex66_g219 < 0) ? fbtotaltiles66_g219 : 0;
			float fblinearindextox66_g219 = round ( fmod ( fbcurrenttileindex66_g219, _Vector1.x ) );
			float fboffsetx66_g219 = fblinearindextox66_g219 * fbcolsoffset66_g219;
			float fblinearindextoy66_g219 = round( fmod( ( fbcurrenttileindex66_g219 - fblinearindextox66_g219 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g219 = (int)(_Vector1.y-1) - fblinearindextoy66_g219;
			float fboffsety66_g219 = fblinearindextoy66_g219 * fbrowsoffset66_g219;
			float2 fboffset66_g219 = float2(fboffsetx66_g219, fboffsety66_g219);
			float2 fbuv66_g219 = i.uv2_texcoord2 * fbtiling66_g219 + fboffset66_g219;
			int flipbookFrame66_g219 = ( ( int )fbcurrenttileindex66_g219);
			float3 desaturateInitialColor277_g219 = ( float4( tex2D( _LightLightmap, fbuv66_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot277_g219 = dot( desaturateInitialColor277_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g219 = lerp( desaturateInitialColor277_g219, desaturateDot277_g219.xxx, 1.0 );
			float4 color289_g219 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g219 = ( float4( desaturateVar277_g219 , 0.0 ) * color289_g219 );
			float4 color290_g219 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g219 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g219 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g219 = 1.0f / _Vector2.y;
			float fbspeed76_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g219 = float2(fbcolsoffset76_g219, fbrowsoffset76_g219);
			float fbcurrenttileindex76_g219 = floor( fmod( fbspeed76_g219 + 12.0, fbtotaltiles76_g219) );
			fbcurrenttileindex76_g219 += ( fbcurrenttileindex76_g219 < 0) ? fbtotaltiles76_g219 : 0;
			float fblinearindextox76_g219 = round ( fmod ( fbcurrenttileindex76_g219, _Vector2.x ) );
			float fboffsetx76_g219 = fblinearindextox76_g219 * fbcolsoffset76_g219;
			float fblinearindextoy76_g219 = round( fmod( ( fbcurrenttileindex76_g219 - fblinearindextox76_g219 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g219 = (int)(_Vector2.y-1) - fblinearindextoy76_g219;
			float fboffsety76_g219 = fblinearindextoy76_g219 * fbrowsoffset76_g219;
			float2 fboffset76_g219 = float2(fboffsetx76_g219, fboffsety76_g219);
			float2 fbuv76_g219 = i.uv2_texcoord2 * fbtiling76_g219 + fboffset76_g219;
			int flipbookFrame76_g219 = ( ( int )fbcurrenttileindex76_g219);
			float3 desaturateInitialColor303_g219 = ( float4( tex2D( _LightLightmap, fbuv76_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot303_g219 = dot( desaturateInitialColor303_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g219 = lerp( desaturateInitialColor303_g219, desaturateDot303_g219.xxx, 1.0 );
			float4 _VarLight384_g219 = ( color290_g219 * float4( desaturateVar303_g219 , 0.0 ) );
			float4 _FinalLight1_3223_g219 = ( ( step( _VarAudioLink3_g219 , 0.0667 ) * _VarLight157_g219 ) + ( step( _VarAudioLink3_g219 , 0.1334 ) * _VarLight270_g219 ) + ( step( _VarAudioLink3_g219 , 0.2001 ) * _VarLight384_g219 ) );
			float fbtotaltiles86_g219 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g219 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g219 = 1.0f / _Vector3.y;
			float fbspeed86_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g219 = float2(fbcolsoffset86_g219, fbrowsoffset86_g219);
			float fbcurrenttileindex86_g219 = floor( fmod( fbspeed86_g219 + 11.0, fbtotaltiles86_g219) );
			fbcurrenttileindex86_g219 += ( fbcurrenttileindex86_g219 < 0) ? fbtotaltiles86_g219 : 0;
			float fblinearindextox86_g219 = round ( fmod ( fbcurrenttileindex86_g219, _Vector3.x ) );
			float fboffsetx86_g219 = fblinearindextox86_g219 * fbcolsoffset86_g219;
			float fblinearindextoy86_g219 = round( fmod( ( fbcurrenttileindex86_g219 - fblinearindextox86_g219 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g219 = (int)(_Vector3.y-1) - fblinearindextoy86_g219;
			float fboffsety86_g219 = fblinearindextoy86_g219 * fbrowsoffset86_g219;
			float2 fboffset86_g219 = float2(fboffsetx86_g219, fboffsety86_g219);
			float2 fbuv86_g219 = i.uv2_texcoord2 * fbtiling86_g219 + fboffset86_g219;
			int flipbookFrame86_g219 = ( ( int )fbcurrenttileindex86_g219);
			float3 desaturateInitialColor278_g219 = ( float4( tex2D( _LightLightmap, fbuv86_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot278_g219 = dot( desaturateInitialColor278_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g219 = lerp( desaturateInitialColor278_g219, desaturateDot278_g219.xxx, 1.0 );
			float4 color293_g219 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g219 = ( float4( desaturateVar278_g219 , 0.0 ) * color293_g219 );
			float fbtotaltiles96_g219 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g219 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g219 = 1.0f / _Vector4.y;
			float fbspeed96_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g219 = float2(fbcolsoffset96_g219, fbrowsoffset96_g219);
			float fbcurrenttileindex96_g219 = floor( fmod( fbspeed96_g219 + 10.0, fbtotaltiles96_g219) );
			fbcurrenttileindex96_g219 += ( fbcurrenttileindex96_g219 < 0) ? fbtotaltiles96_g219 : 0;
			float fblinearindextox96_g219 = round ( fmod ( fbcurrenttileindex96_g219, _Vector4.x ) );
			float fboffsetx96_g219 = fblinearindextox96_g219 * fbcolsoffset96_g219;
			float fblinearindextoy96_g219 = round( fmod( ( fbcurrenttileindex96_g219 - fblinearindextox96_g219 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g219 = (int)(_Vector4.y-1) - fblinearindextoy96_g219;
			float fboffsety96_g219 = fblinearindextoy96_g219 * fbrowsoffset96_g219;
			float2 fboffset96_g219 = float2(fboffsetx96_g219, fboffsety96_g219);
			float2 fbuv96_g219 = i.uv2_texcoord2 * fbtiling96_g219 + fboffset96_g219;
			int flipbookFrame96_g219 = ( ( int )fbcurrenttileindex96_g219);
			float3 desaturateInitialColor279_g219 = ( float4( tex2D( _LightLightmap, fbuv96_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot279_g219 = dot( desaturateInitialColor279_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g219 = lerp( desaturateInitialColor279_g219, desaturateDot279_g219.xxx, 1.0 );
			float4 color292_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g219 = ( float4( desaturateVar279_g219 , 0.0 ) * color292_g219 );
			float fbtotaltiles106_g219 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g219 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g219 = 1.0f / _Vector5.y;
			float fbspeed106_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g219 = float2(fbcolsoffset106_g219, fbrowsoffset106_g219);
			float fbcurrenttileindex106_g219 = floor( fmod( fbspeed106_g219 + 9.0, fbtotaltiles106_g219) );
			fbcurrenttileindex106_g219 += ( fbcurrenttileindex106_g219 < 0) ? fbtotaltiles106_g219 : 0;
			float fblinearindextox106_g219 = round ( fmod ( fbcurrenttileindex106_g219, _Vector5.x ) );
			float fboffsetx106_g219 = fblinearindextox106_g219 * fbcolsoffset106_g219;
			float fblinearindextoy106_g219 = round( fmod( ( fbcurrenttileindex106_g219 - fblinearindextox106_g219 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g219 = (int)(_Vector5.y-1) - fblinearindextoy106_g219;
			float fboffsety106_g219 = fblinearindextoy106_g219 * fbrowsoffset106_g219;
			float2 fboffset106_g219 = float2(fboffsetx106_g219, fboffsety106_g219);
			float2 fbuv106_g219 = i.uv2_texcoord2 * fbtiling106_g219 + fboffset106_g219;
			int flipbookFrame106_g219 = ( ( int )fbcurrenttileindex106_g219);
			float3 desaturateInitialColor316_g219 = ( float4( tex2D( _LightLightmap, fbuv106_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot316_g219 = dot( desaturateInitialColor316_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g219 = lerp( desaturateInitialColor316_g219, desaturateDot316_g219.xxx, 1.0 );
			float4 color291_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g219 = ( float4( desaturateVar316_g219 , 0.0 ) * color291_g219 );
			float4 _FinalLight4_6231_g219 = ( ( step( _VarAudioLink3_g219 , 0.2668 ) * _VarLight490_g219 ) + ( step( _VarAudioLink3_g219 , 0.3335 ) * _VarLight5104_g219 ) + ( step( _VarAudioLink3_g219 , 0.4002 ) * _VarLight6114_g219 ) );
			float fbtotaltiles118_g219 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g219 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g219 = 1.0f / _Vector6.y;
			float fbspeed118_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g219 = float2(fbcolsoffset118_g219, fbrowsoffset118_g219);
			float fbcurrenttileindex118_g219 = floor( fmod( fbspeed118_g219 + 8.0, fbtotaltiles118_g219) );
			fbcurrenttileindex118_g219 += ( fbcurrenttileindex118_g219 < 0) ? fbtotaltiles118_g219 : 0;
			float fblinearindextox118_g219 = round ( fmod ( fbcurrenttileindex118_g219, _Vector6.x ) );
			float fboffsetx118_g219 = fblinearindextox118_g219 * fbcolsoffset118_g219;
			float fblinearindextoy118_g219 = round( fmod( ( fbcurrenttileindex118_g219 - fblinearindextox118_g219 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g219 = (int)(_Vector6.y-1) - fblinearindextoy118_g219;
			float fboffsety118_g219 = fblinearindextoy118_g219 * fbrowsoffset118_g219;
			float2 fboffset118_g219 = float2(fboffsetx118_g219, fboffsety118_g219);
			float2 fbuv118_g219 = i.uv2_texcoord2 * fbtiling118_g219 + fboffset118_g219;
			int flipbookFrame118_g219 = ( ( int )fbcurrenttileindex118_g219);
			float3 desaturateInitialColor315_g219 = ( float4( tex2D( _LightLightmap, fbuv118_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot315_g219 = dot( desaturateInitialColor315_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g219 = lerp( desaturateInitialColor315_g219, desaturateDot315_g219.xxx, 1.0 );
			float4 color294_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g219 = ( float4( desaturateVar315_g219 , 0.0 ) * color294_g219 );
			float fbtotaltiles125_g219 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g219 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g219 = 1.0f / _Vector7.y;
			float fbspeed125_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g219 = float2(fbcolsoffset125_g219, fbrowsoffset125_g219);
			float fbcurrenttileindex125_g219 = floor( fmod( fbspeed125_g219 + 7.0, fbtotaltiles125_g219) );
			fbcurrenttileindex125_g219 += ( fbcurrenttileindex125_g219 < 0) ? fbtotaltiles125_g219 : 0;
			float fblinearindextox125_g219 = round ( fmod ( fbcurrenttileindex125_g219, _Vector7.x ) );
			float fboffsetx125_g219 = fblinearindextox125_g219 * fbcolsoffset125_g219;
			float fblinearindextoy125_g219 = round( fmod( ( fbcurrenttileindex125_g219 - fblinearindextox125_g219 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g219 = (int)(_Vector7.y-1) - fblinearindextoy125_g219;
			float fboffsety125_g219 = fblinearindextoy125_g219 * fbrowsoffset125_g219;
			float2 fboffset125_g219 = float2(fboffsetx125_g219, fboffsety125_g219);
			float2 fbuv125_g219 = i.uv2_texcoord2 * fbtiling125_g219 + fboffset125_g219;
			int flipbookFrame125_g219 = ( ( int )fbcurrenttileindex125_g219);
			float3 desaturateInitialColor280_g219 = ( float4( tex2D( _LightLightmap, fbuv125_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot280_g219 = dot( desaturateInitialColor280_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g219 = lerp( desaturateInitialColor280_g219, desaturateDot280_g219.xxx, 1.0 );
			float4 color295_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g219 = ( float4( desaturateVar280_g219 , 0.0 ) * color295_g219 );
			float fbtotaltiles134_g219 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g219 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g219 = 1.0f / _Vector8.y;
			float fbspeed134_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g219 = float2(fbcolsoffset134_g219, fbrowsoffset134_g219);
			float fbcurrenttileindex134_g219 = floor( fmod( fbspeed134_g219 + 6.0, fbtotaltiles134_g219) );
			fbcurrenttileindex134_g219 += ( fbcurrenttileindex134_g219 < 0) ? fbtotaltiles134_g219 : 0;
			float fblinearindextox134_g219 = round ( fmod ( fbcurrenttileindex134_g219, _Vector8.x ) );
			float fboffsetx134_g219 = fblinearindextox134_g219 * fbcolsoffset134_g219;
			float fblinearindextoy134_g219 = round( fmod( ( fbcurrenttileindex134_g219 - fblinearindextox134_g219 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g219 = (int)(_Vector8.y-1) - fblinearindextoy134_g219;
			float fboffsety134_g219 = fblinearindextoy134_g219 * fbrowsoffset134_g219;
			float2 fboffset134_g219 = float2(fboffsetx134_g219, fboffsety134_g219);
			float2 fbuv134_g219 = i.uv2_texcoord2 * fbtiling134_g219 + fboffset134_g219;
			int flipbookFrame134_g219 = ( ( int )fbcurrenttileindex134_g219);
			float3 desaturateInitialColor281_g219 = ( float4( tex2D( _LightLightmap, fbuv134_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot281_g219 = dot( desaturateInitialColor281_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g219 = lerp( desaturateInitialColor281_g219, desaturateDot281_g219.xxx, 1.0 );
			float4 color296_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g219 = ( float4( desaturateVar281_g219 , 0.0 ) * color296_g219 );
			float4 _FinalLight7_9239_g219 = ( ( step( _VarAudioLink3_g219 , 0.4669 ) * _VarLight7121_g219 ) + ( step( _VarAudioLink3_g219 , 0.5336 ) * _VarLight8133_g219 ) + ( step( _VarAudioLink3_g219 , 0.6003 ) * _VarLight9142_g219 ) );
			float fbtotaltiles159_g219 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g219 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g219 = 1.0f / _Vector9.y;
			float fbspeed159_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g219 = float2(fbcolsoffset159_g219, fbrowsoffset159_g219);
			float fbcurrenttileindex159_g219 = floor( fmod( fbspeed159_g219 + 5.0, fbtotaltiles159_g219) );
			fbcurrenttileindex159_g219 += ( fbcurrenttileindex159_g219 < 0) ? fbtotaltiles159_g219 : 0;
			float fblinearindextox159_g219 = round ( fmod ( fbcurrenttileindex159_g219, _Vector9.x ) );
			float fboffsetx159_g219 = fblinearindextox159_g219 * fbcolsoffset159_g219;
			float fblinearindextoy159_g219 = round( fmod( ( fbcurrenttileindex159_g219 - fblinearindextox159_g219 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g219 = (int)(_Vector9.y-1) - fblinearindextoy159_g219;
			float fboffsety159_g219 = fblinearindextoy159_g219 * fbrowsoffset159_g219;
			float2 fboffset159_g219 = float2(fboffsetx159_g219, fboffsety159_g219);
			float2 fbuv159_g219 = i.uv2_texcoord2 * fbtiling159_g219 + fboffset159_g219;
			int flipbookFrame159_g219 = ( ( int )fbcurrenttileindex159_g219);
			float3 desaturateInitialColor284_g219 = ( float4( tex2D( _LightLightmap, fbuv159_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot284_g219 = dot( desaturateInitialColor284_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g219 = lerp( desaturateInitialColor284_g219, desaturateDot284_g219.xxx, 1.0 );
			float4 color299_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g219 = ( float4( desaturateVar284_g219 , 0.0 ) * color299_g219 );
			float fbtotaltiles165_g219 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g219 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g219 = 1.0f / _Vector10.y;
			float fbspeed165_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g219 = float2(fbcolsoffset165_g219, fbrowsoffset165_g219);
			float fbcurrenttileindex165_g219 = floor( fmod( fbspeed165_g219 + 4.0, fbtotaltiles165_g219) );
			fbcurrenttileindex165_g219 += ( fbcurrenttileindex165_g219 < 0) ? fbtotaltiles165_g219 : 0;
			float fblinearindextox165_g219 = round ( fmod ( fbcurrenttileindex165_g219, _Vector10.x ) );
			float fboffsetx165_g219 = fblinearindextox165_g219 * fbcolsoffset165_g219;
			float fblinearindextoy165_g219 = round( fmod( ( fbcurrenttileindex165_g219 - fblinearindextox165_g219 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g219 = (int)(_Vector10.y-1) - fblinearindextoy165_g219;
			float fboffsety165_g219 = fblinearindextoy165_g219 * fbrowsoffset165_g219;
			float2 fboffset165_g219 = float2(fboffsetx165_g219, fboffsety165_g219);
			float2 fbuv165_g219 = i.uv2_texcoord2 * fbtiling165_g219 + fboffset165_g219;
			int flipbookFrame165_g219 = ( ( int )fbcurrenttileindex165_g219);
			float3 desaturateInitialColor283_g219 = ( float4( tex2D( _LightLightmap, fbuv165_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot283_g219 = dot( desaturateInitialColor283_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g219 = lerp( desaturateInitialColor283_g219, desaturateDot283_g219.xxx, 1.0 );
			float4 color298_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g219 = ( float4( desaturateVar283_g219 , 0.0 ) * color298_g219 );
			float fbtotaltiles173_g219 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g219 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g219 = 1.0f / _Vector11.y;
			float fbspeed173_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g219 = float2(fbcolsoffset173_g219, fbrowsoffset173_g219);
			float fbcurrenttileindex173_g219 = floor( fmod( fbspeed173_g219 + 3.0, fbtotaltiles173_g219) );
			fbcurrenttileindex173_g219 += ( fbcurrenttileindex173_g219 < 0) ? fbtotaltiles173_g219 : 0;
			float fblinearindextox173_g219 = round ( fmod ( fbcurrenttileindex173_g219, _Vector11.x ) );
			float fboffsetx173_g219 = fblinearindextox173_g219 * fbcolsoffset173_g219;
			float fblinearindextoy173_g219 = round( fmod( ( fbcurrenttileindex173_g219 - fblinearindextox173_g219 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g219 = (int)(_Vector11.y-1) - fblinearindextoy173_g219;
			float fboffsety173_g219 = fblinearindextoy173_g219 * fbrowsoffset173_g219;
			float2 fboffset173_g219 = float2(fboffsetx173_g219, fboffsety173_g219);
			float2 fbuv173_g219 = i.uv2_texcoord2 * fbtiling173_g219 + fboffset173_g219;
			int flipbookFrame173_g219 = ( ( int )fbcurrenttileindex173_g219);
			float3 desaturateInitialColor282_g219 = ( float4( tex2D( _LightLightmap, fbuv173_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot282_g219 = dot( desaturateInitialColor282_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g219 = lerp( desaturateInitialColor282_g219, desaturateDot282_g219.xxx, 1.0 );
			float4 color297_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g219 = ( float4( desaturateVar282_g219 , 0.0 ) * color297_g219 );
			float4 _FinalLight10_12247_g219 = ( ( step( _VarAudioLink3_g219 , 0.667 ) * _VarLight10161_g219 ) + ( step( _VarAudioLink3_g219 , 0.7337 ) * _VarLight11172_g219 ) + ( step( _VarAudioLink3_g219 , 0.8004 ) * _VarLight12180_g219 ) );
			float fbtotaltiles189_g219 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g219 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g219 = 1.0f / _Vector12.y;
			float fbspeed189_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g219 = float2(fbcolsoffset189_g219, fbrowsoffset189_g219);
			float fbcurrenttileindex189_g219 = floor( fmod( fbspeed189_g219 + 2.0, fbtotaltiles189_g219) );
			fbcurrenttileindex189_g219 += ( fbcurrenttileindex189_g219 < 0) ? fbtotaltiles189_g219 : 0;
			float fblinearindextox189_g219 = round ( fmod ( fbcurrenttileindex189_g219, _Vector12.x ) );
			float fboffsetx189_g219 = fblinearindextox189_g219 * fbcolsoffset189_g219;
			float fblinearindextoy189_g219 = round( fmod( ( fbcurrenttileindex189_g219 - fblinearindextox189_g219 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g219 = (int)(_Vector12.y-1) - fblinearindextoy189_g219;
			float fboffsety189_g219 = fblinearindextoy189_g219 * fbrowsoffset189_g219;
			float2 fboffset189_g219 = float2(fboffsetx189_g219, fboffsety189_g219);
			float2 fbuv189_g219 = i.uv2_texcoord2 * fbtiling189_g219 + fboffset189_g219;
			int flipbookFrame189_g219 = ( ( int )fbcurrenttileindex189_g219);
			float3 desaturateInitialColor285_g219 = ( float4( tex2D( _LightLightmap, fbuv189_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot285_g219 = dot( desaturateInitialColor285_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g219 = lerp( desaturateInitialColor285_g219, desaturateDot285_g219.xxx, 1.0 );
			float4 color300_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g219 = ( float4( desaturateVar285_g219 , 0.0 ) * color300_g219 );
			float fbtotaltiles195_g219 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g219 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g219 = 1.0f / _Vector13.y;
			float fbspeed195_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g219 = float2(fbcolsoffset195_g219, fbrowsoffset195_g219);
			float fbcurrenttileindex195_g219 = floor( fmod( fbspeed195_g219 + 1.0, fbtotaltiles195_g219) );
			fbcurrenttileindex195_g219 += ( fbcurrenttileindex195_g219 < 0) ? fbtotaltiles195_g219 : 0;
			float fblinearindextox195_g219 = round ( fmod ( fbcurrenttileindex195_g219, _Vector13.x ) );
			float fboffsetx195_g219 = fblinearindextox195_g219 * fbcolsoffset195_g219;
			float fblinearindextoy195_g219 = round( fmod( ( fbcurrenttileindex195_g219 - fblinearindextox195_g219 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g219 = (int)(_Vector13.y-1) - fblinearindextoy195_g219;
			float fboffsety195_g219 = fblinearindextoy195_g219 * fbrowsoffset195_g219;
			float2 fboffset195_g219 = float2(fboffsetx195_g219, fboffsety195_g219);
			float2 fbuv195_g219 = i.uv2_texcoord2 * fbtiling195_g219 + fboffset195_g219;
			int flipbookFrame195_g219 = ( ( int )fbcurrenttileindex195_g219);
			float3 desaturateInitialColor286_g219 = ( float4( tex2D( _LightLightmap, fbuv195_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot286_g219 = dot( desaturateInitialColor286_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g219 = lerp( desaturateInitialColor286_g219, desaturateDot286_g219.xxx, 1.0 );
			float4 color301_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g219 = ( float4( desaturateVar286_g219 , 0.0 ) * color301_g219 );
			float fbtotaltiles203_g219 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g219 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g219 = 1.0f / _Vector14.y;
			float fbspeed203_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g219 = float2(fbcolsoffset203_g219, fbrowsoffset203_g219);
			float fbcurrenttileindex203_g219 = floor( fmod( fbspeed203_g219 + 0.0, fbtotaltiles203_g219) );
			fbcurrenttileindex203_g219 += ( fbcurrenttileindex203_g219 < 0) ? fbtotaltiles203_g219 : 0;
			float fblinearindextox203_g219 = round ( fmod ( fbcurrenttileindex203_g219, _Vector14.x ) );
			float fboffsetx203_g219 = fblinearindextox203_g219 * fbcolsoffset203_g219;
			float fblinearindextoy203_g219 = round( fmod( ( fbcurrenttileindex203_g219 - fblinearindextox203_g219 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g219 = (int)(_Vector14.y-1) - fblinearindextoy203_g219;
			float fboffsety203_g219 = fblinearindextoy203_g219 * fbrowsoffset203_g219;
			float2 fboffset203_g219 = float2(fboffsetx203_g219, fboffsety203_g219);
			float2 fbuv203_g219 = i.uv2_texcoord2 * fbtiling203_g219 + fboffset203_g219;
			int flipbookFrame203_g219 = ( ( int )fbcurrenttileindex203_g219);
			float3 desaturateInitialColor287_g219 = ( float4( tex2D( _LightLightmap, fbuv203_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot287_g219 = dot( desaturateInitialColor287_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g219 = lerp( desaturateInitialColor287_g219, desaturateDot287_g219.xxx, 1.0 );
			float4 color302_g219 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g219 = ( float4( desaturateVar287_g219 , 0.0 ) * color302_g219 );
			float4 _FinalLight13_15255_g219 = ( ( step( _VarAudioLink3_g219 , 0.8671 ) * _VarLight13191_g219 ) + ( step( _VarAudioLink3_g219 , 0.9338 ) * _VarLight14202_g219 ) + ( step( _VarAudioLink3_g219 , 1.0 ) * _VarLight15210_g219 ) );
			float fbtotaltiles339_g219 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g219 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g219 = 1.0f / _Vector15.y;
			float fbspeed339_g219 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g219 = float2(fbcolsoffset339_g219, fbrowsoffset339_g219);
			float fbcurrenttileindex339_g219 = floor( fmod( fbspeed339_g219 + 15.0, fbtotaltiles339_g219) );
			fbcurrenttileindex339_g219 += ( fbcurrenttileindex339_g219 < 0) ? fbtotaltiles339_g219 : 0;
			float fblinearindextox339_g219 = round ( fmod ( fbcurrenttileindex339_g219, _Vector15.x ) );
			float fboffsetx339_g219 = fblinearindextox339_g219 * fbcolsoffset339_g219;
			float fblinearindextoy339_g219 = round( fmod( ( fbcurrenttileindex339_g219 - fblinearindextox339_g219 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g219 = (int)(_Vector15.y-1) - fblinearindextoy339_g219;
			float fboffsety339_g219 = fblinearindextoy339_g219 * fbrowsoffset339_g219;
			float2 fboffset339_g219 = float2(fboffsetx339_g219, fboffsety339_g219);
			float2 fbuv339_g219 = i.uv2_texcoord2 * fbtiling339_g219 + fboffset339_g219;
			int flipbookFrame339_g219 = ( ( int )fbcurrenttileindex339_g219);
			float3 desaturateInitialColor347_g219 = ( float4( tex2D( _LightLightmap, fbuv339_g219 ).rgb , 0.0 ) * _VarColor146_g219 ).xyz;
			float desaturateDot347_g219 = dot( desaturateInitialColor347_g219, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g219 = lerp( desaturateInitialColor347_g219, desaturateDot347_g219.xxx, 1.0 );
			float4 color345_g219 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g219 = ( float4( desaturateVar347_g219 , 0.0 ) * color345_g219 );
			float4 _FinalLight16356_g219 = ( step( _VarAudioLink3_g219 , 0.0667 ) * _VarLight16350_g219 );
			float4 _FinalLights262_g219 = ( _FinalLight1_3223_g219 + _FinalLight4_6231_g219 + _FinalLight7_9239_g219 + _FinalLight10_12247_g219 + _FinalLight13_15255_g219 + _FinalLight16356_g219 );
			float4 temp_output_220_0 = _FinalLights262_g219;
			int Band3_g216 = (int)_BandBlue1;
			float Delay3_g216 = 0.0;
			float localAudioLinkLerp3_g216 = AudioLinkLerp3_g216( Band3_g216 , Delay3_g216 );
			float _VarAudioLink3_g215 = ( 1.0 - localAudioLinkLerp3_g216 );
			float fbtotaltiles52_g215 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g215 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g215 = 1.0f / _Vector0.y;
			float fbspeed52_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g215 = float2(fbcolsoffset52_g215, fbrowsoffset52_g215);
			float fbcurrenttileindex52_g215 = floor( fmod( fbspeed52_g215 + 14.0, fbtotaltiles52_g215) );
			fbcurrenttileindex52_g215 += ( fbcurrenttileindex52_g215 < 0) ? fbtotaltiles52_g215 : 0;
			float fblinearindextox52_g215 = round ( fmod ( fbcurrenttileindex52_g215, _Vector0.x ) );
			float fboffsetx52_g215 = fblinearindextox52_g215 * fbcolsoffset52_g215;
			float fblinearindextoy52_g215 = round( fmod( ( fbcurrenttileindex52_g215 - fblinearindextox52_g215 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g215 = (int)(_Vector0.y-1) - fblinearindextoy52_g215;
			float fboffsety52_g215 = fblinearindextoy52_g215 * fbrowsoffset52_g215;
			float2 fboffset52_g215 = float2(fboffsetx52_g215, fboffsety52_g215);
			float2 fbuv52_g215 = i.uv2_texcoord2 * fbtiling52_g215 + fboffset52_g215;
			int flipbookFrame52_g215 = ( ( int )fbcurrenttileindex52_g215);
			float4 color176 = IsGammaSpace() ? float4( 0, 0, 1, 0 ) : float4( 0, 0, 1, 0 );
			float4 _VarColor146_g215 = color176;
			float3 desaturateInitialColor276_g215 = ( float4( tex2D( _LightLightmap, fbuv52_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot276_g215 = dot( desaturateInitialColor276_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g215 = lerp( desaturateInitialColor276_g215, desaturateDot276_g215.xxx, 1.0 );
			float4 color288_g215 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g215 = ( float4( desaturateVar276_g215 , 0.0 ) * color288_g215 );
			float fbtotaltiles66_g215 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g215 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g215 = 1.0f / _Vector1.y;
			float fbspeed66_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g215 = float2(fbcolsoffset66_g215, fbrowsoffset66_g215);
			float fbcurrenttileindex66_g215 = floor( fmod( fbspeed66_g215 + 13.0, fbtotaltiles66_g215) );
			fbcurrenttileindex66_g215 += ( fbcurrenttileindex66_g215 < 0) ? fbtotaltiles66_g215 : 0;
			float fblinearindextox66_g215 = round ( fmod ( fbcurrenttileindex66_g215, _Vector1.x ) );
			float fboffsetx66_g215 = fblinearindextox66_g215 * fbcolsoffset66_g215;
			float fblinearindextoy66_g215 = round( fmod( ( fbcurrenttileindex66_g215 - fblinearindextox66_g215 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g215 = (int)(_Vector1.y-1) - fblinearindextoy66_g215;
			float fboffsety66_g215 = fblinearindextoy66_g215 * fbrowsoffset66_g215;
			float2 fboffset66_g215 = float2(fboffsetx66_g215, fboffsety66_g215);
			float2 fbuv66_g215 = i.uv2_texcoord2 * fbtiling66_g215 + fboffset66_g215;
			int flipbookFrame66_g215 = ( ( int )fbcurrenttileindex66_g215);
			float3 desaturateInitialColor277_g215 = ( float4( tex2D( _LightLightmap, fbuv66_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot277_g215 = dot( desaturateInitialColor277_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g215 = lerp( desaturateInitialColor277_g215, desaturateDot277_g215.xxx, 1.0 );
			float4 color289_g215 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g215 = ( float4( desaturateVar277_g215 , 0.0 ) * color289_g215 );
			float4 color290_g215 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g215 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g215 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g215 = 1.0f / _Vector2.y;
			float fbspeed76_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g215 = float2(fbcolsoffset76_g215, fbrowsoffset76_g215);
			float fbcurrenttileindex76_g215 = floor( fmod( fbspeed76_g215 + 12.0, fbtotaltiles76_g215) );
			fbcurrenttileindex76_g215 += ( fbcurrenttileindex76_g215 < 0) ? fbtotaltiles76_g215 : 0;
			float fblinearindextox76_g215 = round ( fmod ( fbcurrenttileindex76_g215, _Vector2.x ) );
			float fboffsetx76_g215 = fblinearindextox76_g215 * fbcolsoffset76_g215;
			float fblinearindextoy76_g215 = round( fmod( ( fbcurrenttileindex76_g215 - fblinearindextox76_g215 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g215 = (int)(_Vector2.y-1) - fblinearindextoy76_g215;
			float fboffsety76_g215 = fblinearindextoy76_g215 * fbrowsoffset76_g215;
			float2 fboffset76_g215 = float2(fboffsetx76_g215, fboffsety76_g215);
			float2 fbuv76_g215 = i.uv2_texcoord2 * fbtiling76_g215 + fboffset76_g215;
			int flipbookFrame76_g215 = ( ( int )fbcurrenttileindex76_g215);
			float3 desaturateInitialColor303_g215 = ( float4( tex2D( _LightLightmap, fbuv76_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot303_g215 = dot( desaturateInitialColor303_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g215 = lerp( desaturateInitialColor303_g215, desaturateDot303_g215.xxx, 1.0 );
			float4 _VarLight384_g215 = ( color290_g215 * float4( desaturateVar303_g215 , 0.0 ) );
			float4 _FinalLight1_3223_g215 = ( ( step( _VarAudioLink3_g215 , 0.0667 ) * _VarLight157_g215 ) + ( step( _VarAudioLink3_g215 , 0.1334 ) * _VarLight270_g215 ) + ( step( _VarAudioLink3_g215 , 0.2001 ) * _VarLight384_g215 ) );
			float fbtotaltiles86_g215 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g215 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g215 = 1.0f / _Vector3.y;
			float fbspeed86_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g215 = float2(fbcolsoffset86_g215, fbrowsoffset86_g215);
			float fbcurrenttileindex86_g215 = floor( fmod( fbspeed86_g215 + 11.0, fbtotaltiles86_g215) );
			fbcurrenttileindex86_g215 += ( fbcurrenttileindex86_g215 < 0) ? fbtotaltiles86_g215 : 0;
			float fblinearindextox86_g215 = round ( fmod ( fbcurrenttileindex86_g215, _Vector3.x ) );
			float fboffsetx86_g215 = fblinearindextox86_g215 * fbcolsoffset86_g215;
			float fblinearindextoy86_g215 = round( fmod( ( fbcurrenttileindex86_g215 - fblinearindextox86_g215 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g215 = (int)(_Vector3.y-1) - fblinearindextoy86_g215;
			float fboffsety86_g215 = fblinearindextoy86_g215 * fbrowsoffset86_g215;
			float2 fboffset86_g215 = float2(fboffsetx86_g215, fboffsety86_g215);
			float2 fbuv86_g215 = i.uv2_texcoord2 * fbtiling86_g215 + fboffset86_g215;
			int flipbookFrame86_g215 = ( ( int )fbcurrenttileindex86_g215);
			float3 desaturateInitialColor278_g215 = ( float4( tex2D( _LightLightmap, fbuv86_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot278_g215 = dot( desaturateInitialColor278_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g215 = lerp( desaturateInitialColor278_g215, desaturateDot278_g215.xxx, 1.0 );
			float4 color293_g215 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g215 = ( float4( desaturateVar278_g215 , 0.0 ) * color293_g215 );
			float fbtotaltiles96_g215 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g215 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g215 = 1.0f / _Vector4.y;
			float fbspeed96_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g215 = float2(fbcolsoffset96_g215, fbrowsoffset96_g215);
			float fbcurrenttileindex96_g215 = floor( fmod( fbspeed96_g215 + 10.0, fbtotaltiles96_g215) );
			fbcurrenttileindex96_g215 += ( fbcurrenttileindex96_g215 < 0) ? fbtotaltiles96_g215 : 0;
			float fblinearindextox96_g215 = round ( fmod ( fbcurrenttileindex96_g215, _Vector4.x ) );
			float fboffsetx96_g215 = fblinearindextox96_g215 * fbcolsoffset96_g215;
			float fblinearindextoy96_g215 = round( fmod( ( fbcurrenttileindex96_g215 - fblinearindextox96_g215 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g215 = (int)(_Vector4.y-1) - fblinearindextoy96_g215;
			float fboffsety96_g215 = fblinearindextoy96_g215 * fbrowsoffset96_g215;
			float2 fboffset96_g215 = float2(fboffsetx96_g215, fboffsety96_g215);
			float2 fbuv96_g215 = i.uv2_texcoord2 * fbtiling96_g215 + fboffset96_g215;
			int flipbookFrame96_g215 = ( ( int )fbcurrenttileindex96_g215);
			float3 desaturateInitialColor279_g215 = ( float4( tex2D( _LightLightmap, fbuv96_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot279_g215 = dot( desaturateInitialColor279_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g215 = lerp( desaturateInitialColor279_g215, desaturateDot279_g215.xxx, 1.0 );
			float4 color292_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g215 = ( float4( desaturateVar279_g215 , 0.0 ) * color292_g215 );
			float fbtotaltiles106_g215 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g215 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g215 = 1.0f / _Vector5.y;
			float fbspeed106_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g215 = float2(fbcolsoffset106_g215, fbrowsoffset106_g215);
			float fbcurrenttileindex106_g215 = floor( fmod( fbspeed106_g215 + 9.0, fbtotaltiles106_g215) );
			fbcurrenttileindex106_g215 += ( fbcurrenttileindex106_g215 < 0) ? fbtotaltiles106_g215 : 0;
			float fblinearindextox106_g215 = round ( fmod ( fbcurrenttileindex106_g215, _Vector5.x ) );
			float fboffsetx106_g215 = fblinearindextox106_g215 * fbcolsoffset106_g215;
			float fblinearindextoy106_g215 = round( fmod( ( fbcurrenttileindex106_g215 - fblinearindextox106_g215 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g215 = (int)(_Vector5.y-1) - fblinearindextoy106_g215;
			float fboffsety106_g215 = fblinearindextoy106_g215 * fbrowsoffset106_g215;
			float2 fboffset106_g215 = float2(fboffsetx106_g215, fboffsety106_g215);
			float2 fbuv106_g215 = i.uv2_texcoord2 * fbtiling106_g215 + fboffset106_g215;
			int flipbookFrame106_g215 = ( ( int )fbcurrenttileindex106_g215);
			float3 desaturateInitialColor316_g215 = ( float4( tex2D( _LightLightmap, fbuv106_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot316_g215 = dot( desaturateInitialColor316_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g215 = lerp( desaturateInitialColor316_g215, desaturateDot316_g215.xxx, 1.0 );
			float4 color291_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g215 = ( float4( desaturateVar316_g215 , 0.0 ) * color291_g215 );
			float4 _FinalLight4_6231_g215 = ( ( step( _VarAudioLink3_g215 , 0.2668 ) * _VarLight490_g215 ) + ( step( _VarAudioLink3_g215 , 0.3335 ) * _VarLight5104_g215 ) + ( step( _VarAudioLink3_g215 , 0.4002 ) * _VarLight6114_g215 ) );
			float fbtotaltiles118_g215 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g215 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g215 = 1.0f / _Vector6.y;
			float fbspeed118_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g215 = float2(fbcolsoffset118_g215, fbrowsoffset118_g215);
			float fbcurrenttileindex118_g215 = floor( fmod( fbspeed118_g215 + 8.0, fbtotaltiles118_g215) );
			fbcurrenttileindex118_g215 += ( fbcurrenttileindex118_g215 < 0) ? fbtotaltiles118_g215 : 0;
			float fblinearindextox118_g215 = round ( fmod ( fbcurrenttileindex118_g215, _Vector6.x ) );
			float fboffsetx118_g215 = fblinearindextox118_g215 * fbcolsoffset118_g215;
			float fblinearindextoy118_g215 = round( fmod( ( fbcurrenttileindex118_g215 - fblinearindextox118_g215 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g215 = (int)(_Vector6.y-1) - fblinearindextoy118_g215;
			float fboffsety118_g215 = fblinearindextoy118_g215 * fbrowsoffset118_g215;
			float2 fboffset118_g215 = float2(fboffsetx118_g215, fboffsety118_g215);
			float2 fbuv118_g215 = i.uv2_texcoord2 * fbtiling118_g215 + fboffset118_g215;
			int flipbookFrame118_g215 = ( ( int )fbcurrenttileindex118_g215);
			float3 desaturateInitialColor315_g215 = ( float4( tex2D( _LightLightmap, fbuv118_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot315_g215 = dot( desaturateInitialColor315_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g215 = lerp( desaturateInitialColor315_g215, desaturateDot315_g215.xxx, 1.0 );
			float4 color294_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g215 = ( float4( desaturateVar315_g215 , 0.0 ) * color294_g215 );
			float fbtotaltiles125_g215 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g215 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g215 = 1.0f / _Vector7.y;
			float fbspeed125_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g215 = float2(fbcolsoffset125_g215, fbrowsoffset125_g215);
			float fbcurrenttileindex125_g215 = floor( fmod( fbspeed125_g215 + 7.0, fbtotaltiles125_g215) );
			fbcurrenttileindex125_g215 += ( fbcurrenttileindex125_g215 < 0) ? fbtotaltiles125_g215 : 0;
			float fblinearindextox125_g215 = round ( fmod ( fbcurrenttileindex125_g215, _Vector7.x ) );
			float fboffsetx125_g215 = fblinearindextox125_g215 * fbcolsoffset125_g215;
			float fblinearindextoy125_g215 = round( fmod( ( fbcurrenttileindex125_g215 - fblinearindextox125_g215 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g215 = (int)(_Vector7.y-1) - fblinearindextoy125_g215;
			float fboffsety125_g215 = fblinearindextoy125_g215 * fbrowsoffset125_g215;
			float2 fboffset125_g215 = float2(fboffsetx125_g215, fboffsety125_g215);
			float2 fbuv125_g215 = i.uv2_texcoord2 * fbtiling125_g215 + fboffset125_g215;
			int flipbookFrame125_g215 = ( ( int )fbcurrenttileindex125_g215);
			float3 desaturateInitialColor280_g215 = ( float4( tex2D( _LightLightmap, fbuv125_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot280_g215 = dot( desaturateInitialColor280_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g215 = lerp( desaturateInitialColor280_g215, desaturateDot280_g215.xxx, 1.0 );
			float4 color295_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g215 = ( float4( desaturateVar280_g215 , 0.0 ) * color295_g215 );
			float fbtotaltiles134_g215 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g215 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g215 = 1.0f / _Vector8.y;
			float fbspeed134_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g215 = float2(fbcolsoffset134_g215, fbrowsoffset134_g215);
			float fbcurrenttileindex134_g215 = floor( fmod( fbspeed134_g215 + 6.0, fbtotaltiles134_g215) );
			fbcurrenttileindex134_g215 += ( fbcurrenttileindex134_g215 < 0) ? fbtotaltiles134_g215 : 0;
			float fblinearindextox134_g215 = round ( fmod ( fbcurrenttileindex134_g215, _Vector8.x ) );
			float fboffsetx134_g215 = fblinearindextox134_g215 * fbcolsoffset134_g215;
			float fblinearindextoy134_g215 = round( fmod( ( fbcurrenttileindex134_g215 - fblinearindextox134_g215 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g215 = (int)(_Vector8.y-1) - fblinearindextoy134_g215;
			float fboffsety134_g215 = fblinearindextoy134_g215 * fbrowsoffset134_g215;
			float2 fboffset134_g215 = float2(fboffsetx134_g215, fboffsety134_g215);
			float2 fbuv134_g215 = i.uv2_texcoord2 * fbtiling134_g215 + fboffset134_g215;
			int flipbookFrame134_g215 = ( ( int )fbcurrenttileindex134_g215);
			float3 desaturateInitialColor281_g215 = ( float4( tex2D( _LightLightmap, fbuv134_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot281_g215 = dot( desaturateInitialColor281_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g215 = lerp( desaturateInitialColor281_g215, desaturateDot281_g215.xxx, 1.0 );
			float4 color296_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g215 = ( float4( desaturateVar281_g215 , 0.0 ) * color296_g215 );
			float4 _FinalLight7_9239_g215 = ( ( step( _VarAudioLink3_g215 , 0.4669 ) * _VarLight7121_g215 ) + ( step( _VarAudioLink3_g215 , 0.5336 ) * _VarLight8133_g215 ) + ( step( _VarAudioLink3_g215 , 0.6003 ) * _VarLight9142_g215 ) );
			float fbtotaltiles159_g215 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g215 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g215 = 1.0f / _Vector9.y;
			float fbspeed159_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g215 = float2(fbcolsoffset159_g215, fbrowsoffset159_g215);
			float fbcurrenttileindex159_g215 = floor( fmod( fbspeed159_g215 + 5.0, fbtotaltiles159_g215) );
			fbcurrenttileindex159_g215 += ( fbcurrenttileindex159_g215 < 0) ? fbtotaltiles159_g215 : 0;
			float fblinearindextox159_g215 = round ( fmod ( fbcurrenttileindex159_g215, _Vector9.x ) );
			float fboffsetx159_g215 = fblinearindextox159_g215 * fbcolsoffset159_g215;
			float fblinearindextoy159_g215 = round( fmod( ( fbcurrenttileindex159_g215 - fblinearindextox159_g215 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g215 = (int)(_Vector9.y-1) - fblinearindextoy159_g215;
			float fboffsety159_g215 = fblinearindextoy159_g215 * fbrowsoffset159_g215;
			float2 fboffset159_g215 = float2(fboffsetx159_g215, fboffsety159_g215);
			float2 fbuv159_g215 = i.uv2_texcoord2 * fbtiling159_g215 + fboffset159_g215;
			int flipbookFrame159_g215 = ( ( int )fbcurrenttileindex159_g215);
			float3 desaturateInitialColor284_g215 = ( float4( tex2D( _LightLightmap, fbuv159_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot284_g215 = dot( desaturateInitialColor284_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g215 = lerp( desaturateInitialColor284_g215, desaturateDot284_g215.xxx, 1.0 );
			float4 color299_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g215 = ( float4( desaturateVar284_g215 , 0.0 ) * color299_g215 );
			float fbtotaltiles165_g215 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g215 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g215 = 1.0f / _Vector10.y;
			float fbspeed165_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g215 = float2(fbcolsoffset165_g215, fbrowsoffset165_g215);
			float fbcurrenttileindex165_g215 = floor( fmod( fbspeed165_g215 + 4.0, fbtotaltiles165_g215) );
			fbcurrenttileindex165_g215 += ( fbcurrenttileindex165_g215 < 0) ? fbtotaltiles165_g215 : 0;
			float fblinearindextox165_g215 = round ( fmod ( fbcurrenttileindex165_g215, _Vector10.x ) );
			float fboffsetx165_g215 = fblinearindextox165_g215 * fbcolsoffset165_g215;
			float fblinearindextoy165_g215 = round( fmod( ( fbcurrenttileindex165_g215 - fblinearindextox165_g215 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g215 = (int)(_Vector10.y-1) - fblinearindextoy165_g215;
			float fboffsety165_g215 = fblinearindextoy165_g215 * fbrowsoffset165_g215;
			float2 fboffset165_g215 = float2(fboffsetx165_g215, fboffsety165_g215);
			float2 fbuv165_g215 = i.uv2_texcoord2 * fbtiling165_g215 + fboffset165_g215;
			int flipbookFrame165_g215 = ( ( int )fbcurrenttileindex165_g215);
			float3 desaturateInitialColor283_g215 = ( float4( tex2D( _LightLightmap, fbuv165_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot283_g215 = dot( desaturateInitialColor283_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g215 = lerp( desaturateInitialColor283_g215, desaturateDot283_g215.xxx, 1.0 );
			float4 color298_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g215 = ( float4( desaturateVar283_g215 , 0.0 ) * color298_g215 );
			float fbtotaltiles173_g215 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g215 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g215 = 1.0f / _Vector11.y;
			float fbspeed173_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g215 = float2(fbcolsoffset173_g215, fbrowsoffset173_g215);
			float fbcurrenttileindex173_g215 = floor( fmod( fbspeed173_g215 + 3.0, fbtotaltiles173_g215) );
			fbcurrenttileindex173_g215 += ( fbcurrenttileindex173_g215 < 0) ? fbtotaltiles173_g215 : 0;
			float fblinearindextox173_g215 = round ( fmod ( fbcurrenttileindex173_g215, _Vector11.x ) );
			float fboffsetx173_g215 = fblinearindextox173_g215 * fbcolsoffset173_g215;
			float fblinearindextoy173_g215 = round( fmod( ( fbcurrenttileindex173_g215 - fblinearindextox173_g215 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g215 = (int)(_Vector11.y-1) - fblinearindextoy173_g215;
			float fboffsety173_g215 = fblinearindextoy173_g215 * fbrowsoffset173_g215;
			float2 fboffset173_g215 = float2(fboffsetx173_g215, fboffsety173_g215);
			float2 fbuv173_g215 = i.uv2_texcoord2 * fbtiling173_g215 + fboffset173_g215;
			int flipbookFrame173_g215 = ( ( int )fbcurrenttileindex173_g215);
			float3 desaturateInitialColor282_g215 = ( float4( tex2D( _LightLightmap, fbuv173_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot282_g215 = dot( desaturateInitialColor282_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g215 = lerp( desaturateInitialColor282_g215, desaturateDot282_g215.xxx, 1.0 );
			float4 color297_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g215 = ( float4( desaturateVar282_g215 , 0.0 ) * color297_g215 );
			float4 _FinalLight10_12247_g215 = ( ( step( _VarAudioLink3_g215 , 0.667 ) * _VarLight10161_g215 ) + ( step( _VarAudioLink3_g215 , 0.7337 ) * _VarLight11172_g215 ) + ( step( _VarAudioLink3_g215 , 0.8004 ) * _VarLight12180_g215 ) );
			float fbtotaltiles189_g215 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g215 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g215 = 1.0f / _Vector12.y;
			float fbspeed189_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g215 = float2(fbcolsoffset189_g215, fbrowsoffset189_g215);
			float fbcurrenttileindex189_g215 = floor( fmod( fbspeed189_g215 + 2.0, fbtotaltiles189_g215) );
			fbcurrenttileindex189_g215 += ( fbcurrenttileindex189_g215 < 0) ? fbtotaltiles189_g215 : 0;
			float fblinearindextox189_g215 = round ( fmod ( fbcurrenttileindex189_g215, _Vector12.x ) );
			float fboffsetx189_g215 = fblinearindextox189_g215 * fbcolsoffset189_g215;
			float fblinearindextoy189_g215 = round( fmod( ( fbcurrenttileindex189_g215 - fblinearindextox189_g215 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g215 = (int)(_Vector12.y-1) - fblinearindextoy189_g215;
			float fboffsety189_g215 = fblinearindextoy189_g215 * fbrowsoffset189_g215;
			float2 fboffset189_g215 = float2(fboffsetx189_g215, fboffsety189_g215);
			float2 fbuv189_g215 = i.uv2_texcoord2 * fbtiling189_g215 + fboffset189_g215;
			int flipbookFrame189_g215 = ( ( int )fbcurrenttileindex189_g215);
			float3 desaturateInitialColor285_g215 = ( float4( tex2D( _LightLightmap, fbuv189_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot285_g215 = dot( desaturateInitialColor285_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g215 = lerp( desaturateInitialColor285_g215, desaturateDot285_g215.xxx, 1.0 );
			float4 color300_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g215 = ( float4( desaturateVar285_g215 , 0.0 ) * color300_g215 );
			float fbtotaltiles195_g215 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g215 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g215 = 1.0f / _Vector13.y;
			float fbspeed195_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g215 = float2(fbcolsoffset195_g215, fbrowsoffset195_g215);
			float fbcurrenttileindex195_g215 = floor( fmod( fbspeed195_g215 + 1.0, fbtotaltiles195_g215) );
			fbcurrenttileindex195_g215 += ( fbcurrenttileindex195_g215 < 0) ? fbtotaltiles195_g215 : 0;
			float fblinearindextox195_g215 = round ( fmod ( fbcurrenttileindex195_g215, _Vector13.x ) );
			float fboffsetx195_g215 = fblinearindextox195_g215 * fbcolsoffset195_g215;
			float fblinearindextoy195_g215 = round( fmod( ( fbcurrenttileindex195_g215 - fblinearindextox195_g215 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g215 = (int)(_Vector13.y-1) - fblinearindextoy195_g215;
			float fboffsety195_g215 = fblinearindextoy195_g215 * fbrowsoffset195_g215;
			float2 fboffset195_g215 = float2(fboffsetx195_g215, fboffsety195_g215);
			float2 fbuv195_g215 = i.uv2_texcoord2 * fbtiling195_g215 + fboffset195_g215;
			int flipbookFrame195_g215 = ( ( int )fbcurrenttileindex195_g215);
			float3 desaturateInitialColor286_g215 = ( float4( tex2D( _LightLightmap, fbuv195_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot286_g215 = dot( desaturateInitialColor286_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g215 = lerp( desaturateInitialColor286_g215, desaturateDot286_g215.xxx, 1.0 );
			float4 color301_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g215 = ( float4( desaturateVar286_g215 , 0.0 ) * color301_g215 );
			float fbtotaltiles203_g215 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g215 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g215 = 1.0f / _Vector14.y;
			float fbspeed203_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g215 = float2(fbcolsoffset203_g215, fbrowsoffset203_g215);
			float fbcurrenttileindex203_g215 = floor( fmod( fbspeed203_g215 + 0.0, fbtotaltiles203_g215) );
			fbcurrenttileindex203_g215 += ( fbcurrenttileindex203_g215 < 0) ? fbtotaltiles203_g215 : 0;
			float fblinearindextox203_g215 = round ( fmod ( fbcurrenttileindex203_g215, _Vector14.x ) );
			float fboffsetx203_g215 = fblinearindextox203_g215 * fbcolsoffset203_g215;
			float fblinearindextoy203_g215 = round( fmod( ( fbcurrenttileindex203_g215 - fblinearindextox203_g215 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g215 = (int)(_Vector14.y-1) - fblinearindextoy203_g215;
			float fboffsety203_g215 = fblinearindextoy203_g215 * fbrowsoffset203_g215;
			float2 fboffset203_g215 = float2(fboffsetx203_g215, fboffsety203_g215);
			float2 fbuv203_g215 = i.uv2_texcoord2 * fbtiling203_g215 + fboffset203_g215;
			int flipbookFrame203_g215 = ( ( int )fbcurrenttileindex203_g215);
			float3 desaturateInitialColor287_g215 = ( float4( tex2D( _LightLightmap, fbuv203_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot287_g215 = dot( desaturateInitialColor287_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g215 = lerp( desaturateInitialColor287_g215, desaturateDot287_g215.xxx, 1.0 );
			float4 color302_g215 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g215 = ( float4( desaturateVar287_g215 , 0.0 ) * color302_g215 );
			float4 _FinalLight13_15255_g215 = ( ( step( _VarAudioLink3_g215 , 0.8671 ) * _VarLight13191_g215 ) + ( step( _VarAudioLink3_g215 , 0.9338 ) * _VarLight14202_g215 ) + ( step( _VarAudioLink3_g215 , 1.0 ) * _VarLight15210_g215 ) );
			float fbtotaltiles339_g215 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g215 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g215 = 1.0f / _Vector15.y;
			float fbspeed339_g215 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g215 = float2(fbcolsoffset339_g215, fbrowsoffset339_g215);
			float fbcurrenttileindex339_g215 = floor( fmod( fbspeed339_g215 + 15.0, fbtotaltiles339_g215) );
			fbcurrenttileindex339_g215 += ( fbcurrenttileindex339_g215 < 0) ? fbtotaltiles339_g215 : 0;
			float fblinearindextox339_g215 = round ( fmod ( fbcurrenttileindex339_g215, _Vector15.x ) );
			float fboffsetx339_g215 = fblinearindextox339_g215 * fbcolsoffset339_g215;
			float fblinearindextoy339_g215 = round( fmod( ( fbcurrenttileindex339_g215 - fblinearindextox339_g215 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g215 = (int)(_Vector15.y-1) - fblinearindextoy339_g215;
			float fboffsety339_g215 = fblinearindextoy339_g215 * fbrowsoffset339_g215;
			float2 fboffset339_g215 = float2(fboffsetx339_g215, fboffsety339_g215);
			float2 fbuv339_g215 = i.uv2_texcoord2 * fbtiling339_g215 + fboffset339_g215;
			int flipbookFrame339_g215 = ( ( int )fbcurrenttileindex339_g215);
			float3 desaturateInitialColor347_g215 = ( float4( tex2D( _LightLightmap, fbuv339_g215 ).rgb , 0.0 ) * _VarColor146_g215 ).xyz;
			float desaturateDot347_g215 = dot( desaturateInitialColor347_g215, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g215 = lerp( desaturateInitialColor347_g215, desaturateDot347_g215.xxx, 1.0 );
			float4 color345_g215 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g215 = ( float4( desaturateVar347_g215 , 0.0 ) * color345_g215 );
			float4 _FinalLight16356_g215 = ( step( _VarAudioLink3_g215 , 0.0667 ) * _VarLight16350_g215 );
			float4 _FinalLights262_g215 = ( _FinalLight1_3223_g215 + _FinalLight4_6231_g215 + _FinalLight7_9239_g215 + _FinalLight10_12247_g215 + _FinalLight13_15255_g215 + _FinalLight16356_g215 );
			float4 temp_output_179_0 = _FinalLights262_g215;
			float4 temp_output_190_0 = ( saturate( min( min( temp_output_221_0, temp_output_220_0 ), temp_output_179_0 ) ) * 1.0 );
			int Band3_g222 = (int)_BandWhite1;
			float Delay3_g222 = 0.0;
			float localAudioLinkLerp3_g222 = AudioLinkLerp3_g222( Band3_g222 , Delay3_g222 );
			float _VarAudioLink3_g221 = ( 1.0 - localAudioLinkLerp3_g222 );
			float fbtotaltiles52_g221 = _Vector0.x * _Vector0.y;
			float fbcolsoffset52_g221 = 1.0f / _Vector0.x;
			float fbrowsoffset52_g221 = 1.0f / _Vector0.y;
			float fbspeed52_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling52_g221 = float2(fbcolsoffset52_g221, fbrowsoffset52_g221);
			float fbcurrenttileindex52_g221 = floor( fmod( fbspeed52_g221 + 14.0, fbtotaltiles52_g221) );
			fbcurrenttileindex52_g221 += ( fbcurrenttileindex52_g221 < 0) ? fbtotaltiles52_g221 : 0;
			float fblinearindextox52_g221 = round ( fmod ( fbcurrenttileindex52_g221, _Vector0.x ) );
			float fboffsetx52_g221 = fblinearindextox52_g221 * fbcolsoffset52_g221;
			float fblinearindextoy52_g221 = round( fmod( ( fbcurrenttileindex52_g221 - fblinearindextox52_g221 ) / _Vector0.x, _Vector0.y ) );
			fblinearindextoy52_g221 = (int)(_Vector0.y-1) - fblinearindextoy52_g221;
			float fboffsety52_g221 = fblinearindextoy52_g221 * fbrowsoffset52_g221;
			float2 fboffset52_g221 = float2(fboffsetx52_g221, fboffsety52_g221);
			float2 fbuv52_g221 = i.uv2_texcoord2 * fbtiling52_g221 + fboffset52_g221;
			int flipbookFrame52_g221 = ( ( int )fbcurrenttileindex52_g221);
			float4 color187 = IsGammaSpace() ? float4( 0, 1, 0, 0 ) : float4( 0, 1, 0, 0 );
			float4 _VarColor146_g221 = color187;
			float3 desaturateInitialColor276_g221 = ( float4( tex2D( _LightLightmap, fbuv52_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot276_g221 = dot( desaturateInitialColor276_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar276_g221 = lerp( desaturateInitialColor276_g221, desaturateDot276_g221.xxx, 1.0 );
			float4 color288_g221 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight157_g221 = ( float4( desaturateVar276_g221 , 0.0 ) * color288_g221 );
			float fbtotaltiles66_g221 = _Vector1.x * _Vector1.y;
			float fbcolsoffset66_g221 = 1.0f / _Vector1.x;
			float fbrowsoffset66_g221 = 1.0f / _Vector1.y;
			float fbspeed66_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling66_g221 = float2(fbcolsoffset66_g221, fbrowsoffset66_g221);
			float fbcurrenttileindex66_g221 = floor( fmod( fbspeed66_g221 + 13.0, fbtotaltiles66_g221) );
			fbcurrenttileindex66_g221 += ( fbcurrenttileindex66_g221 < 0) ? fbtotaltiles66_g221 : 0;
			float fblinearindextox66_g221 = round ( fmod ( fbcurrenttileindex66_g221, _Vector1.x ) );
			float fboffsetx66_g221 = fblinearindextox66_g221 * fbcolsoffset66_g221;
			float fblinearindextoy66_g221 = round( fmod( ( fbcurrenttileindex66_g221 - fblinearindextox66_g221 ) / _Vector1.x, _Vector1.y ) );
			fblinearindextoy66_g221 = (int)(_Vector1.y-1) - fblinearindextoy66_g221;
			float fboffsety66_g221 = fblinearindextoy66_g221 * fbrowsoffset66_g221;
			float2 fboffset66_g221 = float2(fboffsetx66_g221, fboffsety66_g221);
			float2 fbuv66_g221 = i.uv2_texcoord2 * fbtiling66_g221 + fboffset66_g221;
			int flipbookFrame66_g221 = ( ( int )fbcurrenttileindex66_g221);
			float3 desaturateInitialColor277_g221 = ( float4( tex2D( _LightLightmap, fbuv66_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot277_g221 = dot( desaturateInitialColor277_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar277_g221 = lerp( desaturateInitialColor277_g221, desaturateDot277_g221.xxx, 1.0 );
			float4 color289_g221 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight270_g221 = ( float4( desaturateVar277_g221 , 0.0 ) * color289_g221 );
			float4 color290_g221 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float fbtotaltiles76_g221 = _Vector2.x * _Vector2.y;
			float fbcolsoffset76_g221 = 1.0f / _Vector2.x;
			float fbrowsoffset76_g221 = 1.0f / _Vector2.y;
			float fbspeed76_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling76_g221 = float2(fbcolsoffset76_g221, fbrowsoffset76_g221);
			float fbcurrenttileindex76_g221 = floor( fmod( fbspeed76_g221 + 12.0, fbtotaltiles76_g221) );
			fbcurrenttileindex76_g221 += ( fbcurrenttileindex76_g221 < 0) ? fbtotaltiles76_g221 : 0;
			float fblinearindextox76_g221 = round ( fmod ( fbcurrenttileindex76_g221, _Vector2.x ) );
			float fboffsetx76_g221 = fblinearindextox76_g221 * fbcolsoffset76_g221;
			float fblinearindextoy76_g221 = round( fmod( ( fbcurrenttileindex76_g221 - fblinearindextox76_g221 ) / _Vector2.x, _Vector2.y ) );
			fblinearindextoy76_g221 = (int)(_Vector2.y-1) - fblinearindextoy76_g221;
			float fboffsety76_g221 = fblinearindextoy76_g221 * fbrowsoffset76_g221;
			float2 fboffset76_g221 = float2(fboffsetx76_g221, fboffsety76_g221);
			float2 fbuv76_g221 = i.uv2_texcoord2 * fbtiling76_g221 + fboffset76_g221;
			int flipbookFrame76_g221 = ( ( int )fbcurrenttileindex76_g221);
			float3 desaturateInitialColor303_g221 = ( float4( tex2D( _LightLightmap, fbuv76_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot303_g221 = dot( desaturateInitialColor303_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar303_g221 = lerp( desaturateInitialColor303_g221, desaturateDot303_g221.xxx, 1.0 );
			float4 _VarLight384_g221 = ( color290_g221 * float4( desaturateVar303_g221 , 0.0 ) );
			float4 _FinalLight1_3223_g221 = ( ( step( _VarAudioLink3_g221 , 0.0667 ) * _VarLight157_g221 ) + ( step( _VarAudioLink3_g221 , 0.1334 ) * _VarLight270_g221 ) + ( step( _VarAudioLink3_g221 , 0.2001 ) * _VarLight384_g221 ) );
			float fbtotaltiles86_g221 = _Vector3.x * _Vector3.y;
			float fbcolsoffset86_g221 = 1.0f / _Vector3.x;
			float fbrowsoffset86_g221 = 1.0f / _Vector3.y;
			float fbspeed86_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling86_g221 = float2(fbcolsoffset86_g221, fbrowsoffset86_g221);
			float fbcurrenttileindex86_g221 = floor( fmod( fbspeed86_g221 + 11.0, fbtotaltiles86_g221) );
			fbcurrenttileindex86_g221 += ( fbcurrenttileindex86_g221 < 0) ? fbtotaltiles86_g221 : 0;
			float fblinearindextox86_g221 = round ( fmod ( fbcurrenttileindex86_g221, _Vector3.x ) );
			float fboffsetx86_g221 = fblinearindextox86_g221 * fbcolsoffset86_g221;
			float fblinearindextoy86_g221 = round( fmod( ( fbcurrenttileindex86_g221 - fblinearindextox86_g221 ) / _Vector3.x, _Vector3.y ) );
			fblinearindextoy86_g221 = (int)(_Vector3.y-1) - fblinearindextoy86_g221;
			float fboffsety86_g221 = fblinearindextoy86_g221 * fbrowsoffset86_g221;
			float2 fboffset86_g221 = float2(fboffsetx86_g221, fboffsety86_g221);
			float2 fbuv86_g221 = i.uv2_texcoord2 * fbtiling86_g221 + fboffset86_g221;
			int flipbookFrame86_g221 = ( ( int )fbcurrenttileindex86_g221);
			float3 desaturateInitialColor278_g221 = ( float4( tex2D( _LightLightmap, fbuv86_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot278_g221 = dot( desaturateInitialColor278_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar278_g221 = lerp( desaturateInitialColor278_g221, desaturateDot278_g221.xxx, 1.0 );
			float4 color293_g221 = IsGammaSpace() ? float4( 1, 0.8039216, 0.09019608, 0 ) : float4( 1, 0.6104956, 0.008568125, 0 );
			float4 _VarLight490_g221 = ( float4( desaturateVar278_g221 , 0.0 ) * color293_g221 );
			float fbtotaltiles96_g221 = _Vector4.x * _Vector4.y;
			float fbcolsoffset96_g221 = 1.0f / _Vector4.x;
			float fbrowsoffset96_g221 = 1.0f / _Vector4.y;
			float fbspeed96_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling96_g221 = float2(fbcolsoffset96_g221, fbrowsoffset96_g221);
			float fbcurrenttileindex96_g221 = floor( fmod( fbspeed96_g221 + 10.0, fbtotaltiles96_g221) );
			fbcurrenttileindex96_g221 += ( fbcurrenttileindex96_g221 < 0) ? fbtotaltiles96_g221 : 0;
			float fblinearindextox96_g221 = round ( fmod ( fbcurrenttileindex96_g221, _Vector4.x ) );
			float fboffsetx96_g221 = fblinearindextox96_g221 * fbcolsoffset96_g221;
			float fblinearindextoy96_g221 = round( fmod( ( fbcurrenttileindex96_g221 - fblinearindextox96_g221 ) / _Vector4.x, _Vector4.y ) );
			fblinearindextoy96_g221 = (int)(_Vector4.y-1) - fblinearindextoy96_g221;
			float fboffsety96_g221 = fblinearindextoy96_g221 * fbrowsoffset96_g221;
			float2 fboffset96_g221 = float2(fboffsetx96_g221, fboffsety96_g221);
			float2 fbuv96_g221 = i.uv2_texcoord2 * fbtiling96_g221 + fboffset96_g221;
			int flipbookFrame96_g221 = ( ( int )fbcurrenttileindex96_g221);
			float3 desaturateInitialColor279_g221 = ( float4( tex2D( _LightLightmap, fbuv96_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot279_g221 = dot( desaturateInitialColor279_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar279_g221 = lerp( desaturateInitialColor279_g221, desaturateDot279_g221.xxx, 1.0 );
			float4 color292_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight5104_g221 = ( float4( desaturateVar279_g221 , 0.0 ) * color292_g221 );
			float fbtotaltiles106_g221 = _Vector5.x * _Vector5.y;
			float fbcolsoffset106_g221 = 1.0f / _Vector5.x;
			float fbrowsoffset106_g221 = 1.0f / _Vector5.y;
			float fbspeed106_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling106_g221 = float2(fbcolsoffset106_g221, fbrowsoffset106_g221);
			float fbcurrenttileindex106_g221 = floor( fmod( fbspeed106_g221 + 9.0, fbtotaltiles106_g221) );
			fbcurrenttileindex106_g221 += ( fbcurrenttileindex106_g221 < 0) ? fbtotaltiles106_g221 : 0;
			float fblinearindextox106_g221 = round ( fmod ( fbcurrenttileindex106_g221, _Vector5.x ) );
			float fboffsetx106_g221 = fblinearindextox106_g221 * fbcolsoffset106_g221;
			float fblinearindextoy106_g221 = round( fmod( ( fbcurrenttileindex106_g221 - fblinearindextox106_g221 ) / _Vector5.x, _Vector5.y ) );
			fblinearindextoy106_g221 = (int)(_Vector5.y-1) - fblinearindextoy106_g221;
			float fboffsety106_g221 = fblinearindextoy106_g221 * fbrowsoffset106_g221;
			float2 fboffset106_g221 = float2(fboffsetx106_g221, fboffsety106_g221);
			float2 fbuv106_g221 = i.uv2_texcoord2 * fbtiling106_g221 + fboffset106_g221;
			int flipbookFrame106_g221 = ( ( int )fbcurrenttileindex106_g221);
			float3 desaturateInitialColor316_g221 = ( float4( tex2D( _LightLightmap, fbuv106_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot316_g221 = dot( desaturateInitialColor316_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar316_g221 = lerp( desaturateInitialColor316_g221, desaturateDot316_g221.xxx, 1.0 );
			float4 color291_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight6114_g221 = ( float4( desaturateVar316_g221 , 0.0 ) * color291_g221 );
			float4 _FinalLight4_6231_g221 = ( ( step( _VarAudioLink3_g221 , 0.2668 ) * _VarLight490_g221 ) + ( step( _VarAudioLink3_g221 , 0.3335 ) * _VarLight5104_g221 ) + ( step( _VarAudioLink3_g221 , 0.4002 ) * _VarLight6114_g221 ) );
			float fbtotaltiles118_g221 = _Vector6.x * _Vector6.y;
			float fbcolsoffset118_g221 = 1.0f / _Vector6.x;
			float fbrowsoffset118_g221 = 1.0f / _Vector6.y;
			float fbspeed118_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling118_g221 = float2(fbcolsoffset118_g221, fbrowsoffset118_g221);
			float fbcurrenttileindex118_g221 = floor( fmod( fbspeed118_g221 + 8.0, fbtotaltiles118_g221) );
			fbcurrenttileindex118_g221 += ( fbcurrenttileindex118_g221 < 0) ? fbtotaltiles118_g221 : 0;
			float fblinearindextox118_g221 = round ( fmod ( fbcurrenttileindex118_g221, _Vector6.x ) );
			float fboffsetx118_g221 = fblinearindextox118_g221 * fbcolsoffset118_g221;
			float fblinearindextoy118_g221 = round( fmod( ( fbcurrenttileindex118_g221 - fblinearindextox118_g221 ) / _Vector6.x, _Vector6.y ) );
			fblinearindextoy118_g221 = (int)(_Vector6.y-1) - fblinearindextoy118_g221;
			float fboffsety118_g221 = fblinearindextoy118_g221 * fbrowsoffset118_g221;
			float2 fboffset118_g221 = float2(fboffsetx118_g221, fboffsety118_g221);
			float2 fbuv118_g221 = i.uv2_texcoord2 * fbtiling118_g221 + fboffset118_g221;
			int flipbookFrame118_g221 = ( ( int )fbcurrenttileindex118_g221);
			float3 desaturateInitialColor315_g221 = ( float4( tex2D( _LightLightmap, fbuv118_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot315_g221 = dot( desaturateInitialColor315_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar315_g221 = lerp( desaturateInitialColor315_g221, desaturateDot315_g221.xxx, 1.0 );
			float4 color294_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight7121_g221 = ( float4( desaturateVar315_g221 , 0.0 ) * color294_g221 );
			float fbtotaltiles125_g221 = _Vector7.x * _Vector7.y;
			float fbcolsoffset125_g221 = 1.0f / _Vector7.x;
			float fbrowsoffset125_g221 = 1.0f / _Vector7.y;
			float fbspeed125_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling125_g221 = float2(fbcolsoffset125_g221, fbrowsoffset125_g221);
			float fbcurrenttileindex125_g221 = floor( fmod( fbspeed125_g221 + 7.0, fbtotaltiles125_g221) );
			fbcurrenttileindex125_g221 += ( fbcurrenttileindex125_g221 < 0) ? fbtotaltiles125_g221 : 0;
			float fblinearindextox125_g221 = round ( fmod ( fbcurrenttileindex125_g221, _Vector7.x ) );
			float fboffsetx125_g221 = fblinearindextox125_g221 * fbcolsoffset125_g221;
			float fblinearindextoy125_g221 = round( fmod( ( fbcurrenttileindex125_g221 - fblinearindextox125_g221 ) / _Vector7.x, _Vector7.y ) );
			fblinearindextoy125_g221 = (int)(_Vector7.y-1) - fblinearindextoy125_g221;
			float fboffsety125_g221 = fblinearindextoy125_g221 * fbrowsoffset125_g221;
			float2 fboffset125_g221 = float2(fboffsetx125_g221, fboffsety125_g221);
			float2 fbuv125_g221 = i.uv2_texcoord2 * fbtiling125_g221 + fboffset125_g221;
			int flipbookFrame125_g221 = ( ( int )fbcurrenttileindex125_g221);
			float3 desaturateInitialColor280_g221 = ( float4( tex2D( _LightLightmap, fbuv125_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot280_g221 = dot( desaturateInitialColor280_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar280_g221 = lerp( desaturateInitialColor280_g221, desaturateDot280_g221.xxx, 1.0 );
			float4 color295_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight8133_g221 = ( float4( desaturateVar280_g221 , 0.0 ) * color295_g221 );
			float fbtotaltiles134_g221 = _Vector8.x * _Vector8.y;
			float fbcolsoffset134_g221 = 1.0f / _Vector8.x;
			float fbrowsoffset134_g221 = 1.0f / _Vector8.y;
			float fbspeed134_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling134_g221 = float2(fbcolsoffset134_g221, fbrowsoffset134_g221);
			float fbcurrenttileindex134_g221 = floor( fmod( fbspeed134_g221 + 6.0, fbtotaltiles134_g221) );
			fbcurrenttileindex134_g221 += ( fbcurrenttileindex134_g221 < 0) ? fbtotaltiles134_g221 : 0;
			float fblinearindextox134_g221 = round ( fmod ( fbcurrenttileindex134_g221, _Vector8.x ) );
			float fboffsetx134_g221 = fblinearindextox134_g221 * fbcolsoffset134_g221;
			float fblinearindextoy134_g221 = round( fmod( ( fbcurrenttileindex134_g221 - fblinearindextox134_g221 ) / _Vector8.x, _Vector8.y ) );
			fblinearindextoy134_g221 = (int)(_Vector8.y-1) - fblinearindextoy134_g221;
			float fboffsety134_g221 = fblinearindextoy134_g221 * fbrowsoffset134_g221;
			float2 fboffset134_g221 = float2(fboffsetx134_g221, fboffsety134_g221);
			float2 fbuv134_g221 = i.uv2_texcoord2 * fbtiling134_g221 + fboffset134_g221;
			int flipbookFrame134_g221 = ( ( int )fbcurrenttileindex134_g221);
			float3 desaturateInitialColor281_g221 = ( float4( tex2D( _LightLightmap, fbuv134_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot281_g221 = dot( desaturateInitialColor281_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar281_g221 = lerp( desaturateInitialColor281_g221, desaturateDot281_g221.xxx, 1.0 );
			float4 color296_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight9142_g221 = ( float4( desaturateVar281_g221 , 0.0 ) * color296_g221 );
			float4 _FinalLight7_9239_g221 = ( ( step( _VarAudioLink3_g221 , 0.4669 ) * _VarLight7121_g221 ) + ( step( _VarAudioLink3_g221 , 0.5336 ) * _VarLight8133_g221 ) + ( step( _VarAudioLink3_g221 , 0.6003 ) * _VarLight9142_g221 ) );
			float fbtotaltiles159_g221 = _Vector9.x * _Vector9.y;
			float fbcolsoffset159_g221 = 1.0f / _Vector9.x;
			float fbrowsoffset159_g221 = 1.0f / _Vector9.y;
			float fbspeed159_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling159_g221 = float2(fbcolsoffset159_g221, fbrowsoffset159_g221);
			float fbcurrenttileindex159_g221 = floor( fmod( fbspeed159_g221 + 5.0, fbtotaltiles159_g221) );
			fbcurrenttileindex159_g221 += ( fbcurrenttileindex159_g221 < 0) ? fbtotaltiles159_g221 : 0;
			float fblinearindextox159_g221 = round ( fmod ( fbcurrenttileindex159_g221, _Vector9.x ) );
			float fboffsetx159_g221 = fblinearindextox159_g221 * fbcolsoffset159_g221;
			float fblinearindextoy159_g221 = round( fmod( ( fbcurrenttileindex159_g221 - fblinearindextox159_g221 ) / _Vector9.x, _Vector9.y ) );
			fblinearindextoy159_g221 = (int)(_Vector9.y-1) - fblinearindextoy159_g221;
			float fboffsety159_g221 = fblinearindextoy159_g221 * fbrowsoffset159_g221;
			float2 fboffset159_g221 = float2(fboffsetx159_g221, fboffsety159_g221);
			float2 fbuv159_g221 = i.uv2_texcoord2 * fbtiling159_g221 + fboffset159_g221;
			int flipbookFrame159_g221 = ( ( int )fbcurrenttileindex159_g221);
			float3 desaturateInitialColor284_g221 = ( float4( tex2D( _LightLightmap, fbuv159_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot284_g221 = dot( desaturateInitialColor284_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar284_g221 = lerp( desaturateInitialColor284_g221, desaturateDot284_g221.xxx, 1.0 );
			float4 color299_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight10161_g221 = ( float4( desaturateVar284_g221 , 0.0 ) * color299_g221 );
			float fbtotaltiles165_g221 = _Vector10.x * _Vector10.y;
			float fbcolsoffset165_g221 = 1.0f / _Vector10.x;
			float fbrowsoffset165_g221 = 1.0f / _Vector10.y;
			float fbspeed165_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling165_g221 = float2(fbcolsoffset165_g221, fbrowsoffset165_g221);
			float fbcurrenttileindex165_g221 = floor( fmod( fbspeed165_g221 + 4.0, fbtotaltiles165_g221) );
			fbcurrenttileindex165_g221 += ( fbcurrenttileindex165_g221 < 0) ? fbtotaltiles165_g221 : 0;
			float fblinearindextox165_g221 = round ( fmod ( fbcurrenttileindex165_g221, _Vector10.x ) );
			float fboffsetx165_g221 = fblinearindextox165_g221 * fbcolsoffset165_g221;
			float fblinearindextoy165_g221 = round( fmod( ( fbcurrenttileindex165_g221 - fblinearindextox165_g221 ) / _Vector10.x, _Vector10.y ) );
			fblinearindextoy165_g221 = (int)(_Vector10.y-1) - fblinearindextoy165_g221;
			float fboffsety165_g221 = fblinearindextoy165_g221 * fbrowsoffset165_g221;
			float2 fboffset165_g221 = float2(fboffsetx165_g221, fboffsety165_g221);
			float2 fbuv165_g221 = i.uv2_texcoord2 * fbtiling165_g221 + fboffset165_g221;
			int flipbookFrame165_g221 = ( ( int )fbcurrenttileindex165_g221);
			float3 desaturateInitialColor283_g221 = ( float4( tex2D( _LightLightmap, fbuv165_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot283_g221 = dot( desaturateInitialColor283_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar283_g221 = lerp( desaturateInitialColor283_g221, desaturateDot283_g221.xxx, 1.0 );
			float4 color298_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight11172_g221 = ( float4( desaturateVar283_g221 , 0.0 ) * color298_g221 );
			float fbtotaltiles173_g221 = _Vector11.x * _Vector11.y;
			float fbcolsoffset173_g221 = 1.0f / _Vector11.x;
			float fbrowsoffset173_g221 = 1.0f / _Vector11.y;
			float fbspeed173_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling173_g221 = float2(fbcolsoffset173_g221, fbrowsoffset173_g221);
			float fbcurrenttileindex173_g221 = floor( fmod( fbspeed173_g221 + 3.0, fbtotaltiles173_g221) );
			fbcurrenttileindex173_g221 += ( fbcurrenttileindex173_g221 < 0) ? fbtotaltiles173_g221 : 0;
			float fblinearindextox173_g221 = round ( fmod ( fbcurrenttileindex173_g221, _Vector11.x ) );
			float fboffsetx173_g221 = fblinearindextox173_g221 * fbcolsoffset173_g221;
			float fblinearindextoy173_g221 = round( fmod( ( fbcurrenttileindex173_g221 - fblinearindextox173_g221 ) / _Vector11.x, _Vector11.y ) );
			fblinearindextoy173_g221 = (int)(_Vector11.y-1) - fblinearindextoy173_g221;
			float fboffsety173_g221 = fblinearindextoy173_g221 * fbrowsoffset173_g221;
			float2 fboffset173_g221 = float2(fboffsetx173_g221, fboffsety173_g221);
			float2 fbuv173_g221 = i.uv2_texcoord2 * fbtiling173_g221 + fboffset173_g221;
			int flipbookFrame173_g221 = ( ( int )fbcurrenttileindex173_g221);
			float3 desaturateInitialColor282_g221 = ( float4( tex2D( _LightLightmap, fbuv173_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot282_g221 = dot( desaturateInitialColor282_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar282_g221 = lerp( desaturateInitialColor282_g221, desaturateDot282_g221.xxx, 1.0 );
			float4 color297_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight12180_g221 = ( float4( desaturateVar282_g221 , 0.0 ) * color297_g221 );
			float4 _FinalLight10_12247_g221 = ( ( step( _VarAudioLink3_g221 , 0.667 ) * _VarLight10161_g221 ) + ( step( _VarAudioLink3_g221 , 0.7337 ) * _VarLight11172_g221 ) + ( step( _VarAudioLink3_g221 , 0.8004 ) * _VarLight12180_g221 ) );
			float fbtotaltiles189_g221 = _Vector12.x * _Vector12.y;
			float fbcolsoffset189_g221 = 1.0f / _Vector12.x;
			float fbrowsoffset189_g221 = 1.0f / _Vector12.y;
			float fbspeed189_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling189_g221 = float2(fbcolsoffset189_g221, fbrowsoffset189_g221);
			float fbcurrenttileindex189_g221 = floor( fmod( fbspeed189_g221 + 2.0, fbtotaltiles189_g221) );
			fbcurrenttileindex189_g221 += ( fbcurrenttileindex189_g221 < 0) ? fbtotaltiles189_g221 : 0;
			float fblinearindextox189_g221 = round ( fmod ( fbcurrenttileindex189_g221, _Vector12.x ) );
			float fboffsetx189_g221 = fblinearindextox189_g221 * fbcolsoffset189_g221;
			float fblinearindextoy189_g221 = round( fmod( ( fbcurrenttileindex189_g221 - fblinearindextox189_g221 ) / _Vector12.x, _Vector12.y ) );
			fblinearindextoy189_g221 = (int)(_Vector12.y-1) - fblinearindextoy189_g221;
			float fboffsety189_g221 = fblinearindextoy189_g221 * fbrowsoffset189_g221;
			float2 fboffset189_g221 = float2(fboffsetx189_g221, fboffsety189_g221);
			float2 fbuv189_g221 = i.uv2_texcoord2 * fbtiling189_g221 + fboffset189_g221;
			int flipbookFrame189_g221 = ( ( int )fbcurrenttileindex189_g221);
			float3 desaturateInitialColor285_g221 = ( float4( tex2D( _LightLightmap, fbuv189_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot285_g221 = dot( desaturateInitialColor285_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar285_g221 = lerp( desaturateInitialColor285_g221, desaturateDot285_g221.xxx, 1.0 );
			float4 color300_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight13191_g221 = ( float4( desaturateVar285_g221 , 0.0 ) * color300_g221 );
			float fbtotaltiles195_g221 = _Vector13.x * _Vector13.y;
			float fbcolsoffset195_g221 = 1.0f / _Vector13.x;
			float fbrowsoffset195_g221 = 1.0f / _Vector13.y;
			float fbspeed195_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling195_g221 = float2(fbcolsoffset195_g221, fbrowsoffset195_g221);
			float fbcurrenttileindex195_g221 = floor( fmod( fbspeed195_g221 + 1.0, fbtotaltiles195_g221) );
			fbcurrenttileindex195_g221 += ( fbcurrenttileindex195_g221 < 0) ? fbtotaltiles195_g221 : 0;
			float fblinearindextox195_g221 = round ( fmod ( fbcurrenttileindex195_g221, _Vector13.x ) );
			float fboffsetx195_g221 = fblinearindextox195_g221 * fbcolsoffset195_g221;
			float fblinearindextoy195_g221 = round( fmod( ( fbcurrenttileindex195_g221 - fblinearindextox195_g221 ) / _Vector13.x, _Vector13.y ) );
			fblinearindextoy195_g221 = (int)(_Vector13.y-1) - fblinearindextoy195_g221;
			float fboffsety195_g221 = fblinearindextoy195_g221 * fbrowsoffset195_g221;
			float2 fboffset195_g221 = float2(fboffsetx195_g221, fboffsety195_g221);
			float2 fbuv195_g221 = i.uv2_texcoord2 * fbtiling195_g221 + fboffset195_g221;
			int flipbookFrame195_g221 = ( ( int )fbcurrenttileindex195_g221);
			float3 desaturateInitialColor286_g221 = ( float4( tex2D( _LightLightmap, fbuv195_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot286_g221 = dot( desaturateInitialColor286_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar286_g221 = lerp( desaturateInitialColor286_g221, desaturateDot286_g221.xxx, 1.0 );
			float4 color301_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 1 ) : float4( 0.05126947, 0.9130987, 0.06301003, 1 );
			float4 _VarLight14202_g221 = ( float4( desaturateVar286_g221 , 0.0 ) * color301_g221 );
			float fbtotaltiles203_g221 = _Vector14.x * _Vector14.y;
			float fbcolsoffset203_g221 = 1.0f / _Vector14.x;
			float fbrowsoffset203_g221 = 1.0f / _Vector14.y;
			float fbspeed203_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling203_g221 = float2(fbcolsoffset203_g221, fbrowsoffset203_g221);
			float fbcurrenttileindex203_g221 = floor( fmod( fbspeed203_g221 + 0.0, fbtotaltiles203_g221) );
			fbcurrenttileindex203_g221 += ( fbcurrenttileindex203_g221 < 0) ? fbtotaltiles203_g221 : 0;
			float fblinearindextox203_g221 = round ( fmod ( fbcurrenttileindex203_g221, _Vector14.x ) );
			float fboffsetx203_g221 = fblinearindextox203_g221 * fbcolsoffset203_g221;
			float fblinearindextoy203_g221 = round( fmod( ( fbcurrenttileindex203_g221 - fblinearindextox203_g221 ) / _Vector14.x, _Vector14.y ) );
			fblinearindextoy203_g221 = (int)(_Vector14.y-1) - fblinearindextoy203_g221;
			float fboffsety203_g221 = fblinearindextoy203_g221 * fbrowsoffset203_g221;
			float2 fboffset203_g221 = float2(fboffsetx203_g221, fboffsety203_g221);
			float2 fbuv203_g221 = i.uv2_texcoord2 * fbtiling203_g221 + fboffset203_g221;
			int flipbookFrame203_g221 = ( ( int )fbcurrenttileindex203_g221);
			float3 desaturateInitialColor287_g221 = ( float4( tex2D( _LightLightmap, fbuv203_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot287_g221 = dot( desaturateInitialColor287_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar287_g221 = lerp( desaturateInitialColor287_g221, desaturateDot287_g221.xxx, 1.0 );
			float4 color302_g221 = IsGammaSpace() ? float4( 0.2509804, 0.9607843, 0.2784314, 0 ) : float4( 0.05126947, 0.9130987, 0.06301003, 0 );
			float4 _VarLight15210_g221 = ( float4( desaturateVar287_g221 , 0.0 ) * color302_g221 );
			float4 _FinalLight13_15255_g221 = ( ( step( _VarAudioLink3_g221 , 0.8671 ) * _VarLight13191_g221 ) + ( step( _VarAudioLink3_g221 , 0.9338 ) * _VarLight14202_g221 ) + ( step( _VarAudioLink3_g221 , 1.0 ) * _VarLight15210_g221 ) );
			float fbtotaltiles339_g221 = _Vector15.x * _Vector15.y;
			float fbcolsoffset339_g221 = 1.0f / _Vector15.x;
			float fbrowsoffset339_g221 = 1.0f / _Vector15.y;
			float fbspeed339_g221 = _Time[ 1 ] * 0.0;
			float2 fbtiling339_g221 = float2(fbcolsoffset339_g221, fbrowsoffset339_g221);
			float fbcurrenttileindex339_g221 = floor( fmod( fbspeed339_g221 + 15.0, fbtotaltiles339_g221) );
			fbcurrenttileindex339_g221 += ( fbcurrenttileindex339_g221 < 0) ? fbtotaltiles339_g221 : 0;
			float fblinearindextox339_g221 = round ( fmod ( fbcurrenttileindex339_g221, _Vector15.x ) );
			float fboffsetx339_g221 = fblinearindextox339_g221 * fbcolsoffset339_g221;
			float fblinearindextoy339_g221 = round( fmod( ( fbcurrenttileindex339_g221 - fblinearindextox339_g221 ) / _Vector15.x, _Vector15.y ) );
			fblinearindextoy339_g221 = (int)(_Vector15.y-1) - fblinearindextoy339_g221;
			float fboffsety339_g221 = fblinearindextoy339_g221 * fbrowsoffset339_g221;
			float2 fboffset339_g221 = float2(fboffsetx339_g221, fboffsety339_g221);
			float2 fbuv339_g221 = i.uv2_texcoord2 * fbtiling339_g221 + fboffset339_g221;
			int flipbookFrame339_g221 = ( ( int )fbcurrenttileindex339_g221);
			float3 desaturateInitialColor347_g221 = ( float4( tex2D( _LightLightmap, fbuv339_g221 ).rgb , 0.0 ) * _VarColor146_g221 ).xyz;
			float desaturateDot347_g221 = dot( desaturateInitialColor347_g221, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar347_g221 = lerp( desaturateInitialColor347_g221, desaturateDot347_g221.xxx, 1.0 );
			float4 color345_g221 = IsGammaSpace() ? float4( 1, 0.2078431, 0.09019608, 1 ) : float4( 1, 0.0356013, 0.008568125, 1 );
			float4 _VarLight16350_g221 = ( float4( desaturateVar347_g221 , 0.0 ) * color345_g221 );
			float4 _FinalLight16356_g221 = ( step( _VarAudioLink3_g221 , 0.0667 ) * _VarLight16350_g221 );
			float4 _FinalLights262_g221 = ( _FinalLight1_3223_g221 + _FinalLight4_6231_g221 + _FinalLight7_9239_g221 + _FinalLight10_12247_g221 + _FinalLight13_15255_g221 + _FinalLight16356_g221 );
			float4 _FinalEmission214 = ( _LightEmission * saturate( ( saturate( ( ( temp_output_221_0 - temp_output_190_0 ) * _Red ) ) + saturate( ( ( temp_output_220_0 - temp_output_190_0 ) * _Green ) ) + saturate( ( ( ( temp_output_179_0 * 1.0 ) - temp_output_190_0 ) * _Blue ) ) + saturate( ( _FinalLights262_g221 * _White ) ) ) ) );
			o.Emission = _FinalEmission214.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19909
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;173;-3418.333,428.0188;Inherit;False;2604.105;1239.881;;39;214;212;210;209;208;207;206;205;204;203;202;201;200;199;198;197;196;195;194;193;192;191;190;189;188;187;186;185;184;183;182;181;179;178;177;176;175;220;221;Lights;1,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-3338.333,1260.019;Inherit;False;Property;_BandBlue1;BandBlue;9;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;-3370.333,1068.019;Inherit;False;Constant;_CBlue1;CBlue;8;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;177;-3338.333,972.0188;Inherit;False;Property;_BandGreen1;BandGreen;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;178;-3370.333,780.0188;Inherit;False;Constant;_CGreen1;CGreen;7;0;Create;True;0;0;0;False;0;False;0,1,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;179;-3104,1072;Inherit;False;Lights;0;;215;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;220;-3072,816;Inherit;False;Lights;0;;219;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-2730.333,1116.019;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;182;-2650.333,1356.019;Inherit;False;Constant;_Float32;Float 32;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;183;-3322.333,668.0188;Inherit;False;Property;_BandRed1;BandRed;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;184;-3370.333,476.0188;Inherit;False;Constant;_CRed1;CRed;5;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;185;-2618.333,1116.019;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;186;-3306.333,1548.019;Inherit;False;Property;_BandWhite1;BandWhite;10;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;188;-2666.333,1228.019;Inherit;False;Constant;_asdf;asdf;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;187;-3360,1344;Inherit;False;Constant;_CWhite1;CWhite;9;0;Create;True;0;0;0;False;0;False;0,1,0,0;1,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;189;-2442.333,1292.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;190;-2458.333,1116.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;192;-2426.333,1500.019;Inherit;False;Property;_White;White;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;191;-3104,1344;Inherit;False;Lights;0;;221;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;221;-3088,528;Inherit;False;Lights;0;;223;cc03b07236e8436448b24513a749388f;0;3;61;SAMPLER2D;0,0,0;False;145;FLOAT4;0,0,0,0;False;263;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;193;-2218.333,1228.019;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;194;-2202.333,1324.019;Inherit;False;Property;_Blue;Blue;3;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;195;-2234.333,652.0188;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;196;-2234.333,908.0188;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-2234.333,1020.019;Inherit;False;Property;_Green;Green;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;198;-2234.333,748.0188;Inherit;False;Property;_Red;Red;5;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;199;-2266.333,1436.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;200;-2074.333,1228.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;201;-2106.333,652.0188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-2106.333,908.0188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-2122.333,1436.019;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-1930.333,1228.019;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-1962.333,908.0188;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-1962.333,652.0188;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-1754.333,1308.019;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-1738.333,940.0188;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;209;-1626.333,844.0188;Inherit;False;Property;_LightEmission;LightEmission;2;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;210;-1610.333,940.0188;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;212;-1450.333,940.0188;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;214;-1146.333,940.0188;Inherit;False;_FinalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;-544,528;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Banana/BaseLightsN;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;179;145;176;0
WireConnection;179;263;175;0
WireConnection;220;145;178;0
WireConnection;220;263;177;0
WireConnection;181;0;221;0
WireConnection;181;1;220;0
WireConnection;181;2;179;0
WireConnection;185;0;181;0
WireConnection;189;0;179;0
WireConnection;189;1;182;0
WireConnection;190;0;185;0
WireConnection;190;1;188;0
WireConnection;191;145;187;0
WireConnection;191;263;186;0
WireConnection;221;145;184;0
WireConnection;221;263;183;0
WireConnection;193;0;189;0
WireConnection;193;1;190;0
WireConnection;195;0;221;0
WireConnection;195;1;190;0
WireConnection;196;0;220;0
WireConnection;196;1;190;0
WireConnection;199;0;191;0
WireConnection;199;1;192;0
WireConnection;200;0;193;0
WireConnection;200;1;194;0
WireConnection;201;0;195;0
WireConnection;201;1;198;0
WireConnection;202;0;196;0
WireConnection;202;1;197;0
WireConnection;203;0;199;0
WireConnection;204;0;200;0
WireConnection;205;0;202;0
WireConnection;206;0;201;0
WireConnection;207;0;203;0
WireConnection;208;0;206;0
WireConnection;208;1;205;0
WireConnection;208;2;204;0
WireConnection;208;3;207;0
WireConnection;210;0;208;0
WireConnection;212;0;209;0
WireConnection;212;1;210;0
WireConnection;214;0;212;0
WireConnection;0;2;214;0
ASEEND*/
//CHKSM=E9AE0DDE0B499D3197451B6F6B8BC8AEA2F1AA1B