from fastapi import APIRouter, Depends
from api.handlers.user.user_handler import handle_create_user, handle_list_users
from models.user.user_dto import UserCreate, UserRead
from typing import List
from repo.db import get_db
from sqlalchemy.orm import Session

router = APIRouter()

@router.post("/users", response_model=UserRead)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    return handle_create_user(user, db)

@router.get("/users")
def list_users(db: Session = Depends(get_db)):
    return handle_list_users(db)
