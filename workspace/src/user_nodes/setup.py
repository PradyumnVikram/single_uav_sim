from setuptools import find_packages, setup
import os


package_name = "user_nodes"


setup(
    name=package_name,
    version="0.1.0",
    packages=find_packages(exclude=["test"]),
    data_files=[
        (
            "share/ament_index/resource_index/packages",
            [os.path.join("resource", package_name)],
        ),
        (os.path.join("share", package_name), ["package.xml"]),
    ],
    install_requires=["setuptools"],
    zip_safe=True,
    maintainer="Codex",
    maintainer_email="codex@example.com",
    description="Example overlay workspace package for your own ROS 2 nodes.",
    license="MIT",
    tests_require=["pytest"],
    entry_points={
        "console_scripts": [
            "heartbeat = user_nodes.heartbeat:main",
        ],
    },
)

