// p115 엠비언트 값 추가
// 엠비언트는 기본적으로 절단(cutoff) 값이다.
// - 어느 값 이하로 디퓨즈 값을 떨어뜨리지 않는다.
// -- 일정 밝기 이하로 계산된 값은 밝기 하한선 값으로 모조리 보간
Shader "Custom/DiffuseShader 3"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _DiffuseTex ("Texture", 2D) = "white" {}
        _Ambient ("Ambient", Range(0, 1)) = 0.25    // 내적값 nl을 보간하는 값 추가
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
                float3 worldNormal : TEXCOORD1;
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

                // float nl = max(0.0, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                // 기존 내적값은 최소값을 0으로 하드코딩
                // 내적값 보간용으로 추가한 변수 _Ambient를 내적 계산식에 할당한다.
                float nl = max(_Ambient, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                float4 diffuseTerm = nl * _Color * tex * _LightColor0;  

                return diffuseTerm;
            }
            ENDCG
        } 
    }
}
