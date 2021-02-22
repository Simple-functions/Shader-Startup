// p68 속성 추가
// 값을 하드코딩하는 것은 좋은 습관이 아니다.
// 색상값을 원하는대로 바꾸기 위해, 속성에 색상 속성을 정의한다.

// 유니티 셰이더는 두 가지 언어가 섞여있다.
    // 1. Cg라는 NVIDIA에서 개발한 셰이더 언더
        // CGPROGRAM과 ENDCG문 사이에 있는 것들이 이 언어로 작성됨
    // 2. 셰이더랩(ShaderLab) 언어
        // 유니티에서만 사용하는 Cg를 확장한 언어다.
        // CGPROGRAM 바깥에 있는 언어가 이 언어로 작성됨
        // _Color 변수를 선언해야 한다.
        // 이를 통해 Cg 언어로 작성한 코드가 셰이더랩 쪽에 존재하는 속성을 인지할 수 있다.

Shader "Unlit/3 RedShader"
{
    // 속성 블록 구성 : _이름 ("설명", 타입) = 기본값
    Properties
    {
        // 색상타입(Color)의 기본값 (1, 0, 0, 1)을 가지는 _Color 변수 선언
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


            // 선언한 속성을 사용하기 위해 CGPROGRAM / ENDCG 사이에 _Color 선언을 추가한다.
            // 속성의 이름 _Color와 내부 선언 변수 이름은 같아야 제대로 작동한다.
            fixed4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 프레그먼트 함수 내의 return문을 바꿔 _Color 변수를 실제로 사용하자
                // return fixed4(1, 0, 0, 1);
                return _Color;
            }
            
            ENDCG
        }
    }
}
