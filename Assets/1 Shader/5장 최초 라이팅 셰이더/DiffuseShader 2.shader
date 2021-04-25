// p113 텍스처 속성 추가
Shader "Custom/DiffuseShader 2"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _DiffuseTex ("Texture", 2D) = "white" {}    // 텍스처 속성 추가
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
                float3 worldNormal : TEXCOORD1; // 0 -> 1로 변경
                // v2f에서 월드 노말벡터 시맨틱 texcoord0을 사용했기 때문에 이걸 TEXCOORD1로 바꾼후 추가한다.
                // - 이유 : GPU에 데이터 구조체 내에 보간된 텍스처 UV를 달라고 요청해야되기 때문
                // - 접근 가능한 텍츠서 보간자(interpolator)의 수는 유한하다.
                // -- 이는 기계 내의 GPU따라감.
                // -- GPU 가능 범위 이상으로 요청시 에러남.
            };

            // 텍스처를 위한 변수 추가
            sampler2D _DiffuseTex;  // 속성에서 추가한 텍스처
            float4 _DiffuseTex_ST;  // TRANSFORM_TEX 매크로 함수에서 사용하는 변수
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // 텍스처 좌표의 크기와 위치를 조절한다.
                // - 재질 내의 어떤 크기와 위치 관련 변화를 적용할 수 있다.
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex);    
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);

                float4 tex = tex2D(_DiffuseTex, i.uv);  // 텍스처를 샘플링

                float nl = max(0.0, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                // 샘플링된 텍스처와 기존 _Color 속성을 사용해 디퓨즈 계산 수행
                // - 샘플링된 텍스처 색상 tex
                // - 색상값 : _Color
                // - 노멀 벡터와 위치 벡터의 내적 : nl
                // -- 세가지 변수를 합쳐 최종 색상 구현
                float4 diffuseTerm = nl * _Color * tex * _LightColor0;  

                return diffuseTerm;
            }
            ENDCG
        } 
    }
}
