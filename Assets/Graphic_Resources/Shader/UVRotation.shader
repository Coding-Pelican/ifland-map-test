// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Secrettown/UVRotation"
{
 Properties {
       // _Color ("Color", Color) = (1,1,1,1)
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Rotation("Rotation", Float) = 0.0
    }
 
    SubShader {
        Pass {
            //Tag{"RenderType"= "Opaque"}
            LOD 200


            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
 
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            float _Rotation;
            float _OffsetX;
            float _OffsetY;
 
            struct appdata {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };
 
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //-------------------//

            struct Input
            {
                float2 _MainTex_ST;
            };

   
            v2f vert (appdata v) {
                float s = sin ( _Rotation );
                float c = cos ( _Rotation );
                float2x2 rotationMatrix = float2x2( c, -s, s, c);
 
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
 
                float offsetX = .5; //_MainTex_ST.z +_MainTex_ST.x / 2;
                float offsetY = .5; //_MainTex_ST.w +_MainTex_ST.y / 2;
 
                float x = v.texcoord.x - offsetX; //* _MainTex_ST.x + _MainTex_ST.z - offsetX;
                float y = v.texcoord.y - offsetY; //* _MainTex_ST.y + _MainTex_ST.w - offsetY;
 
                o.uv = mul (float2(x, y), rotationMatrix ) + float2(offsetX, offsetY);
               
                return o;
            }
   
            fixed4 frag (v2f i) : COLOR {
                return  tex2D(_MainTex, i.uv);                  
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
