from PIL import Image
import io

def preprocess_image(file: bytes):
    return Image.open(io.BytesIO(file))
