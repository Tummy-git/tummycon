Shader "Hidden/Noriben/LED BarLight Video Input Receiver"
{
    Properties
    {
        _MainTex ("Video Texture", 2D) = "black" {}
        [HideInInspector] _IsAVProVideo ("Is AVPro Video", Float) = 0
        [HideInInspector] _IsVerticalMirror ("Is Vertical Mirror", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            ColorMask 0
            ZWrite Off
        }
    }
}
