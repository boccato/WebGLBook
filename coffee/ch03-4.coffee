# Global state of the program.
camera    = null

class EarthApp extends Sim.App 
  constructor: () ->
    Sim.App.call this
  init: (param) ->
    super param
    # Our pretty earth!
    earth = new Earth()
    earth.init()
    this.addObject earth
    # Let there be light.
    sun = new Sun()
    sun.init()
    this.addObject sun
    #
    this.camera.position.z += 1.667

class Earth extends Sim.Object
  constructor: () ->
    Sim.Object.call this

  init: () ->
    # Create a group to contain Earth and Clouds.
    earthGroup = new THREE.Object3D()
    this.setObject3D earthGroup
    this.createGlobe()
    this.createClouds()
    this.createMoon()

  createGlobe: () ->
    surfaceMap  = THREE.ImageUtils.loadTexture "../images/earth_surface_2048.jpg"
    normalMap   = THREE.ImageUtils.loadTexture "../images/earth_normal_2048.jpg"
    specularMap = THREE.ImageUtils.loadTexture "../images/earth_specular_2048.jpg"

    shader   = THREE.ShaderUtils.lib["normal"]
    uniforms = THREE.UniformsUtils.clone shader.uniforms
    # Used to be texture, now it is value.
    uniforms["tNormal"].value = normalMap
    uniforms["tDiffuse"].value = surfaceMap
    uniforms["tSpecular"].value = specularMap
    uniforms["enableDiffuse"].value = true
    uniforms["enableSpecular"].value = true

    material = new THREE.ShaderMaterial
      fragmentShader: shader.fragmentShader
      vertexShader: shader.vertexShader
      uniforms: uniforms
      lights: true

    geometry = new THREE.SphereGeometry 1, 32, 32

    # We'll need these tangents for our shader.
    geometry.computeTangents()
    mesh = new THREE.Mesh geometry, material
    mesh.rotation.x = Earth.TILT
    this.object3D.add mesh
    this.globeMesh = mesh

  createClouds: () ->
    map = THREE.ImageUtils.loadTexture "../images/earth_clouds_1024.png"
    material = new THREE.MeshLambertMaterial
      color: 0xffffff
      map: map
      transparent: true
    geometry = new THREE.SphereGeometry Earth.CLOUDS_SCALE, 32, 32
    mesh = new THREE.Mesh geometry, material
    mesh.rotation.x = Earth.TILT
    this.object3D.add mesh
    this.cloudsMesh = mesh

  createMoon: () ->
    moon = new Moon()
    moon.init()
    this.addChild moon

  update: () ->
    this.globeMesh.rotation.y += Earth.ROTATION_Y
    this.cloudsMesh.rotation.y += Earth.CLOUDS_ROTATION_Y
    super()

  @ROTATION_Y        : 0.001
  @RADIUS            : 6371
  @TILT              : 0.41
  @CLOUDS_SCALE      : 1.005
  # I like 0.7 better than 0.95 :)
  @CLOUDS_ROTATION_Y : Earth.ROTATION_Y * 0.95

class Sun extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    # Create a point light to show off the earth.
    light = new THREE.PointLight 0xffffff, 2, 100
    light.position.set -10, 0, 20
    this.setObject3D light

class Moon extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    geometry = new THREE.SphereGeometry Moon.SIZE_IN_EARTHS, 32, 32
    texture = THREE.ImageUtils.loadTexture "../images/moon_1024.jpg"
    material = new THREE.MeshPhongMaterial
      map: texture
      ambient: 0x888888
    mesh = new THREE.Mesh geometry, material
    # Let's get this into earth-sized units (earth is a unit sphere).
    distance = Moon.DISTANCE_FROM_EARTH / Earth.RADIUS
    mesh.position.set Math.sqrt(distance/2), 0, -Math.sqrt(distance/2)
    # Rotate the moon so it shows its moon-face toward earth.
    mesh.rotation.y = Math.PI
    # Create a group to contain Earth and satellites.
    moonGroup = new THREE.Object3D()
    moonGroup.add mesh
    moonGroup.rotation.y = Moon.INCLINATION
    this.setObject3D moonGroup
    this.moonMesh = mesh
  update: () ->
    this.object3D.rotation.y += Earth.ROTATION_Y / Moon.PERIOD
    super()

  @DISTANCE_FROM_EARTH  : 356400
  @PERIOD               : 28
  @EXAGGERATE_FACTOR    : 1.2
  @INCLINATION          : 0.089
  @SIZE_IN_EARTHS       : 1 / 3.7 * Moon.EXAGGERATE_FACTOR

$ ->
  # Create a div element (container).
  container = document.createElement "div"
  $(container).css
    height: "98%"
    width: "98%"
    overflow: "hidden"
    position: "absolute"
    background: "#000000"
  $("body").append container

  app = new EarthApp()
  app.init container: container
  app.run()
