// Use shader with Unity Particle System
Shader "Custom/MotionVectorSimple"
{
    Properties
    {
        _MainTex ("Sprite Sheet", 2D) = "white" {}
        _MotionVectors ("Motion Vectors", 2D) = "white" {}
        _Strength ("Strength", Range(0, 0.03)) = 0.01
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                // 1.Enable checkbox on Particle System > Rendered > Custom Vertex Stream
                // 2.Add to list: Position(POSITION.xyz), UV(TEXCOORD0.xy), UV2(TEXCOORD0.zw), AnimBlend(TEXCOORD1.x)
                float4 vertex : POSITION;
                float4 uvs : TEXCOORD0;    // TEXCOORD0.xy/TEXCOORD0.zw - next/current frame UV stream from Particle System
                float fBlend : TEXCOORD1;  // transition between frames
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0; 
                float2 uv2 : TEXCOORD1;
                fixed blend : TEXCOORD2;
            };

            sampler2D _MainTex, _MotionVectors;
            float4 _MainTex_ST, _MotionVectors_ST;
            fixed _Strength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uvs.xy,_MainTex);
                o.uv2 = TRANSFORM_TEX(v.uvs.zw,_MainTex);
                o.blend = v.fBlend.x;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float blend = i.blend; // transition between frames

                float2 mvA = tex2D(_MotionVectors, i.uv).xy; 
                float2 uvA = i.uv - (mvA * 2.0 - 1.0) * (blend) * _Strength; // uv for next frame
                fixed4 texA = tex2D(_MainTex, uvA);

                float2 mvB = tex2D(_MotionVectors, i.uv2).xy; 
                float2 uvB = i.uv2 + (mvB * 2.0 - 1.0) * (1.0 - blend) * _Strength;  // uv for current frame
                fixed4 texB = tex2D(_MainTex, uvB);            

                fixed4 tex = lerp(texA, texB, blend);
                return tex;
            }
            ENDCG
        }
    }
}
