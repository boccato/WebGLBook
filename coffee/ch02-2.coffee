# Global state of the program.
animating = false
camera    = null
cube      = null
renderer  = null
scene     = null

$ ->
  # Create a div element (container).
  container = document.createElement "div"
  $(container).css
    height: "80%"
    width: "95%"
    position: "absolute"
  $("body").append container
  prompt = document.createElement "div"
  $(prompt)
    .css
      height: "6%"
      width: "95%"
      bottom: 0
      position: "absolute"
    .text "Click to animate the cube."
  $("body").append prompt

  # Create the Three.js renderer.
  renderer = new THREE.WebGLRenderer( antialias: true)
  renderer.setSize container.offsetWidth, container.offsetHeight
  container.appendChild renderer.domElement

  # Create a new Three.js scene.
  scene = new THREE.Scene()

  # Create a camera and add it to the scene.
  camera = new THREE.PerspectiveCamera(
    45, container.offsetWidth / container.offsetHeight, 1, 4000
  )
  camera.position.set 0, 0, 3
  scene.add camera

  # Create a directional light to show off the object.
  light = new THREE.DirectionalLight 0xffffff, 1.5
  light.position.set 0, 0, 1
  scene.add light

  # Create a shaded, texture-mapped cube.
  mapUrl = "../images/molumen_small_funny_angry_monster.jpg"
  map = THREE.ImageUtils.loadTexture(mapUrl)
  material = new THREE.MeshPhongMaterial map: map
  geometry = new THREE.CubeGeometry 1, 1, 1
  cube = new THREE.Mesh geometry, material

  # Turn the cube toward the scene.
  cube.rotation.x = Math.PI / 5
  cube.rotation.y = Math.PI / 5

  scene.add cube

  # Add a mouse up handler to toggle the animation.
  addMouseHandler()

  # Render loop.
  run()

run = () ->
  renderer.render scene, camera
  cube.rotation.y -= 0.01 if animating
  requestAnimationFrame run

addMouseHandler = () ->
  renderer.domElement.addEventListener "mouseup", onMouseUp, false

onMouseUp = (event) ->
  event.preventDefault()
  animating = !animating
