Shader "Unlit/SkyDome"
{
	Properties
	{
		_SkyTex ("Sky Texture", 2D) = "white" {}
		_GlowTex ("Glow Texture", 2D) = "white" {}
		_SunPosition("Sun Position", Vector) = (0.0, 0.0, 0.0, 0.0)
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			sampler2D _SkyTex;
			sampler2D _GlowTex;
			float4 _SunPosition;

			v2f vert (appdata v)
			{
				v2f o;
				o.texcoord = v.vertex;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 Pos = normalize(i.texcoord);
				float3 Sun = normalize(_SunPosition);

				float SunGlow = dot(Pos,Sun);

				float2 g;
				g.x = 0.5*(Sun.y + 1.0);
				g.y = Pos.y;

				fixed4 SkyColor = tex2D(_SkyTex, g);
				float2 p;
				p.x = g.x;
				p.y = SunGlow;
				fixed4 GlowColor = tex2D(_GlowTex, p);

				fixed4 col;
				col.rgb = (SkyColor.rgb + GlowColor.rgb * GlowColor.a) *0.5;
				col.a = SkyColor.a;
				return col * 2;
			}
			ENDCG
		}
	}
}
