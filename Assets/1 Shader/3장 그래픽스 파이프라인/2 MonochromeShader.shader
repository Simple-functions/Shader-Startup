// p80
// 정점 색상 지원 추가
// 이 셰이더 정점 색상을 추가해보자.
// 정점과 함께 보간을 수행하는 레스터라이저에 전달할 다른 값 전달
Shader "Unlit/2 MonochromeShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            fixed4 _Color;

            // 1. appdata에 추가
            // 메시 정점 색상 채울 멤버를 추가하려면
                // 멤버 이름과 시맨틱에 주의
                // 권장 방법
                    // 멤버 이름 : color
                    // 시맨틱 : COLOR 추가
                // 플랫폼에 따라 변수 이름 다르게 하고 시맨틱 이름만 COLOR로 할때 에러날수 있음
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
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
