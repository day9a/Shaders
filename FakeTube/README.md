# FakeTube shader guide

Single quad FakeTube shader.  
Like a FakeInterior, but it's FakeTube!  
It can be used as a flat decal snap to walls, floor or any objects to improve scenes details.  

Full version: ---  
Blender free example: [FakeTube_free.blend](FakeTube_free.blend)  
Unreal free example: ---  
Unity free example: [FakeTubeFree_Built-in.unitypackage](FakeTubeFree_Built-in.unitypackage)  (unpack to Unity\Projects\YourProjects\Assets) (v2019-2023)  

<img src="imgs/cube_preview.gif" alt="result" width="256" height="256">

---

> - Uses usual PBR textures with metallic workflow.  
> - Assumed that quad orientation conform with a standart Unity quad (GameObject > 3DObject > Quad)  
> - Works with Unity orthographic camera.
> - All animation handling in-shader  
> - (!) Shader can't get shadows from outside to inside and uses FakeShadows that can be adjusted with properties. By default they are set from top to bottom.  


Approximate performance results in general:
- ~450 math for FakeTube Shader  &nbsp; vs  &nbsp; ~250 math Standart Unity Shader 
- ~300 fps  for FakeTube Shader  &nbsp; &nbsp; &nbsp; vs  &nbsp; ~330 fps in empty scene (both for GTX1070 / fullHD)  

---

<details><summary>Show all properties / How it works:</summary>
  
<table>
  <tr>
    <td> 
      <img src="imgs/FakeTubeProperties.png" alt="result" width="384"> 
    </td>
    <td>
      FakeTube properties:  <br>
      - highlighted in Red depend on the current texture and is already configured.  <br>
      - highlighted in Green can be adjusted slightly.  <br>
      - highlighted in Blue - shadow can be adjusted depending on the light source in the scene.  <br>
       <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br>  <br> <br> <br> <br> <br> <br> <br> <br> <br> <br>  <br>
    </td>
  </tr>
  <tr>
    <td> 
      <video src="https://github.com/day9a/Blender/assets/69633736/e3bc3dc9-e9fb-4b5c-b8b7-97f5b19822be" width="256" height="256"> 
    </td>
    <td>
      - Tube separated to 5 parts: Top, Bottom, Walls, Gate A, Gate B where each part of the tube is match each part of the texture.  <br>  
      - In general, it looks a UV unwrap.  <br>  
      - Parts interact with each other only in a certain way for reasons of perfomance/optimization.  <br>
       <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br>
    </td>
  </tr>
</table>

</details>

---

