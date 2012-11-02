# The @ is used to export the class.
class @Saturn
  constructor: () ->
    super()

class Saturn.Rings extends THREE.Geometry
  constructor: (innerRadius, outerRadius, nSegments) ->
    super()
    
    innerRadius ?= 0.5
    outerRadius ?= 1
    gridY = nSegments ? 10

    twopi = 2 * Math.PI
    iVer = Math.max(2, gridY)

    origin = THREE.Vector3 0, 0, 0

    for i in [0..iVer]
      fRad1 = i / iVer
      fRad2 = (i + 1) / iVer
      fX1 = innerRadius * Math.cos( fRad1 * twopi )
      fY1 = innerRadius * Math.sin( fRad1 * twopi )
      fX2 = outerRadius * Math.cos( fRad1 * twopi )
      fY2 = outerRadius * Math.sin( fRad1 * twopi )
      fX4 = innerRadius * Math.cos( fRad2 * twopi )
      fY4 = innerRadius * Math.sin( fRad2 * twopi )
      fX3 = outerRadius * Math.cos( fRad2 * twopi )
      fY3 = outerRadius * Math.sin( fRad2 * twopi )
      
      v1 = new THREE.Vector3( fX1, fY1, 0 )
      v2 = new THREE.Vector3( fX2, fY2, 0 )
      v3 = new THREE.Vector3( fX3, fY3, 0 )
      v4 = new THREE.Vector3( fX4, fY4, 0 )
      @vertices.push( new THREE.Vertex( v1 ) )
      @vertices.push( new THREE.Vertex( v2 ) )
      @vertices.push( new THREE.Vertex( v3 ) )
      @vertices.push( new THREE.Vertex( v4 ) )

    for i in [0..iVer]
      @faces.push(new THREE.Face3( i * 4, i * 4 + 1, i * 4 + 2))
      @faces.push(new THREE.Face3( i * 4, i * 4 + 2, i * 4 + 3))
      @faceVertexUvs[ 0 ].push( [
                          new THREE.UV(0, 1),
                          new THREE.UV(1, 1),
                          new THREE.UV(1, 0) ] );
      @faceVertexUvs[ 0 ].push( [
                          new THREE.UV(0, 1),
                          new THREE.UV(1, 0),
                          new THREE.UV(0, 0) ] );

    this.computeCentroids()
    this.computeFaceNormals()
    @boundingSphere = radius: outerRadius
