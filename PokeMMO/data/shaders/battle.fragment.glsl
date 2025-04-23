#ifdef GL_ES
#define LOWP lowp
#define MED mediump
#define HIGH highp
precision mediump float;
#else
#define MED
#define LOWP
#define HIGH
#endif

#if defined(specularTextureFlag) || defined(specularColorFlag)
#define specularFlag
#endif

#ifdef normalFlag
varying vec3 v_normal;
#endif //normalFlag

#if defined(colorFlag)
varying vec4 v_color;
#endif

#ifdef blendedFlag
varying float v_opacity;
#ifdef alphaTestFlag
varying float v_alphaTest;
#endif //alphaTestFlag
#endif //blendedFlag

#if defined(diffuseTextureFlag) || defined(specularTextureFlag)
#define textureFlag
#endif

#ifdef diffuseTextureFlag
varying MED vec2 v_diffuseUV;
#endif

#ifdef specularTextureFlag
varying MED vec2 v_specularUV;
#endif

#ifdef overlayColorFlag
uniform vec4 u_overlayColor;
#endif

#ifdef diffuseColorFlag
uniform vec4 u_diffuseColor;
#endif

#ifdef emissiveColorFlag
uniform vec4 u_emissiveColor;
#endif

#ifdef diffuseTextureFlag
uniform sampler2D u_diffuseTexture;
#endif

#ifdef specularColorFlag
uniform vec4 u_specularColor;
#endif

#ifdef specularTextureFlag
uniform sampler2D u_specularTexture;
#endif

#ifdef normalTextureFlag
uniform sampler2D u_normalTexture;
#endif

#ifdef lightingFlag
varying vec3 v_lightDiffuse;

#if	defined(ambientLightFlag) || defined(ambientCubemapFlag) || defined(sphericalHarmonicsFlag)
#define ambientFlag
#endif //ambientFlag

#ifdef specularFlag
varying vec3 v_lightSpecular;
#endif //specularFlag

#ifdef shadowMapFlag
uniform sampler2D u_shadowTexture;
uniform float u_shadowPCFOffset;
varying vec3 v_shadowMapUv;
#define separateAmbientFlag
#undef separateAmbientFlag

float getShadowness(vec2 offset)
{
    const vec4 bitShifts = vec4(1.0, 1.0 / 255.0, 1.0 / 65025.0, 1.0 / 16581375.0);
    return step(v_shadowMapUv.z, dot(texture2D(u_shadowTexture, v_shadowMapUv.xy + offset), bitShifts));//+(1.0/255.0));
}

float getShadow()
{
	return (//getShadowness(vec2(0,0)) +
			getShadowness(vec2(u_shadowPCFOffset, u_shadowPCFOffset)) +
			getShadowness(vec2(-u_shadowPCFOffset, u_shadowPCFOffset)) +
			getShadowness(vec2(u_shadowPCFOffset, -u_shadowPCFOffset)) +
			getShadowness(vec2(-u_shadowPCFOffset, -u_shadowPCFOffset))) * 0.25;
}
#endif //shadowMapFlag

#if defined(ambientFlag) && defined(separateAmbientFlag)
varying vec3 v_ambientLight;
#endif //separateAmbientFlag

#endif //lightingFlag

#ifdef fogFlag
uniform vec4 u_fogColor;
varying float v_fog;
#endif // fogFlag

const float glowPass = 1.0;

#ifdef glowFlag
uniform float glowIntensity;
uniform float glowThreshold;
uniform float glowSize;
uniform vec3 glowColor;
uniform vec2 glowInvTexSize;
uniform vec2 glowTexSize;

float fTexelFetch(sampler2D tex, ivec2 coord)
{
    return texture2D(tex, vec2(float(coord.x) * glowInvTexSize.x, float(coord.y) * glowInvTexSize.y)).a;
}
#endif


