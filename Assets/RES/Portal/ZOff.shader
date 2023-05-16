Shader "Custom/DisableZwrite"
{
	SubShader{
		Tags{
			"RenderType" = "Opaque"
		}

		Pass{
			ZWrite Off
		}
	}
}