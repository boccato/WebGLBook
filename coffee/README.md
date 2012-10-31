CoffeeScript Port
=================

This is not a line by line transcript of the original JavaScript code, but is pretty close.

To compile just run:
> coffee -c ch01-1.coffee

To make it auto-recompile everytime you change the file:
> coffee -cw ch01-1.coffee

The code is based on Three.js version r52 and jQuery 1.8.2 (that is why there is a different lib/ directory here).

A few things had to be changed for compatibility with r52:
- [sim.js] ray.intersectScene(this.scene) has changed to ray.intersectObject([this.scene])
- uniforms["tNormal"].texture has changed to uniforms["tNormal"].value
  (same thing for "tDiffuse" and "tSpecular")