Shader "Custom/FakePipe"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Diameter ("Diameter", Range(0,1)) = 0.5
        _Depth ("Depth", Range(0,5)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        sampler2D _MainTex;

        #define PI 3.14159f

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir; 
        };

        half _Diameter;
        half _Depth;
        fixed4 _Color;

        float lessThan(float a, float b)
            {
                if(a < b) {return true;} else {return false;}
            }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv, uv2, uvT, uvB, uvW, uvM;                             // Top, Bottom, Wall, Mixed
            half maskT, maskB, maskW, maskM;
            float3 vDir =  normalize(mul(IN.viewDir, unity_ObjectToWorld).xyz);
            float r = _Diameter;
            uv = IN.uv_MainTex;
            uv2 = uv * 2.0 - 1.0;

            // Bottom
            float2 px = uv + vDir.xz/vDir.y * _Depth - 0.5;                 // parallax offset
            uvB = px * sqrt(1.0 / r) * 0.5 - float2(-0.25, 0.25);
            maskB = lessThan(dot(px, px), r * 0.25);

            // Top
            uvT = uv2 * 0.25 - 0.25;
            maskT = lessThan(r, dot(uv2, uv2));

            // Pipe walls
            float2 inc = normalize(vDir.xz);                                // view vector (incoming)
            // Take two triangles ACH and DCH, where:
            // A - point of intersection of view vector with surface (inc)
            // C - point of center of the pipe (uv2)
            // D - point of intersection of view vector with pipe wall
            // CH - perpendicular drawn from C to side AD (altitude)
            // CD - pipe radius (r)
            float CH = cross(uv2.xyy, inc.xyy).z;                            
            float AH = dot(uv2, inc);
            float AD = AH - sqrt( abs(r - CH * CH));                        // full ray length projected under surface
            float2 wall = uv2 - inc * AD;                                   // pipe walls position
            // Pipe depth
            float up = dot(vDir.xzy, float3(0.0, 0.0, 1.0));                // vDir vs up vector
            float depth = up * AD / sqrt(1.0 - up * up);                    // pipe depth position
            // Remove walls distortion 
            float wallmask = lessThan(wall.y, 0.0);
            wall.x = acos(1.0 / sqrt(r) * wall.x) * 0.318;                  // make coordinates linear
            wall.x = ((1.0 - wallmask) * wall.x + (1.0 - wallmask * wall.x) * wallmask + wallmask) * 0.5; // make coordinates from 0.0 to 1.0
            wall.x =  clamp(1.0 - wall.x, 0.0, 1.0);
            //
            depth = frac(depth * 0.5) * 0.5;
            uvW = float2(wall.x, depth);
            maskW = clamp(maskB + maskT, 0.0, 1.0);

            // Mixed
            uvM = lerp(uvB, uvT, maskT);
            uvM = lerp(uvW, uvM, maskW);

            fixed4 c = tex2D (_MainTex, uvM) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
