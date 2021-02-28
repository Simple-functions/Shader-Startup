// 셰이더의 경로와 이름
// 파일 이름과 셰이더 경로는 다르게 지정 가능하다.
Shader "Unlit/1 RedShader"
{
    // 특성(Properties)
    // 인스펙터 창에 보여질 각각의 특성을 여기에 선언한다. 어떤 것들은 선언할 필요가 없다. 
    // 이 경우는 오직 한 텍스처만 선언한다.
    // 원하는 만큼 선언할수 있지만 플랫폼의 한계를 넘는 경우 경고 발생
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    // 하위 셰이더(Sub-Shader)
    // 한 개 이상의 셰이더 내의 하위 셰이더를 둔다.
    // 하위 셰이더는 여러 종류가 있다.
    // 셰이더 로딩 -> 유니티는 여러 셰이더 중 GPU에서 지원하는 첫 번째 하위 셰이더를 사용한다.
    // 각각의 하위 셰이더는 렌더링 패스(pass)의 리스트를 포함한다. - 이펙트를 다루는 장에서 자세히 설명
    SubShader
    {
        // 태그(Tag)
        // - 정보를 표현하는 키와 값의 쌍으로 구성돼 있다.
        // 예) 어떤 렌더링 큐를 사용할지 지정
        // Opaque - 투명 및 불투명 게임 오브젝트는 각기 다른 렌더링 큐에서 렌더링
        Tags { "RenderType"="Opaque" }
        LOD 100

        // 패스(Pass)
        // 렌더링을 위한 정보와 실제로 셰이더에서 계산하는 코드와 같은 정보를 포함한다.
        // 패스는 C#스크립트로부터 하났기 분리돼 수행될 수 있다.
        Pass
        {
            // CGPROGRAM
            // 명령어의 처음
            CGPROGRAM

            // 정점 셰이더와 픽셀 셰이더에 사용할 함수들을 지정하는 것과 같은 옵션 설정 방법들을 제공한다.
            // 셰이더 컴파일러에게 정보를 전달하는 방법
            // 일부 pragmas는 자동으로 동일한 셰이더에 각기 다른 버전을 컴파일하는데 사용될 수 있다.
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            // 셰이더 컴파일을 하는데 포함시키고자 하는 "라이브러리" 파일을 지정한다.
            #include "UnityCG.cginc"

            // 입력과 출력 구조체

            // 입력 - 정보 입력 구조체 역할
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // 출력 - 정보 전달(출력) 구조체 역할
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                
                // 시맨틱(semantics)
                // 콜론(:) 다음에 오는 단어
                // 컴파일러에게 구조체 내 특정한 멤버 내에 어떤 종류의 정보를 저장하고자 하는지 알려준다.
                // 시맨틱은 미리 정의돼 있다.
                float4 vertex : SV_POSITION;

                // SV 접두어 : 시스템 값(System value)
                // 파이프라인에서 특정한 위치를 참조함
            };

            // 변수 선언
            // 특성 블록 내에 정의된 모든 특성은 CGPROGRAM 블록 안에 적합한 타입의 변수로 다시 정의돼야 한다.
            // 특성에서 선언한 _MainTex 특성을 동일한 이름으로 sampler2D로 적합하게 정의한다.
                // 이를 나중에 정점과 프레그먼트 함수 내에서 사용한다.
            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 정점 함수
            // pragma로 정의했던 정점함수
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // 프레그먼트 함수
            // pragma로 정의했던 프레그먼트 함수
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            
            // ENDCG
            // 명령어의 끝
            ENDCG
        }
    }
}
