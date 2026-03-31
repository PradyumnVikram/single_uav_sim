import rclpy
from rclpy.node import Node


class HeartbeatNode(Node):
    def __init__(self) -> None:
        super().__init__("heartbeat")
        self.counter = 0
        self.timer = self.create_timer(1.0, self.on_timer)

    def on_timer(self) -> None:
        self.counter += 1
        self.get_logger().info(f"overlay workspace node alive: tick={self.counter}")


def main() -> None:
    rclpy.init()
    node = HeartbeatNode()
    try:
        rclpy.spin(node)
    finally:
        node.destroy_node()
        rclpy.shutdown()

