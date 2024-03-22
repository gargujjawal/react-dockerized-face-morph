FROM gobletsky/bionic-opencv-3.4.1:with-dlib-19.13

MAINTAINER Ujjawal Garg <ujjawal.1224@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install nodejs Gallium
RUN apt-get update && apt-get -y install curl \
	&& curl -sL https://deb.nodesource.com/setup_16.x | bash \
	&& apt-get install -y nodejs build-essential

RUN npm i npm@8.19.4 -g

# Create app directory
WORKDIR /usr/src/app

COPY ./py_face_morph/requirements.txt ./py_face_morph/requirements.txt

RUN source /usr/local/bin/virtualenvwrapper.sh \
	&& workon cv \
	&& pip install -r py_face_morph/requirements.txt

COPY package*.json ./

RUN npm install --no-optional

RUN apt-get -y install ffmpeg

# Bundle app source
COPY . .

EXPOSE 8080

ENV NODE_ENV production
ENV PORT 8080
ENV HOST 0.0.0.0

RUN npm run build

CMD [ "npm", "start" ]
