from flask import Flask, request, send_from_directory
import base64

from app import generateCaption

app = Flask(__name__)


@app.get('/')
def index_age():
    return send_from_directory('web', 'index.html')


@app.get('/<path:path>')
def _static(path):
    return send_from_directory('web', path)


@app.post("/api/generate")
def get_image_caption():
    image_in_base64 = request.get_json()['image']
    extension = request.get_json()['extension']

    file_path = "images/image.{}".format(extension)

    with open(file_path, "wb") as fh:
        fh.write(base64.urlsafe_b64decode(image_in_base64))

    caption = generateCaption([file_path])

    response = {
        'caption': caption[0]
    }

    return response
