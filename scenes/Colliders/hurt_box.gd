class_name HurtBox
extends Area2D

enum HitType {NORMAL, KNOCKDOWN, POWERHIT}

signal hit(damage : int, direction : Vector2, type : HitType)
