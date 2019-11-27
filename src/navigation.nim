import math
import config
import la
import image

const VELOCITY_THRESHOLD = 10.0

type Mouse* = object
  curr*: Vec2f
  prev*: Vec2f
  drag*: bool

type Camera* = object
  position*: Vec2f
  velocity*: Vec2f
  scale*: float32
  deltaScale*: float

proc world*(camera: Camera, v: Vec2f): Vec2f =
  v / camera.scale

proc update*(camera: var Camera, config: Config, dt: float, mouse: Mouse, image: Image,
             windowSize: Vec2f) =
  if abs(camera.deltaScale) > 0.5:
    let p0 = (mouse.curr - (windowSize * 0.5)) / camera.scale
    camera.scale = max(camera.scale + camera.delta_scale * dt, 0.01)
    let p1 = (mouse.curr - (windowSize * 0.5)) / camera.scale
    camera.position += p0 - p1

    camera.delta_scale -= sgn(camera.delta_scale).float * config.scale_friction * dt

  if not mouse.drag and (camera.velocity.length > VELOCITY_THRESHOLD):
    camera.position += camera.velocity * dt
    camera.velocity -= camera.velocity * dt * config.dragFriction
