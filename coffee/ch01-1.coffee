getWebGLContext = (canvas) ->
  try
    gl = canvas.getContext("experimental-webgl")
  catch e
    msg = "Error creating WebGL context!: " + e.toString()
    alert(msg)
    throw msg

initViewport = (gl, canvas) ->
  # gl.viewport 0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight
  gl.viewport 0, 0, canvas.width, canvas.height

# Position of square relative to camera.
initModelViewMatrix = () ->
  new Float32Array [
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, -3.333, 1
  ]

# Required by shader to convert 3D (model) to 2D (camera).
initProjectionMatrix = () ->
  new Float32Array [
    2.41421, 0, 0, 0,
    0, 2.41421, 0, 0,
    0, 0, -1.002002, -1,
    0, 0, -0.2002002, 0
  ]

vertexShaderSource = "
  attribute vec3 vertexPos;\n
  uniform mat4 modelViewMatrix;\n
  uniform mat4 projectionMatrix;\n
  void main (void) {\n
    // Return the transformed and projected vertex value.\n
    gl_Position = projectionMatrix * modelViewMatrix *
      vec4(vertexPos, 1.0);\n
  }\n
  "

fragmentShaderSource = "
  void main(void) {\n
    // Return the pixel color: always output white.\n
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);\n
  }\n"

createShader = (gl, str, type) ->
  shader = gl.createShader(
    if (type == "fragment")
      gl.FRAGMENT_SHADER
    else
      gl.VERTEX_SHADER)
  gl.shaderSource shader, str
  gl.compileShader shader
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
    alert gl.getShaderInfoLog(shader)
    shader = null
  shader

initShader = (gl) ->
  # load and compile the fragment and vertex shaders
  fragmentShader = createShader gl, fragmentShaderSource, "fragment"
  vertexShader = createShader gl, vertexShaderSource, "vertex"

  # link them together into a new program
  shaderProgram = gl.createProgram()
  gl.attachShader shaderProgram, vertexShader
  gl.attachShader shaderProgram, fragmentShader
  gl.linkProgram shaderProgram

  # get pointers to the shader params
  shaderVertexPositionAttribute = gl.getAttribLocation shaderProgram, "vertexPos"
  gl.enableVertexAttribArray shaderVertexPositionAttribute
  
  shaderProjectionMatrixUniform = gl.getUniformLocation shaderProgram, "projectionMatrix"
  shaderModelViewMatrixUniform = gl.getUniformLocation shaderProgram, "modelViewMatrix"

  if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS))
    alert "Could not initialise shaders"

  shader =
    shaderProgram: shaderProgram
    shaderVertexPositionAttribute: shaderVertexPositionAttribute
    shaderProjectionMatrixUniform: shaderProjectionMatrixUniform
    shaderModelViewMatrixUniform: shaderModelViewMatrixUniform

createSquare = (gl) ->
  vertexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, vertexBuffer
  verts = [
     0.5,  0.5, 0.0,
    -0.5,  0.5, 0.0,
     0.5, -0.5, 0.0,
    -0.5, -0.5, 0.0
  ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(verts), gl.STATIC_DRAW
  square = { buffer: vertexBuffer, vertSize: 3, nVerts: 4, primtype: gl.TRIANGLE_STRIP }

draw = (gl, obj, shader, mvMat, pMat) ->
  # clear the background (with black)
  gl.clearColor 0.0, 0.0, 0.0, 1.0
  gl.clear gl.COLOR_BUFFER_BIT
  # set the vertex buffer to be drawn
  gl.bindBuffer gl.ARRAY_BUFFER, obj.buffer
  # set the shader to use
  gl.useProgram shader.shaderProgram
  # connect up the shader parameters:
  #   vertex position and projection / model matrices
  gl.vertexAttribPointer shader.shaderVertexPositionAttribute, obj.vertSize, gl.FLOAT, false, 0, 0
  gl.uniformMatrix4fv shader.shaderProjectionMatrixUniform, false, pMat
  gl.uniformMatrix4fv shader.shaderModelViewMatrixUniform, false, mvMat
  # draw the object
  gl.drawArrays obj.primtype, 0, obj.nVerts

$ ->
  # 1. Create a canvas element.
  canvas = document.createElement("canvas")
  canvas.height = 500   # Size must be set before getting
  canvas.width = 500    # the canvas' WebGL context.
  $("body").append(canvas)
  # 2. Obtain a drawing context for the canvas.
  gl = getWebGLContext canvas
  # 3. Initialize the viewport.
  initViewport gl, canvas
  # 4. Create buffers containing data to be rendered.
  square = createSquare gl
  # 5. Create matrices to define the transformation from
  #    vertex buffers to screen space.
  mvMat = initModelViewMatrix()
  pMat = initProjectionMatrix()
  # 6. Create shaders to implement drawing algorithm.
  # vertex + fragment (pixel)
  # 7. Initialize shaders with parameters.
  shader = initShader gl
  # 8. Draw
  draw gl, square, shader, mvMat, pMat
