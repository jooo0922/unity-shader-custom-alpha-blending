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

        // blend SrcAlpha OneMinusSrcAlpha // 블렌딩 팩터 연산을 'Alpha Blending' 으로 적용. -> 가장 일반적인 블렌드 팩터 연산. 대상과 배경이 알파에 의해 섞임. p.473 ~ 474 참고
        // blend SrcAlpha One // 블렌딩 팩터 연산을 'Additive' 로 적용. -> 흔히 'Add 모드' 라고 부르는 블렌딩 방식. 겹치면 겹칠수록 밝아져서, 폭발 효과 등에 사용함. p.475 ~ 476 참고 
        // blend one one // 블렌딩 팩터 연산을 'Additive No Alpha Black is Transparent' 로 적용. -> 두 가지 특징이 있음: 1. 알파값이 적용이 안된다.(1로만 곱해주니까!) 2. Source 의 검은색 부분만 투명하게 처리된다. p.476 ~ 478 참고 
        blend DstColor Zero // 블렌딩 팩터 연산을 '2x Multiplicative' 로 적용. -> 흔히 'Multi 모드' 라고 부르는 블렌딩 방식. 소스와 배경의 색상값을 그냥 곱해버려서 더 어두워지게 만들어버림. (그래서 Source 가 흰색일수록 배경색이 그대로 나옴.) p.478 ~ 480 참고

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
            float4 final = lerp(float4(1, 1, 1, 1), c, c.a); // 2x Multiplicative 에서 배경색을 그대로 보이게 하려면, 이런 식으로 surf 함수에서 알파값이 0인 배경 부분을 흰색(float4(1, 1, 1, 1))으로 출력하는 공식을 활용할 수 있음.
            o.Albedo = final.rgb;
            o.Alpha = final.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
