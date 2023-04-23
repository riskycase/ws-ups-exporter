FROM python

RUN addgroup --system --gid 112 i2c
RUN adduser --system --ingroup i2c worker

USER worker

WORKDIR /home/worker

#ENV DEBIAN_FRONTEND=noninteractive
#RUN apt-get update && apt-get install systemd-sysv -y && rm -rf /var/cache/apt

COPY requirements.txt /home/worker
RUN pip3 install --user -r requirements.txt

COPY *py /app/

ENTRYPOINT ["/home/worker/exporter.py"]

EXPOSE 8000
