# Imagem NGC da NVIDIA: TensorFlow otimizado com CUDA 12.8 (suporte a Blackwell / RTX 50).
# Ultima release TF da NVIDIA (descontinuada dps da 25.02) e a que roda na RTX 5060 (sm_120).
FROM nvcr.io/nvidia/tensorflow:25.02-tf2-py3

# Define o dir de trabalho dentro do contêiner
WORKDIR /tf

# Instala o Java (Para o Spark funcionar)
RUN apt-get update && apt-get install -y default-jre && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia nosso arquivo de requisitos para dentro do contêiner
COPY requirements.txt /tmp/

# Instala PySpark e ferramentas de monitoramento.
# IMPORTANTE: não instalar tensorflow aqui usamos o TF otimizado que já vem na imagem da nvidiea.
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# A imagem NGC não inicia o Jupyter sozinha (cai no bash). Subimos o JupyterLab manualmente.
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''", "--notebook-dir=/tf"]