void main() {
	#if defined(normalFlag)
		vec3 normal = v_normal;
	#endif // normalFlag



	#if defined(diffuseTextureFlag) && defined(diffuseColorFlag) && defined(colorFlag)
		vec4 diffuse = texture2D(u_diffuseTexture, v_diffuseUV) * u_diffuseColor * v_color;
	#elif defined(diffuseTextureFlag) && defined(diffuseColorFlag)
		vec4 diffuse = texture2D(u_diffuseTexture, v_diffuseUV) * u_diffuseColor;
	#elif defined(diffuseTextureFlag) && defined(colorFlag)
		vec4 diffuse = texture2D(u_diffuseTexture, v_diffuseUV) * v_color;
	#elif defined(diffuseTextureFlag)
		vec4 diffuse = texture2D(u_diffuseTexture, v_diffuseUV);
	#elif defined(diffuseColorFlag) && defined(colorFlag)
		vec4 diffuse = u_diffuseColor * v_color;
	#elif defined(diffuseColorFlag)
		vec4 diffuse = u_diffuseColor;
	#elif defined(colorFlag)
		vec4 diffuse = v_color;
	#else
		vec4 diffuse = vec4(1.0);
	#endif

  #ifdef glowFlag
  if(glowSize > 0.0)
  {
    vec4 pixel = diffuse;
    if (diffuse.a <= glowThreshold)
    {
        vec2 size = glowTexSize;
        float uv_x = v_diffuseUV.x * size.x;
        float uv_y = v_diffuseUV.y * size.y;

        float sum = 0.0;
            uv_y = (v_diffuseUV.y * size.y) + (glowSize * float(float(1) - (0.5)));
            float h_sum = 0.0;
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x - (4.0 * glowSize), uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x - (3.0 * glowSize), uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x - (2.0 * glowSize), uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x - glowSize, uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x, uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x + glowSize, uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x + (2.0 * glowSize), uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x + (3.0 * glowSize), uv_y));
            h_sum += fTexelFetch(u_diffuseTexture, ivec2(uv_x + (4.0 * glowSize), uv_y));
            sum += h_sum / glowPass;

        float v = (sum / 9.0) * glowIntensity;
        pixel = vec4(glowColor, v);
    }

    float alpha = 1.0;
    #ifdef diffuseColorFlag
    alpha = u_diffuseColor.a;
    #endif
    diffuse = mix(diffuse, pixel, alpha);
  }
  #endif

  #ifdef emissiveColorFlag
          vec4 emissive = u_emissiveColor;
  #else
          vec4 emissive = vec4(0.0);
  #endif

	#if (!defined(lightingFlag))
		gl_FragColor.rgb = diffuse.rgb;
	#elif (!defined(specularFlag))
		#if defined(ambientFlag) && defined(separateAmbientFlag)
			#ifdef shadowMapFlag
				gl_FragColor.rgb = (diffuse.rgb * (v_ambientLight + getShadow() * v_lightDiffuse));
				//gl_FragColor.rgb = texture2D(u_shadowTexture, v_shadowMapUv.xy);
			#else
				gl_FragColor.rgb = (diffuse.rgb * (v_ambientLight + v_lightDiffuse));
			#endif //shadowMapFlag
		#else
			#ifdef shadowMapFlag
				gl_FragColor.rgb = getShadow() * (diffuse.rgb * v_lightDiffuse);
			#else
				gl_FragColor.rgb = (diffuse.rgb * v_lightDiffuse);
			#endif //shadowMapFlag
		#endif
	#else
		#if defined(specularTextureFlag) && defined(specularColorFlag)
			vec3 specular = texture2D(u_specularTexture, v_specularUV).rgb * u_specularColor.rgb * v_lightSpecular;
		#elif defined(specularTextureFlag)
			vec3 specular = texture2D(u_specularTexture, v_specularUV).rgb * v_lightSpecular;
		#elif defined(specularColorFlag)
			vec3 specular = u_specularColor.rgb * v_lightSpecular;
		#else
			vec3 specular = v_lightSpecular;
		#endif

		#if defined(ambientFlag) && defined(separateAmbientFlag)
			#ifdef shadowMapFlag
			gl_FragColor.rgb = (diffuse.rgb * (getShadow() * v_lightDiffuse + v_ambientLight)) + specular;
				//gl_FragColor.rgb = texture2D(u_shadowTexture, v_shadowMapUv.xy);
			#else
				gl_FragColor.rgb = (u_emissiveColor.rgb *diffuse.rgb * (v_lightDiffuse + v_ambientLight)) + specular;
			#endif //shadowMapFlag
		#else
			#ifdef shadowMapFlag
				gl_FragColor.rgb = getShadow() * ((diffuse.rgb * v_lightDiffuse) + specular);
			#else
				gl_FragColor.rgb = (diffuse.rgb * v_lightDiffuse) + specular;
			#endif //shadowMapFlag
		#endif
	#endif //lightingFlag

        #ifdef emissiveColorFlag
               gl_FragColor.rgb = u_emissiveColor.rgb * diffuse.rgb * v_lightDiffuse;
        #endif

	#ifdef fogFlag
		gl_FragColor.rgb = mix(gl_FragColor.rgb, u_fogColor.rgb, v_fog);
	#endif // end fogFlag

        #ifdef overlayColorFlag
		gl_FragColor.rgb = mix(gl_FragColor.rgb, u_overlayColor.rgb, u_overlayColor.a);
        #endif

	#ifdef blendedFlag
		gl_FragColor.a = diffuse.a * v_opacity;
		#ifdef alphaTestFlag
			if (gl_FragColor.a <= v_alphaTest)
				discard;
		#endif
	#else
		gl_FragColor.a = 1.0;
	#endif

}
