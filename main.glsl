float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float sdOctahedron( vec3 p, float s )
{
  p = abs(p);
  float m = p.x+p.y+p.z-s;
  vec3 q;
       if( 3.0*p.x < m ) q = p.xyz;
  else if( 3.0*p.y < m ) q = p.yzx;
  else if( 3.0*p.z < m ) q = p.zxy;
  else return m*0.57735027;
    
  float k = clamp(0.5*(q.z-q.y+s),0.0,s); 
  return length(vec3(q.x,q.y-s+k,q.z-k)); 
}

vec4 getMinDistanceOverLine(vec2 uv){
    vec3 travelVector = vec3(uv.x, uv.y, -9)-vec3(0, 0, -10);
    
    vec3 pos = vec3(0, 0, -10);
    vec3 minPoint = pos;
    
    float minDist = 10000.f;
    
    for(int i = 0; i < 100; i++){
        pos += travelVector;
        
        if (minDist > sdOctahedron(pos, 1.f)){
            minDist = sdOctahedron(pos, 1.f);
            minPoint = pos;
        }
    }
    
    return vec4(minPoint, minDist);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    float aspectRatio = iResolution.x/iResolution.y;
    
    float mx = iMouse.x/iResolution.x;
    float my = iMouse.y/iResolution.y;
    
    vec4 outp = getMinDistanceOverLine(vec2(uv.x-.5f, (uv.y-.5f)/aspectRatio));
    vec3 minPoint = outp.xyz;
    float d = outp.w;

    vec3 col = vec3(0.f, 0.f, 0.f);

    // Time varying pixel color
    if (d < 1.f){
        float dotp = 1.f-dot(vec3((mx-.5f)*2.f, (my-.5f)*2.f, 0), -minPoint);
        dotp = max(.35f, dotp);
        col = vec3(dotp, dotp, dotp);
    }

    // Output to screen
    fragColor = vec4(col,1.0);
}
