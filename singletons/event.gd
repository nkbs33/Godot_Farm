extends Node

# dialog
signal start_dialog(dialog_data)

# player
signal player_pause()
signal player_resume()
signal player_move(pos)
signal player_world_interact()
signal player_equip(item)
signal player_unequip()

# backpack
signal toggle_backpack()
signal pickup_item(item)
signal consume_equipment()
signal equipment_num_change(num)

signal open_backpack_sell()
signal close_backpack_sell()

# global game utility
signal update_time(hour, minute)

# crop
signal use_seed(seed_name)
signal crop_planted(coord, atlas)
signal remove_crop(coord)

