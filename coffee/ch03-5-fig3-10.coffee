# Wireframe rendering of ring geometry (Fig. 3-10)

class Rings extends Sim.Object
  constructor: () ->
    Sim.Object.call this
  init: () ->
    geometry = new Saturn.Rings 1.1, 1.867, 64
    material = new THREE.MeshBasicMaterial wireframe: true
    mesh = new THREE.Mesh geometry, material
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
