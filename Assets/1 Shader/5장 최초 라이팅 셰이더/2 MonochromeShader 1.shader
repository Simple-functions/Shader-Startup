// p106 최초 유니티 라이팅 셰이더
// monochrome 셰이더에 디퓨즈 항을 추가한다.
Shader "Custom/DiffuseShader 2"
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

            // UnityLightingCommon.cginc : 라이팅 셰이더에 필요한 많은 유용한 변수 및 함수들이 담긴 파일
            #include "UnityLightingCommon.cginc"
            #include "UnityCG.cginc"
            
            // 4장에서 노멀 벡터와 빛의 방향벡터의 좌표 공간을 일치시켜야 한다고 했음
            // 객체 공간을 사용해선 안됨.
                // 빛은 렌더링하는 모델의 바깥에 존재하기 때문
                // 라이팅 계산에 적합한 공간은 월드 공간
            // 1. 렌더러에게 노멀 벡터에 대한 정보를 받음
                // 렌더러에 요청하는 정보가 담긴 appdata에 노멀 슬롯을 하나 추가필요

            fixed4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                // NORMAL 시맨틱 선언을 추가해 노멀을 사용하겠다고 컴파일러에 알려주고 있음에 주목.
                    // 이 방법 말곤 렌더러에 원하는 바를 이해시킬수 없음.
                // 이 정점 함수에서 노멀 위치 벡터를 월드 공간에서 계산해야 함.
                float3 normal : NORMAL;
            };

            // 2. v2f에 추가
            // 정확히 동일한 멤버 변수를 추가해야함
            // 이런 구조 마음에 안들지도 모르는데
            // 바꿔서 조지는건 님책임
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            // 3. 정점 함수에 색상 할당
            // 구조체에 적당한 멤버 변수 추가후 정점 함수에 한줄 추가
            // appdata 변수 v
                // v.color : appdata의 색상 멤버 변수
            // v2f 변수 o
                // o.color : v2f 색상 멤버 변수로
            // o.color = v.color로 할당
            // 정점 색상 데이터 -> 레스터라이저 통과함 -> 레스터라이저 색상 보간
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                return o;
            }

            // 4. 프레그먼트 함수에서 색상값 사용하기
            // v2f에 담긴 보간값을 사용한다.
            fixed4 frag (v2f i) : SV_Target
            {
                // return _Color;
                return i.color;
            }


            ENDCG
        } 
    }
}
