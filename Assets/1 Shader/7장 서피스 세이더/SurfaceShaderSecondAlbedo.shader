// p144 기본 서피스 세이더
Shader "Custom/SurfaceShaderNormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondAlbedo ("Second Albedo (RGB)", 2D) = "white" {}  // 두 번째 텍스처 추가
        _AlbedoLerp ("Albedo Lerp", Range(0, 1)) = 0.5          // 슬라이더 값 추가
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // 물리 기반 표준 라이팅 모델 사용, 모든 광원 타입에 그림자 활성화
        #pragma surface surf Standard fullforwardshadows

        // 라이팅 효과가 더 멋져 보이도록 셰이더 모델 3.0 타깃 사용
        #pragma target 3.0

        sampler2D _MainTex;
        // 속성에 선언한 값을 다시 선언해준다.
        // - 두번째 텍스처를 위한 다른 UV 집합을 넣어야 되지 않나?
        // -- 텍스처가 동일한 UV 구조를 가지고 있다면 하나의 UV 집합을 재활용 가능하다.
        sampler2D _SecondAlbedo;
        half _AlbedoLerp;

        struct Input
        {
            float2 uv_MainTex;
            
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            // 라이팅 함수에 정보를 보내기 앞서 
            // 기본적으로 셰이더의 입력 데이터(텍스처 및 각종 값들)를 처리한다.
            // - 따라서 동일한 UV와 함께 두 번째 테스트를 살펴보고
            // - 둘을 선형 보간한 결과 값을 알베도 출력에 할당해야 한다.
            fixed4 secondAlbedo = tex2D(_SecondAlbedo, IN.uv_MainTex);
            o.Albedo = lerp(c, secondAlbedo, _AlbedoLerp) * _Color;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
