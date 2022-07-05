//멀티레이어 쉐이더 - 라이트맵용/기존 쉐이더포지로 제작된 시크릿타운 라이트맵 부분 추가, 수정 //
//-----SecretTown------//
Shader "Secrettown/MultiLayer_Lightmap"
{
    Properties
    {
//------------------Diffuse Strength 텍스쳐 공통으로 적용--------------------//	
		_DiffuseStrength ("Diffuse Strength", Range(0, 2)) = 1
		[Space][Space][Space]
		[Space][Space][Space]
//------------------------------------------------------------------------//
//------------------Floor Tex---------------------------------------------//
[Header(Floor Texture)]
		_DiffuseColor01 ("Diffuse Color", Color) = (0.5,0.5,0.5,1)
        _Tex1 ("Texture", 2D) = "white" {}
		[Space][Space][Space]
//------------------Wall Tex---------------------------------------------//	
[Header(Wall Texture)]
		_DiffuseColor02 ("Diffuse Color", Color) = (0.5,0.5,0.5,1)		
		_Tex2 ("Texture", 2D) = "white" {}
		[Space][Space][Space]
//------------------Ceiling Tex---------------------------------------------//	
[Header(Ceiling Texture)]
		_DiffuseColor03 ("Diffuse Color", Color) = (0.5,0.5,0.5,1)
		_Tex3 ("Texture", 2D) = "white" {}
		[Space][Space][Space]

//----------------------라이트맵 적용되는 다른 부분----------------------------------------------//	
[Header(Other Texture)]
		_DiffuseColor04 ("Diffuse Color", Color) = (0.5,0.5,0.5,1)
		_Tex4 ("Texture", 2D) = "white" {}
		[Space][Space][Space]

//------------------lightmap/lightmap Strength 텍스쳐 공통으로 적용--------------------//	
[Header(Lightmap)]
		[NoScaleOffset]_LightMap ("Light Map", 2D) = "white" {}
		_LightMapStrength ("Light Map Strength", Range(0, 1)) = 0.7
//----------------------------------------------------------------------------------//

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
				float2 uv4 : TEXCOORD3;
				float2 uv5 : TEXCOORD4;
				
            };

            sampler2D _Tex1,_Tex2,_Tex3,_Tex4,_LightMap;
            float4 _Tex1_ST,_Tex2_ST,_Tex3_ST,_Tex4_ST,_LightMap_ST;
			float _LightMapStrength;
			float _DiffuseStrength;
			float4 _DiffuseColor01, _DiffuseColor02, _DiffuseColor03,_DiffuseColor04;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _Tex1);
				o.uv2 = TRANSFORM_TEX(v.uv2, _Tex2);
				o.uv3 = TRANSFORM_TEX(v.uv3, _Tex3);
				o.uv4 = TRANSFORM_TEX(v.uv4, _Tex4);	
				o.uv5 = TRANSFORM_TEX(v.uv5, _LightMap);			
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
				float4 Light = saturate(tex2D( _LightMap, i.uv5) *_LightMapStrength * 2.0f) / 0.9f;
	
				fixed4 col;
				if ( i.uv1.x > 0.0 )
				{
					col = tex2D(_Tex1, i.uv1) * Light * _DiffuseColor01 * _DiffuseStrength;
				}
				else if ( i.uv2.x > 0.0 )
				{
					col = tex2D(_Tex2, i.uv2) * Light * _DiffuseColor02 * _DiffuseStrength;
				}
				else if ( i.uv3.x > 0.0 )
				{
					col = tex2D(_Tex3, i.uv3) * Light * _DiffuseColor03 * _DiffuseStrength;
				}
				else if ( i.uv4.x > 0.0 )
				{
					col = tex2D(_Tex4, i.uv4) * Light * _DiffuseColor04 * _DiffuseStrength;
				}
				else if ( i.uv5.x > 0.0 )//lightmap
				{
					col = tex2D(_LightMap, i.uv5);
				}				

                
                return col;
            }
            ENDCG
        }
    }
}
