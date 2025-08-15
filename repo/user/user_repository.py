from sqlalchemy.orm import Session
from models.user.user_model import User
from models.user.user_dto import UserCreate

def create_user(db: Session, user: UserCreate):
    db_user = User(name=user.name, email=user.email)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_users(db: Session):
    return db.query(User).all()
