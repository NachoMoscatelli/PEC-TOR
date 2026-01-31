class_name HurtBox
extends Area2D

enum HitType {NORMAL, UPPERCUT, HIGHKICK}

signal hit(damage : int, direction : Vector2, type : HitType)
