from fastapi import FastAPI, File, UploadFile
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import easyocr
import re

app = FastAPI()

# 1. Load your trained Freshness Model
# (Assumes you've saved your model as 'freshness_model.h5')
model = tf.keras.models.load_model('freshness_model.h5')
reader = easyocr.Reader(['en']) # Initialize OCR

def preprocess_image(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((224, 224))
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0) / 255.0
    return img_array

@app.post("/analyze")
async def analyze_food(file: UploadFile = File(...)):
    contents = await file.read()
    
    # --- TASK 1: Freshness Analysis ---
    processed_img = preprocess_image(contents)
    prediction = model.predict(processed_img)[0][0]
    # Logic: 0 = Fresh, 1 = Rotten (based on our training script)
    status = "Fresh" if prediction < 0.5 else "Spoiled"
    confidence = float(1 - prediction if prediction < 0.5 else prediction)

    # --- TASK 2: Expiry Date OCR ---
    # Convert bytes back to Image for EasyOCR
    nparr = np.frombuffer(contents, np.uint8)
    ocr_results = reader.readtext(nparr)
    
    found_date = "No date detected"
    date_pattern = r'\b(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b'
    for (_, text, _) in ocr_results:
        match = re.search(date_pattern, text)
        if match:
            found_date = match.group()
            break

    return {
        "status": status,
        "confidence": f"{confidence:.2%}",
        "expiry_date": found_date,
        "action_required": "Eat soon!" if status == "Fresh" and found_date != "No date detected" else "N/A"
  }
  
