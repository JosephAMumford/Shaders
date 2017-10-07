Shader "Custom/SphereShader" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Diffuse (RGB) Alpha (A)", 2D) = "grey" {}
	}

	SubShader{
		Pass {
			Tags {"LightMode" = "Always"}

			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma glsl
				#pragma target 3.0

				#include "UnityCG.cginc"

				struct appdata {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f {
					float4 pos : SV_POSITION;
					float3 normal : TEXCOORD0;
				};

				v2f vert (appdata v){
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.normal = v.normal;
					return o;
				}

				sampler2D _MainTex;

				#define PI 3.141592653589793

				inline float2 RadialCoords(float3 coord){
					float3 newCoord = normalize(coord);
					float theta = atan2(newCoord.z, newCoord.x);
					float phi = acos(newCoord.y);
					float2 sphereCoords = float2(theta, phi) * (1.0/PI);
					return float2(sphereCoords.x * 0.5 + 0.5, 1 - sphereCoords.y);
				}

				float4 frag(v2f IN) : COLOR {
					float2 equiUV = RadialCoords(IN.normal);
					return tex2D(_MainTex, equiUV);
				}

			ENDCG
		}
	}

	FallBack "VertexLit"
}