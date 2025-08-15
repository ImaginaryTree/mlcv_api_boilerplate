from fastapi import APIRouter
from api.handlers.user.user_handler import handle_create_user, handle_list_users
from models.user.user_dto import UserCreate, UserRead
from typing import List

router = APIRouter()

@router.post("/", response_model=UserRead)
def create_user(user: UserCreate):
    return handle_create_user(user)

@router.get("/", response_model=List[UserRead])
def list_users():
    return handle_list_users()
