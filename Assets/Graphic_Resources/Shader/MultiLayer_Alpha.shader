//-----SecretTown------//
//---------멀티레이어 기본에 알파 사용 추가----------//
Shader "Secrettown/MultiLayer_Alpha"
{
    Properties
    {
        _Tex1 ("Texture", 2D) = "white" {}
		_Tex2 ("Texture", 2D) = "white" {}
		_Tex3 ("Texture", 2D) = "white" {}
		_Tex4 ("Texture", 2D) = "white" {}
		_Tex5 ("Texture", 2D) = "white" {}
		_Tex6 ("Texture", 2D) = "white" {}
		_Tex7 ("Texture", 2D) = "white" {}
		_Tex8 ("Texture", 2D) = "white" {}
		_Tex9 ("Texture", 2D) = "white" {}
		 _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
		
        LOD 100
		zwrite on
		cull off
		
		//Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag alphatest : _Cutoff
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
				float2 uv4 : TEXCOORD3;
				float2 uv5 : TEXCOORD4;
				float2 uv6 : TEXCOORD5;
				float2 uv7 : TEXCOORD6;
				float2 uv8 : TEXCOORD7;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
				float2 uv4 : TEXCOORD3;
				float2 uv5 : TEXCOORD4;
				float2 uv6 : TEXCOORD5;
				float2 uv7 : TEXCOORD6;
				float2 uv8 : TEXCOORD7;
            };

            sampler2D _Tex1,_Tex2,_Tex3,_Tex4,_Tex5,_Tex6,_Tex7,_Tex8,_Tex9;
            float4 _Tex1_ST,_Tex2_ST,_Tex3_ST,_Tex4_ST,_Tex5_ST,_Tex6_ST,_Tex7_ST,_Tex8_ST,_Tex9_ST;
			fixed _Cutoff;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _Tex1);
				o.uv2 = TRANSFORM_TEX(v.uv2, _Tex2);
				o.uv3 = TRANSFORM_TEX(v.uv3, _Tex3);
				o.uv4 = TRANSFORM_TEX(v.uv4, _Tex4);
				o.uv5 = TRANSFORM_TEX(v.uv5, _Tex5);
				o.uv6 = TRANSFORM_TEX(v.uv6, _Tex6);
				o.uv7 = TRANSFORM_TEX(v.uv7, _Tex7);
				o.uv8 = TRANSFORM_TEX(v.uv8, _Tex8);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
				fixed4 col;
				if ( i.uv1.x > 0.0 )
				{
					col = tex2D(_Tex1, i.uv1);
					 clip(col.a - _Cutoff);
				}
				else if ( i.uv2.x > 0.0 )
				{
					col = tex2D(_Tex2, i.uv2);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv3.x > 0.0 )
				{
					col = tex2D(_Tex3, i.uv3);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv4.x > 0.0 )
				{
					col = tex2D(_Tex4, i.uv4);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv5.x > 0.0 )
				{
					col = tex2D(_Tex5, i.uv5);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv6.x > 0.0 )
				{
					col = tex2D(_Tex6, i.uv6);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv7.x > 0.0 )
				{
					col = tex2D(_Tex7, i.uv7);
					clip(col.a - _Cutoff);
				}
				else if ( i.uv8.x > 0.0 )
				{
					col = tex2D(_Tex8, i.uv8);
					clip(col.a - _Cutoff);
				}

                
                return col;
            }
            ENDCG
        }

    }
}
