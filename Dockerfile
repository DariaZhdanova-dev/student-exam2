FROM python:3.7
EXPOSE 5000

COPY . /usr/local/js_example
WORKDIR /usr/local/js_example
ENV FLASK_APP js_example
RUN pip3 install -e .

ENTRYPOINT flask run --host=0.0.0.0