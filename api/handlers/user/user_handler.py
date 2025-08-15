from fastapi import Depends
from sqlalchemy.orm import Session
from repo.db import get_db
from models.user.user_dto import UserCreate
from services.user.user_service import add_user_service, list_users_service

def handle_create_user(user: UserCreate, db: Session = Depends(get_db)):
    return add_user_service(db, user)

def handle_list_users(db: Session = Depends(get_db)):
    return list_users_service(db)
