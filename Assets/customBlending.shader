Shader "Custom/customBlending"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags ������ Transparent �� �ٲ����ν�, ���� ���̴��� '���� ���� ���̴�(������ ���̴�)'�� ��ȯ��.
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off // ���� ���� ���̴������� z���۸� ��Ȱ��ȭ�ؾ� ��. �� ������ p.463 - 464 ����
        cull off // �� �߷����⸦ ��Ȱ��ȭ�Ͽ� quad �޽��� ��鿡�� ���̵��� ��.

        blend SrcAlpha OneMinusSrcAlpha // ���� �ɼ��� 'Alpha Blending' ���� ������ ��. -> ���� �Ϲ����� ���� ���� ����. ���� ����� ���Ŀ� ���� ����. p.473~474 ����

        CGPROGRAM

        // Lambert ����Ʈ �⺻������ ����
        #pragma surface surf Lambert keepalpha // ���� ����Ƽ�� ���ǽ� ���̴����� �⺻������ ������ ���̴�("RenderType"="Opaque") �� ���İ��� 1.0���� ������Ŵ. �̰� ������Ű�� ���� keepalpha �� ���� ��.

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
