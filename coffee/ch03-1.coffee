# Global state of the program.
camera    = null
mesh      = null
renderer  = null
scene     = null

class EarthApp extends Sim.App 
  constructor: () ->
    Sim.App.call this
  init: (param) ->
    Sim.App.prototype.init.call this, param
    earth = new Earth()
    earth.init()
    this.addObject earth

class Earth extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    earthmap = "../images/earth_surface_2048.jpg"
    geometry = new THREE.SphereGeometry 1, 32, 32
    texture  = THREE.ImageUtils.loadTexture earthmap
    material = new THREE.MeshBasicMaterial map: texture
    mesh     = new THREE.Mesh geometry, material

    mesh.rotation.z = Earth.TILT
    this.setObject3D mesh
  update: () ->
    this.object3D.rotation.y += Earth.ROTATION_Y
  @ROTATION_Y  : 0.0025
  @TILT        : 0.41


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
