# UnityMotionVectors

Allows to smoothly blend nearest frames on sprite sheets. Works both with and without motion vectors maps.

[Example](https://cdn-animation.artstation.com/p/video_sources/001/067/657/unity-011.mp4)

1. Create new material use this shader (Custom/MotionVectorSimple)
2. Add [textures](https://drive.google.com/drive/folders/1M1ydlMuAbfz37kagETDJxaPFEwFKYx3r)
3. Use material with particle system.
4. Enable checkbox on Particle System > Rendered > Custom Vertex Stream
5. Add values to list: Position(POSITION.xyz), UV(TEXCOORD0.xy), UV2(TEXCOORD0.zw), AnimBlend(TEXCOORD1.x)
6. Profit!
<img src="vertexStreams.jpg" alt="vertexStreams" width="460" height="400">
