from fastapi import FastAPI
from api.controllers.user import user_controller

app = FastAPI()

app.include_router(user_controller.router)
