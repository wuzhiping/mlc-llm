#docker build -t shawoo/mlc-llm
docker run --rm -it --gpus=all \
           -v $PWD/models/mlc-chat-FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1:/app/dist/prebuilt/mlc-chat-FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1 \
           -p 8000:8000 \
	   shawoo/mlc-llm 
