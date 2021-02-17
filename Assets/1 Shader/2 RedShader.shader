// p64 셰이더 수정
// : 하얀색에서 빨간색으로
// 메시의 최종 색상이 빨간색이 되도록 변경할 것이다.

// p66 포그(fog) 렌더링 제거
// 나아가 포그 렌더링에 관련된 부분을 정리한다.
Shader "Unlit/2 RedShader"
{
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

            //어떻게 하면 가장 간단하게 셰이더의 출력을 빨간색으로 나오게 할 수 있을까?
            // 1장에서 배운 렌더링 파이프라인에 대해서 생각해보면
            // 프레그먼트 함수의 끝에 원하는 색상값을 하드코딩하는 방법이 떠오른다.
            fixed4 frag (v2f i) : SV_Target
            {
                // 전 : 기존 코드는 최종 반환값이 col을 통해 반환된다.
                // // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                // // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                // return col;

                // 후 : 빨간색 값만을 반환한다.
                // fixed4 : 4개의 고정 정밀도 소수를 멤버로 가진 구조체
                // fixed4 각 멤버의 의미
                // 1번 멤버 : 빨간색 (0 ~ 1)
                // 2번 멤버 : 초록색 (0 ~ 1)
                // 3번 멤버 : 파란색 (0 ~ 1)
                // 4번 멤버 : 투명도(알파값) (0 ~ 1)
                // 투명도 값은 Transparent 큐에서 렌더링하지 않는다면 알파값은 보통 무시한다.
                return fixed4(1, 0, 0, 1);

                // ★ 실수 타입 정밀도
                // (정밀도 낮음) fixed < half < float (정밀도 높음)
                // 성능이 중요한 경우 정밀도가 낮은 쪽을 고려한다.
                // 품질이 중요한 경우 정밀도가 높은 쪽을 고려한다.
            }
            
            ENDCG
        }
    }
}
