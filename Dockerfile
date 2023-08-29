FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

SHELL ["/bin/bash", "-ec"]

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

RUN apt install software-properties-common -y
#RUN add-apt-repository "ppa:deadsnakes/ppa"
RUN apt install python3 -y
RUN apt install python3-pip -y
RUN apt install git vim -y
#RUN ln -sf /usr/bin/python3.11 /usr/bin/python
RUN python3 -v

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip install --pre --force-reinstall mlc-ai-nightly-cu121 mlc-chat-nightly-cu121 -f https://mlc.ai/wheels

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1

WORKDIR /app
RUN python3 -c "from mlc_chat import ChatModule; print(ChatModule)"
RUN apt-get install git-lfs -y
RUN git lfs install
RUN mkdir -p dist/prebuilt
RUN git clone https://github.com/mlc-ai/binary-mlc-llm-libs.git dist/prebuilt/lib

WORKDIR  /app/dist/prebuilt
RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN mv /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so.1.bak
#RUN git lfs clone https://huggingface.co/mlc-ai/mlc-chat-Llama-2-7b-chat-hf-q4f16_1
#RUN git lfs clone https://huggingface.co/mlc-ai/mlc-chat-FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1
#RUN git lfs clone https://huggingface.co/mlc-ai/mlc-chat-FlagAlpha-Llama2-Chinese-7b-Chat-q4f32_1
COPY chat.py /app/test.py

WORKDIR /app
CMD python -m mlc_chat.rest --model FlagAlpha-Llama2-Chinese-7b-Chat-q4f16_1  --host 0.0.0.0 --port 8000
