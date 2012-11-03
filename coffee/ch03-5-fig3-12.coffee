# Wireframe rendering of ring geometry (Fig. 3-10)

class Rings extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    texture = THREE.ImageUtils.loadTexture "../images/SatRing.png"
    geometry = new Saturn.Rings 1.1, 1.867, 64
    material = new THREE.MeshLambertMaterial {map: texture, transparent:true, ambient:0xffffff}
    mesh = new THREE.Mesh geometry, material
    mesh.doubleSided = true
    this.setObject3D mesh

class SaturnRingsApp extends Sim.App 
  constructor: () ->
    Sim.App.call this
  init: (param) ->
    super param

    rings = new Rings()
    rings.init()
    this.addObject rings

    this.camera.position.z += 2

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

  app = new SaturnRingsApp()
  app.init container: container
  app.run()
