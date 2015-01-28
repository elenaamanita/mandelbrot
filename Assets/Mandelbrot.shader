//http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
//reference to unity 3d tutorial part of the code
//The Shader command contains a string with the name 
//of the Shader. This name can be subdivided with the “/” character simulating
 //a folder structure, simplifying the future reutilization of the Shader.
  //The name should be unique in all shaders.

Shader "Fractal/Mandelbrot" {
	Properties {
		MaxIterations ("Mandelbrot iteration depth", Float) = 5
		Zoom ("Mandelbrot Zoom", Float) = 1
//		Center ("mandelbrot Center position (XY)", Vector) = (0.5,0.5,0,0)
		InnerColor ("Color 1 (inner)", Color) = (1,0,0,1)
		OuterColor1 ("Color 1 (outer)", Color) = (0,1,0,1)
		OuterColor2 ("Color 2 (outer)", Color) = (0,0,1,1)
		
		Creal ("Mandelbrot Step", Float) = -0.0002
		Cimag ("Mandelbrot Shape", Float) = 0.7383
	}

  //A Shader can contain one or more SubShaders,
  // which are primarily used to implement shaders 
   //for different GPU capabilities.
   //All the SubShaders should present similar results
   //using different techniques for each architecture.
   //ShaderLab translates the code of the shader
    //automatically to other architectures,
    //but in some cases full functionality of 
    //the Shader in mobile architectures is not desired 
    //or some inputs are missing.

	SubShader {
  //each Pass represents an execution of the Vertex and
   //Fragment code for the same object 
  //rendered with the Material of the Shader.

		Pass {

    //This directive define in ShaderLab
    // the language used for the shader.
			CGPROGRAM

			//#pragma glsl

      //Vertex Shader is a shader program to modify
      // the geometry of the scene. It is executed for each 
     //vertex in the scene, and outputs are the coordinates
     //  of the projection, color, textures and other data passed
     //  to the fragment shader. The directive #pragma vertex [function name] is used
     //  to define the name of the vertex function.

			#pragma vertex vert_img

      //Fragment Shader is a shader program to modify image
       //properties in the render window. It is executed for each pixel 
       //and the output is the color info of the pixel. The directive #pragma fragment 
       //defines the name of the function of the fragment shader.

			#pragma fragment frag

      //The target directive defines the hardware requirements to support the shader.
			#pragma target 3.0

      //Include the file “UnityCG.cginc” inside the code of the shader

			#include "UnityCG.cginc"

      //The variable v contains the values for the vertex,
      // this function is called for each vertex of the scene
       //rendered. The returned value is a float4 variable with 
      //the position of the vertex in the screen

      float4 frag(v2f_img i) : COLOR {

      // //The range of the values of coord are mapped to a specific texture. Textures are images stored in
        //         the memory of the GPU representing a square or rectangular image, the textures in the fragment
          //       shader can be also used as procedural textures which uses mathematical functions to define the color
            //     of each pixel in the screen.

                float2 mcoord;
                float2 coord = float2(0.0,0.0);

                //use two values for the pixel in the screen (x,y), one value for the depth (z),
              //   and one value for the homogeneous space (w).
                  
                mcoord.x = ((1.0-i.uv.x)*3.5)-2.5;
                mcoord.y = (i.uv.y*2.0)-1.0;
                float iteration = 0.0;
                const float _MaxIter = 29.0;
                const float PI = 3.14159;
                float xtemp;
               
                for ( iteration = 0.0; iteration < _MaxIter; iteration += 1.0) {
                    if ( coord.x*coord.x + coord.y*coord.y > 2.0*(cos(fmod(_Time.y,2.0*PI))+1.0) )
                    break;
                    xtemp = coord.x*coord.x - coord.y*coord.y + mcoord.x;
                    coord.y = 2.0*coord.x*coord.y + mcoord.y;
                    coord.x = xtemp;
                }
                float val = fmod((iteration/_MaxIter)+_Time.x,1.0);
                float4 color;
                //the output is defined as a COLOR value defined in
                // a fixed4 variable that contains the RGBA (red, green, blue, alpha) of the color.

                color.r = clamp((3.0*abs(fmod(2.0*val,1.0)-0.5)),0.0,1.0);
                color.g = clamp((3.0*abs(fmod(2.0*val+(1.0/3.0),1.0)-0.5)),0.0,1.0);
                color.b = clamp((3.0*abs(fmod(2.0*val-(1.0/3.0),1.0)-0.5)),0.0,1.0);
                color.a = 1.0;
                
                return color;
            }
            ENDCG
        }
    }
}


      


			
			/*uniform float MaxIterations;
			uniform float Zoom;
			uniform float4 Center;
			uniform float4 InnerColor;
			uniform float4 OuterColor1;
			uniform float4 OuterColor2;
			uniform float Creal;
			uniform float Cimag;
    

			  float4 frag(v2f_img i) : COLOR {
				float real = i.uv.x * Zoom + -(Zoom/2.0);
				float imag = i.uv.y * Zoom + -(Zoom/2.0);
				
				
				float r2 = 0.0;
				float iter = 0.0;
				
				for (iter = 0.0; iter < MaxIterations && r2 < 4; iter += 1)
				{					
					float tempreal = real;
	
					real = (tempreal * tempreal) - (imag * imag) + Creal;
					imag = 2.0 * tempreal * imag + Cimag;
					r2   = (real * real) + (imag * imag);
				}
				
				float4 color;
				float4 alpha = (iter * 0.05) - floor(iter * 0.05);
				
				if (r2 < 4.0)
				    color = InnerColor;
				else 
				    color = OuterColor1*(1.0 - alpha) + OuterColor2*alpha; // linearly interpolate color

				return color;
			}
			ENDCG
		}
	}
}*/