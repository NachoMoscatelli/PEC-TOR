extends Area2D

# Esta variable aparecerá en el Inspector para que elijas el destino
@export var punto_destino: Marker2D 

func _ready():
	# Conectamos la señal que detecta cuando algo entra al área
	# Es más seguro hacerlo por código o por el panel de 'Nodos'
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Preguntamos: ¿Lo que entró es el jugador?
	if body.name == "Hector":
		# Si el punto de destino está configurado...
		if punto_destino != null:
			# 1. Movemos al jugador a la posición del marcador
			body.global_position = punto_destino.global_position
			
			# 2. Si el jugador tiene cámara, reiniciamos el suavizado 
			# para que no se vea el "viaje" rápido.
			var camera = body.get_node_or_null("Camera2D")
			if camera:
				camera.reset_smoothing()
		else:
			print("¡Error! No asignaste un punto_destino en el Inspector")
