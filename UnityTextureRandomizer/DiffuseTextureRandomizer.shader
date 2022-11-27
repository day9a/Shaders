// adaptation from example (Technique 3):
// https://iquilezles.org/articles/texturerepetition/
Shader "Custom/DiffuseTextureRandomizer"

{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTex ("White Noise", 2D) = "white" {}
        _Scale ("Scale Noise", float) = 0.5
        _Strength ("Strength", Range(0,1)) = 0.0
    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert noforwardadd

        sampler2D _NoiseTex, _MainTex;
        half _Scale, _Strength;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o) 
        {
            float2 uv = IN.uv_MainTex;
            half k = tex2D(_NoiseTex, _Scale*uv*0.01).x;

            half f = frac(k*8.0);
            half ia = floor(k*8.0);
            half ib = ia + 1.0;

            half2 offa = sin(half2(3.0, 7.0)*ia);
            half2 offb = sin(half2(3.0, 7.0)*ib);

            half3 cola = tex2D(_MainTex, uv + _Strength * offa).xyz;
            half3 colb = tex2D(_MainTex, uv + _Strength * offb).xyz;  


            fixed3 col = lerp(cola, colb, smoothstep(0.2, 0.8, f));

            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = col.rgb;
            o.Alpha = 1.0;
        }
        ENDCG
    }
}
