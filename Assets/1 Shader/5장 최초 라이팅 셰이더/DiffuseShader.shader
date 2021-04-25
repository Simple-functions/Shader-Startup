// p106 최초 유니티 라이팅 셰이더
// monochrome 셰이더에 디퓨즈 항을 추가한다.
Shader "Custom/DiffuseShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        // 이 패스를 포워드 렌더러의 첫 번째 라이트 패스로 사용한다.
        // 첫 번째 빛을 제외한 다른 빛은 최종 결과에 영향을 미치지 않는다.
        Tags { "LightMode" = "ForwardBase"}
        // 다른 빛도 영향을 주길 원할 경우 또 다른 패스를 추가하고 아래 태그를 입력한다.
        // Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            // UnityLightingCommon.cginc : 라이팅 셰이더에 필요한 많은 유용한 변수 및 함수들이 담긴 파일
            #include "UnityLightingCommon.cginc"
            
            // 4장에서 노멀 벡터와 빛의 방향벡터의 좌표 공간을 일치시켜야 한다고 했음
            // 객체 공간을 사용해선 안됨.
                // 빛은 렌더링하는 모델의 바깥에 존재하기 때문
                // 라이팅 계산에 적합한 공간은 월드 공간

            // [입력 구조체 appdata]
            // 1. 먼저 렌더러에게 노멀 벡터에 대한 정보를 받음
                // 렌더러에 요청하는 정보가 담긴 appdata에 노멀 슬롯을 하나 추가필요
            struct appdata
            {
                float4 vertex : POSITION;
                // NORMAL 시맨틱 선언을 추가해 노멀을 사용하겠다고 컴파일러에 알려주고 있음에 주목.
                    // 이 방법 말곤 렌더러에 원하는 바를 이해시킬수 없음.
                // 이 정점 함수에서 노멀 위치 벡터를 월드 공간에서 계산해야 함.
                    // 다행이 이와 관련된 UnityObjectToWorldNormal이라는 편리한 함수가 존재함
                    // appdata를 통해 정점 셰이더로 전달한 노말 벡터 : 기존 객체 공간 -> 월드 공간 변환함
                float3 normal : NORMAL;
            };

            // [출력 구조체 v2f] v2f : vertex to fragment
            struct v2f
            {
                float4 vertex : SV_POSITION;
                // 출력 구조체에 결과 값을 할당하기 위해 TEXCOORD0를 추가한다.
                // - 3차원 혹은 4차원 벡터에 적합한 슬롯 사용 신고
                float3 worldNormal : TEXCOORD0;
            };

            float4 _Color;

            // [appdata 구조체] -> [정점 셰이더 vert] 필요 데이터 전달
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal); // 월드 노멀 벡터 계산
                o.worldNormal = worldNormal;    // 출력 데이터 구조체에 할당

                // [출력 구조체 v2f]할당 후 반환
                return o;
            }

            // [출력 셰이더 프레그먼트 셰이더 frag]
            // 광원의 색상을 _LightColor0을 통해 얻을 수 있다.
            // - 위에 include로 추가한 파일에 _LightColor0가 존재한다.
            // 월드 공간상의 씬 내의 첫 번째 광원의 위치 : _WorldSpaceLightPos0 로 구할수 있음.
            // 벡터의 원소에 접근하고 싶을 때 점을 찍은 다음 r, g, b, a 혹은 x, y, z, w를 추가한다.
            // - 벡터가 가지고 있는 원소값 직접접근 가능
            // -- ex) c라는 배열의 볓 번째 원소에 접근할 때 [0], [1]을 사용하는 것과 비슷한 원리.
            // -- 이것을 스위즐 연산(swizzle operator)이라고 한다.
            // -- 스위즐 연산은 배열 인덱싱보다 더 많은 일을 할 수도 있다.
            // 변환 거치면 벡터크기가 1이 아닐수도 있다.
            // - 프레그먼트 셰이더에서는 우선 worldNormal 값을 정규화해야 한다.
            // - 후, 노멀 값, 빛의 위치 벡터의 내적을 계산한다.
            // - 계산 결과 음수값 되지않도록 주의한다.
            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);  // 정규화

                float nl = max(0.0, dot(normalDirection, _WorldSpaceLightPos0.xyz));    // 값이 음수가 되지 않도록 값을 변환한다.
                float4 diffuseTerm = nl * _Color * _LightColor0;    // 

                return diffuseTerm;
            }
            ENDCG
        } 
    }
}
