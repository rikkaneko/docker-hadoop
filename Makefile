DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_version := 2.0.0-hadoop3.2.1-java8
build:
	podman build -t bde2020/hadoop-base:$(current_version) ./base
	podman build -t bde2020/hadoop-namenode:$(current_version) ./namenode
	podman build -t bde2020/hadoop-datanode:$(current_version) ./datanode
	podman build -t bde2020/hadoop-resourcemanager:$(current_version) ./resourcemanager
	podman build -t bde2020/hadoop-nodemanager:$(current_version) ./nodemanager
	podman build -t bde2020/hadoop-historyserver:$(current_version) ./historyserver
	podman build -t bde2020/hadoop-submit:$(current_version) ./submit

wordcount:
	podman build -t hadoop-wordcount ./submit-wordcount
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -mkdir -p /input/
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -cat /output/*
	# podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -rm -r /output
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -rm -r /input

salestatistics:
	podman build -t hadoop-statistics ./submit-statistics
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -mkdir -p /input/
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-statistics
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -cat /output/*
	# podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -rm -r /output
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -rm -r /input

clean:
	podman run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_version) hdfs dfs -rm -r /output
