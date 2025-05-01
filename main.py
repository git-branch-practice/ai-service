from fastapi import FastAPI
from pydantic import BaseModel
import random

app = FastAPI()

class Message(BaseModel):
    content: str

@app.post("/ai/analyze")
def analyze(message: Message):
    emotion = random.choice(["positive", "negative"])
    return {"emotion": emotion}
