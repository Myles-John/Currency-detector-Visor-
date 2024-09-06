
import torch
import cv2
from flask import Flask, render_template, Response
from ultralytics import YOLO
from gtts import gTTS
import os
import numpy as np
import time
import threading

app = Flask("VISOR")

# Load the YOLOv8 model on the GPU if available
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model = YOLO('models/best(2).pt').to(device)

# Global variables to store the latest annotated frame and detections
latest_frame = None
latest_detections = []
last_detection_time = 0
detection_interval = 2  # seconds
announcement_interval = 8  # seconds
last_detections = {}

def detection_thread(camera):
    global latest_frame, latest_detections, last_detection_time, last_detections
    while True:
        success, frame = camera.read()
        if not success:
            print("Error: Failed to read frame from camera")
            break
        
        # Resize frame for faster processing
        resized_frame = cv2.resize(frame, (320, 240))

        # Perform inference with YOLOv8
        results = model(resized_frame)
        annotated_frame = results[0].plot()
        
        # Get the detection labels
        detections = results[0].boxes.data.cpu().numpy()
        labels = results[0].names

        detected_objects = set()  # Use a set to ensure unique detections
        current_time = time.time()
        for detection in detections:
            class_id = int(detection[5])
            if class_id < len(labels):
                detected_objects.add(labels[class_id])

        # Convert set to list for processing
        detected_objects = list(detected_objects)

        # Filter out objects detected within the announcement interval
        detected_objects = [obj for obj in detected_objects if current_time - last_detections.get(obj, 0) > announcement_interval]

        if detected_objects and (current_time - last_detection_time > detection_interval):
            announcement = ', '.join(detected_objects)
            print(f"Detected: {announcement}")
            tts = gTTS(f"Detected: {announcement}", lang='en')
            tts.save("static/audio/detection.mp3")
            for obj in detected_objects:
                last_detections[obj] = current_time
            last_detection_time = current_time
        
        latest_frame = annotated_frame
        latest_detections = detected_objects

def generate_frames():
    global latest_frame
    while True:
        if latest_frame is not None:
            ret, buffer = cv2.imencode('.jpg', latest_frame)
            frame = buffer.tobytes()
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/audio_feed')
def audio_feed():
    def generate():
        while True:
            if os.path.exists("static/audio/detection.mp3"):
                with open("static/audio/detection.mp3", "rb") as audio_file:
                    yield audio_file.read()
                os.remove("static/audio/detection.mp3")
            else:
                yield b''
    return Response(generate(), mimetype='audio/mpeg')

if __name__ == '__main__':
    camera = cv2.VideoCapture(0)
    if not camera.isOpened():
        print("Error: Could not open video device")
    else:
        # Start the detection thread
        thread = threading.Thread(target=detection_thread, args=(camera,))
        thread.start()
        
        app.run(debug=True, use_reloader=False)

    camera.release()
