class TweenApp extends Sim.App
  constructor: () ->
    Sim.App.call this

  init: (param) ->
    super param

    # Create a point light to show off the MovingBall.
    light = new THREE.PointLight 0xffffff, 1, 100
    light.position.set 0, 0, 20
    @scene.add light

    @camera.position.z = 6.667

    # Create a MovingBall and add it to our sim.
    @movingBall = new MovingBall()
    @movingBall.init()
    @addObject @movingBall

  update: () ->
    TWEEN.update()
    super()

  handleMouseUp: (x, y) ->
    @movingBall.animate()

class MovingBall extends Sim.Object
  constructor: () ->
    Sim.Object.call this

  init: () ->
    # Create our MovingBall.
    BALL_TEXTURE = "../images/ball_texture.jpg"
    geometry = new THREE.SphereGeometry 1, 32, 32
    material = new THREE.MeshPhongMaterial
      map: THREE.ImageUtils.loadTexture BALL_TEXTURE
    mesh = new THREE.Mesh geometry, material
    mesh.position.x = -3.333
    # Thell the framework about our object.
    @setObject3D mesh
  animate: () ->
    if @object3D.position.x > 0
      newpos = @object3D.position.x - 6.667
    else
      newpos = @object3D.position.x + 6.667
    new TWEEN.Tween(@object3D.position)
      .to(x: newpos, 2000).start()

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

  app = new TweenApp()
  app.init container: container
  app.run()
