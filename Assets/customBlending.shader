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

        // blend SrcAlpha OneMinusSrcAlpha // ���� ���� ������ 'Alpha Blending' ���� ����. -> ���� �Ϲ����� ���� ���� ����. ���� ����� ���Ŀ� ���� ����. p.473 ~ 474 ����
        // blend SrcAlpha One // ���� ���� ������ 'Additive' �� ����. -> ���� 'Add ���' ��� �θ��� ���� ���. ��ġ�� ��ĥ���� �������, ���� ȿ�� � �����. p.475 ~ 476 ���� 
        // blend one one // ���� ���� ������ 'Additive No Alpha Black is Transparent' �� ����. -> �� ���� Ư¡�� ����: 1. ���İ��� ������ �ȵȴ�.(1�θ� �����ִϱ�!) 2. Source �� ������ �κи� �����ϰ� ó���ȴ�. p.476 ~ 478 ���� 
        blend DstColor Zero // ���� ���� ������ '2x Multiplicative' �� ����. -> ���� 'Multi ���' ��� �θ��� ���� ���. �ҽ��� ����� ������ �׳� ���ع����� �� ��ο����� ��������. (�׷��� Source �� ����ϼ��� ������ �״�� ����.) p.478 ~ 480 ����

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
            float4 final = lerp(float4(1, 1, 1, 1), c, c.a); // 2x Multiplicative ���� ������ �״�� ���̰� �Ϸ���, �̷� ������ surf �Լ����� ���İ��� 0�� ��� �κ��� ���(float4(1, 1, 1, 1))���� ����ϴ� ������ Ȱ���� �� ����.
            o.Albedo = final.rgb;
            o.Alpha = final.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
