from sqlalchemy.orm import Session
from repo.user.user_repository import create_user, get_users
from models.user.user_dto import UserCreate

def add_user_service(db: Session, user: UserCreate):
    return create_user(db, user)

def list_users_service(db: Session):
    return get_users(db)
