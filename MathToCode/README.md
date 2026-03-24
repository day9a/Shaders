
# Reading Math Paper

|                                                                 <font color="#92d050">Meaning</font><br>                                                                  |                                     <font color="#92d050">Expression</font><br>                                      |                                                                                       <font color="#92d050">Equivalent (GLSL)</font>                                                                                       |
| :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|                                                      <font color="#00b050">Scalar<br>Vector<br>Matrix</font><br><br>                                                      |                      $a, b$ <br> $\vec{v}=(x,y,z)$ <br> $\mathbf{M} \in \mathbb{R}^{3 \times 3}$                      |                                                                                       `a, b`<br>`vec3 v = vec3(x, y, z)`<br>`mat3 M`                                                                                       |
|                                                              <br><font color="#00b050">2x2 Matrix</font><br>                                                              |                                   ${\left\lbrack \matrix{a & b \cr c & d} \right\rbrack}$                                    |                                                                       <br>`mat2(a, c, b, d);` <br><font color="#7f7f7f">GLSL is column-major</font>                                                                        |
|                                                <font color="#00b050">Vector length<br><br>Normalized vector</font><br><br>                                                |                     $\|\mathbf{v}\|$<br>$$\hat{\mathbf{v}} = \frac{\mathbf{v}}{\|\mathbf{v}\|}$$                     |                                                                                             `length(v)`<br><br>`normalize(v)`                                                                                              |
|                                               <font color="#00b050">Product<br>Dot product<br>Cross product</font><br><br>                                                |                      **ab**<br>$\mathbf{a} \cdot \mathbf{b}$<br>$\mathbf{a} \times \mathbf{b}$                       |                                                                                          `a * b`<br>`dot(a, b)`<br>`cross(a, b)`                                                                                           |
|                                                     <br><font color="#00b050">Product of elements<br>(Pi)</font><br>                                                      |                                              <br>$\prod_{i=0}^{n} x_i$                                               |                              `float prod = 1.0;`<br>`for (int i=0; i<=n; ++i) { prod *= x[i]; }`<br><br><font color="#7f7f7f">A `for` loop where we multiply values (initial is `1.0`)</font>                              |
|                                                <br><font color="#00b050">Factorial of a number n<br></font> [Factorial](#Factorial)                                                |                       $n! = \prod_{k=1}^{n} k = 1 \cdot 2 \cdot 3 \dots n$                        |                                                   `int result = 1;` <br>`for (int i=2; i<=n; i++) {result *= i; }`<br><br><font color="#7f7f7f">5!=1⋅2⋅3⋅4⋅5=120</font>                                                    |
|                                                <br><font color="#00b050">Sum of elements<br>(Sigma)</font><br>[Sigma ∑](#Sigma-∑)                                                |                                               <br>$\sum_{i=0}^{n} x_i$                                               |                                               `for(int i=0; i<=n; ++i) { sum += x[i]; }`<br><br><font color="#7f7f7f">A `for` loop where we add values to a variable</font>                                                |
|                                          <font color="#00b050">Derivative (Gradient) <br>(Nabla)</font><br>[Derivative ∇](#Derivative-∇)<br>                                          |                                                 <br>$\nabla f(x, y)$                                                 |                                                                                             <br>`vec2(f(x+e,y)-f(x-e,y), ...)`                                                                                             |
|                                                       <font color="#00b050">Integral</font><br>[Integral ∫](#Integral-∫)<br>                                                        |                                            <br>$\int_{0}^{1} f(x) \, dx$                                             |                                  `for(float x = 0.0; x <= 1.0; x += dx) {integral += f(x) * dx; }`<br><br><font color="#7f7f7f">Sum accumulation (Area under curve) inside a loop.</font>                                  |
|                                                   <font color="#00b050">Differential<br>(Delta)</font><br>[Delta Δ](#Delta-Δ)                                                    |                                                  $\Delta x$<br>$dx$                                                  |                                                                       <font color="#7f7f7f">A tiny change or step (e.g., `float dx = 0.01;`).</font>                                                                       |
|                                                          <br><font color="#00b050">Piecewise function</font><br>                                                          |                          $f(x) =  (a, x < 0), \\ (b, x ≥ 0)$                           |                                                                                               <br>`mix(a, b, step(0.0, x))`                                                                                                |
|                                                 <font color="#00b050">Direct function<br>Inverse function</font><br><br>                                                  |                                          $f(x) = x+2$<br>$f^{-1}(x) = x-2$                                           |                                                                                          `float f(float x) { return x+2.0; }`<br>                                                                                          |
|                                                              <font color="#00b050">Range clamping</font><br>                                                              |                                                $\max(a, \min(x, b))$                                                 |                                                                                                      `clamp(x, a, b)`                                                                                                      |
|                                                                                                                                                                           |                                                                                                                      |                                                                                                                                                                                                                            |
|                                   <font color="#00b050">Round down<br>Round up<br>Modulo (Remainder)<br>Fractional part</font><br><br>                                    |                          $\lfloor x \rfloor$<br>$\lceil x \rceil$<br>$x \bmod y$<br>$\{x\}$                          |                                                                                    `floor(x)`<br>`ceil(x)`<br>`mod(x, y)`<br>`fract(x)`                                                                                    |
|                                              <font color="#00b050">Absolute value<br>Sign of a number (-1, 0, 1)</font><br>                                               |                                               \|x\|<br>$\text{sgn}(x)$                                               |                                                                                                   `abs(x)`<br>`sign(x)`                                                                                                    |
|                                                           <font color="#00b050">Linear interpolation</font><br>                                                           |                                                $\text{lerp}(a, b, t)$                                                |                                                                                                       `mix(a, b, t)`                                                                                                       |
|             <font color="#00b050">Exponentiation</font><br><font color="#00b050">Increment</font><br><font color="#00b050">Natural Exponential</font><br><br>             |                                    $x^2$, $x^y$<br>$x \mapsto x+1$<br>${e}^{x_i}$                                    |                                                                                    `pow(x, 2.0), pow(x, y)`<br>`x += 1`<br>`exp(x[i])`                                                                                     |
|                                                                                                                                                                           |                                                                                                                      |                                                                                                                                                                                                                            |
|                                   *Logic* <br><font color="#00b050">AND<br>OR<br>NOT<br>XOR<br>Equal to<br>Not equal to</font><br><br>                                    |               <br>$a \wedge b$<br>$a \vee b$<br>$\neg a$<br>$a \oplus b$<br>$a \equiv b$<br>$a \neq b$               |                                                                     <br>`a && b`<br>a \|\| b<br>`!a`<br>`a ^^ b, !a != !b`<br>`a == b`<br>`a != b`<br>                                                                     |
|                                                                                                                                                                           |                                                                                                                      |                                                                                                                                                                                                                            |
| *Sets*<br><font color="#00b050">Natural numbers<br>Integers<br>Rational numbers<br>**Real numbers**<br>(rational+irrational)<br>Complex numbers<br>(imaginary)</font><br> |   <br>$\mathbb{N}_0, \mathbb{N}_1$<br>$\mathbb{Z}$<br>$x/y$<br>$\mathbb{R}, \mathbb{R}^+$<br><br>$\mathbb{C}$<br>    |                                           <br>`uint`<br>`int`<br>`float`<br>`π,e,sqrt(2.0),log(7.0)` <br><br>`vec2(real, imaginary)` <br><font color="#7f7f7f">simulated</font>                                            |
|                          <font color="#00b050">Empty sets<br>**Finite** sets<br>**Closed** intervals<br><br>Membership $\in$</font><br><br><br>                           | $\emptyset$<br>$\{a, b, c\}$<br>$[a, \dots, b]$<br><br>$x \in [0, 1]$<br>$x \in \mathbb{R}$<br>$x \notin \mathbb{R}$ |                                        <br>`sing(x) {-1, 0, +1}`<br>`fract(x) {0.0, ..., 1.0}`<br><br>`0.0 <= x && x <= 1.0`<br>`x` <font color="#7f7f7f">is a float</font><br><br>                                        |
|                             *Misc*<br><font color="#00b050">Approaches infinity<br><br>Function composition<br><br>Approximately equal</font>                             |                                <br>$lim_{x→∞}$<br><br>$f \circ g(x)$<br><br>$\approx$                                | <br>`1e9` <font color="#7f7f7f">very large number</font><br><br>`f(g(x)), fract(sin(time))`<br><font color="#7f7f7f">nested call</font><br>`abs(a - b) < 0.0001` <font color="#7f7f7f"><br>tolerance comparison</font><br> |
|                                                                    ///////////////////////////////////                                                                    |                                             ////////////////////////////                                             |                                                                                           //////////////////////////////////////                                                                                           |


---

## Examples:
#### Sigma ∑
Just a loop, which means you need to iterate over all light sources and add up their brightness. #sigma
$$
L = \sum_{i=0}^{N} \text{light}_i
$$
   ```cpp
float totalLight = 0.0;
for(int i = 0; i < N; i++) {
    totalLight += calculateLight(Light[i]);
}
   ```

---

#### Derivative ∇
Needed, for example, to find the **gradient** (direction of the steepest ascent). This is the basis for calculating normals on procedural landscapes. (Imagine standing on a mountain slope in the fog. To understand which way is up, you extend your right foot (step `+e`) and your left foot (`-e`). The difference in height between them is the derivative. Doing this for two axes will give you a vector pointing exactly to the peak.) #derivative

$$
\nabla f(x, y) \approx \left( \frac{f(x+\epsilon, y) - f(x-\epsilon, y)}{2\epsilon}, \frac{f(x, y+\epsilon) - f(x, y-\epsilon)}{2\epsilon} \right)
$$

```cpp
float e = 0.001; // Tiny step (epsilon)
vec2 grad = vec2(
    f(p.x + e, p.y) - f(p.x - e, p.y), // Change along X
    f(p.x, p.y + e) - f(p.x, p.y - e)  // Change along Y
) / (2.0 * e); // Divide by distance covered
```

---
#### Integral ∫ 
This is a sum with small steps; it can be used, for example, when calculating blur or volumetric light. #integral
$$
\int_{0}^{1} f(x) \, dx
$$
   ```cpp
float integral = 0.0;
float stepSize = 0.01; 
for(float x = 0.0; x <= 1.0; x += stepSize) {
    integral += f(x) * stepSize; // Accumulate the areas of narrow rectangles
}
   ```
   
---

#### Delta Δ
For example, if you need to create chromatic aberration, you need to sample a pixel slightly to the side of the current one; this offset is the delta. #delta

```cpp
// Delta (step offset)
vec2 delta = vec2(0.01, 0.0); 
// Sample the pixel color with an offset by delta along the X axis
float redChannel = texture(iChannel0, uv + delta).r;
```
      
---


#### Softmax
This is an activation function in neural networks used to turn "raw" output numbers (logits) into a probability distribution.
$$
y_i = \frac{e^{x_i}}{\sum_{j=1}^{n} e^{x_j}}
$$
```c
void softmax(float x[], float y[], int N) {
    float d = 0.0;
    for(int j = 0; j < N; j++) { 
	    d += exp(x[j]); }
    for(int i = 0; i < N; i++) { 
	    y[i] = exp(x[i]) / d; }
}
```

---
## Defining the natural exponential:
#### Limit
$$
   e^x = \lim_{n \to \infty} \left(1 + \frac{x}{n}\right)^n
$$
```c
float exp_limit(float x) {
    float n = 1e9; 
    return pow(1.0 + x / n, n); // if x = 1 then exp = 2.718
}
```

#### Factorial
$$
e^x = \sum_{k=0}^{\infty} \frac{x^k}{k!}
$$
```c
// v1
float fact(int k) {
    float f = 1.0;
    for(int i = 1; i <= k; i++) {
        f *= float(i);
    }
    return f;
}

float exp_series(float x) {
    float sum = 0.0;
    for(int k = 0; k < 10; k++) { // обрезаем бесконечность
        sum += pow(x, float(k)) / fact(k);
    }
    return sum;
}
```

$$
\frac{x^k}{k!} = \frac{x^{k-1}}{(k-1)!} \cdot \frac{x}{k}
$$
```c 
// v2 (short)
float exp_series_fast(float x) {
    float sum = 1.0;
    float term = 1.0;

    for(int k = 1; k < 10; k++) {
        term *= x / float(k);
        sum += term;
    }
    return sum;
}
```

#### Integral
$$
F(x) = 1 + \int_0^x F(t)\,dx
$$
```c
float exp_integral(float x) {
    float dx = 0.001;
    float t = 0.0;
    float y = 1.0;

    for(int i = 0; i < 10000; i++) {
        if(t > x) break;    
        y += y * dx; // F(t) * dx
        t += dx;
    }
    return y;
}
```
