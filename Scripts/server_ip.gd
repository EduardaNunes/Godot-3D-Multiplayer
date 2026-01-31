# ---------------------------------------------------------------------------- #

extends Label

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	text = get_server_ip()

# ---------------------------------------------------------------------------- #

func get_server_ip() -> String:
	var ip_address = ""
	var ip_list = IP.get_local_addresses()
	
	for ip in ip_list:
		if ip.find(":") == -1 and ip != "127.0.0.1":
			if ip.begins_with("192.168.") or ip.begins_with("10."):
				ip_address = ip
				break
			if ip_address == "":
				ip_address = ip
				
	if ip_address == "":
		return "127.0.0.1"
		
	return ip_address

# ---------------------------------------------------------------------------- #
