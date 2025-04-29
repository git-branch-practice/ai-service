# ai_service.py

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Query(BaseModel):
    text: str

@app.post("/ai/predict")
def predict(query: Query):
    response = f"입력된 텍스트: {query.text} (AI 응답 샘플)"
    return {"result": response}
