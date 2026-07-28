// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banana/SpinLogoCDJ3000"
{
	Properties
	{
		_Logo("Logo", 2D) = "white" {}
		_SpinMask("Spin Mask", 2D) = "white" {}
		_ScreenPixel("Screen Pixel", 2D) = "white" {}
		_PixelResolution("Pixel Resolution", Vector) = (720,1820,0,0)
		_ScreenPixelEmission("Screen Pixel Emission", Int) = 5
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_AmbientOclussionAmount("Ambient Oclussion Amount", Float) = 1
		_EmissionAmount("Emission Amount", Float) = 1
		_RotationSpeed("Rotation Speed", Int) = 2
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
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
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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

			uniform sampler2D _ScreenPixel;
			uniform float2 _PixelResolution;
			uniform int _ScreenPixelEmission;
			uniform sampler2D _AmbientOcclusion;
			uniform float4 _AmbientOcclusion_ST;
			uniform float _AmbientOclussionAmount;
			uniform sampler2D _Logo;
			uniform sampler2D _SpinMask;
			uniform float4 _SpinMask_ST;
			uniform int _RotationSpeed;
			uniform sampler2D _TextureSample2;
			uniform float4 _TextureSample2_ST;
			uniform float _EmissionAmount;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float2 texCoord57 = i.ase_texcoord1.xy * _PixelResolution + float2( 0,0 );
				float2 uv_AmbientOcclusion = i.ase_texcoord1.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
				float2 texCoord3 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_SpinMask = i.ase_texcoord1.xy * _SpinMask_ST.xy + _SpinMask_ST.zw;
				float4 tex2DNode12 = tex2D( _SpinMask, uv_SpinMask );
				float4 temp_cast_0 = (0.01).xxxx;
				float2 texCoord8 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime9 = _Time.y * (float)( _RotationSpeed * -1 );
				float cos7 = cos( mulTime9 );
				float sin7 = sin( mulTime9 );
				float2 rotator7 = mul( texCoord8 - float2( 0.5,0.5 ) , float2x2( cos7 , -sin7 , sin7 , cos7 )) + float2( 0.5,0.5 );
				float2 uv_TextureSample2 = i.ase_texcoord1.xy * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
				
				
				finalColor = ( ( ( tex2D( _ScreenPixel, texCoord57 ) * _ScreenPixelEmission ) * ( ( tex2D( _AmbientOcclusion, uv_AmbientOcclusion ) * _AmbientOclussionAmount ) * ( ( tex2D( _Logo, texCoord3 ) * step( tex2DNode12 , temp_cast_0 ) ) + ( tex2D( _Logo, rotator7 ) * tex2DNode12 ) ) * tex2D( _TextureSample2, uv_TextureSample2 ) ) ) * _EmissionAmount );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
0;0;1920;1019;207.4777;316.2648;1;True;False
Node;AmplifyShaderEditor.IntNode;21;-1543.034,585.8675;Inherit;False;Constant;_Int1;Int 1;3;0;Create;True;0;0;0;False;0;False;-1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;19;-1597.034,394.8678;Inherit;False;Property;_RotationSpeed;Rotation Speed;8;0;Create;True;0;0;0;False;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1357.034,453.8677;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1375.431,118.0172;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1197.511,392.6602;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1282.431,262.0172;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1275,-81.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-906,425.5;Inherit;True;Property;_SpinMask;Spin Mask;1;0;Create;True;0;0;0;False;0;False;-1;53f481a2a76781a4c8923d38ad46733b;53f481a2a76781a4c8923d38ad46733b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-554.3086,647.5056;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;7;-998.4308,204.0172;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-739,193.5;Inherit;True;Property;_asdf;asdf;0;0;Create;True;0;0;0;False;0;False;-1;9739bd6977b5ce647b5469c66ac70858;9739bd6977b5ce647b5469c66ac70858;True;0;False;white;Auto;False;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;48;-389.3086,528.5056;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-735,-94.5;Inherit;True;Property;_asd;asd;0;0;Create;True;0;0;0;False;0;False;-1;9739bd6977b5ce647b5469c66ac70858;9739bd6977b5ce647b5469c66ac70858;True;0;False;white;Auto;False;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;56;-474.6601,-538.9545;Float;False;Property;_PixelResolution;Pixel Resolution;3;0;Create;True;0;0;0;False;0;False;720,1820;720,1820;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;52;-305.0487,-322.0768;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;5;0;Create;True;0;0;0;False;0;False;-1;92fe8598939f19742b87797cefbf2a5a;92fe8598939f19742b87797cefbf2a5a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-282.2122,-111.5911;Inherit;False;Property;_AmbientOclussionAmount;Ambient Oclussion Amount;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-268.2907,-545.4017;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-277,214.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-314,-34.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;-71.29044,249.102;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;0;False;0;False;-1;b068e72919ed46f45988ee58d429896b;b068e72919ed46f45988ee58d429896b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;58;108.7092,-331.4017;Inherit;False;Property;_ScreenPixelEmission;Screen Pixel Emission;4;0;Create;True;0;0;0;False;0;False;5;5;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;19.78778,-254.5911;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-46.88989,15.39398;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;59;-6.290794,-531.4017;Inherit;True;Property;_ScreenPixel;Screen Pixel;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;359.709,-432.4017;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;227.7569,-100.375;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;628.7846,-210.8203;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;691.8211,24.04207;Inherit;False;Property;_EmissionAmount;Emission Amount;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;933.6211,-126.7579;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;47;-574.3086,521.5056;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-1739,-259.5;Inherit;True;Property;_Logo;Logo;0;0;Create;True;0;0;0;False;0;False;-1;9739bd6977b5ce647b5469c66ac70858;9739bd6977b5ce647b5469c66ac70858;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;83;1220.83,-155.6722;Float;False;True;-1;2;ASEMaterialInspector;100;1;Banana/SpinLogoCDJ3000;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;9;0;20;0
WireConnection;7;0;8;0
WireConnection;7;1;10;0
WireConnection;7;2;9;0
WireConnection;6;1;7;0
WireConnection;48;0;12;0
WireConnection;48;1;50;0
WireConnection;1;1;3;0
WireConnection;57;0;56;0
WireConnection;11;0;6;0
WireConnection;11;1;12;0
WireConnection;13;0;1;0
WireConnection;13;1;48;0
WireConnection;65;0;52;0
WireConnection;65;1;66;0
WireConnection;18;0;13;0
WireConnection;18;1;11;0
WireConnection;59;1;57;0
WireConnection;60;0;59;0
WireConnection;60;1;58;0
WireConnection;54;0;65;0
WireConnection;54;1;18;0
WireConnection;54;2;73;0
WireConnection;61;0;60;0
WireConnection;61;1;54;0
WireConnection;63;0;61;0
WireConnection;63;1;64;0
WireConnection;47;0;12;0
WireConnection;83;0;63;0
ASEEND*/
//CHKSM=E704227563CEB9D2AD71296891D8CCB11CEF3AB3