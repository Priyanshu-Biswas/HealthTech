from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
import logging

app = Flask(__name__)
CORS(app)  # Allow all origins

genai.configure(api_key="AIzaSyCvyrF3nAQcraL93RuQpuD5Ua_L1HkRHIc")  # ⚠ Exposed API key

client = genai.GenerativeModel("gemini-2.0-flash")

@app.route('/send_prompt', methods=['POST'])
def send_prompt():
    data = request.json
    prompt = data.get('prompt')

    if not prompt:
        return jsonify({"error": "No prompt provided"}), 400

    try:
        response = client.generate_content(prompt)

        if response and hasattr(response, 'text'):
            text_response = response.text
        else:
            text_response = "No response from AI."

        return jsonify({"API Output": str(text_response)})

    except Exception as e:
        logging.error("Error occurred: %s", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    app.run(host='0.0.0.0', port=5000, debug=True)