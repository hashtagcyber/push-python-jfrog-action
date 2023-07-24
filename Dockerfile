# Base container image
FROM python:3.9

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN pip install twine

ENTRYPOINT ["/entrypoint.sh"]


