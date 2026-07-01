# Imagem NGC da NVIDIA: TensorFlow otimizado com CUDA 12.8 (suporte a Blackwell / RTX 50).
# Ultima release TF da NVIDIA (descontinuada dps da 25.02) e a que roda na RTX 5060 (sm_120).
FROM nvcr.io/nvidia/tensorflow:25.02-tf2-py3

# Define o dir de trabalho dentro do contêiner
WORKDIR /tf

# Java 17 (o Spark 3.5.0 suporta oficialmente Java 8/11/17). O `default-jre` da imagem
# (Ubuntu 24.04) puxava Java 21, incompativel com o Arrow do PySpark
# (erro: "sun.misc.Unsafe or java.nio.DirectByteBuffer.<init>(long, int) not available").
RUN apt-get update && apt-get install -y openjdk-17-jre-headless && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Copia nosso arquivo de requisitos para dentro do contêiner
COPY requirements.txt /tmp/

# Instala PySpark e ferramentas de monitoramento.
# IMPORTANTE: não instalar tensorflow aqui usamos o TF otimizado que já vem na imagem da nvidiea.
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# A imagem NGC não inicia o Jupyter sozinha (cai no bash). Subimos o JupyterLab manualmente.
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''", "--notebook-dir=/tf"]