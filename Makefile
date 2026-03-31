RUNTIME ?= docker
IMAGE ?= single-drone-sim:latest
CONT_NAME ?= single-drone-sim
RUN_SCRIPT := scripts/run_gui_$(RUNTIME).sh

.PHONY: attach build shell overlay-build sim exec stop demo-node help

help:
	@echo "build         Build the simulation image"
	@echo "shell         Start an interactive shell with the overlay workspace mounted"
	@echo "overlay-build Build packages in ./workspace inside the container"
	@echo "sim           Start the single-drone simulation in a named container"
	@echo "attach        Attach to the tmux session in the running simulation container"
	@echo "exec          Open another shell in the running simulation container"
	@echo "stop          Stop and remove the named simulation container"
	@echo "demo-node     Run the sample overlay node inside the running container"

build:
	$(RUNTIME) build -t $(IMAGE) .

shell:bIR="$(PWD)/workspace" ./$(RUN_SCRIPT) $(IMAGE) bash

overlay-build:
	WORKSPACE_DIR="$(PWD)/workspace" ./$(RUN_SCRIPT) $(IMAGE) bash -lc "source /opt/ros/$$ROS_DISTRO/setup.bash && source /opt/sim_ws/install/setup.bash && cd /workspace && colcon build --symlink-install"

sim:
	CONT_NAME=$(CONT_NAME) KEEP_CONTAINER=1 WORKSPACE_DIR="$(PWD)/workspace" ./$(RUN_SCRIPT) $(IMAGE)

attach:
	$(RUNTIME) exec -it $(CONT_NAME) tmux attach -t sim

exec:
	$(RUNTIME) exec -it $(CONT_NAME) bash

stop:
	-$(RUNTIME) stop $(CONT_NAME)
	-$(RUNTIME) rm $(CONT_NAME)

demo-node:
	$(RUNTIME) exec -it $(CONT_NAME) bash -lc "source /opt/sim_ws/install/setup.bash && if [ -f /workspace/install/setup.bash ]; then source /workspace/install/setup.bash; fi && ros2 run user_nodes heartbeat"
