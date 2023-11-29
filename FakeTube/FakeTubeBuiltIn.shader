Shader "Custom/FakeTubeBuildIn"
{
    Properties
    {
        _MainTex ("Albedo(RGB)Alpha(A)", 2D) = "white" {}
        [NoScaleOffset]_MetallicSmoothness ("Metallic(R)Smoothness(A)", 2D) = "black" {}
        [NoScaleOffset]_Emission ("Emit(RGB)", 2D) = "black" {}
        [Normal][NoScaleOffset]_NormalMap ("Normal", 2D) = "gray" {}
        _Noise ("DistortMap(RG)", 2D) = "black" {}
        [Header(TUBE SHAPE)]
        _TopRadius ("Top Radius", Range(0,1)) = 0.8
        _TubeRadius ("Tube Radius", Range(0,2)) = 0.8
        _TubeDepth ("Tube Depth", Range(0,32)) = 1.0
        _TubeDepthScale ("Tube Depth Scale", Range(0,4)) = 1.0
        [Header(GATES AB SHAPES)] 
        _GateARadius ("Radius A", float) = 0.8
        _GateBRadius ("Radius B", float) = 0.8
        _GateADepth ("Depth A", float) = 0.5
        _GateBDepth ("Depth B", float) = 0.6
        _GateAScale ("Scale A", Range(0,2)) = 1.0
        _GateBScale ("Scale B", Range(0,2)) = 1.0
        _GateBRot (">>Rotation B Animation",  float) = 0.0
        [Toggle(CHECKBOX_ON)] _Step("Step Rotation", Int) = 0

        [Header(TUBE SHADOW)]
        _FakeShadow ("Fake Shadow", Range(0,1)) = 0.5
        _SoftTube ("Soft Shadow", Range(0,2)) = 0.5
        _SoftTop ("Soft Top", Range(0,1.1)) = 0.5
        _AngleX ("Angle X", Range(0,1)) = 0.0
        _AngleY ("Angle Y", Range(0,5)) = 1.0
        [Header(FAN SHADOW)]
        _FanShadow ("Fan Shadow", Range(0,1)) = 0.5
        _FanSoft ("Fan Soft", Range(0,3)) = 0.5
        _FanWidthX ("Width X", Range(-1,1)) = 0.5
        _FanLengthY ("Length Y(Depth)", Range(-1,1)) = 0.5
        _FanOffsetX ("Offset X", Range(0,5)) = 0.5
        _FanOffsetY ("Offset Y(Depth)", Range(-1,1)) = 0.0
        _BladeCount("Blade Count", Int) = 5

        [Header(FOG)]
        _FogPower ("Fog Power", Range(0,1)) = 0.0
        _FogCover ("Fog Over Gates", Range(0,1)) = 0.0
        _FogCol ("Fog Color", Color) = (1,1,0,1)
        [Header(DISTORT)]
        _TopDistort ("Top Edge", Range(0,1)) = 0.0
        _HeatDistort ("Heat", Range(0,1)) = 0.0
        _GateBDistort ("Liquid(Gate B)", Range(0,1)) = 0.0
        _DistortAnim (">>Distortion Animation", float) = 0.0
        [Header(MISC)] 
        _Emit ("Emission Map Power", float) = 0.0
        _EmitAnim (">>Emission Blinking Animation", float) = 0.0
        _LessLight ("Less Lighting", Range(0,1)) = 0.5
        _MipLevel ("Offset Mip Level", Range(0,1)) = 0.2
        [Toggle(CHECKBOX_ON)] _UseAlpha("Disable Alpha", Int) = 0
        [HideInInspector]_Cutoff("Cutoff", float) = 0.5
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf StandardSpecular alphatest:_Cutoff fullforwardshadows
        #pragma target 3.0

        #include "UnityCG.cginc"

        sampler2D _MainTex;
        sampler2D _MetallicSmoothness;
        sampler2D _Emission;
        sampler2D _NormalMap;
        sampler2D _Noise;

        half _TopRadius; 
        half _TubeRadius; 
        half _TubeDepth; 
        half _TubeDepthScale;
        half _GateARadius; 
        half _GateBRadius; 
        half _GateADepth; 
        half _GateBDepth; 
        half _GateAScale; 
        half _GateBScale; 
        half _GateBRot;
        bool _Step;

        half _FakeShadow; 
        half _SoftTube; 
        half _SoftTop; 
        half _AngleX; 
        half _AngleY;
        half _FanShadow; 
        half _FanSoft; 
        half _FanWidthX; 
        half _FanLengthY; 
        half _FanOffsetX; 
        half _FanOffsetY;
        half _BladeCount;

        half _FogPower; 
        half _FogCover;
        half4 _FogCol;
        half _TopDistort; 
        half _HeatDistort; 
        half _GateBDistort; 
        half _DistortAnim;
        half _Emit; 
        half _EmitAnim;
        half _LessLight;
        half _MipLevel;
        bool _UseAlpha;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        float2 Rotate2d(float2 p, float a)
        {
            return cos(a) * p - sin(a) * float2(p.y, -p.x);
        }

        float2 Distort(float2 p1, float2 p2, half t, int align)
        {
            return lerp(-p1 * 1.2, p2 * 4.0, align) + half2(0.0, t);
        }

        float2 Parallax(float2 p, float3 vDir, half d)
        {
                return (p - vDir.xz / vDir.y * d) * 0.5;
        }

        half TubeShadows(float2 p, half mask_top, half x, half y, half t, half AngleX)
        {
            // Tube shadow
            p = Rotate2d(p, AngleX);
            half sh = 1.0 - (p.x + 0.95 + _AngleY * y);
            half tubesh = 0.5 / ((_SoftTube * 0.1 + 0.001) + _SoftTube * _AngleY * y);
            tubesh = saturate(saturate(sh * tubesh) + 1.0 - _FakeShadow);

            // Fan shadow
            half fan_y = (y - _GateBDepth + _FanOffsetY) * _FanLengthY;
            half fansh_y = saturate(32.0 * fan_y) * frac(saturate(1.0 - fan_y) * saturate(1.0 - fan_y));
            half fan_x = x * _BladeCount * 6.28319 - _BladeCount * t + _FanOffsetX; 
            fan_x = sin(fan_x) + _FanWidthX;
            half fansh_x = smoothstep(16.0 * _FanSoft  * fan_y, -fan_y, fan_x);
            half fansh = fansh_y * fansh_x * _FanShadow;

            // Tube shadow + Fan shadow + Soft top
            half tubeshadows = tubesh - tubesh * fansh;
            half softtop = 1.0 - saturate((1.2 - _SoftTop) * mask_top * y * 128.0);
            tubeshadows = saturate(tubeshadows + softtop * softtop);

            return tubeshadows;
        }
        
        half4 GatesShadows(float2 uv_pxa, float2 uv_pxb, half AngleX)
        {
            // Gate A B shadow
            half soft = _SoftTube * 0.5 + 0.001;
            float2 rot = float2(cos(-AngleX), sin(-AngleX));
            half sh_a = dot(uv_pxa + rot, uv_pxa + rot);
            half sh_b = dot(uv_pxb + rot, uv_pxb + rot);
            half a = 1.05 - _AngleY * _GateADepth + _TopRadius * 0.25;
            half b = 1.05 - _AngleY * _GateBDepth + _TopRadius * 0.25;
            sh_a = smoothstep(a, a - soft, sh_a);
            sh_b = smoothstep(b, b - soft, sh_b);
            sh_a = max(sh_a, 1.0 - _FakeShadow);
            sh_b = max(sh_b, 1.0 - _FakeShadow);

            half2 sh_a2b = uv_pxb * 0.5 + (_GateBDepth - _GateADepth) * _AngleY * rot * 0.125 + half2(0.75, 0.25);

            return half4(sh_a, sh_b, sh_a2b.x, sh_a2b.y);
        }

        half3 TubeFog(half mask_top, half depth, half bottom)
        {
            half mask_fog = saturate(depth / bottom) * mask_top;
            half fog = mask_fog * _FogPower;
            half lesslight =  saturate(mask_fog * 32.0) * _LessLight;
            return half3(fog, fog * _FogCover, lesslight);
        }

        float4 FixWallNormal(float4 wall, float2 p)
        {
            float w1 = abs(p.x - 0.5) * 2.0;
            float w2 = abs(frac(p.x + 0.25) - 0.5) * 2.0;
            float w3 = lerp(1.0 - wall.y, wall.y, w1);

            wall.y = lerp(1.0 - wall.y, wall.y, w2);
            wall.w = wall.w + w3 - 0.5;

            return float4(1.0, wall.y, wall.z, wall.w);
        }

        float3x3 AngleAxis3x3(float angle, float3 axis) // 3x3 Rotation matrix with an angle and an arbitrary vector 
        {
            float c, s;
            sincos(angle, s, c);

            float t = 1 - c;
            float x = axis.x;
            float y = axis.y;
            float z = axis.z;

            return float3x3(
                t * x * x + c,      t * x * y - s * z,  t * x * z + s * y,
                t * x * y + s * z,  t * y * y + c,      t * y * z - s * x,
                t * x * z - s * y,  t * y * z + s * x,  t * z * z + c
            );
        }

        float3 AxisNormalRotation(float3 p, float t) 
        {
            return mul(p * float3(1,0,1) - 0.5, AngleAxis3x3(t, float3(0,1,0))) + 0.5;
        }  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        struct MapsStruct
        {
            half4 Albedo;
            half4 Metal;
            half3 Emit;
            half4 Norm;
        };  

        MapsStruct FakeTube(float2 uv_main, float3 vDir)
        {
            float2 uv, uv_top, uv_bottom, uv_wall, uv_gatea, uv_gateb, uv_mixed;
            half mask_top, mask_bottom, mask_wall, mask_gatea, mask_gateb, mask_mixed, mask_heat, mask_edge, mask_fog;
            half t, t1, t2, t3;

            t = _Time.z;
            t1 = t * _GateBRot;
            t1 = lerp(t1, floor(t1) * 2.4, _Step); // rotate
            t2 = t * _DistortAnim; // distort
            t3 = 1.0 - saturate((sin(t * 5.0) + sin(t * 8.7)) * _EmitAnim + _EmitAnim); // blinking
            const half4 NormColor = half4(1.0, 0.5, 0.5, 0.5);
            const half half_PI = 1.5707964;
            _AngleX = _AngleX * half_PI * 4.0 - half_PI;

            uv.xy = uv_main.xy * 2.0 - 1.0;
            vDir = vDir.xzy;

            // Edge + Heat distortion
            half c = dot(uv, uv); 
            mask_heat = (1.0 - c) * (1.0 - c) * (c < _TopRadius);
            mask_edge = saturate(0.5 - abs(c - _TopRadius));
            uv += (tex2D(_Noise, Distort(uv, 0, 0.0, 0)).xy      - 0.75) * mask_edge * mask_edge * _TopDistort * 0.1;
            uv += (tex2D(_Noise, Distort(uv, vDir.xy, t2, 1)).xy - 0.75) * mask_heat * _HeatDistort * 0.1;





            // Top
            uv_top = uv * 0.249 + float2(0.75, 0.25);
            mask_top = _TopRadius > dot(uv, uv);

            // Bottom
            half bottom = _TubeDepth * _TubeDepthScale;
            float2 uv_px = Parallax(uv, vDir, bottom);
            uv_bottom = uv_px * sqrt(1.0 / _TubeRadius) * 0.249;
            uv_bottom = lerp(uv_bottom + float2(0.375, 0.25), uv_bottom + float2(0.5, 0.75),  uv_bottom.x < 0.0);
            mask_bottom = dot(uv_px, uv_px) < _TubeRadius * 0.25;

            // Walls
            float2 inc = normalize(vDir.xz);                            // incoming
            float CH = cross(uv.xyy, inc.xyy).z; 
            float AH = dot(uv, inc);
            float AD = AH + sqrt(abs(_TubeRadius - CH * CH));           // full ray length projected under surface
            float2 walls = uv - inc * AD;                               // tube walls position
            float mask = walls.x < 0.0;
            uv_wall.x = acos(sqrt(1.0 / _TubeRadius) * walls.y) * 0.318; // make uv linear // 0.318 magic number
            uv_wall.x = ((1.0 - mask) * uv_wall.x + (1.0 - mask * uv_wall.x) * mask + mask) * 0.5; // from 0.0 to 1.0

            float up = dot(vDir.xzy, float3(0,0,1));
            float depth = up * AD / sqrt(1.0 - up * up);                // tube depth position 
            float d = 0.5 / _TubeDepthScale * depth;                    // from 0.0 to 1.0
            uv_wall.y = lerp(frac(d * 2.0) * 0.25 + 0.25, frac(d) * 0.5, d < 0.5) * 0.75 + 0.001; // y depth recurrence

            uv_wall = float2(saturate(uv_wall.x), uv_wall.y);
            mask_wall = mask_bottom < mask_top;

            // Gate A
            float2 uv_pxa = Parallax(uv, vDir, _GateADepth);
            half mask_a = dot(uv_pxa, uv_pxa) > _GateARadius * 0.25;
            uv_gatea = uv_pxa * _GateAScale * 0.5 - float2(0.25, 0.75);
            mask_gatea = mask_top > mask_a;

            // Gate B
            float2 uv_pxb = Parallax(uv, vDir, _GateBDepth);
            half mask_b = dot(uv_pxb, uv_pxb) > _GateBRadius * 0.25;
            uv_gateb = Rotate2d(uv_pxb, t1);          
            uv_gateb += (tex2D(_Noise, Distort(uv_gateb, 0, t2, 0)).xy - 0.75) * _GateBDistort * 0.1;
            uv_gateb = frac(uv_gateb * _GateBScale - 0.5) * 0.5 + 0.5;
            mask_gateb = mask_top > mask_b;





            // Tube shadows
            half tubeshadows = TubeShadows(walls, mask_top, uv_wall.x, depth, t1, _AngleX);
            half4 gatesshadows = GatesShadows(uv_pxa, uv_pxb, _AngleX);

            half switchdeep = _GateBDepth > bottom;                     // if gateB is deeper than bottom, than gates A and B change their behavior (uses for window)
            half GateB_switchdeep = mask_gateb > lerp(1.0 - mask_top, 1.0 - mask_top * mask_bottom, switchdeep);
            half gatea2bshadow = tex2D(_MainTex, gatesshadows.zw).a * _FakeShadow;
            half gatebshadow =  min(saturate(GateB_switchdeep - gatea2bshadow), gatesshadows.y);
            half gateashadow = saturate(gatesshadows.x + (_GateADepth < 0.05));  // if gateA has no depth then no shadow

            // Tube fog
            half3 tubefog = TubeFog(mask_top, depth, bottom);





            // Maps sampling
            uv_mixed = lerp(uv_top, uv_bottom, mask_top);
            uv_mixed = lerp(uv_mixed, uv_wall.yx, mask_wall);           // swap x/y that's right

            float2 dx = ddx(uv_main) * _MipLevel;
            float2 dy = ddy(uv_main) * _MipLevel;

            MapsStruct Tube, GateA, GateB;
            Tube.Albedo =   tex2D(_MainTex,           uv_mixed, dx, dy).rgba;
            Tube.Metal =    tex2D(_MetallicSmoothness,uv_mixed, dx, dy).rgba;
            Tube.Emit =     tex2D(_Emission,          uv_mixed, dx, dy).rgb;
            Tube.Norm =     tex2D(_NormalMap,         uv_mixed, dx, dy).xyzw;

            GateB.Albedo =  tex2D(_MainTex,           uv_gateb, dx, dy).rgba;
            GateB.Metal =   tex2D(_MetallicSmoothness,uv_gateb, dx, dy).rgba;
            GateB.Emit =    tex2D(_Emission,          uv_gateb, dx, dy).rgb;
            GateB.Norm =    tex2D(_NormalMap,         uv_gateb, dx, dy).xyzw;

            GateA.Albedo =  tex2D(_MainTex,           uv_gatea, dx, dy).rgba;
            GateA.Metal =   tex2D(_MetallicSmoothness,uv_gatea, dx, dy).rgba;
            GateA.Emit =    tex2D(_Emission,          uv_gatea, dx, dy).rgb;
            GateA.Norm =    tex2D(_NormalMap,         uv_gatea, dx, dy).xyzw;

            // Mixing Maps with shadows and fog
            Tube.Albedo.rgb = lerp(Tube.Albedo.rgb * tubeshadows, _FogCol, tubefog.x);
            Tube.Albedo.a =  saturate(Tube.Albedo.a + mask_top + _UseAlpha);
            Tube.Metal.r =    lerp(Tube.Metal.r, 0.0,                      tubefog.x);    
            Tube.Metal.g =    saturate(tubeshadows                       - tubefog.z);
            Tube.Emit =       lerp(Tube.Emit, 0.0,                         tubefog.x);    
            Tube.Norm =       lerp(Tube.Norm, FixWallNormal(Tube.Norm, uv_wall.xy), mask_wall);
            Tube.Norm =       lerp(Tube.Norm, NormColor,                   tubefog.x);

            GateB.Albedo.rgb = lerp(GateB.Albedo.rgb * gatebshadow, _FogCol.rgb, tubefog.y);
            GateB.Albedo.a *= GateB_switchdeep - GateB_switchdeep * _Step * (1.0 - t3);   // step blinking
            GateB.Metal.r =   lerp(GateB.Metal.r, 0.0,                     tubefog.y);
            GateB.Metal.g =   saturate(gatebshadow - tubefog.z);
            GateB.Emit =      lerp(GateB.Emit, 0.0,                        tubefog.y);
            GateB.Norm.yzw =  AxisNormalRotation(GateB.Norm.yzw, t1); // rotate normal opposite direction / unity have a normal map handling where XYZW seen as ZYYX / (0.5, 0.5, 1.0, -) as (1.0, 0.5, -, 0.5)
            GateB.Norm =      lerp(GateB.Norm.xyyw, NormColor,             tubefog.y);

            GateA.Albedo.rgb = lerp(GateA.Albedo.rgb * gateashadow, _FogCol.rgb, tubefog.y);
            GateA.Albedo.a *= mask_gatea; 
            GateA.Metal.r =   lerp(GateA.Metal.r, 0.0,                     tubefog.y);
            GateA.Metal.g =   saturate(gateashadow                       - tubefog.z);
            GateA.Emit =      lerp(GateA.Emit, 0.0,                        tubefog.y);
            GateA.Norm =      lerp(GateA.Norm, NormColor,                  tubefog.y);

            half GateA_switchdeep = lerp(GateA.Albedo.a, mask_gatea, switchdeep);

            // Mixing Tube, GateB, GateA parts
            Tube.Albedo.rgb = lerp(Tube.Albedo.rgb, GateB.Albedo.rgb, GateB.Albedo.a);
            Tube.Albedo.a =   lerp(Tube.Albedo.a,   1.0,              GateB.Albedo.a);
            Tube.Metal.r =    lerp(Tube.Metal.r,    GateB.Metal.r,    GateB.Albedo.a);
            Tube.Metal.g =    lerp(Tube.Metal.g,    GateB.Metal.g,    GateB.Albedo.a);
            Tube.Metal.a =    lerp(Tube.Metal.a,    GateB.Metal.a,    GateB.Albedo.a);
            Tube.Emit =       lerp(Tube.Emit,       GateB.Emit,       GateB.Albedo.a);
            Tube.Norm =       lerp(Tube.Norm,       GateB.Norm,       GateB.Albedo.a);

            Tube.Albedo.rgb = lerp(Tube.Albedo.rgb, GateA.Albedo.rgb, GateA.Albedo.a);
            Tube.Albedo.a =   lerp(Tube.Albedo.a,   1.0,              GateA.Albedo.a);
            Tube.Metal.r =    lerp(Tube.Metal.r,    GateA.Metal.r,    GateA.Albedo.a);    // .Metal.r as Metallic
            Tube.Metal.g =    lerp(Tube.Metal.g,    GateA.Metal.g,    GateA.Albedo.a);    // .Metal.g as Occlusion
            Tube.Metal.a =    lerp(Tube.Metal.a,    GateA.Metal.a,    GateA_switchdeep);  // .Metal.a as Smoothness
            Tube.Emit =       lerp(Tube.Emit,       GateA.Emit,       GateA.Albedo.a) * t3 * _Emit;
            Tube.Norm =       lerp(Tube.Norm,       GateA.Norm,       GateA_switchdeep);

            // Diffuse-Specular from Albedo-Metallic
            half3 specular = lerp(half3(0.04, 0.04, 0.04), Tube.Albedo.rgb, Tube.Metal.r);
            half3 diffuse = Tube.Albedo.rgb * (0.96 - Tube.Metal.r * 0.96);
            Tube.Albedo.rgb = diffuse;
            Tube.Metal.r = specular;

            MapsStruct o;
            o.Albedo = Tube.Albedo;
            o.Metal = Tube.Metal;
            o.Emit = Tube.Emit;
            o.Norm =  Tube.Norm;
            return o;
        }

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            float2 uv = IN.uv_MainTex;
            MapsStruct c = FakeTube(uv, IN.viewDir);

            o.Albedo = c.Albedo.rgb;
            o.Alpha = c.Albedo.a;
            o.Specular = c.Metal.rrr;
            o.Occlusion = c.Metal.g;
            o.Smoothness = c.Metal.a;
            o.Emission = c.Emit.rgb;
            o.Normal = UnpackNormal(c.Norm);
        }
        ENDCG
    }
    FallBack "Diffuse"
}





