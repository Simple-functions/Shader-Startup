// p77
Shader "Unlit/1 MonochromeShader"
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

            // 1. 정점 데이터 구조체
            // 입력 조립 단계에 대응하는 appdata
            // 구조체의 멤버에 어떤 시맨틱을 추가함으로써 입력 조립 단계에서
                // 사용 가능 데이터중
                // 원하는 데이터가 무엇인지 알려줌
            struct appdata
            {
                float4 vertex : POSITION;
                // POSITION은 셰이더 시맨틱
                    // 멤버의 목적과 관련된 정보를 전달하는 셰이더 데이터 구조체에 붙어있는 문자열
                    // ★ 시맨틱과 데이터 타입은 반드시 일치해야 한다. (고차원화된 셰이더 제작시 에러 발생하면 문제)
                        // IF 하나의 실수형(float) : 하나의 POSITION 시맨틱 대응시
                        // - float4 값은 암묵적으로 float 값으로 잘려나감
                // 데이터 타입 float4 : 변수의 "모양" 설정
                // 시맨틱 : 해당 변수에 할당될 값 결정

                // 유니폼(uniform) : 전역적으로 전달할수 있는 데이터 혹은 셰이더에 있는 속성
            };

            // 3. 프레그먼트 데이터 구조체
            // v2f 데이터 구조체에 어떤 멤버를 추가하느냐?
                // 정점 셰이더에서 전달받은 데이터 중 어떤 데이터를 전달할 수 있는지를 결정한다.
            struct v2f
            {
                float4 vertex : SV_POSITION;
                // 오직 처리한 정점의 2D 위치만을 담고있음
                // 시맨틱은 중복해서 사용하면 안된다.
                    // 예 : 이 경우 두 번째 멤버에 SV_POSITION 할당 금지
            };

            // 2. 프로그래밍 가능한 단계인 정점 처리 단계로 정점 셰이더 함수가 실행된다.
            // 이 함수는 appdata 데이터 구조체를 인자로 하고 두 번째 구조체인 v2f를 반환한다.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
                // 정점 셰이더에 필요한 최소한의 요구사항
                    // 정점 좌표 공간에서 레스터라이저가 사용하는 좌표 공간으로 변환
                    // - 이를 UnityObjectToClipPos 함수가 수행
            }

            // 4. 프레그먼트 함수
            // 다음으로 프로그래밍이 가능한 단계
            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
                // 사실 어디에서도 프레그먼트의 반환값 fixed4를 사용하지 않았다.
                // 근데 이 함수 지우면 작동안됨
                    // ★ 셰이더 코드에 안보일뿐 그래픽스 파이프라인에서 사용함
                // SV_Target : 출력 시맨틱
                    // 하나의 프레그먼트 색상 출력 의미
            }
            
            // 이 셰이더 3D 씬 공간에서 2D 렌더링 대상 공간으로 변환 의미함
            // 실제로 3D 모델 2D 화면에 렌더링해서 그럼
                // 하지만 이게 레스터라이저 기능 제대로 보여주고있진 않음
            
            ENDCG
        }
    }
}
