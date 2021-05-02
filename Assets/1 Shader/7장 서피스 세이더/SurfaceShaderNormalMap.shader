// p144 기본 서피스 세이더
Shader "Custom/SurfaceShaderNormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
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
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // 해당 셰이더에 인스턴스 서포트를 추가한다. 이 셰이더를 활용하는 재질에 '인스턴싱 활성화'를 체크해야 한다.
        // 인스턴싱에 대한 자세한 정보는 https://docs.unityed.com/Manual/GPUInstancing.html이 사이트를 참고한다.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // 각 인스턴스별 프로퍼티는 여기에 넣는다.
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 색상이 스며든 텍스처에서 알베도값을 가져온다.
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            o.Albedo = c.rgb;
            // 금속성(metallic)과 부드러움(smoothness)정도는 슬라이더 변수에서 가져온다.
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
