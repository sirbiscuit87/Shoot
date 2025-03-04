const PROPERTY_FLAG = 4096

static func obj_to_dict(obj: Object) -> Dictionary:
    var obj_as_dict = {}
    for prop in obj.get_property_list():
        if prop["usage"] == PROPERTY_FLAG:
            obj_as_dict[prop["name"]] = obj.get(prop["name"])

    return obj_as_dict

static func dict_to_obj(obj: Object, dict: Dictionary):
    for key in dict.keys():
        obj[key] = dict[key]