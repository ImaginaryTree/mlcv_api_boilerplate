from fastapi import APIRouter
from api.handlers.image.image_handler import handle_predict

router = APIRouter()

@router.post("/image/predict")
def predict_endpoint(file: bytes):
    return handle_predict(file)
