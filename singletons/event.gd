extends Node

# dialog
signal start_dialog(dialog_data, dialog_index)
signal get_next_line()
signal show_next_line(idx)
signal end_dialog()
signal choose_dialog_option(idx)

# player
signal player_pause()
signal player_resume()
signal player_move(pos)
signal player_world_interact()
signal player_equip(item)
signal player_unequip()

# backpack
signal toggle_backpack()
signal bag_item_change(item)
signal equip_backpack_item(idx)
signal unequip_backpack_item(idx)
signal pre_item_menu_show(callback)
signal pickup_item(item)
signal consume_equipment()
signal equipment_num_change(num)

# global game utility
signal update_time(hour, minute)

# crop
signal use_seed(seed_name)
signal crop_planted(coord, atlas)
signal remove_crop(coord)

