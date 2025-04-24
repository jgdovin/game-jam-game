# This file is part of QAudio, a Godot audio library.
# Copyright (C) 2025 Ducking Games Studio
class_name AudioStreamPlayerPool extends Node

"""
AudioStreamPlayerPool is a pool of AudioStreamPlayerPooling 
nodes that can be used to play audio streams.
"""

const DefaultBus: String = "Master"
const DefaultVolume: float = 1.0
const DefaultPoolSize: int = 8

var _mutex: Mutex = Mutex.new()
var _ready: Array[AudioStreamPlayerPooling] = []
var _busy: Array[AudioStreamPlayerPooling] = []

var _tick_timer: Timer = Timer.new()
var _tick_interval: float = 15 # seconds

## Initialize the pool with a given bus, volume, and size.
func _init(pool_bus: String = DefaultBus, pool_volume: float = DefaultVolume, pool_size: int = DefaultPoolSize) -> void:
  # Create the pool of AudioStreamPlayerPooling nodes
  for i in range(pool_size):
    var player: AudioStreamPlayerPooling = AudioStreamPlayerPooling.new()
    player.bus = pool_bus
    player.volume_db = linear_to_db(pool_volume)
    player.persistent = false # Set to true if you want the player to persist after finishing the stream
    add_child(player)
    _ready.append(player)

  # Create a timer to shrink the pool of players
  _tick_timer.wait_time = _tick_interval
  _tick_timer.autostart = true
  _tick_timer.one_shot = false
  _tick_timer.timeout.connect(_on_tick)
  add_child(_tick_timer)
  _tick_timer.start()

## _stab plays an audio stream immediately 
## and returns the player to the pool when finished
func _stab(_s: AudioStream, _b: String = DefaultBus, _v: float = DefaultVolume) -> void:
  var player: AudioStreamPlayerPooling = acquire(_s, _b)
  player.volume_db = linear_to_db(_v)
  player.play()


## Acquire a player from the pool and set its stream and bus
func acquire(_s: AudioStream, _b: String = DefaultBus) -> AudioStreamPlayerPooling:
  _mutex.lock()
  if _ready.size() == 0:
    _grow()

  var player: AudioStreamPlayerPooling = _ready.pop_front()
  player.acquire(_s, _b)
  _busy.append(player)
  _mutex.unlock()
  return player

# empty the pool of players and remove them from the scene tree
func _purge_pool() -> void:
  # Remove all players from the pool
  for player in _ready:
    player.queue_free()
  _ready.clear()

  for player in _busy:
    player.queue_free()
  _busy.clear()

# reset and build the pool of players
func _build_pool() -> void:
  _mutex.lock()
  _purge_pool()
  for i in DefaultPoolSize:
    _grow()
  _mutex.unlock()

# grow the pool of players by one
func _grow() -> void:
  # Add more players to the pool
  var new_player: AudioStreamPlayerPooling = AudioStreamPlayerPooling.new()
  new_player.bus = DefaultBus
  new_player.volume_db = linear_to_db(DefaultVolume)
  _mutex.lock()
  _ready.append(new_player)
  _mutex.unlock()
  # Add the new player to the scene tree
  add_child(new_player)
  new_player.finished.connect(_finished.bind(new_player))

# called on every tick of the timer, used to shrink the pool of players
func _on_tick() -> void:
  _mutex.lock()
  # Check if the pool is too large and shrink it
  if _ready.size() > DefaultPoolSize:
    _shrink()
  _mutex.unlock()

# shrink the pool of players by one
func _shrink() -> void:
  _mutex.lock()
  # Remove a player from the pool
  if _ready.size() > DefaultPoolSize:
    var player: AudioStreamPlayerPooling = _ready.pop_back()
    player.queue_free()
  else:
    push_error("Attempted to shrink the pool below the default size")
  _mutex.unlock()

# called when a player is finished playing its stream
func _finished(player: AudioStreamPlayerPooling) -> void:
  recycle(player)

func recycle(player: AudioStreamPlayerPooling) -> void:
  # Move the player from the busy list to the ready list
  _mutex.lock()
  player.reset()
  if _busy.has(player):
    _busy.erase(player)
  if not _ready.has(player):
    _busy.append(player)
  _mutex.unlock()
