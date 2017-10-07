// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Unlit/SunShader" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_GlowTex ("Glow (RGB) Trans (A)", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_SunPosition("Sun Position", Vector) = (0.0, 0.0, 0.0, 0.0)
}
SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	Blend SrcAlpha OneMinusSrcAlpha
	LOD 100

	Lighting Off

	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 ver : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 ver : NORMAL;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			sampler2D _GlowTex;
			float4 _MainTex_ST;
			fixed _Cutoff;
			float4 _SunPosition;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.ver = v.vertex;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 Pos = normalize(i.ver);
				float3 Sun = normalize(_SunPosition);

				float SunGlow = dot(Pos,Sun);
				fixed2 p;
				p.x =  0.5*(Sun.y + 1.0);
				p.y = SunGlow;
				fixed4 GlowColor = tex2D(_GlowTex, p);

				fixed4 SunColor = tex2D(_MainTex, i.uv);

				fixed4 col;
				col.rgb = (SunColor.rgb*GlowColor.rgb) * 0.5;
				col.a = SunColor.a;

				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);

				return col * 2;
			}
		ENDCG
	}
}

}

