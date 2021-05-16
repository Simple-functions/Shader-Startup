// p144 �⺻ ���ǽ� ���̴�
Shader "Custom/SurfaceShaderNormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondAlbedo ("Second Albedo (RGB)", 2D) = "white" {}  // �� ��° �ؽ�ó �߰�
        _AlbedoLerp ("Albedo Lerp", Range(0, 1)) = 0.5          // �����̴� �� �߰�
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // ���� ��� ǥ�� ������ �� ���, ��� ���� Ÿ�Կ� �׸��� Ȱ��ȭ
        #pragma surface surf Standard fullforwardshadows

        // ������ ȿ���� �� ���� ���̵��� ���̴� �� 3.0 Ÿ�� ���
        #pragma target 3.0

        sampler2D _MainTex;
        // �Ӽ��� ������ ���� �ٽ� �������ش�.
        // - �ι�° �ؽ�ó�� ���� �ٸ� UV ������ �־�� ���� �ʳ�?
        // -- �ؽ�ó�� ������ UV ������ ������ �ִٸ� �ϳ��� UV ������ ��Ȱ�� �����ϴ�.
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
            // ������ �Լ��� ������ ������ �ռ� 
            // �⺻������ ���̴��� �Է� ������(�ؽ�ó �� ���� ����)�� ó���Ѵ�.
            // - ���� ������ UV�� �Բ� �� ��° �׽�Ʈ�� ���캸��
            // - ���� ���� ������ ��� ���� �˺��� ��¿� �Ҵ��ؾ� �Ѵ�.
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
