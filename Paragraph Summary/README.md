# Paragraph Summary
* Translate text input in either Japanese or Mandarin to English.
* Perform extractive or abstractive summary on the translated English text.
* Users allowed to determine the length of abstractive summary (from 10 to 50).
* Use streamlit application for user to input text.
* `paragraph_summary.mp4` shows how paragraph summary is implemented in streamlit.

| S/N | File | Description |
| :---: | :---: | :---: |
| 1 | app.py | Configure steamlit for user to select language and input text |
| 2 | cache.py | Code implementation for loading translation models and summary models |
| 3 | Dockerfile | Instructions for building docker |
| 4 | requirements.txt| Applications to be installed via docker build |


