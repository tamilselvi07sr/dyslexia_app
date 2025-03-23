from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import requests
import os
import uuid
from gtts import gTTS
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get Together.AI API Key
API_KEY = os.getenv("TOGETHER_API_KEY", "tgp_v1_CTRpbzaiygerdWVYDtUELAyHSom5OdKDDzn9DYWBMtk")  # Replace with actual key
API_URL = "https://api.together.xyz/v1/chat/completions"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

# Initialize FastAPI app
app = FastAPI()

# ✅ Mount the "static" directory to serve audio files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Define request model
class TextRequest(BaseModel):
    text: str

# Function to simplify text using Together.AI
def simplify_text(text: str):
    payload = {
        "model": "Qwen/Qwen2-VL-72B-Instruct",
        "messages": [
            {"role": "system", "content": "You are a kind teacher helping a dyslexic child. Use **very short sentences**. Use **super easy words**. Give **one simple example**. Avoid big words."},
            {"role": "user", "content": f"Explain this in the shortest way possible: {text}"}
        ],
        "temperature": 0.2
    }

    response = requests.post(API_URL, headers=HEADERS, json=payload)

    if response.status_code == 200:
        data = response.json()
        return data.get("choices", [{}])[0].get("message", {}).get("content", "No response generated.")
    else:
        error_message = response.json().get("error", {}).get("message", "Unknown error")
        raise HTTPException(status_code=response.status_code, detail=error_message)

# ✅ Function to convert simplified text to speech
def text_to_speech(text: str):
    filename = f"audio_{uuid.uuid4()}.mp3"
    filepath = os.path.join("static", filename)

    # Generate speech
    tts = gTTS(text=text, lang="en")
    tts.save(filepath)

    return f"/static/{filename}"

# ✅ API Endpoint to simplify text
@app.post("/simplify")
def get_simplified_text(request: TextRequest):
    simplified_text = simplify_text(request.text)
    return {"simplified_text": simplified_text}

# ✅ API Endpoint to get simplified audio
@app.post("/simplify-audio")
def get_simplified_audio(request: TextRequest):
    simplified_text = simplify_text(request.text)
    audio_url = text_to_speech(simplified_text)
    return {"audio_url": audio_url}
