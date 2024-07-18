extends Node

signal start_dialog()
signal end_dialog()

signal player_pause()
signal player_resume()

signal player_move(pos)
signal player_world_interact()
signal player_equip(item)

signal bag_item_change(item)
signal equip_backpack_item(idx)

signal move_in_ui()
signal update_time(hour, minute)

signal plant_crop(coord, atlas)
signal remove_crop(coord)

signal toggle_backpack()

