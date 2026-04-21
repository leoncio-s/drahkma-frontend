# Drahkma Frontend 🪙

O **Drahkma** é uma plataforma voltada para gestão financeira. O projeto utiliza uma arquitetura robusta e escalável para garantir performance na web;

## 🚀 Tecnologias e Arquitetura

Este projeto foi construído seguindo os princípios da **Clean Architecture**, dividindo as responsabilidades em camadas:
- **Data:** Implementações de repositórios e fontes de dados externas.
- **Domain:** Entidades de negócio e UseCases (Regras de negócio puras).
- **Presentation:** UI Widgets, Controllers e State Management (ValueNotifier/GetIt).

### Core Stack:
- **Flutter** (Framework principal)
- **GetIt** (Injeção de dependência)
- **Dio** (Consumo de APIs)
- **Clean Architecture** (Padrão de projeto)

---

## 📱 Plataformas Suportadas

O projeto foi otimizado para rodar em:

- **Web:** (Chrome, Edge, Safari e Firefox) - *Otimizado para resoluções Desktop e Mobile.*

---

## 🛠️ Como Buildar o Projeto

Antes de começar, certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na sua máquina (versão estável recomendada).

### 1. Clonando o Repositório
```bash
git clone [https://github.com/leoncio-s/drahkma-frontend.git](https://github.com/leoncio-s/drahkma-frontend.git)

cd drahkma-frontend
```

### 2. Instalando Dependências
```bash
flutter pub get
```


### 3. Gerando Builds para WEB
```bash
flutter build web --release -o --build-number="<VERSION>" --base-href="/frontend/" -O 4
```
---

## 👥 Contribuição
1. Crie uma branch para sua feature (git checkout -b feature/nova-feature)

2. Commit suas mudanças (git commit -m 'Add: nova funcionalidade')

3. Push para a branch (git push origin feature/nova-feature)

4. Abra um Pull Request

---
Desenvolvido por [Léo](https://github.com/leoncio-s) 🚀