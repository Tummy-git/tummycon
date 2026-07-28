// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/ScreenDisplayCDJ3000"
{
	Properties
	{
		_Smoothing("Smoothing", Float) = 0.01
		_Delay("Delay", Range( 1 , 127)) = 127
		_ScreenPixel("Screen Pixel", 2D) = "white" {}
		_Resolutioin("Resolutioin", Vector) = (720,1280,0,0)
		_ScreenPixelEmission("Screen Pixel Emission", Int) = 1
		_BaseEmission("Base Emission", Float) = 1
		_BaseBandColor("Base Band Color", Color) = (0,0.1761498,1,0)
		_BaseBandColorEmission("Base Band Color Emission", Float) = 1
		_TrebelBandColor("Trebel Band Color", Color) = (0.7058824,0.4117647,0.03529412,0)
		_TrebelBandColorEmission("Trebel Band Color Emission", Float) = 1
		_LowBandColor("Low Band Color", Color) = (1,0.07371522,0,0)
		_LowBandColorEmission("Low Band Color Emission", Float) = 1
		_HighBandColor("High Band Color", Color) = (0.09793162,1,0,0)
		_HighBandColorEmission("High Band Color Emission", Float) = 1
		_Screen("Screen", 2D) = "white" {}
		_Move("Move", 2D) = "white" {}
		_BaseTextureEmission("Base Texture Emission", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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

			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
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

			uniform sampler2D _ScreenPixel;
			uniform float2 _Resolutioin;
			uniform int _ScreenPixelEmission;
			uniform sampler2D _Screen;
			uniform float4 _Screen_ST;
			uniform float _BaseTextureEmission;
			uniform float _Delay;
			uniform float _Smoothing;
			uniform float4 _HighBandColor;
			uniform float _HighBandColorEmission;
			uniform float4 _LowBandColor;
			uniform float _LowBandColorEmission;
			uniform float4 _TrebelBandColor;
			uniform float _TrebelBandColorEmission;
			uniform float4 _BaseBandColor;
			uniform float _BaseBandColorEmission;
			uniform float _BaseEmission;
			uniform sampler2D _Move;
			inline float AudioLinkLerp3_g109( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g60( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g99( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g108( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g128( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g132( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g130( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g129( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g111( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g96( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g100( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			
			inline float AudioLinkLerp3_g112( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord2.xy;
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
				float2 Resoluition463 = _Resolutioin;
				float2 texCoord466 = i.ase_texcoord1.xy * Resoluition463 + float2( 0,0 );
				float2 uv_Screen = i.ase_texcoord1.xy * _Screen_ST.xy + _Screen_ST.zw;
				int Band3_g109 = (int)3.0;
				float2 texCoord166 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay300 = _Delay;
				float Delay3_g109 = ( texCoord166.x * Delay300 );
				float localAudioLinkLerp3_g109 = AudioLinkLerp3_g109( Band3_g109 , Delay3_g109 );
				float LinesHightX704 = 1.65;
				float2 texCoord161 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float Smoothing176 = _Smoothing;
				float temp_output_163_0 = ( saturate( ( ( localAudioLinkLerp3_g109 * 0.1 ) - abs( ( LinesHightX704 - texCoord161.y ) ) ) ) / Smoothing176 );
				float3 temp_cast_1 = (saturate( temp_output_163_0 )).xxx;
				float3 desaturateInitialColor392 = temp_cast_1;
				float desaturateDot392 = dot( desaturateInitialColor392, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar392 = lerp( desaturateInitialColor392, desaturateDot392.xxx, 1.0 );
				float4 HighColor601 = _HighBandColor;
				float HighColorEmission609 = _HighBandColorEmission;
				float4 FinalHighX168 = ( ( float4( desaturateVar392 , 0.0 ) * HighColor601 ) * HighColorEmission609 );
				int Band3_g60 = (int)2.0;
				float2 texCoord153 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g60 = ( texCoord153.x * Delay300 );
				float localAudioLinkLerp3_g60 = AudioLinkLerp3_g60( Band3_g60 , Delay3_g60 );
				float2 texCoord148 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_150_0 = ( saturate( ( ( localAudioLinkLerp3_g60 * 0.2 ) - abs( ( LinesHightX704 - texCoord148.y ) ) ) ) / Smoothing176 );
				float HighWhiteX191 = temp_output_163_0;
				float3 temp_cast_4 = (saturate( ( temp_output_150_0 * ( 1.0 - HighWhiteX191 ) ) )).xxx;
				float3 desaturateInitialColor391 = temp_cast_4;
				float desaturateDot391 = dot( desaturateInitialColor391, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar391 = lerp( desaturateInitialColor391, desaturateDot391.xxx, 1.0 );
				float4 LowColor598 = _LowBandColor;
				float LowColorEmission608 = _LowBandColorEmission;
				float4 FinalLowX154 = ( ( float4( desaturateVar391 , 0.0 ) * LowColor598 ) * LowColorEmission608 );
				int Band3_g99 = (int)1.0;
				float2 texCoord139 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g99 = ( texCoord139.x * Delay300 );
				float localAudioLinkLerp3_g99 = AudioLinkLerp3_g99( Band3_g99 , Delay3_g99 );
				float2 texCoord134 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_136_0 = ( saturate( ( ( localAudioLinkLerp3_g99 * 0.3 ) - abs( ( LinesHightX704 - texCoord134.y ) ) ) ) / Smoothing176 );
				float LowWhiteX190 = temp_output_150_0;
				float temp_output_453_0 = ( temp_output_136_0 * ( 1.0 - LowWhiteX190 ) );
				float3 temp_cast_7 = (saturate( ( temp_output_453_0 * ( 1.0 - ( temp_output_453_0 * HighWhiteX191 ) ) ) )).xxx;
				float3 desaturateInitialColor390 = temp_cast_7;
				float desaturateDot390 = dot( desaturateInitialColor390, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar390 = lerp( desaturateInitialColor390, desaturateDot390.xxx, 1.0 );
				float4 TrebelColor599 = _TrebelBandColor;
				float TrebelColorEmission607 = _TrebelBandColorEmission;
				float4 FinalTrebelX140 = ( ( float4( desaturateVar390 , 0.0 ) * TrebelColor599 ) * TrebelColorEmission607 );
				int Band3_g108 = (int)0.0;
				float2 texCoord21 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g108 = ( texCoord21.x * Delay300 );
				float localAudioLinkLerp3_g108 = AudioLinkLerp3_g108( Band3_g108 , Delay3_g108 );
				float2 texCoord83 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_8_0 = ( saturate( ( ( localAudioLinkLerp3_g108 * 0.4 ) - abs( ( LinesHightX704 - texCoord83.y ) ) ) ) / Smoothing176 );
				float temp_output_429_0 = ( 1.0 - LowWhiteX190 );
				float TrebelWhiteX189 = temp_output_136_0;
				float temp_output_445_0 = ( ( temp_output_8_0 * temp_output_429_0 ) * ( 1.0 - ( temp_output_429_0 * TrebelWhiteX189 ) ) );
				float3 temp_cast_10 = (saturate( ( temp_output_445_0 * ( 1.0 - ( temp_output_445_0 * HighWhiteX191 ) ) ) )).xxx;
				float3 desaturateInitialColor387 = temp_cast_10;
				float desaturateDot387 = dot( desaturateInitialColor387, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar387 = lerp( desaturateInitialColor387, desaturateDot387.xxx, 1.0 );
				float4 BaseColor600 = _BaseBandColor;
				float BaseColorEmission606 = _BaseBandColorEmission;
				float4 FinalBaseX126 = ( ( float4( desaturateVar387 , 0.0 ) * BaseColor600 ) * BaseColorEmission606 );
				float LinesThinknessY722 = 0.01;
				int Band3_g128 = (int)3.0;
				float2 texCoord508 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0 );
				float Delay3_g128 = ( texCoord508.x * Delay300 );
				float localAudioLinkLerp3_g128 = AudioLinkLerp3_g128( Band3_g128 , Delay3_g128 );
				float LinesHightY712 = 0.21;
				float2 texCoord534 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float3 temp_cast_13 = (saturate( ( saturate( ( LinesThinknessY722 - abs( ( ( ( localAudioLinkLerp3_g128 * 0.05 ) + LinesHightY712 ) - texCoord534.y ) ) ) ) / Smoothing176 ) )).xxx;
				float3 desaturateInitialColor566 = temp_cast_13;
				float desaturateDot566 = dot( desaturateInitialColor566, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar566 = lerp( desaturateInitialColor566, desaturateDot566.xxx, 1.0 );
				float2 texCoord682 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float Step689 = ( 1.0 - ( step( texCoord682.x , 0.0989 ) + ( 1.0 - step( texCoord682.x , 0.898 ) ) ) );
				float4 FinaLowY593 = ( ( ( float4( desaturateVar566 , 0.0 ) * HighColor601 ) * HighColorEmission609 ) * Step689 );
				int Band3_g132 = (int)2.0;
				float2 texCoord661 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g132 = ( texCoord661.x * Delay300 );
				float localAudioLinkLerp3_g132 = AudioLinkLerp3_g132( Band3_g132 , Delay3_g132 );
				float2 texCoord679 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float3 temp_cast_16 = (saturate( ( saturate( ( LinesThinknessY722 - abs( ( ( ( localAudioLinkLerp3_g132 * 0.1 ) + LinesHightY712 ) - texCoord679.y ) ) ) ) / Smoothing176 ) )).xxx;
				float3 desaturateInitialColor672 = temp_cast_16;
				float desaturateDot672 = dot( desaturateInitialColor672, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar672 = lerp( desaturateInitialColor672, desaturateDot672.xxx, 1.0 );
				float4 FinalHighYYY677 = ( ( ( float4( desaturateVar672 , 0.0 ) * LowColor598 ) * LowColorEmission608 ) * Step689 );
				int Band3_g130 = (int)1.0;
				float2 texCoord641 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g130 = ( texCoord641.x * Delay300 );
				float localAudioLinkLerp3_g130 = AudioLinkLerp3_g130( Band3_g130 , Delay3_g130 );
				float2 texCoord649 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float3 temp_cast_19 = (saturate( ( saturate( ( LinesThinknessY722 - abs( ( ( ( localAudioLinkLerp3_g130 * 0.2 ) + LinesHightY712 ) - texCoord649.y ) ) ) ) / Smoothing176 ) )).xxx;
				float3 desaturateInitialColor652 = temp_cast_19;
				float desaturateDot652 = dot( desaturateInitialColor652, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar652 = lerp( desaturateInitialColor652, desaturateDot652.xxx, 1.0 );
				float4 FinalTrebelY657 = ( ( ( float4( desaturateVar652 , 0.0 ) * TrebelColor599 ) * TrebelColorEmission607 ) * Step689 );
				int Band3_g129 = (int)0.0;
				float2 texCoord507 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0,0 );
				float Delay3_g129 = ( texCoord507.x * Delay300 );
				float localAudioLinkLerp3_g129 = AudioLinkLerp3_g129( Band3_g129 , Delay3_g129 );
				float2 texCoord535 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float3 temp_cast_22 = (saturate( ( saturate( ( LinesThinknessY722 - abs( ( ( ( localAudioLinkLerp3_g129 * 0.3 ) + LinesHightY712 ) - texCoord535.y ) ) ) ) / Smoothing176 ) )).xxx;
				float3 desaturateInitialColor564 = temp_cast_22;
				float desaturateDot564 = dot( desaturateInitialColor564, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar564 = lerp( desaturateInitialColor564, desaturateDot564.xxx, 1.0 );
				float4 FinalBaseY590 = ( ( ( float4( desaturateVar564 , 0.0 ) * BaseColor600 ) * BaseColorEmission606 ) * Step689 );
				int Band3_g111 = (int)3.0;
				float2 texCoord751 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0.223,0.2 );
				float Delay3_g111 = ( texCoord751.x * Delay300 );
				float localAudioLinkLerp3_g111 = AudioLinkLerp3_g111( Band3_g111 , Delay3_g111 );
				float LinesHightTopX848 = 2.4;
				float2 texCoord776 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_785_0 = ( saturate( ( ( localAudioLinkLerp3_g111 * 0.02 ) - abs( ( LinesHightTopX848 - texCoord776.y ) ) ) ) / Smoothing176 );
				float3 temp_cast_25 = (saturate( temp_output_785_0 )).xxx;
				float3 desaturateInitialColor826 = temp_cast_25;
				float desaturateDot826 = dot( desaturateInitialColor826, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar826 = lerp( desaturateInitialColor826, desaturateDot826.xxx, 1.0 );
				float4 FinalHighTopX838 = ( ( float4( desaturateVar826 , 0.0 ) * HighColor601 ) * HighColorEmission609 );
				int Band3_g96 = (int)2.0;
				float2 texCoord860 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0.223,0.2 );
				float Delay3_g96 = ( texCoord860.x * Delay300 );
				float localAudioLinkLerp3_g96 = AudioLinkLerp3_g96( Band3_g96 , Delay3_g96 );
				float2 texCoord865 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_869_0 = ( saturate( ( ( localAudioLinkLerp3_g96 * 0.05 ) - abs( ( LinesHightTopX848 - texCoord865.y ) ) ) ) / Smoothing176 );
				float HighWhiteTopX790 = temp_output_785_0;
				float3 temp_cast_28 = (saturate( ( temp_output_869_0 * ( 1.0 - HighWhiteTopX790 ) ) )).xxx;
				float3 desaturateInitialColor879 = temp_cast_28;
				float desaturateDot879 = dot( desaturateInitialColor879, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar879 = lerp( desaturateInitialColor879, desaturateDot879.xxx, 1.0 );
				float4 FinalLowTopX882 = ( ( float4( desaturateVar879 , 0.0 ) * LowColor598 ) * LowColorEmission608 );
				int Band3_g100 = (int)1.0;
				float2 texCoord744 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0.223,0.2 );
				float Delay3_g100 = ( texCoord744.x * Delay300 );
				float localAudioLinkLerp3_g100 = AudioLinkLerp3_g100( Band3_g100 , Delay3_g100 );
				float2 texCoord756 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_766_0 = ( saturate( ( ( localAudioLinkLerp3_g100 * 0.08 ) - abs( ( LinesHightTopX848 - texCoord756.y ) ) ) ) / Smoothing176 );
				float LowWhiteTopX870 = temp_output_869_0;
				float temp_output_795_0 = ( temp_output_766_0 * ( 1.0 - LowWhiteTopX870 ) );
				float3 temp_cast_31 = (saturate( ( temp_output_795_0 * ( 1.0 - ( temp_output_795_0 * HighWhiteTopX790 ) ) ) )).xxx;
				float3 desaturateInitialColor828 = temp_cast_31;
				float desaturateDot828 = dot( desaturateInitialColor828, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar828 = lerp( desaturateInitialColor828, desaturateDot828.xxx, 1.0 );
				float4 FinalTrebelTopX839 = ( ( float4( desaturateVar828 , 0.0 ) * TrebelColor599 ) * TrebelColorEmission607 );
				int Band3_g112 = (int)0.0;
				float2 texCoord757 = i.ase_texcoord1.zw * float2( 1,5 ) + float2( 0.223,0 );
				float Delay3_g112 = ( texCoord757.x * Delay300 );
				float localAudioLinkLerp3_g112 = AudioLinkLerp3_g112( Band3_g112 , Delay3_g112 );
				float2 texCoord782 = i.ase_texcoord1.xy * float2( -3,3 ) + float2( 0,0 );
				float temp_output_786_0 = ( saturate( ( ( localAudioLinkLerp3_g112 * 0.1 ) - abs( ( LinesHightTopX848 - texCoord782.y ) ) ) ) / Smoothing176 );
				float temp_output_780_0 = ( 1.0 - LowWhiteTopX870 );
				float TrebelWhiteTopX770 = temp_output_766_0;
				float temp_output_794_0 = ( ( temp_output_786_0 * temp_output_780_0 ) * ( 1.0 - ( temp_output_780_0 * TrebelWhiteTopX770 ) ) );
				float3 temp_cast_34 = (saturate( ( temp_output_794_0 * ( 1.0 - ( temp_output_794_0 * HighWhiteTopX790 ) ) ) )).xxx;
				float3 desaturateInitialColor825 = temp_cast_34;
				float desaturateDot825 = dot( desaturateInitialColor825, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar825 = lerp( desaturateInitialColor825, desaturateDot825.xxx, 1.0 );
				float4 FinalBaseTopX840 = ( ( float4( desaturateVar825 , 0.0 ) * BaseColor600 ) * BaseColorEmission606 );
				float temp_output_2_0_g137 = 0.85;
				float2 appendResult10_g138 = (float2(temp_output_2_0_g137 , temp_output_2_0_g137));
				float2 temp_output_11_0_g138 = ( abs( (frac( (i.ase_texcoord1.xy*Resoluition463 + float2( 0,0 )) )*2.0 + -1.0) ) - appendResult10_g138 );
				float2 break16_g138 = ( 1.0 - ( temp_output_11_0_g138 / fwidth( temp_output_11_0_g138 ) ) );
				float4 FinalBands473 = ( ( ( ( FinalHighX168 + FinalLowX154 + FinalTrebelX140 + FinalBaseX126 + FinaLowY593 + FinalHighYYY677 + FinalTrebelY657 + FinalBaseY590 ) + FinalHighTopX838 + FinalLowTopX882 + FinalTrebelTopX839 + FinalBaseTopX840 ) * _BaseEmission ) * saturate( min( break16_g138.x , break16_g138.y ) ) );
				float2 texCoord887 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner886 = ( _Time.y * float2( 0.72,0 ) + texCoord887);
				float4 FinalScreenAdd701 = ( ( ( tex2D( _Screen, uv_Screen ) * _BaseTextureEmission ) + FinalBands473 ) + ( _BaseTextureEmission * tex2D( _Move, panner886 ) ) );
				float4 FinalLCD477 = ( ( tex2D( _ScreenPixel, texCoord466 ) * _ScreenPixelEmission ) * FinalScreenAdd701 );
				
				
				finalColor = FinalLCD477;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
0;0;1920;1019;8881.459;-3708.561;3.31017;True;False
Node;AmplifyShaderEditor.CommentaryNode;175;-1557.329,-1386.134;Inherit;False;787.4534;850.8916;;14;463;462;722;712;721;720;176;704;703;174;300;299;848;849;Variables;1,0,0.6869249,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-1504,-1248;Inherit;False;Property;_Delay;Delay;1;0;Create;True;0;0;0;False;0;False;127;127;1;127;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;-1008,-1248;Inherit;False;Delay;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;141;-2603.992,1192.564;Inherit;False;3011.069;589.0981;;24;397;598;149;154;190;398;151;391;384;460;461;459;150;147;179;148;146;152;144;145;303;153;608;702;Low;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;858;-6994.927,4911.535;Inherit;False;3011.069;589.0981;;22;882;881;880;879;878;874;872;871;870;869;868;867;866;865;864;863;862;861;860;859;883;884;Low;1,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;303;-2315,1626.725;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;153;-2570.991,1388.453;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;860;-6961.926,5107.424;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0.223,0.2;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;703;-1504,-1024;Inherit;False;Constant;_HightX;HightX;0;0;Create;True;0;0;0;False;0;False;1.65;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-1504,-1328;Inherit;False;Property;_Smoothing;Smoothing;0;0;Create;True;0;0;0;False;0;False;0.01;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2108.176,1519.564;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;859;-6705.935,5345.696;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2070.326,1403.382;Inherit;False;Constant;_BandLowX;BandLowX;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;849;-1503.801,-848.4507;Inherit;False;Constant;_HightXTop;HightXTop;0;0;Create;True;0;0;0;False;0;False;2.4;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-1008,-1328;Inherit;False;Smoothing;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-1749.326,1554.382;Inherit;False;Constant;_Float5;Float 5;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;862;-6461.261,5122.353;Inherit;False;Constant;_Float19;Float 19;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;861;-6499.11,5238.535;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;704;-1008,-1024;Inherit;False;LinesHightX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;146;-1847.326,1462.382;Inherit;False;4BandAmplitudeLerp;-1;;60;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;702;-1656.317,1365.167;Inherit;False;704;LinesHightX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-1578.771,1561.344;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;864;-6238.261,5181.353;Inherit;False;4BandAmplitudeLerp;-1;;96;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;848;-1007.801,-847.4507;Inherit;False;LinesHightTopX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-1587.326,1460.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-1677.676,1243.864;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;863;-6140.261,5273.353;Inherit;False;Constant;_Float18;Float 18;1;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;868;-5969.706,5280.315;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;865;-6068.61,4962.834;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;150;-1397.67,1316.276;Inherit;False;DrawLine;-1;;97;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;866;-5978.261,5179.353;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;867;-6047.251,5084.138;Inherit;False;848;LinesHightTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;869;-5788.604,5035.247;Inherit;False;DrawLine;-1;;98;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-1113.218,1245.461;Inherit;False;LowWhiteX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;127;-2591.113,376.6763;Inherit;False;3413.86;687.5452;;28;140;396;395;137;390;135;383;458;457;456;455;453;454;452;189;136;178;134;133;138;132;131;130;302;139;599;607;706;Trebel;1,0.6652651,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;125;-2595.298,-483.6071;Inherit;False;3380.861;719.6576;;37;188;126;393;394;388;387;91;389;450;451;449;448;445;412;447;8;446;83;105;443;429;177;111;106;434;109;432;77;301;431;433;21;435;414;600;606;705;Base;0,0.2754967,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;414;-1539.724,-21.27522;Inherit;False;190;LowWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;741;-7003.942,3257.217;Inherit;False;3380.861;719.6576;;35;841;840;836;829;825;818;814;800;796;794;792;789;788;787;786;783;782;781;780;779;777;773;772;768;767;763;762;757;755;753;752;748;743;850;851;Base;0,0.2754967,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;870;-5493.152,4991.432;Inherit;False;LowWhiteTopX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-2318.048,835.0162;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;739;-6953.063,4082.48;Inherit;False;3413.86;687.5452;;26;839;834;832;828;822;816;805;797;795;793;791;784;770;766;759;758;756;754;750;749;747;745;744;742;852;853;Trebel;1,0.6652651,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;139;-2541.112,613.5657;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;743;-5948.368,3719.549;Inherit;False;870;LowWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-2095.296,703.6767;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;435;-1403.589,-43.14028;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;742;-6679.998,4540.82;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2057.447,587.4952;Inherit;False;Constant;_BandTrebelX;BandTrebelX;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;744;-6903.062,4319.37;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0.223,0.2;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;155;-2623.527,1907.598;Inherit;False;2364.987;558.2764;;22;168;400;399;164;392;162;385;191;163;161;160;180;165;159;167;158;304;156;166;601;609;707;High;0.2280058,1,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;166;-2573.525,2144.487;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;748;-5812.233,3697.684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-6419.396,4293.3;Inherit;False;Constant;_Float13;Float 13;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;-6457.246,4409.481;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;132;-1834.446,646.4953;Inherit;False;4BandAmplitudeLerp;-1;;99;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1736.446,738.4953;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;433;-1406.589,-98.14027;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;746;-6966.578,5616.199;Inherit;False;2547.987;589.2764;;20;790;838;835;831;826;819;785;778;776;774;775;771;769;764;765;761;760;751;856;857;High;0.2280058,1,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;-2330.235,2356.661;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;431;-1399.589,-227.1401;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1574.446,644.4953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-1583.226,767.1218;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;749;-6196.396,4352.3;Inherit;False;4BandAmplitudeLerp;-1;;100;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-2297.64,-62.03492;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;750;-6098.396,4444.3;Inherit;False;Constant;_Float9;Float 9;1;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;156;-2314.709,2147.598;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;751;-6733.576,5853.088;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0.223,0.2;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;706;-1617.859,562.6914;Inherit;False;704;LinesHightX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2545.297,-246.718;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;752;-5815.233,3642.684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;134;-1659.666,435.8085;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;109;-2061.633,-272.7884;Inherit;False;Constant;_BandBaseX;BandBaseX;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;759;-5979.809,4268.496;Inherit;False;848;LinesHightTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;760;-6490.286,6065.262;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-2089.86,2118.416;Inherit;False;Constant;_BandHighX;BandHighX;1;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;758;-5936.396,4350.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;753;-6706.284,3678.79;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;761;-6474.759,5856.198;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;756;-6021.616,4141.613;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;755;-5808.233,3513.684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-2127.709,2234.598;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;432;-1335.589,-233.1401;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;754;-5945.176,4472.927;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2099.481,-156.6073;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;757;-6953.941,3494.106;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0.223,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;136;-1384.79,500.3888;Inherit;False;DrawLine;-1;;101;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;640;-6288.022,408.0013;Inherit;False;3380.861;719.6576;;23;659;658;657;656;655;654;653;652;651;650;649;648;647;646;645;644;642;641;690;691;714;715;724;Trebel;1,0.6666667,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;485;-6300.655,1891.612;Inherit;False;3387.702;581.1323;;22;582;576;566;562;538;534;533;531;529;528;522;520;516;508;593;602;610;694;695;718;719;726;High;0.2280058,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-1105.896,436.1204;Inherit;False;TrebelWhiteX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;765;-6287.759,5943.198;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1768.86,2269.416;Inherit;False;Constant;_Float6;Float 6;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;434;-1204.589,-232.1401;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;766;-5746.74,4206.193;Inherit;False;DrawLine;-1;;110;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;763;-6470.277,3468.036;Inherit;False;Constant;_Float12;Float 12;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;767;-6508.125,3584.217;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;484;-6280.926,-427.8206;Inherit;False;3378.958;692.2028;;29;614;590;581;613;574;564;605;559;541;535;530;537;525;526;521;519;517;507;681;682;683;684;686;687;688;689;710;713;723;Base;0,0.2754967,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;159;-1866.86,2177.416;Inherit;False;4BandAmplitudeLerp;-1;;109;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;762;-5744.233,3507.684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;764;-6249.911,5827.017;Inherit;False;Constant;_Float17;Float 17;1;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;111;-1838.633,-213.7885;Inherit;False;4BandAmplitudeLerp;-1;;108;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;660;-6251.194,1190.51;Inherit;False;3210.006;563.0406;;23;678;677;676;675;674;673;672;671;670;679;668;669;667;666;664;665;663;661;692;693;716;717;725;High;1,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-1740.633,-121.7887;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;705;-1618.859,-302.3086;Inherit;False;704;LinesHightX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;516;-6007.363,2340.675;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;707;-1667.647,2098.066;Inherit;False;704;LinesHightX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;770;-5467.846,4141.925;Inherit;False;TrebelWhiteTopX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;663;-5953.536,1612.083;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;517;-5985.171,-6.248165;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;773;-6149.277,3619.036;Inherit;False;Constant;_Float11;Float 11;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1578.633,-215.7885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;768;-6247.277,3527.036;Inherit;False;4BandAmplitudeLerp;-1;;112;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;772;-5613.233,3508.684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;771;-5928.911,5978.017;Inherit;False;Constant;_Float10;Float 10;1;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-1673.123,-425.1491;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;180;-1610.006,2274.28;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-1582.624,-101.4683;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;443;-1534.309,48.08599;Inherit;False;189;TrebelWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;507;-6232.828,-190.9315;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;661;-6201.193,1427.399;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;508;-6250.653,2128.501;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;642;-5990.364,829.5737;Inherit;False;300;Delay;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;641;-6238.021,644.8904;Inherit;True;2;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;429;-1148.656,-279.4114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;769;-6026.911,5886.017;Inherit;False;4BandAmplitudeLerp;-1;;111;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-1606.86,2175.416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-1701.833,1975.614;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;779;-5991.268,3639.356;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;522;-5766.988,2102.43;Inherit;False;Constant;_BandHighY;BandHighY;1;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;775;-5766.911,5884.017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;-1055.872,-56.39741;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;644;-5792.206,735.0015;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;777;-5942.953,3788.91;Inherit;False;770;TrebelWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;778;-5827.698,5806.667;Inherit;False;848;LinesHightTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-5717.529,1401.329;Inherit;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;520;-5804.837,2218.612;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;720;-1504,-944;Inherit;False;Constant;_HightY;HightY;0;0;Create;True;0;0;0;False;0;False;0.21;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;452;-1383.043,867.8853;Inherit;False;190;LowWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-1388.977,-359.8947;Inherit;False;DrawLine;-1;;114;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;521;-5749.164,-217.0018;Inherit;False;Constant;_BandBaseY;BandBaseY;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;782;-6081.767,3315.675;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;774;-5770.056,5982.881;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;664;-5755.378,1517.51;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;645;-5754.357,618.8201;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;163;-1417.204,2031.31;Inherit;False;DrawLine;-1;;113;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;780;-5557.3,3461.413;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;783;-5987.277,3525.036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;519;-5787.012,-100.8204;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;776;-5861.883,5684.215;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;781;-6027.503,3438.516;Inherit;False;848;LinesHightTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;447;-854.5653,-165.511;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;721;-1505,-742;Inherit;False;Constant;_Thinkness;Thinkness;0;0;Create;True;0;0;0;False;0;False;0.01;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;712;-1008,-944;Inherit;False;LinesHightY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;666;-5494.529,1460.329;Inherit;False;4BandAmplitudeLerp;-1;;132;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-5396.529,1552.329;Inherit;False;Constant;_Float7;Float 7;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;454;-1142.165,862.9276;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-1079.453,1960.397;Inherit;False;HighWhiteX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;786;-5797.621,3380.93;Inherit;False;DrawLine;-1;;131;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;646;-5531.357,677.8198;Inherit;False;4BandAmplitudeLerp;-1;;130;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;526;-5526.164,-158.002;Inherit;False;4BandAmplitudeLerp;-1;;129;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;528;-5556.988,2109.43;Inherit;False;4BandAmplitudeLerp;-1;;128;3cf4b6e83381a9a4f84f8cf857bc3af5;0;2;2;INT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;647;-5433.357,769.8203;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-5481.988,2225.43;Inherit;False;Constant;_Float16;Float 16;1;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;784;-5744.993,4573.689;Inherit;False;870;LowWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;785;-5577.254,5739.911;Inherit;False;DrawLine;-1;;127;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;1.5;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;412;-988.4679,-348.816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;525;-5428.164,-66.00156;Inherit;False;Constant;_Float15;Float 15;1;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;787;-5464.516,3684.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;714;-5450.015,884.2029;Inherit;False;712;LinesHightY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;789;-5397.112,3392.009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;453;-901.0345,556.5502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;788;-5263.209,3575.313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;790;-5239.503,5668.998;Inherit;False;HighWhiteTopX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;445;-744.2925,-337.0563;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;722;-1009,-742;Inherit;False;LinesThinknessY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-5283.988,2159.43;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;455;-1083.156,932.5037;Inherit;False;191;HighWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;718;-5474.77,2335.043;Inherit;False;712;LinesHightY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;682;-4372.966,63.37592;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;713;-5446.015,10.20288;Inherit;False;712;LinesHightY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;668;-5234.529,1458.329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;659;-5271.357,675.8198;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;791;-5504.115,4568.732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;448;-1523.203,124.0122;Inherit;False;191;HighWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;716;-5417.015,1641.203;Inherit;False;712;LinesHightY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-5281.164,-191.002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;679;-5274.076,1234.51;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;723;-5249.304,-39.56949;Inherit;False;722;LinesThinknessY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;795;-5262.984,4262.355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;710;-5135.096,-234.1974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;794;-5152.937,3403.768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;648;-5275.349,790.1406;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;456;-841.1566,793.5037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;534;-5373.25,1955.852;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;725;-5193.304,1649.431;Inherit;False;722;LinesThinknessY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;724;-5201.304,893.4305;Inherit;False;722;LinesThinknessY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;726;-5218.319,2339.231;Inherit;False;722;LinesThinknessY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;449;-715.1875,35.67604;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;531;-5287.134,2258.294;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;683;-4135.906,144.0855;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.898;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;793;-5445.105,4638.309;Inherit;False;790;HighWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;792;-5931.847,3864.837;Inherit;False;790;HighWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;535;-5305.711,-383.8207;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;669;-5238.521,1572.65;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;715;-5126.015,643.2029;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;537;-5265.155,74.31873;Inherit;False;176;Smoothing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;717;-5073.015,1416.203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;719;-5093.77,2101.043;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;459;-1368.401,1579.625;Inherit;False;191;HighWhiteX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;649;-5310.904,452.0013;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;-3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;670;-4951.874,1325.223;Inherit;False;DrawLine;-1;;135;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;0.025;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;451;-544.1874,5.676098;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;797;-5203.106,4499.309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;681;-4135.966,-21.62408;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.0989;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;650;-5002.701,548.7137;Inherit;False;DrawLine;-1;;136;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;0.025;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;796;-5123.832,3776.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;871;-5759.335,5298.596;Inherit;False;790;HighWhiteTopX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;-621.7356,1489.528;Inherit;False;Property;_LowBandColor;Low Band Color;10;0;Create;True;0;0;0;False;0;False;1,0.07371522,0,0;1,0.0737148,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;91;-386.9107,-196.453;Inherit;False;Property;_BaseBandColor;Base Band Color;6;0;Create;True;0;0;0;False;0;False;0,0.1761498,1,0;0.3317457,0.4367751,0.990566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;541;-5023.508,-304.1082;Inherit;False;DrawLine;-1;;134;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;0.025;False;2;FLOAT;0.05;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;135;-185.0768,712.5532;Inherit;False;Property;_TrebelBandColor;Trebel Band Color;8;0;Create;True;0;0;0;False;0;False;0.7058824,0.4117647,0.03529412,0;0.7058823,0.4117641,0.03529412,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;538;-4938.499,2037.879;Inherit;False;DrawLine;-1;;133;b931a6c4da53ab6489d06086e5e19048;0;4;5;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.025;False;3;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;461;-1130.141,1522.493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;684;-3998.906,91.08548;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;457;-713.1566,738.5037;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;162;-1395.222,2182.58;Inherit;False;Property;_HighBandColor;High Band Color;12;0;Create;True;0;0;0;False;0;False;0.09793162,1,0,0;0.09793111,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;671;-4715.74,1366.341;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;686;-3819.906,-15.91455;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;651;-4752.568,583.8319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;460;-933.1409,1403.493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-170.9514,886.522;Inherit;False;Property;_TrebelBandColorEmission;Trebel Band Color Emission;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;397;-650.2408,1656.079;Inherit;False;Property;_LowBandColorEmission;Low Band Color Emission;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;598;-380.3656,1484.108;Inherit;False;LowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;872;-5521.076,5241.464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;601;-1114.537,2198.885;Inherit;False;HighColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;600;-149.9531,-241.9016;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;800;-4966.513,3746.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;458;-480.0345,599.7221;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;399;-1406.629,2351.431;Inherit;False;Property;_HighBandColorEmission;High Band Color Emission;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;450;-547.1874,-306.3236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;599;53.47925,676.3677;Inherit;False;TrebelColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;805;-5075.106,4444.309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;394;-349.7778,-5.216629;Inherit;False;Property;_BaseBandColorEmission;Base Band Color Emission;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;562;-4685.602,2069.755;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;559;-4747.375,-251.99;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;874;-5324.076,5122.464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-59.10327,-124.2225;Inherit;False;BaseColorEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;814;-4955.832,3434.501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;605;-4721.803,-114.4022;Inherit;False;600;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;672;-4529.493,1295.822;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;673;-4690.17,1503.929;Inherit;False;598;LowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;609;-980.5783,2287.635;Inherit;False;HighColorEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;384;-460.5869,1366.067;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;564;-4561.128,-322.5087;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;383;-19.18376,573.9863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;385;-1164.307,2063.186;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;688;-3566.906,8.085449;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;652;-4566.321,513.3132;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;607;213.6769,771.791;Inherit;False;TrebelColorEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;389;-353.6312,-304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-250.9226,1586.547;Inherit;False;LowColorEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;816;-4841.984,4305.526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;566;-4547.06,2084.509;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;602;-4757.994,2212.787;Inherit;False;601;HighColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;653;-4726.997,721.4197;Inherit;False;599;TrebelColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;576;-4367.516,2096.149;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;610;-4436.693,2290.392;Inherit;False;609;HighColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;655;-4423.979,783.3373;Inherit;False;607;TrebelColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;654;-4342.677,567.424;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;818;-4762.276,3436.824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;387;-167.3838,-374.5187;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;819;-5324.358,5771.787;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;878;-4851.521,5085.038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;674;-4387.152,1565.846;Inherit;False;608;LowColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;391;-318.4235,1364.26;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;689;-3374.007,-21.612;Inherit;False;Step;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;675;-4305.851,1349.933;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;574;-4337.482,-268.3979;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;822;-4420.135,4269.791;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;392;-1025.765,2077.94;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DesaturateOpNode;390;108.722,563.8226;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;613;-4418.784,-52.48456;Inherit;False;606;BaseColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;852;-4366.156,4429.227;Inherit;False;599;TrebelColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;582;-4171.724,2135.699;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;-4123.309,1539.056;Inherit;False;689;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;826;-5185.816,5786.541;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;581;-4153.522,-230.2063;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;828;-4253.229,4269.627;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;287.5486,592.1434;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;883;-4794.779,5235.772;Inherit;False;598;LowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-115.7224,1377.297;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;825;-4576.029,3366.306;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;656;-4158.718,605.6156;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;879;-4709.358,5083.231;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-4189.162,843.5909;Inherit;False;689;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;694;-4084.723,2287.487;Inherit;False;689;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;388;56.26234,-320.408;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;676;-4121.893,1388.125;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;856;-5240.566,5899.887;Inherit;False;601;HighColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-846.2213,2089.58;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;850;-4596.833,3531.619;Inherit;False;600;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;691;-3946.175,604.3058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;695;-3893.737,2157.201;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;240.2223,-282.2163;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;831;-5006.272,5798.181;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;853;-4135.156,4499.227;Inherit;False;607;TrebelColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;-650.4292,2129.13;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;693;-3932.322,1408.771;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;687;-3356.906,-230.9146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;55.76672,1481.054;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;851;-4452.833,3620.619;Inherit;False;606;BaseColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;829;-4352.383,3420.417;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;880;-4506.657,5096.268;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;832;-4074.402,4297.948;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;857;-5058.78,5994.403;Inherit;False;609;HighColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;884;-4608.779,5285.772;Inherit;False;608;LowColorEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;480.0488,639.5219;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;373.2102,-274.1792;Inherit;False;FinalBaseX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;835;-4810.48,5837.73;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;179.4631,1347.359;Inherit;False;FinalLowX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;474;-2554.919,2752.629;Inherit;False;1675.298;949.6611;;20;845;844;843;842;596;595;594;597;473;481;479;371;372;319;480;170;171;173;172;846;BandJoin;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;593;-3697.957,2119.734;Inherit;False;FinaLowY;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;590;-3186.524,-247.6281;Inherit;False;FinalBaseY;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;657;-3746.721,595.1937;Inherit;False;FinalTrebelY;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-498.4924,2052.409;Inherit;False;FinalHighX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;606.6957,629.8954;Inherit;False;FinalTrebelX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;881;-4335.168,5200.025;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;834;-3881.902,4345.326;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;677;-3740.896,1379.703;Inherit;False;FinalHighYYY;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;836;-4168.424,3458.608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-2496.319,2866.628;Inherit;False;154;FinalLowX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;596;-2496.797,3060.215;Inherit;False;593;FinaLowY;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;839;-3753.256,4342.7;Inherit;False;FinalTrebelTopX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-2496.319,2802.629;Inherit;False;168;FinalHighX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;840;-4035.435,3466.645;Inherit;False;FinalBaseTopX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;594;-2498.797,3185.215;Inherit;False;657;FinalTrebelY;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-2496.919,2998.428;Inherit;False;126;FinalBaseX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-2496.797,2932.215;Inherit;False;140;FinalTrebelX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;838;-4658.542,5761.01;Inherit;False;FinalHighTopX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;462;-1504,-1152;Inherit;False;Property;_Resolutioin;Resolutioin;3;0;Create;True;0;0;0;False;0;False;720,1280;720,1280;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;595;-2496.797,3252.215;Inherit;False;590;FinalBaseY;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;597;-2496.797,3124.215;Inherit;False;677;FinalHighYYY;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;882;-4211.472,5066.33;Inherit;False;FinalLowTopX;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;843;-2496,3440;Inherit;False;839;FinalTrebelTopX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;845;-2496,3312;Inherit;False;838;FinalHighTopX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;463;-1008,-1152;Inherit;False;Resoluition;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;319;-2196.446,2884.386;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;-2496,3505;Inherit;False;840;FinalBaseTopX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;842;-2496,3377;Inherit;False;882;FinalLowTopX;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;846;-1968.744,2946.765;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;372;-1798.272,2980.038;Inherit;False;Property;_BaseEmission;Base Emission;5;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;480;-1844.209,3079.962;Inherit;False;463;Resoluition;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-1603.616,2870.938;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;479;-1602.107,3035.222;Inherit;True;Grid;-1;;137;a9240ca2be7e49e4f9fa3de380c0dbe9;0;3;5;FLOAT2;8,8;False;6;FLOAT2;0,0;False;2;FLOAT;0.85;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;698;-869.6331,2758.862;Inherit;False;1803.076;919.3303;Comment;13;892;701;891;700;885;699;886;708;887;696;889;709;890;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;481;-1331.277,2911.858;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;890;-749.5558,3379.309;Inherit;False;Constant;_Vector0;Vector 0;17;0;Create;True;0;0;0;False;0;False;0.72,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;889;-714.5558,3513.309;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;887;-754.5558,3259.309;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;709;-745.2235,3062.236;Inherit;False;Property;_BaseTextureEmission;Base Texture Emission;16;0;Create;True;0;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-1200.756,2894.977;Inherit;False;FinalBands;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;696;-830.0468,2872.955;Inherit;True;Property;_Screen;Screen;14;0;Create;True;0;0;0;False;0;False;-1;10dee62b25dbc1f41b922d01638030e4;10dee62b25dbc1f41b922d01638030e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;886;-538.5558,3293.309;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;708;-481.2235,2901.236;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;470;-2547.642,3784.379;Inherit;False;1531.261;615.8574;Comment;8;477;475;468;476;469;467;466;471;LCD Pannel;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;699;-475.5188,3085.366;Inherit;False;473;FinalBands;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;885;-352.5558,3272.309;Inherit;True;Property;_Move;Move;15;0;Create;True;0;0;0;False;0;False;-1;10dee62b25dbc1f41b922d01638030e4;d44f88ba882ecde42a42436676524fd4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;700;-248.5188,2972.366;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;471;-2507.597,3933.386;Inherit;False;463;Resoluition;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;892;-46.55603,3157.309;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;891;211.2096,3003.263;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;466;-2336.351,3919.602;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;469;-1939.15,4133.601;Inherit;False;Property;_ScreenPixelEmission;Screen Pixel Emission;4;0;Create;True;0;0;0;False;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;701;346.2466,3002.32;Inherit;False;FinalScreenAdd;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;467;-2089.51,3929.813;Inherit;True;Property;_ScreenPixel;Screen Pixel;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;468;-1703.149,4032.603;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;476;-1811.372,4232.535;Inherit;False;701;FinalScreenAdd;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;475;-1539.527,4102.106;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-1360.114,4102.838;Inherit;False;FinalLCD;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;614;-5491.385,-291.7694;Inherit;False;600;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;841;-5540.383,3311.714;Inherit;False;BaseWhiteTopX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;478;2078.26,918.6628;Inherit;False;477;FinalLCD;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;678;-5459.75,1326.562;Inherit;False;600;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;658;-5496.578,544.0525;Inherit;False;600;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-1131.739,-429.1107;Inherit;False;BaseWhiteX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;2275.079,900.5389;Float;False;True;-1;2;ASEMaterialInspector;100;12;Banana/ScreenDisplayCDJ3000;98260b9dbbbb4b244bc27a597305f10e;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;300;0;299;0
WireConnection;144;0;153;1
WireConnection;144;1;303;0
WireConnection;176;0;174;0
WireConnection;861;0;860;1
WireConnection;861;1;859;0
WireConnection;704;0;703;0
WireConnection;146;2;145;0
WireConnection;146;4;144;0
WireConnection;864;2;862;0
WireConnection;864;4;861;0
WireConnection;848;0;849;0
WireConnection;147;0;146;0
WireConnection;147;1;152;0
WireConnection;150;5;148;2
WireConnection;150;1;702;0
WireConnection;150;2;147;0
WireConnection;150;3;179;0
WireConnection;866;0;864;0
WireConnection;866;1;863;0
WireConnection;869;5;865;2
WireConnection;869;1;867;0
WireConnection;869;2;866;0
WireConnection;869;3;868;0
WireConnection;190;0;150;0
WireConnection;870;0;869;0
WireConnection;130;0;139;1
WireConnection;130;1;302;0
WireConnection;435;0;414;0
WireConnection;748;0;743;0
WireConnection;745;0;744;1
WireConnection;745;1;742;0
WireConnection;132;2;131;0
WireConnection;132;4;130;0
WireConnection;433;0;435;0
WireConnection;431;0;433;0
WireConnection;133;0;132;0
WireConnection;133;1;138;0
WireConnection;749;2;747;0
WireConnection;749;4;745;0
WireConnection;156;0;166;0
WireConnection;752;0;748;0
WireConnection;758;0;749;0
WireConnection;758;1;750;0
WireConnection;761;0;751;0
WireConnection;755;0;752;0
WireConnection;158;0;156;0
WireConnection;158;1;304;0
WireConnection;432;0;431;0
WireConnection;77;0;21;1
WireConnection;77;1;301;0
WireConnection;136;5;134;2
WireConnection;136;1;706;0
WireConnection;136;2;133;0
WireConnection;136;3;178;0
WireConnection;189;0;136;0
WireConnection;765;0;761;0
WireConnection;765;1;760;0
WireConnection;434;0;432;0
WireConnection;766;5;756;2
WireConnection;766;1;759;0
WireConnection;766;2;758;0
WireConnection;766;3;754;0
WireConnection;767;0;757;1
WireConnection;767;1;753;0
WireConnection;159;2;167;0
WireConnection;159;4;158;0
WireConnection;762;0;755;0
WireConnection;111;2;109;0
WireConnection;111;4;77;0
WireConnection;770;0;766;0
WireConnection;105;0;111;0
WireConnection;105;1;106;0
WireConnection;768;2;763;0
WireConnection;768;4;767;0
WireConnection;772;0;762;0
WireConnection;429;0;434;0
WireConnection;769;2;764;0
WireConnection;769;4;765;0
WireConnection;160;0;159;0
WireConnection;160;1;165;0
WireConnection;775;0;769;0
WireConnection;775;1;771;0
WireConnection;446;0;429;0
WireConnection;446;1;443;0
WireConnection;644;0;641;1
WireConnection;644;1;642;0
WireConnection;520;0;508;1
WireConnection;520;1;516;0
WireConnection;8;5;83;2
WireConnection;8;1;705;0
WireConnection;8;2;105;0
WireConnection;8;3;177;0
WireConnection;664;0;661;1
WireConnection;664;1;663;0
WireConnection;163;5;161;2
WireConnection;163;1;707;0
WireConnection;163;2;160;0
WireConnection;163;3;180;0
WireConnection;780;0;772;0
WireConnection;783;0;768;0
WireConnection;783;1;773;0
WireConnection;519;0;507;1
WireConnection;519;1;517;0
WireConnection;447;0;446;0
WireConnection;712;0;720;0
WireConnection;666;2;665;0
WireConnection;666;4;664;0
WireConnection;454;0;452;0
WireConnection;191;0;163;0
WireConnection;786;5;782;2
WireConnection;786;1;781;0
WireConnection;786;2;783;0
WireConnection;786;3;779;0
WireConnection;646;2;645;0
WireConnection;646;4;644;0
WireConnection;526;2;521;0
WireConnection;526;4;519;0
WireConnection;528;2;522;0
WireConnection;528;4;520;0
WireConnection;785;5;776;2
WireConnection;785;1;778;0
WireConnection;785;2;775;0
WireConnection;785;3;774;0
WireConnection;412;0;8;0
WireConnection;412;1;429;0
WireConnection;787;0;780;0
WireConnection;787;1;777;0
WireConnection;789;0;786;0
WireConnection;789;1;780;0
WireConnection;453;0;136;0
WireConnection;453;1;454;0
WireConnection;788;0;787;0
WireConnection;790;0;785;0
WireConnection;445;0;412;0
WireConnection;445;1;447;0
WireConnection;722;0;721;0
WireConnection;533;0;528;0
WireConnection;533;1;529;0
WireConnection;668;0;666;0
WireConnection;668;1;667;0
WireConnection;659;0;646;0
WireConnection;659;1;647;0
WireConnection;791;0;784;0
WireConnection;530;0;526;0
WireConnection;530;1;525;0
WireConnection;795;0;766;0
WireConnection;795;1;791;0
WireConnection;710;0;530;0
WireConnection;710;1;713;0
WireConnection;794;0;789;0
WireConnection;794;1;788;0
WireConnection;456;0;453;0
WireConnection;456;1;455;0
WireConnection;449;0;445;0
WireConnection;449;1;448;0
WireConnection;683;0;682;1
WireConnection;715;0;659;0
WireConnection;715;1;714;0
WireConnection;717;0;668;0
WireConnection;717;1;716;0
WireConnection;719;0;533;0
WireConnection;719;1;718;0
WireConnection;670;5;679;2
WireConnection;670;1;717;0
WireConnection;670;2;725;0
WireConnection;670;3;669;0
WireConnection;451;0;449;0
WireConnection;797;0;795;0
WireConnection;797;1;793;0
WireConnection;681;0;682;1
WireConnection;650;5;649;2
WireConnection;650;1;715;0
WireConnection;650;2;724;0
WireConnection;650;3;648;0
WireConnection;796;0;794;0
WireConnection;796;1;792;0
WireConnection;541;5;535;2
WireConnection;541;1;710;0
WireConnection;541;2;723;0
WireConnection;541;3;537;0
WireConnection;538;5;534;2
WireConnection;538;1;719;0
WireConnection;538;2;726;0
WireConnection;538;3;531;0
WireConnection;461;0;459;0
WireConnection;684;0;683;0
WireConnection;457;0;456;0
WireConnection;671;0;670;0
WireConnection;686;0;681;0
WireConnection;686;1;684;0
WireConnection;651;0;650;0
WireConnection;460;0;150;0
WireConnection;460;1;461;0
WireConnection;598;0;149;0
WireConnection;872;0;871;0
WireConnection;601;0;162;0
WireConnection;600;0;91;0
WireConnection;800;0;796;0
WireConnection;458;0;453;0
WireConnection;458;1;457;0
WireConnection;450;0;445;0
WireConnection;450;1;451;0
WireConnection;599;0;135;0
WireConnection;805;0;797;0
WireConnection;562;0;538;0
WireConnection;559;0;541;0
WireConnection;874;0;869;0
WireConnection;874;1;872;0
WireConnection;606;0;394;0
WireConnection;814;0;794;0
WireConnection;814;1;800;0
WireConnection;672;0;671;0
WireConnection;609;0;399;0
WireConnection;384;0;460;0
WireConnection;564;0;559;0
WireConnection;383;0;458;0
WireConnection;385;0;163;0
WireConnection;688;0;686;0
WireConnection;652;0;651;0
WireConnection;607;0;395;0
WireConnection;389;0;450;0
WireConnection;608;0;397;0
WireConnection;816;0;795;0
WireConnection;816;1;805;0
WireConnection;566;0;562;0
WireConnection;576;0;566;0
WireConnection;576;1;602;0
WireConnection;654;0;652;0
WireConnection;654;1;653;0
WireConnection;818;0;814;0
WireConnection;387;0;389;0
WireConnection;819;0;785;0
WireConnection;878;0;874;0
WireConnection;391;0;384;0
WireConnection;689;0;688;0
WireConnection;675;0;672;0
WireConnection;675;1;673;0
WireConnection;574;0;564;0
WireConnection;574;1;605;0
WireConnection;822;0;816;0
WireConnection;392;0;385;0
WireConnection;390;0;383;0
WireConnection;582;0;576;0
WireConnection;582;1;610;0
WireConnection;826;0;819;0
WireConnection;581;0;574;0
WireConnection;581;1;613;0
WireConnection;828;0;822;0
WireConnection;137;0;390;0
WireConnection;137;1;599;0
WireConnection;151;0;391;0
WireConnection;151;1;598;0
WireConnection;825;0;818;0
WireConnection;656;0;654;0
WireConnection;656;1;655;0
WireConnection;879;0;878;0
WireConnection;388;0;387;0
WireConnection;388;1;600;0
WireConnection;676;0;675;0
WireConnection;676;1;674;0
WireConnection;164;0;392;0
WireConnection;164;1;601;0
WireConnection;691;0;656;0
WireConnection;691;1;690;0
WireConnection;695;0;582;0
WireConnection;695;1;694;0
WireConnection;393;0;388;0
WireConnection;393;1;606;0
WireConnection;831;0;826;0
WireConnection;831;1;856;0
WireConnection;400;0;164;0
WireConnection;400;1;609;0
WireConnection;693;0;676;0
WireConnection;693;1;692;0
WireConnection;687;0;581;0
WireConnection;687;1;689;0
WireConnection;398;0;151;0
WireConnection;398;1;608;0
WireConnection;829;0;825;0
WireConnection;829;1;850;0
WireConnection;880;0;879;0
WireConnection;880;1;883;0
WireConnection;832;0;828;0
WireConnection;832;1;852;0
WireConnection;396;0;137;0
WireConnection;396;1;607;0
WireConnection;126;0;393;0
WireConnection;835;0;831;0
WireConnection;835;1;857;0
WireConnection;154;0;398;0
WireConnection;593;0;695;0
WireConnection;590;0;687;0
WireConnection;657;0;691;0
WireConnection;168;0;400;0
WireConnection;140;0;396;0
WireConnection;881;0;880;0
WireConnection;881;1;884;0
WireConnection;834;0;832;0
WireConnection;834;1;853;0
WireConnection;677;0;693;0
WireConnection;836;0;829;0
WireConnection;836;1;851;0
WireConnection;839;0;834;0
WireConnection;840;0;836;0
WireConnection;838;0;835;0
WireConnection;882;0;881;0
WireConnection;463;0;462;0
WireConnection;319;0;171;0
WireConnection;319;1;172;0
WireConnection;319;2;173;0
WireConnection;319;3;170;0
WireConnection;319;4;596;0
WireConnection;319;5;597;0
WireConnection;319;6;594;0
WireConnection;319;7;595;0
WireConnection;846;0;319;0
WireConnection;846;1;845;0
WireConnection;846;2;842;0
WireConnection;846;3;843;0
WireConnection;846;4;844;0
WireConnection;371;0;846;0
WireConnection;371;1;372;0
WireConnection;479;5;480;0
WireConnection;481;0;371;0
WireConnection;481;1;479;0
WireConnection;473;0;481;0
WireConnection;886;0;887;0
WireConnection;886;2;890;0
WireConnection;886;1;889;0
WireConnection;708;0;696;0
WireConnection;708;1;709;0
WireConnection;885;1;886;0
WireConnection;700;0;708;0
WireConnection;700;1;699;0
WireConnection;892;0;709;0
WireConnection;892;1;885;0
WireConnection;891;0;700;0
WireConnection;891;1;892;0
WireConnection;466;0;471;0
WireConnection;701;0;891;0
WireConnection;467;1;466;0
WireConnection;468;0;467;0
WireConnection;468;1;469;0
WireConnection;475;0;468;0
WireConnection;475;1;476;0
WireConnection;477;0;475;0
WireConnection;841;0;786;0
WireConnection;188;0;8;0
WireConnection;7;0;478;0
ASEEND*/
//CHKSM=5CB934B5E383F5373A4F61E1E6C72BDCC687D830
