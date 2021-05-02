// p136 기본 서피스 세이더
Shader "Custom/defaultSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        // 물리 기반 표준 라이팅 모델 사용, 모든 광원 타입에 그림자 활성화
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        // 라이팅 효과가 더 멋져 보이도록 셰이더 모델 3.0 타깃 사용
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // 해당 셰이더에 인스턴스 서포트를 추가한다. 이 셰이더를 활용하는 재질에 '인스턴싱 활성화'를 체크해야 한다.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // 인스턴싱에 대한 자세한 정보는 https://docs.unityed.com/Manual/GPUInstancing.html이 사이트를 참고한다.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
            // 각 인스턴스별 프로퍼티는 여기에 넣는다.
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            // 색상이 스며든 텍스처에서 알베도값을 가져온다.
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            // 금속성(metallic)과 부드러움(smoothness)정도는 슬라이더 변수에서 가져온다.
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
