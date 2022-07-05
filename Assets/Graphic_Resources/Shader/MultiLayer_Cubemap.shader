//멀티레이어 쉐이더 - 큐브맵용/기존 쉐이더포지로 제작된 시크릿타운 큐브맵 부분 추가, 수정 //
//-----SecretTown------//
Shader "Secrettown/MultiLayer_Cubemap"
{
    Properties
    {
		_CubeMap ("Cube Map", Cube) = "_Skybox" {}
        _RefractionPower ("Refraction Power", Range(0, 1)) = 0.1
		[Space][Space][Space]
		_DiffuseStrength ("Diffuse Strength", Range(0, 2)) = 1
		_DiffuseColor ("Diffuse Color", Color) = (0.5,0.5,0.5,1)

        _Tex1 ("Texture", 2D) = "white" {}
		_Tex2 ("Texture", 2D) = "white" {}
		_Tex3 ("Texture", 2D) = "white" {}
		_Tex4 ("Texture", 2D) = "white" {}
		_Tex5 ("Texture", 2D) = "white" {}
		_Tex6 ("Texture", 2D) = "white" {}
		_Tex7 ("Texture", 2D) = "white" {}
		_Tex8 ("Texture", 2D) = "white" {}
		_Tex9 ("Texture", 2D) = "white" {}

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

			#pragma target 3.0

			uniform float4 _LightColor0;
			uniform float _RefractionPower;
            uniform samplerCUBE _CubeMap;
			uniform float4 _DiffuseColor;
            uniform float _DiffuseStrength;

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

				float3 normal : NORMAL;
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

				float4 posWorld : TEXCOORD8;
                float3 normalDir : TEXCOORD9;
				//LIGHTING_COORDS(4,5)
                //UNITY_FOG_COORDS(6)
            };

            sampler2D _Tex1,_Tex2,_Tex3,_Tex4,_Tex5,_Tex6,_Tex7,_Tex8,_Tex9;
            float4 _Tex1_ST,_Tex2_ST,_Tex3_ST,_Tex4_ST,_Tex5_ST,_Tex6_ST,_Tex7_ST,_Tex8_ST,_Tex9_ST;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;

				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);


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
				 UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				 i.normalDir = normalize(i.normalDir);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 normalDirection = i.normalDir;
				float3 viewReflectDirection = reflect(-viewDirection, normalDirection);
				
				fixed4 col;
				if ( i.uv1.x > 0.0 )
				{

			   /////// Diffuse:
				float4 _DiffuseMap_var = tex2D(_Tex1,TRANSFORM_TEX(i.uv1, _Tex1));
			   //float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv1, _LightMap));
				float3 diffuseColor = _DiffuseMap_var.rgb;
				////// Emissive:
				float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
				/// Final Color:
				float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
				fixed4 finalRGBA = fixed4(finalColor,1);
				UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv2.x > 0.0 )
				{
			    /////// Diffuse:
				float4 _DiffuseMap_var = tex2D(_Tex2,TRANSFORM_TEX(i.uv2, _Tex2));
			   //float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv1, _LightMap));
				float3 diffuseColor = _DiffuseMap_var.rgb;
				////// Emissive:
				float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
				/// Final Color:
				float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
				fixed4 finalRGBA = fixed4(finalColor,1);
				UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv3.x > 0.0 )
				{
				/////// Diffuse:
				float4 _DiffuseMap_var = tex2D(_Tex3,TRANSFORM_TEX(i.uv3, _Tex3));
			   //float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv1, _LightMap));
				float3 diffuseColor = _DiffuseMap_var.rgb;
				////// Emissive:
				float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
				/// Final Color:
				float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
				fixed4 finalRGBA = fixed4(finalColor,1);
				UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv4.x > 0.0 )
				{
				/////// Diffuse:
				float4 _DiffuseMap_var = tex2D(_Tex4,TRANSFORM_TEX(i.uv4, _Tex4));
			   //float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv1, _LightMap));
				float3 diffuseColor = _DiffuseMap_var.rgb;
				////// Emissive:
				float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
				/// Final Color:
				float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
				fixed4 finalRGBA = fixed4(finalColor,1);
				UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv5.x > 0.0 )
				{
					col = tex2D(_Tex5, i.uv5);
				}
				else if ( i.uv6.x > 0.0 )
				{
					col = tex2D(_Tex6, i.uv6);
				}
				else if ( i.uv7.x > 0.0 )
				{
					col = tex2D(_Tex7, i.uv7);
				}
				else if ( i.uv8.x > 0.0 )
				{
					col = tex2D(_Tex8, i.uv8);
				}

                
                return col;
            }
            ENDCG
        }
    }
}
