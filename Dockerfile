FROM python:alpine
WORKDIR /app
RUN apk add neovim bash git
COPY . .
RUN pip install -r requirements.txt
RUN mkdir /root/.config
RUN export USER=root
COPY ./nvim /root/.config/nvim
COPY ./.local /root/.local
EXPOSE 5000
CMD ["python", "app.py", "--command", "nvim"]
