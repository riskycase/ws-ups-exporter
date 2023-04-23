FROM python

RUN addgroup --system --gid 112 i2c
RUN adduser --system --ingroup i2c worker

USER worker

WORKDIR /home/worker

COPY requirements.txt /home/worker
RUN pip3 install --user -r requirements.txt

COPY *py /home/worker/

ENTRYPOINT ["/home/worker/exporter.py"]

EXPOSE 8000
