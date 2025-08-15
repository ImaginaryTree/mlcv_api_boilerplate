from services.image.image_service import predict_service

def handle_predict(file: bytes):
    return predict_service(file)
