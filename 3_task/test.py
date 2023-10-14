import requests
import json

data = {
  "fullname": "George",
  "characteristics": {
    "sex": "male",
    "age": 27
  },
  "skills": ["smart", "strong"],
  "experience": [
    {
      "position": "developer",
      "workplace": "netflix",
      "salary": "7000"
    },
    {
      "position": "engineer",
      "workplace": "facebook",
      "id_card": 56117,
      "Country": "Scotland"
    }
  ]
}

url = 'http://127.0.0.1:5000/json_to_xml'
headers = {'Content-Type': 'application/json'}
response = requests.post(url, data=json.dumps(data), headers=headers)

if response.status_code == 200:
    print(response.text)
else:
    print(f"Request failed with status code {response.status_code}: {response.text}")