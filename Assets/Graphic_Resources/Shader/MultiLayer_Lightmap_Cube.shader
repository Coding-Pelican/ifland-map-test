//멀티레이어 쉐이더 - 라이트맵용/기존 쉐이더포지로 제작된 시크릿타운 라이트맵과 큐브맵 부분 추가, 수정 //
//-----SecretTown------//
Shader "Secrettown/MultiLayer_Lightmap_Cube"
{
    Properties
    {
//------------------CubeMap 텍스쳐 공통으로 적용--------------------//
[Header(Cubemap)]
		_CubeMap ("Cube Map", Cube) = "_Skybox" {}
        _RefractionPower ("Refraction Power", Range(0, 1)) = 0.1
		[Space][Space][Space]

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
			#pragma target 3.0

			uniform float4 _LightColor0;
			uniform float _RefractionPower;
            uniform samplerCUBE _CubeMap;

            #include "UnityCG.cginc"

			struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
				float2 uv4 : TEXCOORD3;	
				float2 uv5 : TEXCOORD4;		

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

				float4 posWorld : TEXCOORD8;
                float3 normalDir : TEXCOORD9;
				
            };

            sampler2D _Tex1,_Tex2,_Tex3,_Tex4,_LightMap;
            float4 _Tex1_ST,_Tex2_ST,_Tex3_ST,_Tex4_ST,_LightMap_ST;
			float _LightMapStrength;
			float _DiffuseStrength;
			float4 _DiffuseColor01, _DiffuseColor02, _DiffuseColor03,_DiffuseColor04;

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
				o.uv5 = TRANSFORM_TEX(v.uv5, _LightMap);			
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
				//------------ 큐브맵과 라이트맵 기본 설정-------------//
				float4 Light = saturate(tex2D( _LightMap, i.uv5) *_LightMapStrength * 2.0f) / 0.9f;
				float4 _LightMap_var = tex2D(_LightMap,TRANSFORM_TEX(i.uv5, _LightMap));

				 UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				 i.normalDir = normalize(i.normalDir);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 normalDirection = i.normalDir;
				float3 viewReflectDirection = reflect(-viewDirection, normalDirection);

	
				fixed4 col;
				if ( i.uv1.x > 0.0 )
				{
					float4 _DiffuseMap_var = tex2D(_Tex1,TRANSFORM_TEX(i.uv1, _Tex1));
					
					//float3 diffuseColor = saturate (saturate((_LightMap_var.rgb * _LightMapStrength))/(1.0 - (_DiffuseMap_var.rgb * _DiffuseColor01.rgb * _DiffuseStrength)));
					float3 diffuseColor = (saturate((_LightMap_var.rgb * _LightMapStrength)* 1.5)/1.0 + (_DiffuseMap_var.rgb * _DiffuseColor01.rgb * _DiffuseStrength)) - 0.3 ;

					float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);

					float3 finalColor = (diffuseColor * _DiffuseStrength)   + emissive;
					fixed4 finalRGBA = fixed4(finalColor,1);
					UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				
				}
				else if ( i.uv2.x > 0.0 )
				{
					float4 _DiffuseMap_var = tex2D(_Tex2,TRANSFORM_TEX(i.uv2, _Tex2));
					
					//float3 diffuseColor = saturate (saturate((_LightMap_var.rgb * _LightMapStrength))/(1.0 - (_DiffuseMap_var.rgb * _DiffuseColor02.rgb * _DiffuseStrength)));

					float3 diffuseColor = (saturate((_LightMap_var.rgb * _LightMapStrength) * 1.5 )/1.0 + (_DiffuseMap_var.rgb * _DiffuseColor02.rgb * _DiffuseStrength)) - 0.3 ;

					float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
					
					float3 finalColor = (diffuseColor * _DiffuseStrength)   + emissive;

					//float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
					fixed4 finalRGBA = fixed4(finalColor,1);
					UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv3.x > 0.0 )
				{
					float4 _DiffuseMap_var = tex2D(_Tex3,TRANSFORM_TEX(i.uv3, _Tex3));
					
					//float3 diffuseColor = saturate (saturate((_LightMap_var.rgb * _LightMapStrength))/(1.0 - (_DiffuseMap_var.rgb * _DiffuseColor03.rgb * _DiffuseStrength)));
					float3 diffuseColor = (saturate((_LightMap_var.rgb * _LightMapStrength)* 1.5)/1.0 + (_DiffuseMap_var.rgb * _DiffuseColor03.rgb * _DiffuseStrength)) - 0.3 ;

					float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);

					//float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;

				float3 finalColor = (diffuseColor * _DiffuseStrength)   + emissive;
					
					fixed4 finalRGBA = fixed4(finalColor,1);
					UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
				}
				else if ( i.uv4.x > 0.0 )
				{
					float4 _DiffuseMap_var = tex2D(_Tex4,TRANSFORM_TEX(i.uv4, _Tex4));
					
					//float3 diffuseColor = saturate (saturate((_LightMap_var.rgb * _LightMapStrength))/(1.0 - (_DiffuseMap_var.rgb * _DiffuseColor04.rgb * _DiffuseStrength)));
					float3 diffuseColor = (saturate((_LightMap_var.rgb * _LightMapStrength)* 1.5)/1.0 + (_DiffuseMap_var.rgb * _DiffuseColor04.rgb * _DiffuseStrength)) - 0.3 ;

					float3 emissive = (texCUBElod(_CubeMap,float4(viewReflectDirection,_RefractionPower)).rgb * _RefractionPower);
					
					float3 finalColor = (diffuseColor * _DiffuseStrength)   + emissive;

					//float3 finalColor = (diffuseColor * _DiffuseStrength) + emissive;
					fixed4 finalRGBA = fixed4(finalColor,1);
					UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				
					col = finalRGBA;
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
