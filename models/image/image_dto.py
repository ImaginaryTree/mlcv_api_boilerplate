from pydantic import BaseModel

class ImagePredictionRequest(BaseModel):
    file: bytes

class ImagePredictionResponse(BaseModel):
    prediction: str
