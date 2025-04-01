from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import requests
import os
import uuid
from gtts import gTTS
from dotenv import load_dotenv
from fastapi.middleware.cors import CORSMiddleware

# ✅ Allow Flutter (Frontend) to communicate with FastAPI
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to your frontend URL if deployed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ✅ Load environment variables
load_dotenv()

# ✅ Get Together.AI API Key (Ensure it's set in .env)
API_KEY = os.getenv("TOGETHER_API_KEY")  
if not API_KEY:
    raise ValueError("TOGETHER_API_KEY is not set. Add it to a .env file.")

API_URL = "https://api.together.xyz/v1/chat/completions"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}

# ✅ Initialize FastAPI app
app = FastAPI()

# ✅ Ensure "static" directory exists
STATIC_DIR = os.path.join(os.getcwd(), "static")
if not os.path.exists(STATIC_DIR):
    os.makedirs(STATIC_DIR)

# ✅ Mount static files directory for serving audio
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# ✅ Define request model
class TextRequest(BaseModel):
    text: str

# ✅ Root route (IMPORTANT for Render)
@app.get("/")
def home():
    return {"message": "Dyslexia App is running!"}

# ✅ Function to simplify text using Together.AI
def simplify_text(text: str):
    payload = {
        "model": "Qwen/Qwen2-VL-72B-Instruct",
        "messages": [
            {"role": "system", "content": "You are a kind teacher helping a dyslexic child. Use **very short sentences**. Use **super easy words**. Give **one simple example**. Avoid big words."},
            {"role": "user", "content": f"Explain this in the shortest way possible: {text}"}
        ],
        "temperature": 0.2
    }

    try:
        response = requests.post(API_URL, headers=HEADERS, json=payload)
        response.raise_for_status()  # Raises an error for non-200 status codes
        data = response.json()
        return data.get("choices", [{}])[0].get("message", {}).get("content", "No response generated.")
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Error calling Together.AI: {str(e)}")

# ✅ Function to convert simplified text to speech
def text_to_speech(text: str):
    filename = f"audio_{uuid.uuid4()}.mp3"
    filepath = os.path.join(STATIC_DIR, filename)

    try:
        tts = gTTS(text=text, lang="en")
        tts.save(filepath)
        return f"/static/{filename}"
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Text-to-speech failed: {str(e)}")

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
    return {"simplified_text": simplified_text, "audio_url": audio_url}

# ✅ Run the app for Render (Dynamic Port Handling)
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 10000))  # Render sets PORT dynamically
    uvicorn.run(app, host="0.0.0.0", port=port)
