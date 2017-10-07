Shader "Editor/Vertex color" {

SubShader {
    Pass {
        
        CGPROGRAM

        #pragma vertex vert
        #pragma fragment frag

        struct vertexInput {
        	float4 vertex : POSITION;
        	fixed4 color : COLOR;
        };
        
        struct vertexOutput {
        	float4 pos : SV_POSITION;
        	fixed4 color : COLOR;
        };
        
        vertexOutput vert(vertexInput input){
        	vertexOutput output;
        	output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
        	output.color = input.color;
        	return output;
        }
        
        float4 frag(vertexOutput input) : COLOR {
        	return  input.color;
        }
        
        ENDCG
    }
}
}