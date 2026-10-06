# Dockerfile do Simulador de Cartões de Crédito
# Usado no Laboratório de Segurança em Kubernetes (Minikube).
#
# Este Dockerfile segue boas práticas básicas de construção de imagem
# (usuário não-root, imagem slim, dependências fixadas) porque o foco
# deste laboratório é o hardening da CAMADA DE KUBERNETES — RBAC,
# Network Policies, Pod Security e Secrets — não da imagem em si.
# O código da aplicação, propositalmente, continua com as
# vulnerabilidades estudadas nos laboratórios de SonarQube e Semgrep.

FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN apt-get update \
        && apt-get upgrade -y \
        && pip install --no-cache-dir -r requirements.txt \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY . .

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser \
    && chown -R appuser:appgroup /app
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
