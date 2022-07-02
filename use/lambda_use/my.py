import json
def handler(event,context):
    return json.dumps({"message": "Hello World"})