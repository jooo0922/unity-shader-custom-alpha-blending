Shader "Custom/customBlending"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags 설정을 Transparent 로 바꿈으로써, 현재 쉐이더를 '알파 블렌드 쉐이더(반투명 쉐이더)'로 변환함.
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off // 알파 블렌딩 쉐이더에서는 z버퍼를 비활성화해야 함. 그 이유는 p.463 - 464 참고
        cull off // 면 추려내기를 비활성화하여 quad 메쉬가 양면에서 보이도록 함.

        blend SrcAlpha OneMinusSrcAlpha // 블렌딩 옵션을 'Alpha Blending' 으로 설정해 줌. -> 가장 일반적인 블렌드 팩터 연산. 대상과 배경이 알파에 의해 섞임. p.473~474 참고

        CGPROGRAM

        // Lambert 라이트 기본형으로 시작
        #pragma surface surf Lambert keepalpha // 원래 유니티는 서피스 셰이더에서 기본적으로 불투명 쉐이더("RenderType"="Opaque") 의 알파값을 1.0으로 고정시킴. 이걸 해제시키기 위해 keepalpha 를 써준 것.

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
