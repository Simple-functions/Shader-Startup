// p152 최종 BlinnPhong
Shader "Custom/SurfaceShaderBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // BlinnPhong에서 필요한 속성을 추가한다.
        _SpecColor ("Specular Material Color", Color) = (1, 1, 1, 1)
        _Shininess("Shininess", Range(0.03, 1)) = 0.078125
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        // 표준 모델 대신 BlinnPhong을 사용한다.
        // - surf pragma를 BlinnPhong으로 변경한다.
        #pragma surface surf BlinnPhong fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        // 속성 정의
        float _Shininess;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        // SurfaceOutputStandard 대신에 SurfaceOutput 데이터 구조체를 취한다.
        // - inout SurfaceOutput으로 변경
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Specular = _Shininess;
            o.Gloss = c.a;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
