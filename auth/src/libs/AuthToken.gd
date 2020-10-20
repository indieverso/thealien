extends Node
class_name AuthToken

# You can set it via GODOT_TOKEN_SECRET environment variable
var secret = 'YQoy1pFDOHeddU8TnN9w4kckg4EWlbZ5'


func _ready() -> void:
	if OS.has_environment("GODOT_TOKEN_SECRET"):
		secret = OS.get_environment("GODOT_TOKEN_SECRET")


func generate_token(payload) -> String:
	var header = {
		"typ": "JWT",
		"alg": "HS256"
	}
	
	var encoded_header : String = base64_encode(json_encode(header))
	var encoded_payload : String = base64_encode(json_encode(payload))
	
	var signature = hmac_sha256(
		encoded_header + "." + encoded_payload,
		secret)
	var encoded_signature : String = Marshalls.raw_to_base64(signature)
	
	return encoded_header + "." + encoded_payload + "." + encoded_signature


func base64_encode(value: String) -> String:
	value = Marshalls.utf8_to_base64(value)
	return value.replace("+", "-").replace("/", "_").replace("=", "")


func json_encode(value: Dictionary) -> String:
	return JSON.print(value)


func hmac_sha256(message, key):
	var x = 0
	var k
	
	if key.length() <= 64:
		k = key.to_utf8()

	# Hash key if length > 64
	if key.length() > 64:
		k =  key.sha256_buffer()

	# Right zero padding if key length < 64
	while k.size() < 64:
		k.append(convert_hex_to_dec("00"))

	var i = "".to_utf8()
	var o = "".to_utf8()
	var m = message.to_utf8()
	var s = File.new()
			
	while x < 64:
		o.append(k[x] ^ 0x5c)
		i.append(k[x] ^ 0x36)
		x += 1
		
	var inner = i + m
	
	s.open("user://temp", File.WRITE)
	s.store_buffer(inner)
	s.close()
	var z = s.get_sha256("user://temp")
	
	var outer = "".to_utf8()
	
	x = 0
	while x < 64:
		outer.append(convert_hex_to_dec(z.substr(x, 2)))
		x += 2
	
	outer = o + outer
	
	s.open("user://temp", File.WRITE)
	s.store_buffer(outer)
	s.close()
	
	z = s.get_sha256("user://temp")
	
	outer = "".to_utf8()
	
	x = 0
	while x < 64:
		outer.append(convert_hex_to_dec(z.substr(x, 2)))
		x += 2
	
	var mm = outer
	return outer


func convert_hex_to_dec(h):
	var c = "0123456789ABCDEF"
	
	h = h.to_upper()
	
	var r = h.right(1)
	var l = h.left(1)
	
	var b0 = c.find(r)
	var b1 = c.find(l) * 16
	
	var x = b1 + b0
	return x
