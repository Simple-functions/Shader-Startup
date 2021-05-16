// p144 �⺻ ���ǽ� ���̴�
Shader "Custom/SurfaceShaderNormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // ��� ���� ���� �Ӽ� �߰�
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
        // ������ �Ӽ� �ٽ� ����
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
            // surf �Լ��� �ش� ������ �ٷ�� ������ �ڵ带 �߰��Ѵ�.
            // - �ؽ�ó�� ���ø� �ϴ� ��(���������� ���� �ؽ�ó UV �ʿ�)��
            // - �� ����� UnpackNormal �Լ��� �����ϴ� ���� �ʿ��ϴ�.
            // - ����� ���ǽ� ��� ������ ����ü�� ��� ����� �Ҵ��Ѵ�.
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
