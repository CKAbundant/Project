FROM nvcr.io/nvidia/pytorch:22.01-py3
LABEL maintainer="Aw Chong Kiang <22034803@myrp.edu.sg>"
USER root

WORKDIR /workspace/assignment

COPY requirements.txt /workspace/assignment/requirements.txt

RUN python3 -m pip install --no-cache-dir -r requirements.txt && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache
    
COPY . /workspace/assignment/

RUN python cache.py
    
ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]

EXPOSE 8501

