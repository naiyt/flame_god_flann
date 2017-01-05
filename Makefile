bundle: set-config
	bundle install

set-config:
	bundle config build.ruby-opencv --with-opencv-dir=/usr/local/Cellar/opencv/2.4.13.2
