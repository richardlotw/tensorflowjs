#!/bin/bash



tensorflow_model_server --port=8500 --rest_api_port="${PORT}" --model_config_file="${MODEL_CONFIG_FILE}"  "$@"


