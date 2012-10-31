$ ->
  # 1. Create a div element (container).
  container = document.createElement "div"
  $(container).css
    height: 500
    width: 500
    background: '#000000'
  $("body").append container

  # 2. Create the Three.js renderer.
  renderer = new THREE.WebGLRenderer()
  renderer.setSize container.offsetWidth, container.offsetHeight
  container.appendChild renderer.domElement

  # 3. Create a new Three.js scene.
  scene = new THREE.Scene()

  # 4. Create a camera and add it to the scene.
  camera = new THREE.PerspectiveCamera(
    45, container.offsetWidth / container.offsetHeight, 1, 4000
  )
  camera.position.set 0, 0, 3.3333
  scene.add camera

  # 5. Create a rectangle and add it to the scene.
  geometry = new THREE.PlaneGeometry 1, 1
  mesh = new THREE.Mesh geometry, new THREE.MeshBasicMaterial()
  scene.add mesh

  # 6. Render it.
  renderer.render scene, camera