# Global state of the program.
camera    = null
mesh      = null
renderer  = null
scene     = null

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

class Earth extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    earthmap = "../images/earth_surface_2048.jpg"
    geometry = new THREE.SphereGeometry 1, 32, 32
    texture  = THREE.ImageUtils.loadTexture earthmap
    material = new THREE.MeshPhongMaterial map: texture
    mesh     = new THREE.Mesh geometry, material

    mesh.rotation.z = Earth.TILT
    this.setObject3D mesh
  update: () ->
    this.object3D.rotation.y += Earth.ROTATION_Y
  @ROTATION_Y  : 0.0025
  @TILT        : 0.41

class Sun extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    # Create a point light to show off the earth.
    light = new THREE.PointLight 0xffffff, 2, 100
    light.position.set -10, 0, 20
    this.setObject3D light

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
