from core.image.inference_pipeline import run_inference
from utils.image.image_utils import preprocess_image

def predict_service(file: bytes):
    image = preprocess_image(file)
    result = run_inference(image)
    return {"prediction": result}
