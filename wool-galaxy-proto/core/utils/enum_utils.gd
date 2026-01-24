# enum_utils.gd
class_name EnumUtils

static func direction_to_vector(direction: Enums.Direction4Way) -> Vector2:
    match direction:
        Enums.Direction4Way.LEFT: return Vector2(-1, 0)
        Enums.Direction4Way.RIGHT: return Vector2(1, 0)
        Enums.Direction4Way.UP: return Vector2(0, -1)
        Enums.Direction4Way.DOWN: return Vector2(0, 1)
        _: return Vector2.ZERO