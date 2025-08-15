from fastapi import FastAPI
from api.controllers.user import user_controller
from repo import db

# Create tables if not exists (optional for dev)
db.Base.metadata.create_all(bind=db.engine)

app = FastAPI()

app.include_router(user_controller.router, prefix="/users", tags=["Users"])
