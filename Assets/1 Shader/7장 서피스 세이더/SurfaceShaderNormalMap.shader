// p144 기본 서피스 세이더
Shader "Custom/SurfaceShaderNormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // 노멀 맵을 위한 속성 추가
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        // 선언한 속성 다시 선언
        sampler2D _NormalMap;

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
            // surf 함수에 해당 변수를 다루는 적합한 코드를 추가한다.
            // - 텍스처를 샘플링 하는 것(마찬가지로 메인 텍스처 UV 필요)과
            // - 그 결과를 UnpackNormal 함수에 적용하는 것이 필요하다.
            // - 결과를 서피스 출력 데이터 구조체의 노멀 멤버에 할당한다.
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
