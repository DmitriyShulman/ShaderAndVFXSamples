Shader "Unlit/ExampleShader_1_Unlit"
{
    Properties
    {
        _MainTex1 ("MainTex1", 2D) = "white" {}
        _MainTex2 ("MainTex2", 2D) = "white" {}
        _MaskTex ("MaskTex", 2D) = "white" {}
        _TilingAndOffset("Tiling and Offset", vector) = (1,1,0,0)
        _Color("Color", color) = (1,1,1,1)
        _Disp("Displace along Normal", range(0, 2)) = 1
        _Speed("Animation Speed", vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags {        
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque" 
             }
        LOD 100

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"       

        CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float4 _TilingAndOffset;
            half _Disp;
            half4 _Speed;
        CBUFFER_END

        TEXTURE2D(_MainTex1);
        SAMPLER(sampler_MainTex1);
        TEXTURE2D(_MainTex2);
        SAMPLER(sampler_MainTex2);
        TEXTURE2D(_MaskTex);
        SAMPLER(sampler_MaskTex);

        struct appdata
        {
            float4 position : POSITION;
            float2 uv_MainTex1 : TEXCOORD0;
            float2 uv_MainTex2 : TEXCOORD0;
            float2 uv_Mask : TEXCOORD0;
        };

        struct v2f
        {
            float4 position : SV_POSITION;
            float2 uv_MainTex1 : TEXCOORD0;
            float2 uv_MainTex2 : TEXCOORD1;
            float2 uv_Mask : TEXCOORD2;
        };

        ENDHLSL

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            v2f vert(appdata i)
            {
                v2f o;
                o.position = TransformObjectToHClip(i.position.xyz * _Disp);
                o.uv_MainTex1 = (i.uv_MainTex1 * _TilingAndOffset.xy) +  frac(_TilingAndOffset.zw * _Time.y * _Speed.xy);
                o.uv_MainTex2 = i.uv_MainTex2;
                o.uv_Mask = i.uv_Mask;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                half mask = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, i.uv_Mask).x;
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex1, sampler_MainTex1, i.uv_MainTex1) * mask;
                baseTex += SAMPLE_TEXTURE2D(_MainTex2, sampler_MainTex2, i.uv_MainTex2) * (1-mask);
                return _Color * baseTex;
            }

            ENDHLSL
        }
    }
}
