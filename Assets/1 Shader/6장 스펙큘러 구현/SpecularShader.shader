// p121 스펙큘러 추가
Shader "Custom/SpecularShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _DiffuseTex ("Texture", 2D) = "white" {}
        _Ambient ("Ambient", Range(0, 1)) = 0.25
        // 두 개의 신규 속성 추가
        // 스펙큘러 색상
        _SpecColor("Specular material Color", Color) = (1, 1, 1, 1)
        // 스펙큘러 강도
        _Shininess("Shininess", Float) = 10
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase"}
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;  
            };

            // [출력 구조체 v2f] v2f : vertex to fragment
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                // 월드 공간 정점 위치 계산용
                // 정점 셰이더에서 계산해서 프래그먼트에 전달용
                float4 vertexWorld : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;
            float4 _Color;
            float _Ambient; // 내적값을 보간하는 변수 추가

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex);    
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);

                float4 tex = tex2D(_DiffuseTex, i.uv);

                float nl = max(_Ambient, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                float4 diffuseTerm = nl * _Color * tex * _LightColor0;  

                return diffuseTerm;
            }
            ENDCG
        } 
    }
}
