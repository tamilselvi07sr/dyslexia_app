import requests

BASE_URL = "http://127.0.0.1:8000"  # Change if running on a different port

# Test Simplify API
def test_simplify():
    payload = {"text": "The mitochondrion is the powerhouse of the cell."}
    response = requests.post(f"{BASE_URL}/simplify", json=payload)
    print("Simplified Text:", response.json())

# Test Simplify + Audio API
def test_simplify_audio():
    payload = {"text": "Photosynthesis is the process by which plants make food using sunlight."}
    response = requests.post(f"{BASE_URL}/simplify-audio", json=payload)
    print("Response:", response.json())

if __name__ == "__main__":
    test_simplify()
    test_simplify_audio()
