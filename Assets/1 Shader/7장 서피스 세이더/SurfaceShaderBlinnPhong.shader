// p152 ���� BlinnPhong
Shader "Custom/SurfaceShaderBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // BlinnPhong���� �ʿ��� �Ӽ��� �߰��Ѵ�.
        _SpecColor ("Specular Material Color", Color) = (1, 1, 1, 1)
        _Shininess("Shininess", Range(0.03, 1)) = 0.078125
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        // ǥ�� �� ��� BlinnPhong�� ����Ѵ�.
        // - surf pragma�� BlinnPhong���� �����Ѵ�.
        #pragma surface surf BlinnPhong fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        // �Ӽ� ����
        float _Shininess;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        // SurfaceOutputStandard ��ſ� SurfaceOutput ������ ����ü�� ���Ѵ�.
        // - inout SurfaceOutput���� ����
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
