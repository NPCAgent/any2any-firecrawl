FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libstdc++6 \
    xvfb 

WORKDIR /app

COPY common-debian.sh ./
RUN chmod +x common-debian.sh
RUN apt-get update && bash ./common-debian.sh

COPY desktop-lite-debian.sh ./
RUN sudo chmod +x desktop-lite-debian.sh
RUN apt-get update && bash ./desktop-lite-debian.sh
ENV DBUS_SESSION_BUS_ADDRESS="autolaunch:" \
    VNC_RESOLUTION="1440x768x16" \
    VNC_DPI="96" \
    VNC_PORT="5901" \
    NOVNC_PORT="6080" \
    DISPLAY=":1" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# Cannot run programs in fluxbox if user is root.
USER vscode 

# Install Python dependencies
COPY --chown=vscode:vscode requirements.txt ./

# Remove py which is pulled in by retry, py is not needed and is a CVE
RUN python -m pip install --no-cache-dir --upgrade -r requirements.txt && python -m pip uninstall -y py && \
    python -m playwright install chromium && python -m playwright install-deps chromium && \
    sudo ln -s /usr/local/bin/supervisord /usr/bin/supervisord


# Cleanup for CVEs and size reduction
# https://github.com/tornadoweb/tornado/issues/3107
# xserver-common and xvfb included by playwright installation but not needed after
# perl-base is part of the base Python Debian image but not needed for Danswer functionality
# perl-base could only be removed with --allow-remove-essential





COPY --chown=vscode:vscode . ./

EXPOSE $PORT
EXPOSE 6080
# run fast api hypercorn
# CMD hypercorn main:app --bind [::]:$PORT
CMD bash entrypoint.bash
# CMD ["hypercorn", "main:app", "--bind", "[::]:$PORT"]
# CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port $PORT"]
