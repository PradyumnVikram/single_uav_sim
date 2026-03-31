cd kamikaze/ardupilot
docker run --rm -it -v "$(pwd):/ardupilot" -u "$(id -u):$(id -g)" ardupilot:latest bash
sim_vehicle.py -v ArduCopter -f gazebo-iris --model JSON --map --console

cd kamikaze/
docker run -it --security-opt label=disable -e XDG_RUNTIME_DIR=/tmp   -e XAUTHORITY=$XAUTHORITY   -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --net host -e DISPLAY  --gpus '"all","capabilities=compute,utility,graphics"' --device=/dev/dri single-drone-sim:latest tmux
gz sim -v4 -r iris_runway.sdf


