# Eye-Tracking Dyslexia Detection Service

This project aims to provide a service that detects dyslexia by analyzing eye movements from video inputs. The backend is built with Flask and deployed using Docker and Render. The core processing involves using computer vision techniques to analyze eye movements and generate predictions.

## Features

- Upload a video to the service
- Analyze eye movements from the video
- Get a prediction indicating whether the subject is likely dyslexic

## Tech Stack

- Python
- Flask
- OpenCV
- Dlib
- Gunicorn
- Docker
- Render

## Setup and Installation

### Prerequisites

- Python 3.11
- Docker
- Git

### Local Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/AlikoGrace/final_eye_tracking_model.git
  cd final_eye_tracking_model

  ###create virtual environment  and activate it 
python3 -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
###Install requirements
pip install -r requirements.txt

### Run app
python app.py
